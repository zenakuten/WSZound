class MutWSZound extends Mutator
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force);

var string ZoundPass;
var bool bZound;
var bool ShowTrigger;
var bool ShowToSelf;
var bool bAnnounce;
var bool AnnounceOnce;
var bool bNoSpecPlayer;
var bool b24HourTime;
var bool InGameZound;
var bool bChatLog;
var bool bChatFilter;
var bool bPlayerList;
var bool bBotsTalk;
var int SoundDelay;
var int LoginDelay;
var int DelaysEach;
var int SoundsEach;
var int RepeatDelay;
var int TrigTimeout;
var bool bInitialized;
var int SoundTime;
var bool bHide;
var bool bDedicated;
var bool bHashID;
var bool bLoadRepln;
var bool bStartup;
var int CurrentID;
var int MySeconds;
var int ZPlayers;
var int NumTrigsA;
var int NumTrigsB;
var PlayerController ZoundController[51];
var string ZoundPlayerName[51];
var string ZoundPlayerHash[51];
var string ZoundPlayerMute[51];
var string ZoundPlayerShut[51];
var int ZoundPlayerKill[51];
var int ZoundPlayerGain[51];
var int ZoundPlayerLogID[51];
var int ZoundPlayerSound[51];
var int ZoundPlayerDelay[51];
var int ZoundPlayerTimer[51];
var string ZoundAdmin[51];
var string ZLastPlayers;
var string MySoundA[251];
var string MySoundB[251];
var string MySoundC[251];
var string MySoundD[251];
var string MySoundE[251];
var string MySoundF[251];
var string MySoundG[251];
var string MySoundH[251];
var WSZoundBHandler myHandler;
var WSZoundConfigs myConfigs;
var WSZoundChatLog myChatLog;
var WSZoundFilter myFilter;
var WSZoundTriggers myTrigs;
var WSZoundPlayerList myPlayList;
var WSZoundPlayerBan myBanList;
var WSZoundTime myTimes;
var WSZoundPlayers MyPlayers;
var WSZoundReplication ZRI;
var Sound SoundBuff[55];
var int PTypeBuff[55];
var string PTrigBuff[55];
var string PFromBuff[55];
var string LastZound[255];
var int LastCount[255];
var string TotPlayers[51];
var string TotTrigger[51];
var string sCode;
var Color Yellow;
var Color Cyan;

function PostBeginPlay()
{
    local int i;

    if(!bInitialized)
    {
        bInitialized = true;
        Log("<<< Starting Zound >>>");
        myHandler = Spawn(Class'WSZoundBHandler');
        myConfigs = Spawn(Class'WSZoundConfigs');
        myPlayList = Spawn(Class'WSZoundPlayerList');
        myBanList = Spawn(Class'WSZoundPlayerBan');
        myFilter = Spawn(Class'WSZoundFilter');
        myTrigs = Spawn(Class'WSZoundTriggers');
        myTimes = Spawn(Class'WSZoundTime');
        myChatLog = Spawn(Class'WSZoundChatLog');
        MyPlayers = Spawn(Class'WSZoundPlayers');
        myConfigs.myMut = self;
        myPlayList.myMut = self;
        myBanList.myMut = self;
        myTimes.myMut = self;
        myFilter.myMut = self;
        myTrigs.myMut = self;
        myHandler.myMut = self;
        MyPlayers.myMut = self;
        ZRI = Spawn(Class'WSZoundReplication');
        SoundTime = 0;
        myConfigs.LoadZoundConfigs();
        MyPlayers.LoadZoundPlayers();
        myTrigs.LoadSounds();
        myTrigs.LoadNames();
        if(Level.NetMode != NM_DedicatedServer)
        {
            LoginDelay = 1;
        }
        if(DelaysEach < 0)
        {
            DelaysEach = 0;
        }
        if(SoundDelay < 0)
        {
            SoundDelay = 0;
        }
        for(i = 0; i < 50; i++)
        {
            ZoundPlayerName[i] = "";
            ZoundPlayerHash[i] = "";
            ZoundPlayerMute[i] = "";
            ZoundPlayerShut[i] = "";
            ZoundPlayerSound[i] = 0;
            ZoundPlayerDelay[i] = 0;
            ZoundPlayerTimer[i] = 0;
            ZoundPlayerLogID[i] = -1;
            ZoundPlayerKill[i] = 0;
            ZoundPlayerGain[i] = 0;
            ZoundController[i] = none;
            ZoundAdmin[i] = "";
            SoundBuff[i] = none;
            PTypeBuff[i] = 0;
            PTrigBuff[i] = "";
            PFromBuff[i] = "";
        }
        SoundBuff[50] = none;
        PTypeBuff[50] = 0;
        PTrigBuff[50] = "";
        PFromBuff[50] = "";
        for(i = 0; i < 255; i++)
        {
            LastZound[i] = "";
            LastCount[i] = 0;
        }
        if(TrigTimeout == 0)
        {
            TrigTimeout = 10;
        }
        if(Level.NetMode == NM_Standalone)
        {
            TrigTimeout = 10;
        }
        myTrigs.PreloadCustomSounds();
        MySeconds = 0;
        bLoadRepln = true;
        bStartup = true;
        SetTimer(1.0000000, true);
        if(RepeatDelay > 600)
        {
            RepeatDelay = 600;
        }
        i = Rand(900);
        if(i < 100)
        {
            i += 100;
        }
        sCode = string(i);
    }
    super(Actor).PostBeginPlay();
}

function LoadReplicationInfo()
{
    local int i;

    if(ZRI == none)
    {
        ZRI = Spawn(Class'WSZoundReplication');
    }
    for(i = 0; i < 250; i++)
    {
        ZRI.SoundA[i] = MySoundA[i];
    }
    for(i = 0; i < 250; i++)
    {
        ZRI.SoundB[i] = MySoundB[i];
    }
    for(i = 0; i < 250; i++)
    {
        ZRI.SoundC[i] = MySoundC[i];
    }
    for(i = 0; i < 250; i++)
    {
        ZRI.SoundD[i] = MySoundD[i];
    }
    for(i = 0; i < 250; i++)
    {
        ZRI.SoundE[i] = MySoundE[i];
    }
    for(i = 0; i < 250; i++)
    {
        ZRI.SoundF[i] = MySoundF[i];
    }
    for(i = 0; i < 250; i++)
    {
        ZRI.SoundG[i] = MySoundG[i];
    }
    for(i = 0; i < 250; i++)
    {
        ZRI.SoundH[i] = MySoundH[i];
    }
    ZRI.Dummy++;
}

