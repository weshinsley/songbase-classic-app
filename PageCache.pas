unit PageCache;

interface
uses SBFiles, Classes, ComCtrls, Graphics;

type
  CachePage = record
     bLoaded        : boolean;
     sText          : string;
     sPicture       : string;
     hBGPicture     : TPicture;
     iShortcutKey   : Word;
     iModifier      : Word;
  end;
  PCachePage = ^CachePage;

  TPageCacheEntry = class(TObject)
    //private
      sSongname  : string;
      sSrcLine   : string;
      SR         : SongRecord;
      iPageCount : integer;
      aPages     : array of CachePage;
  end;

  TQuickSearchEntry = class(TObject)
    private
      sString    : string;
  end;

  procedure PageCache_Initialise;
  procedure PageCache_Finalise;
  procedure PageCache_AddSong( sID : string; SR : SongRecord; sSrcLine : string );
  function  PageCache_GetSongName( sID : string ) : string;
  function  PageCache_GetPageCount( sID : string ) : integer;
  function  PageCache_GetPagePicture( sID : string; iPage : integer ) : string;
  function  PageCache_GetPageText( sID : string; iPage : integer ) : string;
  function  PageCache_LoadRTF( hRichEdit : TRichEdit; sID : string; iPage : integer ) : boolean;
  function  PageCache_EnsureID( sID : string; var iIdx : integer ) : boolean;
  function  PageCache_GetEntry( sID : string ) : TPageCacheEntry;
  function  PageCache_GetEntryFromIndex( iIdx : integer ) : TPageCacheEntry;
  function  PageCache_GetByTitle( sTitle : string ) : string;
  function  PageCache_EntryGetRTF( hEntry : TPageCacheEntry; iPage : integer ) : string;
  procedure PageCache_EntryEnsureOHP( hEntry : TPageCacheEntry );
  procedure PageCache_ValidateOHPFile( OHPFile, TempDir : string );
  function PageCache_TextSearch( sSearchStr : string; var hResults : TStringList;
                                 iMax : integer; bCheckDupl, bClear : boolean ) : boolean;
  function  PageCache_EnsureSDB : boolean;
  function  PageCache_GetSong( sID : string; var SR : SongRecord ) : boolean;
  function  PageCache_GetSongFromIndex( iIndex : integer; var SR : SongRecord ) : boolean;
  function  PageCache_GetSongnameFromIndex( iIndex : integer; var S : string ) : boolean;
  function  PageCache_GetSrcLine( sID : string ) : string;
  procedure PageCache_SetOHPViewed( sID : string );
  function  PageCache_GetOHPString( hEntry : TPageCacheEntry ) : string;
  procedure PageCache_GetPageShortcut( sID : string; iPage : integer;
                                       var wMod : Word; var wKey : Word );
  procedure PageCache_FlushID( sID : string );
  procedure PageCache_FlushAll;
  procedure PageCache_FlushQuick;
  procedure PageCache_UpdateSR( SR : SongRecord );
  procedure PageCache_ForceReload( sID : string );
  function  PageCache_GetSongCount : integer;
  function  PageCache_GetNextFreeSongID( iPrevID : integer = 0 ) : integer;
  function  PageCache_TextContains( sID, sText : string; bAlreadyCP : boolean = false ) : boolean;
  function  PageCache_SearchTitles( sSearchStr : string ) : TStringList;
  procedure PageCache_SaveRTF( hRichEdit:TRichEdit; sID:string; iPage:integer );
  function  PageCache_CreateSearchList( hList : TStringList ) : boolean;
  function  PageCache_GetIDForSBTitle( sTitle : string ) : string;

  function  PageCache_GetRichText( hRichEdit:TRichEdit ) : string;
  procedure PageCache_SetRichText( hRichEdit : TRichEdit; sText : string );
  function  PageCache_FindImportSongState( sOHPImport : string; SR : SongRecord ) : integer;

const
  SONGSTATE_SAME  = 0;
  SONGSTATE_NEW   = 1;
  SONGSTATE_NEWER = 2;
  SONGSTATE_OLDER = 3;

