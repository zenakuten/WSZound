class WSZoundNames extends PopupPageBase
    config(WSZoundNames)
    editinlinenew
    instanced;

struct ZTrigs
{
    var string ServerID;
    var string Triggers;
};

var() config array<ZTrigs> ZoundDump;

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
}

function HandleParameters(string Param1, string Param2)
{
    local bool bFound;
    local int i, j;

    if(Param1 == "")
    {
        return;
    }
    j = default.ZoundDump.Length;
    for(i = 0; i < j; i++)
    {
        if(default.ZoundDump[i].ServerID == Param1)
        {
            bFound = true;
            default.ZoundDump[i].Triggers = Param2;
            break;
        }
    }
    if(!bFound)
    {
        default.ZoundDump.Length = j + 1;
        default.ZoundDump[j].ServerID = Param1;
        default.ZoundDump[j].Triggers = Param2;
    }
    self.StaticSaveConfig();
    Controller.CloseMenu(false);
}