function ModifyPlayer(Pawn Other)
{
    local Controller C;

    C = Other.Controller;
    if((C != none) && C.PlayerReplicationInfo != none)
    {
        if(!C.PlayerReplicationInfo.bBot && bStartup)
        {
            bStartup = false;
            MySeconds = 0;
        }
    }
    super.ModifyPlayer(Other);
}

function SetClientClass(PlayerController PC)
{
    local WSZoundSpawn ZSRI;

    if(PC == none)
    {
        return;
    }
    foreach DynamicActors(Class'WSZoundSpawn', ZSRI)
    {
        if(PC == ZSRI.Owner)
        {
            ZSRI.Destroy();
        }        
    }    
    ZSRI = Spawn(Class'WSZoundSpawn', PC);
    ZSRI.PLC = PC;
    ZSRI.Dummy++;
    Log(((GetDateTime(true)) $ " SetClientClass for: ") $ PC.PlayerReplicationInfo.PlayerName, 'Zound');
}

function CenterMessage(PlayerController Sender, string Mesg, Color cColr, int Time)
{
    if(Sender != none)
    {
        if(myBanList.CheckBanList(Sender))
        {
            return;
        }
        Sender.ClearProgressMessages();
        if(Mesg != " ")
        {
            Sender.SetProgressTime(float(Time));
            Sender.SetProgressMessage(0, Mesg, cColr);
        }
    }
}

event Tick(float DeltaTime)
{
    local Controller C;

    super(Actor).Tick(DeltaTime);
    if(Level.Game.NumPlayers != ZPlayers)
    {
        ZPlayers = Level.Game.NumPlayers;
        LoadRepPlayers();
    }
    if(Level.Game.CurrentID > CurrentID)
    {
        for(C = Level.ControllerList; C != none; C = C.nextController)
        {
            if((C != none) && C.PlayerReplicationInfo != none)
            {
                if(C.PlayerReplicationInfo.PlayerID == CurrentID)
                {
                    break;
                }
            }
        }
        CurrentID++;
        if((C != none) && C.PlayerReplicationInfo != none)
        {
            if(C.PlayerReplicationInfo.bBot)
            {
                return;
            }
            if(C.IsA('PlayerController'))
            {
                if(MessagingSpectator(C) == none)
                {
                    SetClientClass(PlayerController(C));
                }
            }
        }
    }
}

function LoadRepPlayers()
{
    local Controller C;
    local int X;

    for(X = 0; X < 32; X++)
    {
        ZRI.Players[X] = "";
    }
    X = 0;
    for(C = Level.ControllerList; C != none; C = C.nextController)
    {
        if((C.IsA('PlayerController') && MessagingSpectator(C) == none) && C.PlayerReplicationInfo.PlayerName != "WebAdmin")
        {
            if(!C.PlayerReplicationInfo.bOnlySpectator && C.PlayerReplicationInfo.PlayerName != "DemoRecSpectator")
            {
                ZRI.Players[X] = C.PlayerReplicationInfo.PlayerName;
                X++;
            }
        }
    }
    ZRI.Dummy++;
}

function bool CheckForNoZound(PlayerController PC)
{
    local string sNick;
    local int i;

    if(PC == none)
    {
        return false;
    }
    sNick = PC.PlayerReplicationInfo.PlayerName;
    for(i = 0; i < 50; i++)
    {
        if(ZoundPlayerName[i] == sNick)
        {
            if(ZoundPlayerKill[i] == 0)
            {
                return true;
                continue;
            }
            return false;
        }
    }
    return false;
}

function SetupMuted(PlayerController PC, string sMute, bool bPlayer)
{
    local string sTemp, sNick;
    local int i;

    if(PC == none)
    {
        return;
    }
    sNick = PC.PlayerReplicationInfo.PlayerName;
    sTemp = "";
    for(i = 0; i < 50; i++)
    {
        if(ZoundPlayerName[i] == sNick)
        {
            if(bPlayer)
            {
                if(sMute == "None")
                {
                    sMute = "";
                }
                ZoundPlayerShut[i] = sMute;
                return;
            }
            if(sMute != "")
            {
                sTemp = Mid(sMute, Len(sMute) - 1);
                if(sTemp != ",")
                {
                    sMute = sMute $ ",";
                }
                ZoundPlayerMute[i] = sMute;
                return;
            }
        }
    }
}

function bool CheckMuted(PlayerController PC, string sTrig, string sWho)
{
    local string sTemp, sNick;
    local int i;

    if(PC == none)
    {
        return true;
    }
    if(sTrig == "")
    {
        return false;
    }
    sNick = PC.PlayerReplicationInfo.PlayerName;
    for(i = 0; i < 50; i++)
    {
        if(ZoundPlayerName[i] == sNick)
        {
            sTemp = ZoundPlayerMute[i];
            if(InStr(sTemp, sTrig $ ",") != -1)
            {
                return true;
            }
            if((ZoundPlayerShut[i] != "") && ZoundPlayerShut[i] == sWho)
            {
                return true;
            }
            break;
        }
    }
    return false;
}

function int GetClientGain(PlayerController PC)
{
    local string sNick;
    local int i;

    if(PC == none)
    {
        return 0;
    }
    sNick = PC.PlayerReplicationInfo.PlayerName;
    for(i = 0; i < 50; i++)
    {
        if(ZoundPlayerName[i] == sNick)
        {
            return ZoundPlayerGain[i];
        }
    }
    return 0;
}

