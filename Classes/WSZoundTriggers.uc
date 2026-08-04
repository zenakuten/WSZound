class WSZoundTriggers extends Info
    config(WSZound)
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force);

struct ZoundTrigger
{
    var string SoundName;
    var string TriggerName;
    var bool DedicatedOnly;
    var bool HideInMenu;
    var bool AdminOnly;
    var int Random;
    var string Filename;
};

var config bool SortTriggerList;
var() config array<ZoundTrigger> Zounds;
var() array<ZoundTrigger> MyZounds;
var MutWSZound myMut;

function PreBeginPlay()
{
    if(default.Zounds.Length == 0)
    {
        default.Zounds.Length = 2;
        default.Zounds[0].SoundName = "PlayerEnter";
        default.Zounds[0].TriggerName = "PlayerEnter";
        default.Zounds[0].DedicatedOnly = true;
        default.Zounds[0].HideInMenu = true;
        default.Zounds[0].AdminOnly = false;
        default.Zounds[0].Random = 0;
        default.Zounds[0].Filename = "";
        default.Zounds[1].SoundName = "PlayerExit";
        default.Zounds[1].TriggerName = "PlayerExit";
        default.Zounds[1].DedicatedOnly = true;
        default.Zounds[1].HideInMenu = true;
        default.Zounds[1].AdminOnly = false;
        default.Zounds[1].Random = 0;
        default.Zounds[1].Filename = "";
        self.StaticSaveConfig();
    }
    super(Actor).PreBeginPlay();
}

function LoadSounds()
{
    local string sTemp;
    local int i, j;

    if(default.Zounds.Length == 0)
    {
        return;
    }
    for(i = 0; i < default.Zounds.Length; i++)
    {
        MyZounds[i] = default.Zounds[i];
    }
    myMut.TrigTimeout = 10;
    if(MyZounds.Length > 250)
    {
        myMut.TrigTimeout = (MyZounds.Length * 15) / 250;
    }
    if(default.SortTriggerList)
    {
        SortTriggers();
    }
    for(i = 0; i < MyZounds.Length; i++)
    {
        sTemp = MyZounds[i].SoundName;
        j = InStr(sTemp, ",");
        if(j != -1)
        {
            sTemp = Left(sTemp, j);
            MyZounds[i].SoundName = sTemp;
        }
    }
}

function string GetTriggerWord(string sTrig, bool bNum, bool bAdm, optional bool bDedicated)
{
    local string sTemp, sTemp2, sTemp3, sTrigger;
    local bool bInline;
    local int i, j;

    sTrigger = "";
    if(default.Zounds.Length == 0)
    {
        return "";
    }
    sTrig = myMut.CheckOutTrigger(sTrig);
    for(i = 0; i < MyZounds.Length; i++)
    {
        j = -1;
        bInline = false;
        sTemp = Caps(MyZounds[i].TriggerName);
        sTemp2 = Caps(MyZounds[i].TriggerName) $ " ";
        sTemp3 = Caps(MyZounds[i].TriggerName) $ "  ";
        if(((Caps(sTrig) == sTemp) || Caps(sTrig) == sTemp2) || Caps(sTrig) == sTemp3)
        {
            j = 1;
        }
        if((!MyZounds[i].DedicatedOnly && !bDedicated) && j != 1)
        {
            bInline = true;
            if(bAdm)
            {
                if(Caps(sTrig) == sTemp)
                {
                    j = 99;
                }
            }
            if(j == -1)
            {
                sTemp = Caps(MyZounds[i].TriggerName);
                if(Len(sTrig) > (Len(sTemp) * 3))
                {
                    sTemp = sTemp;                    
                }
                else
                {
                    if(Len(sTrig) > (Len(sTemp) * 2))
                    {
                        sTemp = " " $ sTemp;                        
                    }
                    else
                    {
                        sTemp = (" " $ sTemp) $ " ";
                    }
                }
                j = InStr(Caps(sTrig), sTemp);
            }
        }
        if((j != -1) && MyZounds[i].Filename != "")
        {
            sTrigger = MyZounds[i].TriggerName;
            if(bDedicated || !bInline)
            {
                myMut.bDedicated = true;                
            }
            else
            {
                myMut.bDedicated = MyZounds[i].DedicatedOnly;
            }
            break;
        }
    }
    if(i >= MyZounds.Length)
    {
        return "";
    }
    if(bNum)
    {
        return string(i);        
    }
    else
    {
        if(!bInline)
        {
            if(!bAdm && MyZounds[i].AdminOnly)
            {
                myMut.bHide = false;                
            }
            else
            {
                if(!myMut.ShowTrigger)
                {
                    myMut.bHide = true;                    
                }
                else
                {
                    if(myMut.ShowTrigger && MyZounds[i].HideInMenu)
                    {
                        myMut.bHide = true;                        
                    }
                    else
                    {
                        if(bAdm && MyZounds[i].AdminOnly)
                        {
                            myMut.bHide = true;
                        }
                    }
                }
            }            
        }
        else
        {
            if(bAdm && j == 99)
            {
                myMut.bHide = true;
            }
        }
    }
    return sTrigger;
}

