class wsGUIListBox extends GUIListBox;

defaultproperties
{
    DefaultListClass="WSZound.wsGUIList"
    StyleName="WSButton"
    SelectedStyleName="WSListBox"
    SectionStyleName="ListSection"
    
    Begin Object Class=wsGUIVertScrollBar Name=TheScrollbar
         bVisible=False
         OnPreDraw=TheScrollbar.GripPreDraw
    End Object
    MyScrollBar=wsGUIVertScrollBar'wsGUIListBox.TheScrollbar'    
    
}