class WSZoundConfigs extends Info
    config(WSZound)
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force);

var config string ZoundPass;
var config bool bZound;
var config bool ShowTrigger;
var config bool ShowToSelf;
var config bool bAnnounce;
var config bool AnnounceOnce;
var config bool bBotsTalk;
var config bool NoSpecToPlayer;
var config bool Say24HourTime;
var config bool InGameZound;
var config bool UseChatLog;
var config bool UseChatFilter;
var config bool UsePlayerList;
var config int SoundDelay;
var config int LoginDelay;
var config int DelaysEach;
var config int SoundsEach;
var config int RepeatDelay;
var MutWSZound myMut;

function LoadZoundConfigs()
{
    myMut.ZoundPass = default.ZoundPass;
    myMut.bZound = default.bZound;
    myMut.ShowTrigger = default.ShowTrigger;
    myMut.ShowToSelf = default.ShowToSelf;
    myMut.bAnnounce = default.bAnnounce;
    myMut.AnnounceOnce = default.AnnounceOnce;
    myMut.bBotsTalk = default.bBotsTalk;
    myMut.bNoSpecPlayer = default.NoSpecToPlayer;
    myMut.b24HourTime = default.Say24HourTime;
    myMut.InGameZound = default.InGameZound;
    myMut.bChatLog = default.UseChatLog;
    myMut.bChatFilter = default.UseChatFilter;
    myMut.bPlayerList = default.UsePlayerList;
    myMut.SoundDelay = default.SoundDelay;
    myMut.LoginDelay = default.LoginDelay;
    myMut.DelaysEach = default.DelaysEach;
    myMut.SoundsEach = default.SoundsEach;
    myMut.RepeatDelay = default.RepeatDelay;
}

function SaveZoundConfigs()
{
    default.bZound = myMut.bZound;
    default.ShowTrigger = myMut.ShowTrigger;
    default.ShowToSelf = myMut.ShowToSelf;
    default.bAnnounce = myMut.bAnnounce;
    default.AnnounceOnce = myMut.AnnounceOnce;
    default.bBotsTalk = myMut.bBotsTalk;
    default.NoSpecToPlayer = myMut.bNoSpecPlayer;
    default.Say24HourTime = myMut.b24HourTime;
    default.InGameZound = myMut.InGameZound;
    default.UseChatLog = myMut.bChatLog;
    default.UseChatFilter = myMut.bChatFilter;
    default.UsePlayerList = myMut.bPlayerList;
    default.SoundDelay = myMut.SoundDelay;
    default.LoginDelay = myMut.LoginDelay;
    default.DelaysEach = myMut.DelaysEach;
    default.SoundsEach = myMut.SoundsEach;
    default.RepeatDelay = myMut.RepeatDelay;
    self.StaticSaveConfig();
}

defaultproperties
{
    bZound=true
    ShowToSelf=true
    bAnnounce=true
    SoundDelay=5
    LoginDelay=5
    DelaysEach=1
    SoundsEach=10
    RepeatDelay=5
}