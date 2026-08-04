class WSZoundPlayerList extends Info
    config(WSZound)
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force);

struct PlayerList
{
    var string NickName;
    var string UniqueID;
};

var() config array<PlayerList> ListedPlayer;
var MutWSZound myMut;

function PreBeginPlay()
{
    if(default.ListedPlayer.Length == 0)
    {
        default.ListedPlayer.Length = 1;
        default.ListedPlayer[0].NickName = "Nickname";
        default.ListedPlayer[0].UniqueID = "abcf542decb78f1aaa64fde7c891abce";
        self.StaticSaveConfig();
    }
    super(Actor).PreBeginPlay();
}

function bool CheckPlayerList(PlayerController Sender, bool byPass)
{
    local string sKey;
    local int i;

    if(!byPass)
    {
        if(!myMut.bPlayerList)
        {
            return true;
        }
        if(Sender == none)
        {
            return true;
        }
    }
    sKey = Sender.GetPlayerIDHash();
    for(i = 0; i < default.ListedPlayer.Length; i++)
    {
        if(default.ListedPlayer[i].UniqueID == sKey)
        {
            return true;
        }
    }
    return false;
}

function bool AddRemovePlayer(string sNick)
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
        for(i = 0; i < default.ListedPlayer.Length; i++)
        {
            if(default.ListedPlayer[i].UniqueID == sKey)
            {
                default.ListedPlayer.Remove(i, 1);
                self.StaticSaveConfig();
                return false;
            }
        }
        i = default.ListedPlayer.Length;
        default.ListedPlayer.Length = i + 1;
        default.ListedPlayer[i].NickName = sNick;
        default.ListedPlayer[i].UniqueID = sKey;
        self.StaticSaveConfig();
        return true;
    }
    return false;
}
