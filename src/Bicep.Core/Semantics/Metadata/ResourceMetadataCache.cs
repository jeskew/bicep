// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Runtime.CompilerServices;
using Azure.Deployments.Expression.Expressions;
using Azure.Deployments.Core.Definitions.Schema;
using Bicep.Core.Diagnostics;
using Bicep.Core.Emit;
using Bicep.Core.Extensions;
using Bicep.Core.Syntax;
using Bicep.Core.TypeSystem;
using Bicep.Core.TypeSystem.Az;
using Microsoft.WindowsAzure.ResourceStack.Common.Extensions;
using Newtonsoft.Json.Linq;

namespace Bicep.Core.Semantics.Metadata
{
    public class ResourceMetadataCache : SyntaxMetadataCacheBase<ResourceMetadata?>
    {
        private readonly SemanticModel semanticModel;
        private readonly Lazy<ImmutableDictionary<ModuleSymbol, ScopeHelper.ScopeData>> moduleScopeData;
        private readonly Lazy<ImmutableDictionary<ResourceDeclarationSyntax, ResourceSymbol>> resourceSymbols;
        private readonly ConcurrentDictionary<(ModuleSymbol module, string output), ResourceMetadata> moduleOutputLookup;

        public ResourceMetadataCache(SemanticModel semanticModel)
        {
            this.semanticModel = semanticModel;
            this.moduleScopeData = new(() => ScopeHelper.GetModuleScopeInfo(semanticModel, ToListDiagnosticWriter.Create()));
            this.resourceSymbols = new(() => ResourceSymbolVisitor.GetAllResources(semanticModel.Root)
                .ToImmutableDictionary(x => x.DeclaringResource));

            this.moduleOutputLookup = new();
        }

        // NOTE: modules can declare outputs with resource types. This means one piece of syntax (the module)
        // can declare multiple ResourceMetadata. We have this separate code path to 'load' these because
        // the discovery is driven by semantics not syntax.
        public ResourceMetadata? TryAdd(ModuleSymbol module, string output)
        {
            if (module.TryGetBodyPropertyValue(AzResourceTypeProvider.ResourceNamePropertyName) is {} moduleNameSyntax &&
                module.TryGetBodyObjectType() is ObjectType objectType &&
                objectType.Properties.TryGetValue(LanguageConstants.ModuleOutputsPropertyName, out var outputsProperty) &&
                outputsProperty.TypeReference.Type is ObjectType outputsType &&
                outputsType.Properties.TryGetValue(output, out var property))
            {
                if (property.TypeReference.Type is ResourceType resourceType)
                {
                    if (module.TryGetSemanticModel(out var moduleModel, out var diagnostics))
                    {
                        ResourceMetadata metadata = moduleModel switch
                        {
                            SemanticModel bicepModel => new ModuleOutputResourceMetadata(resourceType, module, moduleNameSyntax, new(() => GetResourceIdExpression(module, bicepModel, moduleScopeData.Value[module], output)), output),
                            ArmTemplateSemanticModel armModel => throw new NotImplementedException(),
                            TemplateSpecSemanticModel templateSpecModel => throw new NotImplementedException(),
                            // FIXME: new diagnostic: Output {output} of module {moduleName} is of a resource type, but the module's semantic model type was not recognized. 
                            _ => new ErrorResourceMetadata(resourceType, ImmutableArray.Create(DiagnosticBuilder.ForPosition(module.DeclaringModule.Path).ReferencedModuleHasErrors())),
                        };
                        moduleOutputLookup.TryAdd((module, output), metadata);
                        return metadata;
                    }
                    throw new InvalidOperationException();
                }
            }

            return null;
        }

