unit Import;

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
  TFImport = class(TForm)
    LMe: TLabel;
    BImport: TButton;
    lvFileList: TListView;
    BAllAll: TBitBtn;
    BNone: TBitBtn;
    BvDone: TBevel;
    BCancel: TButton;
    ImageList1: TImageList;
    LAll: TLabel;
    BChangedAll: TBitBtn;
    LChanged: TLabel;
    LNew: TLabel;
    BNewAll: TBitBtn;
    Bevel1: TBevel;
    LNone: TLabel;
    LSelect: TLabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    cbDuplicates: TCheckBox;
    Bevel4: TBevel;
    CheckBox1: TCheckBox;
    procedure BCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lvFileListColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BAllAllClick(Sender: TObject);
    procedure BNoneClick(Sender: TObject);
    procedure BImportClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvFileListData(Sender: TObject; Item: TListItem);
    procedure BChangedAllClick(Sender: TObject);
    procedure BNewAllClick(Sender: TObject);

  private
    { Private declarations }
//    procedure MergeFiles( hList : TListView; FromFile, ToFile : string );
  public
    RemoteFile : string;
    MyFile : string;
    posX,posY : integer;
    MyFileChanged : boolean;

    SDBInFile, OHPInFile : string;    // SDB & OHP files

    { Public declarations }

    { Public declarations }
    RecordCount  : integer;
    CheckedCount : integer;
    CheckedItems : array of boolean;

    SRs          : array of SongRecord;
    States       : array of integer;

    SortColumn   : integer;
    SortAsc      : boolean;
    SortedIdxs   : array of integer;
  end;

var
  FImport: TFImport;
  SLIMP : TStringList;
  SLEx : TStringList;
  SLRemote : TStringList;
  SLCurrent : TStringList;
  SongStates : array[0..3] of string = ( 'Same', 'New', 'Newer', 'Older' );


implementation

uses EditProj, SBMain, Math, InfoBox, PageCache, Contnrs;

{$R *.DFM}


 {   RF:=FileOpen.FileName;
    if RF=FileName then begin
      messagedlg('Import and Export tools need two different files',mtError,[mbOk],0);
    end else begin
      if (uppercase(copy(RF,length(RF)-3,4))<>'.SDB') then RF:=RF+'.sdb';
      m:=mrYes; newf:=false;
      if not fileexists(RF) then begin
        newf:=true;
        m:=messagedlg('This song database does not exist. Create new database?',mtConfirmation,[mbYes,mbCancel],0);
      end;
      if (m=mrYes) then begin
        if NEwf then begin
          while RF[length(RF)]<>'.' do RF:=copy(RF,1,length(RF)-1);
          if not OpenForWrite(TF,RF+'sdb') then Exit;
          CloseTextfile(TF,RF+'sdb');
          if not OpenForWrite(TF,RF+'sor') then Exit;
          CloseTextfile(TF,RF+'sor');
          RF:=RF+'sdb';
        end;
        FImpExp.MyFile:=FileName;
        FImpExp.RemoteFile:=RF;
        FImpExp.Top:=FSongbase.Top+10;
        FImpExp.Left:=FSongbase.Left+10;
        FInfoBox.ShowBox( FImpExp, 'Please Wait... working out which songs have changed' );
        Save_Cursor := Screen.Cursor;
        Screen.Cursor := crHourGlass;
        FImpExp.PrepareImports;
        FInfoBox.Close;
        Screen.Cursor := Save_Cursor;
        FImpExp.ShowModal;
        if FImpExp.MyFileChanged then TryOpen(Sender);
      end;
    end;
  end;}

