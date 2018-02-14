unit Export;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBZipUtils, SBFiles, ImgList, Buttons, ComCtrls;

type
  MergeRecord = record
    iStringHash : integer;
    iSongState : integer;
    iId : integer;
    tOHPLastMod : TDateTime;
    SR : PSongRecord;
  end;

type
  PMergeRecord = ^MergeRecord;

type
  TFExport = class(TForm)
    BExport: TButton;
    lvFileList: TListView;
    BYouNone: TBitBtn;
    BYouAll: TBitBtn;
    BvDone: TBevel;
    Bevel1: TBevel;
    CBLinks: TCheckBox;
    SaveDialog1: TSaveDialog;
    BCancel: TButton;
    ImageList1: TImageList;

    procedure BCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BYouAllClick(Sender: TObject);
    procedure BYouNoneClick(Sender: TObject);
    procedure BExportClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvFileListData(Sender: TObject; Item: TListItem);

  private
    { Private declarations }
//    procedure MergeFiles( hList : TListView; FromFile, ToFile : string );
  public
    ExportFilename : string;
    posX,posY : integer;
    MyFileChanged : boolean;
    SWaitMessage : string;
    FileTitle    : string;

    MeSortColumn, YouSortColumn : integer;
    MeSortAsc,    YouSortAsc    : boolean;

    { Public declarations }
    RecordCount  : integer;
    CheckedCount : integer;
    CheckedItems : array of boolean;
  end;

var
  FExport: TFExport;

implementation

uses EditProj, SBMain, Math, PageCache, InfoBox, About;

{$R *.DFM}

procedure TFExport.BCancelClick(Sender: TObject);
begin
  close;
end;

