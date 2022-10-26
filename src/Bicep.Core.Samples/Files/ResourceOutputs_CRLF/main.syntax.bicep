targetScope = 'tenant'
//@[000:1600) ProgramSyntax
//@[000:0022) ├─TargetScopeSyntax
//@[000:0011) | ├─Token(Identifier) |targetScope|
//@[012:0013) | ├─Token(Assignment) |=|
//@[014:0022) | └─StringSyntax
//@[014:0022) |   └─Token(StringComplete) |'tenant'|
//@[022:0026) ├─Token(NewLine) |\r\n\r\n|

param modSubId string
//@[000:0021) ├─ParameterDeclarationSyntax
//@[000:0005) | ├─Token(Identifier) |param|
//@[006:0014) | ├─IdentifierSyntax
//@[006:0014) | | └─Token(Identifier) |modSubId|
//@[015:0021) | └─SimpleTypeSyntax
//@[015:0021) |   └─Token(Identifier) |string|
//@[021:0023) ├─Token(NewLine) |\r\n|
param modRgName string
//@[000:0022) ├─ParameterDeclarationSyntax
//@[000:0005) | ├─Token(Identifier) |param|
//@[006:0015) | ├─IdentifierSyntax
//@[006:0015) | | └─Token(Identifier) |modRgName|
//@[016:0022) | └─SimpleTypeSyntax
//@[016:0022) |   └─Token(Identifier) |string|
//@[022:0024) ├─Token(NewLine) |\r\n|
param otherSubId string
//@[000:0023) ├─ParameterDeclarationSyntax
//@[000:0005) | ├─Token(Identifier) |param|
//@[006:0016) | ├─IdentifierSyntax
//@[006:0016) | | └─Token(Identifier) |otherSubId|
//@[017:0023) | └─SimpleTypeSyntax
//@[017:0023) |   └─Token(Identifier) |string|
//@[023:0027) ├─Token(NewLine) |\r\n\r\n|

module mod './modulea.bicep' = {
//@[000:0141) ├─ModuleDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |module|
//@[007:0010) | ├─IdentifierSyntax
//@[007:0010) | | └─Token(Identifier) |mod|
//@[011:0028) | ├─StringSyntax
//@[011:0028) | | └─Token(StringComplete) |'./modulea.bicep'|
//@[029:0030) | ├─Token(Assignment) |=|
//@[031:0141) | └─ObjectSyntax
//@[031:0032) |   ├─Token(LeftBrace) |{|
//@[032:0034) |   ├─Token(NewLine) |\r\n|
    name: 'test'
//@[004:0016) |   ├─ObjectPropertySyntax
//@[004:0008) |   | ├─IdentifierSyntax
//@[004:0008) |   | | └─Token(Identifier) |name|
//@[008:0009) |   | ├─Token(Colon) |:|
//@[010:0016) |   | └─StringSyntax
//@[010:0016) |   |   └─Token(StringComplete) |'test'|
//@[016:0018) |   ├─Token(NewLine) |\r\n|
    scope: resourceGroup(modSubId, modRgName)
//@[004:0045) |   ├─ObjectPropertySyntax
//@[004:0009) |   | ├─IdentifierSyntax
//@[004:0009) |   | | └─Token(Identifier) |scope|
//@[009:0010) |   | ├─Token(Colon) |:|
//@[011:0045) |   | └─FunctionCallSyntax
//@[011:0024) |   |   ├─IdentifierSyntax
//@[011:0024) |   |   | └─Token(Identifier) |resourceGroup|
//@[024:0025) |   |   ├─Token(LeftParen) |(|
//@[025:0033) |   |   ├─FunctionArgumentSyntax
//@[025:0033) |   |   | └─VariableAccessSyntax
//@[025:0033) |   |   |   └─IdentifierSyntax
//@[025:0033) |   |   |     └─Token(Identifier) |modSubId|
//@[033:0034) |   |   ├─Token(Comma) |,|
//@[035:0044) |   |   ├─FunctionArgumentSyntax
//@[035:0044) |   |   | └─VariableAccessSyntax
//@[035:0044) |   |   |   └─IdentifierSyntax
//@[035:0044) |   |   |     └─Token(Identifier) |modRgName|
//@[044:0045) |   |   └─Token(RightParen) |)|
//@[045:0047) |   ├─Token(NewLine) |\r\n|
    params: {
//@[004:0039) |   ├─ObjectPropertySyntax
//@[004:0010) |   | ├─IdentifierSyntax
//@[004:0010) |   | | └─Token(Identifier) |params|
//@[010:0011) |   | ├─Token(Colon) |:|
//@[012:0039) |   | └─ObjectSyntax
//@[012:0013) |   |   ├─Token(LeftBrace) |{|
//@[013:0015) |   |   ├─Token(NewLine) |\r\n|
       foo: 'bar'
//@[007:0017) |   |   ├─ObjectPropertySyntax
//@[007:0010) |   |   | ├─IdentifierSyntax
//@[007:0010) |   |   | | └─Token(Identifier) |foo|
//@[010:0011) |   |   | ├─Token(Colon) |:|
//@[012:0017) |   |   | └─StringSyntax
//@[012:0017) |   |   |   └─Token(StringComplete) |'bar'|
//@[017:0019) |   |   ├─Token(NewLine) |\r\n|
    }
//@[004:0005) |   |   └─Token(RightBrace) |}|
//@[005:0007) |   ├─Token(NewLine) |\r\n|
}
//@[000:0001) |   └─Token(RightBrace) |}|
//@[001:0005) ├─Token(NewLine) |\r\n\r\n|

