class WSZoundClient extends Interaction
    config(WSZoundClient);

struct ZCTriggers
{
    var string ServerID;
    var string MutedWords;
    var string Favourites;
};

var config bool ZoundInitial;
var config bool ZoundEnabled;
var config int ZoundMenuKey;
var config int ZoundVolume;
var config bool bMuteLongZounds;
var config float MaxZoundSeconds;
var string KeyBind[125];
var() config array<ZCTriggers> ZoundServer;
var() string MyServerID;
var string MesgLogon;
var string MesgBind;
var bool bShowMesg;
var bool bMesgDone;
var bool bMyInit;
var float MyTime;

function Initialized()
{
    local string sBind;

    if(!ZoundInitial)
    {
        default.ZoundInitial = true;
        default.ZoundEnabled = true;
        default.ZoundMenuKey = 35;
        default.ZoundVolume = 80;
        default.MaxZoundSeconds = 10.0000000;
        self.StaticSaveConfig();
    }
    SetKeyBindList();
    sBind = KeyBind[default.ZoundMenuKey];
    MesgLogon = "- This server uses Zound -";
    if(sBind != "")
    {
        MesgBind = ("- ZoundMenu Keybind on " $ sBind) $ " key -";
    }
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
    if(MyTime == float(20))
    {
        Disable('Tick');
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
}