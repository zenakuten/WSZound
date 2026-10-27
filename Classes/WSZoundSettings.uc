//-----------------------------------------------------------
// On-disk store for the client side settings.
//
// PerObjectConfig names the ini section after the object and the class
// ("[WSZoundClient WSZoundSettings]") instead of after the package
// ("[WSZound.WSZoundClient]"). The package name changes every time the version
// is bumped, which orphaned the whole section and dropped the player's
// settings back to defaults; the object name never changes.
//-----------------------------------------------------------
// ZCTriggers lives in WSZoundClient, which has to be parsed first for the
// reference below to resolve - hence the dependson.
class WSZoundSettings extends Object
    Config(WSZoundClient)
    PerObjectConfig
    dependson(WSZoundClient);

var config bool ZoundInitial;
var config bool ZoundEnabled;
var config int ZoundMenuKey;
var config int ZoundVolume;
var config bool bMuteLongZounds;
var config float MaxZoundSeconds;
var config array<WSZoundClient.ZCTriggers> ZoundServer;

defaultproperties
{
    ZoundMenuKey=35
    ZoundVolume=80
    MaxZoundSeconds=10.000000
}
