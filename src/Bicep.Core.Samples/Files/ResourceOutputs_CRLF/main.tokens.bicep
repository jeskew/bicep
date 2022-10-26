targetScope = 'tenant'
//@[000:011) Identifier |targetScope|
//@[012:013) Assignment |=|
//@[014:022) StringComplete |'tenant'|
//@[022:026) NewLine |\r\n\r\n|

param modSubId string
//@[000:005) Identifier |param|
//@[006:014) Identifier |modSubId|
//@[015:021) Identifier |string|
//@[021:023) NewLine |\r\n|
param modRgName string
//@[000:005) Identifier |param|
//@[006:015) Identifier |modRgName|
//@[016:022) Identifier |string|
//@[022:024) NewLine |\r\n|
param otherSubId string
//@[000:005) Identifier |param|
//@[006:016) Identifier |otherSubId|
//@[017:023) Identifier |string|
//@[023:027) NewLine |\r\n\r\n|

module mod './modulea.bicep' = {
//@[000:006) Identifier |module|
//@[007:010) Identifier |mod|
//@[011:028) StringComplete |'./modulea.bicep'|
//@[029:030) Assignment |=|
//@[031:032) LeftBrace |{|
//@[032:034) NewLine |\r\n|
    name: 'test'
//@[004:008) Identifier |name|
//@[008:009) Colon |:|
//@[010:016) StringComplete |'test'|
//@[016:018) NewLine |\r\n|
    scope: resourceGroup(modSubId, modRgName)
//@[004:009) Identifier |scope|
//@[009:010) Colon |:|
//@[011:024) Identifier |resourceGroup|
//@[024:025) LeftParen |(|
//@[025:033) Identifier |modSubId|
//@[033:034) Comma |,|
//@[035:044) Identifier |modRgName|
//@[044:045) RightParen |)|
//@[045:047) NewLine |\r\n|
    params: {
//@[004:010) Identifier |params|
//@[010:011) Colon |:|
//@[012:013) LeftBrace |{|
//@[013:015) NewLine |\r\n|
       foo: 'bar'
//@[007:010) Identifier |foo|
//@[010:011) Colon |:|
//@[012:017) StringComplete |'bar'|
//@[017:019) NewLine |\r\n|
    }
//@[004:005) RightBrace |}|
//@[005:007) NewLine |\r\n|
}
//@[000:001) RightBrace |}|
//@[001:005) NewLine |\r\n\r\n|

module otherMod './moduleb.bicep' = {
//@[000:006) Identifier |module|
//@[007:015) Identifier |otherMod|
//@[016:033) StringComplete |'./moduleb.bicep'|
//@[034:035) Assignment |=|
//@[036:037) LeftBrace |{|
//@[037:039) NewLine |\r\n|
    name: 'test2'
//@[004:008) Identifier |name|
//@[008:009) Colon |:|
//@[010:017) StringComplete |'test2'|
//@[017:019) NewLine |\r\n|
    scope: resourceGroup(modSubId, modRgName)
//@[004:009) Identifier |scope|
//@[009:010) Colon |:|
//@[011:024) Identifier |resourceGroup|
//@[024:025) LeftParen |(|
//@[025:033) Identifier |modSubId|
//@[033:034) Comma |,|
//@[035:044) Identifier |modRgName|
//@[044:045) RightParen |)|
//@[045:047) NewLine |\r\n|
    params: {
//@[004:010) Identifier |params|
//@[010:011) Colon |:|
//@[012:013) LeftBrace |{|
//@[013:015) NewLine |\r\n|
       p: mod.outputs.storage
//@[007:008) Identifier |p|
//@[008:009) Colon |:|
//@[010:013) Identifier |mod|
//@[013:014) Dot |.|
//@[014:021) Identifier |outputs|
//@[021:022) Dot |.|
//@[022:029) Identifier |storage|
//@[029:031) NewLine |\r\n|
    }
//@[004:005) RightBrace |}|
//@[005:007) NewLine |\r\n|
}
//@[000:001) RightBrace |}|
//@[001:005) NewLine |\r\n\r\n|