{procedure TFImport.PrepareImports;
var TF : TextFile;
    S : string;
    hMeSR, hYouSR : PSongRecord;
    hMMe, hMYou : PMergeRecord;
    hMe, hYou : TList;
    hMeMerges, hYouMerges : TList;
    iCode, iMe, iYou : integer;
    MyOHPFile, YouOHPFile : string;
    hListItem : TListItem;
begin
  left:=posX;
  top:=posY;
  SLIMP:=TStringList.Create;
  SLEx:=TStringList.Create;
  SLRemote:=TStringList.Create;
  SLCurrent:=TStringList.Create;
  SLImp.Sorted:=true;
  SLEx.Sorted:=true;
  SLRemote.Sorted:=true;
  SLCurrent.Sorted:=true;
  MeSortColumn := 0;
  YouSortColumn := 0;
  MeSortAsc := true;
  YouSortAsc := true;

  // Create the lists
  hMe        := TList.Create;
  hYou       := TList.Create;
  hMeMerges  := TList.Create;
  hYouMerges := TList.Create;

  // Get the filenames
  MyOHPFile  := OHPFile;
  YouOHPFile := ChangeFileExt( RemoteFile, 'ohp');

  LME.Caption:=MyFile;
  if LME.Width>250 then begin
    while (LME.Width>240) do begin
      LME.Caption:=copy(LME.Caption,2,lengtH(LME.Caption)-1);
    end;
    LME.Caption:='...'+LME.Caption;
  end;
  LYou.Caption:=RemoteFile;
  if LYou.Width>250 then begin
    while (LYou.Width>240) do begin
      LYou.Caption:=copy(LYou.Caption,2,lengtH(LYou.Caption)-1);
    end;
    LYou.Caption:='...'+LYou.Caption;
  end;
  ListMe.Items.Clear;
  ListYou.Items.Clear;
  SLCurrent.Clear;
  SLRemote.Clear;
  SLImp.Clear;
  SLEx.Clear;

  // Read in entries from THIS catalogue
  if not OpenForRead(TF,MyFile) then Exit;
  while not eof(TF) do begin
    readln(TF,S);
    new(hMeSR);
    DeLimit(s,hMeSR^);
    hMe.Add( hMeSR );

    // Hash the record and get the last-modified time of the words file
    new(hMMe);
    hMMe.SR := hMeSR;
    hMMe.tOHPLastMod := 0;
    hMMe.iSongState := 0;

    S := hMeSR.Id + '.ohp';
    ExtractFileFromZip(MyOHPFile,S,TempDir);
    if FileExists(TempDir+S) then
      hMMe.tOHPLastMod := FileDateToDateTime( FileAge(TempDir+S) );
    Val( hMeSR.Id, hMMe.iId, iCode );
    hMMe.iStringHash := HashRecord(hMeSR);
    hMeMerges.Add(hMMe);
//    LBCurrent.Items.Add(SR.Title);
//    SLCurrent.Add(SR.Title+'~'+SR.ID);
  end;
  CloseTextfile(TF, MyFile);

  // Read in entries from THE OTHER catalogue
  if not OpenForRead(TF,RemoteFile) then Exit;
  while not eof(TF) do begin
    readln(TF,S);
    new(hYouSR);
    DeLimit(s,hYouSR^);
    hYou.Add( hYouSR );

    // Hash the record and get the last-modified time of the words file
    new(hMYou);
    hMYou.SR := hYouSR;
    hMYou.tOHPLastMod := 0;
    hMYou.iSongState := 0;

    S := hYouSR.Id + '.ohp';
    ExtractFileFromZip(YouOHPFile,S,TempDir);
    if FileExists(TempDir+S) then
      hMYou.tOHPLastMod := FileDateToDateTime( FileAge(TempDir+S) );
    Val( hYouSR.Id, hMYou.iId, iCode );
    hMYou.iStringHash := HashRecord(hYouSR);
    hYouMerges.Add(hMYou);
//    LBRemote.Items.Add(SR.Title);
//    SLRemote.Add(SR.Title+'~'+SR.ID);
  end;
  CloseTextfile(TF, RemoteFile);

  // Sort both of the lists by IDs
  hMeMerges.Sort(  SortSongRecordCallback );
  hYouMerges.Sort( SortSongRecordCallback );

  // Remove the entries which match
  iMe  := 0;
  iYou := 0;
  while (iMe < hMeMerges.Count) and (iYou < hYouMerges.Count) do begin
    hMMe  := hMeMerges.Items[iMe];
    hMYou := hYouMerges.Items[iYou];
    if (hMMe.iStringHash = hMYou.iStringHash) and
       (hMMe.tOHPLastMod = hMYou.tOHPLastMod) and
       (hMMe.iId         = hMYou.iId) then begin
      hMeMerges.Delete( iMe);
      hYouMerges.Delete(iYou);
    end else begin
      // New/Old song?
      if (hMMe.iStringHash = hMYou.iStringHash) and
         (hMMe.iId         = hMYou.iId)         then
      begin
        // Song is the same, which one's newer?!
        if (hMMe.tOHPLastMod > hMYou.tOHPLastMod) then begin
          hMMe.iSongState  := SONGSTATE_NEWER;
          hMYou.iSongState := SONGSTATE_OLDER;
        end else begin
          hMMe.iSongState  := SONGSTATE_OLDER;
          hMYou.iSongState := SONGSTATE_NEWER;
        end;
        inc(iMe);
        inc(iYou);
      end else if( hMMe.iStringHash > hMYou.iStringHash) then begin
        hMYou.iSongState := SONGSTATE_NEW;
        inc(iYou);
      end else if( hMMe.iStringHash < hMYou.iStringHash) then begin
        hMMe.iSongState := SONGSTATE_NEW;
        inc(iMe);
      end else if( hMMe.iId > hMYou.iId) then begin
        hMYou.iSongState := SONGSTATE_NEW;
        inc(iYou);
      end else begin
        hMMe.iSongState := SONGSTATE_NEW;
        inc(iMe);
      end;
    end;
  end;

  while iYou < hYouMerges.Count do begin
    hMYou := hYouMerges.Items[iYou];
    hMYou.iSongState := SONGSTATE_NEW;
    inc(iYou);
  end;
  while iMe < hMeMerges.Count do begin
    hMMe := hMeMerges.Items[iMe];
    hMMe.iSongState := SONGSTATE_NEW;
    inc(iMe);
  end;

  // Then update the two lists with those ones which remain
  for iMe := 0 to hMeMerges.Count-1 do begin
    hMMe  := hMeMerges.Items[iMe];
    hListItem := ListMe.Items.Add;
    hListItem.Caption := hMMe.SR.Title;
    hListItem.SubItems.Add( SongStates[hMMe.iSongState] );
    hListItem.SubItems.Add( DateTimeToStr(hMMe.tOHPLastMod) );
    hListItem.SubItems.Add( IntToStr(hMMe.iId) );
//    LBCurrent.Items.Add( hMMe.SR.Title );
//    SLCurrent.Add(hMMe.SR.Title+'  """'+hMMe.SR.ID);
  end;
  for iYou := 0 to hYouMerges.Count-1 do begin
    hMYou := hYouMerges.Items[iYou];
    hListItem := ListYou.Items.Add;
    hListItem.Caption := hMYou.SR.Title;
    hListItem.SubItems.Add( SongStates[hMYou.iSongState] );
    hListItem.SubItems.Add( DateTimeToStr(hMYou.tOHPLastMod) );
    hListItem.SubItems.Add( IntToStr(hMYou.iId) );
// LBRemote.add( hMYou.Sr.Title );
//    SLRemote.Add(hMYou.SR.Title+'  """'+hMYou.SR.ID);
  end;
end;

function TFImport.HashRecord(Song: PSongRecord) : integer;
var bytePtr : PByte;
    S : string;
    i, iTotal : integer;
begin
  S := Song.Title     + Song.AltTitle + Song.Author   + Song.CopDate  +
       Song.CopyRight + Song.OfficeNo + Song.Photo    + Song.MusBook  +
       Song.Tune      + Song.Arr      + Song.ISBN     + Song.cl1      +
       Song.cl2       + Song.Notes    + Song.UniqueID +
       IntToStr(Song.Key)  + IntToStr(Song.MM) +
       IntToStr(Song.Capo) + IntToStr(Song.Tempo);
  bytePtr := PByte(S);
  iTotal  := 0;
  for i := 0 to Length(S) do begin
    iTotal := (iTotal + bytePtr^) mod $7FFFFFFF;
    inc(bytePtr);
  end;
  HashRecord := iTotal;
end;}

