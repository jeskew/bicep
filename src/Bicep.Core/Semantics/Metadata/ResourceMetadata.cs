// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
using System.Collections.Generic;
using System.Linq;
using Bicep.Core.Diagnostics;
using Bicep.Core.Resources;
using Bicep.Core.TypeSystem;
using Bicep.Core.Semantics.Namespaces;

namespace Bicep.Core.Semantics.Metadata
{
    // Represents a logical resource, regardless of how it was declared.
    public record ResourceMetadata(
        ResourceType Type,
        bool IsExistingResource)
    {
        public ResourceTypeReference TypeReference => Type.TypeReference;

        public bool IsAzResource => Type.DeclaringNamespace.ProviderNameEquals(AzNamespaceType.BuiltInName);

        public virtual IEnumerable<IDiagnostic> Diagnostics => Enumerable.Empty<IDiagnostic>();
    }
}