// Returns the owner-only replicated actor for a player, used to route a zound
// through the client (where the mute check now happens). Found by owner so it
// survives respawns; falls back to none (caller then plays server-side).
function WSZoundSpawn GetZoundSpawn(PlayerController PC)
{
    local WSZoundSpawn ZS;

    if(PC == none)
    {
        return none;
    }
    foreach DynamicActors(Class'WSZoundSpawn', ZS)
    {
        if(ZS.Owner == PC)
        {
            return ZS;
        }
    }
    return none;
}

// Routes a resolved zound to a player through their client actor so the mute
// check happens client-side (full, uncapped list). Falls back to server-side
// play when the actor is not available (e.g. player just joined).
function PlayZoundTo(PlayerController PC, Sound MySound, float MyGain, string sTrig)
{
    local WSZoundSpawn ZS;

    if((PC == none) || MySound == none)
    {
        return;
    }
    ZS = GetZoundSpawn(PC);
    if(PC == Level.GetLocalPlayerController())
    {
        if((ZS != none) && (ZS.ZoundIsMuted(sTrig) || ZS.ZoundIsTooLong(MySound)))
        {
            return;
        }
        PC.ClientPlaySound(MySound, true, MyGain);
        return;
    }
    if(ZS != none)
    {
        ZS.ClientPlayZound(MySound, MyGain, sTrig);
    }
    else
    {
        PC.ClientPlaySound(MySound, true, MyGain);
    }
}

function Timer()
{
    local Sound MySound;
    local string sTemp;
    local float MyGain;
    local int i, j;

    super(Actor).Timer();
    MySeconds++;
    if((MySeconds >= 3) && bLoadRepln)
    {
        bLoadRepln = false;
        LoadReplicationInfo();
        MySeconds = 0;
    }
    if(SoundTime > 0)
    {
        SoundTime--;
    }
    if((SoundTime == 0) && SoundBuff[0] != none)
    {
        BroadcastSound(SoundBuff[0], PTypeBuff[0], PTrigBuff[0], PFromBuff[0]);
        for(i = 0; i < 51; i++)
        {
            SoundBuff[i] = SoundBuff[i + 1];
            PTypeBuff[i] = PTypeBuff[i + 1];
            PTrigBuff[i] = PTrigBuff[i + 1];
            PFromBuff[i] = PFromBuff[i + 1];
        }
    }
    for(i = 0; i < 50; i++)
    {
        if(ZoundPlayerDelay[i] > 0)
        {
            ZoundPlayerDelay[i]--;
        }
        if(ZoundPlayerTimer[i] > 0)
        {
            ZoundPlayerTimer[i]--;
            if(ZoundPlayerTimer[i] == 0)
            {
                if(!myBanList.CheckBanList(ZoundController[i]))
                {
                    if(CheckForNoZound(ZoundController[i]))
                    {
                        ZoundController[i].ClientMessage("< Zound is Disabled >");
                        continue;
                    }
                    ZoundController[i].ClientMessage("< Zound is Enabled >");
                    if(bAnnounce)
                    {
                        j = -1;
                        if(AnnounceOnce)
                        {
                            j = InStr(ZLastPlayers, ZoundPlayerName[i]);
                        }
                        if(j == -1)
                        {
                            sTemp = ZoundPlayerName[i];
                            MySound = GetCustomSound(sTemp, ZoundController[i], false, true);
                            if(MySound == none)
                            {
                                sTemp = "PlayerEnter";
                                MySound = GetCustomSound(sTemp, ZoundController[i], false, true);
                            }
                        }
                        if(MySound != none)
                        {
                            if(!CheckMuted(ZoundController[i], sTemp, ""))
                            {
                                MyGain = GetMyVolume(ZoundController[i]);
                                PlayZoundTo(ZoundController[i], MySound, MyGain, sTemp);
                            }
                        }
                    }
                }
            }
        }
    }
    for(i = 0; i < 255; i++)
    {
        if(LastZound[i] != "")
        {
            LastCount[i]--;
            if(LastCount[i] <= 0)
            {
                LastZound[i] = "";
                LastCount[i] = 0;
            }
        }
    }
}

function AddToSoundBuff(Sound MySound, int PL, string sTrig, string sNick)
{
    local int j;

    for(j = 0; j < 50; j++)
    {
        if(SoundBuff[j] == none)
        {
            SoundBuff[j] = MySound;
            PTypeBuff[j] = PL;
            PTrigBuff[j] = sTrig;
            PFromBuff[j] = sNick;
            break;
        }
    }
}

function BroadcastSound(Sound MySound, optional int iNum, optional string sTrig, optional string FromWho)
{
    local Controller C;
    local float MyGain;

    if(SoundTime > 0)
    {
        return;
    }
    if(!bZound)
    {
        return;
    }
    if((!InGameZound && !Level.Game.bGameEnded) && !Level.Game.bWaitingToStartMatch)
    {
        return;
    }
    if(MySound == none)
    {
        return;
    }
    SoundTime = SoundDelay;
    for(C = Level.ControllerList; C != none; C = C.nextController)
    {
        if(((C != none) && C.IsA('PlayerController')) && !C.PlayerReplicationInfo.bBot)
        {
            if(myPlayList.CheckPlayerList(PlayerController(C), false) || CheckZoundAdmin(PlayerController(C)))
            {
                if(!CheckForNoZound(PlayerController(C)))
                {
                    if(!CheckMuted(PlayerController(C), sTrig, FromWho))
                    {
                        MyGain = GetMyVolume(PlayerController(C));
                        if(bNoSpecPlayer && iNum == 1)
                        {
                            if(C.PlayerReplicationInfo.bOnlySpectator)
                            {
                                PlayZoundTo(PlayerController(C), MySound, MyGain, sTrig);
                            }                            
                        }
                        else
                        {
                            if(bNoSpecPlayer && iNum == 2)
                            {
                                if(!C.PlayerReplicationInfo.bOnlySpectator)
                                {
                                    PlayZoundTo(PlayerController(C), MySound, MyGain, sTrig);
                                }                                
                            }
                            else
                            {
                                PlayZoundTo(PlayerController(C), MySound, MyGain, sTrig);
                            }
                        }
                    }
                }
            }
        }
    }
}