module otherMod './moduleb.bicep' = {
//@[000:0159) ├─ModuleDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |module|
//@[007:0015) | ├─IdentifierSyntax
//@[007:0015) | | └─Token(Identifier) |otherMod|
//@[016:0033) | ├─StringSyntax
//@[016:0033) | | └─Token(StringComplete) |'./moduleb.bicep'|
//@[034:0035) | ├─Token(Assignment) |=|
//@[036:0159) | └─ObjectSyntax
//@[036:0037) |   ├─Token(LeftBrace) |{|
//@[037:0039) |   ├─Token(NewLine) |\r\n|
    name: 'test2'
//@[004:0017) |   ├─ObjectPropertySyntax
//@[004:0008) |   | ├─IdentifierSyntax
//@[004:0008) |   | | └─Token(Identifier) |name|
//@[008:0009) |   | ├─Token(Colon) |:|
//@[010:0017) |   | └─StringSyntax
//@[010:0017) |   |   └─Token(StringComplete) |'test2'|
//@[017:0019) |   ├─Token(NewLine) |\r\n|
    scope: resourceGroup(modSubId, modRgName)
//@[004:0045) |   ├─ObjectPropertySyntax
//@[004:0009) |   | ├─IdentifierSyntax
//@[004:0009) |   | | └─Token(Identifier) |scope|
//@[009:0010) |   | ├─Token(Colon) |:|
//@[011:0045) |   | └─FunctionCallSyntax
//@[011:0024) |   |   ├─IdentifierSyntax
//@[011:0024) |   |   | └─Token(Identifier) |resourceGroup|
//@[024:0025) |   |   ├─Token(LeftParen) |(|
//@[025:0033) |   |   ├─FunctionArgumentSyntax
//@[025:0033) |   |   | └─VariableAccessSyntax
//@[025:0033) |   |   |   └─IdentifierSyntax
//@[025:0033) |   |   |     └─Token(Identifier) |modSubId|
//@[033:0034) |   |   ├─Token(Comma) |,|
//@[035:0044) |   |   ├─FunctionArgumentSyntax
//@[035:0044) |   |   | └─VariableAccessSyntax
//@[035:0044) |   |   |   └─IdentifierSyntax
//@[035:0044) |   |   |     └─Token(Identifier) |modRgName|
//@[044:0045) |   |   └─Token(RightParen) |)|
//@[045:0047) |   ├─Token(NewLine) |\r\n|
    params: {
//@[004:0051) |   ├─ObjectPropertySyntax
//@[004:0010) |   | ├─IdentifierSyntax
//@[004:0010) |   | | └─Token(Identifier) |params|
//@[010:0011) |   | ├─Token(Colon) |:|
//@[012:0051) |   | └─ObjectSyntax
//@[012:0013) |   |   ├─Token(LeftBrace) |{|
//@[013:0015) |   |   ├─Token(NewLine) |\r\n|
       p: mod.outputs.storage
//@[007:0029) |   |   ├─ObjectPropertySyntax
//@[007:0008) |   |   | ├─IdentifierSyntax
//@[007:0008) |   |   | | └─Token(Identifier) |p|
//@[008:0009) |   |   | ├─Token(Colon) |:|
//@[010:0029) |   |   | └─PropertyAccessSyntax
//@[010:0021) |   |   |   ├─PropertyAccessSyntax
//@[010:0013) |   |   |   | ├─VariableAccessSyntax
//@[010:0013) |   |   |   | | └─IdentifierSyntax
//@[010:0013) |   |   |   | |   └─Token(Identifier) |mod|
//@[013:0014) |   |   |   | ├─Token(Dot) |.|
//@[014:0021) |   |   |   | └─IdentifierSyntax
//@[014:0021) |   |   |   |   └─Token(Identifier) |outputs|
//@[021:0022) |   |   |   ├─Token(Dot) |.|
//@[022:0029) |   |   |   └─IdentifierSyntax
//@[022:0029) |   |   |     └─Token(Identifier) |storage|
//@[029:0031) |   |   ├─Token(NewLine) |\r\n|
    }
//@[004:0005) |   |   └─Token(RightBrace) |}|
//@[005:0007) |   ├─Token(NewLine) |\r\n|
}
//@[000:0001) |   └─Token(RightBrace) |}|
//@[001:0005) ├─Token(NewLine) |\r\n\r\n|