function Sound GetCustomSound(string sTrig, Controller Sender, bool bInGame, optional bool bDedicated)
{
    local string sSound, sTemp, sFile;
    local Sound LoadSound;
    local bool IsAdmin;
    local int i, j, R;

    LoadSound = none;
    if(MyZounds.Length == 0)
    {
        return none;
    }
    IsAdmin = myMut.CheckZoundAdmin(PlayerController(Sender));
    sTemp = GetTriggerWord(sTrig, true, IsAdmin, bDedicated);
    if(sTemp == "")
    {
        return none;
    }
    i = int(sTemp);
    if(i >= MyZounds.Length)
    {
        return none;
    }
    sSound = MyZounds[i].SoundName;
    sTemp = MyZounds[i].TriggerName;
    if(!IsAdmin && bInGame)
    {
        if((sTemp ~= "PlayerEnter") || sTemp ~= "PlayerExit")
        {
            return none;
        }
        if(Sender != none)
        {
            if((sTemp ~= Sender.PlayerReplicationInfo.PlayerName) && !MyZounds[i].DedicatedOnly)
            {
                return none;
            }
        }
    }
    sFile = MyZounds[i].Filename;
    R = MyZounds[i].Random;
    if(R > 1)
    {
        R = Rand(R);
        if(R > 0)
        {
            sSound = sSound $ string(R + 1);
        }
        j = InStr(sFile, ".");
        if(j != -1)
        {
            sFile = Left(sFile, j) $ ".uax";            
        }
        else
        {
            sFile = sFile $ ".uax";
        }
    }
    LoadSound = Sound(DynamicLoadObject((sFile $ ".") $ (GetItemName(sSound)), Class'Engine.Sound'));
    if(LoadSound == none)
    {
        return none;
    }
    if(!IsAdmin && MyZounds[i].AdminOnly)
    {
        return none;
    }
    if(MyZounds[i].DedicatedOnly || bDedicated)
    {
        if(!myMut.ShowTrigger)
        {
            myMut.bHide = true;            
        }
        else
        {
            if(MyZounds[i].AdminOnly)
            {
                myMut.bHide = true;
            }
        }
    }
    return LoadSound;
}

function PreloadCustomSounds()
{
    local string sSound;
    local int i;

    if(MyZounds.Length == 0)
    {
        return;
    }
    for(i = 0; i < MyZounds.Length; i++)
    {
        sSound = MyZounds[i].SoundName;
        if((sSound != "") && MyZounds[i].Filename != "")
        {
            DynamicLoadObject((MyZounds[i].Filename $ ".") $ sSound, Class'Engine.Sound');
        }
    }
}