procedure TFImport.BCancelClick(Sender: TObject);
begin
  close;
end;

{procedure TFImport.MergeFiles( hList : TListView; FromFile, ToFile : string );
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
end;
 }
  {
  for i:=0 to ListMe.Items.Count-1 do
  begin
    if ListMe.Items[i].Checked then begin
      OldID:=copy(SLEx.Strings[i],pos('  """',SLEx.Strings[i])+5,length(SLex.Strings[i]));
      ti:=copy(SLEx.Strings[i],1,pos('  """',Slex.Strings[i])-5);
      str(FirstId,NewID);
      OpenForRead(TF,MyFile);
      repeat
        readln(TF,S);
        DeLimit(s,SR);
      until SR.ID=OldID;
      if not CBLinks.Checked then SR.Links:='';
      CloseTextfile(TF,MyFile);
      IgnoreMe:=false;
      if (IgnoreDup.Checked) then begin
        OpenforRead(TF,RemoteFile);
        while (not eof(TF)) and (not IgnoreMe) do begin
          readln(TF,S);
          DeLimit(s,SR2);
          if FSongbase.squash(SR2.Title)=FSongbase.squash(SR.Title) then IgnoreMe:=true;
        end;
        CloseTextfile(TF,RemoteFile);
      end;
      if not IgnoreMe then begin
        // Sort out multimedia links
        if (not CBLinks.Checked) then SR.Links:='';
        NewLinks:='';
        lcount:=0;
        if (pos(chr129,SR.Links)>0) then SR.Links:=copy(SR.Links,pos(chr129,SR.Links)+1,length(SR.Links));
        while (pos(chr129,SR.Links)>0) do begin
          d1:=copy(SR.Links,1,pos(chr129,SR.Links)-1);
          SR.Links:=copy(SR.Links,pos(chr129,SR.Links)+1,length(SR.Links));
          if pos(chr129,SR.Links)>0 then f1:=copy(SR.Links,1,pos(chr129,SR.Links)-1) else f1:=SR.Links;
          SR.Links:=copy(SR.Links,pos(chr129,SR.Links)+1,length(SR.Links));
          ExtractFileFromZip(OHPFile,f1,TempDir);
          k:=length(f1);
          ext:='';
          while (f1[k]<>'.') do begin
            ext:=f1[k]+ext;
            dec(k);
          end;
          inc(lcount);
          str(lcount,f2);
          f2:=NewID+'-'+f2+'.'+ext;
          NewLinks:=NewLinks+d1+chr129+f2+chr129;
          Renamefile(TempDir+f1,TempDir+f2);
          AddFileToZip(TempDir+f2,RemOHP,true);
        end;
        str(lcount+1,SR.Links);
        SR.Links:=SR.Links+chr129+NewLinks;
        SR.ID:=NewID;
        Limit(S2,SR);
        OpenForRead(TF,RemoteFile);
        OpenForWrite(TG,TempDir+'temp.tmp');
        Written:=false;
        while not eof(TF) do begin
          readln(TF,S);
          if (not FSongbase.before(S,S2)) and not Written then begin writeln(TG,S2); Written:=true; end;
          writeln(TG,S);
        end;
        if not Written then writeln(TG,S2);
        CloseTextfile(TF,RemoteFile);
        CloseTextfile(TG,TempDir+'temp.tmp');
        erase(TF);
        rename(TG,RemoteFile);
        ExtractFileFromZip(OHPFile,OldID+'.ohp',TempDir);
        renamefile(TempDir+OldID+'.ohp',TempDir+newID+'.ohp');
        if fileexists(TempDir+newID+'.ohp') then begin
          OpenForRead(TF,TempDir+newID+'.ohp');
          readln(TF,S);
          CloseTextfile(TF,TempDir+newID+'.ohp');
          val(S,V,Code);
          for j:=1 to v do begin
            str(j,S);
            ExtractFileFromZip(OHPFile,OldID+'-'+S+'.rtf',TempDir);
            RenameFile(TempDir+OldID+'-'+S+'.rtf',TempDir+NewID+'-'+S+'.rtf');
          end;
          AddFileToZip(TempDir+NewID+'.ohp',RemOHP,true);
          for k:=1 to v do begin
            str(k,s);
            AddFileToZip(TempDir+NewID+'-'+S+'.rtf',RemOHP,true);
          end;
          UpdateFsH(NewID, RemOHP, RemFSH);
        end;
        inc(FirstID);
      end;
  end;

  OpenForRead(TF,MyFile);
  FirstID:=1;
  while not eof(TF) do begin
    readln(TF,S);
    DeLimit(s,SR);
    val(SR.ID,V,Code);
    if V>=FirstId then FirstId:=V+1;
  end;
  CloseTextfile(TF,MyFile);

  for i:=0 to LBImp.Items.Count-1 do begin
    LBImp.ItemIndex:=i;
    LBImp.Update;
    OldID:=copy(SLImp.Strings[i],pos('  """',SLImp.Strings[i])+5,length(SLImp.Strings[i]));
    OpenForRead(TF,MyFile);
    ti:=copy(SLImp.Strings[i],1,pos('  """',SLImp.Strings[i])-5);
    repeat
      if not eof(TF) then readln(TF,S);
      DeLimit(s,SR);
    until (SR.Title=Ti) or (eof(TF));
    CloseTextfile(TF,MyFile);
    if (FSongbase.squash(Ti)<>FSongbase.squash(SR.Title)) or (not IgnoreDup.Checked) then begin
      str(FirstId,NewID);
      OpenForRead(TF,RemoteFile);
      repeat
        readln(TF,S);
        DeLimit(s,SR);
      until SR.ID=OldID;
      CloseTextfile(TF,RemoteFile);

      // Sort out multimedia links
      if (not CBLinks.Checked) then SR.Links:='';
      NewLinks:='';
      lcount:=0;
      if (pos(chr129,SR.Links)>0) then SR.Links:=copy(SR.Links,pos(chr129,SR.Links)+1,length(SR.Links));
      while (pos(chr129,SR.Links)>0) do begin
        d1:=copy(SR.Links,1,pos(chr129,SR.Links)-1);
        SR.Links:=copy(SR.Links,pos(chr129,SR.Links)+1,length(SR.Links));
        if pos(chr129,SR.Links)>0 then f1:=copy(SR.Links,1,pos(chr129,SR.Links)-1) else f1:=SR.Links;
        SR.Links:=copy(SR.Links,pos(chr129,SR.Links)+1,length(SR.Links));
        ExtractFileFromZip(RemOHP,f1,TempDir);
        k:=length(f1);
        ext:='';
        while (f1[k]<>'.') do begin
          ext:=f1[k]+ext;
          dec(k);
        end;
        inc(lcount);
        str(lcount,f2);
        f2:=NewID+'-'+f2+'.'+ext;
        NewLinks:=NewLinks+d1+chr129+f2+chr129;
        Renamefile(TempDir+f1,TempDir+f2);
        AddFileToZip(TempDir+f2,OHPFile,true);
      end;
      str(lcount+1,SR.Links);
      SR.Links:=SR.Links+chr129+NewLinks;
      SR.ID:=NewID;
      Limit(S2,SR);
      OpenForRead(TF,MyFile);
      OpenForWrite(TG,TempDir+'temp.tmp');
      Written:=false;
      while not eof(TF) do begin
        readln(TF,S);
        if (not FSongbase.before(S,S2)) and not Written then begin writeln(TG,S2); Written:=true; end;
        writeln(TG,S);
      end;
      if not Written then writeln(TG,S2);
      CloseTextfile(TF,MyFile);
      CloseTextfile(TG,TempDir+'temp.tmp');
      erase(TF);
      rename(TG,MyFile);
      ExtractFileFromZip(RemOHP,OldID+'.ohp',TempDir);
      renamefile(TempDir+OldID+'.ohp',TempDir+newID+'.ohp');
      if FileExists(TempDir+newID+'.ohp') then begin
        OpenForRead(TF,TempDir+newID+'.ohp');
        readln(TF,S);
        CloseTextfile(TF,TempDir+newID+'.ohp');
        val(S,V,Code);
        for j:=1 to v do begin
          str(j,S);
          ExtractFileFromZip(RemOHP,OldID+'-'+S+'.rtf',TempDir);
          RenameFile(TempDir+OldID+'-'+S+'.rtf',TempDir+NewID+'-'+S+'.rtf');
        end;
        AddFileToZip(TempDir+newID+'.ohp',OHPFile,true);
        for j:=1 to v do begin
          str(j,s);
          AddFiletoZip(TempDir+NewID+'-'+S+'.rtf',OHPFile,true);
        end;
        UpdateFsH(NewID, OHPFile, MyFSH);
      end;
      inc(FirstID);
    end;
  end;
  close;
end;}

