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
var int NumTrigsA;
var int NumTrigsB;
// Per-player slots, one per distinct player this map (kept after they leave, so a
// returning player gets theirs back by name). Slots [0, NumZoundSlots) are in use, and
// every loop over the slots stops there, so the cap itself costs nothing.
const MAXZOUNDPLAYERS = 256;
var int NumZoundSlots;
var PlayerController ZoundController[MAXZOUNDPLAYERS];
var string ZoundPlayerName[MAXZOUNDPLAYERS];
var string ZoundPlayerHash[MAXZOUNDPLAYERS];
var string ZoundPlayerMute[MAXZOUNDPLAYERS];
var string ZoundPlayerShut[MAXZOUNDPLAYERS];
var int ZoundPlayerKill[MAXZOUNDPLAYERS];
var int ZoundPlayerGain[MAXZOUNDPLAYERS];
var int ZoundPlayerLogID[MAXZOUNDPLAYERS];
var int ZoundPlayerSound[MAXZOUNDPLAYERS];
var int ZoundPlayerDelay[MAXZOUNDPLAYERS];
var int ZoundPlayerTimer[MAXZOUNDPLAYERS];
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
// Every WSZoundSpawn made by SetClientClass, so GetZoundSpawn doesn't have to scan all
// the actors in the level for each player on every zound.
var array<WSZoundSpawn> ZoundSpawns;
// Number of non-empty ZoundAdmin slots; CheckZoundAdmin skips its scan while it's 0.
var int NumZoundAdmins;
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
    local int i;

    if(PC == none)
    {
        return;
    }
    // Replace this player's spawn. Entries leave the list in WSZoundSpawn.Destroyed, so
    // everything here is alive; unlist before destroying so that callback finds nothing.
    for(i = ZoundSpawns.Length - 1; i >= 0; i--)
    {
        ZSRI = ZoundSpawns[i];
        if(ZSRI == none)
        {
            ZoundSpawns.Remove(i, 1);
        }
        else if(ZSRI.Owner == PC)
        {
            ZoundSpawns.Remove(i, 1);
            ZSRI.Destroy();
        }
    }
    ZSRI = Spawn(Class'WSZoundSpawn', PC);
    ZSRI.PLC = PC;
    ZSRI.Dummy++;
    ZSRI.MyMut = self;
    ZoundSpawns[ZoundSpawns.Length] = ZSRI;
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

// Index of PC's Zound player slot, or -1 when the player has no slot. Logged-on players
// are matched by controller: a pointer compare with no string copies, which also keeps
// a renamed player on their slot (by name alone they lost it and heard zounds at volume
// 0). The name match covers players before their logon message and returning players.
final function int FindPlayerSlot(PlayerController PC)
{
    local string sNick;
    local int i;

    for(i = 0; i < NumZoundSlots; i++)
    {
        if(ZoundController[i] == PC)
        {
            return i;
        }
    }
    sNick = PC.PlayerReplicationInfo.PlayerName;
    for(i = 0; i < NumZoundSlots; i++)
    {
        if(ZoundPlayerName[i] == sNick)
        {
            return i;
        }
    }
    return -1;
}

// Whether slot i has muted this trigger (whole list entry) or the player who sent it.
final function bool SlotMuted(int i, string sTrig, string sWho)
{
    if(Class'WSZoundClient'.static.FindListEntry(ZoundPlayerMute[i], sTrig) != -1)
    {
        return true;
    }
    return (ZoundPlayerShut[i] != "") && ZoundPlayerShut[i] == sWho;
}

final function float GainToVolume(int Gn)
{
    if(Gn == 0)
    {
        return 0.0000000;
    }
    return 2.0000000 * (float(Gn) / float(100));
}

function bool CheckForNoZound(PlayerController PC)
{
    local int i;

    if(PC == none)
    {
        return false;
    }
    i = FindPlayerSlot(PC);
    return (i != -1) && ZoundPlayerKill[i] == 0;
}

function SetupMuted(PlayerController PC, string sMute, bool bPlayer)
{
    local string sTemp;
    local int i;

    if(PC == none)
    {
        return;
    }
    i = FindPlayerSlot(PC);
    if(i == -1)
    {
        return;
    }
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
    }
}

function bool CheckMuted(PlayerController PC, string sTrig, string sWho)
{
    local int i;

    if(PC == none)
    {
        return true;
    }
    if(sTrig == "")
    {
        return false;
    }
    i = FindPlayerSlot(PC);
    return (i != -1) && SlotMuted(i, sTrig, sWho);
}