function float GetMyVolume(PlayerController Sender)
{
    local int Gn;
    local float fVol;

    Gn = GetClientGain(Sender);
    if(Gn == 0)
    {
        return 0.0000000;
    }
    fVol = float(Gn);
    fVol = fVol / float(100);
    return 2.0000000 * fVol;
}

function Sound GetCustomSound(string CustomSound, Controller Sender, bool bInGame, optional bool bDedicated)
{
    local Sound LoadSound;

    if(!CheckInGameZound(Sender))
    {
        return none;
    }
    if(Len(CustomSound) < 2)
    {
        return none;
    }
    if(Sender != none)
    {
        if(!myPlayList.CheckPlayerList(PlayerController(Sender), false) && !CheckZoundAdmin(PlayerController(Sender)))
        {
            return none;
        }
    }
    LoadSound = myTrigs.GetCustomSound(CustomSound, Sender, bInGame, bDedicated);
    if(LoadSound != none)
    {
        return LoadSound;
    }
    return none;
}

function DoChatLog(Controller Who, string Cmd)
{
    local string sTemp, sNick, DateTime;
    local int i;

    if(Who.PlayerReplicationInfo.bBot)
    {
        return;
    }
    sTemp = "                ";
    DateTime = GetDateTime(false);
    sNick = Who.PlayerReplicationInfo.PlayerName;
    i = Len(sNick);
    if(i < 16)
    {
        sNick = sNick $ Mid(sTemp, i);        
    }
    else
    {
        sNick = Left(sNick, 16);
    }
    myChatLog.WriteChatLog((((DateTime $ " - ") $ sNick) $ " : ") $ Cmd);
}

function string GetDateTime(bool bTimeOnly)
{
    local string AbsoluteTime;

    if(!bTimeOnly)
    {
        AbsoluteTime = string(Level.Year);
        if(Level.Month < 10)
        {
            AbsoluteTime = (AbsoluteTime $ "/0") $ string(Level.Month);            
        }
        else
        {
            AbsoluteTime = (AbsoluteTime $ "/") $ string(Level.Month);
        }
        if(Level.Day < 10)
        {
            AbsoluteTime = (AbsoluteTime $ "/0") $ string(Level.Day);            
        }
        else
        {
            AbsoluteTime = (AbsoluteTime $ "/") $ string(Level.Day);
        }
        AbsoluteTime = AbsoluteTime $ " - ";
    }
    if(Level.Hour < 10)
    {
        AbsoluteTime = (AbsoluteTime $ "0") $ string(Level.Hour);        
    }
    else
    {
        AbsoluteTime = AbsoluteTime $ string(Level.Hour);
    }
    if(Level.Minute < 10)
    {
        AbsoluteTime = (AbsoluteTime $ ":0") $ string(Level.Minute);        
    }
    else
    {
        AbsoluteTime = (AbsoluteTime $ ":") $ string(Level.Minute);
    }
    if(Level.Second < 10)
    {
        AbsoluteTime = (AbsoluteTime $ ":0") $ string(Level.Second);        
    }
    else
    {
        AbsoluteTime = (AbsoluteTime $ ":") $ string(Level.Second);
    }
    if(Level.Millisecond < 10)
    {
        AbsoluteTime = (AbsoluteTime $ ":00") $ string(Level.Millisecond);        
    }
    else
    {
        if(Level.Millisecond < 100)
        {
            AbsoluteTime = (AbsoluteTime $ ":0") $ string(Level.Millisecond);            
        }
        else
        {
            AbsoluteTime = (AbsoluteTime $ ":") $ string(Level.Millisecond);
        }
    }
    return AbsoluteTime;
}

function OpenZoundMenu(PlayerController Sender)
{
    local string Param1, Param2, sNick, MPlayer;
    local bool bAdmin;
    local int i, S;

    if(CheckZoundAdmin(Sender))
    {
        bAdmin = true;
    }
    if(!bZound && !bAdmin)
    {
        return;
    }
    if(!bAdmin && myBanList.CheckBanList(Sender))
    {
        Sender.ClientMessage("< You have been banned from using Zound! >");
        return;
    }
    sNick = Sender.PlayerReplicationInfo.PlayerName;
    if(bStartup)
    {
        bStartup = false;
        if(Level.Game.bWaitingToStartMatch)
        {
            MySeconds = 0;
            Log(((GetDateTime(true)) $ " OpenZoundMenu - Started Replication Timer by ") $ sNick, 'Zound');
        }
    }
    if(!myPlayList.CheckPlayerList(Sender, false) && !CheckZoundAdmin(Sender))
    {
        return;
    }
    Param1 = sCode $ ",";
    if(CheckZoundAdmin(Sender))
    {
        Param1 = Param1 $ "1,";        
    }
    else
    {
        Param1 = Param1 $ "0,";
    }
    if(CheckForNoZound(Sender))
    {
        Param1 = Param1 $ "0,";        
    }
    else
    {
        Param1 = Param1 $ "1,";
    }
    if(MySeconds < TrigTimeout)
    {
        Param1 = Param1 $ "1,";        
    }
    else
    {
        Param1 = Param1 $ "0,";
    }
    Param1 = (((Param1 $ string(NumTrigsA)) $ ",") $ string(NumTrigsB)) $ ",";
    S = 9999;
    for(i = 0; i < 50; i++)
    {
        if(ZoundPlayerName[i] == sNick)
        {
            MPlayer = ZoundPlayerShut[i];
            if(MPlayer == "")
            {
                MPlayer = "None";
            }
            if(!bAdmin && SoundsEach != 0)
            {
                S = SoundsEach - ZoundPlayerSound[i];
            }
            if(S < 0)
            {
                S = 0;
            }
            break;
        }
    }
    Param2 = ((MPlayer $ ",") $ string(S)) $ ",";
    Sender.ClientOpenMenu("WSZound.WSZoundMenuTrigs", false, Param1, Param2);
}

