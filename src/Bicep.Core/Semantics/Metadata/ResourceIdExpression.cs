// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using System.Collections.Immutable;
using Azure.Deployments.Expression.Expressions;
using Bicep.Core.Diagnostics;

namespace Bicep.Core.Semantics.Metadata;

/// <summary>
/// Represents the expression that evaluates to a module output resource's ID within the parent template.
/// </summary>
public class ResourceIdExpression
{
    // My kingdom for an Either<TResult, TError> type
    private ResourceIdExpression(LanguageExpression? expression, ImmutableArray<ErrorDiagnostic>? errors)
    {
        Expression = expression;
        Errors = errors;
    }

    public LanguageExpression? Expression { get; }

    public ImmutableArray<ErrorDiagnostic>? Errors { get; }

    public static ResourceIdExpression Create(LanguageExpression expression) => new(expression, null);

    public static ResourceIdExpression Create(ImmutableArray<ErrorDiagnostic> errors) => new(null, errors);
}