{procedure TFExport.MergeFiles( hList : TListView; FromFile, ToFile : string );
var hIDs           : TList;
    hFromRecords   : TList;
    hItem          : TListItem;
    pSR            : PSongRecord;
    aPageCounts    : array of integer;
    ToOhp, FromOHP : string;
    ToFSH, FromFSH : string;
    S, S2, sID     : string;
    i,j            : integer;
    TF, FOut, TOHP : Textfile;
    FirstID, Code  : integer;
    SR             : SongRecord;
begin
  ToOHP := ToFile;
  while (copy(ToOHP,length(ToOhP),1)<>'.') do ToOHP:=copy(ToOHP,1,length(ToOhp)-1);
  ToFSH:=ToOhP+'fsh';
  ToOHP:=ToOhP+'ohp';

  FromOHP:=FromFile;
  while (copy(FromOHP,length(FromOhP),1)<>'.') do FromOHP:=copy(FromOHP,1,length(FromOhp)-1);
  FromFSH:=FromOhp+'fsh';
  FromOHP:=FromOhP+'ohp';

  // Search through the list and get the checked items - then sort by name
  // (as this will determine insertion point in the destination file, not ID)
  hIDs := TList.Create;
  for i := 0 to hList.Items.Count-1 do begin
    if hList.Items[i].Checked then begin
      hIDs.Add( hList.Items[i] );
    end;
  end;
  hIDs.Sort( SortListItemsByName );

  // Now, get the ID which we can start inserting new songs in at.
  // IMPROVE: Presumably, we need to plug gaps otherwise this will just run out of control?
  FirstID:=1;
  if not OpenForRead(TF,ToFile) then Exit;
  while not eof(TF) do begin
    readln(TF,S);
    DeLimit(s,SR);
    val(SR.ID,i,Code);
    if i>=FirstId then FirstId:=i+1;
  end;
  CloseTextfile(TF,ToFile);

  // Now open the 'From' file and read in the data lines for the IDs selected
  hIDs := TList.Create;
  hFromRecords := TList.Create;
  if not OpenForRead( TF, FromFile ) then Exit;
  while (not eof(TF)) do begin
    readln(TF,S);
    New(pSR);
    DeLimit(s,pSR^);

    // Find the item with the given id
    for i:=0 to hList.Items.Count-1 do begin
      hItem := hList.Items[i];
      if hItem.SubItems[2] = pSR^.Id then begin
        if hItem.Checked then begin
          // Found it, add the items to the lists for export.
          hIDs.Add( hItem );
          hFromRecords.Add( pSR );
        end;
        Break;
      end;
    end;
  end;
  CloseTextfile( TF, FromFile );

  // IMPROVE: Resort hFromRecords and hIDs so they're in 'before' order

  // Take a copy of the destination catalogue so we can write to it
  FileCopy( ToOHP, TempDir+'temp.ohp' );
  if not FileExists( TempDir+'temp.ohp' ) // or not writable
  then begin
    LogThis( 'ERROR: Failed to create new OHP file' );
    CleanUpRecords( hFromRecords );
    Exit;
  end;

  // Then open up the reading and writing files
  if not OpenForRead( TF, ToFile ) or
     not OpenForWrite( FOut, TempDir+'temp.sdb' ) then begin
    LogThis( 'ERROR: Failed to access files for import' );
    CleanUpRecords( hFromRecords );
    Exit;
  end;

  // Now scan through the 'ToFile' to find where to insert each item
  i := 0;
  while not Eof(TF) do begin
    readln(TF,S);
    DeLimit(s,SR);
    if i < hFromRecords.Count then begin
      pSR := hFromRecords.Items[i];
      while FSongbase.before(pSR^.Title, SR.Title) do
      begin
        // IMPLEMENT: Ignore multimedia links, reset usage indicators, etc...

        // Select the next available ID number
        pSR^.Id := IntToStr(FirstId + i);
        Limit(S2,pSR^);
        writeln( FOut, S2 );
        inc(i);
        if i >= hFromRecords.Count then Break;
        pSR := hFromRecords.Items[i];
      end;
    end;
    writeln( FOut, S );
  end;
  CloseTextFile( TF, ToFile );

  // If we have any records left over at the end, write them now.
  while i < hFromRecords.Count do begin
    // Select the next available ID number
    pSR := hFromRecords.Items[i];
    pSR^.Id := IntToStr(FirstId + i);
    Limit(S2,pSR^);
    writeln( FOut, S2 );
    inc(i);
  end;

  // Once that's done, we have a new SDB file, close it
  CloseTextfile( FOut, 'temp.sdb' );

  // Now we have our list of data from the source file, decompress the
  // RTFs from the From OHP so we can transfer them to the To file and
  // take account of the number of pages in each.
  SetLength( aPageCounts, hIDs.Count );
  for i := 0 to hIDs.Count-1 do begin
    hItem := hIds.Items[i];
    pSR   := hFromRecords.Items[i];

    // Get the filename to extract
    sID := hItem.SubItems[2];
    S2  := sID + '.ohp';
    ExtractFileFromZip( FromOHP, S2, TempDir );

    // Open the OHP file
    if not OpenForRead( TOhp, TempDir+S2 ) then begin
      LogThis( 'ERROR: OHP file '+S2+' failed to decompress' );
      CleanUpRecords( hFromRecords );
      Exit;
    end;

    // And get the actual number of pages
    readln(TOhp,S);
    val(S,aPageCounts[i],Code);
    CloseTextFile( TOhp, TempDir+S2 );

    // Then rename the OHP file
    S := TempDir + pSR^.Id + '.ohp';
    RenameFile( TempDir+S2, S );
    AddFileToZip( S, TempDir+'temp.ohp', true );

    // Now extract the pages and add them to the new catalogue
    for j := 1 to aPageCounts[i] do begin
      S   := '-'+IntToStr(j)+'.rtf';
      S2  := TempDir+pSR^.Id + S;
      S   := sID + S;

      ExtractFileFromZip( FromOHP, S, TempDir );
      RenameFile( TempDir+S, S2 );
      AddFileToZip( S2, TempDir+'temp.ohp', true );
    end;
  end;

  // And now remove the checked items (which we've now resolved) from the list
  for i := 0 to hIDs.Count-1 do begin
    hItem := hIds.Items[i];
    hItem.Delete;
  end;

  // Finally clean up the record data...
  CleanUpRecords( hFromRecords );

  // Then update the actual files, by first making space for them
  if FileExists(ToFile + '.bak') then DeleteFile(ToFile + '.bak');
  if FileExists(ToOHP  + '.bak') then DeleteFile(ToOHP  + '.bak');
  if FileExists(ToFSH  + '.bak') then DeleteFile(ToFSH  + '.bak');

  // Then moving the old ones out of the way
  DeleteFile( ToFSH );
  RenameFile( ToOHP,  ToOHP + '.bak' );
  RenameFile( ToFile, ToFile+ '.bak' );

  // And move the new ones in
  RenameFile( TempDir+'temp.ohp', ToOHP );
  RenameFile( TempDir+'temp.sdb', ToFile );
end;}