function OpenAdminMenu(PlayerController Sender)
{
    local string Param1, Param2;
    local Controller C;
    local bool bAdmin;

    if(Sender == none)
    {
        return;
    }
    if(!CheckZoundAdmin(Sender))
    {
        return;
    }
    bAdmin = true;
    Param1 = sCode $ ",";
    if(bZound)
    {
        Param1 = Param1 $ "1,";        
    }
    else
    {
        Param1 = Param1 $ "0,";
    }
    if(ShowTrigger)
    {
        Param1 = Param1 $ "1,";        
    }
    else
    {
        Param1 = Param1 $ "0,";
    }
    if(ShowToSelf)
    {
        Param1 = Param1 $ "1,";        
    }
    else
    {
        Param1 = Param1 $ "0,";
    }
    if(bAnnounce)
    {
        Param1 = Param1 $ "1,";        
    }
    else
    {
        Param1 = Param1 $ "0,";
    }
    if(AnnounceOnce)
    {
        Param1 = Param1 $ "1,";        
    }
    else
    {
        Param1 = Param1 $ "0,";
    }
    if(bBotsTalk)
    {
        Param1 = Param1 $ "1,";        
    }
    else
    {
        Param1 = Param1 $ "0,";
    }
    if(bNoSpecPlayer)
    {
        Param1 = Param1 $ "1,";        
    }
    else
    {
        Param1 = Param1 $ "0,";
    }
    if(b24HourTime)
    {
        Param1 = Param1 $ "1,";        
    }
    else
    {
        Param1 = Param1 $ "0,";
    }
    if(InGameZound)
    {
        Param1 = Param1 $ "1,";        
    }
    else
    {
        Param1 = Param1 $ "0,";
    }
    if(bChatLog)
    {
        Param1 = Param1 $ "1,";        
    }
    else
    {
        Param1 = Param1 $ "0,";
    }
    if(bChatFilter)
    {
        Param1 = Param1 $ "1,";        
    }
    else
    {
        Param1 = Param1 $ "0,";
    }
    if(bPlayerList)
    {
        Param1 = Param1 $ "1,";        
    }
    else
    {
        Param1 = Param1 $ "0,";
    }
    Param1 = (((((((((Param1 $ string(SoundDelay)) $ ",") $ string(LoginDelay)) $ ",") $ string(DelaysEach)) $ ",") $ string(SoundsEach)) $ ",") $ string(RepeatDelay)) $ ",";
    Param2 = "";
    for(C = Level.ControllerList; C != none; C = C.nextController)
    {
        if(((C.IsA('PlayerController') && MessagingSpectator(C) == none) && C.PlayerReplicationInfo.PlayerName != "WebAdmin") && C.PlayerReplicationInfo.PlayerName != "DemoRecSpectator")
        {
            Param2 = (Param2 $ C.PlayerReplicationInfo.PlayerName) $ ",";
            if((Len(Param1) + Len(Param2)) > 420)
            {
                break;
            }
        }
    }
    Sender.ClientOpenMenu("WSZound.WSZoundMenuAdmin", false, Param1, Param2);
}

function AdminSubmit(PlayerController Sender, string Options)
{
    local string sTemp;
    local int i;

    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    bZound = bool(sTemp);
    Options = Mid(Options, i + 1);
    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    ShowTrigger = bool(sTemp);
    Options = Mid(Options, i + 1);
    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    ShowToSelf = bool(sTemp);
    Options = Mid(Options, i + 1);
    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    bAnnounce = bool(sTemp);
    Options = Mid(Options, i + 1);
    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    AnnounceOnce = bool(sTemp);
    Options = Mid(Options, i + 1);
    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    bBotsTalk = bool(sTemp);
    Options = Mid(Options, i + 1);
    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    bNoSpecPlayer = bool(sTemp);
    Options = Mid(Options, i + 1);
    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    b24HourTime = bool(sTemp);
    Options = Mid(Options, i + 1);
    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    InGameZound = bool(sTemp);
    Options = Mid(Options, i + 1);
    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    if(bChatLog && sTemp == "0")
    {
        myChatLog.CloseChatLog();
    }
    bChatLog = bool(sTemp);
    Options = Mid(Options, i + 1);
    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    bChatFilter = bool(sTemp);
    Options = Mid(Options, i + 1);
    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    bPlayerList = bool(sTemp);
    Options = Mid(Options, i + 1);
    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    SoundDelay = int(sTemp);
    Options = Mid(Options, i + 1);
    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    LoginDelay = int(sTemp);
    Options = Mid(Options, i + 1);
    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    DelaysEach = int(sTemp);
    Options = Mid(Options, i + 1);
    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    SoundsEach = int(sTemp);
    Options = Mid(Options, i + 1);
    i = InStr(Options, ",");
    sTemp = Left(Options, i);
    RepeatDelay = int(sTemp);
    Options = Mid(Options, i + 1);
    myConfigs.SaveZoundConfigs();
}

