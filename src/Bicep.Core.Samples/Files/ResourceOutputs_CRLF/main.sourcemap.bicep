targetScope = 'tenant'

param modSubId string
//@[11:13]     "modSubId": {
param modRgName string
//@[14:16]     "modRgName": {
param otherSubId string
//@[17:19]     "otherSubId": {

module mod './modulea.bicep' = {
//@[22:80]       "type": "Microsoft.Resources/deployments",
    name: 'test'
//@[25:25]       "name": "test",
    scope: resourceGroup(modSubId, modRgName)
    params: {
       foo: 'bar'
//@[35:35]             "value": "bar"
    }
}

module otherMod './moduleb.bicep' = {
//@[81:130]       "type": "Microsoft.Resources/deployments",
    name: 'test2'
//@[84:84]       "name": "test2",
    scope: resourceGroup(modSubId, modRgName)
    params: {
       p: mod.outputs.storage
//@[94:94]             "value": "[reference(extensionResourceId(format('/subscriptions/{0}/resourceGroups/{1}', parameters('modSubId'), parameters('modRgName')), 'Microsoft.Resources/deployments', 'test'), '2020-10-01').outputs.storage.value]"
    }
}

module xMgMod './modulec.bicep' = {
//@[131:174]       "type": "Microsoft.Resources/deployments",
    name: 'anotherTest'
//@[134:134]       "name": "anotherTest",
    scope: managementGroup('myMg')
}

module arrayMod './modulea.bicep' = [for i in range(0, 10): {
//@[175:237]       "copy": {
  name: 'test${i}'
//@[182:182]       "name": "[format('test{0}', range(0, 10)[copyIndex()])]",
  scope: resourceGroup(otherSubId, modRgName)
  params: {
    foo: 'baz${i}'
//@[192:192]             "value": "[format('baz{0}', range(0, 10)[copyIndex()])]"
  }
}]

output id string = mod.outputs.storage.id
//@[240:243]     "id": {
output name string = mod.outputs.storage.name
//@[244:247]     "name": {
output type string = mod.outputs.storage.type
//@[248:251]     "type": {
output apiVersion string = mod.outputs.storage.apiVersion
//@[252:255]     "apiVersion": {
output accessTier string = mod.outputs.storage.properties.accessTier
//@[256:259]     "accessTier": {
output publicAccess string = mod.outputs.container.properties.publicAccess
//@[260:263]     "publicAccess": {

output indirectionAccessTier string = otherMod.outputs.storage.properties.accessTier
//@[264:267]     "indirectionAccessTier": {

output policyType string = xMgMod.outputs.policy.properties.policyType
//@[268:271]     "policyType": {

output id9 string = arrayMod[9].outputs.storage.id
//@[272:275]     "id9": {
output publicAccess9 string = arrayMod[9].outputs.container.properties.publicAccess
//@[276:279]     "publicAccess9": {

