class WSZoundClient extends Interaction;

struct ZCTriggers
{
    var string ServerID;
    var string MutedWords;
    var string Favourites;
};

// In-memory copy only. The ini side of these lives in WSZoundSettings, which is
// where LoadZoundConfig and SaveZoundConfig read and write them.
var bool ZoundInitial;
var bool ZoundEnabled;
var int ZoundMenuKey;
var int ZoundVolume;
var bool bMuteLongZounds;
var float MaxZoundSeconds;
var string KeyBind[125];
var() array<ZCTriggers> ZoundServer;

var WSZoundSettings Settings;
var() string MyServerID;
var string MesgLogon;
var string MesgBind;
var bool bShowMesg;
var bool bMesgDone;
var bool bMyInit;
var float MyTime;
var string MenuCmd;

// The settings object is created with a fixed name, so it always maps to the
// same ini section no matter what the package is called. Held on the class
// default so every caller shares the one instance.
static function WSZoundSettings GetSettings()
{
    if(default.Settings == none)
    {
        default.Settings = new(none, "WSZoundClient") class'WSZoundSettings';
    }
    return default.Settings;
}

// Position of Entry in a comma-terminated list ("a,b,c,"), matched as a whole entry, or
// -1. A plain InStr(List, Entry $ ",") also matched the tail of a longer entry, so
// muting LEON-GOODBYE muted BYE too. The index is where the entry starts in List.
static final function int FindListEntry(string List, string Entry)
{
    return InStr("," $ List, ("," $ Entry) $ ",");
}

static function LoadZoundConfig()
{
    local WSZoundSettings S;
    local int i;

    S = GetSettings();
    default.ZoundInitial = S.ZoundInitial;
    default.ZoundEnabled = S.ZoundEnabled;
    default.ZoundMenuKey = S.ZoundMenuKey;
    default.ZoundVolume = S.ZoundVolume;
    default.bMuteLongZounds = S.bMuteLongZounds;
    default.MaxZoundSeconds = S.MaxZoundSeconds;
    default.ZoundServer.Length = S.ZoundServer.Length;
    for(i = 0; i < S.ZoundServer.Length; i++)
    {
        default.ZoundServer[i] = S.ZoundServer[i];
    }
}

static function SaveZoundConfig()
{
    local WSZoundSettings S;
    local int i;

    S = GetSettings();
    S.ZoundInitial = default.ZoundInitial;
    S.ZoundEnabled = default.ZoundEnabled;
    S.ZoundMenuKey = default.ZoundMenuKey;
    S.ZoundVolume = default.ZoundVolume;
    S.bMuteLongZounds = default.bMuteLongZounds;
    S.MaxZoundSeconds = default.MaxZoundSeconds;
    S.ZoundServer.Length = default.ZoundServer.Length;
    for(i = 0; i < default.ZoundServer.Length; i++)
    {
        S.ZoundServer[i] = default.ZoundServer[i];
    }
    S.SaveConfig();
}

function Initialized()
{
    LoadZoundConfig();
    if(!default.ZoundInitial)
    {
        default.ZoundInitial = true;
        default.ZoundEnabled = true;
        default.ZoundMenuKey = 35;
        default.ZoundVolume = 80;
        default.MaxZoundSeconds = 10.0000000;
        SaveZoundConfig();
    }
    SetKeyBindList();
    MesgLogon = "- This server uses Zound -";
    SetMenuKeyMessage();
    MyTime = 0.0300000;
    ClientLogon();
    Enable('Tick');
    bShowMesg = true;
}

function bool KeyEvent(out Interactions.EInputKey Key, out Interactions.EInputAction Action, float Delta)
{
    local PlayerController PLC;

    PLC = ViewportOwner.Actor;
    if(Action != IST_Press)
    {
        return false;        
    }
    else
    {
        if((int(Key) == default.ZoundMenuKey) && default.ZoundMenuKey != 0)
        {
            PLC.ConsoleCommand("Mutate ZoundMenu");
            return true;
        }
    }
    return false;
}

function SetMenuKeyMessage()
{
    local string sBind;

    sBind = "";
    if(default.ZoundMenuKey != 0)
    {
        sBind = KeyBind[default.ZoundMenuKey];
    }
    if(sBind != "")
    {
        MesgBind = ("- ZoundMenu Keybind on " $ sBind) $ " key -";
    }
    else
    {
        MesgBind = ("- ZoundMenu has no key - type: " $ MenuCmd) $ " -";
    }
}

function Tick(float Delta)
{
    MyTime += Delta;
    if((MyTime >= float(3)) && !bMyInit)
    {
        bMyInit = true;
        ClientLogon();
    }
    if((MyTime > float(10)) && !bMesgDone)
    {
        bMesgDone = true;
        bShowMesg = false;
    }
    // Nothing is left to do after the logon and the join message, so stop the
    // per-frame Tick and PostRender. Interactions ignore Disable('Tick'), and the old
    // MyTime == 20 test was never exactly true. KeyEvent still runs (bActive).
    if(bMyInit && bMesgDone)
    {
        bRequiresTick = false;
        bVisible = false;
    }
}

