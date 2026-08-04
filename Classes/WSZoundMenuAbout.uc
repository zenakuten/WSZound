class WSZoundMenuAbout extends PopupPageBase
    config(User)
    editinlinenew
    instanced;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
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
    Controls[3].SetFocus(none);
}

function bool OnClickClose(GUIComponent Sender)
{
    Controller.CloseMenu(false);
    return true;
}

function OnClose(optional bool bCanceled)
{
    Class'WSZoundMenuTrigs'.default.bReset = true;
}

defaultproperties
{
    bAllowedAsLast=true
    // Reference: GUIImage'WSZoundMenuAbout.DialogBackground'
    begin object name="DialogBackground" class=XInterface.GUIImage
        Image=Texture'InterfaceContent.Menu.SquareBoxA'
        ImageColor=(R=220,G=220,B=220,A=250)
        ImageStyle=ISTY_Stretched
        ImageRenderStyle=MSTY_Normal
        WinHeight=1.0000000
        bBoundToParent=true
        bScaleToParent=true
        bNeverFocus=true
    end object
    Controls[0]=DialogBackground
    // Reference: GUIImage'WSZoundMenuAbout.LogoImage'
    begin object name="LogoImage" class=XInterface.GUIImage
        Image=Texture'InterfaceContent.Backgrounds.bg09'
        ImageColor=(R=180,G=180,B=180,A=250)
        ImageStyle=ISTY_Scaled
        ImageRenderStyle=MSTY_Normal
        WinTop=0.2500000
        WinLeft=0.3550000
        WinWidth=0.2500000
        WinHeight=0.0600000
    end object
    Controls[1]=LogoImage
    // Reference: GUILabel'WSZoundMenuAbout.lblHeader'
    begin object name="lblHeader" class=XInterface.GUILabel
        Caption="< Zound >"
        TextAlign=TXTA_Center
        TextColor=(R=0,G=255,B=255,A=255)
        TextFont="UT2SmallHeaderFont"
        WinTop=0.2550000
        WinLeft=0.3600000
        WinWidth=0.2400000
        WinHeight=0.0500000
    end object
    Controls[2]=lblHeader
    // Reference: GUIButton'WSZoundMenuAbout.NoneButton'
    begin object name="NoneButton" class=XInterface.GUIButton
        StyleName="WSButton"
        WinTop=0.2600000
        WinLeft=0.3850000
        WinWidth=0.0000010
        WinHeight=0.0000010
        OnKeyEvent=NoneButton.InternalOnKeyEvent
    end object
    Controls[3]=NoneButton
    // Reference: GUILabel'WSZoundMenuAbout.lblVersion'
    begin object name="lblVersion" class=XInterface.GUILabel
        Caption="Version 5.5"
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="UT2SmallFont"
        FontScale=FNS_Small
        WinTop=0.3200000
        WinLeft=0.3350000
        WinWidth=0.2850000
        WinHeight=0.0300000
    end object
    Controls[4]=lblVersion
    // Reference: GUILabel'WSZoundMenuAbout.lblCopy'
    begin object name="lblCopy" class=XInterface.GUILabel
        Caption="(c) ProAsm 2007/9"
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="UT2SmallFont"
        FontScale=FNS_Small
        WinTop=0.3475000
        WinLeft=0.3350000
        WinWidth=0.2850000
        WinHeight=0.0300000
    end object
    Controls[5]=lblCopy
    // Reference: GUILabel'WSZoundMenuAbout.lblCredits'
    begin object name="lblCredits" class=XInterface.GUILabel
        Caption="Credits"
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="UT2SmallFont"
        FontScale=FNS_Small
        WinTop=0.3750000
        WinLeft=0.3250000
        WinWidth=0.3150000
        WinHeight=0.0300000
    end object
    Controls[6]=lblCredits
    // Reference: GUILabel'WSZoundMenuAbout.lblDesign'
    begin object name="lblDesign" class=XInterface.GUILabel
        Caption="FU - Frogger - AssRaker"
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="UT2SmallFont"
        FontScale=FNS_Small
        WinTop=0.4025000
        WinLeft=0.3250000
        WinWidth=0.3125000
        WinHeight=0.0300000
    end object
    Controls[7]=lblDesign
    // Reference: GUILabel'WSZoundMenuAbout.lblTeam'
    begin object name="lblTeam" class=XInterface.GUILabel
        Caption="The UT2Vote Team"
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="UT2SmallFont"
        FontScale=FNS_Small
        WinTop=0.4300000
        WinLeft=0.3250000
        WinWidth=0.3125000
        WinHeight=0.0300000
    end object
    Controls[8]=lblTeam
    // Reference: GUIButton'WSZoundMenuAbout.CloseButton'
    begin object name="CloseButton" class=XInterface.GUIButton
        StyleName="WSButton"
        Caption="Close"
        FontScale=FNS_Small
        WinTop=0.4625000
        WinLeft=0.4350000
        WinWidth=0.1000000
        OnClick=WSZoundMenuAbout.OnClickClose
        OnKeyEvent=CloseButton.InternalOnKeyEvent
    end object
    Controls[9]=CloseButton
    WinTop=0.2300000
    WinLeft=0.3400000
    WinWidth=0.2800000
    WinHeight=0.2850000
}