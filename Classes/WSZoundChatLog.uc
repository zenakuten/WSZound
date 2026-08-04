class WSZoundChatLog extends Info
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force);

var FileLog ChatLog;
var string LastMesg;

event PreBeginPlay()
{
    Enable('Tick');
}

function CloseChatLog()
{
    if(ChatLog != none)
    {
        ChatLog.Destroy();
        ChatLog = none;
    }
}

function WriteChatLog(string sLog)
{
    local string sDay;

    if(ChatLog == none)
    {
        sDay = GetDay();
        ChatLog = Spawn(Class'Engine.FileLog', Level);
        ChatLog.OpenLog("ZoundChat" $ sDay);
    }
    if(ChatLog != none)
    {
        if(sLog != LastMesg)
        {
            ChatLog.Logf(sLog);
        }
        LastMesg = sLog;
    }
}

event Tick(float Delta)
{
    if((Level.NextURL != "") && ChatLog != none)
    {
        CloseChatLog();
    }
}

function string GetDay()
{
    if(Level.Day < 10)
    {
        return "0" $ string(Level.Day);        
    }
    else
    {
        return "" $ string(Level.Day);
    }
}