implementation
uses
  Windows, About, IniFiles, SysUtils, StrUtils, SBZipUtils, InfoBox, SBMain,
  DateUtils;

var
  bLoadedSDB : boolean;
  hPageCache : THashedStringList;
  // Cache = THashedStringList[Song id]-> Printed songname
  //                                    ->Record
  //                                          ->array[pages RTF:string, or nil]
  //                                          ->SongRecord
  //                                          ->Page count : integer;

  MemStream  : TMemoryStream;   // For RTF loading
  hQuickSearch : TStringList;

procedure PageCache_Initialise;
begin
  hPageCache := THashedStringList.Create;
  MemStream  := TMemoryStream.Create;
  hQuickSearch := nil;
  bLoadedSDB := false;
end;

procedure PageCache_Finalise;
begin
  hPageCache.Destroy;
  hPageCache := nil;
  MemStream.Free;
  if nil <> hQuickSearch then begin
    hQuickSearch.Destroy;
    hQuickSearch := nil;
  end;
  bLoadedSDB := false;
end;


procedure PageCache_FlushAll;
begin
  hPageCache.Clear;
  bLoadedSDB := false;
  PageCache_FlushQuick;
end;

procedure PageCache_FlushQuick;
begin
  if hQuickSearch <> nil then begin
    hQuickSearch.Destroy;
    hQuickSearch := nil;
  end;
end;


procedure PageCache_FlushID( sID : string );
//var i : integer;
begin
// IMPROVE: Refresh information for a song without killing everything...
PageCache_FlushAll;
{  i := hPageCache.IndexOf(sID);
  if i <> -1 then begin
    hPageCache.Delete(i);
  end;}
end;

procedure PageCache_ForceReload( sID : string );
var
  hEntry : TPageCacheEntry;
begin
  hEntry := PageCache_GetEntry( sID );
  if hEntry <> nil then begin
    hEntry.iPageCount := -1;
    setlength( hEntry.aPages, 0 );
    PageCache_EntryEnsureOHP( hEntry );
  end;
end;

procedure PageCache_UpdateSR( SR : SongRecord );
var iIdx : integer;
    hEntry : TPageCacheEntry;
begin
  if PageCache_EnsureID( SR.Id, iIdx ) then begin
    hEntry := hPageCache.Objects[iIdx] as TPageCacheEntry;
    hEntry.SR := SR;
    Limit( hEntry.sSrcLine, hEntry.SR );

    // Update the song name if needed
    hEntry.sSongname := SR.Title;
    if( length(SR.AltTitle) > 2 ) then hEntry.sSongname := hEntry.sSongname + ' (' + SR.AltTitle +')';

    hPageCache.Objects[iIdx] := hEntry;
  end;
end;



procedure PageCache_AddSong( sID : string; SR : SongRecord; sSrcLine : string );
var
  hEntry : TPageCacheEntry;
  SName  : string;
begin
  // Create a new entry
  hEntry := TPageCacheEntry.Create;

  // Work out what to call it throughout the application
  SName := SR.Title;
  if( length(SR.AltTitle) > 2 ) then SName := SName + ' (' + SR.AltTitle +')';

  // Now populate the entry
  hEntry.sSongname  := SName;
  hEntry.sSrcLine   := sSrcLine;
  hEntry.iPageCount := -1;
  hEntry.SR         := SR;
  setlength(hEntry.aPages, 0);

  // And add it to the cache
  hPageCache.AddObject( sID, hEntry );
end;


function PageCache_GetSongName( sID : string ) : string;
var
  hEntry : TPageCacheEntry;
  i : integer;
begin
  Result := '';
  if PageCache_EnsureID( sID, i ) then begin
    if i <> -1 then begin
      hEntry := hPageCache.Objects[i] as TPageCacheEntry;
      Result := hEntry.sSongname;
    end
  end;
end;

function PageCache_GetSrcLine( sID : string ) : string;
var
  hEntry : TPageCacheEntry;
  i : integer;
