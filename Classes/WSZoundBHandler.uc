class WSZoundBHandler extends BroadcastHandler
    config
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force);

var MutWSZound myMut;
var bool bInit;

function PreBeginPlay()
{
    local BroadcastHandler bh;

    if(!bInit)
    {
        bInit = true;
        if(Level.Game.BroadcastHandler.IsA('UT2VoteChatHandler'))
        {
            foreach AllActors(Class'Engine.BroadcastHandler', bh)
            {
                if(bh.Class == Level.Game.default.BroadcastClass)
                {
                    bh.RegisterBroadcastHandler(self);
                    break;
                }                
            }                        
        }
        else
        {
            Level.Game.BroadcastHandler.RegisterBroadcastHandler(self);
        }
    }
}

function BroadcastText(PlayerReplicationInfo SenderPRI, PlayerController Receiver, coerce string Msg, optional name Type)
{
    if((SenderPRI != none) && (Type == 'Say') || Type == 'TeamSay')
    {
        Msg = myMut.ChatHandler(Controller(SenderPRI.Owner), Msg, Receiver);
        if(Msg == "")
        {
            return;
        }
    }
    super.BroadcastText(SenderPRI, Receiver, Msg, Type);
}