module xMgMod './modulec.bicep' = {
//@[000:0099) ├─ModuleDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |module|
//@[007:0013) | ├─IdentifierSyntax
//@[007:0013) | | └─Token(Identifier) |xMgMod|
//@[014:0031) | ├─StringSyntax
//@[014:0031) | | └─Token(StringComplete) |'./modulec.bicep'|
//@[032:0033) | ├─Token(Assignment) |=|
//@[034:0099) | └─ObjectSyntax
//@[034:0035) |   ├─Token(LeftBrace) |{|
//@[035:0037) |   ├─Token(NewLine) |\r\n|
    name: 'anotherTest'
//@[004:0023) |   ├─ObjectPropertySyntax
//@[004:0008) |   | ├─IdentifierSyntax
//@[004:0008) |   | | └─Token(Identifier) |name|
//@[008:0009) |   | ├─Token(Colon) |:|
//@[010:0023) |   | └─StringSyntax
//@[010:0023) |   |   └─Token(StringComplete) |'anotherTest'|
//@[023:0025) |   ├─Token(NewLine) |\r\n|
    scope: managementGroup('myMg')
//@[004:0034) |   ├─ObjectPropertySyntax
//@[004:0009) |   | ├─IdentifierSyntax
//@[004:0009) |   | | └─Token(Identifier) |scope|
//@[009:0010) |   | ├─Token(Colon) |:|
//@[011:0034) |   | └─FunctionCallSyntax
//@[011:0026) |   |   ├─IdentifierSyntax
//@[011:0026) |   |   | └─Token(Identifier) |managementGroup|
//@[026:0027) |   |   ├─Token(LeftParen) |(|
//@[027:0033) |   |   ├─FunctionArgumentSyntax
//@[027:0033) |   |   | └─StringSyntax
//@[027:0033) |   |   |   └─Token(StringComplete) |'myMg'|
//@[033:0034) |   |   └─Token(RightParen) |)|
//@[034:0036) |   ├─Token(NewLine) |\r\n|
}
//@[000:0001) |   └─Token(RightBrace) |}|
//@[001:0005) ├─Token(NewLine) |\r\n\r\n|

module arrayMod './modulea.bicep' = [for i in range(0, 10): {
//@[000:0170) ├─ModuleDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |module|
//@[007:0015) | ├─IdentifierSyntax
//@[007:0015) | | └─Token(Identifier) |arrayMod|
//@[016:0033) | ├─StringSyntax
//@[016:0033) | | └─Token(StringComplete) |'./modulea.bicep'|
//@[034:0035) | ├─Token(Assignment) |=|
//@[036:0170) | └─ForSyntax
//@[036:0037) |   ├─Token(LeftSquare) |[|
//@[037:0040) |   ├─Token(Identifier) |for|
//@[041:0042) |   ├─LocalVariableSyntax
//@[041:0042) |   | └─IdentifierSyntax
//@[041:0042) |   |   └─Token(Identifier) |i|
//@[043:0045) |   ├─Token(Identifier) |in|
//@[046:0058) |   ├─FunctionCallSyntax
//@[046:0051) |   | ├─IdentifierSyntax
//@[046:0051) |   | | └─Token(Identifier) |range|
//@[051:0052) |   | ├─Token(LeftParen) |(|
//@[052:0053) |   | ├─FunctionArgumentSyntax
//@[052:0053) |   | | └─IntegerLiteralSyntax
//@[052:0053) |   | |   └─Token(Integer) |0|
//@[053:0054) |   | ├─Token(Comma) |,|
//@[055:0057) |   | ├─FunctionArgumentSyntax
//@[055:0057) |   | | └─IntegerLiteralSyntax
//@[055:0057) |   | |   └─Token(Integer) |10|
//@[057:0058) |   | └─Token(RightParen) |)|
//@[058:0059) |   ├─Token(Colon) |:|
//@[060:0169) |   ├─ObjectSyntax
//@[060:0061) |   | ├─Token(LeftBrace) |{|
//@[061:0063) |   | ├─Token(NewLine) |\r\n|
  name: 'test${i}'
//@[002:0018) |   | ├─ObjectPropertySyntax
//@[002:0006) |   | | ├─IdentifierSyntax
//@[002:0006) |   | | | └─Token(Identifier) |name|
//@[006:0007) |   | | ├─Token(Colon) |:|
//@[008:0018) |   | | └─StringSyntax
//@[008:0015) |   | |   ├─Token(StringLeftPiece) |'test${|
//@[015:0016) |   | |   ├─VariableAccessSyntax
//@[015:0016) |   | |   | └─IdentifierSyntax
//@[015:0016) |   | |   |   └─Token(Identifier) |i|
//@[016:0018) |   | |   └─Token(StringRightPiece) |}'|
//@[018:0020) |   | ├─Token(NewLine) |\r\n|
  scope: resourceGroup(otherSubId, modRgName)
//@[002:0045) |   | ├─ObjectPropertySyntax
//@[002:0007) |   | | ├─IdentifierSyntax
//@[002:0007) |   | | | └─Token(Identifier) |scope|
//@[007:0008) |   | | ├─Token(Colon) |:|
//@[009:0045) |   | | └─FunctionCallSyntax
//@[009:0022) |   | |   ├─IdentifierSyntax
//@[009:0022) |   | |   | └─Token(Identifier) |resourceGroup|
//@[022:0023) |   | |   ├─Token(LeftParen) |(|
//@[023:0033) |   | |   ├─FunctionArgumentSyntax
//@[023:0033) |   | |   | └─VariableAccessSyntax
//@[023:0033) |   | |   |   └─IdentifierSyntax
//@[023:0033) |   | |   |     └─Token(Identifier) |otherSubId|
//@[033:0034) |   | |   ├─Token(Comma) |,|
//@[035:0044) |   | |   ├─FunctionArgumentSyntax
//@[035:0044) |   | |   | └─VariableAccessSyntax
//@[035:0044) |   | |   |   └─IdentifierSyntax
//@[035:0044) |   | |   |     └─Token(Identifier) |modRgName|
//@[044:0045) |   | |   └─Token(RightParen) |)|
//@[045:0047) |   | ├─Token(NewLine) |\r\n|
  params: {
//@[002:0036) |   | ├─ObjectPropertySyntax
//@[002:0008) |   | | ├─IdentifierSyntax
//@[002:0008) |   | | | └─Token(Identifier) |params|
//@[008:0009) |   | | ├─Token(Colon) |:|
//@[010:0036) |   | | └─ObjectSyntax
//@[010:0011) |   | |   ├─Token(LeftBrace) |{|
//@[011:0013) |   | |   ├─Token(NewLine) |\r\n|
    foo: 'baz${i}'
//@[004:0018) |   | |   ├─ObjectPropertySyntax
//@[004:0007) |   | |   | ├─IdentifierSyntax
//@[004:0007) |   | |   | | └─Token(Identifier) |foo|
//@[007:0008) |   | |   | ├─Token(Colon) |:|
//@[009:0018) |   | |   | └─StringSyntax
//@[009:0015) |   | |   |   ├─Token(StringLeftPiece) |'baz${|
//@[015:0016) |   | |   |   ├─VariableAccessSyntax
//@[015:0016) |   | |   |   | └─IdentifierSyntax
//@[015:0016) |   | |   |   |   └─Token(Identifier) |i|
//@[016:0018) |   | |   |   └─Token(StringRightPiece) |}'|
//@[018:0020) |   | |   ├─Token(NewLine) |\r\n|
  }
//@[002:0003) |   | |   └─Token(RightBrace) |}|
//@[003:0005) |   | ├─Token(NewLine) |\r\n|
}]
//@[000:0001) |   | └─Token(RightBrace) |}|
//@[001:0002) |   └─Token(RightSquare) |]|
//@[002:0006) ├─Token(NewLine) |\r\n\r\n|