function int GetClientGain(PlayerController PC)
{
    local int i;

    if(PC == none)
    {
        return 0;
    }
    i = FindPlayerSlot(PC);
    if(i == -1)
    {
        return 0;
    }
    return ZoundPlayerGain[i];
}

// Returns the owner-only replicated actor for a player, used to route a zound
// through the client (where the mute check now happens). Found by owner in
// ZoundSpawns so it survives respawns; falls back to none (caller then plays
// server-side).
function WSZoundSpawn GetZoundSpawn(PlayerController PC)
{
    local WSZoundSpawn ZS;
    local int i;

    if(PC == none)
    {
        return none;
    }
    for(i = 0; i < ZoundSpawns.Length; i++)
    {
        ZS = ZoundSpawns[i];
        if((ZS != none) && ZS.Owner == PC)
        {
            return ZS;
        }
    }
    return none;
}

// Fallback for a departed player's spawn when NotifyLogout didn't reach this mutator (a
// mutator ahead of it may not pass the call on). PLC reads none once the engine has
// cleared its references to the destroyed controller; that was the old per-tick check.
final function SweepZoundSpawns()
{
    local int i;

    for(i = ZoundSpawns.Length - 1; i >= 0; i--)
    {
        if(ZoundSpawns[i] == none)
        {
            ZoundSpawns.Remove(i, 1);
        }
        else if(ZoundSpawns[i].PLC == none)
        {
            // Destroyed takes it out of the list.
            ZoundSpawns[i].Destroy();
        }
    }
}

// Called from WSZoundSpawn.Destroyed so ZoundSpawns never holds a destroyed actor.
function RemoveZoundSpawn(WSZoundSpawn ZS)
{
    local int i;

    for(i = 0; i < ZoundSpawns.Length; i++)
    {
        if(ZoundSpawns[i] == ZS)
        {
            ZoundSpawns.Remove(i, 1);
            return;
        }
    }
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
    SweepZoundSpawns();
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
    for(i = 0; i < NumZoundSlots; i++)
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
    local PlayerController PC;
    local float MyGain;
    local int S;

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
        PC = PlayerController(C);
        if((PC == none) || C.PlayerReplicationInfo.bBot)
        {
            continue;
        }
        if(!myPlayList.CheckPlayerList(PC, false) && !CheckZoundAdmin(PC))
        {
            continue;
        }
        // One slot lookup instead of CheckForNoZound, CheckMuted and GetMyVolume each
        // scanning the slots. No slot means: not disabled, not muted, volume 0.
        S = FindPlayerSlot(PC);
        MyGain = 0.0000000;
        if(S != -1)
        {
            if(ZoundPlayerKill[S] == 0)
            {
                continue;
            }
            if((sTrig != "") && SlotMuted(S, sTrig, FromWho))
            {
                continue;
            }
            MyGain = GainToVolume(ZoundPlayerGain[S]);
        }
        if(bNoSpecPlayer && iNum == 1)
        {
            if(C.PlayerReplicationInfo.bOnlySpectator)
            {
                PlayZoundTo(PC, MySound, MyGain, sTrig);
            }
        }
        else
        {
            if(bNoSpecPlayer && iNum == 2)
            {
                if(!C.PlayerReplicationInfo.bOnlySpectator)
                {
                    PlayZoundTo(PC, MySound, MyGain, sTrig);
                }
            }
            else
            {
                PlayZoundTo(PC, MySound, MyGain, sTrig);
            }
        }
    }
}

function float GetMyVolume(PlayerController Sender)
{
    return GainToVolume(GetClientGain(Sender));
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
    i = FindPlayerSlot(Sender);
    if(i != -1)
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
    }
    Param2 = ((MPlayer $ ",") $ string(S)) $ ",";
    Sender.ClientOpenMenu(string(Class'WSZoundMenuTrigs'), false, Param1, Param2);
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
    Sender.ClientOpenMenu(string(Class'WSZoundMenuAdmin'), false, Param1, Param2);
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
    i = FindPlayerSlot(Sender);
    if(i != -1)
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
        // Found by controller after a rename: the slot takes the new name.
        ZoundPlayerName[i] = sNick;
        ZoundPlayerKill[i] = iZnd;
        ZoundPlayerGain[i] = iVol;
        ZoundController[i] = Sender;
        ZoundPlayerHash[i] = Sender.GetPlayerIDHash();
        ZoundPlayerLogID[i] = Sender.PlayerReplicationInfo.PlayerID;
        return;
    }
    if(bMutate)
    {
        return;
    }
    // New player: the next unused slot. Slots aren't reused within a map.
    if(NumZoundSlots < MAXZOUNDPLAYERS)
    {
        i = NumZoundSlots;
        NumZoundSlots++;
        ZoundPlayerName[i] = sNick;
        ZoundPlayerKill[i] = iZnd;
        ZoundPlayerGain[i] = iVol;
        ZoundController[i] = Sender;
        ZoundPlayerHash[i] = Sender.GetPlayerIDHash();
        ZoundPlayerLogID[i] = Sender.PlayerReplicationInfo.PlayerID;
        ZoundPlayerTimer[i] = LoginDelay;
        ZoundPlayerSound[i] = 0;
        ZoundPlayerDelay[i] = 0;
    }
    if(Len(sMesg) > 3)
    {
        SetupMuted(Sender, sMesg, false);
    }
}