function Mutate(string MutateString, PlayerController Sender)
{
    local string sTemp, sNick;
    local bool bDone;

    if(Sender == none)
    {
        return;
    }
    if(((MutateString ~= "Zound On") || MutateString ~= "Zound Off") || MutateString ~= "Zound OnOff")
    {
        CheckZoundPlayer(Sender, "0,80,", true);
        return;
    }
    if((Left(MutateString, 9) ~= "ZoundMenu") || MutateString ~= "Zounds")
    {
        sTemp = Mid(MutateString, 10);
        if(sTemp != "")
        {
            if((ZoundPass != "") && Caps(ZoundPass) != "NONE")
            {
                if((Mid(MutateString, 10) == ZoundPass) && !CheckZoundAdmin(Sender))
                {
                    AddRemoveZoundAdmin(Sender, true);
                    Sender.ClientMessage("< You have logged in as Zound Admin >");                    
                }
                else
                {
                    AddRemoveZoundAdmin(Sender, false);
                    Sender.ClientMessage("< You have logged out as Zound Admin >");
                    Sender.ConsoleCommand("AdminLogout");
                }
            }
        }
        OpenZoundMenu(Sender);
    }
    if(MutateString ~= "ZoundLogout")
    {
        if(CheckZoundAdmin(Sender))
        {
            AddRemoveZoundAdmin(Sender, false);
            Sender.ClientMessage("< You have logged out as Zound Admin >");
            Sender.ConsoleCommand("AdminLogout");
        }
    }
    if(Left(MutateString, 17) == "ZoundClientLogon-")
    {
        CheckZoundPlayer(Sender, Mid(MutateString, 17));
        return;
    }
    if(Left(MutateString, 10) ~= "ZoundLogin")
    {
        if((ZoundPass != "") && Caps(ZoundPass) != "NONE")
        {
            if((Mid(MutateString, 11) == ZoundPass) && !CheckZoundAdmin(Sender))
            {
                AddRemoveZoundAdmin(Sender, true);
                Sender.ClientMessage("< You have logged in as Zound Admin >");                
            }
            else
            {
                AddRemoveZoundAdmin(Sender, false);
                Sender.ClientMessage("< You have logged out as Zound Admin >");
                Sender.ConsoleCommand("AdminLogout");
            }
        }
    }
    if(Left(MutateString, 3) == sCode)
    {
        sTemp = Mid(MutateString, 3);
        if(sTemp == "ZoundAdminMenu")
        {
            OpenAdminMenu(Sender);
            return;
        }
        if(Left(sTemp, 18) == "ZoundClientSubmit-")
        {
            CheckZoundPlayer(Sender, Mid(sTemp, 18));
            return;
        }
        if(Left(sTemp, 16) == "ZoundClientMute-")
        {
            SetupMuted(Sender, Mid(sTemp, 16), false);
            return;
        }
        if(Left(sTemp, 22) == "ZoundClientMutePlayer-")
        {
            SetupMuted(Sender, Mid(sTemp, 22), true);
            return;
        }
        if(sTemp == "DisplayTotals")
        {
            GetPlayerTrigs(Sender);
            return;
        }
        if(Left(sTemp, 17) == "ZoundAdminSubmit-")
        {
            AdminSubmit(Sender, Mid(sTemp, 17));
            return;
        }
        if(Left(sTemp, 19) == "ZoundAddPlayerList-")
        {
            sNick = Mid(sTemp, 19);
            bDone = myPlayList.AddRemovePlayer(sNick);
            if(bDone)
            {
                sTemp = ("< " $ sNick) $ " was added to the PlayerList >";                
            }
            else
            {
                sTemp = ("< " $ sNick) $ " was removed from the PlayerList >";
            }
            Sender.ClientMessage(sTemp);
            Log(((GetDateTime(false)) $ " ") $ sTemp, 'Zound');
            return;
        }
        if(Left(sTemp, 19) == "ZoundBanPlayerList-")
        {
            sNick = Mid(sTemp, 19);
            bDone = myBanList.AddRemoveBan(sNick);
            if(bDone)
            {
                sTemp = ("< " $ sNick) $ " is now banned from using Zound >";
                CheckZoundPlayer(GetSender(sNick), "0,0,");                
            }
            else
            {
                sTemp = ("< " $ sNick) $ " was removed from the Banned List >";
                CheckZoundPlayer(GetSender(sNick), "1,80,");
            }
            Sender.ClientMessage(sTemp);
            Log(((GetDateTime(false)) $ " ") $ sTemp, 'Zound');
            return;
        }
    }
    if(NextMutator != none)
    {
        NextMutator.Mutate(MutateString, Sender);
    }
}

function PlayerController GetSender(string sNick)
{
    local Controller C;

    for(C = Level.ControllerList; C != none; C = C.nextController)
    {
        if(C.PlayerReplicationInfo.PlayerName ~= sNick)
        {
            return PlayerController(C);
        }
    }
    return none;
}

function CheckZoundPlayer(PlayerController Sender, string sMesg, optional bool bMutate)
{
    local string sNick;
    local int i, k, iZnd, iVol;

    sNick = Sender.PlayerReplicationInfo.PlayerName;
    i = InStr(sMesg, ",");
    iZnd = int(Left(sMesg, i));
    sMesg = Mid(sMesg, i + 1);
    i = InStr(sMesg, ",");
    iVol = int(Left(sMesg, i));
    sMesg = Mid(sMesg, i + 1);
    for(i = 0; i < 50; i++)
    {
        if(ZoundPlayerName[i] == sNick)
        {
            if(bMutate)
            {
                k = ZoundPlayerKill[i];
                k = k + 1;
                if(k > 1)
                {
                    k = 0;
                }
                ZoundPlayerKill[i] = k;
                if(k == 0)
                {
                    Sender.ClientMessage("< Your Zound is disabled on this level >");                    
                }
                else
                {
                    Sender.ClientMessage("< Your Zound is enabled on this level >");
                }
                return;
            }
            ZoundPlayerKill[i] = iZnd;
            ZoundPlayerGain[i] = iVol;
            ZoundController[i] = Sender;
            ZoundPlayerHash[i] = Sender.GetPlayerIDHash();
            ZoundPlayerLogID[i] = Sender.PlayerReplicationInfo.PlayerID;
            return;
        }
    }
    if(bMutate)
    {
        return;
    }
    for(i = 0; i < 50; i++)
    {
        if(ZoundPlayerName[i] == "")
        {
            ZoundPlayerName[i] = sNick;
            ZoundPlayerKill[i] = iZnd;
            ZoundPlayerGain[i] = iVol;
            ZoundController[i] = Sender;
            ZoundPlayerHash[i] = Sender.GetPlayerIDHash();
            ZoundPlayerLogID[i] = Sender.PlayerReplicationInfo.PlayerID;
            ZoundPlayerTimer[i] = LoginDelay;
            ZoundPlayerSound[i] = 0;
            ZoundPlayerDelay[i] = 0;
            break;
        }
    }
    if(Len(sMesg) > 3)
    {
        SetupMuted(Sender, sMesg, false);
    }
}

