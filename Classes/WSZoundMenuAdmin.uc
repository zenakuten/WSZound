class WSZoundMenuAdmin extends PopupPageBase
    config(User)
    editinlinenew
    instanced;

var bool bAdmin;
var string sCode;
var export editinline GUILabel lblBind;
var export editinline moCheckBox bZoundSvr;
var export editinline moCheckBox bShowTrigger;
var export editinline moCheckBox bShowToSelf;
var export editinline moCheckBox bAnnounce;
var export editinline moCheckBox Announce1;
var export editinline moCheckBox bBotsTalk;
var export editinline moCheckBox bSpecPlay;
var export editinline moCheckBox b24HourTime;
var export editinline moCheckBox bInGameZound;
var export editinline moCheckBox bChatLog;
var export editinline moCheckBox bChatFilter;
var export editinline moCheckBox bPlayerList;
var export editinline moNumericEdit SoundDelay;
var export editinline moNumericEdit LoginDelay;
var export editinline moNumericEdit DelaysEach;
var export editinline moNumericEdit SoundsEach;
var export editinline moNumericEdit RepeatDelay;
var export editinline GUIListBox PlayerList;

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
    bZoundSvr = moCheckBox(Controls[3]);
    bShowTrigger = moCheckBox(Controls[4]);
    bShowToSelf = moCheckBox(Controls[5]);
    bAnnounce = moCheckBox(Controls[6]);
    Announce1 = moCheckBox(Controls[7]);
    bBotsTalk = moCheckBox(Controls[8]);
    bSpecPlay = moCheckBox(Controls[9]);
    b24HourTime = moCheckBox(Controls[10]);
    bInGameZound = moCheckBox(Controls[11]);
    bChatLog = moCheckBox(Controls[12]);
    bChatFilter = moCheckBox(Controls[13]);
    bPlayerList = moCheckBox(Controls[14]);
    SoundDelay = moNumericEdit(Controls[15]);
    LoginDelay = moNumericEdit(Controls[16]);
    DelaysEach = moNumericEdit(Controls[17]);
    SoundsEach = moNumericEdit(Controls[18]);
    RepeatDelay = moNumericEdit(Controls[19]);
    PlayerList = GUIListBox(Controls[20]);
    Controls[1].SetFocus(none);
    bShowTrigger.Hint = ("Everyone sees the Triggers." $ Chr(10)) $ "Only effects dedicated triggers.";
    bShowToSelf.Hint = ("Always show in own chat." $ Chr(10)) $ "Only effects dedicated triggers.";
    bBotsTalk.Hint = ("Allows Bots to use Zound" $ Chr(10)) $ "Mainly effects ServerBots2";
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
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    bZoundSvr.Checked(bool(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    bShowTrigger.Checked(bool(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    bShowToSelf.Checked(bool(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    bAnnounce.Checked(bool(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    Announce1.Checked(bool(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    bBotsTalk.Checked(bool(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    bSpecPlay.Checked(bool(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    b24HourTime.Checked(bool(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    bInGameZound.Checked(bool(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    bChatLog.Checked(bool(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    bChatFilter.Checked(bool(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    bPlayerList.Checked(bool(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    SoundDelay.SetValue(int(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    LoginDelay.SetValue(int(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    DelaysEach.SetValue(int(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    SoundsEach.SetValue(int(sTemp));
    Param1 = Mid(Param1, i + 1);
    i = InStr(Param1, ",");
    sTemp = Left(Param1, i);
    RepeatDelay.SetValue(int(sTemp));
    Param1 = Mid(Param1, i + 1);
    PlayerList.List.Clear();
    for(j = 0; j < 30; j++)
    {
        i = InStr(Param2, ",");
        sTemp = Left(Param2, i);
        if(sTemp == "")
        {
            break;
        }
        Param2 = Mid(Param2, i + 1);
        PlayerList.List.Add(" " $ sTemp);
    }
    PlayerList.List.SetIndex(0);
    PlayerList.List.TextAlign = TXTA_Left;
}

function string GetSettings()
{
    local string sTemp;

    sTemp = "";
    if(bZoundSvr.IsChecked())
    {
        sTemp = sTemp $ "1,";        
    }
    else
    {
        sTemp = sTemp $ "0,";
    }
    if(bShowTrigger.IsChecked())
    {
        sTemp = sTemp $ "1,";        
    }
    else
    {
        sTemp = sTemp $ "0,";
    }
    if(bShowToSelf.IsChecked())
    {
        sTemp = sTemp $ "1,";        
    }
    else
    {
        sTemp = sTemp $ "0,";
    }
    if(bAnnounce.IsChecked())
    {
        sTemp = sTemp $ "1,";        
    }
    else
    {
        sTemp = sTemp $ "0,";
    }
    if(Announce1.IsChecked())
    {
        sTemp = sTemp $ "1,";        
    }
    else
    {
        sTemp = sTemp $ "0,";
    }
    if(bBotsTalk.IsChecked())
    {
        sTemp = sTemp $ "1,";        
    }
    else
    {
        sTemp = sTemp $ "0,";
    }
    if(bSpecPlay.IsChecked())
    {
        sTemp = sTemp $ "1,";        
    }
    else
    {
        sTemp = sTemp $ "0,";
    }
    if(b24HourTime.IsChecked())
    {
        sTemp = sTemp $ "1,";        
    }
    else
    {
        sTemp = sTemp $ "0,";
    }
    if(bInGameZound.IsChecked())
    {
        sTemp = sTemp $ "1,";        
    }
    else
    {
        sTemp = sTemp $ "0,";
    }
    if(bChatLog.IsChecked())
    {
        sTemp = sTemp $ "1,";        
    }
    else
    {
        sTemp = sTemp $ "0,";
    }
    if(bChatFilter.IsChecked())
    {
        sTemp = sTemp $ "1,";        
    }
    else
    {
        sTemp = sTemp $ "0,";
    }
    if(bPlayerList.IsChecked())
    {
        sTemp = sTemp $ "1,";        
    }
    else
    {
        sTemp = sTemp $ "0,";
    }
    sTemp = (((((((sTemp $ string(SoundDelay.GetValue())) $ ",") $ string(LoginDelay.GetValue())) $ ",") $ string(DelaysEach.GetValue())) $ ",") $ string(SoundsEach.GetValue())) $ ",";
    sTemp = (sTemp $ string(RepeatDelay.GetValue())) $ ",";
    return sTemp;
}

function bool OnClickBan(GUIComponent Sender)
{
    local string sTemp;

    sTemp = PlayerList.List.Get();
    if(sTemp == "")
    {
        return false;
    }
    sTemp = Mid(sTemp, 1);
    sTemp = (sCode $ "ZoundBanPlayerList-") $ sTemp;
    PlayerOwner().Player.Console.DelayedConsoleCommand("MUTATE " $ sTemp);
    return true;
}

function bool OnClickList(GUIComponent Sender)
{
    local string sTemp;

    sTemp = PlayerList.List.Get();
    if(sTemp == "")
    {
        return false;
    }
    sTemp = Mid(sTemp, 1);
    sTemp = (sCode $ "ZoundAddPlayerList-") $ sTemp;
    PlayerOwner().Player.Console.DelayedConsoleCommand("MUTATE " $ sTemp);
    return true;
}

function bool OnClickSubmit(GUIComponent Sender)
{
    local string sTemp;

    sTemp = GetSettings();
    PlayerOwner().Player.Console.DelayedConsoleCommand((("MUTATE " $ sCode) $ "ZoundAdminSubmit-") $ sTemp);
    Controller.CloseAll(false);
    return true;
}

function bool OnClickLogout(GUIComponent Sender)
{
    PlayerOwner().Player.Console.DelayedConsoleCommand("MUTATE ZoundLogout");
    Controller.CloseMenu(false);
    return true;
}

function bool OnClickTotal(GUIComponent Sender)
{
    PlayerOwner().Player.Console.DelayedConsoleCommand(("MUTATE " $ sCode) $ "DisplayTotals");
    Controller.CloseMenu(false);
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
    // Reference: GUIImage'WSZoundMenuAdmin.DialogBackground'
    begin object name="DialogBackground" class=XInterface.GUIImage
        Image=Texture'InterfaceContent.Menu.SquareBoxA'
        ImageColor=(R=180,G=180,B=180,A=200)
        ImageStyle=ISTY_Stretched
        ImageRenderStyle=MSTY_Normal
        WinHeight=1.0000000
        bBoundToParent=true
        bScaleToParent=true
        bNeverFocus=true
    end object
    Controls[0]=DialogBackground
    // Reference: GUIButton'WSZoundMenuAdmin.NoneButton'
    begin object name="NoneButton" class=XInterface.GUIButton
        StyleName="WSButton"
        WinTop=0.1300000
        WinLeft=0.7200000
        WinWidth=0.0000010
        WinHeight=0.0000010
        OnKeyEvent=NoneButton.InternalOnKeyEvent
    end object
    Controls[1]=NoneButton
    // Reference: GUILabel'WSZoundMenuAdmin.MyPageHeader'
    begin object name="MyPageHeader" class=XInterface.GUILabel
        Caption="Zound Configs"
        TextAlign=TXTA_Center
        TextColor=(R=0,G=255,B=255,A=255)
        TextFont="UT2SmallHeaderFont"
        WinTop=0.1200000
        WinLeft=0.6800000
        WinWidth=0.2000000
        WinHeight=0.0500000
    end object
    Controls[2]=MyPageHeader
    // Reference: moCheckBox'WSZoundMenuAdmin.Set0'
    begin object name="Set0" class=wsCheckBox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9000000
        Caption="Enable Zound on Server"
        ComponentClassName="WSZound.wsGUICheckBoxButton"
        OnCreateComponent=Set0.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Enables / Disables Server Zound."
        WinTop=0.1650000
        WinLeft=0.6300000
        WinWidth=0.3150000
        WinHeight=0.0200000
        bStandardized=false
    end object
    Controls[3]=Set0
    // Reference: moCheckBox'WSZoundMenuAdmin.Set1'
    begin object name="Set1" class=wsCheckBox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9000000
        Caption="Show Triggers to all Players"
        ComponentClassName="WSZound.wsGUICheckBoxButton"
        OnCreateComponent=Set1.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Everyone sees the Triggers."
        WinTop=0.1900000
        WinLeft=0.6300000
        WinWidth=0.3150000
        WinHeight=0.0200000
        bStandardized=false
    end object
    Controls[4]=Set1
    // Reference: moCheckBox'WSZoundMenuAdmin.Set2'
    begin object name="Set2" class=wsCheckBox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9000000
        Caption="Show Triggers to self always"
        ComponentClassName="WSZound.wsGUICheckBoxButton"
        OnCreateComponent=Set2.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Always show triggers in own chat."
        WinTop=0.2150000
        WinLeft=0.6300000
        WinWidth=0.3150000
        WinHeight=0.0200000
        bStandardized=false
    end object
    Controls[5]=Set2
    // Reference: moCheckBox'WSZoundMenuAdmin.Set3'
    begin object name="Set3" class=wsCheckBox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9000000
        Caption="Enable Player Announcement"
        ComponentClassName="WSZound.wsGUICheckBoxButton"
        OnCreateComponent=Set3.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Enables PlayerEnter / PlayerExit triggers."
        WinTop=0.2400000
        WinLeft=0.6300000
        WinWidth=0.3150000
        WinHeight=0.0200000
        bStandardized=false
    end object
    Controls[6]=Set3
    // Reference: moCheckBox'WSZoundMenuAdmin.Set4'
    begin object name="Set4" class=wsCheckBox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9000000
        Caption="Enable Announcement Once"
        ComponentClassName="WSZound.wsGUICheckBoxButton"
        OnCreateComponent=Set4.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Only announces at logon, not every level."
        WinTop=0.2650000
        WinLeft=0.6300000
        WinWidth=0.3150000
        WinHeight=0.0200000
        bStandardized=false
    end object
    Controls[7]=Set4
    // Reference: moCheckBox'WSZoundMenuAdmin.Set5'
    begin object name="Set5" class=wsCheckBox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9000000
        Caption="Enable Bots to use Zound"
        ComponentClassName="WSZound.wsGUICheckBoxButton"
        OnCreateComponent=Set5.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Allows Bots to call on Zound."
        WinTop=0.2900000
        WinLeft=0.6300000
        WinWidth=0.3150000
        WinHeight=0.0200000
        bStandardized=false
    end object
    Controls[8]=Set5
    // Reference: moCheckBox'WSZoundMenuAdmin.Set6'
    begin object name="Set6" class=wsCheckBox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9000000
        Caption="Disable Spectator to Player"
        ComponentClassName="WSZound.wsGUICheckBoxButton"
        OnCreateComponent=Set6.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Spectators / Players cant hear each other."
        WinTop=0.3150000
        WinLeft=0.6300000
        WinWidth=0.3150000
        WinHeight=0.0200000
        bStandardized=false
    end object
    Controls[9]=Set6
    // Reference: moCheckBox'WSZoundMenuAdmin.Set7'
    begin object name="Set7" class=wsCheckBox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9000000
        Caption="Use 24 hour Time"
        ComponentClassName="WSZound.wsGUICheckBoxButton"
        OnCreateComponent=Set7.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Uses 24 hour time in 'Time?'."
        WinTop=0.3400000
        WinLeft=0.6300000
        WinWidth=0.3150000
        WinHeight=0.0200000
        bStandardized=false
    end object
    Controls[10]=Set7
    // Reference: moCheckBox'WSZoundMenuAdmin.Set8'
    begin object name="Set8" class=wsCheckBox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9000000
        Caption="Use Zound In Game"
        ComponentClassName="WSZound.wsGUICheckBoxButton"
        OnCreateComponent=Set8.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Alows Zound during the game."
        WinTop=0.3650000
        WinLeft=0.6300000
        WinWidth=0.3150000
        WinHeight=0.0200000
        bStandardized=false
    end object
    Controls[11]=Set8
    // Reference: moCheckBox'WSZoundMenuAdmin.Set9'
    begin object name="Set9" class=wsCheckBox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9000000
        Caption="Use Zound Chat Logging"
        ComponentClassName="WSZound.wsGUICheckBoxButton"
        OnCreateComponent=Set9.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Enables a daily Zound Chatlog."
        WinTop=0.3900000
        WinLeft=0.6300000
        WinWidth=0.3150000
        WinHeight=0.0200000
        bStandardized=false
    end object
    Controls[12]=Set9
    // Reference: moCheckBox'WSZoundMenuAdmin.Set10'
    begin object name="Set10" class=wsCheckBox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9000000
        Caption="Use Zound Chat Filtering"
        ComponentClassName="WSZound.wsGUICheckBoxButton"
        OnCreateComponent=Set10.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Enables filtering of swear words."
        WinTop=0.4150000
        WinLeft=0.6300000
        WinWidth=0.3150000
        WinHeight=0.0200000
        bStandardized=false
    end object
    Controls[13]=Set10
    // Reference: moCheckBox'WSZoundMenuAdmin.Set11'
    begin object name="Set11" class=wsCheckBox
        ComponentJustification=TXTA_Left
        CaptionWidth=0.9000000
        Caption="Use Defined Player List"
        ComponentClassName="WSZound.wsGUICheckBoxButton"
        OnCreateComponent=Set11.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Only Players in a list can use Zound."
        WinTop=0.4400000
        WinLeft=0.6300000
        WinWidth=0.3150000
        WinHeight=0.0200000
        bStandardized=false
    end object
    Controls[14]=Set11
    // Reference: moNumericEdit'WSZoundMenuAdmin.Adj1'
    begin object name="Adj1" class=wsNumericEdit
        MaxValue=60
        CaptionWidth=0.7050000
        Caption="Sound Delay Time"
        LabelFont="UT2SmallFont"
        LabelColor=(R=255,G=255,B=255,A=255)
        OnCreateComponent=Adj1.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Delay time before sound"
        WinTop=0.4650000
        WinLeft=0.6300000
        WinWidth=0.3000000
        bStandardized=false
    end object
    Controls[15]=Adj1
    // Reference: moNumericEdit'WSZoundMenuAdmin.Adj2'
    begin object name="Adj2" class=wsNumericEdit
        MaxValue=60
        CaptionWidth=0.7050000
        Caption="Player Login Delay"
        LabelFont="UT2SmallFont"
        LabelColor=(R=255,G=255,B=255,A=255)
        OnCreateComponent=Adj2.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Delay before hearing sound"
        WinTop=0.5000000
        WinLeft=0.6300000
        WinWidth=0.3000000
        bStandardized=false
    end object
    Controls[16]=Adj2
    // Reference: moNumericEdit'WSZoundMenuAdmin.Adj3'
    begin object name="Adj3" class=wsNumericEdit
        MaxValue=10
        CaptionWidth=0.7050000
        Caption="Delay Multiplyer"
        LabelFont="UT2SmallFont"
        LabelColor=(R=255,G=255,B=255,A=255)
        OnCreateComponent=Adj3.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="10 times delay manifesting"
        WinTop=0.5350000
        WinLeft=0.6300000
        WinWidth=0.3000000
        bStandardized=false
    end object
    Controls[17]=Adj3
    // Reference: moNumericEdit'WSZoundMenuAdmin.Adj4'
    begin object name="Adj4" class=wsNumericEdit
        MaxValue=99
        CaptionWidth=0.7050000
        Caption="Maximum Sounds"
        LabelFont="UT2SmallFont"
        LabelColor=(R=255,G=255,B=255,A=255)
        OnCreateComponent=Adj4.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="The maximum sounds a player can have"
        WinTop=0.5700000
        WinLeft=0.6300000
        WinWidth=0.3000000
        bStandardized=false
    end object
    Controls[18]=Adj4
    // Reference: moNumericEdit'WSZoundMenuAdmin.Repeat'
    begin object name="Repeat" class=wsNumericEdit
        MinValue=0
        MaxValue=240
        CaptionWidth=0.7050000
        Caption="Sound Repeat Delay"
        LabelFont="UT2SmallFont"
        LabelColor=(R=255,G=255,B=255,A=255)
        OnCreateComponent=Repeat.InternalOnCreateComponent
        FontScale=FNS_Small
        Hint="Delay before trigger can repeat"
        WinTop=0.6050000
        WinLeft=0.6300000
        WinWidth=0.3000000
        bStandardized=false
    end object
    Controls[19]=Repeat
    // Reference: GUIListBox'WSZoundMenuAdmin.Playlist'
    begin object name="Playlist" class=wsGUIListBox
        bVisibleWhenEmpty=true
        OnCreateComponent=Playlist.InternalOnCreateComponent
        Hint="Banning or Listing ->"
        WinTop=0.6398148
        WinLeft=0.6300000
        WinWidth=0.2050000
        WinHeight=0.1530000
    end object
    Controls[20]=Playlist
    // Reference: GUIButton'WSZoundMenuAdmin.BanButton'
    begin object name="BanButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Banning"
        FontScale=FNS_Small
        Hint="Ban / Unban player from Zound"
        WinTop=0.6380000
        WinLeft=0.8400000
        WinWidth=0.0900000
        OnClick=WSZoundMenuAdmin.OnClickBan
        OnKeyEvent=BanButton.InternalOnKeyEvent
    end object
    Controls[21]=BanButton
    // Reference: GUIButton'WSZoundMenuAdmin.ListButton'
    begin object name="ListButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Listing"
        FontScale=FNS_Small
        Hint="Add / Remove player from List"
        WinTop=0.6780000
        WinLeft=0.8400000
        WinWidth=0.0900000
        OnClick=WSZoundMenuAdmin.OnClickList
        OnKeyEvent=ListButton.InternalOnKeyEvent
    end object
    Controls[22]=ListButton
    // Reference: GUIButton'WSZoundMenuAdmin.TotalButton'
    begin object name="TotalButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Totals"
        FontScale=FNS_Small
        Hint="List total level triggers"
        WinTop=0.7180000
        WinLeft=0.8400000
        WinWidth=0.0900000
        OnClick=WSZoundMenuAdmin.OnClickTotal
        OnKeyEvent=TotalButton.InternalOnKeyEvent
    end object
    Controls[23]=TotalButton
    // Reference: GUIButton'WSZoundMenuAdmin.LogoutButton'
    begin object name="LogoutButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Logout"
        FontScale=FNS_Small
        Hint="Close and Logout as Admin"
        WinTop=0.7580000
        WinLeft=0.8400000
        WinWidth=0.0900000
        OnClick=WSZoundMenuAdmin.OnClickLogout
        OnKeyEvent=LogoutButton.InternalOnKeyEvent
    end object
    Controls[24]=LogoutButton
    // Reference: GUIButton'WSZoundMenuAdmin.SubmitButton'
    begin object name="SubmitButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Submit"
        FontScale=FNS_Small
        WinTop=0.7990000
        WinLeft=0.6300000
        WinWidth=0.0900000
        OnClick=WSZoundMenuAdmin.OnClickSubmit
        OnKeyEvent=JoinButton.InternalOnKeyEvent
    end object
    Controls[25]=SubmitButton
    // Reference: GUIButton'WSZoundMenuAdmin.CloseButton'
    begin object name="CloseButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Close"
        FontScale=FNS_Small
        WinTop=0.7990000
        WinLeft=0.8400000
        WinWidth=0.0900000
        OnClick=WSZoundMenuAdmin.OnClickClose
        OnKeyEvent=CloseButton.InternalOnKeyEvent
    end object
    Controls[26]=CloseButton
    WinTop=0.1200000
    WinLeft=0.6100000
    WinWidth=0.3400000
    WinHeight=0.7320000
}