procedure TFImport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  posX:=left;
  posY:=top;
  SLImp.free;
  SLEx.free;
  SLRemote.free;
  SLCurrent.free;
end;

procedure TFImport.lvFileListColumnClick(Sender: TObject; Column: TListColumn);
var i,j, state : integer;
const SortStateOrdered : array[0..3] of integer = ( SONGSTATE_NEW, SONGSTATE_NEWER,
                                                    SONGSTATE_SAME, SONGSTATE_OLDER );
begin
  if Column.Index = SortColumn then begin
    SortAsc := not SortAsc
  end else begin
    SortAsc    := true;
    SortColumn := Column.Index;
  end;

  if 0 = SortColumn then begin
    if SortAsc then begin
      for i := 0 to RecordCount-1 do begin
        SortedIdxs[i] := i;
      end;
    end else begin
      for i := 0 to RecordCount-1 do begin
        SortedIdxs[i] := (RecordCount-1) - i;
      end;
    end;
  end else begin
    // Sort by state
    j := 0;
    for state := 0 to 3 do begin
      for i := 0 to RecordCount-1 do begin
        if (States[i] = SortStateOrdered[state]) then begin
          SortedIdxs[j] := i;
          inc( j );
        end;
      end;
    end;

    // Reverse if it's not ascending
    if not SortAsc then begin
      for i := 0 to (RecordCount-1) div 2 do begin
        j := SortedIdxs[(RecordCount-1)-i];
        SortedIdxs[(RecordCount-1)-i] := SortedIdxs[i];
        SortedIdxs[i] := j;
      end;
    end;
  end;

  lvFileList.Invalidate;