module xMgMod './modulec.bicep' = {
//@[000:006) Identifier |module|
//@[007:013) Identifier |xMgMod|
//@[014:031) StringComplete |'./modulec.bicep'|
//@[032:033) Assignment |=|
//@[034:035) LeftBrace |{|
//@[035:037) NewLine |\r\n|
    name: 'anotherTest'
//@[004:008) Identifier |name|
//@[008:009) Colon |:|
//@[010:023) StringComplete |'anotherTest'|
//@[023:025) NewLine |\r\n|
    scope: managementGroup('myMg')
//@[004:009) Identifier |scope|
//@[009:010) Colon |:|
//@[011:026) Identifier |managementGroup|
//@[026:027) LeftParen |(|
//@[027:033) StringComplete |'myMg'|
//@[033:034) RightParen |)|
//@[034:036) NewLine |\r\n|
}
//@[000:001) RightBrace |}|
//@[001:005) NewLine |\r\n\r\n|

module arrayMod './modulea.bicep' = [for i in range(0, 10): {
//@[000:006) Identifier |module|
//@[007:015) Identifier |arrayMod|
//@[016:033) StringComplete |'./modulea.bicep'|
//@[034:035) Assignment |=|
//@[036:037) LeftSquare |[|
//@[037:040) Identifier |for|
//@[041:042) Identifier |i|
//@[043:045) Identifier |in|
//@[046:051) Identifier |range|
//@[051:052) LeftParen |(|
//@[052:053) Integer |0|
//@[053:054) Comma |,|
//@[055:057) Integer |10|
//@[057:058) RightParen |)|
//@[058:059) Colon |:|
//@[060:061) LeftBrace |{|
//@[061:063) NewLine |\r\n|
  name: 'test${i}'
//@[002:006) Identifier |name|
//@[006:007) Colon |:|
//@[008:015) StringLeftPiece |'test${|
//@[015:016) Identifier |i|
//@[016:018) StringRightPiece |}'|
//@[018:020) NewLine |\r\n|
  scope: resourceGroup(otherSubId, modRgName)
//@[002:007) Identifier |scope|
//@[007:008) Colon |:|
//@[009:022) Identifier |resourceGroup|
//@[022:023) LeftParen |(|
//@[023:033) Identifier |otherSubId|
//@[033:034) Comma |,|
//@[035:044) Identifier |modRgName|
//@[044:045) RightParen |)|
//@[045:047) NewLine |\r\n|
  params: {
//@[002:008) Identifier |params|
//@[008:009) Colon |:|
//@[010:011) LeftBrace |{|
//@[011:013) NewLine |\r\n|
    foo: 'baz${i}'
//@[004:007) Identifier |foo|
//@[007:008) Colon |:|
//@[009:015) StringLeftPiece |'baz${|
//@[015:016) Identifier |i|
//@[016:018) StringRightPiece |}'|
//@[018:020) NewLine |\r\n|
  }
//@[002:003) RightBrace |}|
//@[003:005) NewLine |\r\n|
}]
//@[000:001) RightBrace |}|
//@[001:002) RightSquare |]|
//@[002:006) NewLine |\r\n\r\n|