output id string = mod.outputs.storage.id
//@[000:0041) ├─OutputDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |output|
//@[007:0009) | ├─IdentifierSyntax
//@[007:0009) | | └─Token(Identifier) |id|
//@[010:0016) | ├─SimpleTypeSyntax
//@[010:0016) | | └─Token(Identifier) |string|
//@[017:0018) | ├─Token(Assignment) |=|
//@[019:0041) | └─PropertyAccessSyntax
//@[019:0038) |   ├─PropertyAccessSyntax
//@[019:0030) |   | ├─PropertyAccessSyntax
//@[019:0022) |   | | ├─VariableAccessSyntax
//@[019:0022) |   | | | └─IdentifierSyntax
//@[019:0022) |   | | |   └─Token(Identifier) |mod|
//@[022:0023) |   | | ├─Token(Dot) |.|
//@[023:0030) |   | | └─IdentifierSyntax
//@[023:0030) |   | |   └─Token(Identifier) |outputs|
//@[030:0031) |   | ├─Token(Dot) |.|
//@[031:0038) |   | └─IdentifierSyntax
//@[031:0038) |   |   └─Token(Identifier) |storage|
//@[038:0039) |   ├─Token(Dot) |.|
//@[039:0041) |   └─IdentifierSyntax
//@[039:0041) |     └─Token(Identifier) |id|
//@[041:0043) ├─Token(NewLine) |\r\n|
output name string = mod.outputs.storage.name
//@[000:0045) ├─OutputDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |output|
//@[007:0011) | ├─IdentifierSyntax
//@[007:0011) | | └─Token(Identifier) |name|
//@[012:0018) | ├─SimpleTypeSyntax
//@[012:0018) | | └─Token(Identifier) |string|
//@[019:0020) | ├─Token(Assignment) |=|
//@[021:0045) | └─PropertyAccessSyntax
//@[021:0040) |   ├─PropertyAccessSyntax
//@[021:0032) |   | ├─PropertyAccessSyntax
//@[021:0024) |   | | ├─VariableAccessSyntax
//@[021:0024) |   | | | └─IdentifierSyntax
//@[021:0024) |   | | |   └─Token(Identifier) |mod|
//@[024:0025) |   | | ├─Token(Dot) |.|
//@[025:0032) |   | | └─IdentifierSyntax
//@[025:0032) |   | |   └─Token(Identifier) |outputs|
//@[032:0033) |   | ├─Token(Dot) |.|
//@[033:0040) |   | └─IdentifierSyntax
//@[033:0040) |   |   └─Token(Identifier) |storage|
//@[040:0041) |   ├─Token(Dot) |.|
//@[041:0045) |   └─IdentifierSyntax
//@[041:0045) |     └─Token(Identifier) |name|
//@[045:0047) ├─Token(NewLine) |\r\n|
output type string = mod.outputs.storage.type
//@[000:0045) ├─OutputDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |output|
//@[007:0011) | ├─IdentifierSyntax
//@[007:0011) | | └─Token(Identifier) |type|
//@[012:0018) | ├─SimpleTypeSyntax
//@[012:0018) | | └─Token(Identifier) |string|
//@[019:0020) | ├─Token(Assignment) |=|
//@[021:0045) | └─PropertyAccessSyntax
//@[021:0040) |   ├─PropertyAccessSyntax
//@[021:0032) |   | ├─PropertyAccessSyntax
//@[021:0024) |   | | ├─VariableAccessSyntax
//@[021:0024) |   | | | └─IdentifierSyntax
//@[021:0024) |   | | |   └─Token(Identifier) |mod|
//@[024:0025) |   | | ├─Token(Dot) |.|
//@[025:0032) |   | | └─IdentifierSyntax
//@[025:0032) |   | |   └─Token(Identifier) |outputs|
//@[032:0033) |   | ├─Token(Dot) |.|
//@[033:0040) |   | └─IdentifierSyntax
//@[033:0040) |   |   └─Token(Identifier) |storage|
//@[040:0041) |   ├─Token(Dot) |.|
//@[041:0045) |   └─IdentifierSyntax
//@[041:0045) |     └─Token(Identifier) |type|
//@[045:0047) ├─Token(NewLine) |\r\n|
output apiVersion string = mod.outputs.storage.apiVersion
//@[000:0057) ├─OutputDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |output|
//@[007:0017) | ├─IdentifierSyntax
//@[007:0017) | | └─Token(Identifier) |apiVersion|
//@[018:0024) | ├─SimpleTypeSyntax
//@[018:0024) | | └─Token(Identifier) |string|
//@[025:0026) | ├─Token(Assignment) |=|
//@[027:0057) | └─PropertyAccessSyntax
//@[027:0046) |   ├─PropertyAccessSyntax
//@[027:0038) |   | ├─PropertyAccessSyntax
//@[027:0030) |   | | ├─VariableAccessSyntax
//@[027:0030) |   | | | └─IdentifierSyntax
//@[027:0030) |   | | |   └─Token(Identifier) |mod|
//@[030:0031) |   | | ├─Token(Dot) |.|
//@[031:0038) |   | | └─IdentifierSyntax
//@[031:0038) |   | |   └─Token(Identifier) |outputs|
//@[038:0039) |   | ├─Token(Dot) |.|
//@[039:0046) |   | └─IdentifierSyntax
//@[039:0046) |   |   └─Token(Identifier) |storage|
//@[046:0047) |   ├─Token(Dot) |.|
//@[047:0057) |   └─IdentifierSyntax
//@[047:0057) |     └─Token(Identifier) |apiVersion|
//@[057:0059) ├─Token(NewLine) |\r\n|
output accessTier string = mod.outputs.storage.properties.accessTier
//@[000:0068) ├─OutputDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |output|
//@[007:0017) | ├─IdentifierSyntax
//@[007:0017) | | └─Token(Identifier) |accessTier|
//@[018:0024) | ├─SimpleTypeSyntax
//@[018:0024) | | └─Token(Identifier) |string|
//@[025:0026) | ├─Token(Assignment) |=|
//@[027:0068) | └─PropertyAccessSyntax
//@[027:0057) |   ├─PropertyAccessSyntax
//@[027:0046) |   | ├─PropertyAccessSyntax
//@[027:0038) |   | | ├─PropertyAccessSyntax
//@[027:0030) |   | | | ├─VariableAccessSyntax
//@[027:0030) |   | | | | └─IdentifierSyntax
//@[027:0030) |   | | | |   └─Token(Identifier) |mod|
//@[030:0031) |   | | | ├─Token(Dot) |.|
//@[031:0038) |   | | | └─IdentifierSyntax
//@[031:0038) |   | | |   └─Token(Identifier) |outputs|
//@[038:0039) |   | | ├─Token(Dot) |.|
//@[039:0046) |   | | └─IdentifierSyntax
//@[039:0046) |   | |   └─Token(Identifier) |storage|
//@[046:0047) |   | ├─Token(Dot) |.|
//@[047:0057) |   | └─IdentifierSyntax
//@[047:0057) |   |   └─Token(Identifier) |properties|
//@[057:0058) |   ├─Token(Dot) |.|
//@[058:0068) |   └─IdentifierSyntax
//@[058:0068) |     └─Token(Identifier) |accessTier|
//@[068:0070) ├─Token(NewLine) |\r\n|
output publicAccess string = mod.outputs.container.properties.publicAccess
//@[000:0074) ├─OutputDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |output|
//@[007:0019) | ├─IdentifierSyntax
//@[007:0019) | | └─Token(Identifier) |publicAccess|
//@[020:0026) | ├─SimpleTypeSyntax
//@[020:0026) | | └─Token(Identifier) |string|
//@[027:0028) | ├─Token(Assignment) |=|
//@[029:0074) | └─PropertyAccessSyntax
//@[029:0061) |   ├─PropertyAccessSyntax
//@[029:0050) |   | ├─PropertyAccessSyntax
//@[029:0040) |   | | ├─PropertyAccessSyntax
//@[029:0032) |   | | | ├─VariableAccessSyntax
//@[029:0032) |   | | | | └─IdentifierSyntax
//@[029:0032) |   | | | |   └─Token(Identifier) |mod|
//@[032:0033) |   | | | ├─Token(Dot) |.|
//@[033:0040) |   | | | └─IdentifierSyntax
//@[033:0040) |   | | |   └─Token(Identifier) |outputs|
//@[040:0041) |   | | ├─Token(Dot) |.|
//@[041:0050) |   | | └─IdentifierSyntax
//@[041:0050) |   | |   └─Token(Identifier) |container|
//@[050:0051) |   | ├─Token(Dot) |.|
//@[051:0061) |   | └─IdentifierSyntax
//@[051:0061) |   |   └─Token(Identifier) |properties|
//@[061:0062) |   ├─Token(Dot) |.|
//@[062:0074) |   └─IdentifierSyntax
//@[062:0074) |     └─Token(Identifier) |publicAccess|
//@[074:0076) ├─Token(NewLine) |\r\n|
output db1FreeTier bool = mod.outputs.db1.properties.enableFreeTier
//@[000:0067) ├─OutputDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |output|
//@[007:0018) | ├─IdentifierSyntax
//@[007:0018) | | └─Token(Identifier) |db1FreeTier|
//@[019:0023) | ├─SimpleTypeSyntax
//@[019:0023) | | └─Token(Identifier) |bool|
//@[024:0025) | ├─Token(Assignment) |=|
//@[026:0067) | └─PropertyAccessSyntax
//@[026:0052) |   ├─PropertyAccessSyntax
//@[026:0041) |   | ├─PropertyAccessSyntax
//@[026:0037) |   | | ├─PropertyAccessSyntax
//@[026:0029) |   | | | ├─VariableAccessSyntax
//@[026:0029) |   | | | | └─IdentifierSyntax
//@[026:0029) |   | | | |   └─Token(Identifier) |mod|
//@[029:0030) |   | | | ├─Token(Dot) |.|
//@[030:0037) |   | | | └─IdentifierSyntax
//@[030:0037) |   | | |   └─Token(Identifier) |outputs|
//@[037:0038) |   | | ├─Token(Dot) |.|
//@[038:0041) |   | | └─IdentifierSyntax
//@[038:0041) |   | |   └─Token(Identifier) |db1|
//@[041:0042) |   | ├─Token(Dot) |.|
//@[042:0052) |   | └─IdentifierSyntax
//@[042:0052) |   |   └─Token(Identifier) |properties|
//@[052:0053) |   ├─Token(Dot) |.|
//@[053:0067) |   └─IdentifierSyntax
//@[053:0067) |     └─Token(Identifier) |enableFreeTier|
//@[067:0069) ├─Token(NewLine) |\r\n|
output dbsFreeTier array = [for i in range(0, 3): mod.outputs.dbs[i].properties.enableFreeTier]
//@[000:0095) ├─OutputDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |output|
//@[007:0018) | ├─IdentifierSyntax
//@[007:0018) | | └─Token(Identifier) |dbsFreeTier|
//@[019:0024) | ├─SimpleTypeSyntax
//@[019:0024) | | └─Token(Identifier) |array|
//@[025:0026) | ├─Token(Assignment) |=|
//@[027:0095) | └─ForSyntax
//@[027:0028) |   ├─Token(LeftSquare) |[|
//@[028:0031) |   ├─Token(Identifier) |for|
//@[032:0033) |   ├─LocalVariableSyntax
//@[032:0033) |   | └─IdentifierSyntax
//@[032:0033) |   |   └─Token(Identifier) |i|
//@[034:0036) |   ├─Token(Identifier) |in|
//@[037:0048) |   ├─FunctionCallSyntax
//@[037:0042) |   | ├─IdentifierSyntax
//@[037:0042) |   | | └─Token(Identifier) |range|
//@[042:0043) |   | ├─Token(LeftParen) |(|
//@[043:0044) |   | ├─FunctionArgumentSyntax
//@[043:0044) |   | | └─IntegerLiteralSyntax
//@[043:0044) |   | |   └─Token(Integer) |0|
//@[044:0045) |   | ├─Token(Comma) |,|
//@[046:0047) |   | ├─FunctionArgumentSyntax
//@[046:0047) |   | | └─IntegerLiteralSyntax
//@[046:0047) |   | |   └─Token(Integer) |3|
//@[047:0048) |   | └─Token(RightParen) |)|
//@[048:0049) |   ├─Token(Colon) |:|
//@[050:0094) |   ├─PropertyAccessSyntax
//@[050:0079) |   | ├─PropertyAccessSyntax
//@[050:0068) |   | | ├─ArrayAccessSyntax
//@[050:0065) |   | | | ├─PropertyAccessSyntax
//@[050:0061) |   | | | | ├─PropertyAccessSyntax
//@[050:0053) |   | | | | | ├─VariableAccessSyntax
//@[050:0053) |   | | | | | | └─IdentifierSyntax
//@[050:0053) |   | | | | | |   └─Token(Identifier) |mod|
//@[053:0054) |   | | | | | ├─Token(Dot) |.|
//@[054:0061) |   | | | | | └─IdentifierSyntax
//@[054:0061) |   | | | | |   └─Token(Identifier) |outputs|
//@[061:0062) |   | | | | ├─Token(Dot) |.|
//@[062:0065) |   | | | | └─IdentifierSyntax
//@[062:0065) |   | | | |   └─Token(Identifier) |dbs|
//@[065:0066) |   | | | ├─Token(LeftSquare) |[|
//@[066:0067) |   | | | ├─VariableAccessSyntax
//@[066:0067) |   | | | | └─IdentifierSyntax
//@[066:0067) |   | | | |   └─Token(Identifier) |i|
//@[067:0068) |   | | | └─Token(RightSquare) |]|
//@[068:0069) |   | | ├─Token(Dot) |.|
//@[069:0079) |   | | └─IdentifierSyntax
//@[069:0079) |   | |   └─Token(Identifier) |properties|
//@[079:0080) |   | ├─Token(Dot) |.|
//@[080:0094) |   | └─IdentifierSyntax
//@[080:0094) |   |   └─Token(Identifier) |enableFreeTier|
//@[094:0095) |   └─Token(RightSquare) |]|
//@[095:0099) ├─Token(NewLine) |\r\n\r\n|