procedure TFExport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  posX:=left;
  posY:=top;
end;

procedure TFExport.ListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var hItem : TListItem;
    hHit  : THitTests;
    hList : TListView;
begin
  hList   := Sender as TListView;
  hItem := hList.GetItemAt(x, y);
   if (hItem <> nil) then begin
    hHit := hList.GetHitTestInfoAt(x, y);
    if hHit = [htOnIcon] then begin
      CheckedItems[hItem.Index] := not CheckedItems[hItem.Index];
      if CheckedItems[hItem.Index] then inc( CheckedCount )
                                   else dec( CheckedCount );
      lvFileList.UpdateItems(hItem.Index, hItem.Index);
      BExport.Enabled := ( CheckedCount > 0 );
    end;
  end;
end;

procedure TFExport.BYouAllClick(Sender: TObject);
var iIdx: integer;
begin
  for iIdx := 0 to RecordCount-1 do begin
    CheckedItems[iIdx] := true;
  end;
  CheckedCount := RecordCount;
  lvFileList.Invalidate;
  BExport.Enabled := (RecordCount > 0);
end;

procedure TFExport.BYouNoneClick(Sender: TObject);
var iIdx: integer;
begin
  for iIdx := 0 to RecordCount-1 do begin
    CheckedItems[iIdx] := false;
  end;
  CheckedCount := 0;
  lvFileList.Invalidate;
  BExport.Enabled := false;
end;

procedure TFExport.BExportClick(Sender: TObject);
var iIdx, iPage, iCurrentIdx : integer;
    SR : SongRecord;
    sNewID, sInfoStr, sOutFile, sFile, sPageText : string;
    SDBOutFile, OHPOutFile : string;
    FOHP, FSDB, FTMP, FPage : TextFile;
    hEntry : TPageCacheEntry;
    hZipFiles : TStringList;
    TmpOutOHP, TmpOutSDB : string;
    bResult : boolean;