        private ResourceIdExpression GetResourceIdExpression(ModuleSymbol module, SemanticModel moduleModel, ScopeHelper.ScopeData moduleScope, string outputName)
        {
            if (moduleModel.Binder.FileSymbol.OutputDeclarations.Where(os => os.Name == outputName).FirstOrDefault() is { } outputSymbol)
            {
                var parentEmitterSettings = new EmitterSettings(semanticModel.Features);
                var moduleEmitterSettings = new EmitterSettings(moduleModel.Features);
                var parentContext = new EmitterContext(semanticModel, parentEmitterSettings);
                var moduleContext = new EmitterContext(moduleModel, moduleEmitterSettings);
                var parentConverter = new ExpressionConverter(parentContext);
                var moduleConverter = new ExpressionConverter(moduleContext);
                var translator = NameExpressionTranslator(parentConverter, moduleConverter, module, moduleModel, moduleScope);
                LanguageExpression translateExpression(LanguageExpression expression) => LanguageExpressionRewriter.Rewrite(expression, translator);

                try
                {
                    return ResourceIdExpression.Create(
                        moduleModel.ResourceMetadata.TryLookup(outputSymbol.Value) switch
                        {
                            DeclaredResourceMetadata declared => ScopeHelper.FormatFullyQualifiedResourceId(parentContext, 
                                parentConverter, 
                                moduleScope, 
                                declared.TypeReference.FormatType(), 
                                moduleConverter.GetResourceNameSegments(declared).Select(translateExpression)),
                            ParameterResourceMetadata parameter => GetSuppliedParameterValue(module, parameter.Symbol) is {} suppliedValue && TryLookup(suppliedValue) is {} resourceIdInParentTemplate
                                ? resourceIdInParentTemplate switch {
                                    ParameterResourceMetadata paramInParent => new FunctionExpression("parameters", 
                                        new[] { new JTokenExpression(paramInParent.Symbol.Name) }, 
                                        Array.Empty<LanguageExpression>()),
                                    DeclaredResourceMetadata declared => ScopeHelper.FormatFullyQualifiedResourceId(parentContext,
                                        parentConverter,
                                        parentContext.ResourceScopeData[declared],
                                        declared.TypeReference.FormatType(),
                                        parentConverter.GetResourceNameSegments(declared)),
                                    ModuleOutputResourceMetadata output => output.ResourceIdExpression is { Expression: {} expression }
                                        ? expression
                                        : throw new NameExpressionTranslationException("The referenced output has errors"),
                                    _ => throw new NameExpressionTranslationException("Unrecognized resource metadata type"),
                                }
                                : translateExpression(new FunctionExpression("parameters", new[] { new JTokenExpression(parameter.Symbol.Name) }, Array.Empty<LanguageExpression>())),
                            ModuleOutputResourceMetadata output => output.ResourceIdExpression is { Expression: {} expression } 
                                ? translateExpression(expression)
                                : throw new NameExpressionTranslationException("The referenced output has errors"),
                            // output.ResourceName switch {
                            //     NameSyntaxOrExpression.BicepNameSyntax bicepSyntax => NameSyntaxTranslationVisitor.TranslateNameSyntax(module, moduleModel, moduleScope, bicepSyntax.NameSegments),
                            //     NameSyntaxOrExpression.ArmTemplateNameExpression armExpression => throw new NotImplementedException(),
                            //     // FIXME: Use a different diagnostic message
                            //     NameSyntaxOrExpression.UnresolvableNameSyntax => new NameSyntaxOrExpression.UnresolvableNameSyntax(ImmutableArray.Create(DiagnosticBuilder.ForPosition(outputSymbol.DeclaringOutput.Value).InvalidResourceType())),
                            //     // FIXME: Unreachable, but use a diagnostic message
                            //     _ => throw new InvalidOperationException("Unrecognized name type"),
                            // },
                            // FIXME: Use a diagnostic message
                            _ => throw new NameExpressionTranslationException("Unrecognized resource metadata type"),
                        });
                } catch (NameExpressionTranslationException)
                {
                    // TODO where does this diagnostic get associated to? It's only an error if it would result in a double reference
                    return ResourceIdExpression.Create(ImmutableArray.Create(DiagnosticBuilder.ForDocumentStart().AnyTypeIsNotAllowed()));
                }
            }
            else
            {
                // FIXME: Use a diagnostic message
                // throw new InvalidOperationException($"Unable to locate resource output '{outputName}' in model for module '{module.Name}.'");
                    return ResourceIdExpression.Create(ImmutableArray.Create(DiagnosticBuilder.ForDocumentStart().AnyTypeIsNotAllowed()));
            }
        }