output indirectionAccessTier string = otherMod.outputs.storage.properties.accessTier
//@[000:0084) ├─OutputDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |output|
//@[007:0028) | ├─IdentifierSyntax
//@[007:0028) | | └─Token(Identifier) |indirectionAccessTier|
//@[029:0035) | ├─SimpleTypeSyntax
//@[029:0035) | | └─Token(Identifier) |string|
//@[036:0037) | ├─Token(Assignment) |=|
//@[038:0084) | └─PropertyAccessSyntax
//@[038:0073) |   ├─PropertyAccessSyntax
//@[038:0062) |   | ├─PropertyAccessSyntax
//@[038:0054) |   | | ├─PropertyAccessSyntax
//@[038:0046) |   | | | ├─VariableAccessSyntax
//@[038:0046) |   | | | | └─IdentifierSyntax
//@[038:0046) |   | | | |   └─Token(Identifier) |otherMod|
//@[046:0047) |   | | | ├─Token(Dot) |.|
//@[047:0054) |   | | | └─IdentifierSyntax
//@[047:0054) |   | | |   └─Token(Identifier) |outputs|
//@[054:0055) |   | | ├─Token(Dot) |.|
//@[055:0062) |   | | └─IdentifierSyntax
//@[055:0062) |   | |   └─Token(Identifier) |storage|
//@[062:0063) |   | ├─Token(Dot) |.|
//@[063:0073) |   | └─IdentifierSyntax
//@[063:0073) |   |   └─Token(Identifier) |properties|
//@[073:0074) |   ├─Token(Dot) |.|
//@[074:0084) |   └─IdentifierSyntax
//@[074:0084) |     └─Token(Identifier) |accessTier|
//@[084:0088) ├─Token(NewLine) |\r\n\r\n|