function ModifyLogin(out string Portal, out string Options)
{
    // Name only: the login options also carry ?Password= and any ?AdminPassword=.
    Log(((GetDateTime(true)) $ " Zound PlayerLogin: ") $ Level.Game.ParseOption(Options, "Name"), 'Zound');
    if(NextMutator != none)
    {
        NextMutator.ModifyLogin(Portal, Options);
    }
}

function NotifyLogout(Controller Exiting)
{
    local string sTemp;
    local Sound MySound;
    local WSZoundSpawn ZS;
    local int i;

    if((bAnnounce && !Level.Game.bGameEnded) && !Exiting.PlayerReplicationInfo.bBot)
    {
        sTemp = "PlayerExit";
        MySound = GetCustomSound(sTemp, none, false, true);
        if(MySound != none)
        {
            AddToSoundBuff(MySound, 3, sTemp, "");
        }
    }
    // The player's spawn only goes when they leave: it has to outlive respawns and the end
    // of the match, because zounds keep playing then and PlayZoundTo would otherwise play
    // them unmuted. Destroyed takes it out of ZoundSpawns.
    ZS = GetZoundSpawn(PlayerController(Exiting));
    if(ZS != none)
    {
        ZS.Destroy();
    }
    // Their slot stays (found by name if they come back), minus the controller and any
    // join announcement still pending.
    for(i = 0; i < NumZoundSlots; i++)
    {
        if(ZoundController[i] == Exiting)
        {
            ZoundController[i] = none;
            ZoundPlayerTimer[i] = 0;
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
    if(Sender.PlayerReplicationInfo.bAdmin)
    {
        return true;
    }
    // Runs for every receiver of every chat line; usually nobody is a Zound admin.
    if(NumZoundAdmins == 0)
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
    return false;
}

// Keeps NumZoundAdmins equal to the number of non-empty ZoundAdmin slots.
function AddRemoveZoundAdmin(PlayerController Sender, bool bAdd)
{
    local string sTemp;
    local int i, Free;

    if((Sender == none) || Sender.PlayerReplicationInfo == none)
    {
        return;
    }
    sTemp = Sender.PlayerReplicationInfo.PlayerName;
    if(sTemp == "")
    {
        return;
    }
    Free = -1;
    for(i = 0; i < 50; i++)
    {
        if(ZoundAdmin[i] == sTemp)
        {
            if(bAdd)
            {
                return;
            }
            ZoundAdmin[i] = "";
            NumZoundAdmins--;
        }
        else if((Free == -1) && ZoundAdmin[i] == "")
        {
            Free = i;
        }
    }
    if(bAdd && Free != -1)
    {
        ZoundAdmin[Free] = sTemp;
        NumZoundAdmins++;
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
    Sender.ClientOpenMenu(string(Class'WSZoundMenuHist'), false, Param1, Param2);
}

// Drops up to 49 leading spaces, then collapses every run of spaces into one.
function string CheckOutTrigger(string sTrig)
{
    local int i;

    while((i < 49) && Mid(sTrig, i, 1) == " ")
    {
        i++;
    }
    if(i > 0)
    {
        sTrig = Mid(sTrig, i);
    }
    while(InStr(sTrig, "  ") != -1)
    {
        sTrig = Repl(sTrig, "  ", " ", true);
    }
    return sTrig;
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
            for(i = 0; i < NumZoundSlots; i++)
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
    ServerState.ServerInfo[i].Value = "V5";
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
    FriendlyName="WSZound V5"
    Description="Plays sounds triggered by chat messages"
}