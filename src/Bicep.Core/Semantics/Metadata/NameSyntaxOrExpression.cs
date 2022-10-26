// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using System.Collections.Immutable;
using Azure.Deployments.Expression.Expressions;
using Bicep.Core.Diagnostics;
using Bicep.Core.Syntax;

namespace Bicep.Core.Semantics.Metadata;

public abstract record NameSyntaxOrExpression
{
    private NameSyntaxOrExpression() {}

    public sealed record BicepNameSyntax(ImmutableArray<SyntaxBase> NameSegments) : NameSyntaxOrExpression { }

    public sealed record ArmTemplateNameExpression(ImmutableArray<LanguageExpression> NameSegments) : NameSyntaxOrExpression { }

    public sealed record UnresolvableNameSyntax(ImmutableArray<ErrorDiagnostic> Errors) : NameSyntaxOrExpression { }
}