output policyType string = xMgMod.outputs.policy.properties.policyType
//@[000:0070) ├─OutputDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |output|
//@[007:0017) | ├─IdentifierSyntax
//@[007:0017) | | └─Token(Identifier) |policyType|
//@[018:0024) | ├─SimpleTypeSyntax
//@[018:0024) | | └─Token(Identifier) |string|
//@[025:0026) | ├─Token(Assignment) |=|
//@[027:0070) | └─PropertyAccessSyntax
//@[027:0059) |   ├─PropertyAccessSyntax
//@[027:0048) |   | ├─PropertyAccessSyntax
//@[027:0041) |   | | ├─PropertyAccessSyntax
//@[027:0033) |   | | | ├─VariableAccessSyntax
//@[027:0033) |   | | | | └─IdentifierSyntax
//@[027:0033) |   | | | |   └─Token(Identifier) |xMgMod|
//@[033:0034) |   | | | ├─Token(Dot) |.|
//@[034:0041) |   | | | └─IdentifierSyntax
//@[034:0041) |   | | |   └─Token(Identifier) |outputs|
//@[041:0042) |   | | ├─Token(Dot) |.|
//@[042:0048) |   | | └─IdentifierSyntax
//@[042:0048) |   | |   └─Token(Identifier) |policy|
//@[048:0049) |   | ├─Token(Dot) |.|
//@[049:0059) |   | └─IdentifierSyntax
//@[049:0059) |   |   └─Token(Identifier) |properties|
//@[059:0060) |   ├─Token(Dot) |.|
//@[060:0070) |   └─IdentifierSyntax
//@[060:0070) |     └─Token(Identifier) |policyType|
//@[070:0074) ├─Token(NewLine) |\r\n\r\n|

