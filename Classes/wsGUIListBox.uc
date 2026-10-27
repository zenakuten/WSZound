class wsGUIListBox extends GUIListBox;

// The list class is set here, not in defaultproperties, so it follows the package name.
function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    DefaultListClass = string(class'wsGUIList');
    Super.InitComponent(MyController, MyOwner);
}

defaultproperties
{
    StyleName="WSButton"
    SelectedStyleName="WSListBox"
    SectionStyleName="ListSection"
    
    Begin Object Class=wsGUIVertScrollBar Name=TheScrollbar
         bVisible=False
         OnPreDraw=TheScrollbar.GripPreDraw
    End Object
    MyScrollBar=wsGUIVertScrollBar'wsGUIListBox.TheScrollbar'    
    
}