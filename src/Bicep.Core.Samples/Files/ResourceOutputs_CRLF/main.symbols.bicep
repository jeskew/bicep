targetScope = 'tenant'

param modSubId string
//@[06:14) Parameter modSubId. Type: string. Declaration start char: 0, length: 21
param modRgName string
//@[06:15) Parameter modRgName. Type: string. Declaration start char: 0, length: 22
param otherSubId string
//@[06:16) Parameter otherSubId. Type: string. Declaration start char: 0, length: 23

module mod './modulea.bicep' = {
//@[07:10) Module mod. Type: module. Declaration start char: 0, length: 141
    name: 'test'
    scope: resourceGroup(modSubId, modRgName)
    params: {
       foo: 'bar'
    }
}

module otherMod './moduleb.bicep' = {
//@[07:15) Module otherMod. Type: module. Declaration start char: 0, length: 159
    name: 'test2'
    scope: resourceGroup(modSubId, modRgName)
    params: {
       p: mod.outputs.storage
    }
}

module xMgMod './modulec.bicep' = {
//@[07:13) Module xMgMod. Type: module. Declaration start char: 0, length: 99
    name: 'anotherTest'
    scope: managementGroup('myMg')
}

module arrayMod './modulea.bicep' = [for i in range(0, 10): {
//@[41:42) Local i. Type: int. Declaration start char: 41, length: 1
//@[07:15) Module arrayMod. Type: module[]. Declaration start char: 0, length: 170
  name: 'test${i}'
  scope: resourceGroup(otherSubId, modRgName)
  params: {
    foo: 'baz${i}'
  }
}]

output id string = mod.outputs.storage.id
//@[07:09) Output id. Type: string. Declaration start char: 0, length: 41
output name string = mod.outputs.storage.name
//@[07:11) Output name. Type: string. Declaration start char: 0, length: 45
output type string = mod.outputs.storage.type
//@[07:11) Output type. Type: string. Declaration start char: 0, length: 45
output apiVersion string = mod.outputs.storage.apiVersion
//@[07:17) Output apiVersion. Type: string. Declaration start char: 0, length: 57
output accessTier string = mod.outputs.storage.properties.accessTier
//@[07:17) Output accessTier. Type: string. Declaration start char: 0, length: 68
output publicAccess string = mod.outputs.container.properties.publicAccess
//@[07:19) Output publicAccess. Type: string. Declaration start char: 0, length: 74
output db1FreeTier bool = mod.outputs.db1.properties.enableFreeTier
//@[07:18) Output db1FreeTier. Type: bool. Declaration start char: 0, length: 67
output dbsFreeTier array = [for i in range(0, 3): mod.outputs.dbs[i].properties.enableFreeTier]
//@[32:33) Local i. Type: int. Declaration start char: 32, length: 1
//@[07:18) Output dbsFreeTier. Type: array. Declaration start char: 0, length: 95

output indirectionAccessTier string = otherMod.outputs.storage.properties.accessTier
//@[07:28) Output indirectionAccessTier. Type: string. Declaration start char: 0, length: 84

output policyType string = xMgMod.outputs.policy.properties.policyType
//@[07:17) Output policyType. Type: string. Declaration start char: 0, length: 70

output id9 string = arrayMod[9].outputs.storage.id
//@[07:10) Output id9. Type: string. Declaration start char: 0, length: 50
output publicAccess9 string = arrayMod[9].outputs.container.properties.publicAccess
//@[07:20) Output publicAccess9. Type: string. Declaration start char: 0, length: 83
output dbs9FreeTier array = [for i in range(0, 3): arrayMod[9].outputs.dbs[i].properties.enableFreeTier]
//@[33:34) Local i. Type: int. Declaration start char: 33, length: 1
//@[07:19) Output dbs9FreeTier. Type: array. Declaration start char: 0, length: 104

