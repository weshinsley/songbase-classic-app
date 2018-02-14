unit SearchThread;

interface

uses
  Classes, SBFiles, ComCtrls;

type
  TTSearchThread = class(TThread)
  private
    { Private declarations }
    RecordNum     : integer;
    ProgressSize  : integer;
    ProgressValue : integer;
    CurrentRecord : SongRecord;
    CurrentPage   : integer;
    CurrentIndex  : integer;
    TextLine      : string;
    aSelectStart  : array[0..2] of integer;
    aSelectEnd    : array[0..2] of integer;

    procedure UpdateRecord;
    procedure SetProgress;
    procedure FindWithinRTF( index : integer; sSearchUP, sID : string; var psText : string; var piPage, piSelectStart, piSelectEnd : integer );

  public
    RemoteSearch    : boolean;
    FileName        : string;
    QuickSearchFile : string;
    OHPFile         : string;
    TempDir         : string;
    SearchStr       : string;
    PRichEditCtrl   : ^TRichEdit;
    iMusicKeyIdx    : integer;
    iMusicScaleIdx  : integer;
    iMusicCapoIdx   : integer;
    iMusicTempoIdx  : integer;
    bSearchRTF      : boolean;
    bAdvanced       : boolean;
    procedure reallyExecute;

  protected
    procedure Execute; override;
  end;

implementation

uses SearchResults, SysUtils, EditProj, SBZipUtils, StrUtils, RichEdit,
     Messages, Types, Dialogs, PageCache, WebServer,SBMain;

{ TTSearchThread }

procedure TTSearchThread.Execute;
begin
  reallyExecute();
end;

procedure TTSearchThread.reallyExecute;
var
  i, j, iRecord : integer;
  SR            : SongRecord;
  SearchUC, SearchCP : string;
  bFound, bEmptySearch, bInText, bCheckMusical, bInRecord : boolean;
begin
  // Get the search terms
  iRecord         := 0;

  // Get an upper case version of the search-string
  SearchUC     := UpperCase(SearchStr);
  SearchCP     := CapNoPunc(SearchStr);
  bEmptySearch := (SearchStr = '');

  // Are we going to search musical things?
  bCheckMusical := (iMusicKeyIdx   >=1) and (iMusicScaleIdx >=1) and
                   (iMusicCapoIdx  >=1) and (iMusicTempoIdx >=1);

  // Open the files
{  if not OpenForRead(TF,FileName) then Exit;
  if not OpenForRead(QSF,QuickSearchFile) then begin CloseTextfile(TF,FileName); Exit; end;
  if eof(QSF) then begin
    CloseTextfile(QSF,QuickSearchFile);
    CloseTextfile(TF,FileName);
    Exit;
  end;}

  // Work out how much work you need to do...
  ProgressSize  := PageCache_GetSongCount;
  ProgressValue := 0;
  if (not RemoteSearch) then Synchronize(SetProgress);

  // Search...
//  while not eof(TF) do begin
  for j := 0 to PageCache_GetSongCount do begin
    CurrentIndex:=j;
    inc( iRecord );

    // First search in the Title/SubTitle/Author/etc...
    bFound     := false;
    bInText    := false;
    bInRecord  := false;
    TextLine   := '';

    if not PageCache_GetSongFromIndex( j, SR ) then continue;

    if bEmptySearch then bFound := true
    else begin
      // Does it appear in the song record?
      if ( 0<> pos(SearchUC,UpperCase(SR.Title)    )) or
         ( 0<> pos(SearchUC,UpperCase(SR.AltTitle) )) or
         ( 0<> pos(SearchUC,UpperCase(SR.Author)   )) then bInRecord := true;
      if bAdvanced then begin
        // If the Advanced panel is open, include copyright details, etc...
        if ( 0<> pos(SearchUC,UpperCase(SR.CopDate)  )) or
           ( 0<> pos(SearchUC,UpperCase(SR.CopyRight))) or
           ( 0<> pos(SearchUC,UpperCase(SR.OfficeNo) )) or
           ( 0<> pos(SearchUC,UpperCase(SR.Notes)    )) or
           ( 0<> pos(SearchUC,UpperCase(SR.MusBook)  )) or
           ( 0<> pos(SearchUC,UpperCase(SR.Tune)     )) or
           ( 0<> pos(SearchUC,UpperCase(SR.Arr)      )) or
           ( 0<> pos(SearchUC,UpperCase(SR.CL1)      )) or
           ( 0<> pos(SearchUC,UpperCase(SR.CL2)      )) then bInRecord := true;
      end;
    end;
    if bInRecord then bFound := true;

    if bSearchRTF then begin
      // Search the actual text - IMPROVE: Can we search inline? is the fast-text search in order?
      bInText := PageCache_TextContains( SR.ID, SearchCP, true );
     if bInText then bFound := true;
    end;

    // Then filter results based on other search criteria
    if bCheckMusical and bFound then begin
      if (iMusicKeyIdx   >=1) and (iMusicKeyIdx   -1 <> SR.Key)   then bFound:=false;
      if (iMusicScaleIdx >=1) and (iMusicScaleIdx -1 <> SR.MM)    then bFound:=false;
      if (iMusicCapoIdx  >=1) and (iMusicCapoIdx  -1 <> SR.Capo)  then bFound:=false;
      if (iMusicTempoIdx >=1) and (iMusicTempoIdx -1 <> SR.Tempo) then bFound:=false;
    end;

    // Found!
    if bFound then begin
      RecordNum     := iRecord;
      CurrentRecord := SR;
      CurrentPage   := 0;

      // Search through each record item and highlight according to matching
      i := pos(SearchUC,UpperCase(SR.Title));
      if( i > 0 ) then begin
        aSelectStart[0] := i;
        aSelectEnd[0]   := i + length(SearchUC);
      end else begin
        aSelectStart[0] := 0;
        aSelectEnd[0]   := 0;
      end;

      i := pos(SearchUC,UpperCase(SR.Author));
      if( i > 0 ) then begin
        aSelectStart[1] := i;
        aSelectEnd[1]   := i + length(SearchUC);
      end else begin
        aSelectStart[1] := 0;
        aSelectEnd[1]   := 0;
      end;

      if bInText { and FSettings.HighlightTextInSearchWindow } then begin
        // Open the RTF and highlight the text...
        FindWithinRTF( j, SearchUC, SR.ID, TextLine, CurrentPage, aSelectStart[2], aSelectEnd[2] );
      end else begin
        aSelectStart[2] := 0;
        aSelectEnd[2]   := 0;
      end;
      Synchronize(UpdateRecord);
    end;

    // Keep the progress bar up to date - every 10 items
    if( iRecord - ProgressValue > 10 ) then begin
      ProgressValue := j;
      if (not RemoteSearch) then Synchronize(SetProgress);
    end;
  end;

  // Final update to progress bar
  ProgressValue := ProgressSize;
  if (not RemoteSearch) then begin
    Synchronize(SetProgress);
    Synchronize(FSearchResults.SearchComplete);
  end;
