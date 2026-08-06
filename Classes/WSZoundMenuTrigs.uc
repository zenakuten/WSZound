class WSZoundMenuTrigs extends PopupPageBase
    config(User)
    editinlinenew
    instanced;

var string sCode;
var string MyMutes;
var string MyFavors;
var string MyServerID;
var string MyTrigger;
var string MyPlayer;
var bool bSaveMute;
var bool bSaveFavs;
var bool bSaveClient;
var bool bSavePlayer;
var bool bSaveBind;
var bool bTimer1;
var bool bTimer2;
var bool bStartup;
var bool bRepWait;
var bool bAdmin;
var() bool bReset;
var string sText;
var int iTotal;
var int numSounds;
var int RepSecs;
var int NumTrigsA;
var int NumTrigsB;
var string MySoundA[251];
var string MySoundB[251];
var string MySoundC[251];
var string MySoundD[251];
var string MySoundE[251];
var string MySoundF[251];
var string MySoundG[251];
var string MySoundH[251];
var string KeyBind[125];
var bool MyZound;
var int MyKeyBind;
var int MyVolume;
var export editinline moCheckBox bZoundCnt;
var export editinline moCheckBox MuteLenBox;
var export editinline GUISlider MuteLenSlider;
var export editinline GUILabel MuteLenLabel;
var Material MuteLenFill;
var export editinline GUIListBox PlayerList;
var export editinline GUIListBox KeyBindList;
var export editinline GUISlider BindSlider;
var export editinline moEditBox ChatLine;
var export editinline GUILabel Muted;
var export editinline GUILabel total;
var export editinline GUILabel LabSounds;
var export editinline GUIButton btnSave;
var export editinline GUIListBox AllTrigList;
var export editinline moEditBox FilterBox;
var string sFilter;
var export editinline GUIListBox MutedList;
var export editinline GUIListBox FavorList;
var export editinline GUIScrollTextBox CodedList;
var WSZoundReplication ZRI;
var Color clRed;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    MyController.RegisterStyle(Class'WSZoundStyle', true);
    MyController.RegisterStyle(Class'STY_WSButton', true);
    MyController.RegisterStyle(Class'STY_WSButtonActive', true);
    MyController.RegisterStyle(Class'STY_WSButtonTab', true);
    MyController.RegisterStyle(Class'STY_WSCheckBox', true);
    MyController.RegisterStyle(Class'STY_WSComboButton', true);
    MyController.RegisterStyle(Class'STY_WSEditBox', true);
    MyController.RegisterStyle(Class'STY_WSLabel', true);
    MyController.RegisterStyle(Class'STY_WSLabelWhite', true);
    MyController.RegisterStyle(Class'STY_WSListBox', true);
    MyController.RegisterStyle(Class'STY_WSSliderBar', true);
    MyController.RegisterStyle(Class'STY_WSSliderCaption', true);
    MyController.RegisterStyle(Class'STY_WSSliderKnob', true);
    MyController.RegisterStyle(Class'STY_WSSliderKnobWhite', true);
    MyController.RegisterStyle(Class'STY_WSSpinner', true);
    MyController.RegisterStyle(Class'STY_WSVertDownButton', true);
    MyController.RegisterStyle(Class'STY_WSVertUpButton', true);
    super(GUIPage).InitComponent(MyController, MyOwner);
    total = GUILabel(Controls[3]);
    Muted = GUILabel(Controls[5]);
    AllTrigList = GUIListBox(Controls[7]);
    AllTrigList.List.TextAlign = TXTA_Left;
    AllTrigList.List.__OnDblClick__Delegate = AllTrigListDblClick;
    CodedList = GUIScrollTextBox(Controls[8]);
    CodedList.TextAlign = TXTA_Left;
    Controls[8].bVisible = false;
    MutedList = GUIListBox(Controls[9]);
    MutedList.List.TextAlign = TXTA_Left;
    FavorList = GUIListBox(Controls[10]);
    FavorList.List.TextAlign = TXTA_Left;
    FavorList.List.__OnDblClick__Delegate = FavorListDblClick;
    LabSounds = GUILabel(Controls[19]);
    ChatLine = moEditBox(Controls[20]);
    moEditBox(Controls[20]).MyEditBox.MaxWidth = 80;
    ChatLine.MyEditBox.CaretPos = 1;
    FilterBox = moEditBox(Controls[36]);
    FilterBox.MyEditBox.OnChange = OnFilterChange;
    ChatLine.__OnKeyEvent__Delegate = CheckMessage;
    btnSave = GUIButton(Controls[25]);
    PlayerList = GUIListBox(Controls[30]);
    PlayerList.List.TextAlign = TXTA_Left;
    KeyBindList = GUIListBox(Controls[32]);
    KeyBindList.List.TextAlign = TXTA_Left;
    SetKeyBindList();
    bZoundCnt = moCheckBox(Controls[33]);
    BindSlider = GUISlider(Controls[35]);
    MuteLenBox = moCheckBox(Controls[37]);
    MuteLenLabel = GUILabel(Controls[38]);
    MuteLenSlider = GUISlider(Controls[39]);
    MuteLenFill = MuteLenSlider.FillImage;
    ResetFocus();
    CheckReplication();
    GUIButton(Controls[23]).Hint = ("Play selected Trigger" $ Chr(10)) $ "to yourself only";
    GUIButton(Controls[26]).Caption = (((Chr(27) $ Chr(240)) $ Chr(240)) $ Chr(240)) $ "Close";
    RepSecs = 0;
}

