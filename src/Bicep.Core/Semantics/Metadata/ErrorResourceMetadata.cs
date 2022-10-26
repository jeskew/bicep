// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
using System.Collections.Generic;
using System.Collections.Immutable;
using Bicep.Core.Diagnostics;
using Bicep.Core.TypeSystem;

namespace Bicep.Core.Semantics.Metadata;

// Represents a resource that could not be resolved due to load/parse errors
public record ErrorResourceMetadata(ResourceType Type, ImmutableArray<ErrorDiagnostic> Errors)
    : ResourceMetadata(Type, IsExistingResource: true)
{
    public override IEnumerable<IDiagnostic> Diagnostics => Errors;
}