end;

procedure TTSearchThread.FindWithinRTF( index : integer; sSearchUP, sID : string; var psText : string; var piPage, piSelectStart, piSelectEnd : integer );
var
  S                   : string;
  iPage, iPages, iPos, iLine : integer;
  iLineCount                 : integer;
  bLoop                      : boolean;
  rRect                      : TRect;
begin
  // Scan the directory
  iLine      := 0;
  iLineCount := 0;
  iPage      := 1;
  iPages     := PageCache_GetPageCount( sID );
  bLoop      := true;

  while bLoop do begin
    PageCache_LoadRTF( PRichEditCtrl^, sID, iPage );

    rRect.Left   := 0;
    rRect.Top    := 0;
    rRect.Right  := 1280 * 1440 div 72;
    rRect.Bottom := 1024 * 1440 div 72;
    PRichEditCtrl^.Perform( EM_SETRECT, 0, Cardinal(@rRect) );

    // Trim any blank lines on the end
    iLineCount := PRichEditCtrl^.Lines.Count-1;
    while (iLineCount > 0) and (PRichEditCtrl^.Lines[iLineCount] = '') do
      dec( iLineCount );

    for iLine := 0 to iLineCount do begin
      S := PRichEditCtrl^.Lines[iLine];
      if S <> '' then begin
        iPos := pos(sSearchUP,UpperCase(S));
        if iPos > 0 then begin
          piSelectStart := iPos;
          piSelectEnd   := iPos + length(sSearchUP);
          psText        := S;
          piPage        := iPage;
          bLoop         := false;
          Break;
        end;
      end;
    end;
    inc(iPage);
    if iPage > iPages then bLoop := false;
  end;

  if (psText <> '') and (iLine > 0) and not bLoop then begin
    psText := '... ' + psText;
    if piSelectStart>0 then begin
      piSelectStart := piSelectStart + 4;
      piSelectEnd   := piSelectEnd   + 4;
    end;
  end;
  if (psText <> '') and not bLoop and (iLine < iLineCount) then begin
    psText := psText + ' ...';
  end;
end;

procedure TTSearchThread.SetProgress;
begin
  if FSearchResults.ProgressBar1.Max <> ProgressSize then
     FSearchResults.ProgressBar1.Max := ProgressSize;
  FSearchResults.ProgressBar1.Position := ProgressValue;
end;

procedure TTSearchThread.UpdateRecord;
begin
  if (not RemoteSearch) then begin
    FSearchResults.AddRecord( RecordNum, CurrentPage, CurrentRecord, TextLine, aSelectStart, aSelectEnd );
  end else begin
    inc(FWebServer.NoSearchResults);
    FWebServer.SearchResults:=FWebServer.SearchResults+IntToStr(CurrentIndex)+tab+CurrentRecord.Id+tab+CurrentREcord.Title+tab+TextLine+tab+CurrentRecord.AltTitle+tab+CurrentRecord.Author+newline;
  end;
end;

end.
