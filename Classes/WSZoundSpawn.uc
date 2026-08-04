class WSZoundSpawn extends Info
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force);

var PlayerController PLC;
var bool bInfoDone;
var int Dummy;
var int Trys;
var WSZoundClient ZC;

replication
{
    reliable if((bNetInitial && Role == ROLE_Authority) && bNetOwner)
        Dummy, PLC;

    reliable if(Role == ROLE_Authority)
        ClientPlayZound;
}

// Mute test against the full local mute list. Runs wherever the client config
// lives: on a remote client (via the RPC below) or on a listen/standalone host
// (called directly by the server). Returns false when the interaction is not
// yet installed (fail-open).
simulated function bool ZoundIsMuted(string sTrig)
{
    local string sMute;

    if(ZC == none)
    {
        return false;
    }
    sMute = ZC.GetMutedWords();
    if((sMute != "") && Mid(sMute, Len(sMute) - 1) != ",")
    {
        sMute = sMute $ ",";
    }
    return (InStr(sMute, sTrig $ ",") != -1);
}

// True when the "mute long zounds" client option is on and this sound is
// longer than the configured limit. GetSoundDuration works on the loaded sound.
simulated function bool ZoundIsTooLong(Sound MySound)
{
    return (Class'WSZoundClient'.default.bMuteLongZounds && (GetSoundDuration(MySound) > Class'WSZoundClient'.default.MaxZoundSeconds));
}

// Server calls this on the owning REMOTE client. The mute check is done there,
// against the full local mute list - so the mute list never has to be uploaded
// to the server and is effectively unlimited. (Local host players are handled
// server-side in MutWSZound.PlayZoundTo, since a client RPC won't run locally.)
simulated function ClientPlayZound(Sound MySound, float MyGain, string sTrig)
{
    if((PLC == none) || MySound == none)
    {
        return;
    }
    if(ZoundIsMuted(sTrig) || ZoundIsTooLong(MySound))
    {
        return;
    }
    PLC.ClientPlaySound(MySound, true, MyGain);
}

simulated function SetInteraction()
{
    if(PLC == none)
    {
        PLC = PlayerController(Owner);
    }
    if(PLC == none)
    {
        return;
    }
    ZC = WSZoundClient(PLC.Player.InteractionMaster.AddInteraction("WSZound.WSZoundClient", PLC.Player));
    if(ZC == none)
    {
        return;
    }
    bInfoDone = true;
}

simulated function Tick(float DeltaTime)
{
    if(Level.NetMode != NM_DedicatedServer)
    {
        if(!bInfoDone && Trys < 20)
        {
            Trys++;
            SetInteraction();
        }
        return;
    }
    // Keep the actor alive across respawns so it can receive ClientPlayZound;
    // only tear it down when the match ends or the player has left.
    if(Level.Game.bGameEnded || PLC == none)
    {
        Destroy();
    }
}

defaultproperties
{
    bOnlyRelevantToOwner=true
    RemoteRole=ROLE_SimulatedProxy
    NetUpdateFrequency=10.0000000
    NetPriority=3.0000000
}