        private class NameExpressionTranslationException : InvalidOperationException
        {
            internal NameExpressionTranslationException(string message) : base(message) {}
        }

        private Func<LanguageExpression, LanguageExpression> NameExpressionTranslator(ExpressionConverter outerConverter, ExpressionConverter innerConverter, ModuleSymbol module, SemanticModel moduleModel, ScopeHelper.ScopeData scopeData)
            => expression =>
            {
                if (expression is not FunctionExpression functionExpression)
                {
                    return expression;
                }

                return functionExpression.Function switch
                {
                    "parameters" => TranslateParametersFunctionExpression(outerConverter, innerConverter, module, moduleModel, scopeData, Translate(outerConverter, innerConverter, module, moduleModel, scopeData, functionExpression.Parameters).Single()),
                    "variables" => TranslateVariablesFunctionExpression(outerConverter, innerConverter, module, moduleModel, scopeData, Translate(outerConverter, innerConverter, module, moduleModel, scopeData, functionExpression.Parameters).Single()),
                    "resourceGroup" when scopeData.ResourceGroupProperty is {} targetResourceGroup 
                        => TranslateResourceGroupFunctionExpression(() => outerConverter.ConvertExpression(targetResourceGroup),
                            scopeData.SubscriptionIdProperty is {} targetSubcriptionId ? () => outerConverter.ConvertExpression(targetSubcriptionId) : null,
                            functionExpression),
                    "subscription" when scopeData.SubscriptionIdProperty is {} targetSubscriptionId 
                        => TranslateSubscriptionFunctionExpression(() => outerConverter.ConvertExpression(targetSubscriptionId), functionExpression),
                    "managementGroup" when scopeData.ManagementGroupNameProperty is {} targetManagementGroup
                        => TranslateManagementGroupFunctionExpression(() => outerConverter.ConvertExpression(targetManagementGroup), functionExpression),
                    _ => functionExpression,
                };
            };

        // private Func<LanguageExpression, LanguageExpression> NameExpressionTranslator(ModuleSymbol module, Template armTemplate, ScopeHelper.ScopeData scopeData)
        //     => expression =>
        //     {
        //         throw new NotImplementedException();
        //     };

        private LanguageExpression[] Translate(ExpressionConverter outerConverter, ExpressionConverter innerConverter, ModuleSymbol module, SemanticModel moduleModel, ScopeHelper.ScopeData scopeData, LanguageExpression[] expressions)
            => expressions.Select(e => LanguageExpressionRewriter.Rewrite(e, NameExpressionTranslator(outerConverter, innerConverter, module, moduleModel, scopeData))).ToArray();

        private LanguageExpression TranslateParametersFunctionExpression(ExpressionConverter outerConverter, ExpressionConverter innerConverter, ModuleSymbol module, SemanticModel moduleModel, ScopeHelper.ScopeData scopeData, LanguageExpression? parameterNameExpression)
        {
            // "[parameters(parameters('bar'))]" etc. is perfectly legal and only sometimes compile-time resolvable.
            // FunctionExpressions compiled from Bicep VariableAccessSyntax nodes will never take this form, but hand-written ARM templates could definitely include such an expression.
            if (parameterNameExpression is not JTokenExpression jTokenExpression || jTokenExpression.Value is not JValue jValue || jValue.Value is not string parameterName)
            {
                throw new InvalidOperationException($"Unable to perform compile-time resolution of parameters() expression.");
            }

            if (moduleModel.Binder.FileSymbol.ParameterDeclarations.Where(ps => ps.Name == parameterName).FirstOrDefault() is { } parameter)
            {
                if (GetSuppliedParameterValue(module, parameter) is { } suppliedValue)
                {
                    return outerConverter.ConvertExpression(suppliedValue);
                }

                if (parameter.DeclaringParameter.Modifier is ParameterDefaultValueSyntax defaultValueSyntax)
                {
                    return LanguageExpressionRewriter.Rewrite(innerConverter.ConvertExpression(defaultValueSyntax.DefaultValue), NameExpressionTranslator(outerConverter, innerConverter, module, moduleModel, scopeData));
                }

                throw new InvalidOperationException($"No value found for parameter ${parameterName}.");
            }

            throw new InvalidOperationException($"Parameter {parameterName} not found.");
        }