end;


procedure TFImport.ListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var hItem  : TListItem;
    hHit   : THitTests;
    i      : integer;
    hList  : TListView;
begin
  hList := Sender as TListView;
  hItem := hList.GetItemAt(x, y);
   if (hItem <> nil) then begin
    hHit := hList.GetHitTestInfoAt(x, y);
    if hHit = [htOnIcon] then begin
      i := SortedIdxs[hItem.Index];
      CheckedItems[i] := not CheckedItems[i];
      if CheckedItems[i] then inc( CheckedCount )
                         else dec( CheckedCount );
      lvFileList.UpdateItems(hItem.Index, hItem.Index);
      BImport.Enabled := ( CheckedCount > 0 );
    end;
  end;
end;


procedure TFImport.BImportClick(Sender: TObject);
var i, j, iID : integer;
    sOldID, sNewID, sPages : string;
    hOHPFileList : TStringList;
    hSRList : TList;
    bResult : boolean;
    bAdded  : boolean;
    sTempSDB, sTempOHP, sRTFFile : string;
    sLine,    sOHPText : string;
    F, FSDB : TextFile;
    eErr, iPageCount, iCode : integer;
    pSR : PSongRecord;
begin
  hOHPFileList  := TStringList.Create();
  hSRList       := TObjectList.Create();

  FInfoBox.ShowBox( Self, 'Merging files... please wait...' );

  // Read in the current SDB file
  bResult := OpenForRead( FSDB, FileName );
  if bResult then begin
    while not Eof(FSDB) do begin
      readln( FSDB, sLine );
      New(pSR);
      DeLimit( sLine, pSR^ );
      hSRList.Add( pSR );
    end;
    CloseFile( FSDB );
  end;

  // Now work through the checked items and update the data
  iID     := 1;
  bResult := true;
  for i := 0 to RecordCount-1 do begin
    if CheckedItems[i] then begin
      sOldID := SRs[i].ID;

      if cbDuplicates.Checked or (States[i] = SONGSTATE_NEW) then begin
        iId    := PageCache_GetNextFreeSongID(iId);
        sNewID := IntToStr( iId );
      end else begin
        sNewID := PageCache_GetIDForSBTitle( SRs[i].Title );
      end;

      // Get the OHP file from the Import file
      if GetFileDataFromZip( OHPInFile, sOldID + '.ohp', sOHPText, true ) then
      begin
        // Save it in the temp directory
        sTempOHP := TempDir + sNewID + '.ohp';
        bResult  := OpenForWrite( F, sTempOHP );
        if bResult then begin
          write( F, sOHPText );
          closefile(F);
          hOHPFileList.Add( sTempOHP );
        end;
      end else bResult := false;

      // Handle the result
      if not bResult then break;

      // Get the number of pages
      sPages := GetStrLine( sOHPText );
      val( sPages, iPageCount, iCode );

      // Iterate through the page count and copy the items
      for j := 1 to iPageCount do
      begin
        if GetFileDataFromZip( OHPInFile, sOldID +'-'+ IntToStr(j) +'.rtf', sOHPText, false ) then
        begin
          // Save it in the temp directory
          sRTFFile := TempDir + sNewID +'-'+ IntToStr(j) +'.rtf';
          assignfile(F, sRTFFile );
          rewrite(F);
          eErr := IOResult;
          if 0 = eErr then begin
            write( F, sOHPText );
            closefile(F);
            hOHPFileList.Add( sRTFFile );
          end
          else bResult := false;
        end else bResult := false;
        if not bResult then break;
      end;

      // Now, find where in the SDB data this inserts
      bAdded := false;
      for j := 0 to hSRList.Count-1 do begin
        pSR := hSRList.Items[j];

        // If it's the same song, then either replace it or insert after it
        if FSongbase.squash( pSR.Title ) = FSongbase.squash( SRs[i].Title ) then begin
          SRs[i].Id := sNewID;
          if cbDuplicates.Checked then begin
            new(pSR);
            pSR^ := SRs[i];
            hSRList.Insert( j, pSR );
          end else begin
            pSR  := hSRList.Items[j];
            pSR^ := SRs[i];
          end;
          bAdded := true;
          break;
        end;

        // Otherwise, if it should have already been inserted, then
        // there's no existing entry and we should insert it here.
        if FSongbase.before( SRs[i].Title, pSR.Title ) then begin
          SRs[i].ID := sNewID;
          new(pSR);
          pSR^ := SRs[i];
          hSRList.Insert( j, pSR );
          bAdded := true;
          break;
        end;
      end;

      // If it's not added yet, add it
      if not bAdded then begin
        SRs[i].Id := sNewID;
        new(pSR);
        pSR^ := SRs[i];
        hSRList.Insert( j, pSR );
      end;

      // Select the next id.
      inc( iId );
      if not bResult then break;
    end;
  end;

  // Rewrite the SDB now
  if bResult then begin
    sTempSDB := TempDir + 'temp.sdb';
    bResult := OpenForWrite( FSDB, sTempSDB );
    if bResult then begin
      for i := 0 to hSRList.Count-1 do begin
        pSR := hSRList.Items[i];
        Limit( sLine, pSR^ );
        writeln( FSDB, sLine );
      end;
      CloseFile( FSDB );
    end;
  end;

  // Add the pages...
  if bResult and (hOHPFileList.Count > 0) then begin
    AddFilesToZip( hOHPFileList, OHPFile, true );
  end;

  // Finally, rename the Temp SDB file.
  if bResult then begin
    if FileExists( FileName + '.bak' ) then DeleteFile( FileName + '.bak' );
    RenameFile( FileName, FileName + '.bak' );
    RenameFile( sTempSDB, FileName );
  end;


  // Finally, close it.
  FInfoBox.Close;
  Close;

  // And force a reload of the catalogue
  FSongbase.TryOpen(FSongbase);