begin
  Result := '';
  if PageCache_EnsureID( sID, i ) then begin
    if i <> -1 then begin
      hEntry := hPageCache.Objects[i] as TPageCacheEntry;
      Result := hEntry.sSrcLine;
    end
  end;
end;

function PageCache_GetEntryFromIndex( iIdx : integer ) : TPageCacheEntry;
begin
  PageCache_EnsureSDB;
  if iIdx >= hPageCache.Count then begin
    Result := nil;
    Exit;
  end;
  Result := (hPageCache.Objects[iIdx] as TPageCacheEntry);
end;

function PageCache_GetSongFromIndex( iIndex : integer; var SR : SongRecord ) : boolean;
var hEntry : TPageCacheEntry;
begin
  hEntry := PageCache_GetEntryFromIndex( iIndex );
  if nil <> hEntry then begin
    SR := hEntry.SR;
    Result := true;
  end else
    Result := false;
end;

function PageCache_GetSongnameFromIndex( iIndex : integer; var S : string ) : boolean;
begin
  PageCache_EnsureSDB;
  if iIndex >= hPageCache.Count then begin
    Result := false;
    Exit;
  end;
  S := (hPageCache.Objects[iIndex] as TPageCacheEntry).sSongname;
  Result := true;
end;

function  PageCache_GetSong( sID : string; var SR : SongRecord ) : boolean;
var iIdx : integer;
    hEntry : TPageCacheEntry;
begin
  if PageCache_EnsureID( sID, iIdx ) then begin
    hEntry := hPageCache.Objects[iIdx] as TPageCacheEntry;
    SR := hEntry.SR;
    Result := true;
  end else Result := false;
end;

procedure PageCache_SetOHPViewed( sID : string );
var iIdx : integer;
    hEntry : TPageCacheEntry;
begin
  if PageCache_EnsureID( sID, iIdx ) then begin
    hEntry := hPageCache.Objects[iIdx] as TPageCacheEntry;
    if hEntry.SR.OHP <> '1' then begin
      hEntry.SR.OHP := '1';
      Limit( hEntry.sSrcLine, hEntry.SR );
      hPageCache.Objects[iIdx] := hEntry;
    end;
  end;
end;

function PageCache_GetPageCount( sID : string ) : integer;
var
  hEntry : TPageCacheEntry;
begin
  hEntry := PageCache_GetEntry( sID );
  if hEntry <> nil then begin
    PageCache_EntryEnsureOHP( hEntry );
    Result := hEntry.iPageCount;
  end else
    Result := 0;
end;

function PageCache_GetPagePicture( sID : string; iPage : integer ) : string;
var
  hEntry : TPageCacheEntry;
begin
  Result := '';
  hEntry := PageCache_GetEntry( sID );
  if hEntry <> nil then begin
    PageCache_EntryEnsureOHP( hEntry );
    if iPage <= hEntry.iPageCount then begin
      Result := hEntry.aPages[iPage-1].sPicture;
    end;
  end;
end;

function PageCache_GetPageText( sID : string; iPage : integer ) : string;
var
  hEntry : TPageCacheEntry;
begin
  Result := '';
  hEntry := PageCache_GetEntry( sID );
  if hEntry <> nil then begin
    Result := PageCache_EntryGetRTF( hEntry, iPage );
  end;
end;

procedure PageCache_GetPageShortcut( sID : string; iPage : integer;
                                     var wMod : Word; var wKey : Word );
var hEntry : TPageCacheEntry;
begin
  hEntry := PageCache_GetEntry( sID );
  if hEntry <> nil then begin
    PageCache_EntryEnsureOHP( hEntry );
    if iPage <= hEntry.iPageCount then begin
      wMod := hEntry.aPages[iPage-1].iModifier;
      wKey := hEntry.aPages[iPage-1].iShortcutKey;
    end;
  end;
end;