output id9 string = arrayMod[9].outputs.storage.id
//@[000:0050) ├─OutputDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |output|
//@[007:0010) | ├─IdentifierSyntax
//@[007:0010) | | └─Token(Identifier) |id9|
//@[011:0017) | ├─SimpleTypeSyntax
//@[011:0017) | | └─Token(Identifier) |string|
//@[018:0019) | ├─Token(Assignment) |=|
//@[020:0050) | └─PropertyAccessSyntax
//@[020:0047) |   ├─PropertyAccessSyntax
//@[020:0039) |   | ├─PropertyAccessSyntax
//@[020:0031) |   | | ├─ArrayAccessSyntax
//@[020:0028) |   | | | ├─VariableAccessSyntax
//@[020:0028) |   | | | | └─IdentifierSyntax
//@[020:0028) |   | | | |   └─Token(Identifier) |arrayMod|
//@[028:0029) |   | | | ├─Token(LeftSquare) |[|
//@[029:0030) |   | | | ├─IntegerLiteralSyntax
//@[029:0030) |   | | | | └─Token(Integer) |9|
//@[030:0031) |   | | | └─Token(RightSquare) |]|
//@[031:0032) |   | | ├─Token(Dot) |.|
//@[032:0039) |   | | └─IdentifierSyntax
//@[032:0039) |   | |   └─Token(Identifier) |outputs|
//@[039:0040) |   | ├─Token(Dot) |.|
//@[040:0047) |   | └─IdentifierSyntax
//@[040:0047) |   |   └─Token(Identifier) |storage|
//@[047:0048) |   ├─Token(Dot) |.|
//@[048:0050) |   └─IdentifierSyntax
//@[048:0050) |     └─Token(Identifier) |id|
//@[050:0052) ├─Token(NewLine) |\r\n|
output publicAccess9 string = arrayMod[9].outputs.container.properties.publicAccess
//@[000:0083) ├─OutputDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |output|
//@[007:0020) | ├─IdentifierSyntax
//@[007:0020) | | └─Token(Identifier) |publicAccess9|
//@[021:0027) | ├─SimpleTypeSyntax
//@[021:0027) | | └─Token(Identifier) |string|
//@[028:0029) | ├─Token(Assignment) |=|
//@[030:0083) | └─PropertyAccessSyntax
//@[030:0070) |   ├─PropertyAccessSyntax
//@[030:0059) |   | ├─PropertyAccessSyntax
//@[030:0049) |   | | ├─PropertyAccessSyntax
//@[030:0041) |   | | | ├─ArrayAccessSyntax
//@[030:0038) |   | | | | ├─VariableAccessSyntax
//@[030:0038) |   | | | | | └─IdentifierSyntax
//@[030:0038) |   | | | | |   └─Token(Identifier) |arrayMod|
//@[038:0039) |   | | | | ├─Token(LeftSquare) |[|
//@[039:0040) |   | | | | ├─IntegerLiteralSyntax
//@[039:0040) |   | | | | | └─Token(Integer) |9|
//@[040:0041) |   | | | | └─Token(RightSquare) |]|
//@[041:0042) |   | | | ├─Token(Dot) |.|
//@[042:0049) |   | | | └─IdentifierSyntax
//@[042:0049) |   | | |   └─Token(Identifier) |outputs|
//@[049:0050) |   | | ├─Token(Dot) |.|
//@[050:0059) |   | | └─IdentifierSyntax
//@[050:0059) |   | |   └─Token(Identifier) |container|
//@[059:0060) |   | ├─Token(Dot) |.|
//@[060:0070) |   | └─IdentifierSyntax
//@[060:0070) |   |   └─Token(Identifier) |properties|
//@[070:0071) |   ├─Token(Dot) |.|
//@[071:0083) |   └─IdentifierSyntax
//@[071:0083) |     └─Token(Identifier) |publicAccess|
//@[083:0085) ├─Token(NewLine) |\r\n|
output dbs9FreeTier array = [for i in range(0, 3): arrayMod[9].outputs.dbs[i].properties.enableFreeTier]
//@[000:0104) ├─OutputDeclarationSyntax
//@[000:0006) | ├─Token(Identifier) |output|
//@[007:0019) | ├─IdentifierSyntax
//@[007:0019) | | └─Token(Identifier) |dbs9FreeTier|
//@[020:0025) | ├─SimpleTypeSyntax
//@[020:0025) | | └─Token(Identifier) |array|
//@[026:0027) | ├─Token(Assignment) |=|
//@[028:0104) | └─ForSyntax
//@[028:0029) |   ├─Token(LeftSquare) |[|
//@[029:0032) |   ├─Token(Identifier) |for|
//@[033:0034) |   ├─LocalVariableSyntax
//@[033:0034) |   | └─IdentifierSyntax
//@[033:0034) |   |   └─Token(Identifier) |i|
//@[035:0037) |   ├─Token(Identifier) |in|
//@[038:0049) |   ├─FunctionCallSyntax
//@[038:0043) |   | ├─IdentifierSyntax
//@[038:0043) |   | | └─Token(Identifier) |range|
//@[043:0044) |   | ├─Token(LeftParen) |(|
//@[044:0045) |   | ├─FunctionArgumentSyntax
//@[044:0045) |   | | └─IntegerLiteralSyntax
//@[044:0045) |   | |   └─Token(Integer) |0|
//@[045:0046) |   | ├─Token(Comma) |,|
//@[047:0048) |   | ├─FunctionArgumentSyntax
//@[047:0048) |   | | └─IntegerLiteralSyntax
//@[047:0048) |   | |   └─Token(Integer) |3|
//@[048:0049) |   | └─Token(RightParen) |)|
//@[049:0050) |   ├─Token(Colon) |:|
//@[051:0103) |   ├─PropertyAccessSyntax
//@[051:0088) |   | ├─PropertyAccessSyntax
//@[051:0077) |   | | ├─ArrayAccessSyntax
//@[051:0074) |   | | | ├─PropertyAccessSyntax
//@[051:0070) |   | | | | ├─PropertyAccessSyntax
//@[051:0062) |   | | | | | ├─ArrayAccessSyntax
//@[051:0059) |   | | | | | | ├─VariableAccessSyntax
//@[051:0059) |   | | | | | | | └─IdentifierSyntax
//@[051:0059) |   | | | | | | |   └─Token(Identifier) |arrayMod|
//@[059:0060) |   | | | | | | ├─Token(LeftSquare) |[|
//@[060:0061) |   | | | | | | ├─IntegerLiteralSyntax
//@[060:0061) |   | | | | | | | └─Token(Integer) |9|
//@[061:0062) |   | | | | | | └─Token(RightSquare) |]|
//@[062:0063) |   | | | | | ├─Token(Dot) |.|
//@[063:0070) |   | | | | | └─IdentifierSyntax
//@[063:0070) |   | | | | |   └─Token(Identifier) |outputs|
//@[070:0071) |   | | | | ├─Token(Dot) |.|
//@[071:0074) |   | | | | └─IdentifierSyntax
//@[071:0074) |   | | | |   └─Token(Identifier) |dbs|
//@[074:0075) |   | | | ├─Token(LeftSquare) |[|
//@[075:0076) |   | | | ├─VariableAccessSyntax
//@[075:0076) |   | | | | └─IdentifierSyntax
//@[075:0076) |   | | | |   └─Token(Identifier) |i|
//@[076:0077) |   | | | └─Token(RightSquare) |]|
//@[077:0078) |   | | ├─Token(Dot) |.|
//@[078:0088) |   | | └─IdentifierSyntax
//@[078:0088) |   | |   └─Token(Identifier) |properties|
//@[088:0089) |   | ├─Token(Dot) |.|
//@[089:0103) |   | └─IdentifierSyntax
//@[089:0103) |   |   └─Token(Identifier) |enableFreeTier|
//@[103:0104) |   └─Token(RightSquare) |]|
//@[104:0106) ├─Token(NewLine) |\r\n|

//@[000:0000) └─Token(EndOfFile) ||
