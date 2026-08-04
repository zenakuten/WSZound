class WSZoundStyle extends STY2ListBox
    instanced;

event Initialize()
{
    local int i;

    for(i = 0; i < 5; i++)
    {
        Fonts[i] = Controller.GetMenuFont(FontNames[i]);
    }
}

defaultproperties
{
    KeyName="WSZoundStyle"
    FontColors[0]=(R=250,G=250,B=250,A=250)
    FontColors[1]=(R=250,G=250,B=250,A=250)
    FontColors[2]=(R=250,G=250,B=250,A=250)
    FontColors[3]=(R=250,G=250,B=250,A=250)
    FontColors[4]=(R=250,G=250,B=250,A=250)
    Images[0]=Texture'InterfaceContent.Menu.BorderBoxD'
    Images[1]=Texture'InterfaceContent.Menu.BorderBoxD'
    Images[2]=Texture'InterfaceContent.Menu.BorderBoxD'
    Images[3]=Texture'InterfaceContent.Menu.BorderBoxD'
    Images[4]=Texture'InterfaceContent.Menu.BorderBoxD'
}