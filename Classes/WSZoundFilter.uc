class WSZoundFilter extends Info
    config(WSZound)
    hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force);

struct CensoredWords
{
    var string CensorWord;
    var string BadWords;
};

var MutWSZound myMut;
var() config array<CensoredWords> filter;

function PreBeginPlay()
{
    if(default.filter.Length == 0)
    {
        default.filter.Length = 1;
        default.filter[0].CensorWord = "****";
        default.filter[0].BadWords = "badword1,badword2,badword3,badword10,";
        self.StaticSaveConfig();
    }
    super(Actor).PreBeginPlay();
}

function string FilterString(Controller Sender, coerce string Msg)
{
    local string sWords, sTemp;
    local int i, j, k;

    if(default.filter.Length == 0)
    {
        return Msg;
    }
    for(i = 0; i < default.filter.Length; i++)
    {
        sWords = default.filter[i].BadWords;
        j = InStr(sWords, ",");
        if(j > -1)
        {
            while(j > -1)
            {
                sTemp = Left(sWords, j);
                k = InStr(Caps(Msg), Caps(sTemp));
                if(k > -1)
                {
                    while(k > -1)
                    {
                        Msg = (Left(Msg, k) $ Chr(1)) $ Mid(Msg, k + Len(sTemp));
                        k = InStr(Caps(Msg), Caps(sTemp));
                    }
                    Msg = Repl(Msg, Chr(1), default.filter[i].CensorWord);
                }
                sWords = Mid(sWords, j + 1);
                j = InStr(sWords, ",");
            }
        }
    }
    return Msg;
}