        private static SyntaxBase? GetSuppliedParameterValue(ModuleSymbol module, ParameterSymbol parameterSymbol)
        {
            if (module.TryGetBodyPropertyValue(LanguageConstants.ModuleParamsPropertyName) is ObjectSyntax paramsObject
                && paramsObject.TryGetPropertyByName(parameterSymbol.Name) is { } suppliedValue)
            {
                return suppliedValue.Value;
            }

            return default;
        }

        private LanguageExpression TranslateVariablesFunctionExpression(ExpressionConverter outerConverter, ExpressionConverter innerConverter, ModuleSymbol module, SemanticModel moduleModel, ScopeHelper.ScopeData scopeData, LanguageExpression? variableNameExpression)
        {
            // "[variables(variables('bar'))]" etc. is perfectly legal and only sometimes compile-time resolvable.
            // FunctionExpressions compiled from Bicep VariableAccessSyntax nodes will never take this form, but hand-written ARM templates could definitely include such an expression.
            if (variableNameExpression is not JTokenExpression jTokenExpression || jTokenExpression.Value is not JValue jValue || jValue.Value is not string variableName)
            {
                throw new NameExpressionTranslationException($"Unable to perform compile-time resolution of variables() expression.");
            }

            if (moduleModel.Binder.FileSymbol.VariableDeclarations.Where(v => LanguageConstants.IdentifierComparer.Equals(v.Name, variableName)).FirstOrDefault() is VariableSymbol variableSymbol)
            {
                return LanguageExpressionRewriter.Rewrite(innerConverter.ConvertExpression(variableSymbol.Value), NameExpressionTranslator(outerConverter, innerConverter, module, moduleModel, scopeData));
            }

            throw new NameExpressionTranslationException($"Variable {variableName} not found.");
        }

        private LanguageExpression TranslateResourceGroupFunctionExpression(Func<LanguageExpression> targetResourceGroupNameConverter, Func<LanguageExpression>? targetSubscriptionIdConverter, FunctionExpression current)
        {
            if (current.Parameters.Any() || current.Properties.Length != 1 || current.Properties[0] is not JTokenExpression jTokenExpression || jTokenExpression.Value is not JValue jValue || jValue.Value is not string propertyName)
            {
                throw new NameExpressionTranslationException("Unable to perform compile-time resolution of resourceGroup() expression");
            }

            return propertyName switch
            {
                "name" => targetResourceGroupNameConverter(),
                "type" => new JTokenExpression(AzResourceTypeProvider.ResourceTypeResourceGroup),
                "id" => new FunctionExpression("format", 
                    new[] 
                    { 
                        new JTokenExpression("/subscriptions/{0}/resourceGroups/{1}"),
                        targetSubscriptionIdConverter is not null
                            ? targetSubscriptionIdConverter()
                            : new FunctionExpression("subscription", Array.Empty<LanguageExpression>(), new [] { new JTokenExpression("subscriptionId") }),
                        targetResourceGroupNameConverter(),
                    },
                    Array.Empty<LanguageExpression>()),
                string unsupportedPropertyName => throw new NameExpressionTranslationException(
                    $"A resource group's '{unsupportedPropertyName}' property cannot be calculated by ARM from outside a deployment within that resource group."),
            };
        }

        private LanguageExpression TranslateSubscriptionFunctionExpression(Func<LanguageExpression> targetSubscriptionIdConverter, FunctionExpression current)
        {
            if (current.Parameters.Any() || current.Properties.Length != 1 || current.Properties[0] is not JTokenExpression jTokenExpression || jTokenExpression.Value is not JValue jValue || jValue.Value is not string propertyName)
            {
                throw new NameExpressionTranslationException("Unable to perform compile-time resolution of subscription() expression");
            }

            return propertyName switch
            {
                "subscriptionId" => targetSubscriptionIdConverter(),
                "id" => new FunctionExpression("format", new[] { new JTokenExpression("/subscriptions/{0}" ), targetSubscriptionIdConverter() }, Array.Empty<LanguageExpression>()),
                // cross-tenant nested deployments are not a thing; dereference the current tenant
                "tenantId" => new FunctionExpression("tenant", Array.Empty<LanguageExpression>(), new[] { new JTokenExpression("tenantId") }),
                string unsupportedPropertyName => throw new NameExpressionTranslationException(
                    $"A subscription's '{unsupportedPropertyName}' property cannot be calculated by ARM from outside a deployment within that subscription."),
            };
        }

