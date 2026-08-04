// ====================================================================
//  wsGUIList
//  GUIList that forces a whole-pixel row height. The native list measures
//  row height from the font as a float; rounding it keeps rows aligned to
//  whole pixels for crisp text/selection rendering.
// ====================================================================

class wsGUIList extends GUIList;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController, MyOwner);
    GetItemHeight = IntegerItemHeight;
}

function float IntegerItemHeight(Canvas C)
{
    local float XL, YL;

    C.TextSize("WQ,2", XL, YL);
    return float(int(YL + 0.5));
}