function ModifyLogin(out string Portal, out string Options)
{
    Log(((GetDateTime(true)) $ " Zound PlayerLogin: ") $ Options, 'Zound');
    if(NextMutator != none)
    {
        NextMutator.ModifyLogin(Portal, Options);
    }
}

function NotifyLogout(Controller Exiting)
{
    local string sTemp;
    local Sound MySound;

    if((bAnnounce && !Level.Game.bGameEnded) && !Exiting.PlayerReplicationInfo.bBot)
    {
        sTemp = "PlayerExit";
        MySound = GetCustomSound(sTemp, none, false, true);
        if(MySound != none)
        {
            AddToSoundBuff(MySound, 3, sTemp, "");
        }
    }
    if(NextMutator != none)
    {
        NextMutator.NotifyLogout(Exiting);
    }
}

function string GetPlayerIDType(PlayerController Sender)
{
    if(Class'IpDrv.MasterServerUplink'.default.DoUplink)
    {
        bHashID = true;
        return Sender.GetPlayerIDHash();        
    }
    else
    {
        bHashID = false;
        return string(Sender.PlayerReplicationInfo.PlayerID);
    }
}

function bool AllowSayTrig(string sSound, bool IsAdmin)
{
    local int i;

    if((RepeatDelay == 0) || IsAdmin)
    {
        return true;
    }
    for(i = 0; i < 255; i++)
    {
        if(LastZound[i] == sSound)
        {
            return false;
        }
    }
    for(i = 0; i < 255; i++)
    {
        if(LastZound[i] == "")
        {
            LastZound[i] = sSound;
            LastCount[i] = RepeatDelay;
            return true;
        }
    }
    return true;
}

function bool CheckZoundAdmin(PlayerController Sender)
{
    local string sTemp;
    local int i;

    if((Sender == none) || Sender.PlayerReplicationInfo == none)
    {
        return false;
    }
    sTemp = Sender.PlayerReplicationInfo.PlayerName;
    for(i = 0; i < 50; i++)
    {
        if(ZoundAdmin[i] == sTemp)
        {
            return true;
        }
    }
    if(Sender.PlayerReplicationInfo.bAdmin)
    {
        return true;        
    }
    else
    {
        return false;
    }
}

function AddRemoveZoundAdmin(PlayerController Sender, bool bAdd)
{
    local string sTemp;
    local int i;

    if((Sender == none) || Sender.PlayerReplicationInfo == none)
    {
        return;
    }
    sTemp = Sender.PlayerReplicationInfo.PlayerName;
    for(i = 0; i < 50; i++)
    {
        if(bAdd)
        {
            if((ZoundAdmin[i] == "") || ZoundAdmin[i] == sTemp)
            {
                ZoundAdmin[i] = sTemp;
                return;
            }
            continue;
        }
        if(ZoundAdmin[i] == sTemp)
        {
            ZoundAdmin[i] = "";
            return;
        }
    }
}

function SetPlayerTrigs(string sNick, string sTrig)
{
    local int i;

    for(i = 0; i < 50; i++)
    {
        if(TotPlayers[i] == sNick)
        {
            TotTrigger[i] = (TotTrigger[i] $ sTrig) $ ",";
            break;
        }
        if(TotPlayers[i] == "")
        {
            TotPlayers[i] = sNick;
            TotTrigger[i] = sTrig $ ",";
            break;
        }
    }
}

function GetPlayerTrigs(PlayerController Sender)
{
    local string Param1, Param2;
    local bool bAdmin;
    local int i;

    bAdmin = CheckZoundAdmin(Sender);
    if(!bAdmin)
    {
        return;
    }
    Param1 = sCode $ ",";
    Param2 = "";
    for(i = 0; i < 50; i++)
    {
        if(TotPlayers[i] != "")
        {
            Param1 = (Param1 $ TotPlayers[i]) $ ",";
            Param2 = (Param2 $ TotTrigger[i]) $ "~";
        }
        if((Len(Param1) + Len(Param2)) > 440)
        {
            break;
        }
    }
    Sender.ClientOpenMenu("WSZound.WSZoundMenuHist", false, Param1, Param2);
}

function string CheckOutTrigger(string sTrig)
{
    local string sTemp;
    local int i;

    sTemp = sTrig;
    for(i = 1; i < 50; i++)
    {
        if(Left(sTemp, 1) == " ")
        {
            sTemp = Mid(sTemp, 1);
        }
    }
    i = InStr(sTemp, "  ");
    while(i != -1)
    {
        sTemp = Left(sTemp, i) $ Mid(sTemp, i + 1);
        i = InStr(sTemp, "  ");
    }
    if((sTemp != "") && Mid(sTemp, Len(sTemp) - 1) == " ")
    {
        if(Mid(sTemp, Len(sTemp)) == "")
        {
            if(InStr(sTemp, " ") == -1)
            {
                sTemp = Left(sTemp, Len(sTemp) - 1);
            }
        }
    }
    return sTemp;
}