output id string = mod.outputs.storage.id
//@[000:006) Identifier |output|
//@[007:009) Identifier |id|
//@[010:016) Identifier |string|
//@[017:018) Assignment |=|
//@[019:022) Identifier |mod|
//@[022:023) Dot |.|
//@[023:030) Identifier |outputs|
//@[030:031) Dot |.|
//@[031:038) Identifier |storage|
//@[038:039) Dot |.|
//@[039:041) Identifier |id|
//@[041:043) NewLine |\r\n|
output name string = mod.outputs.storage.name
//@[000:006) Identifier |output|
//@[007:011) Identifier |name|
//@[012:018) Identifier |string|
//@[019:020) Assignment |=|
//@[021:024) Identifier |mod|
//@[024:025) Dot |.|
//@[025:032) Identifier |outputs|
//@[032:033) Dot |.|
//@[033:040) Identifier |storage|
//@[040:041) Dot |.|
//@[041:045) Identifier |name|
//@[045:047) NewLine |\r\n|
output type string = mod.outputs.storage.type
//@[000:006) Identifier |output|
//@[007:011) Identifier |type|
//@[012:018) Identifier |string|
//@[019:020) Assignment |=|
//@[021:024) Identifier |mod|
//@[024:025) Dot |.|
//@[025:032) Identifier |outputs|
//@[032:033) Dot |.|
//@[033:040) Identifier |storage|
//@[040:041) Dot |.|
//@[041:045) Identifier |type|
//@[045:047) NewLine |\r\n|
output apiVersion string = mod.outputs.storage.apiVersion
//@[000:006) Identifier |output|
//@[007:017) Identifier |apiVersion|
//@[018:024) Identifier |string|
//@[025:026) Assignment |=|
//@[027:030) Identifier |mod|
//@[030:031) Dot |.|
//@[031:038) Identifier |outputs|
//@[038:039) Dot |.|
//@[039:046) Identifier |storage|
//@[046:047) Dot |.|
//@[047:057) Identifier |apiVersion|
//@[057:059) NewLine |\r\n|
output accessTier string = mod.outputs.storage.properties.accessTier
//@[000:006) Identifier |output|
//@[007:017) Identifier |accessTier|
//@[018:024) Identifier |string|
//@[025:026) Assignment |=|
//@[027:030) Identifier |mod|
//@[030:031) Dot |.|
//@[031:038) Identifier |outputs|
//@[038:039) Dot |.|
//@[039:046) Identifier |storage|
//@[046:047) Dot |.|
//@[047:057) Identifier |properties|
//@[057:058) Dot |.|
//@[058:068) Identifier |accessTier|
//@[068:070) NewLine |\r\n|
output publicAccess string = mod.outputs.container.properties.publicAccess
//@[000:006) Identifier |output|
//@[007:019) Identifier |publicAccess|
//@[020:026) Identifier |string|
//@[027:028) Assignment |=|
//@[029:032) Identifier |mod|
//@[032:033) Dot |.|
//@[033:040) Identifier |outputs|
//@[040:041) Dot |.|
//@[041:050) Identifier |container|
//@[050:051) Dot |.|
//@[051:061) Identifier |properties|
//@[061:062) Dot |.|
//@[062:074) Identifier |publicAccess|
//@[074:076) NewLine |\r\n|
output db1FreeTier bool = mod.outputs.db1.properties.enableFreeTier
//@[000:006) Identifier |output|
//@[007:018) Identifier |db1FreeTier|
//@[019:023) Identifier |bool|
//@[024:025) Assignment |=|
//@[026:029) Identifier |mod|
//@[029:030) Dot |.|
//@[030:037) Identifier |outputs|
//@[037:038) Dot |.|
//@[038:041) Identifier |db1|
//@[041:042) Dot |.|
//@[042:052) Identifier |properties|
//@[052:053) Dot |.|
//@[053:067) Identifier |enableFreeTier|
//@[067:069) NewLine |\r\n|
output dbsFreeTier array = [for i in range(0, 3): mod.outputs.dbs[i].properties.enableFreeTier]
//@[000:006) Identifier |output|
//@[007:018) Identifier |dbsFreeTier|
//@[019:024) Identifier |array|
//@[025:026) Assignment |=|
//@[027:028) LeftSquare |[|
//@[028:031) Identifier |for|
//@[032:033) Identifier |i|
//@[034:036) Identifier |in|
//@[037:042) Identifier |range|
//@[042:043) LeftParen |(|
//@[043:044) Integer |0|
//@[044:045) Comma |,|
//@[046:047) Integer |3|
//@[047:048) RightParen |)|
//@[048:049) Colon |:|
//@[050:053) Identifier |mod|
//@[053:054) Dot |.|
//@[054:061) Identifier |outputs|
//@[061:062) Dot |.|
//@[062:065) Identifier |dbs|
//@[065:066) LeftSquare |[|
//@[066:067) Identifier |i|
//@[067:068) RightSquare |]|
//@[068:069) Dot |.|
//@[069:079) Identifier |properties|
//@[079:080) Dot |.|
//@[080:094) Identifier |enableFreeTier|
//@[094:095) RightSquare |]|
//@[095:099) NewLine |\r\n\r\n|

