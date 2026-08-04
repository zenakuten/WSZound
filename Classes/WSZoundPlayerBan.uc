class WSZoundPlayerBan extends Info
    config(WSZound)
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force);

struct PlayerBans
{
    var string NickName;
    var string UniqueID;
};

var() config array<PlayerBans> BannedPlayer;
var MutWSZound myMut;

function PreBeginPlay()
{
    if(default.BannedPlayer.Length == 0)
    {
        default.BannedPlayer.Length = 1;
        default.BannedPlayer[0].NickName = "Nickname";
        default.BannedPlayer[0].UniqueID = "abcf542decb78f1aaa64fde7c891abce";
        self.StaticSaveConfig();
    }
    super(Actor).PreBeginPlay();
}

function bool CheckBanList(PlayerController Sender)
{
    local string sNick, sKey;
    local int i;

    if((Sender != none) && Sender.PlayerReplicationInfo != none)
    {
        sNick = Sender.PlayerReplicationInfo.PlayerName;
        sKey = Sender.GetPlayerIDHash();
        for(i = 0; i < default.BannedPlayer.Length; i++)
        {
            if(default.BannedPlayer[i].NickName == sNick)
            {
                return true;
            }
        }
        for(i = 0; i < default.BannedPlayer.Length; i++)
        {
            if(default.BannedPlayer[i].UniqueID == sKey)
            {
                return true;
            }
        }
    }
    return false;
}

function bool AddRemoveBan(string sNick)
{
    local string sKey;
    local Controller C;
    local int i;

    sKey = "";
    for(C = Level.ControllerList; C != none; C = C.nextController)
    {
        if(C.PlayerReplicationInfo.PlayerName ~= sNick)
        {
            sKey = PlayerController(C).GetPlayerIDHash();
            break;
        }
    }
    if(sKey != "")
    {
        for(i = 0; i < default.BannedPlayer.Length; i++)
        {
            if(default.BannedPlayer[i].NickName == sNick)
            {
                default.BannedPlayer.Remove(i, 1);
                self.StaticSaveConfig();
                return false;
            }
        }
        for(i = 0; i < default.BannedPlayer.Length; i++)
        {
            if(default.BannedPlayer[i].UniqueID == sKey)
            {
                default.BannedPlayer.Remove(i, 1);
                self.StaticSaveConfig();
                return false;
            }
        }
        i = default.BannedPlayer.Length;
        default.BannedPlayer.Length = i + 1;
        default.BannedPlayer[i].NickName = sNick;
        default.BannedPlayer[i].UniqueID = sKey;
        self.StaticSaveConfig();
        return true;
    }
    return false;
}