        private LanguageExpression TranslateManagementGroupFunctionExpression(Func<LanguageExpression> targetManagementGroupConverter, FunctionExpression current)
        {
            var resolutionFailedMessage = "Unable to perform compile-time resolution of managementGroup() expression";
            if (current.Parameters.Any())
            {
                throw new NameExpressionTranslationException(resolutionFailedMessage);
            }

            return current.Properties.Length switch
            {
                1 when current.Properties[0] is JTokenExpression jTokenExpression && jTokenExpression.Value is JValue { Value: string propertyName } 
                    => TranslateManagementGroupFunctionExpressionTopLevelProperty(targetManagementGroupConverter, propertyName),
                2 when current.Properties[0] is JTokenExpression firstExpression && firstExpression.Value is JValue { Value: string topLevelPropertyName } && topLevelPropertyName == "properties"
                    && current.Properties[1] is JTokenExpression secondExpression && secondExpression.Value is JValue { Value: string propertyName }
                    => TranslateManagementGroupFunctionExpressionPropertiesProperty(propertyName),
                _ => throw new NameExpressionTranslationException(resolutionFailedMessage),

            };
        }

        private LanguageExpression TranslateManagementGroupFunctionExpressionTopLevelProperty(Func<LanguageExpression> targetManagementGroupConverter, string propertyName) => propertyName switch
        {
            "name" => targetManagementGroupConverter(),
            "type" => new JTokenExpression($"/providers/{AzResourceTypeProvider.ResourceTypeManagementGroup}"),
            "id" => new FunctionExpression("format", new[] { new JTokenExpression($"/providers/{AzResourceTypeProvider.ResourceTypeManagementGroup}/{{0}}"), targetManagementGroupConverter() }, Array.Empty<LanguageExpression>()),
            _ => throw new NameExpressionTranslationException(
                $"A management group's '{propertyName}' property cannot be calculated by ARM from outside a deployment in that management group at managementGroup scope."),
        };

        private LanguageExpression TranslateManagementGroupFunctionExpressionPropertiesProperty(string propertyName) => propertyName switch
        {
            // cross-tenant nested deployments are not a thing; dereference the current tenant
            "tenantId" => new FunctionExpression("tenant", Array.Empty<LanguageExpression>(), new[] { new JTokenExpression("tenantId") }),
            _ => throw new NameExpressionTranslationException(
                $"A management group's 'properties.{propertyName}' property cannot be calculated by ARM from outside a deployment in that management group at managementGroup scope."),
        };


        private class NameSyntaxTranslationVisitor : SyntaxRewriteVisitor
        {
            private readonly List<ErrorDiagnostic> errors = new();
            private readonly ModuleSymbol module;
            private readonly SemanticModel semanticModel;
            private readonly ScopeHelper.ScopeData moduleScope;

            private NameSyntaxTranslationVisitor(ModuleSymbol module, SemanticModel semanticModel, ScopeHelper.ScopeData moduleScope)
            {
                this.module = module;
                this.semanticModel = semanticModel;
                this.moduleScope = moduleScope;
            }

            internal static NameSyntaxOrExpression TranslateNameSyntax(ModuleSymbol module, SemanticModel semanticModel, ScopeHelper.ScopeData moduleScope, IEnumerable<SyntaxBase> nameSegments)
            {
                NameSyntaxTranslationVisitor visitor = new(module, semanticModel, moduleScope);
                var translatedNameSegments = nameSegments.Select(visitor.Rewrite).ToImmutableArray();

                if (visitor.errors.Any())
                {
                    return new NameSyntaxOrExpression.UnresolvableNameSyntax(visitor.errors.ToImmutableArray());
                }

                return new NameSyntaxOrExpression.BicepNameSyntax(translatedNameSegments);
            }

