param foo string = bar
param bar string = 'baz'

var fizz = foo

resource storage 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: 'test${fizz}${resourceGroup().id}${subscription().id}'

  resource blobServices 'blobServices' existing = {
    name: 'default'

    resource container 'containers' existing = {
      name: uniqueString(resourceGroup().id, fizz)
    }
  }
}

resource dbs 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing = [for i in range(0, 3): {
  name: 'db${i}'
}]

output storage resource = storage
output container resource = storage::blobServices::container
output db1 resource = dbs[1]
output dbs resource = [for i in range(0, 3): dbs[i]]