function PageCache_LoadRTF( hRichEdit : TRichEdit; sID : string; iPage : integer ) : boolean;
var sRTFText : string;
begin
  Result   := false;

  // Get the file
  sRTFText := PageCache_GetPageText( sID, iPage );
  if sRTFText <> '' then
  begin
    // Write it into the memory stream
    MemStream.Clear;
    MemStream.WriteBuffer(Pointer(sRTFText)^, Length(sRTFText));
    MemStream.Position := 0;

    // Now load into the richedit control
    hRichEdit.PlainText := False;
    hRichEdit.Clear;
    hRichEdit.Lines.LoadFromStream(MemStream);
    Result := true;
  end;
end;


procedure PageCache_EnsureFastSearch;
var i : integer;
    TF : TextFile;
    S, sID : string;
    hEntry : TQuickSearchEntry;
begin
  // Firstly load in the quick search information.
  if nil = hQuickSearch then
  begin
    if OpenForRead( TF, QSFile ) then
    begin
      hQuickSearch := TStringList.Create;
      while not eof(TF) do
      begin
        readln(TF, S);
        i := pos( '~', S );
        if i > 0 then
        begin
          hEntry := TQuickSearchEntry.Create();
          sID := copy( S,1,i-1 );
          hEntry.sString := copy( S,i+1,length(S) );
          hQuickSearch.AddObject( sID, hEntry );
        end;
      end;
      CloseTextfile( TF,QSFile );
    end;
  end;
end;

function PageCache_TextSearch( sSearchStr : string; var hResults : TStringList;
                                iMax : integer; bCheckDupl, bClear : boolean ) : boolean;
var i, iFound : integer;
    SearchCP : string;
    hEntry : TQuickSearchEntry;
begin
  // Firstly load in the quick search information.
  PageCache_EnsureFastSearch;

  // Return an empty list if we've failed to load the QuickSearch index
  if bClear then hResults.Clear();
  Result   := true;
  if nil = hQuickSearch then Exit;

  // Now search...
  iFound   := 0;
  SearchCP := CapNoPunc(sSearchStr);
  for i := 0 to hQuickSearch.Count-1 do begin
    hEntry := hQuickSearch.Objects[i] as TQuickSearchEntry;
    if 0 <> pos(SearchCP, hEntry.sString) then begin
      if not bCheckDupl or
            ( (-1 = hResults.IndexOf( hQuickSearch.Strings[i] )) and
              (-1 = hResults.IndexOf( '~' + hQuickSearch.Strings[i] )) ) then
      begin
        inc(iFound);
        if iFound > iMax then begin
          Result := false;
          break;
        end;
        hResults.Add( hQuickSearch.Strings[i] );
      end;
    end;
  end;
end;


function PageCache_TextContains( sID, sText : string; bAlreadyCP : boolean = false ) : boolean;
var i : integer;
    SearchCP : string;
    hEntry : TQuickSearchEntry;
begin
  Result := false;

  // Firstly load in the quick search information.
  PageCache_EnsureFastSearch;
  if hQuickSearch <> nil then begin
    i := hQuickSearch.IndexOf( sID );
    if i <> -1 then begin
      if bAlreadyCP then SearchCP := sText
                    else SearchCP := CapNoPunc(sText);
      hEntry   := hQuickSearch.Objects[i] as TQuickSearchEntry;
      if 0 <> pos(SearchCP, hEntry.sString) then Result := true;
    end;
  end;
end;


function PageCache_EnsureSDB : boolean;
var TF : Textfile;
    SR : SongRecord;
    FS : string;
begin
  if false = bLoadedSDB then begin
    hPageCache.Clear;
    if OpenForRead(TF,FileName) then begin
      bLoadedSDB := true;
      while not eof(TF) do begin
        readln(TF,FS);
        Delimit(FS,SR);
        PageCache_AddSong( SR.Id, SR, FS );
      end;
      CloseTextfile(TF,FileName);
    end;
  end;
  Result := true;
end;

function PageCache_GetSongCount : integer;
begin
  PageCache_EnsureSDB;
  Result := hPageCache.Count;
end;