            protected override SyntaxBase ReplaceForSyntax(ForSyntax syntax)
            {
                throw new NotImplementedException("I guess this would need to be translated to a map expression? Seems messy.");
            }

            protected override SyntaxBase ReplacePropertyAccessSyntax(PropertyAccessSyntax syntax)
            {
                if (syntax.BaseExpression is FunctionCallSyntax callSyntax)
                {
                    if (callSyntax.Name.IdentifierName == "resourceGroup")
                    {
                        return ReplaceResourceGroupPropertyAccess(syntax);
                    }
                    else if (callSyntax.Name.IdentifierName == "subscription")
                    {
                        return ReplaceSubscriptionPropertyAccess(syntax);
                    }
                    else if (callSyntax.Name.IdentifierName == "managementGroup")
                    {
                        return ReplaceManagementGroupPropertyAccess(syntax);
                    }
                }
                else if (syntax.BaseExpression is PropertyAccessSyntax parentProp &&
                    parentProp.BaseExpression is FunctionCallSyntax parentCall &&
                    parentCall.Name.IdentifierName == "managementGroup" &&
                    parentProp.PropertyName.IdentifierName == "properties")
                {
                    return ReplaceManagementGroupPropertiesPropertyAccess(syntax);
                }

                return base.ReplacePropertyAccessSyntax(syntax);
            }

            private SyntaxBase ReplaceResourceGroupPropertyAccess(PropertyAccessSyntax current)
            {
                if (moduleScope.ResourceGroupProperty is { } targetResourceGroup)
                {
                    return current.PropertyName.IdentifierName switch
                    {
                        "name" => targetResourceGroup,
                        "type" => SyntaxFactory.CreateStringLiteral(AzResourceTypeProvider.ResourceTypeResourceGroup),
                        "id" => SyntaxFactory.CreateString(new[] { "/subscriptions/", "/resourceGroups/", string.Empty },
                            new[] { ReplaceSubscriptionPropertyAccess(SyntaxFactory.CreatePropertyAccess(SyntaxFactory.CreateFunctionCall("subscription"), "subscriptionId")), targetResourceGroup }),
                        // FIXME: Use a diagnostic message for cross-RG module output resources whose names dereference the target RG's 'location', 'managedBy', 'tags', or 'properties' property.
                        string unsupportedPropertyName => throw new InvalidOperationException(
                            $"A resource group's '{unsupportedPropertyName}' property cannot be calculated by ARM from outside a deployment within that resource group."),
                    };
                }

                return current;
            }

            private SyntaxBase ReplaceSubscriptionPropertyAccess(PropertyAccessSyntax current)
            {
                if (moduleScope.SubscriptionIdProperty is { } targetSubscriptionId)
                {
                    return current.PropertyName.IdentifierName switch
                    {
                        "subscriptionId" => targetSubscriptionId,
                        "id" => SyntaxFactory.CreateString(new[] { "/subscriptions/", string.Empty }, new[] { targetSubscriptionId }),
                        // cross-tenant nested deployments are not a thing; dereference the current tenant
                        "tenantId" => CreateTenantIdExpressionSyntax(),
                        // FIXME: Use a diagnostic message for cross-subscription module output resources whose names dereference the target subscription's 'displayName'
                        string unsupportedPropertyName => throw new InvalidOperationException(
                            $"A subscription's '{unsupportedPropertyName}' property cannot be calculated by ARM from outside a deployment within that subscription."),
                    };
                }

                return current;
            }

            private SyntaxBase ReplaceManagementGroupPropertyAccess(PropertyAccessSyntax current)
            {
                if (moduleScope.ManagementGroupNameProperty is { } targetManagementGroup)
                {
                    return current.PropertyName.IdentifierName switch
                    {
                        "name" => targetManagementGroup,
                        "type" => SyntaxFactory.CreateStringLiteral($"/providers/{AzResourceTypeProvider.ResourceTypeManagementGroup}"),
                        "id" => SyntaxFactory.CreateString(new[] { $"/providers/{AzResourceTypeProvider.ResourceTypeManagementGroup}", string.Empty }, new[] { targetManagementGroup }),
                        // FIXME: Use a diagnostic message for cross-MG module output resources whose names dereference unknown properties from the target MG.
                        string unsupportedPropertyName => throw new InvalidOperationException(
                            $"A management group's '{unsupportedPropertyName}' property cannot be calculated by ARM from outside a deployment in that management group at managementGroup scope."),
                    };
                }

                return current;
            }

