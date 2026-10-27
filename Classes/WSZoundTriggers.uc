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

// Trigger lookup tables, built by BuildTriggerIndex() once MyZounds is final.
// Exact names are kept in one string per name length as Chr(1)$NAME records in list
// order, so one native InStr finds the first match and its offset gives the record.
var array<string> ExactHay;     // [L] = records of every playable trigger with an L-char name
var array<int> ExactBase;       // [L] = ExactIdx slot of bucket L's first record
var array<int> ExactIdx;        // MyZounds index of each record
var array<int> InlIdx;          // playable DedicatedOnly=False triggers, in list order
var array<int> InlLen;
var array<string> InlName;      // "NAME"
var array<string> InlPre;       // " NAME"
var array<string> InlBoth;      // " NAME "
var array<int> TrigFlags;       // 1 = AdminOnly, 2 = HideInMenu
// One-entry memo: ChatHandler resolves the same message once per receiver.
var string MemoIn, MemoName;
var int MemoIdx;
var bool bMemoValid, bMemoDed, bMemoInline;

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
    BuildTriggerIndex();
}

// Builds the lookup tables used by FindTrigger. MyZounds must not change afterwards
// without calling this again.
function BuildTriggerIndex()
{
    local array<string> Key;
    local array<int> Slot;
    local string S, D;
    local int i, k, L, F, n, Total;

    n = MyZounds.Length;
    Key.Length = n;
    Slot.Length = n;
    TrigFlags.Length = n;
    ExactHay.Length = 0;
    ExactBase.Length = 0;
    ExactIdx.Length = 0;
    InlIdx.Length = 0;
    InlLen.Length = 0;
    InlName.Length = 0;
    InlPre.Length = 0;
    InlBoth.Length = 0;
    bMemoValid = false;
    D = Chr(1);
    // Pass 1: flags, inline list, and bucket sizes (counted in ExactBase).
    for(i = 0; i < n; i++)
    {
        F = 0;
        if(MyZounds[i].AdminOnly)
        {
            F = 1;
        }
        if(MyZounds[i].HideInMenu)
        {
            F += 2;
        }
        TrigFlags[i] = F;
        Slot[i] = -1;
        if(MyZounds[i].Filename == "")
        {
            continue;
        }
        S = Caps(MyZounds[i].TriggerName);
        L = Len(S);
        if(!MyZounds[i].DedicatedOnly)
        {
            k = InlIdx.Length;
            InlIdx[k] = i;
            InlLen[k] = L;
            InlName[k] = S;
            InlPre[k] = " " $ S;
            InlBoth[k] = (" " $ S) $ " ";
        }
        // Chr(1) marks record starts, so a name containing it can't be indexed (or typed).
        if(InStr(S, D) != -1)
        {
            continue;
        }
        Key[i] = S;
        Slot[i] = L;
        if(L >= ExactBase.Length)
        {
            ExactBase.Length = L + 1;
        }
        ExactBase[L]++;
    }
    // Bucket sizes -> bucket end slots.
    for(L = 0; L < ExactBase.Length; L++)
    {
        Total += ExactBase[L];
        ExactBase[L] = Total;
    }
    ExactIdx.Length = Total;
    ExactHay.Length = ExactBase.Length;
    // Pass 2, walking backwards: each bucket's end slot steps down to its start slot,
    // and prepending keeps every bucket in list order.
    for(i = n - 1; i >= 0; i--)
    {
        L = Slot[i];
        if(L != -1)
        {
            ExactBase[L]--;
            ExactIdx[ExactBase[L]] = i;
            ExactHay[L] = (D $ Key[i]) $ ExactHay[L];
        }
    }
}

// MyZounds index of the first playable trigger whose Caps'd name is Key (Len L), or -1.
final function int FindExact(string Key, int L)
{
    local int p;

    if(L >= ExactHay.Length)
    {
        return -1;
    }
    p = InStr(ExactHay[L], Chr(1) $ Key);
    if(p == -1)
    {
        return -1;
    }
    return ExactIdx[ExactBase[L] + (p / (L + 1))];
}

// First trigger in list order that sTrig sets off, or -1, by the same rules as the
// original per-trigger loop. bMemoInline and MemoName describe the result.
final function int FindTrigger(string sTrig, bool bDedicated)
{
    local string S, Pat;
    local int i, k, L, N, Best;

    if((bMemoValid && bMemoDed == bDedicated) && MemoIn == sTrig)
    {
        return MemoIdx;
    }
    S = Caps(myMut.CheckOutTrigger(sTrig));
    N = Len(S);
    Best = FindExact(S, N);
    // "NAME " is the only other exact form: CheckOutTrigger leaves no double spaces.
    if((N > 0) && Mid(S, N - 1) == " ")
    {
        k = FindExact(Left(S, N - 1), N - 1);
        if((k != -1) && (Best == -1 || k < Best))
        {
            Best = k;
        }
    }
    bMemoInline = false;
    if(!bDedicated)
    {
        for(k = 0; k < InlIdx.Length; k++)
        {
            i = InlIdx[k];
            if((Best != -1) && i >= Best)
            {
                break;
            }
            L = InlLen[k];
            if(N > (L * 3))
            {
                Pat = InlName[k];
            }
            else if(N > (L * 2))
            {
                Pat = InlPre[k];
            }
            else
            {
                Pat = InlBoth[k];
            }
            if(InStr(S, Pat) != -1)
            {
                Best = i;
                bMemoInline = true;
                break;
            }
        }
    }
    bMemoValid = true;
    bMemoDed = bDedicated;
    MemoIn = sTrig;
    MemoIdx = Best;
    if(Best != -1)
    {
        MemoName = MyZounds[Best].TriggerName;
    }
    return Best;
}

function string GetTriggerWord(string sTrig, bool bNum, bool bAdm, optional bool bDedicated)
{
    local int i;

    i = FindTrigger(sTrig, bDedicated);
    if(i == -1)
    {
        return "";
    }
    // Inline matches are never DedicatedOnly; every other match counts as dedicated.
    myMut.bDedicated = !bMemoInline;
    if(bNum)
    {
        return string(i);
    }
    if(!bMemoInline)
    {
        if(!bAdm && (TrigFlags[i] & 1) != 0)
        {
            myMut.bHide = false;
        }
        else if(!myMut.ShowTrigger || TrigFlags[i] != 0)
        {
            // HideInMenu, or AdminOnly with an admin sender (the !bAdm case is above).
            myMut.bHide = true;
        }
    }
    return MemoName;
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
