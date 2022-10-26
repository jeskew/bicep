targetScope = 'managementGroup'

param snap string = crackle
param crackle string = 'pop'

resource policy 'Microsoft.Authorization/policyDefinitions@2020-09-01' existing = {
  name: guid(managementGroup().name, managementGroup().properties.tenantId, snap)
}

output policy resource = policy