function LoadNames()
{
    local string sTemp;
    local int i, j, X;

    if(MyZounds.Length == 0)
    {
        return;
    }
    for(i = 0; i < 250; i++)
    {
        myMut.MySoundA[i] = "";
        myMut.MySoundB[i] = "";
        myMut.MySoundC[i] = "";
        myMut.MySoundD[i] = "";
        myMut.MySoundE[i] = "";
        myMut.MySoundF[i] = "";
        myMut.MySoundG[i] = "";
        myMut.MySoundH[i] = "";
    }
    myMut.MySoundA[0] = ">?time";
    myMut.NumTrigsA = 0;
    myMut.NumTrigsB = 0;
    X = 1;
    for(i = 0; i < MyZounds.Length; i++)
    {
        sTemp = GetParams(i);
        if(sTemp != "")
        {
            myMut.MySoundA[X] = sTemp;
            X++;
            if(X >= 250)
            {
                break;
            }
        }
    }
    if(X < 250)
    {
        return;
    }
    i++;
    X = 0;
    for(j = i; j < MyZounds.Length; j++)
    {
        sTemp = GetParams(j);
        if(sTemp != "")
        {
            myMut.MySoundB[X] = sTemp;
            X++;
            if(X >= 250)
            {
                break;
            }
        }
    }
    if(X < 250)
    {
        return;
    }
    j++;
    X = 0;
    for(i = j; i < MyZounds.Length; i++)
    {
        sTemp = GetParams(i);
        if(sTemp != "")
        {
            myMut.MySoundC[X] = sTemp;
            X++;
            if(X >= 250)
            {
                break;
            }
        }
    }
    if(X < 250)
    {
        return;
    }
    i++;
    X = 0;
    for(j = i; j < MyZounds.Length; j++)
    {
        sTemp = GetParams(j);
        if(sTemp != "")
        {
            myMut.MySoundD[X] = sTemp;
            X++;
            if(X >= 250)
            {
                break;
            }
        }
    }
    if(X < 250)
    {
        return;
    }
    j++;
    X = 0;
    for(i = j; i < MyZounds.Length; i++)
    {
        sTemp = GetParams(i);
        if(sTemp != "")
        {
            myMut.MySoundE[X] = sTemp;
            X++;
            if(X >= 250)
            {
                break;
            }
        }
    }
    if(X < 250)
    {
        return;
    }
    i++;
    X = 0;
    for(j = i; j < MyZounds.Length; j++)
    {
        sTemp = GetParams(j);
        if(sTemp != "")
        {
            myMut.MySoundF[X] = sTemp;
            X++;
            if(X >= 250)
            {
                break;
            }
        }
    }
    if(X < 250)
    {
        return;
    }
    j++;
    X = 0;
    for(i = j; i < MyZounds.Length; i++)
    {
        sTemp = GetParams(i);
        if(sTemp != "")
        {
            myMut.MySoundG[X] = sTemp;
            X++;
            if(X >= 250)
            {
                break;
            }
        }
    }
    if(X < 250)
    {
        return;
    }
    i++;
    X = 0;
    for(j = i; j < MyZounds.Length; j++)
    {
        sTemp = GetParams(j);
        if(sTemp != "")
        {
            myMut.MySoundH[X] = sTemp;
            X++;
            if(X >= 250)
            {
                break;
            }
        }
    }
    return;
}

function string GetParams(int iNum)
{
    local string sTemp;

    sTemp = MyZounds[iNum].TriggerName;
    if((sTemp == "PlayerEnter") || sTemp == "PlayerExit")
    {
        return "";
    }
    if(MyZounds[iNum].AdminOnly)
    {
        if(MyZounds[iNum].DedicatedOnly)
        {
            sTemp = "}" $ sTemp;            
        }
        else
        {
            sTemp = "{" $ sTemp;
        }        
    }
    else
    {
        if(MyZounds[iNum].HideInMenu)
        {
            if(MyZounds[iNum].DedicatedOnly)
            {
                sTemp = "]" $ sTemp;                
            }
            else
            {
                sTemp = "[" $ sTemp;
            }            
        }
        else
        {
            if(MyZounds[iNum].Random > 0)
            {
                if(MyZounds[iNum].DedicatedOnly)
                {
                    sTemp = ")" $ sTemp;                    
                }
                else
                {
                    sTemp = "(" $ sTemp;
                }                
            }
            else
            {
                if(MyZounds[iNum].DedicatedOnly)
                {
                    sTemp = ">" $ sTemp;                    
                }
                else
                {
                    sTemp = "<" $ sTemp;
                }
            }
        }
    }
    if(sTemp != "")
    {
        myMut.NumTrigsA++;
        if((((Left(sTemp, 1) != "[") && Left(sTemp, 1) != "]") && Left(sTemp, 1) != "{") && Left(sTemp, 1) != "}")
        {
            myMut.NumTrigsB++;
        }
    }
    return sTemp;
}

function SortTriggers()
{
    local array<ZoundTrigger> TempZound;
    local int i, j;

    TempZound.Length = 1;
    for(i = 0; i < MyZounds.Length; i++)
    {
        for(j = i + 1; j < MyZounds.Length; j++)
        {
            if(Caps(MyZounds[i].TriggerName) > Caps(MyZounds[j].TriggerName))
            {
                TempZound[0] = MyZounds[i];
                MyZounds[i] = MyZounds[j];
                MyZounds[j] = TempZound[0];
            }
        }
    }
    for(i = 0; i < MyZounds.Length; i++)
    {
        default.Zounds[i] = MyZounds[i];
    }
    default.SortTriggerList = false;
    self.StaticSaveConfig();
}