            private SyntaxBase ReplaceManagementGroupPropertiesPropertyAccess(PropertyAccessSyntax current)
            {
                if (moduleScope.ManagementGroupNameProperty is { } _targetManagementGroup)
                {
                    return current.PropertyName.IdentifierName switch
                    {
                        "tenantId" => CreateTenantIdExpressionSyntax(),
                        // FIXME: Use a diagnostic message for cross-MG module output resources whose names dereference the target MG's 'properties.details' or 'properties.displayName' property.
                        string unsupportedPropertyName => throw new InvalidOperationException(
                            $"A management group's 'properties.{unsupportedPropertyName}' property cannot be calculated by ARM from outside a deployment in that management group at managementGroup scope."),
                    };
                }

                return current;
            }

            private SyntaxBase CreateTenantIdExpressionSyntax() => SyntaxFactory.CreatePropertyAccess(SyntaxFactory.CreateFunctionCall("tenant"), "tenantId");

            protected override SyntaxBase ReplaceVariableAccessSyntax(VariableAccessSyntax syntax)
                => semanticModel.GetSymbolInfo(syntax) switch
                {
                    ParameterSymbol parameter => ReplaceVariableAccessSyntax(syntax, parameter),
                    VariableSymbol variable => Rewrite(variable.Value),
                    // FIXME: Use a diagnostic message
                    Symbol unsupportedSymbol => throw new InvalidOperationException($"Cannot replace symbols of kind '{unsupportedSymbol.Kind}'"),
                    // FIXME: Use a diagnostic message
                    _ => throw new InvalidOperationException($"Invalid or missing symbol '{syntax.Name.IdentifierName}'"),
                };

            private SyntaxBase ReplaceVariableAccessSyntax(VariableAccessSyntax syntax, ParameterSymbol parameterSymbol)
            {
                if (module.TryGetBodyPropertyValue(LanguageConstants.ModuleParamsPropertyName) is ObjectSyntax paramsObject
                    && paramsObject.TryGetPropertyByName(parameterSymbol.Name) is { } suppliedValue)
                {
                    return suppliedValue.Value;
                }

                if (parameterSymbol.DeclaringParameter.Modifier is ParameterDefaultValueSyntax defaultValueSyntax)
                {
                    return Rewrite(defaultValueSyntax.DefaultValue);
                }

                // FIXME: Use a diagnostic message
                throw new InvalidOperationException($"No value was supplied for required parameter '{syntax.Name.IdentifierName}'");
            }
        }

