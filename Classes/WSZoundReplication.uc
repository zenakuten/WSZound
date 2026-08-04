class WSZoundReplication extends ReplicationInfo
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force);

var string SoundA[251];
var string SoundB[251];
var string SoundC[251];
var string SoundD[251];
var string SoundE[251];
var string SoundF[251];
var string SoundG[251];
var string SoundH[251];
var string Players[32];
var int Dummy;

replication
{
    reliable if(Role == ROLE_Authority)
        Dummy, Players, 
        SoundA, SoundB, 
        SoundC, SoundD, 
        SoundE, SoundF, 
        SoundG, SoundH;
}

simulated function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    Dummy++;
}

defaultproperties
{
    NetUpdateFrequency=1.0000000
    bNetNotify=true
}