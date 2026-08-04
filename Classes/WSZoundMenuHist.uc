class WSZoundMenuHist extends PopupPageBase
    config(User)
    editinlinenew
    instanced;

var string sCode;
var string Plays[50];
var string Trigs[50];
var export editinline GUIListBox Playlist;
var export editinline GUIListBox TrigList;

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
    Playlist = GUIListBox(Controls[3]);
    TrigList = GUIListBox(Controls[4]);
    Controls[2].SetFocus(none);
}

function HandleParameters(string Param1, string Param2)
{
    local string sTemp;
    local int i, j;

    PlayerOwner().Player.Console.TypingClose();
    PlayerOwner().Player.Console.ConsoleClose();
    i = InStr(Param1, ",");
    sCode = Left(Param1, i);
    Param1 = Mid(Param1, i + 1);
    Playlist.List.Clear();
    TrigList.List.Clear();
    for(i = 0; i < 50; i++)
    {
        j = InStr(Param1, ",");
        if(j > 0)
        {
            sTemp = Left(Param1, j);
            Param1 = Mid(Param1, j + 1);
            if(sTemp == "")
            {
                break;
            }
            Playlist.List.Add(sTemp);
            Plays[i] = sTemp;
            continue;
        }
        break;
    }
    for(i = 0; i < 50; i++)
    {
        j = InStr(Param2, "~");
        if(j > -1)
        {
            sTemp = Left(Param2, j);
            Param2 = Mid(Param2, j + 1);
            if(sTemp == "")
            {
                break;
            }
            Trigs[i] = sTemp;
        }
    }
    Playlist.List.SetIndex(0);
    Playlist.List.TextAlign = TXTA_Left;
    TrigList.List.TextAlign = TXTA_Left;
    GetPlayerTrigs();
}

function GetPlayerTrigs()
{
    local string sTemp;
    local int i, j;

    i = Playlist.List.Index;
    if(i > -1)
    {
        sTemp = Trigs[i];
        TrigList.List.Clear();
        for(i = 0; i < 50; i++)
        {
            j = InStr(sTemp, ",");
            if(j > -1)
            {
                TrigList.List.Add(Left(sTemp, j));
                sTemp = Mid(sTemp, j + 1);
                if((sTemp == "") || Left(sTemp, 1) == "~")
                {
                    break;
                }
            }
        }
    }
    TrigList.List.SetIndex(0);
    TrigList.List.TextAlign = TXTA_Left;
}

function bool OnClickList(GUIComponent Sender)
{
    GetPlayerTrigs();
    return true;
}

function bool OnClickLog(GUIComponent Sender)
{
    local string sTemp;
    local int i;

    for(i = 0; i < 50; i++)
    {
        if(Plays[i] != "")
        {
            sTemp = ((("Total Triggers for " $ Plays[i]) $ Chr(9)) $ " = ") $ Trigs[i];
            Log(sTemp, 'Zound');
        }
    }
    Controls[5].MenuState = MSAT_Disabled;
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
    bAllowedAsLast=true
    // Reference: GUIImage'WSZoundMenuHist.DialogBackground'
    begin object name="DialogBackground" class=XInterface.GUIImage
        Image=Texture'InterfaceContent.Menu.SquareBoxA'
        ImageColor=(R=180,G=180,B=180,A=250)
        ImageStyle=ISTY_Stretched
        ImageRenderStyle=MSTY_Normal
        WinHeight=1.0000000
        bBoundToParent=true
        bScaleToParent=true
        bNeverFocus=true
    end object
    Controls[0]=DialogBackground
    // Reference: GUILabel'WSZoundMenuHist.MyPageHeader'
    begin object name="MyPageHeader" class=XInterface.GUILabel
        Caption="Zound Trigger History"
        TextAlign=TXTA_Center
        TextColor=(R=0,G=255,B=255,A=255)
        TextFont="UT2SmallHeaderFont"
        WinTop=0.1200000
        WinLeft=0.2700000
        WinWidth=0.4400000
        WinHeight=0.0500000
    end object
    Controls[1]=MyPageHeader
    // Reference: GUIButton'WSZoundMenuHist.NoneButton'
    begin object name="NoneButton" class=XInterface.GUIButton
        StyleName="WSButton"
        WinTop=0.1250000
        WinLeft=0.3200000
        WinWidth=0.0000010
        WinHeight=0.0000010
        OnKeyEvent=NoneButton.InternalOnKeyEvent
    end object
    Controls[2]=NoneButton
    // Reference: GUIListBox'WSZoundMenuHist.PlayerList'
    begin object name="PlayerList" class=wsGUIListBox
        bVisibleWhenEmpty=true
        OnCreateComponent=PlayerList.InternalOnCreateComponent
        WinTop=0.1703704
        WinLeft=0.2800000
        WinWidth=0.2000000
        WinHeight=0.2800000
        OnClick=WSZoundMenuHist.OnClickList
    end object
    Controls[3]=PlayerList
    // Reference: GUIListBox'WSZoundMenuHist.TriggerList'
    begin object name="TriggerList" class=wsGUIListBox
        bVisibleWhenEmpty=true
        OnCreateComponent=TriggerList.InternalOnCreateComponent
        WinTop=0.1703704
        WinLeft=0.4900000
        WinWidth=0.2000000
        WinHeight=0.2800000
    end object
    Controls[4]=TriggerList
    // Reference: GUIButton'WSZoundMenuHist.LogButton'
    begin object name="LogButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Log"
        FontScale=FNS_Small
        Hint="Dump total triggers to local log"
        WinTop=0.4600000
        WinLeft=0.2800000
        WinWidth=0.1100000
        OnClick=WSZoundMenuHist.OnClickLog
        OnKeyEvent=LogButton.InternalOnKeyEvent
    end object
    Controls[5]=LogButton
    // Reference: GUIButton'WSZoundMenuHist.CloseButton'
    begin object name="CloseButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Close"
        FontScale=FNS_Small
        Hint="Close"
        WinTop=0.4600000
        WinLeft=0.5800000
        WinWidth=0.1100000
        OnClick=WSZoundMenuHist.OnClickClose
        OnKeyEvent=CloseButton.InternalOnKeyEvent
    end object
    Controls[6]=CloseButton
    WinTop=0.1200000
    WinLeft=0.2600000
    WinWidth=0.4500000
    WinHeight=0.3900000
}