function string ChatHandler(Controller Who, string Cmd, Controller ToWho)
{
    local string sTemp, sTemp2, sTemp3, sComd, sTrig, sLog;

    local Sound MySound;
    local bool IsAdmin, bWhoToWho, bMeOnly;
    local int i, j, PL;

    sTrig = Cmd;
    sLog = Cmd;
    bHide = false;
    bDedicated = false;
    if(ToWho.PlayerReplicationInfo.PlayerName ~= "WebAdmin")
    {
        return Cmd;
    }
    if(Who == ToWho)
    {
        bWhoToWho = true;
    }
    IsAdmin = CheckZoundAdmin(PlayerController(Who));
    if(Who.IsA('PlayerController') && Who.PlayerReplicationInfo.bOnlySpectator)
    {
        PL = 1;        
    }
    else
    {
        PL = 2;
    }
    sTrig = CheckOutTrigger(sTrig);
    if(bChatFilter || bChatLog)
    {
        sTemp = Cmd;
        if(bChatFilter)
        {
            sTemp = myFilter.FilterString(Who, Cmd);
        }
        if(bChatLog && Who == ToWho)
        {
            DoChatLog(Who, sTemp);
        }
        Cmd = sTemp;
    }
    if(Left(sTrig, 1) == "~")
    {
        bMeOnly = true;
        sTrig = Mid(sTrig, 1);
    }
    if(sTrig ~= "time?")
    {
        sTrig = "?time";
    }
    j = InStr(Caps(Cmd), "?TIME");
    if(j != -1)
    {
        sTrig = "?time";
    }
    if(sTrig ~= "?time")
    {
        if(Who == ToWho)
        {
            myTimes.SpeakTheTime(PlayerController(Who));
            SetPlayerTrigs(Who.PlayerReplicationInfo.PlayerName, sTrig);
        }
        return "";        
    }
    else
    {
        if(!IsAdmin && !myPlayList.CheckPlayerList(PlayerController(Who), false))
        {
            return Cmd;
        }
        if(!IsAdmin)
        {
            if((sTrig ~= "PlayerEnter") || sTrig ~= "PlayerExit")
            {
                return Cmd;
            }
        }
        if(Who == ToWho)
        {
            if(!myBanList.CheckBanList(PlayerController(Who)))
            {
                MySound = GetCustomSound(sTrig, Who, true);
            }
            if(bMeOnly && MySound != none)
            {
                PlayerController(Who).ClientPlaySound(MySound, true, GetMyVolume(PlayerController(Who)));
            }            
        }
        else
        {
            MySound = none;
        }
    }
    if(bMeOnly)
    {
        return "";
    }
    if(((!IsAdmin && !InGameZound) && !Level.Game.bGameEnded) && !Level.Game.bWaitingToStartMatch)
    {
        return Cmd;
    }
    if(!Who.PlayerReplicationInfo.bBot)
    {
        sTrig = myTrigs.GetTriggerWord(Cmd, false, IsAdmin);
        if(sTrig == "")
        {
            return Cmd;
        }
        if(myBanList.CheckBanList(PlayerController(Who)))
        {
            if(sTrig ~= Cmd)
            {
                Cmd = "";
            }
            return Cmd;
        }
        i = InStr(Caps(Cmd), Caps(sTrig));
        if(i != -1)
        {
            sComd = Cmd;
            if((Who != ToWho) && bHide)
            {
                sTemp = Caps(sTrig);
                sTemp2 = Caps(sTrig) $ " ";
                sTemp3 = Caps(sTrig) $ "  ";
                if(Caps(Cmd) ~= Caps(sTrig))
                {
                    sComd = "";
                }
                if((Caps(Cmd) == sTemp2) || Caps(Cmd) == sTemp3)
                {
                    sComd = "";
                }                
            }
            else
            {
                if(((!ShowToSelf && !ShowTrigger) && Who == ToWho) && bDedicated)
                {
                    sComd = "";
                }
            }
            Cmd = sComd;
        }
        bHide = false;
        sTemp = GetPlayerIDType(PlayerController(Who));
        if((MySound != none) && !AllowSayTrig(sTrig, IsAdmin))
        {
            return Cmd;
        }
        if(MySound != none)
        {
            for(i = 0; i < 50; i++)
            {
                if(((!IsAdmin && bHashID) && ZoundPlayerHash[i] == sTemp) || !bHashID && string(ZoundPlayerLogID[i]) == sTemp)
                {
                    if((ZoundPlayerSound[i] >= SoundsEach) && SoundsEach != 0)
                    {
                        PlayerController(Who).ClientMessage(("< Only " $ string(SoundsEach)) $ " Zound Triggers allowed per Player >");
                        if((Caps(sTrig) == Caps(Cmd)) && bDedicated)
                        {
                            return "";                            
                        }
                        else
                        {
                            return Cmd;
                        }
                        continue;
                    }
                    if(ZoundPlayerDelay[i] > 0)
                    {
                        if((Caps(sTrig) == Caps(Cmd)) && bDedicated)
                        {
                            return "";                            
                        }
                        else
                        {
                            return Cmd;
                        }
                        continue;
                    }
                    if(!IsAdmin)
                    {
                        ZoundPlayerSound[i]++;
                    }
                    ZoundPlayerDelay[i] = ZoundPlayerSound[i] * DelaysEach;
                    break;
                }
            }
        }
    }
    else
    {
        if(!bBotsTalk)
        {
            return Cmd;
        }
    }
    if(MySound != none)
    {
        AddToSoundBuff(MySound, PL, sTrig, Who.PlayerReplicationInfo.PlayerName);
        SetPlayerTrigs(Who.PlayerReplicationInfo.PlayerName, sTrig);
    }
    return Cmd;
}

function bool CheckInGameZound(Controller C)
{
    local bool IsAdmin;

    if((C != none) && C.IsA('PlayerController'))
    {
        IsAdmin = CheckZoundAdmin(PlayerController(C));
    }
    if(((!IsAdmin && !InGameZound) && !Level.Game.bGameEnded) && !Level.Game.bWaitingToStartMatch)
    {
        return false;        
    }
    else
    {
        return true;
    }
}

function GetServerDetails(out GameInfo.ServerResponseLine ServerState)
{
    local int i;

    i = ServerState.ServerInfo.Length;
    ServerState.ServerInfo.Length = i + 1;
    ServerState.ServerInfo[i].Key = "WSZound";
    ServerState.ServerInfo[i].Value = "V1";
}

function ServerTraveling(string URL, bool bItems)
{
    MyPlayers.SaveZoundPlayers();
    Log(((GetDateTime(true)) $ " ServerTraveling - URL = ") $ URL, 'WSZound');
    if(NextMutator != none)
    {
        NextMutator.ServerTraveling(URL, bItems);
    }
}

defaultproperties
{
    Yellow=(R=250,G=250,B=0,A=255)
    Cyan=(R=0,G=160,B=255,A=255)
    bAddToServerPackages=true
    GroupName="WSZound"
    FriendlyName="WSZound V1"
    Description="Plays sounds triggered by chat messages"
}