end;

procedure TFImport.FormShow(Sender: TObject);
var sInfoMsg, sLine : string;
    FSDB       : TextFile;
    SR         : SongRecord;
    i          : integer;
begin
  MyFileChanged := false;

  // Open the info box
  sInfoMsg := 'Loading...';
  FInfoBox.ShowBox( Self, sInfoMsg );
  FInfoBox.Refresh;
  BImport.Enabled := false;

  // Open the SDB file for import and catalogue it
  if false = OpenForRead( FSDB, SDBInFile ) then begin
    Exit;
  end;
  LMe.Caption := SDBInFile;

  // Read all the items in the file
  i := 0;
  while not Eof(FSDB) do begin
    readln(FSDB,sLine);
    DeLimit(sLine,SR);

    // See if there's already a matching song in the current database
    inc( i );
    SetLength( SRs,        i );
    SetLength( States,     i );

    States[i-1] := PageCache_FindImportSongState( OHPInFile, SR );
    SRs[i-1]    := SR;

    // Update the box
    if 0 = i mod 10 then begin
      FInfoBox.Label1.Caption := sInfoMsg + ' (read ' + IntToStr(i) + ')';
      FInfoBox.Refresh;
    end;
  end;

  // Set the number of rows to the items read
  SetLength( CheckedItems, 0 );
  SetLength( CheckedItems, i );
  SetLength( SortedIdxs,   i );
  lvFileList.Items.Count := i;
  RecordCount            := i;

  if 1 = i then begin
    CheckedItems[0] := true;
    BImport.Enabled := true;
  end;

  // Set the sort order
  SortColumn := 0;
  SortAsc    := true;
  for i := 0 to RecordCount-1 do begin
    SortedIdxs[i] := i;
  end;

  FInfoBox.Close;
