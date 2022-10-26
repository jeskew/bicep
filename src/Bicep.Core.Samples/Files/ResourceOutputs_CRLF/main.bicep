targetScope = 'tenant'

param modSubId string
param modRgName string
param otherSubId string

module mod './modulea.bicep' = {
    name: 'test'
    scope: resourceGroup(modSubId, modRgName)
    params: {
       foo: 'bar'
    }
}

module otherMod './moduleb.bicep' = {
    name: 'test2'
    scope: resourceGroup(modSubId, modRgName)
    params: {
       p: mod.outputs.storage
    }
}

module xMgMod './modulec.bicep' = {
    name: 'anotherTest'
    scope: managementGroup('myMg')
}

module arrayMod './modulea.bicep' = [for i in range(0, 10): {
  name: 'test${i}'
  scope: resourceGroup(otherSubId, modRgName)
  params: {
    foo: 'baz${i}'
  }
}]

output id string = mod.outputs.storage.id
output name string = mod.outputs.storage.name
output type string = mod.outputs.storage.type
output apiVersion string = mod.outputs.storage.apiVersion
output accessTier string = mod.outputs.storage.properties.accessTier
output publicAccess string = mod.outputs.container.properties.publicAccess
output db1FreeTier bool = mod.outputs.db1.properties.enableFreeTier
output dbsFreeTier array = [for i in range(0, 3): mod.outputs.dbs[i].properties.enableFreeTier]

output indirectionAccessTier string = otherMod.outputs.storage.properties.accessTier

output policyType string = xMgMod.outputs.policy.properties.policyType

output id9 string = arrayMod[9].outputs.storage.id
output publicAccess9 string = arrayMod[9].outputs.container.properties.publicAccess
output dbs9FreeTier array = [for i in range(0, 3): arrayMod[9].outputs.dbs[i].properties.enableFreeTier]
