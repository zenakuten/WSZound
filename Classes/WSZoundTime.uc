class WSZoundTime extends Info
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force);

#exec AUDIO IMPORT FILE="Sounds\0.wav" NAME="0"
#exec AUDIO IMPORT FILE="Sounds\1.wav" NAME="1"
#exec AUDIO IMPORT FILE="Sounds\2.wav" NAME="2"
#exec AUDIO IMPORT FILE="Sounds\3.wav" NAME="3"
#exec AUDIO IMPORT FILE="Sounds\4.wav" NAME="4"
#exec AUDIO IMPORT FILE="Sounds\5.wav" NAME="5"
#exec AUDIO IMPORT FILE="Sounds\6.wav" NAME="6"
#exec AUDIO IMPORT FILE="Sounds\7.wav" NAME="7"
#exec AUDIO IMPORT FILE="Sounds\8.wav" NAME="8"
#exec AUDIO IMPORT FILE="Sounds\9.wav" NAME="9"
#exec AUDIO IMPORT FILE="Sounds\10.wav" NAME="10"
#exec AUDIO IMPORT FILE="Sounds\11.wav" NAME="11"
#exec AUDIO IMPORT FILE="Sounds\12.wav" NAME="12"
#exec AUDIO IMPORT FILE="Sounds\13.wav" NAME="13"
#exec AUDIO IMPORT FILE="Sounds\14.wav" NAME="14"
#exec AUDIO IMPORT FILE="Sounds\15.wav" NAME="15"
#exec AUDIO IMPORT FILE="Sounds\16.wav" NAME="16"
#exec AUDIO IMPORT FILE="Sounds\17.wav" NAME="17"
#exec AUDIO IMPORT FILE="Sounds\18.wav" NAME="18"
#exec AUDIO IMPORT FILE="Sounds\19.wav" NAME="19"
#exec AUDIO IMPORT FILE="Sounds\20.wav" NAME="20"
#exec AUDIO IMPORT FILE="Sounds\30.wav" NAME="30"
#exec AUDIO IMPORT FILE="Sounds\40.wav" NAME="40"
#exec AUDIO IMPORT FILE="Sounds\50.wav" NAME="50"
#exec AUDIO IMPORT FILE="Sounds\am.wav" NAME="am"
#exec AUDIO IMPORT FILE="Sounds\Bell.wav" NAME="Bell"
#exec AUDIO IMPORT FILE="Sounds\Hours.wav" NAME="Hours"
#exec AUDIO IMPORT FILE="Sounds\Minutes.wav" NAME="Minutes"
#exec AUDIO IMPORT FILE="Sounds\PM.wav" NAME="PM"
#exec AUDIO IMPORT FILE="Sounds\The_time_is.wav" NAME="The_time_is"

var MutWSZound myMut;
var bool bDone;
var bool bBell;
var bool bTimeIs;
var bool bHour1;
var bool bHour2;
var bool bMins1;
var bool bMins2;
var bool bAmPm;
var bool bSayMins;
var bool bSayHour;
var string sHour1;
var string sHour2;
var string sMins1;
var string sMins2;
var string sAmPm;
var float Delay;
var float MyGain;
var PlayerController ThePlayer;

function PostBeginPlay()
{
    bDone = true;
    super(Actor).PostBeginPlay();
}

function SpeakTheTime(PlayerController PC)
{
    local int Gn, Hour1, Hour2, Mins1, Mins2;

    local float fVol;

    if(bDone == false)
    {
        return;
    }
    ThePlayer = PC;
    if(myMut.CheckForNoZound(PC))
    {
        return;
    }
    Gn = myMut.GetClientGain(PC);
    if(Gn == 0)
    {
        return;
    }
    fVol = float(Gn);
    fVol = fVol / float(100);
    MyGain = 2.0000000 * fVol;
    Hour1 = Level.Hour;
    Mins1 = Level.Minute;
    Hour2 = -1;
    Mins2 = -1;
    if(myMut.b24HourTime == false)
    {
        bAmPm = true;
        sAmPm = "am";
        if(Hour1 > 11)
        {
            sAmPm = "pm";
        }
        if(Hour1 > 12)
        {
            Hour1 = Hour1 - 12;
        }
        if(Hour1 == 0)
        {
            Hour1 = 12;
        }
        if(Mins1 == 0)
        {
            Mins1 = -1;
        }        
    }
    else
    {
        if(Hour1 >= 20)
        {
            Hour2 = Hour1 - 20;
            Hour1 = 20;
            if(Hour2 > 0)
            {
                sHour2 = string(Hour2);
                bHour2 = true;
            }
        }
        bSayHour = true;
        bSayMins = true;
        bAmPm = false;
    }
    sHour1 = string(Hour1);
    bHour1 = true;
    if(Mins1 >= 50)
    {
        Mins2 = Mins1 - 50;
        Mins1 = 50;        
    }
    else
    {
        if(Mins1 >= 40)
        {
            Mins2 = Mins1 - 40;
            Mins1 = 40;            
        }
        else
        {
            if(Mins1 >= 30)
            {
                Mins2 = Mins1 - 30;
                Mins1 = 30;                
            }
            else
            {
                if(Mins1 >= 20)
                {
                    Mins2 = Mins1 - 20;
                    Mins1 = 20;
                }
            }
        }
    }
    if(Mins1 != -1)
    {
        sMins1 = string(Mins1);
        bMins1 = true;
    }
    if(Mins2 > 0)
    {
        sMins2 = string(Mins2);
        bMins2 = true;
    }
    Delay = 0.8000000;
    if((Mins1 > 12) && Mins1 < 20)
    {
        Delay = 1.0000000;
    }
    bDone = false;
    bBell = true;
    bAmPm = true;
    bTimeIs = true;
    SetTimer(1.0000000, false);
}

function PlayTimeSound(string SoundClass)
{
    local Sound MySound;

    MySound = Sound(DynamicLoadObject("WSZound." $ SoundClass, Class'Engine.Sound'));
    if(MySound == none)
    {
        return;
    }
    if(ThePlayer != none)
    {
        ThePlayer.ClientPlaySound(MySound, true, MyGain);
    }
}

function Timer()
{
    if(bBell)
    {
        bBell = false;
        PlayTimeSound("Bell");
        SetTimer(0.7000000, false);
        return;
    }
    if(bTimeIs)
    {
        bTimeIs = false;
        PlayTimeSound("The_time_is");
        SetTimer(2.0000000, false);
        return;
    }
    if(bHour1)
    {
        bHour1 = false;
        PlayTimeSound(sHour1);
        SetTimer(0.8000000, false);
        return;
    }
    if(bHour2)
    {
        bHour2 = false;
        PlayTimeSound(sHour2);
        SetTimer(0.8000000, false);
        return;
    }
    if(bSayHour)
    {
        bSayHour = false;
        PlayTimeSound("Hours");
        SetTimer(0.8000000, false);
        return;
    }
    if(bMins1)
    {
        bMins1 = false;
        PlayTimeSound(sMins1);
        SetTimer(Delay, false);
        return;
    }
    if(bMins2)
    {
        bMins2 = false;
        PlayTimeSound(sMins2);
        SetTimer(0.8000000, false);
        return;
    }
    if(bSayMins)
    {
        bSayMins = false;
        PlayTimeSound("Minutes");
        SetTimer(0.9000000, false);
        return;
    }
    if(bAmPm)
    {
        bAmPm = false;
        PlayTimeSound(sAmPm);
        bDone = true;
        return;
    }
}