end;

{  iCurrentIdx := 0;
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
          for iPage := 1 to hEntry.iPageCount do begin
            pPage := @hEntry.aPages[iPage-1];

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

end;               }

procedure TFImport.lvFileListData(Sender: TObject; Item: TListItem);
var i : integer;
begin
  // on data
  if Item.Index <= RecordCount then begin
    i := SortedIdxs[Item.Index];
    Item.ImageIndex := Ord( CheckedItems[i] );
    Item.Caption    := SRs[i].Title;
    Item.Data       := PChar(SRs[i].Id);
    Item.SubItems.Add( SongStates[States[i]] );
  end;
end;

function SortListItemsByName(Item1, Item2: Pointer): Integer;
var hItem1, hItem2 : TListItem;
begin
  hItem1 := Item1;
  hItem2 := Item2;
  if hItem1.Caption = hItem2.Caption then SortListItemsByName := 0
  else if FSongbase.before(hItem1.Caption,hItem2.Caption) then SortListItemsByName := -1
                                                          else SortListItemsByName :=  1;
end;


// ALL -------------------------------------------------------------------------

procedure TFImport.BAllAllClick(Sender: TObject);
var iIdx: integer;
begin
  for iIdx := 0 to RecordCount-1 do begin
    CheckedItems[iIdx] := true;
  end;
  CheckedCount := RecordCount;
  lvFileList.Invalidate;
  BImport.Enabled := true;
