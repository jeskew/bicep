// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
using System;
using System.Collections.Generic;
using Bicep.Core.Diagnostics;
using Bicep.Core.Syntax;
using Bicep.Core.TypeSystem;

namespace Bicep.Core.Semantics.Metadata
{
    // Represents a resource that is declared as a parameter in Bicep.
    public record ModuleOutputResourceMetadata(
        ResourceType Type,
        ModuleSymbol Module,
        SyntaxBase ModuleNameSyntax,
        Lazy<ResourceIdExpression> ResourceIdExpressionLazy,
        string OutputName)
        : ResourceMetadata(Type, IsExistingResource: true)
    {
        public ResourceIdExpression ResourceIdExpression => ResourceIdExpressionLazy.Value;

        public override IEnumerable<IDiagnostic> Diagnostics => ResourceIdExpression is { Errors: {} errors } ? errors : base.Diagnostics;
    }
}