        protected override ResourceMetadata? Calculate(SyntaxBase syntax)
        {
            RuntimeHelpers.EnsureSufficientExecutionStack();

            switch (syntax)
            {
                case ResourceAccessSyntax _:
                case VariableAccessSyntax _:
                    {
                        var symbol = semanticModel.GetSymbolInfo(syntax);
                        if (symbol is DeclaredSymbol declaredSymbol && semanticModel.Binder.TryGetCycle(declaredSymbol) is null)
                        {
                            return this.TryLookup(declaredSymbol.DeclaringSyntax);
                        }

                    break;
                }
                case ParameterDeclarationSyntax parameterDeclarationSyntax:
                {
                    var symbol = semanticModel.GetSymbolInfo(parameterDeclarationSyntax);
                    if (symbol is ParameterSymbol parameterSymbol && parameterSymbol.Type is ResourceType resourceType)
                    {
                        return new ParameterResourceMetadata(resourceType, parameterSymbol);
                    }
                    break;
                }
                case PropertyAccessSyntax propertyAccessSyntax when IsModuleScalarOutputAccess(propertyAccessSyntax, out var module):
                {
                    // Access to a module output might be a resource metadata.
                    return this.TryAdd(module, propertyAccessSyntax.PropertyName.IdentifierName);
                }
                case PropertyAccessSyntax propertyAccessSyntax when IsModuleArrayOutputAccess(propertyAccessSyntax, out var module):
                {
                    // Access to a module array output might be a resource metadata.
                    return this.TryAdd(module, propertyAccessSyntax.PropertyName.IdentifierName);
                }
                case ResourceDeclarationSyntax resourceDeclarationSyntax:
                    {
                        // Skip analysis for ErrorSymbol and similar cases, these are invalid cases, and won't be emitted.
                        if (!resourceSymbols.Value.TryGetValue(resourceDeclarationSyntax, out var symbol) ||
                            symbol.TryGetResourceType() is not { } resourceType)
                        {
                            break;
                        }

                        if (semanticModel.Binder.TryGetCycle(symbol) is not null)
                        {
                            break;
                        }

                        if (semanticModel.Binder.GetNearestAncestor<ResourceDeclarationSyntax>(syntax) is { } nestedParentSyntax)
                        {
                            // nested resource parent syntax
                            if (TryLookup(nestedParentSyntax) is { } parentMetadata)
                            {
                                return new DeclaredResourceMetadata(
                                    resourceType,
                                    symbol.DeclaringResource.IsExistingResource(),
                                    symbol,
                                    new(parentMetadata, null, true));
                            }
                        }
                        else if (symbol.TryGetBodyPropertyValue(LanguageConstants.ResourceParentPropertyName) is { } referenceParentSyntax)
                        {
                            SyntaxBase? indexExpression = null;
                            if (referenceParentSyntax is ArrayAccessSyntax arrayAccess)
                            {
                                referenceParentSyntax = arrayAccess.BaseExpression;
                                indexExpression = arrayAccess.IndexExpression;
                            }

                            // parent property reference syntax
                            if (TryLookup(referenceParentSyntax) is { } parentMetadata)
                            {
                                return new DeclaredResourceMetadata(
                                    resourceType,
                                    symbol.DeclaringResource.IsExistingResource(),
                                    symbol,
                                    new(parentMetadata, indexExpression, false));
                            }
                        }
                        else
                        {
                            return new DeclaredResourceMetadata(
                                resourceType,
                                symbol.DeclaringResource.IsExistingResource(),
                                symbol,
                                null);
                        }

                        break;
                    }
                case VariableDeclarationSyntax variableDeclarationSyntax:
                    return this.TryLookup(variableDeclarationSyntax.Value);
            }

            return null;
        }

        private bool IsModuleScalarOutputAccess(PropertyAccessSyntax propertyAccessSyntax, [NotNullWhen(true)] out ModuleSymbol? symbol)
        {
            if (propertyAccessSyntax.BaseExpression is PropertyAccessSyntax childPropertyAccess &&
                childPropertyAccess.PropertyName.IdentifierName == LanguageConstants.ModuleOutputsPropertyName &&
                childPropertyAccess.BaseExpression is VariableAccessSyntax grandChildAccess &&
                this.semanticModel.GetSymbolInfo(grandChildAccess) is ModuleSymbol module &&
                module.TryGetBodyPropertyValue(AzResourceTypeProvider.ResourceNamePropertyName) is {} name)
            {
                symbol = module;
                return true;
            }

            symbol = null;
            return false;
        }

        private bool IsModuleArrayOutputAccess(PropertyAccessSyntax propertyAccessSyntax, [NotNullWhen(true)] out ModuleSymbol? symbol)
        {
            if (propertyAccessSyntax.BaseExpression is PropertyAccessSyntax childPropertyAccess &&
                childPropertyAccess.PropertyName.IdentifierName == LanguageConstants.ModuleOutputsPropertyName &&
                childPropertyAccess.BaseExpression is ArrayAccessSyntax arrayAccessSyntax &&
                arrayAccessSyntax.BaseExpression is  VariableAccessSyntax grandChildAccess &&
                this.semanticModel.GetSymbolInfo(grandChildAccess) is ModuleSymbol module &&
                module.TryGetBodyPropertyValue(AzResourceTypeProvider.ResourceNamePropertyName) is {} name)
            {
                symbol = module;
                return true;
            }

            symbol = null;
            return false;
        }
    }
}