begin
  SaveDialog1.Title:= FileTitle;
  SaveDialog1.Filter:='Songbase Files|*.sdb';
  SaveDialog1.Options:=[ofOverWritePrompt];

  if 0 = CheckedCount then Exit;

  SaveDialog1.Filename := 'export.sdb';
  if 1 = CheckedCount then begin
    for iIdx := 0 to RecordCount-1 do begin
      if CheckedItems[iIdx] then begin
        if PageCache_GetSongFromIndex( iIdx, SR ) then begin
          SaveDialog1.Filename := SR.Title + '.sdb';
        end;
        break;
      end;
    end;
  end;
  if not SaveDialog1.Execute then Exit;

  // If there's no extension, add one
  SDBOutFile := SaveDialog1.FileName;
  if '' = ExtractFileExt(SDBOutFile) then SDBOutFile := SDBOutFile + '.sdb';
  OHPOutFile := ChangeFileExt( SDBOutFile, '.ohp' );

  iCurrentIdx := 0;
  bResult     := true;
  TmpOutOHP   := TempDir + 'temp.ohp';
  TmpOutSDB   := TempDir + 'temp.sdb';

  // close it and write the file
  Close;

  // CREATE THE FILE
  if not OpenForWrite( FSDB, TmpOutSDB ) then Exit;

  FSongbase.Cursor := crHourGlass;
  sInfoStr := 'Saving....';
  FInfoBox.ShowBox( Self, sInfoStr );
  FInfoBox.Label1.Refresh;

  // Initialise the Zip files list
  hZipFiles := TStringList.Create;

  // Now, find all the selected items in the list
  for iIdx := 0 to RecordCount-1 do begin
    if CheckedItems[iIdx] then
    begin
      // SAVE THE ENTRY
      hEntry := PageCache_GetEntryFromIndex( iIdx );

      inc( iCurrentIdx );
      sNewID := IntToStr( iCurrentIdx );
      if nil <> hEntry then
      begin
        // Retrieve the pages from the cache
        PageCache_EntryEnsureOHP( hEntry );

        // Write the OHP file for the new entry.
        sPageText := PageCache_GetOHPString( hEntry );
        sOutFile  := TempDir + sNewID + '.ohp';
        if OpenForWrite( FOHP, sOutFile ) then begin
          Writeln( FOHP, sPageText );
          CloseFile( FOHP );
          hZipFiles.Add( sOutFile );
        end else bResult := false;

        // Now, for each page...
        if bResult then begin
          for iPage := 1 to hEntry.iPageCount do
          begin
            // Get the RTF data as a string and write it out with the 'new' ID.
            sFile    := hEntry.SR.Id +'-'+ IntToStr(iPage)     +'.rtf';
            sOutFile := TempDir + sNewID +'-'+ IntToStr(iPage) +'.rtf';
            if GetFileDataFromZip( OHPFile, sFile, sPageText, false ) then begin
              assignfile( FPage, sOutFile );
              rewrite( FPage );
              if 0 = IOResult then begin
                Write( FPage, sPageText );
                CloseFile( FPage );
                hZipFiles.Add( sOutFile );
              end else bResult := false;
            end;
            if false = bResult then break;
          end;
        end;

        // Finally, convert the SongRecord back to a string and write it
        if bResult then begin
          SR := hEntry.SR;
          SR.Id := sNewID;
          Limit( sPageText, SR );
          writeln( FSDB, sPageText );
        end;
      end;

      // IMPLEMENT: Add multimedia links here for this song!

      // If we can get out early, we will
      dec( CheckedCount );
      if 0 = CheckedCount then break;

      if (0 = CheckedCount mod 10) then begin
        FInfoBox.Label1.Caption := sInfoStr + ' (' + IntToStr( CheckedCount ) + ' remaining)';
        FInfoBox.Label1.Refresh;
      end;
    end;
    if false = bResult then break;
  end;

  // CLOSE THE SDB FILE
  CloseFile( FSDB );

  // Now write the zip files to the output OHP file
  if bResult then begin
    bResult := WriteEmptyZip( TmpOutOHP );

    // Create the info file - to say which version of Songbase is responsible for this SDB file
    sFile := TempDir+'songbase.version';
    if OpenForWrite( FTMP, sFile ) then begin
      writeln( FTMP, 'CreatedBy: ' + VERSION_NAME );
      CloseTextfile( FTMP, sFile );
      AddFileToZip( sFile, TmpOutOHP, true );
    end;

    FInfoBox.Label1.Caption := 'Updating index, please wait';
    FInfoBox.Label1.Refresh;
    if bResult then AddFilesToZip( hZipFiles, TmpOutOHP, true );
  end;

  // If we got to here then write the final files
  if bResult then begin
    if FileExists( OHPOutFile + '.bak' ) then DeleteFile( OHPOutFile + '.bak' );
    if FileExists( SDBOutFile + '.bak' ) then DeleteFile( SDBOutFile + '.bak' );
    if FileExists( OHPOutFile ) then RenameFile( OHPOutFile, OHPOutFile + '.bak' );
    if FileExists( SDBOutFile ) then RenameFile( SDBOutFile, SDBOutFile + '.bak' );
    RenameFile( TmpOutOHP, OHPOutFile );
    RenameFile( TmpOutSDB, SDBOutFile );
  end else begin
    if FileExists( TmpOutOHP ) then DeleteFile( TmpOutOHP );
    if FileExists( TmpOutSDB ) then DeleteFile( TmpOutSDB );
  end;

  FInfoBox.Close;
  FSongbase.Cursor := crDefault;
//  MergeFiles( ListMe, MyFile, RemoteFile );
  //PrepareImports;
end;

procedure TFExport.FormShow(Sender: TObject);
begin
  // DISPLAY 'PLEASE WAIT' MESSAGE
  YouSortAsc       := true;

  // Get the list of items
  RecordCount       := PageCache_GetSongCount();
  SetLength( CheckedItems, 0 );
  SetLength( CheckedItems, RecordCount );
  lvFileList.Items.Count := RecordCount;

  // We select the current song, by default
  CheckedCount := 1;
  CheckedItems[ FSongbase.SBRecNo.Position-1 ] := true;
  lvFileList.Items[FSongbase.SBRecNo.Position-1].MakeVisible(false);
  BExport.Enabled := true;
end;

procedure TFExport.lvFileListData(Sender: TObject; Item: TListItem);
var sSongname : string;
    SR        : SongRecord;
begin
  // on data
  if (Item.Index <= RecordCount) and
     PageCache_GetSongFromIndex( Item.Index, SR ) and
     PageCache_GetSongnameFromIndex( Item.Index, sSongname ) then begin
    Item.ImageIndex := Ord( CheckedItems[Item.Index] );
    Item.Caption := sSongname;
    Item.Data    := PChar(SR.Id);
  end;
end;

end.

