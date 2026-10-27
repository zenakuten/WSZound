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
// Words parsed once from the config by BuildFilter (Caps'd, trimmed, empties dropped),
// each with the censor text of the entry it came from, in config order.
var array<string> FilterWord;
var array<string> FilterCensor;
// One-entry memo: ChatHandler filters the same line once per receiver.
var string MemoIn, MemoOut;
var bool bMemoValid;

function PreBeginPlay()
{
    if(default.filter.Length == 0)
    {
        default.filter.Length = 1;
        default.filter[0].CensorWord = "****";
        default.filter[0].BadWords = "badword1,badword2,badword3,badword10,";
        self.StaticSaveConfig();
    }
    BuildFilter();
    super(Actor).PreBeginPlay();
}

// Splits each BadWords list on commas (a trailing comma is optional), trims the spaces
// around each word and drops empty ones, which used to hang the server.
function BuildFilter()
{
    local array<string> Parts;
    local string W;
    local int i, j, n;

    FilterWord.Length = 0;
    FilterCensor.Length = 0;
    bMemoValid = false;
    for(i = 0; i < default.filter.Length; i++)
    {
        Split(default.filter[i].BadWords, ",", Parts);
        for(j = 0; j < Parts.Length; j++)
        {
            W = Parts[j];
            while(Left(W, 1) == " ")
            {
                W = Mid(W, 1);
            }
            while(Right(W, 1) == " ")
            {
                W = Left(W, Len(W) - 1);
            }
            // Chr(1) is FilterString's placeholder; a word containing it would match forever.
            if((W == "") || InStr(W, Chr(1)) != -1)
            {
                continue;
            }
            n = FilterWord.Length;
            FilterWord[n] = Caps(W);
            FilterCensor[n] = default.filter[i].CensorWord;
        }
    }
}

function string FilterString(Controller Sender, coerce string Msg)
{
    local string In, CM;
    local int i, k, L;

    if(bMemoValid && MemoIn == Msg)
    {
        return MemoOut;
    }
    In = Msg;
    CM = Caps(Msg);
    for(i = 0; i < FilterWord.Length; i++)
    {
        k = InStr(CM, FilterWord[i]);
        if(k == -1)
        {
            continue;
        }
        // Mark every hit with Chr(1) first so the censor text can't be matched by this
        // word. CM stays in step with Msg because Caps maps each character to one.
        L = Len(FilterWord[i]);
        while(k != -1)
        {
            Msg = (Left(Msg, k) $ Chr(1)) $ Mid(Msg, k + L);
            CM = (Left(CM, k) $ Chr(1)) $ Mid(CM, k + L);
            k = InStr(CM, FilterWord[i]);
        }
        Msg = Repl(Msg, Chr(1), FilterCensor[i], true);
        CM = Caps(Msg);
    }
    bMemoValid = true;
    MemoIn = In;
    MemoOut = Msg;
    return Msg;
}