end;

procedure TFImport.BNoneClick(Sender: TObject);
var iIdx : integer;
begin
  for iIdx := 0 to RecordCount-1 do begin
    CheckedItems[iIdx] := false;
  end;
  CheckedCount := 0;
  lvFileList.Invalidate;
  BImport.Enabled := false;
end;


// NEW ------------------------------------------------------------------------

procedure TFImport.BChangedAllClick(Sender: TObject);
var iIdx, iCount: integer;
begin
  iCount := 0;
  for iIdx := 0 to RecordCount-1 do begin
    if (States[iIdx] = SONGSTATE_NEW)   or
       (States[iIdx] = SONGSTATE_NEWER) then CheckedItems[iIdx] := true;
    if CheckedItems[iIdx] then inc(iCount);
  end;
  CheckedCount := iCount;
  lvFileList.Invalidate;
  BImport.Enabled := ( iCount > 0 );
end;


// NEWER -----------------------------------------------------------------------

procedure TFImport.BNewAllClick(Sender: TObject);
var iIdx, iCount: integer;
begin
  iCount := 0;
  for iIdx := 0 to RecordCount-1 do begin
    if States[iIdx] = SONGSTATE_NEW then CheckedItems[iIdx] := true;
    if CheckedItems[iIdx] then inc(iCount);
  end;
  CheckedCount := iCount;
  lvFileList.Invalidate;
  BImport.Enabled := ( iCount > 0 );
end;

end.