function ClientLogon()
{
    local string sTemp;

    GetServerIP();
    // Mutes are no longer uploaded. The mute check is done client-side in
    // WSZoundSpawn.ClientPlayZound against the full local list, so only the
    // enabled flag and volume are sent to the server.
    if(default.ZoundEnabled == true)
    {
        sTemp = "1,";        
    }
    else
    {
        sTemp = "0,";
    }
    sTemp = (sTemp $ string(default.ZoundVolume)) $ ",";
    ViewportOwner.Actor.ConsoleCommand("Mutate ZoundClientLogon-" $ sTemp);
}

function string GetMutedWords()
{
    local string sTemp;
    local int i, j;

    j = default.ZoundServer.Length;
    if(j == 0)
    {
        return "";
    }
    sTemp = "";
    for(i = 0; i < j; i++)
    {
        if(default.ZoundServer[i].ServerID == default.MyServerID)
        {
            sTemp = default.ZoundServer[i].MutedWords;
            break;
        }
    }
    return sTemp;
}

function GetServerIP()
{
    local string sTemp;
    local int i;

    sTemp = ViewportOwner.Actor.GetServerNetworkAddress();
    i = InStr(sTemp, ".");
    while(i != -1)
    {
        sTemp = Left(sTemp, i) $ Mid(sTemp, i + 1);
        i = InStr(sTemp, ".");
    }
    i = InStr(sTemp, ":");
    if(i != -1)
    {
        sTemp = Left(sTemp, i) $ Mid(sTemp, i + 1);
    }
    if(sTemp == "")
    {
        sTemp = "Local";
    }
    default.MyServerID = sTemp;
}

function PostRender(Canvas C)
{
    local PlayerController PLC;
    local bool bMiddle;

    PLC = ViewportOwner.Actor;
    if(PLC == none)
    {
        return;
    }
    if(PLC.IsInState('GameEnded'))
    {
        return;
    }
    bMiddle = C.bCenter;
    C.bCenter = true;
    if(bShowMesg)
    {
        C.DrawColor.R = 250;
        C.DrawColor.G = 250;
        C.DrawColor.B = 0;
        if(int(C.DrawColor.A) > 10)
        {
            C.DrawColor.A = byte(float(255) - (float(25) * MyTime));
        }
        C.Font = PLC.myHUD.GetFontSizeIndex(C, -2);
        C.SetPos(0.0000000, (C.ClipY / float(8)) * 6.8300000);
        C.DrawText(MesgLogon);
        C.SetPos(0.0000000, (C.ClipY / float(8)) * 7.0500000);
        C.DrawText(MesgBind);
    }
    C.bCenter = bMiddle;
}

function SetKeyBindList()
{
    local int i;

    for(i = 0; i < 125; i++)
    {
        KeyBind[i] = "";
    }
    KeyBind[0] = "None";
    KeyBind[32] = "SpaceBar";
    KeyBind[33] = "PageUp";
    KeyBind[34] = "PageDn";
    KeyBind[35] = "End";
    KeyBind[36] = "Home";
    KeyBind[37] = "Left";
    KeyBind[38] = "Up";
    KeyBind[39] = "Right";
    KeyBind[40] = "Down";
    KeyBind[44] = "PrintScn";
    KeyBind[45] = "Insert";
    KeyBind[46] = "Delete";
    KeyBind[65] = "A";
    KeyBind[66] = "B";
    KeyBind[67] = "C";
    KeyBind[68] = "D";
    KeyBind[69] = "E";
    KeyBind[70] = "F";
    KeyBind[71] = "G";
    KeyBind[72] = "H";
    KeyBind[73] = "I";
    KeyBind[74] = "J";
    KeyBind[75] = "K";
    KeyBind[76] = "L";
    KeyBind[77] = "M";
    KeyBind[78] = "N";
    KeyBind[79] = "O";
    KeyBind[80] = "P";
    KeyBind[81] = "Q";
    KeyBind[82] = "R";
    KeyBind[83] = "S";
    KeyBind[84] = "T";
    KeyBind[85] = "U";
    KeyBind[86] = "V";
    KeyBind[87] = "W";
    KeyBind[88] = "X";
    KeyBind[89] = "Y";
    KeyBind[90] = "Z";
    KeyBind[96] = "NumPad0";
    KeyBind[97] = "NumPad1";
    KeyBind[98] = "NumPad2";
    KeyBind[99] = "NumPad3";
    KeyBind[100] = "NumPad4";
    KeyBind[101] = "NumPad5";
    KeyBind[102] = "NumPad6";
    KeyBind[103] = "NumPad7";
    KeyBind[104] = "NumPad8";
    KeyBind[105] = "NumPad9";
    KeyBind[106] = "GreyStar";
    KeyBind[107] = "GreyPlus";
    KeyBind[109] = "GreyMinus";
    KeyBind[111] = "GreySlash";
    KeyBind[112] = "F1";
    KeyBind[113] = "F2";
    KeyBind[114] = "F3";
    KeyBind[115] = "F4";
    KeyBind[116] = "F5";
    KeyBind[117] = "F6";
    KeyBind[118] = "F7";
    KeyBind[119] = "F8";
    KeyBind[120] = "F9";
    KeyBind[121] = "F10";
    KeyBind[122] = "F11";
    KeyBind[123] = "F12";
}

function NotifyLevelChange()
{
    bRequiresTick = false;
    Disable('Tick');
    Master.RemoveInteraction(self);
}

defaultproperties
{
    bVisible=true
    bRequiresTick=true
    MenuCmd="mutate zoundmenu"
}