// This function manages the loading of the SDB file on the first cache request
// for an OHP file, and the caching of the data about each song within it.
function PageCache_EnsureID( sID : string; var iIdx : integer ) : boolean;
begin
  Result := false;
  iIdx   := -1;
  if hPageCache = nil then Exit;

  // First time through, we just load in the SDB file.
  PageCache_EnsureSDB;
  if bLoadedSDB then begin
    iIdx   := hPageCache.IndexOf(sID);
    Result := ( -1 <> iIdx );
  end;
end;



function PageCache_GetEntry( sID : string ) : TPageCacheEntry;
var i : integer;
begin
  Result := nil;
  if PageCache_EnsureID( sID, i ) then begin
    Result := hPageCache.Objects[i] as TPageCacheEntry;
  end;
end;


{ Direct TPageCacheEntry access functions - the ones that do the work! }

function PageCache_EntryGetRTF( hEntry : TPageCacheEntry; iPage : integer ) : string;
var
  sFile  : string;
  pPage  : PCachePage;
begin
  Result := '';
  PageCache_EntryEnsureOHP( hEntry );
  if iPage <= hEntry.iPageCount then begin
    pPage := @hEntry.aPages[iPage-1];
    if not pPage^.bLoaded then begin
      sFile := hEntry.SR.Id +'-'+ IntToStr(iPage) +'.rtf';
      if GetFileDataFromZip( OHPFile, sFile, pPage^.sText, false )
                      then pPage^.bLoaded := true;
    end;

    // Set return value
    if pPage^.bLoaded then Result := pPage^.sText;
  end;
end;

procedure PageCache_EntryEnsureOHP( hEntry : TPageCacheEntry );
var
  sOHPText, sInfoFile, sPages, sMod, sKey : string;
  i, iCode, iPos : integer;
  pPage : PCachePage;
begin
  if hEntry.iPageCount = -1 then
  begin
    // Get the OHP file from the ZIP file
    sInfoFile := hEntry.SR.Id + '.ohp';
    if not GetFileDataFromZip( OHPFile, sInfoFile, sOHPText, true ) then begin
      // No OHP file - means no pages
      hEntry.iPageCount := 0;
      Exit;
    end;

    // And acquire the number of pages
    sPages := GetStrLine( sOHPText );
    val( sPages, hEntry.iPageCount, iCode );

    // Now, if we were successful, read the shortcut keys for the pages
    if hEntry.iPageCount > 0 then
    begin
      setlength( hEntry.aPages, hEntry.iPageCount );
      for i := 1 to hEntry.iPageCount do
      begin
        pPage := @hEntry.aPages[i-1];
        pPage^.bLoaded         := false;
        pPage^.hBGPicture      := nil;

        // Firstly split the string
        sPages := GetStrLine( sOHPText );
        iPos := pos('$',sPages);
        if iPos > 0 then begin
          pPage^.sPicture := copy(sPages,iPos+1,length(sPages));
          sPages := copy(sPages,0,iPos-1);
        end;

        // Then get the modifier and key values
        iPos := pos('~',sPages);
        sMod := copy( sPages, 0, iPos-1 );
        sKey := copy( sPages, iPos+1, length(sPages) );

        val( sMod, pPage^.iModifier,    iCode );
        val( sKey, pPage^.iShortcutKey, iCode );
      end;
    end;
  end;
end;

function PageCache_GetOHPString( hEntry : TPageCacheEntry ) : string;
var
  sText : string;
  iIdx  : integer;
  pPage : PCachePage;
begin
  PageCache_EntryEnsureOHP( hEntry );

  // The first line is the number of pages
  sText := IntToStr( hEntry.iPageCount );

  // Then there's one line for each page
  for iIdx := 1 to hEntry.iPageCount do begin
    pPage := @hEntry.aPages[iIdx-1];
    sText := sText + Chr(13) + Chr(10);

    // If there's a picture, it goes first, followed by a $
    if trim(pPage^.sPicture) <> '' then begin
      sText := sText + trim(pPage^.sPicture) + '$';
    end;

    // Then the modifier code, followed by the unmodified shortcut key
    sText := sText + IntToStr( pPage^.iModifier ) + '~'
                   + IntToStr( pPage^.iShortcutKey );
  end;
  Result := sText;
