class wsEditBox extends moEditBox;

// The component class is set here, not in defaultproperties, so it follows the package name.
function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    ComponentClassName = string(class'wsGUIEditBox');
    Super.InitComponent(MyController, MyOwner);
}

defaultproperties
{
    LabelStyleName="WSLabel"
}