output indirectionAccessTier string = otherMod.outputs.storage.properties.accessTier
//@[000:006) Identifier |output|
//@[007:028) Identifier |indirectionAccessTier|
//@[029:035) Identifier |string|
//@[036:037) Assignment |=|
//@[038:046) Identifier |otherMod|
//@[046:047) Dot |.|
//@[047:054) Identifier |outputs|
//@[054:055) Dot |.|
//@[055:062) Identifier |storage|
//@[062:063) Dot |.|
//@[063:073) Identifier |properties|
//@[073:074) Dot |.|
//@[074:084) Identifier |accessTier|
//@[084:088) NewLine |\r\n\r\n|

output policyType string = xMgMod.outputs.policy.properties.policyType
//@[000:006) Identifier |output|
//@[007:017) Identifier |policyType|
//@[018:024) Identifier |string|
//@[025:026) Assignment |=|
//@[027:033) Identifier |xMgMod|
//@[033:034) Dot |.|
//@[034:041) Identifier |outputs|
//@[041:042) Dot |.|
//@[042:048) Identifier |policy|
//@[048:049) Dot |.|
//@[049:059) Identifier |properties|
//@[059:060) Dot |.|
//@[060:070) Identifier |policyType|
//@[070:074) NewLine |\r\n\r\n|

output id9 string = arrayMod[9].outputs.storage.id
//@[000:006) Identifier |output|
//@[007:010) Identifier |id9|
//@[011:017) Identifier |string|
//@[018:019) Assignment |=|
//@[020:028) Identifier |arrayMod|
//@[028:029) LeftSquare |[|
//@[029:030) Integer |9|
//@[030:031) RightSquare |]|
//@[031:032) Dot |.|
//@[032:039) Identifier |outputs|
//@[039:040) Dot |.|
//@[040:047) Identifier |storage|
//@[047:048) Dot |.|
//@[048:050) Identifier |id|
//@[050:052) NewLine |\r\n|
output publicAccess9 string = arrayMod[9].outputs.container.properties.publicAccess
//@[000:006) Identifier |output|
//@[007:020) Identifier |publicAccess9|
//@[021:027) Identifier |string|
//@[028:029) Assignment |=|
//@[030:038) Identifier |arrayMod|
//@[038:039) LeftSquare |[|
//@[039:040) Integer |9|
//@[040:041) RightSquare |]|
//@[041:042) Dot |.|
//@[042:049) Identifier |outputs|
//@[049:050) Dot |.|
//@[050:059) Identifier |container|
//@[059:060) Dot |.|
//@[060:070) Identifier |properties|
//@[070:071) Dot |.|
//@[071:083) Identifier |publicAccess|
//@[083:085) NewLine |\r\n|
output dbs9FreeTier array = [for i in range(0, 3): arrayMod[9].outputs.dbs[i].properties.enableFreeTier]
//@[000:006) Identifier |output|
//@[007:019) Identifier |dbs9FreeTier|
//@[020:025) Identifier |array|
//@[026:027) Assignment |=|
//@[028:029) LeftSquare |[|
//@[029:032) Identifier |for|
//@[033:034) Identifier |i|
//@[035:037) Identifier |in|
//@[038:043) Identifier |range|
//@[043:044) LeftParen |(|
//@[044:045) Integer |0|
//@[045:046) Comma |,|
//@[047:048) Integer |3|
//@[048:049) RightParen |)|
//@[049:050) Colon |:|
//@[051:059) Identifier |arrayMod|
//@[059:060) LeftSquare |[|
//@[060:061) Integer |9|
//@[061:062) RightSquare |]|
//@[062:063) Dot |.|
//@[063:070) Identifier |outputs|
//@[070:071) Dot |.|
//@[071:074) Identifier |dbs|
//@[074:075) LeftSquare |[|
//@[075:076) Identifier |i|
//@[076:077) RightSquare |]|
//@[077:078) Dot |.|
//@[078:088) Identifier |properties|
//@[088:089) Dot |.|
//@[089:103) Identifier |enableFreeTier|
//@[103:104) RightSquare |]|
//@[104:106) NewLine |\r\n|

//@[000:000) EndOfFile ||
