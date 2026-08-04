class WSZoundPlayers extends Info
    config
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force);

var config string ZLastPlayers;
var MutWSZound myMut;

function LoadZoundPlayers()
{
    myMut.ZLastPlayers = default.ZLastPlayers;
    default.ZLastPlayers = "";
    self.StaticSaveConfig();
}

function SaveZoundPlayers()
{
    local string sTemp;
    local int i;

    sTemp = "";
    for(i = 0; i < 32; i++)
    {
        if(myMut.ZoundPlayerName[i] == "")
        {
            break;
        }
        sTemp = (sTemp $ myMut.ZoundPlayerName[i]) $ " ";
    }
    default.ZLastPlayers = sTemp;
    self.StaticSaveConfig();
}