end;


procedure PageCache_ValidateOHPFile( OHPFile, TempDir : string );
var
    i : integer;
    hAllItems : TStringList;
    TF : TextFile;
    S : string;
begin
  // FUDGE: Check the OHP file and see whether it's created by this version or above...
  hAllItems := ListZipEntries( OHPFile, 'songbase.version', TempDir );
  if 0 = hAllItems.Count then begin
    FInfoBox.ShowBox( FSongbase, FSongbase.SValidateCache );
    hAllItems := ListZipEntries( OHPFile, '*', TempDir );
    i := 0;
    while i < hAllItems.Count do begin
      if LowerCase(hAllItems[i]) = hAllItems[i] then begin
        hAllItems.Delete(i);
      end else begin
        // Only RTF and OHP files need to be lower case
        if AnsiEndsText( '.OHP', hAllItems[i] ) or
           AnsiEndsText( '.RTF', hAllItems[i] ) then inc(i)
                                                else hAllItems.Delete(i);
      end;
    end;

    // If there's anything to fix, do it now.
    if hAllItems.Count > 0 then begin
      FInfoBox.ShowBox( FSongbase, 'Please Wait... correcting catalogue' );
      for i := 0 to hAllItems.Count-1 do begin
        S := TempDir + LowerCase( hAllItems[i] );
        ExtractFileFromZip(OHPFile, hAllItems[i], TempDir);
        if FileExists( TempDir + hAllItems[i] ) then begin
          DeleteFileFromZip(OHPFile, hAllItems[i] );
          RenameFile( TempDir+hAllItems[i], S );
          AddFileToZip( S, OHPFile, true );
        end;
      end;
    end;

    // Create the info file - to say which version of Songbase is responsible for this SDB file
    S := TempDir+'songbase.version';
    if OpenForWrite( TF, S ) then begin
      writeln( TF, 'CreatedBy: ' + VERSION_NAME );
      CloseTextfile( TF, S );
      AddFileToZip( S, OHPFile, true );
    end;

    FInfoBox.Close;
  end;
end;


function PageCache_GetNextFreeSongID( iPrevID : integer = 0 ) : integer;
var i, iCode, iId, iMax : integer;
begin
  iMax := iPrevID;
  for i := 0 to hPageCache.Count-1 do begin
    val( hPageCache.Strings[i], iId, iCode);
    if iId > iMax then iMax := iId;
  end;
  Result := 1+ iMax;
end;


function PageCache_GetIDForSBTitle( sTitle : string ) : string;
var i : integer;
    hEntry : TPageCacheEntry;
    sSq : string;
begin
  sSq := FSongbase.squash(sTitle);
  for i := 0 to hPageCache.Count-1 do begin
    hEntry := hPageCache.Objects[i] as TPageCacheEntry;
    if FSongbase.squash(hEntry.SR.Title) = sSq then begin
      Result := hPageCache.Strings[i];
      Exit;
    end;
  end;
  Result := '';
end;


function PageCache_GetByTitle( sTitle : string ) : string;
var i : integer;
    hEntry : TPageCacheEntry;
begin
  for i := 0 to hPageCache.Count-1 do begin
    hEntry := hPageCache.Objects[i] as TPageCacheEntry;
    if hEntry.sSongname = sTitle then begin
      Result := hPageCache.Strings[i];
      Exit;
    end;
  end;
  Result := '';
end;

function  PageCache_SearchTitles( sSearchStr : string ) : TStringList;
var i, iLen : integer;
    hEntry : TPageCacheEntry;
    sKey : string;
    hList : TStringList;
begin
  // Get the key in the right format
  sKey  := FSongbase.squash( sSearchStr );
  iLen  := length(sKey);
  hList := TStringList.Create;

  for i := 0 to hPageCache.Count-1 do begin
    hEntry := hPageCache.Objects[i] as TPageCacheEntry;
    if copy( FSongbase.squash(hEntry.SR.Title), 1, iLen) = sKey then begin
      hList.Add(hPageCache.Strings[i]);
    end
    else if copy( FSongbase.squash(hEntry.SR.AltTitle), 1, iLen) = sKey then begin
      hList.Add( '~' + hPageCache.Strings[i]);
    end;
  end;
  Result := hList;