function HandleParameters(string Param1, string Param2)
{
    local string sTemp, P1, P2;
    local int i, res;

    if(ZRI == none)
    {
        CheckReplication();
    }
    P1 = Param1;
    P2 = Param2;
    sTemp = PlayerOwner().ConsoleCommand("GETCURRENTRES");
    i = InStr(sTemp, "x");
    if(i > 0)
    {
        res = int(Left(sTemp, i));
        if((res != 0) && res < 900)
        {
            GUILabel(Controls[3]).WinLeft = 0.3900000;
            for(i = 0; i < 36; i++)
            {
                if(Controls[i].IsA('GUILabel'))
                {
                    GUILabel(Controls[i]).TextFont = "UT2IRCFont";
                }
            }
        }
    }
    i = InStr(Param1, ",");
    sCode = Left(Param1, i);
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    bAdmin = bool(Left(Param1, i));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    bZoundCnt.Checked(bool(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    bRepWait = bool(sTemp);
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    NumTrigsA = int(sTemp);
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    NumTrigsB = int(sTemp);
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param2, ",");
    sTemp = Left(Param2, i);
    MyPlayer = sTemp;
    Param2 = Mid(Param2, i + 1);
    i = InStr(Param2, ",");
    sTemp = Left(Param2, i);
    numSounds = int(sTemp);
    Param2 = Mid(Param2, i + 1);
    SetPlayerList();
    CheckNumSounds(true);
    if(!bZoundCnt.IsChecked())
    {
        ClearAllZoundOptions();
    }
    if(!bRepWait)
    {
        LoadTriggers(true);
    }
    bStartup = true;
    SetTimer(0.3300000, true);
    LoadFavorWords();
    LoadFavorList();
    if(bAdmin)
    {
        Muted.Caption = "Coded Triggers   ";
        Controls[8].WinLeft = 0.4840000;
        Controls[9].WinLeft = 0.8500000;
        Controls[9].DisableMe();
        Controls[9].bVisible = false;
        Controls[8].bVisible = true;
        Controls[11].bVisible = false;
        Controls[12].bVisible = false;
        Controls[15].bVisible = true;
        Controls[16].bVisible = true;
        Controls[17].bVisible = true;
        Controls[18].bVisible = true;
        Controls[21].bVisible = true;
        Controls[22].bVisible = false;        
    }
    else
    {
        Controls[8].bVisible = false;
        Controls[8].WinLeft = 0.8500000;
        Controls[9].WinLeft = 0.4840000;
        Controls[8].DisableMe();
        Controls[21].bVisible = false;
        Controls[22].bVisible = true;
        LoadMutedWords();
        LoadMutedList();
    }
    FavorList.List.SetIndex(0);
    LoadClientStuff();
    bSaveFavs = false;
    bSaveMute = false;
    bSaveClient = false;
    btnSave.Caption = "Save";
    ChatLine.SetText("");
    Controls[20].SetFocus(none);
}

function ResetFocus()
{
    Controls[7].SetFocus(none);
}

function Timer()
{
    if(default.bReset)
    {
        default.bReset = false;
        ResetFocus();
    }
    if(bRepWait)
    {
        RepSecs++;
        if(RepSecs == 3)
        {
            RepSecs = 0;
            LoadTriggers(false);
        }
    }
    if(bStartup)
    {
        bStartup = false;
        ChatLine.SetText("");
    }
    if((((bSaveFavs || bSaveMute) || bSaveClient) || bSavePlayer) || bSaveBind)
    {
        bTimer1 = !bTimer1;
        if(bTimer1)
        {
            btnSave.Caption = (((Chr(27) $ Chr(240)) $ Chr(16)) $ Chr(16)) $ "Save";            
        }
        else
        {
            btnSave.Caption = (((Chr(27) $ Chr(240)) $ Chr(240)) $ Chr(240)) $ "Save";
        }
    }
}

function bool CheckNumSounds(optional bool bStart)
{
    if(bAdmin)
    {
        LabSounds.Caption = "AdminOnly";
        LabSounds.TextColor = clRed;
        LabSounds.TextAlign = TXTA_Left;
        return true;
    }
    if(numSounds >= 9999)
    {
        LabSounds.Caption = "Unlimited Zounds";
        return true;        
    }
    else
    {
        if(numSounds == 0)
        {
            LabSounds.Caption = "Zounds left: " $ string(numSounds);
            return false;            
        }
        else
        {
            if(!bStart)
            {
                numSounds--;
            }
            LabSounds.Caption = "Zounds left: " $ string(numSounds);
            return true;
        }
    }
}

function ClearAllZoundOptions()
{
    local int i;

    for(i = 0; i < 36; i++)
    {
        if(((i != 25) && i != 26) && i != 33)
        {
            Controls[i].DisableMe();
        }
    }
}

function LoadMutedList()
{
    local string sTemp, sMutes;
    local int j;

    MutedList.List.Clear();
    sMutes = MyMutes;
    j = InStr(sMutes, ",");
    while(j != -1)
    {
        sTemp = Left(sMutes, j);
        if(sTemp == "")
        {
            break;
        }
        MutedList.List.Add(sTemp);
        sMutes = Mid(sMutes, j + 1);
        j = InStr(sMutes, ",");
    }
    MutedList.List.Sort();
    MutedList.List.SetIndex(0);
}

function LoadFavorList()
{
    local string sTemp, sFavr;
    local int j;

    FavorList.List.Clear();
    sFavr = MyFavors;
    j = InStr(sFavr, ",");
    while(j != -1)
    {
        sTemp = Left(sFavr, j);
        if(sTemp == "")
        {
            break;
        }
        FavorList.List.Add(sTemp);
        sFavr = Mid(sFavr, j + 1);
        j = InStr(sFavr, ",");
    }
    FavorList.List.Sort();
    FavorList.List.SetIndex(0);
}

function CheckReplication()
{
    foreach PlayerOwner().DynamicActors(Class'WSZoundReplication', ZRI)
    {
        break;        
    }    
}

function OnFilterChange(GUIComponent Sender)
{
    sFilter = Caps(FilterBox.GetText());
    LoadTriggers(true);
}

function LoadTriggers(bool bDone)
{
    local int i;

    if(ZRI == none)
    {
        CheckReplication();
    }
    if(ZRI == none)
    {
        return;
    }
    AllTrigList.List.Clear();
    iTotal = 0;
    sText = "";
    for(i = 0; i < 250; i++)
    {
        if(MySoundA[i] == "")
        {
            MySoundA[i] = ZRI.SoundA[i];
            if(MySoundA[i] == "")
            {
                break;
            }
        }
        AddToAllTriggers(MySoundA[i], bAdmin);
    }
    for(i = 0; i < 250; i++)
    {
        if(MySoundB[i] == "")
        {
            MySoundB[i] = ZRI.SoundB[i];
            if(MySoundB[i] == "")
            {
                break;
            }
        }
        AddToAllTriggers(MySoundB[i], bAdmin);
    }
    for(i = 0; i < 250; i++)
    {
        if(MySoundC[i] == "")
        {
            MySoundC[i] = ZRI.SoundC[i];
            if(MySoundC[i] == "")
            {
                break;
            }
        }
        AddToAllTriggers(MySoundC[i], bAdmin);
    }
    for(i = 0; i < 250; i++)
    {
        if(MySoundD[i] == "")
        {
            MySoundD[i] = ZRI.SoundD[i];
            if(MySoundD[i] == "")
            {
                break;
            }
        }
        AddToAllTriggers(MySoundD[i], bAdmin);
    }
    for(i = 0; i < 250; i++)
    {
        if(MySoundE[i] == "")
        {
            MySoundE[i] = ZRI.SoundE[i];
            if(MySoundE[i] == "")
            {
                break;
            }
        }
        AddToAllTriggers(MySoundE[i], bAdmin);
    }
    for(i = 0; i < 250; i++)
    {
        if(MySoundF[i] == "")
        {
            MySoundF[i] = ZRI.SoundF[i];
            if(MySoundF[i] == "")
            {
                break;
            }
        }
        AddToAllTriggers(MySoundF[i], bAdmin);
    }
    for(i = 0; i < 250; i++)
    {
        if(MySoundG[i] == "")
        {
            MySoundG[i] = ZRI.SoundG[i];
            if(MySoundG[i] == "")
            {
                break;
            }
        }
        AddToAllTriggers(MySoundG[i], bAdmin);
    }
    for(i = 0; i < 250; i++)
    {
        if(MySoundH[i] == "")
        {
            MySoundH[i] = ZRI.SoundH[i];
            if(MySoundH[i] == "")
            {
                break;
            }
        }
        AddToAllTriggers(MySoundH[i], bAdmin);
    }
    if(bAdmin)
    {
        if(sText == "")
        {
            sText = "      ";
        }
        CodedList.MyScrollText.SetContent(sText, Chr(10));
    }
    ShowTotalTriggers(iTotal, bDone);
}

function ShowTotalTriggers(int iTot, bool bDone)
{
    local string sTemp, sTotal;
    local int t;

    if(bAdmin)
    {
        t = NumTrigsA;        
    }
    else
    {
        t = NumTrigsB;
    }
    sTemp = GetStringTriggers(iTot);
    if((iTot >= t) || bDone)
    {
        t = iTot;
        bRepWait = false;
        sTotal = GetStringTriggers(t);
        total.Caption = (("Total Triggers: " $ sTemp) $ "/") $ sTotal;        
    }
    else
    {
        sTotal = GetStringTriggers(t + 1);
        total.Caption = (("Loading...... : " $ sTemp) $ "/") $ sTotal;
    }
}

function string GetStringTriggers(int iNum)
{
    local string sTemp;

    sTemp = "";
    if(iNum < 10)
    {
        sTemp = "000";        
    }
    else
    {
        if(iNum < 100)
        {
            sTemp = "00";            
        }
        else
        {
            if(iNum < 1000)
            {
                sTemp = "0";
            }
        }
    }
    sTemp = sTemp $ string(iNum);
    return sTemp;
}

function AddToAllTriggers(string sTrig, bool bAdm)
{
    local string sTemp;

    if(sTrig != "")
    {
        sTemp = Left(sTrig, 1);
        sTrig = Mid(sTrig, 1);
        if(!bAdm && (((sTemp == "{") || sTemp == "}") || sTemp == "[") || sTemp == "]")
        {
            return;
        }
        if((sFilter == "") || InStr(Caps(sTrig), sFilter) != -1)
        {
            AllTrigList.List.Add(sTrig);
            iTotal++;
        }
        if(bAdm)
        {
            AddToCodedList(sTrig, sTemp);
        }
    }
}

function AddToCodedList(string sTrig, string sLeft)
{
    local string Yel, Red, Wht, Blu, Grn, Vio,
	    Aqu;

    Yel = "��";
    Red = "�";
    Wht = "���";
    Blu = "��";
    Grn = "�";
    Vio = "��";
    Aqu = "��";
    if((sTrig == "") || sLeft == "")
    {
        return;
    }
    if(sLeft == "}")
    {
        sTrig = (((Red $ sTrig) $ Blu) $ "*") $ Wht;        
    }
    else
    {
        if(sLeft == "{")
        {
            sTrig = (Red $ sTrig) $ Wht;            
        }
        else
        {
            if(sLeft == "]")
            {
                sTrig = (((Yel $ sTrig) $ Blu) $ "*") $ Wht;                
            }
            else
            {
                if(sLeft == "[")
                {
                    sTrig = (Yel $ sTrig) $ Wht;                    
                }
                else
                {
                    if(sLeft == ")")
                    {
                        sTrig = (((Grn $ sTrig) $ Blu) $ "*") $ Wht;                        
                    }
                    else
                    {
                        if(sLeft == "(")
                        {
                            sTrig = (Grn $ sTrig) $ Wht;                            
                        }
                        else
                        {
                            if(sLeft == ">")
                            {
                                sTrig = ((sTrig $ Blu) $ "*") $ Wht;
                            }
                        }
                    }
                }
            }
        }
    }
    sText = (sText $ sTrig) $ Chr(10);
}

function bool FavorListDblClick(GUIComponent Sender)
{
    local string sTemp;
    local int i;

    i = FavorList.List.Index;
    if(i < 0)
    {
        return false;
    }
    sTemp = FavorList.List.GetItemAtIndex(i);
    if(sTemp == "")
    {
        return false;
    }
    MyTrigger = sTemp;
    ChatLine.SetText("");
    ResetFocus();
    if(!bAdmin && !CheckNumSounds())
    {
        return false;
    }
    PlayerOwner().ConsoleCommand("Say " $ sTemp);
}

function bool CheckMessage(out byte Key, out byte State, float Delta)
{
    local string sTemp;

    if((int(Key) == 13) && int(State) == 1)
    {
        sTemp = ChatLine.GetText();
        ChatLine.SetText("");
        if(CheckIfTrigger(sTemp))
        {
            if(!bAdmin && !CheckNumSounds())
            {
                return false;
            }
        }
        PlayerOwner().ConsoleCommand("Say " $ sTemp);
        return true;
    }
    return false;
}

function bool CheckIfTrigger(string sTrig)
{
    local string sTemp;
    local int i, j, L;

    L = AllTrigList.List.ItemCount;
    if(L == 0)
    {
        return false;
    }
    sTrig = Caps(sTrig);
    for(i = 1; i < 50; i++)
    {
        if(Left(sTrig, 1) == " ")
        {
            sTrig = Mid(sTrig, 1);
        }
    }
    i = InStr(sTrig, "  ");
    while(i != -1)
    {
        sTrig = Left(sTrig, i) $ Mid(sTrig, i + 1);
        i = InStr(sTrig, "  ");
    }
    if((sTrig != "") && Mid(sTrig, Len(sTrig) - 1) == " ")
    {
        if(Mid(sTrig, Len(sTrig)) == "")
        {
            if(InStr(sTrig, " ") == -1)
            {
                sTrig = Left(sTrig, Len(sTrig) - 1);
            }
        }
    }
    for(i = 0; i < L; i++)
    {
        sTemp = Caps(AllTrigList.List.GetItemAtIndex(i));
        if(sTrig == sTemp)
        {
            return true;
        }
        sTemp = sTemp $ " ";
        if(sTrig == sTemp)
        {
            return true;
        }
        sTemp = " " $ sTemp;
        j = InStr(sTrig, sTemp);
        if(j != -1)
        {
            return true;
        }
    }
    return false;
}

function bool AllTrigListDblClick(GUIComponent Sender)
{
    local string sTemp;
    local int i;

    i = AllTrigList.List.Index;
    if(i < 0)
    {
        return false;
    }
    sTemp = AllTrigList.List.GetItemAtIndex(i);
    if(sTemp == "")
    {
        return false;
    }
    MyTrigger = sTemp;
    ChatLine.SetText("");
    ResetFocus();
    if(!bAdmin && !CheckNumSounds())
    {
        return false;
    }
    PlayerOwner().ConsoleCommand("Say " $ sTemp);
    return true;
}

function bool OnClickSubFav(GUIComponent Sender)
{
    local string sTemp;
    local int i;

    ResetFocus();
    if(FavorList.List.ItemCount == 0)
    {
        return false;
    }
    i = FavorList.List.Index;
    sTemp = FavorList.List.GetItemAtIndex(i);
    i = InStr(Caps(MyFavors), Caps(sTemp) $ ",");
    if(i == -1)
    {
        PlayerOwner().ClientMessage(("< Cannot find " $ sTemp) $ " in your Favourite List >");
        PlayerOwner().ClientPlaySound(Sound'PickupSounds.UDamagePickup');
        return false;
    }
    MyFavors = Left(MyFavors, i) $ Mid(MyFavors, (i + Len(sTemp)) + 1);
    LoadFavorList();
    btnSave.Caption = (((Chr(27) $ Chr(254)) $ Chr(16)) $ Chr(16)) $ "Save";
    bSaveFavs = true;
    return true;
}

function bool OnClickAddFav(GUIComponent Sender)
{
    local string sTemp;
    local int i;

    ResetFocus();
    i = AllTrigList.List.Index;
    sTemp = AllTrigList.List.GetItemAtIndex(i);
    i = InStr(Caps(MyFavors), Caps(sTemp) $ ",");
    if(i != -1)
    {
        PlayerOwner().ClientMessage(("< " $ sTemp) $ " is already in your Favourite List >");
        PlayerOwner().ClientPlaySound(Sound'PickupSounds.UDamagePickup');
        return false;
    }
    if(((Len(MyFavors) + Len(sTemp)) + 1) > 4000)
    {
        PlayerOwner().ClientMessage("< Your Favourites buffer has reached its Limit >");
        PlayerOwner().ClientPlaySound(Sound'PickupSounds.UDamagePickup');
        return false;
    }
    MyFavors = (sTemp $ ",") $ MyFavors;
    LoadFavorList();
    btnSave.Caption = (((Chr(27) $ Chr(254)) $ Chr(16)) $ Chr(16)) $ "Save";
    bSaveFavs = true;
    return true;
}

function bool OnClickSubMute(GUIComponent Sender)
{
    local string sTemp;
    local int i;

    ResetFocus();
    if(FavorList.List.ItemCount == 0)
    {
        return false;
    }
    i = MutedList.List.Index;
    sTemp = MutedList.List.GetItemAtIndex(i);
    i = InStr(Caps(MyMutes), Caps(sTemp) $ ",");
    if(i == -1)
    {
        PlayerOwner().ClientMessage(("< Cannot find " $ sTemp) $ " in your Mute buffer >");
        PlayerOwner().ClientPlaySound(Sound'PickupSounds.UDamagePickup');
        return false;
    }
    MyMutes = Left(MyMutes, i) $ Mid(MyMutes, (i + Len(sTemp)) + 1);
    LoadMutedList();
    btnSave.Caption = (((Chr(27) $ Chr(254)) $ Chr(16)) $ Chr(16)) $ "Save";
    bSaveMute = true;
    return true;
}

function bool OnClickAddMute(GUIComponent Sender)
{
    local string sTemp;
    local int i;

    ResetFocus();
    i = AllTrigList.List.Index;
    sTemp = AllTrigList.List.GetItemAtIndex(i);
    i = InStr(Caps(MyMutes), Caps(sTemp) $ ",");
    if(i != -1)
    {
        PlayerOwner().ClientMessage(("< " $ sTemp) $ " is already in your Mute buffer >");
        PlayerOwner().ClientPlaySound(Sound'PickupSounds.UDamagePickup');
        return false;
    }
    if(((Len(MyMutes) + Len(sTemp)) + 1) > 4000)
    {
        PlayerOwner().ClientMessage("< Your Mute buffer has reached its Limit >");
        PlayerOwner().ClientPlaySound(Sound'PickupSounds.UDamagePickup');
        return false;
    }
    MyMutes = (sTemp $ ",") $ MyMutes;
    LoadMutedList();
    btnSave.Caption = (((Chr(27) $ Chr(254)) $ Chr(16)) $ Chr(16)) $ "Save";
    bSaveMute = true;
    return true;
}

function bool OnRightClickSave(GUIComponent Sender)
{
    ResetFocus();
    bSaveMute = false;
    bSaveFavs = false;
    bSaveClient = false;
    bSavePlayer = false;
    bSaveBind = false;
    btnSave.Caption = "Save";
    return true;
}

function bool OnClickSave(GUIComponent Sender)
{
    local string sTemp;
    local int i;

    ResetFocus();
    if(bSaveFavs)
    {
        bSaveFavs = false;
        if(Len(MyFavors) < 4000)
        {
            SaveFavorWords();            
        }
        else
        {
            PlayerOwner().ClientMessage("< Your Favourites buffer has reached its Limit >");
            PlayerOwner().ClientPlaySound(Sound'PickupSounds.UDamagePickup');
        }
    }
    if(bSaveMute)
    {
        bSaveMute = false;
        sTemp = MyMutes;
        if((sTemp != "") && Mid(sTemp, Len(sTemp) - 1) != ",")
        {
            sTemp = sTemp $ ",";
        }
        if(Len(sTemp) < 200)
        {
            PlayerOwner().Player.Console.DelayedConsoleCommand((("MUTATE " $ sCode) $ "ZoundClientMute-") $ sTemp);
            SaveMutedWords();            
        }
        else
        {
            PlayerOwner().ClientMessage("< Your Mute buffer has reached its Limit >");
            PlayerOwner().ClientPlaySound(Sound'PickupSounds.UDamagePickup');
        }
    }
    if(bSaveClient)
    {
        bSaveClient = false;
        SaveClientStuff(false);
    }
    if(bSavePlayer)
    {
        i = PlayerList.List.Index;
        sTemp = PlayerList.List.GetItemAtIndex(i);
        MyPlayer = sTemp;
        PlayerOwner().Player.Console.DelayedConsoleCommand((("MUTATE " $ sCode) $ "ZoundClientMutePlayer-") $ sTemp);
        bSavePlayer = false;
        SetPlayerList();
    }
    if(bSaveBind)
    {
        i = KeyBindList.List.Index;
        sTemp = KeyBindList.List.GetItemAtIndex(i);
        sTemp = Mid(sTemp, 5);
        MyKeyBind = FindKeyBind(sTemp);
        SaveClientStuff(true);
        bSaveBind = false;
    }
    btnSave.Caption = "Save";
    return true;
}

function LoadMutedWords()
{
    local int i, j;

    j = Class'WSZoundClient'.default.ZoundServer.Length;
    if(j == 0)
    {
        return;
    }
    MyServerID = Class'WSZoundClient'.default.MyServerID;
    for(i = 0; i < j; i++)
    {
        if(Class'WSZoundClient'.default.ZoundServer[i].ServerID == MyServerID)
        {
            MyMutes = Class'WSZoundClient'.default.ZoundServer[i].MutedWords;
            if(Len(MyMutes) > 4000)
            {
                MyMutes = Left(MyMutes, 4000);
            }
            if((MyMutes != "") && Mid(MyMutes, Len(MyMutes) - 1) != ",")
            {
                MyMutes = MyMutes $ ",";
            }
            return;
        }
    }
}

function SaveMutedWords()
{
    local string sTemp;
    local int i, j;

    j = Class'WSZoundClient'.default.ZoundServer.Length;
    MyServerID = Class'WSZoundClient'.default.MyServerID;
    sTemp = MyMutes;
    if((sTemp != "") && Mid(sTemp, Len(sTemp) - 1) == ",")
    {
        sTemp = Left(sTemp, Len(sTemp) - 1);
    }
    if(j != 0)
    {
        for(i = 0; i < j; i++)
        {
            if(Class'WSZoundClient'.default.ZoundServer[i].ServerID == MyServerID)
            {
                Class'WSZoundClient'.default.ZoundServer[i].MutedWords = sTemp;
                Class'WSZoundClient'.static.StaticSaveConfig();
                return;
            }
        }
    }
    if(j > 1000)
    {
        return;
    }
    Class'WSZoundClient'.default.ZoundServer.Length = j + 1;
    Class'WSZoundClient'.default.ZoundServer[j].ServerID = MyServerID;
    Class'WSZoundClient'.default.ZoundServer[j].MutedWords = sTemp;
    Class'WSZoundClient'.static.StaticSaveConfig();
}

function LoadFavorWords()
{
    local int i, j;

    j = Class'WSZoundClient'.default.ZoundServer.Length;
    if(j == 0)
    {
        return;
    }
    MyServerID = Class'WSZoundClient'.default.MyServerID;
    for(i = 0; i < j; i++)
    {
        if(Class'WSZoundClient'.default.ZoundServer[i].ServerID == MyServerID)
        {
            MyFavors = Class'WSZoundClient'.default.ZoundServer[i].Favourites;
            if(Len(MyFavors) > 4000)
            {
                MyFavors = Left(MyFavors, 4000);
            }
            if((MyFavors != "") && Mid(MyFavors, Len(MyFavors) - 1) != ",")
            {
                MyFavors = MyFavors $ ",";
            }
            return;
        }
    }
}

function SaveFavorWords()
{
    local string sTemp;
    local int i, j;

    j = Class'WSZoundClient'.default.ZoundServer.Length;
    MyServerID = Class'WSZoundClient'.default.MyServerID;
    sTemp = MyFavors;
    if((sTemp != "") && Mid(sTemp, Len(sTemp) - 1) == ",")
    {
        sTemp = Left(sTemp, Len(sTemp) - 1);
    }
    if(j != 0)
    {
        for(i = 0; i < j; i++)
        {
            if(Class'WSZoundClient'.default.ZoundServer[i].ServerID == MyServerID)
            {
                Class'WSZoundClient'.default.ZoundServer[i].Favourites = sTemp;
                Class'WSZoundClient'.static.StaticSaveConfig();
                return;
            }
        }
    }
    if(j >= 1000)
    {
        return;
    }
    Class'WSZoundClient'.default.ZoundServer.Length = j + 1;
    Class'WSZoundClient'.default.ZoundServer[j].ServerID = MyServerID;
    Class'WSZoundClient'.default.ZoundServer[j].Favourites = sTemp;
    Class'WSZoundClient'.static.StaticSaveConfig();
}

function bool OnClickAdmin(GUIComponent Sender)
{
    PlayerOwner().Player.Console.DelayedConsoleCommand(("MUTATE " $ sCode) $ "ZoundAdminMenu");
    Controller.CloseMenu(false);
    return true;
}

function bool OnClickAllList(GUIComponent Sender)
{
    local int i;

    i = AllTrigList.List.Index;
    if(i < 0)
    {
        return false;
    }
    MyTrigger = AllTrigList.List.GetItemAtIndex(i);
    return true;
}

function bool OnClickMutedList(GUIComponent Sender)
{
    local int i;

    i = MutedList.List.Index;
    if(i < 0)
    {
        return false;
    }
    MyTrigger = MutedList.List.GetItemAtIndex(i);
    return true;
}

function bool OnClickFavorList(GUIComponent Sender)
{
    local int i;

    i = FavorList.List.Index;
    if(i < 0)
    {
        return false;
    }
    MyTrigger = FavorList.List.GetItemAtIndex(i);
    return true;
}

function bool OnClickTest(GUIComponent Sender)
{
    if(MyTrigger != "")
    {
        PlayerOwner().ConsoleCommand("Say ~" $ MyTrigger);
        ChatLine.SetText("");
        ResetFocus();
    }
    return true;
}

function bool OnClickDump(GUIComponent Sender)
{
    local string sTemp, sDump, SvrID;
    local int i, j, X, Z;

    ResetFocus();
    if(MyServerID == "")
    {
        return false;
    }
    SvrID = MyServerID;
    Z = 2;
    X = AllTrigList.List.ItemCount;
    for(i = 0; i < X; i++)
    {
        sTemp = AllTrigList.List.GetItemAtIndex(i);
        sDump = (sDump $ sTemp) $ ",";
        j = Len(sDump);
        if(j > 960)
        {
            Controller.OpenMenu("WSZound.WSZoundNames", SvrID, sDump);
            SvrID = (MyServerID $ "_") $ string(Z);
            sDump = "";
            Z++;
            j = 0;
        }
    }
    if(j > 3)
    {
        Controller.OpenMenu("WSZound.WSZoundNames", SvrID, sDump);
    }
    ResetFocus();
    return true;
}

function OnMuteLenChange(GUIComponent Sender)
{
    MuteLenLabel.Caption = ("Max Length: " $ FmtSeconds(MuteLenSlider.Value)) $ "s";
    btnSave.Caption = (((Chr(27) $ Chr(254)) $ Chr(16)) $ Chr(16)) $ "Save";
    bSaveClient = true;
}

// The max-length slider only means anything while long-zound muting is on, so
// grey it (and its label) out when the checkbox is unchecked. A disabled slider
// draws with the style's disabled images and ignores mouse/keyboard; the fill
// bar is drawn natively at full brightness regardless, so drop it too.
function UpdateMuteLenEnabled()
{
    if(MuteLenBox.IsChecked())
    {
        MuteLenSlider.FillImage = MuteLenFill;
        MuteLenSlider.EnableMe();
        MuteLenLabel.EnableMe();
    }
    else
    {
        MuteLenSlider.FillImage = none;
        MuteLenSlider.DisableMe();
        MuteLenLabel.DisableMe();
    }
}

function OnMuteLenBoxChange(GUIComponent Sender)
{
    UpdateMuteLenEnabled();
    OnChangeClient(Sender);
}

function string FmtSeconds(float f)
{
    local int whole, tenths;

    whole = int(f);
    tenths = int((f - float(whole)) * 10.0000000);
    return (string(whole) $ ".") $ string(tenths);
}

function OnChangeClient(GUIComponent Sender)
{
    ResetFocus();
    btnSave.Caption = (((Chr(27) $ Chr(254)) $ Chr(16)) $ Chr(16)) $ "Save";
    bSaveClient = true;
}

function SaveClientStuff(bool bBind)
{
    local string sTemp;

    MyZound = bZoundCnt.IsChecked();
    MyVolume = int(GUISlider(Controls[35]).Value);
    Class'WSZoundClient'.default.ZoundEnabled = MyZound;
    if(bBind)
    {
        // Explicit pick: stop auto-moving the key off the player's own binds.
        Class'WSZoundClient'.default.ZoundMenuKey = MyKeyBind;
        Class'WSZoundClient'.default.bMenuKeyUserSet = true;
    }
    Class'WSZoundClient'.default.ZoundVolume = MyVolume;
    Class'WSZoundClient'.default.bMuteLongZounds = MuteLenBox.IsChecked();
    Class'WSZoundClient'.default.MaxZoundSeconds = MuteLenSlider.Value;
    Class'WSZoundClient'.static.StaticSaveConfig();
    sTemp = "";
    if(bZoundCnt.IsChecked())
    {
        sTemp = sTemp $ "1,";        
    }
    else
    {
        sTemp = sTemp $ "0,";
    }
    sTemp = (sTemp $ string(MyVolume)) $ ",";
    PlayerOwner().Player.Console.DelayedConsoleCommand((("MUTATE " $ sCode) $ "ZoundClientSubmit-") $ sTemp);
}

function LoadClientStuff()
{
    local string sTemp;
    local int i, j;

    MyZound = Class'WSZoundClient'.default.ZoundEnabled;
    bZoundCnt.Checked(MyZound);
    MyKeyBind = Class'WSZoundClient'.default.ZoundMenuKey;
    MyVolume = Class'WSZoundClient'.default.ZoundVolume;
    GUISlider(Controls[35]).SetValue(float(MyVolume));
    MuteLenBox.Checked(Class'WSZoundClient'.default.bMuteLongZounds);
    MuteLenSlider.SetValue(Class'WSZoundClient'.default.MaxZoundSeconds);
    MuteLenLabel.Caption = ("Max Length: " $ FmtSeconds(MuteLenSlider.Value)) $ "s";
    UpdateMuteLenEnabled();
    sTemp = "Key: " $ KeyBind[MyKeyBind];
    j = KeyBindList.List.ItemCount;
    KeyBindList.List.SetIndex(0);
    for(i = 0; i < j; i++)
    {
        if(KeyBindList.List.GetItemAtIndex(i) == sTemp)
        {
            sTemp = "";
            KeyBindList.List.SetIndex(i);
            break;
        }
        KeyBindList.List.MyScrollBar.MoveGripBy(1);
    }
    ChatLine.SetText("");
}

function SetPlayerList()
{
    local string sTemp;
    local int i;

    PlayerList.List.Clear();
    PlayerList.List.Add(MyPlayer);
    if(MyPlayer != "None")
    {
        PlayerList.List.Add("None");
    }
    for(i = 0; i < 32; i++)
    {
        sTemp = ZRI.Players[i];
        if(sTemp == "")
        {
            break;
        }
        if(((sTemp != MyPlayer) && sTemp != PlayerOwner().PlayerReplicationInfo.PlayerName) && sTemp != "None")
        {
            PlayerList.List.Add(sTemp);
        }
    }
    PlayerList.List.SetIndex(0);
}

function bool OnClickBindList(GUIComponent Sender)
{
    bSaveBind = true;
    return true;
}

function bool OnClickMutePlayer(GUIComponent Sender)
{
    if(PlayerList.List.ItemCount > 1)
    {
        bSavePlayer = true;
    }
    return true;
}

function SetKeyBindList()
{
    local int i;

    for(i = 0; i < 125; i++)
    {
        KeyBind[i] = "";
    }
    KeyBind[0] = "None";
    KeyBind[32] = "SpaceBar";
    KeyBind[33] = "PageUp";
    KeyBind[34] = "PageDn";
    KeyBind[35] = "End";
    KeyBind[36] = "Home";
    KeyBind[37] = "Left";
    KeyBind[38] = "Up";
    KeyBind[39] = "Right";
    KeyBind[40] = "Down";
    KeyBind[44] = "PrintScn";
    KeyBind[45] = "Insert";
    KeyBind[46] = "Delete";
    KeyBind[65] = "A";
    KeyBind[66] = "B";
    KeyBind[67] = "C";
    KeyBind[68] = "D";
    KeyBind[69] = "E";
    KeyBind[70] = "F";
    KeyBind[71] = "G";
    KeyBind[72] = "H";
    KeyBind[73] = "I";
    KeyBind[74] = "J";
    KeyBind[75] = "K";
    KeyBind[76] = "L";
    KeyBind[77] = "M";
    KeyBind[78] = "N";
    KeyBind[79] = "O";
    KeyBind[80] = "P";
    KeyBind[81] = "Q";
    KeyBind[82] = "R";
    KeyBind[83] = "S";
    KeyBind[84] = "T";
    KeyBind[85] = "U";
    KeyBind[86] = "V";
    KeyBind[87] = "W";
    KeyBind[88] = "X";
    KeyBind[89] = "Y";
    KeyBind[90] = "Z";
    KeyBind[96] = "NumPad0";
    KeyBind[97] = "NumPad1";
    KeyBind[98] = "NumPad2";
    KeyBind[99] = "NumPad3";
    KeyBind[100] = "NumPad4";
    KeyBind[101] = "NumPad5";
    KeyBind[102] = "NumPad6";
    KeyBind[103] = "NumPad7";
    KeyBind[104] = "NumPad8";
    KeyBind[105] = "NumPad9";
    KeyBind[106] = "GreyStar";
    KeyBind[107] = "GreyPlus";
    KeyBind[109] = "GreyMinus";
    KeyBind[111] = "GreySlash";
    KeyBind[112] = "F1";
    KeyBind[113] = "F2";
    KeyBind[114] = "F3";
    KeyBind[115] = "F4";
    KeyBind[116] = "F5";
    KeyBind[117] = "F6";
    KeyBind[118] = "F7";
    KeyBind[119] = "F8";
    KeyBind[120] = "F9";
    KeyBind[121] = "F10";
    KeyBind[122] = "F11";
    KeyBind[123] = "F12";
    KeyBindList.List.Clear();
    for(i = 0; i < 125; i++)
    {
        if(KeyBind[i] != "")
        {
            KeyBindList.List.Add("Key: " $ KeyBind[i]);
        }
    }
}

function int FindKeyBind(string sBind)
{
    local int i;

    for(i = 0; i < 125; i++)
    {
        if(KeyBind[i] == sBind)
        {
            return i;
        }
    }
    return 0;
}

function bool OnClickAbout(GUIComponent Sender)
{
    Controller.OpenMenu("WSZound.WSZoundMenuAbout");
    return true;
}

function bool OnClickClose(GUIComponent Sender)
{
    Controller.CloseMenu(false);
    return true;
}

function InternalOnCreateComponent(GUIComponent NewComp, GUIComponent Sender)
{
}

function OnClose(optional bool bCanceled)
{
    Controller.PurgeObjectReferences();
    Controller.VerifyStack();
}

defaultproperties
{
    clRed=(R=255,G=10,B=10,A=255)
    bAllowedAsLast=true
    // Reference: GUIImage'WSZoundMenuTrigs.BackDialog'
    begin object name="BackDialog" class=XInterface.GUIImage
        Image=Texture'InterfaceContent.Menu.SquareBoxA'
        ImageColor=(R=180,G=180,B=180,A=255)
        ImageStyle=ISTY_Stretched
        ImageRenderStyle=MSTY_Normal
        WinHeight=1.0000000
        bBoundToParent=true
        bScaleToParent=true
        bNeverFocus=true
    end object
    Controls[0]=BackDialog
    // Reference: GUIImage'WSZoundMenuTrigs.MyPageHeader'
    begin object name="MyPageHeader" class=XInterface.GUIImage
        Image=Texture'InterfaceContent.Menu.BorderBoxD'
        ImageColor=(R=200,G=200,B=200,A=255)
        ImageStyle=ISTY_Stretched
        ImageRenderStyle=MSTY_Normal
        WinTop=0.1400000
        WinLeft=0.1400000
        WinWidth=0.5110000
        WinHeight=0.0500000
        bNeverFocus=true
    end object
    Controls[1]=MyPageHeader
    // Reference: GUILabel'WSZoundMenuTrigs.MyHeaderLabel'
    begin object name="MyHeaderLabel" class=XInterface.GUILabel
        Caption="Zound Triggers"
        TextColor=(R=0,G=255,B=255,A=255)
        TextFont="UT2SmallHeaderFont"
        WinTop=0.1380000
        WinLeft=0.1600000
        WinWidth=0.3000000
        WinHeight=0.0500000
    end object
    Controls[2]=MyHeaderLabel
    // Reference: GUILabel'WSZoundMenuTrigs.LabelNum'
    begin object name="LabelNum" class=XInterface.GUILabel
        TextColor=(R=250,G=250,B=250,A=255)
        TextFont="UT2SmallFont"
        WinTop=0.1490000
        WinLeft=0.4100000
        WinWidth=0.2500000
        WinHeight=0.0350000
    end object
    Controls[3]=LabelNum
    // Reference: GUILabel'WSZoundMenuTrigs.LabelTrigs'
    begin object name="LabelTrigs" class=XInterface.GUILabel
        Caption="All Triggers    "
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="UT2SmallFont"
        Hint="DoubleClick to Play"
        WinTop=0.1900000
        WinLeft=0.1450000
        WinWidth=0.1650000
        WinHeight=0.0350000
    end object
    Controls[4]=LabelTrigs
    // Reference: GUILabel'WSZoundMenuTrigs.LabelFavor'
    begin object name="LabelFavor" class=XInterface.GUILabel
        Caption="Muted Triggers   "
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="UT2SmallFont"
        WinTop=0.1900000
        WinLeft=0.4900000
        WinWidth=0.1650000
        WinHeight=0.0350000
    end object
    Controls[5]=LabelFavor
    // Reference: GUILabel'WSZoundMenuTrigs.LabelMuted'
    begin object name="LabelMuted" class=XInterface.GUILabel
        Caption="Favourite Triggers "
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="UT2SmallFont"
        Hint="DoubleClick to Play"
        WinTop=0.1900000
        WinLeft=0.3150000
        WinWidth=0.1600000
        WinHeight=0.0350000
    end object
    Controls[6]=LabelMuted
    // Reference: GUIListBox'WSZoundMenuTrigs.ListAllTrigs'
    begin object name="ListAllTrigs" class=wsGUIListBox
        bVisibleWhenEmpty=true
        OnCreateComponent=ListAllTrigs.InternalOnCreateComponent
        WinTop=0.2250000
        WinLeft=0.1400000
        WinWidth=0.1655000
        WinHeight=0.2100000
        OnClick=WSZoundMenuTrigs.OnClickAllList
    end object
    Controls[7]=ListAllTrigs
    begin object name="FilterEdit" class=wsEditBox
        CaptionWidth=0.4500000
        Caption="Filter:"
        LabelFont="UT2SmallFont"
        LabelColor=(R=180,G=180,B=180,A=255)
        OnCreateComponent=FilterEdit.InternalOnCreateComponent
        FontScale=FNS_Small
        WinTop=0.4500000
        WinLeft=0.1400000
        WinWidth=0.1655000
        WinHeight=0.0400000
    end object
    Controls[36]=FilterEdit
    // Reference: GUIScrollTextBox'WSZoundMenuTrigs.CodedNames'
    begin object name="CodedNames" class=wsGUIScrollTextBox
        bNoTeletype=true
        bVisibleWhenEmpty=true
        OnCreateComponent=CodedNames.InternalOnCreateComponent
        FontScale=FNS_Small
        WinTop=0.2250000
        WinLeft=0.4840000
        WinWidth=0.1655000
        WinHeight=0.2600000
    end object
    Controls[8]=CodedNames
    // Reference: GUIListBox'WSZoundMenuTrigs.ListMuted'
    begin object name="ListMuted" class=wsGUIListBox
        bVisibleWhenEmpty=true
        OnCreateComponent=ListMuted.InternalOnCreateComponent
        WinTop=0.2250000
        WinLeft=0.4840000
        WinWidth=0.1655000
        WinHeight=0.2200000
        OnClick=WSZoundMenuTrigs.OnClickMutedList
    end object
    Controls[9]=ListMuted
    // Reference: GUIListBox'WSZoundMenuTrigs.ListFavor'
    begin object name="ListFavor" class=wsGUIListBox
        bVisibleWhenEmpty=true
        OnCreateComponent=ListFavor.InternalOnCreateComponent
        WinTop=0.2250000
        WinLeft=0.3120000
        WinWidth=0.1655000
        WinHeight=0.2200000
        OnClick=WSZoundMenuTrigs.OnClickFavorList
    end object
    Controls[10]=ListFavor
    // Reference: GUIButton'WSZoundMenuTrigs.AddMuteButton'
    begin object name="AddMuteButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Add"
        FontScale=FNS_Small
        Hint="Add word from All Triggers to Muted list"
        WinTop=0.4500000
        WinLeft=0.4840000
        WinWidth=0.0800000
        OnClick=WSZoundMenuTrigs.OnClickAddMute
        OnKeyEvent=AddMuteButton.InternalOnKeyEvent
    end object
    Controls[11]=AddMuteButton
    // Reference: GUIButton'WSZoundMenuTrigs.SubMuteButton'
    begin object name="SubMuteButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Del"
        FontScale=FNS_Small
        Hint="Delete word from Muted list"
        WinTop=0.4500000
        WinLeft=0.5690000
        WinWidth=0.0800000
        OnClick=WSZoundMenuTrigs.OnClickSubMute
        OnKeyEvent=SubMuteButton.InternalOnKeyEvent
    end object
    Controls[12]=SubMuteButton
    // Reference: GUIButton'WSZoundMenuTrigs.AddFButton'
    begin object name="AddFButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Add"
        FontScale=FNS_Small
        Hint="Add word from All Triggers to Favourite list"
        WinTop=0.4500000
        WinLeft=0.3120000
        WinWidth=0.0800000
        OnClick=WSZoundMenuTrigs.OnClickAddFav
        OnKeyEvent=AddFButton.InternalOnKeyEvent
    end object
    Controls[13]=AddFButton
    // Reference: GUIButton'WSZoundMenuTrigs.SubFavButton'
    begin object name="SubFavButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Del"
        FontScale=FNS_Small
        Hint="Delete word from Favorite list"
        WinTop=0.4500000
        WinLeft=0.3970000
        WinWidth=0.0800000
        OnClick=WSZoundMenuTrigs.OnClickSubFav
        OnKeyEvent=SubFavButton.InternalOnKeyEvent
    end object
    Controls[14]=SubFavButton
    // Reference: GUILabel'WSZoundMenuTrigs.LabelNorm'
    begin object name="LabelNorm" class=XInterface.GUILabel
        Caption="Normal"
        TextColor=(R=220,G=220,B=220,A=255)
        TextFont="UT2IRCFont"
        WinTop=0.6500000
        WinLeft=0.1430000
        WinWidth=0.0800000
        WinHeight=0.0300000
        bVisible=false
    end object
    Controls[15]=LabelNorm
    // Reference: GUILabel'WSZoundMenuTrigs.LabelDed'
    begin object name="LabelDed" class=XInterface.GUILabel
        Caption="Dedicated*"
        TextColor=(R=16,G=128,B=255,A=255)
        TextFont="UT2IRCFont"
        WinTop=0.6500000
        WinLeft=0.2100000
        WinWidth=0.0800000
        WinHeight=0.0320000
        bVisible=false
    end object
    Controls[16]=LabelDed
    // Reference: GUILabel'WSZoundMenuTrigs.LabelRnd'
    begin object name="LabelRnd" class=XInterface.GUILabel
        Caption="Random"
        TextColor=(R=16,G=200,B=16,A=255)
        TextFont="UT2IRCFont"
        WinTop=0.6500000
        WinLeft=0.3050000
        WinWidth=0.8000000
        WinHeight=0.0320000
        bVisible=false
    end object
    Controls[17]=LabelRnd
    // Reference: GUILabel'WSZoundMenuTrigs.LabelHid'
    begin object name="LabelHid" class=XInterface.GUILabel
        Caption="HideInMenu"
        TextColor=(R=250,G=250,B=16,A=255)
        TextFont="UT2IRCFont"
        WinTop=0.6500000
        WinLeft=0.3800000
        WinWidth=0.1000000
        WinHeight=0.0320000
        bVisible=false
    end object
    Controls[18]=LabelHid
    // Reference: GUILabel'WSZoundMenuTrigs.LabelLeft'
    begin object name="LabelLeft" class=XInterface.GUILabel
        Caption="Unlimited Zounds"
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="UT2IRCFont"
        WinTop=0.6500000
        WinLeft=0.4850000
        WinWidth=0.1650000
        WinHeight=0.0320000
    end object
    Controls[19]=LabelLeft
    // Reference: moEditBox'WSZoundMenuTrigs.Chat'
    begin object name="Chat" class=wsEditBox
        CaptionWidth=0.1500000
        Caption="Chat:"
        LabelFont="UT2SmallFont"
        LabelColor=(R=180,G=180,B=180,A=255)
        OnCreateComponent=Chat.InternalOnCreateComponent
        FontScale=FNS_Small
        WinTop=0.6780000
        WinLeft=0.1420000
        WinWidth=0.5070000
        WinHeight=0.0500000
    end object
    Controls[20]=Chat
    // Reference: GUIButton'WSZoundMenuTrigs.AdminButton'
    begin object name="AdminButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Admin"
        FontScale=FNS_Small
        Hint="Admin Configurations"
        WinTop=0.7155000
        WinLeft=0.1400000
        WinWidth=0.1200000
        OnClick=WSZoundMenuTrigs.OnClickAdmin
        OnKeyEvent=AdminButton.InternalOnKeyEvent
    end object
    Controls[21]=AdminButton
    // Reference: GUIButton'WSZoundMenuTrigs.AboutButton'
    begin object name="AboutButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="About"
        FontScale=FNS_Small
        WinTop=0.7155000
        WinLeft=0.1400000
        WinWidth=0.1200000
        OnClick=WSZoundMenuTrigs.OnClickAbout
        OnKeyEvent=AboutButton.InternalOnKeyEvent
    end object
    Controls[22]=AboutButton
    // Reference: GUIButton'WSZoundMenuTrigs.TestButton'
    begin object name="TestButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Test"
        FontScale=FNS_Small
        WinTop=0.7155000
        WinLeft=0.2700000
        WinWidth=0.1200000
        OnClick=WSZoundMenuTrigs.OnClickTest
        OnKeyEvent=TestButton.InternalOnKeyEvent
    end object
    Controls[23]=TestButton
    // Reference: GUIButton'WSZoundMenuTrigs.DumpButton'
    begin object name="DumpButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Dump"
        FontScale=FNS_Small
        Hint="Dumps all triggers to WSZoundNames.ini"
        WinTop=0.7155000
        WinLeft=0.4000000
        WinWidth=0.1200000
        OnClick=WSZoundMenuTrigs.OnClickDump
        OnKeyEvent=DumpButton.InternalOnKeyEvent
    end object
    Controls[24]=DumpButton
    // Reference: GUIButton'WSZoundMenuTrigs.SaveButton'
    begin object name="SaveButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Save"
        FontScale=FNS_Small
        Hint="Rightclick to cancel save"
        WinTop=0.7155000
        WinLeft=0.5300000
        WinWidth=0.1200000
        OnClick=WSZoundMenuTrigs.OnClickSave
        OnRightClick=WSZoundMenuTrigs.OnRightClickSave
        OnKeyEvent=SaveButton.InternalOnKeyEvent
    end object
    Controls[25]=SaveButton
    // Reference: GUIButton'WSZoundMenuTrigs.CloseButton'
    begin object name="CloseButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Close"
        FontScale=FNS_Small
        WinTop=0.7155000
        WinLeft=0.6580000
        WinWidth=0.1670000
        OnClick=WSZoundMenuTrigs.OnClickClose
        OnKeyEvent=CloseButton.InternalOnKeyEvent
    end object
    Controls[26]=CloseButton
    // Reference: GUIImage'WSZoundMenuTrigs.ClientHeader'
    begin object name="ClientHeader" class=XInterface.GUIImage
        Image=Texture'InterfaceContent.Menu.BorderBoxD'
        ImageColor=(R=200,G=200,B=200,A=255)
        ImageStyle=ISTY_Stretched
        ImageRenderStyle=MSTY_Normal
        WinTop=0.1400000
        WinLeft=0.6580000
        WinWidth=0.1650000
        WinHeight=0.0500000
        bNeverFocus=true
    end object
    Controls[27]=ClientHeader
    // Reference: GUILabel'WSZoundMenuTrigs.ClientLabel'
    begin object name="ClientLabel" class=XInterface.GUILabel
        Caption="Options"
        TextAlign=TXTA_Center
        TextColor=(R=0,G=255,B=255,A=255)
        TextFont="UT2SmallHeaderFont"
        WinTop=0.1380000
        WinLeft=0.6600000
        WinWidth=0.1600000
        WinHeight=0.0500000
    end object
    Controls[28]=ClientLabel
    // Reference: GUILabel'WSZoundMenuTrigs.LabelOptions'
    begin object name="LabelOptions" class=XInterface.GUILabel
        Caption="Muted Player  "
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="UT2SmallFont"
        WinTop=0.1900000
        WinLeft=0.6600000
        WinWidth=0.1600000
        WinHeight=0.0350000
    end object
    Controls[29]=LabelOptions
    // Reference: GUIListBox'WSZoundMenuTrigs.ListPlayers'
    begin object name="ListPlayers" class=wsGUIListBox
        bVisibleWhenEmpty=true
        OnCreateComponent=ListPlayers.InternalOnCreateComponent
        Hint="Mute a Player"
        WinTop=0.2250000
        WinLeft=0.6580000
        WinWidth=0.1650000
        WinHeight=0.1000000
        OnClick=WSZoundMenuTrigs.OnClickMutePlayer
    end object
    Controls[30]=ListPlayers
    // Reference: GUILabel'WSZoundMenuTrigs.BindLabel'
    begin object name="BindLabel" class=XInterface.GUILabel
        Caption="Keybind  "
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="UT2IRCFont"
        FontScale=FNS_Small
        WinTop=0.3200000
        WinLeft=0.6600000
        WinWidth=0.1600000
        WinHeight=0.0300000
    end object
    Controls[31]=BindLabel
    // Reference: GUIListBox'WSZoundMenuTrigs.ListBind'
    begin object name="ListBind" class=wsGUIListBox
        bVisibleWhenEmpty=true
        OnCreateComponent=ListBind.InternalOnCreateComponent
        Hint="Select a Key to Bind"
        WinTop=0.3472222
        WinLeft=0.6580000
        WinWidth=0.1650000
        WinHeight=0.0975000
        OnClick=WSZoundMenuTrigs.OnClickBindList
    end object
    Controls[32]=ListBind
    // Reference: moCheckBox'WSZoundMenuTrigs.ZEnable'
    begin object name="ZEnable" class=wsCheckBox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9000000
        Caption="Enable Zound"
        ComponentClassName="WSZound.wsGUICheckBoxButton"
        OnCreateComponent=ZEnable.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Enable/Disable Zound"
        WinTop=0.4560000
        WinLeft=0.6600000
        WinWidth=0.1570000
        WinHeight=0.0280000
        bStandardized=false
        OnChange=WSZoundMenuTrigs.OnChangeClient
    end object
    Controls[33]=ZEnable
    // Reference: GUILabel'WSZoundMenuTrigs.LabelVol'
    begin object name="LabelVol" class=XInterface.GUILabel
        Caption="Client Volume"
        TextAlign=TXTA_Center
        TextColor=(R=0,G=255,B=255,A=255)
        TextFont="UT2IRCFont"
        FontScale=FNS_Small
        WinTop=0.6560000
        WinLeft=0.6580000
        WinWidth=0.1650000
        WinHeight=0.0300000
    end object
    Controls[34]=LabelVol
    // Reference: GUISlider'WSZoundMenuTrigs.VolSlider'
    begin object name="VolSlider" class=wsGUISlider
        bIntSlider=true
        WinTop=0.6840000
        WinLeft=0.6600000
        WinWidth=0.1630000
        OnClick=VolSlider.InternalOnClick
        OnMousePressed=VolSlider.InternalOnMousePressed
        OnMouseRelease=VolSlider.InternalOnMouseRelease
        OnChange=WSZoundMenuTrigs.OnChangeClient
        OnKeyEvent=VolSlider.InternalOnKeyEvent
        OnCapturedMouseMove=VolSlider.InternalCapturedMouseMove
    end object
    Controls[35]=VolSlider
    begin object name="MuteLenChk" class=wsCheckBox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9000000
        Caption="Mute Long Zounds"
        ComponentClassName="WSZound.wsGUICheckBoxButton"
        OnCreateComponent=MuteLenChk.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Mute zounds longer than the length below"
        WinTop=0.4900000
        WinLeft=0.6600000
        WinWidth=0.1570000
        WinHeight=0.0280000
        bStandardized=false
        OnChange=WSZoundMenuTrigs.OnMuteLenBoxChange
    end object
    Controls[37]=MuteLenChk
    begin object name="MuteLenLbl" class=XInterface.GUILabel
        Caption="Max Length: 10.0s"
        TextColor=(R=0,G=255,B=255,A=255)
        FontScale=FNS_Small
        WinTop=0.5250000
        WinLeft=0.6600000
        WinWidth=0.1630000
        WinHeight=0.0300000
    end object
    Controls[38]=MuteLenLbl
    begin object name="MuteLenSld" class=wsGUISlider
        MinValue=0.0000000
        MaxValue=30.0000000
        bIntSlider=false
        WinTop=0.5600000
        WinLeft=0.6600000
        WinWidth=0.1630000
        OnClick=MuteLenSld.InternalOnClick
        OnMousePressed=MuteLenSld.InternalOnMousePressed
        OnMouseRelease=MuteLenSld.InternalOnMouseRelease
        OnChange=WSZoundMenuTrigs.OnMuteLenChange
        OnKeyEvent=MuteLenSld.InternalOnKeyEvent
        OnCapturedMouseMove=MuteLenSld.InternalCapturedMouseMove
        OnSliding=WSZoundMenuTrigs.OnMuteLenChange
    end object
    Controls[39]=MuteLenSld
    WinTop=0.1225000
    WinLeft=0.1285000
    WinWidth=0.7050000
    WinHeight=0.6480000
}