end;


function  PageCache_CreateSearchList( hList : TStringList ) : boolean;
var i : integer;
    hEntry : TPageCacheEntry;
begin
  // Get the key in the right format
  hList.Clear;
  for i := 0 to hPageCache.Count-1 do begin
    hEntry := hPageCache.Objects[i] as TPageCacheEntry;
    with hEntry.SR do begin
      hList.Add(FSongbase.Squash(Title)+'~'+hEntry.sSongname+'~'+ID);
      if length(AltTitle) > 2 then begin
        hList.Add( FSongbase.Squash(AltTitle)+'~'+AltTitle+' ('+Title+')~'+ID);
      end;
    end;
  end;

  Result := true;
end;

procedure PageCache_SaveRTF( hRichEdit:TRichEdit; sID:string; iPage:integer );
var S : string;
begin
  // Save from richedit control into memory
  MemStream.Clear;
  hRichEdit.Lines.SaveToStream(MemStream);

  // Save the memory stream into the appropriate file... sorry...
  str(iPage,S);
  S:=sID+'-'+S+'.rtf';
  MemStream.SaveToFile( TempDir+S );
end;

procedure PageCache_SetRichText( hRichEdit : TRichEdit; sText : string );
begin
  // Write it into the memory stream
  MemStream.Clear;
  MemStream.WriteBuffer(Pointer(sText)^, Length(sText));
  MemStream.Position := 0;

  // Now load into the richedit control
  hRichEdit.PlainText := False;
  hRichEdit.Clear;
  hRichEdit.Lines.LoadFromStream(MemStream);
end;

function PageCache_GetRichText( hRichEdit:TRichEdit ) : string;
const BufferSize = 102;
var S : string;
    iRead  : integer;
    Buffer : array[0..BufferSize] of Char;
begin
  // Save from richedit control into memory
  MemStream.Clear;
  hRichEdit.Lines.SaveToStream(MemStream);

  // Get the memory stream into a string and return it.
  MemStream.Position := 0;
  repeat begin
    iRead := MemStream.Read( Buffer, BufferSize );
    S := S + Copy( Buffer, 0, iRead );
  end until iRead < BufferSize;
  Result := S;
end;

function PageCache_FindImportSongState( sOHPImport : string; SR : SongRecord ) : integer;
var hEntry : TPageCacheEntry;
    iImpTime, iSrcTime : TDateTime;
    i, iCmp : integer;
    S : string;
begin
  Result := SONGSTATE_NEW;

  // Iterate through the songs in this
  PageCache_EnsureSDB;
  for i := 0 to hPageCache.Count-1 do begin
    hEntry := hPageCache.Objects[i] as TPageCacheEntry;

    if FSongbase.squash( hEntry.SR.Title ) = FSongbase.squash( SR.Title ) then
    begin
      // Get the time of the OHP file from the Import Zip File
      S := SR.Id + '.ohp';
      ExtractFileFromZip(sOHPImport,S,TempDir);
      if FileExists(TempDir+S) then begin
        iImpTime := FileDateToDateTime( FileAge(TempDir+S) );

        // Get the time of the OHP file from the Current Zip File
        S := hEntry.SR.Id + '.ohp';
        ExtractFileFromZip(OHPFile,S,TempDir);
        if FileExists(TempDir+S) then begin
          iSrcTime := FileDateToDateTime( FileAge(TempDir+S) );

          // Compare the timers
          iCmp := CompareDateTime( iImpTime, iSrcTime );
          if          iCmp > 0 then begin Result := SONGSTATE_NEWER;
          end else if iCmp < 0 then begin Result := SONGSTATE_OLDER;
          end else                  begin Result := SONGSTATE_SAME;
          end;
        end;
      end;
      break;
    end;
  end;
end;

end.
