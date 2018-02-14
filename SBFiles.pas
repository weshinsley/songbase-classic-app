unit SBFiles;

interface
uses Types;

  type ShortcutArray = array[1..200] of word;

  type SongRecord = record
    Title,AltTitle,Author,CopDate,CopyRight,OfficeNo,OHP,Sheet,
    Trans,Rec,Photo,MusBook,Tune,Arr,ISBN,Id,cl1,cl2,Notes,Links,
    UniqueID : string;
    Key,MM,Capo,Tempo : shortint
  end;

  type PSongRecord = ^SongRecord;

  function  OpenForWrite(var F : TextFile; S : string) : boolean;
  function  OpenForRead(var F : TextFile; S : string) : boolean;
  function  OpenForAppend(var F : TextFile; S : string) : boolean;
  function  WriteEmptyZip(S : string) : boolean;
  procedure CloseTextfile(var F : TextFile; sFilename : string = '' );

  procedure UpdateFsH(wGID : string; TheOHPFile : string; FSHFile : String);
  procedure DeLimit(s2 : string; var SR : SongRecord );
  procedure QuickDelim(s2 : string; var Title,AltTitle,ID : string);
  procedure Limit(var s : string; SR : SongRecord);
  function FastString(TheOHPFile : string; cID : string) : string;
  function CapNoPunc(S : string) : string;
  procedure OverwriteOrder(OrigOrder : string; OrdFile : string; S : string);
  procedure ReadParams(ini : string);
  procedure SaveParams(ini : string);
  procedure DeAmp(var S : string);
  procedure FileCopy( Const sourcefilename, targetfilename: String );
  procedure LogThis( sText : string );
  function  GetStrLine( var sText : string ) : string;
  function  stripCommas(s : string ) : string;
  procedure writeCCLIInfo(var TF : TextFile);
  function  RectsEqual( hA, hB : TRect ) : boolean;
  function  GetTempDirectory: String;
  procedure processRectStr( sStr : string; var rRect : TRect );
  function  RectToStr( rRect : TRect ) : string;

  type TNumber = class(TObject)
    public
      iIdx : integer;
      constructor Create( iI : integer );
    end;

  implementation
  uses SBZipUtils, Controls, ComCtrls, Classes, SBMain, SysUtils, Dialogs, EditProj, Tools,Appear,
       TitleSearch, Search, Import, Export, PrintSelect, PrintSongList, LinkForm, LinkDesc, FileCtrl,
       StrUtils, OHPPrint, About, Graphics, Menus, PreviewWindow, SearchResults, SongDetails,
       FontConfig, PageCache, Math, Windows, NetSetup;

function GetStrLine( var sText : string ) : string;
var iPos, iLen : integer;
begin
  iPos := 1;
  iLen := Length(sText);
  while (iPos <= iLen) and (Ord(sText[iPos]) <> 10) and (Ord(sText[iPos])<>13) do inc(iPos);
  GetStrLine := LeftStr( sText, iPos-1 );
  while (iPos <= iLen) and ((Ord(sText[iPos]) = 10) or  (Ord(sText[iPos])=13)) do inc(iPos);
  Delete( sText, 1, iPos-1 );
end;


{$IOCHECKS OFF}
function OpenForWrite(var F : TextFile; S : string) : boolean;
var eErr : integer;
begin
  LogThis( 'Opening File('+ S +') for writing' );
  assignfile(F,S);
  rewrite(F);
  eErr := IOResult;
  if 0 = eErr then begin
    writeln(F,'!SB!200');
    LogThis( 'File '+ S +' opened' );
    OpenForWrite := true;
  end else begin
    LogThis( 'ERROR: Opening '+S+' - ' + SysErrorMessage(eErr) );
    OpenForWrite := false;
  end;
end;

function OpenForAppend(var F : Textfile; S : string) : boolean;
var eErr : integer;
begin
  LogThis( 'Opening File('+ S +') for appending' );
  assignfile(F,S);
  append(F);
  eErr := IOResult;
  if 0 = eErr then begin
    LogThis( 'File '+ S +' opened' );
    OpenForAppend := true;
  end else begin
    LogThis( 'ERROR: Opening '+S+' - ' + SysErrorMessage(eErr) );
    OpenForAppend := false;
  end;
end;

function OpenForRead(var F : TextFile; S : string) : boolean;
var s2 : string;
    eErr : integer;
begin
  if not fileexists(S) then begin
    messagedlg('File "'+ S +'" not found',mtError,[mbOk],0);
    OpenForRead := false;
  end else begin
    LogThis( 'Opening File ('+ S +') for reading' );
    assignfile(F,S);
    reset(F);
    eErr := IOResult;
    if 0 = eErr then begin
      readln(F,S2);
      if (copy(S2,1,4)<>'!SB!') and (copy(S2,1,4)<>'SDB2') then begin  {Legacy}
        CloseTextfile(F);
        reset(F);
      end else if (length(S2)>4) and (copy(S2,5,3)<>'200') then begin
        messagedlg('Songbase version problem reading '+S2,mtError,[mbOk],0);
      end;
      LogThis( 'File '+ S +' opened' );
      OpenForRead := true;
    end else begin
      LogThis( 'ERROR: Opening '+S+' - ' + SysErrorMessage(eErr) );
      OpenForRead := false;
    end;
  end;
end;

function WriteEmptyZip(S : string) : boolean;
var F : File;
    O : array[1..22] of char;
    I : byte;
    eErr : integer;
begin
  assignfile(F,S);
  rewrite(F,1);
  eErr := IOResult;
  if 0 = eErr then begin
    O[1]:='P'; O[2]:='K';
    O[3]:=chr(5); O[4]:=chr(6);
    for i:=5 to 22 do O[i]:=chr(0);
    blockwrite(F,O,22);
    closefile(F);
    LogThis( 'Opened Empty Zip '+S );
    WriteEmptyZip := true;
  end else begin
    LogThis( 'ERROR: Creating Empty Zip '+S+' - ' + SysErrorMessage(eErr) );
    WriteEmptyZip := false;
  end;
end;

{$IOCHECKS ON}


procedure CloseTextfile(var F : TextFile; sFilename : string = '' );
begin
  if sFilename <> '' then sFilename := ' ('+ sFilename +')';
  LogThis( 'Closing File Handle'+sFilename );
  CloseFile(F);
end;

procedure UpdateFsH(wGID : string; TheOHPFile : string; FSHFile : String);
var SCH,OSCH : Textfile;
    FsID,FS : string;
    JustWritten : boolean;
begin
  LogThis( 'Updating Fast Search index: ' + FSHFile );
  if not OpenForRead(SCH,FSHFile) then Exit;
  if not OpenForWrite(OSCH,TempDir+'temp.fsh') then begin CloseTextfile(SCH,FSHFile); Exit; end;
  JustWritten:=false;
  while (not eof(SCH)) do begin
    readln(SCH,FS);
    FsID:=copy(FS,1,pos('~',FS)-1);
    if (FsID=wGID) then begin
      JustWritten:=true;
      writeln(OSCH,FsID+'~'+FastString(TheOHPFile,wGID));
    end else writeln(OSCH,FS);
  end;
  if not JustWritten then writeln(OSCH,wGID+'~'+FastString(TheOHPFile,wGID));
  CloseTextfile(SCH,FSHFile);
  CloseTextfile(OSCH,TempDir+'temp.fsh');
  erase(SCH);
  rename(OSCH,FSHFile);
  PageCache_FlushQuick;
  LogThis( 'Fast Search index updated' );
end;

function FastString(TheOHPFile : string; cID : string) : string;
var OutS : string;
    Pages,i,j : integer;
begin
  Pages := PageCache_GetPageCount( cID );
  if Pages > 0 then begin
    for i := 1 to Pages do begin
      PageCache_LoadRTF( FEditWin.RESong, cID, i );
      for j := 0 to FEditWin.RESong.Lines.Count-1 do begin
        OutS := OutS + CapNoPunc( FEditWin.RESong.Lines.Strings[j] );
      end;
    end;
  end;
  FEditWin.RESong.Clear;
  FastString:=OutS;
end;

function CapNoPunc(S : string) : string;
const Allow : string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var S2 : string;
    i : integer;
begin
  S2:='';
  for i:=1 to length(S) do
    if pos(uppercase(S[i]),Allow)>0 then S2:=S2+uppercase(S[i]);
  CapNoPunc:=S2;
end;

procedure OverwriteOrder(OrigOrder : string; OrdFile : string; S : string);
var TF,GF : TextFile;
    D : string;
begin
  LogThis( 'Writing order file ''' + OrdFile + '''' );
  if not OpenForRead(TF,OrdFile)   then Exit;
  if not OpenForWrite(GF,TempDir+'potato') then begin CloseTextfile(TF,OrdFile); Exit; end;
  while not eof(TF) do begin
    readln(TF,D);
    writeln(GF,D);
    if D<>OrigOrderName then begin
      readln(TF,D); writeln(GF,D);
    end else begin
      readln(TF,D); writeln(GF,S);
    end;
  end;
  flush(GF);
  CloseTextfile(GF,TempDir+'potato');
  CloseTextfile(TF,OrdFile);
  erase(TF);
  rename(GF,OrdFile);
  LogThis( 'Order file written' );
end;

procedure QuickDeLim(s2 : string; var Title,AltTitle,ID: string);
var s : string;
    i : byte;
begin
  s:=s2;
  Title:=copy(S,1,pos('~',S)-1);
  AltTitle:='';
  if pos(chr128,Title)<>0 then begin
    AltTitle:=copy(title,pos(chr128,title)+1,length(title));
    title:=copy(title,1,pos(chr128,title)-1);
  end;
  for i:=1 to 10 do S:=copy(S,pos('~',S)+1,length(S));
  ID:=copy(S,1,pos('~',S)-1);
end;


procedure DeLimit(s2 : string; var SR : SongRecord);
var s,test : string;
  begin
    s:=s2;
    SR.Title:=copy(S,1,pos('~',S)-1);
    SR.AltTitle:='';
    if pos(chr128,SR.Title)<>0 then begin
      SR.AltTitle:=copy(SR.title,pos(chr128,SR.title)+1,length(SR.title));
      SR.title:=copy(SR.title,1,pos(chr128,SR.title)-1);
    end;
    S:=copy(S,pos('~',S)+1,length(S));
    SR.Author:=copy(S,1,pos('~',S)-1);
    S:=copy(S,pos('~',S)+1,length(S));
    SR.CopDate:=copy(S,1,pos('~',S)-1);
    S:=copy(S,pos('~',S)+1,length(S));
    SR.Copyright:=copy(S,1,pos('~',S)-1);
    S:=copy(S,pos('~',S)+1,length(S));
    SR.UniqueID:='';
    SR.OfficeNo:=copy(S,1,pos('~',S)-1);
    if (pos(chr128,SR.OfficeNo)>0) then begin
      SR.officeNo:=copy(SR.OfficeNo,pos(chr128,SR.OfficeNo)+1,length(SR.OfficeNo));
      SR.UniqueID:=copy(SR.OfficeNo,1,pos(chr128,SR.OfficeNo)-1);
    end;
    S:=copy(S,pos('~',S)+1,length(S));
    Test:=copy(S,1,pos('~',S)-1);
    while length(Test)<5 do Test:=Test+'0';
    SR.OHP:=Test[1];
    SR.Sheet:=Test[2];
    SR.Rec:=Test[3];
    SR.Photo:=Test[4];
    SR.Trans:=Test[5];
    SR.Links:='';
    if length(Test)>5 then SR.Links:=copy(Test,6,length(Test));
    S:=copy(S,pos('~',S)+1,length(S));
    SR.MusBook:=copy(S,1,pos('~',S)-1);
    S:=copy(S,pos('~',S)+1,length(S));
    SR.ISBN:=copy(S,1,pos('~',S)-1);
    S:=copy(S,pos('~',S)+1,length(S));
    SR.Tune:=copy(S,1,pos('~',S)-1);
    S:=copy(S,pos('~',S)+1,length(S));
    SR.Arr:=copy(S,1,pos('~',S)-1);
    S:=copy(S,pos('~',S)+1,length(S));
    SR.ID:=copy(S,1,pos('~',S)-1);
    S:=copy(S,pos('~',S)+1,length(S));
    SR.MM:=0;
    if (ord(S[1])>=78) then begin SR.MM:=1; S[1]:=chr(ord(S[1])-14); end
    else if (ord(S[1])<64) then begin SR.MM:=-1; S[1]:=chr(ord(S[1])+14); end;

    SR.Key:=ord(S[1])-65;
    SR.Capo:=ord(S[2])-65;
    SR.Tempo:=ord(S[3])-65; S:=copy(S,4,length(S));
    SR.CL1:=copy(S,1,pos('~',S)-1);
    S:=copy(S,pos('~',S)+1,length(S));
    SR.CL2:=copy(S,1,pos('~',S)-1);
    S:=copy(S,pos('~',S)+1,length(S));
    SR.Notes:=S;
  end;

procedure Limit(var s : string; SR : SongRecord);
begin
  S:=SR.Title+chr128+SR.AltTitle+'~'+SR.Author+'~'+SR.CopDate+'~'+SR.CopyRight+'~'+SR.UniqueID+chr128+SR.OfficeNo+'~'+SR.OHP+SR.Sheet+SR.Rec+SR.Photo+SR.Trans+SR.Links+'~'+SR.MusBook+'~'+SR.ISBN+'~'+SR.Tune+'~'+SR.Arr+'~'+SR.ID+'~';
  S:=S+chr(65+SR.Key+(14*SR.MM))+chr(65+SR.Capo)+chr(65+SR.Tempo)+SR.Cl1+'~'+SR.Cl2+'~'+SR.Notes;
end;

procedure DeAmp(var S : string);
begin
  while pos('&',S)<>0 do S:=copy(S,1,pos('&',S)-1)+copy(S,pos('&',S)+1,length(S));
end;


procedure SaveParams(ini : string);
var S : string;
    TF : Textfile;
    i: integer;
begin
  LogThis( 'Writing options file: ' + ini );
  if not OpenForWrite(TF,INI) then Exit;
  writeln(TF,'Global_Font = '+FSettings.PrimaryFont.Name);
  str(FSettings.PrimaryFont.Size,S); writeln(TF,'Global_Size = '+S);
  str(FSongbase.left,S); writeln(TF,'Screen_X = '+S);
  str(FSongbase.top,S); writeln(TF,'Screen_Y = '+S);
  str(FSongbase.szDisplaySize.cx,S); writeln(TF, 'Display_W = '+S);
  str(FSongbase.szDisplaySize.cy,S); writeln(TF, 'Display_H = '+S);
  str(FPreviewWindow.left,S); writeln(TF,'Preview_X = '+S);
  str(FPreviewWindow.top,S); writeln(TF,'Preview_Y = '+S);
  str(FSongBase.szPreviewSize.cx,S); writeln(TF,'Preview_W = '+S);
  str(FSongBase.szPreviewSize.cy,S); writeln(TF,'Preview_H = '+S);
  str(FLiveWindow.left,S); writeln(TF,'LiveWin_X = '+S);
  str(FLiveWindow.top,S); writeln(TF,'LiveWin_Y = '+S);
  str(FSongBase.szLiveSize.cx,S); writeln(TF,'LiveWin_W = '+S);
  str(FSongBase.szLiveSize.cy,S); writeln(TF,'LiveWin_H = '+S);
  str(FSearchResults.Left,S); writeln(TF, 'SearchResults_X = '+S);
  str(FSearchResults.Top ,S); writeln(TF, 'SearchResults_Y = '+S);
  str(FTitle.posX,S); writeln(TF,'Title_X = '+S);
  str(FTitle.posY,S); writeln(TF,'Title_Y = '+S);
  str(FSearch.posX,S); writeln(TF,'Search_X = '+S);
  str(FSearch.posY,S); writeln(TF,'Search_Y = '+S);
  str(FImport.posX,S); writeln(TF,'Import_X = '+S);
  str(FImport.posY,S); writeln(TF,'Import_Y = '+S);
  str(FExport.posX,S); writeln(TF,'Export_X = '+S);
  str(FExport.posY,S); writeln(TF,'Export_Y = '+S);
  str(FPrintSelect.posX,S); writeln(TF,'PrnSel_X = '+S);
  str(FPrintSelect.posY,S); writeln(TF,'PrnSel_Y = '+S);
  str(FPSong.posX,S); writeln(TF,'FPSong_X = '+S);
  str(FPSong.posY,S); writeln(TF,'FPSong_Y = '+S);
  str(FLinkDesc.posX,S); writeln(TF,'FLDes_X = '+S);
  str(FLinkDesc.posY,S); writeln(TF,'FLDes_Y = '+S);
  str(FLinkForm.posX,S); writeln(TF,'FLink_X = '+S);
  str(FLinkForm.posY,S); writeln(TF,'FLink_Y = '+S);
  str(FPOhp.posX,S); writeln(TF,'FPOhp_X = '+S);
  str(FPOhp.posY,S); writeln(TF,'FPOhp_Y = '+S);
  str(FSettings.posX,S); writeln(TF,'FGlob_X = '+S);
  str(FSettings.posY,S); writeln(TF,'FGlob_Y = '+S);
  str(FAbout.posX,S); writeln(TF,'FAbout_X = '+S);
  str(FAbout.posY,S); writeln(TF,'FAbout_Y = '+S);
  str(FSongDetails.posX,S); writeln(TF,'FSDetails_X = '+S);
  str(FSongDetails.posY,S); writeln(TF,'FSDetails_Y = '+S);
  writeln( TF, 'LicenseNo = ' + FSettings.ELicense.Text );

  S:='Global_Bold = ';   if FSettings.PrimaryFont.Bold   then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  S:='Global_Italic = '; if FSettings.PrimaryFont.Italic then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  str(FSettings.PrimaryFont.Color,S); S:='Global_FColour = '+S; writeln(TF,S);
  str(FSettings.PColB.Color,      S); S:='Global_BColour = '+S; writeln(TF,S);
  str(FSettings.PShadowCol.Color, S); S:='Global_Shadow = '+S; writeln(TF,S);

  writeln( TF, 'Global Area = ' + IntToStr( FSongbase.rTextArea.Left  ) +', '+
                                  IntToStr( FSongbase.rTextArea.Top   ) +', '+
                                  IntToStr( FSongbase.rTextArea.Right ) +', '+
                                  IntToStr( FSongbase.rTextArea.Bottom) );

  writeln(TF,'Net_Local_IP = '+FNetSetup.LocalIP);
  writeln(TF,'Net_Port = '+FNetSetup.Port);
  if (FNetSetup.Enabled) then writeln(TF,'Net_Enable = 1') else writeln(TF,'Net_Enable = 0');

  if (FNetSetup.CheckList.Count>0) then begin
    for i:=0 to FNetSetup.CheckList.Count-1 do begin
      writeln(TF,'Screens_Server = '+FNetSetup.SGScreens.Cells[0,i+1]+','+FNetSetup.SGSCreens.Cells[1,i+1]+','+
      FNetSetup.CheckList.Strings[i]);
    end;
  end;    

  // MAIN FONT SETTINGS
  S:='Global_Forces = ';
  if FSettings.PrimaryFont.ForceName   then S:=S+'1' else S:=S+'0';
  if FSettings.PrimaryFont.ForceSize   then S:=S+'1' else S:=S+'0';
  if FSettings.PrimaryFont.ForceBold   then S:=S+'1' else S:=S+'0';
  if FSettings.PrimaryFont.ForceItalic then S:=S+'1' else S:=S+'0';
  if FSettings.PrimaryFont.ForceColor  then S:=S+'1' else S:=S+'0';
  if FSettings.BackTick.Checked   then S:=S+'1' else S:=S+'0';
{  if FSongbase.CBC1.Checked then S:=S+'1' else} S:=S+'0';
{  if FSongbase.CBC2.Checked then S:=S+'1' else} S:=S+'0';
  if FSettings.AutoLoad1.Checked then S:=S+'1' else S:=S+'0';
  if FSettings.AutoView1.Checked then S:=S+'1' else S:=S+'0';

{  if FImport.CBLinks.Checked then S:=S+'1' else} S:=S+'0';
  if FSettings.ImageTick.Checked then S:=S+'1' else S:=S+'0';
  if FSettings.AutoViewSingle1.Checked then S:=S+'1' else S:=S+'0';
  if FSettings.CBRemoveSort.Checked  then S:=S+'1' else S:=S+'0';
  if FSettings.cbPowerPoint.Checked  then S:=S+'1' else S:=S+'0';
  if FSettings.cbProjectNext.Checked then S:=S+'1' else S:=S+'0';
  if bIgnoreDoubleClicks             then S:=S+'1' else S:=S+'0';
  if FSettings.cbShadow.Checked      then S:=S+'1' else S:=S+'0';
  if FExport.CBLinks.Checked         then S:=S+'1' else S:=S+'0';
  writeln(TF,S);

  // COPYRIGHT FONT SETTINGS
  writeln(TF,'Copyright_Font = '+FSettings.CopyrightFont.Name );
  str(FSettings.CopyrightFont.Size, S); writeln(TF,'Copyright_Size = '+S);
  str(FSettings.CopyrightFont.Color,S); writeln(TF,'Copyright_FColour = '+S);
  writeln(TF,'Copyright_Area = '+ RectToStr(FSongbase.rCopyArea) );

  S:='Copyright_Forces = ';
  if FSettings.CopyrightFont.ForceName   then S:=S+'1' else S:=S+'0';
  if FSettings.CopyrightFont.ForceSize   then S:=S+'1' else S:=S+'0';
  if FSettings.CopyrightFont.ForceBold   then S:=S+'1' else S:=S+'0';
  if FSettings.CopyrightFont.ForceItalic then S:=S+'1' else S:=S+'0';
  if FSettings.CopyrightFont.ForceColor  then S:=S+'1' else S:=S+'0';
  if FSettings.CopyrightFont.Bold        then S:=S+'1' else S:=S+'0';
  if FSettings.CopyrightFont.Italic      then S:=S+'1' else S:=S+'0';
  writeln(TF,S);

  // CCLI FONT SETTINGS
  writeln(TF,'CCLI_Font = '+FSettings.CCLIFont.Name );
  str(FSettings.CCLIFont.Size,S);  writeln(TF,'CCLI_Size = '+S);
  str(FSettings.CCLIFont.Color,S); writeln(TF,'CCLI_FColour = '+S);
  writeln(TF,'CCLI_Area = ' + RectToStr(FSongbase.rCCLIArea) );

  S:='CCLI_Forces = ';
  if FSettings.CCLIFont.ForceName   then S:=S+'1' else S:=S+'0';
  if FSettings.CCLIFont.ForceSize   then S:=S+'1' else S:=S+'0';
  if FSettings.CCLIFont.ForceBold   then S:=S+'1' else S:=S+'0';
  if FSettings.CCLIFont.ForceItalic then S:=S+'1' else S:=S+'0';
  if FSettings.CCLIFont.ForceColor  then S:=S+'1' else S:=S+'0';
  if FSettings.CCLIFont.Bold        then S:=S+'1' else S:=S+'0';
  if FSettings.CCLIFont.Italic      then S:=S+'1' else S:=S+'0';
  writeln(TF,S);

  // DEFAULT FONT (for editing) SETTINGS
  writeln(TF,'Default_Font = '+FTools.CBFont.Text);
  str(FTools.UpDown1.Position,S); writeln(TF,'Default_Size = '+S);
  S:='Background_Image = '+FSettings.ImageFile; writeln(TF,S);
  S:='Blank_Image_File = '+FProjWin.BlankImgFile; writeln(TF,S);

  S:='Force_BG_Image = '; if FSettings.ForceBGImage.Checked then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  S:='Default_Bold = ';   if FTools.BBold.Down              then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  S:='Default_Italic = '; if FTools.BItalic.Down            then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  S:='Default_Under = ';  if FTools.BUnder.Down             then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  str(FTools.PCol2.Color,S);      S:='Default_FColour = '+S;        writeln(TF,S);
  str(FSettings.iShadowOffset,S); S:= 'Default_Shadow_Offset = '+S; writeln(TF,S);
  S:='Default_Just = ';
  if FTools.BLeft.Down then S:=S+'0' else
  if FTools.BCent.Down then S:=S+'1' else
  if FTools.BRight.Down then S:=S+'2' else s:=S+'3';
  writeln(TF,S);
  S:='Auto_TickOHP = '; if FSettings.CBAutoOHP.Checked then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  S:='Auto_Complete = '; if FSongbase.AutoCompletion1.Checked then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  writeln(TF,'SearchText = '+FSearch.ESearchText.Text);
  S:='Search_OHP = '; if FSearch.CBOHPSearch.Checked then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  S:='Search_Mus = ';
  S:=S+chr(65+FSearch.CKey.ItemIndex)+chr(65+FSearch.CMM.ItemIndex)+chr(65+FSearch.CCapo.ItemIndex)+chr(65+FSearch.CTempo.ItemIndex);
  writeln(TF,S);

  if FSettings.lbBGImages.Count > 0 then begin
    S:='Background_List = ';
    for i:=0 to FSettings.lbBGImages.Count-1 do begin
      S := S + '"' + FSettings.lbBGImages.Items.Strings[i] + '",';
    end;
    S := LeftStr(S, Length(S)-1);    
    writeln(TF,S);
  end;

  if FSettings.cbBGOrder.ItemIndex <> 0 then begin
    S:='Background_ListOrder = '+ FSettings.cbBGOrder.Items.Strings[
                                            FSettings.cbBGOrder.ItemIndex];
    writeln(TF,S);
  end;

  S:='Print_Trans = '; if FPrintSelect.PCTrans.Checked then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  S:='Print_OHP = '; if FPrintSelect.PCOHP.Checked then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  S:='Print_Rec = '; if FPrintSelect.PCRec.Checked then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  S:='Print_Photo = '; if FPrintSelect.PCPhoto.Checked then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  S:='Print_All = '; if FPrintSelect.PCAll.Checked then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  S:='Print_Print = '; if FPrintSelect.PCPrint.Checked then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  S:='Print_Prev = '; if FPrintSelect.PCBPreview.Checked then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  S:='SL_CSK = '; if FPSong.CSK.checked then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  S:='SL_CIK = '; if FPSong.CIK.checked then S:=S+'1' else S:=S+'0'; writeln(TF,S);
  S:='SL_Capo = '; if FPSong.CBCapo.checked then S:=S+'1' else S:=S+'0'; writeln(TF,S);

  // Added 'as projected' in .42 (config needs to be re-ordered for backwards compat)
  i := 0;
  case FTools.CBScreen.ItemIndex of
    ITEM_IDX_AS_PROJECTED: i := 6;
    ITEM_IDX_640_480:      i := 1;
    ITEM_IDX_800_600:      i := 2;
    ITEM_IDX_1024_768:     i := 3;
    ITEM_IDX_1152_864:     i := 4;
    ITEM_IDX_1280_1024:    i := 5;
  end;
  writeln( TF, 'Res = '+ IntToStr(i) );
  
  str(FSettings.CBScaleProjRes.ItemIndex,S); S:='Project_Scale = '+S; writeln(TF,S);
  if FSongbase.bMultiMonConfig then str( FSongbase.ProjectScreen, S )
                               else str( 0, S );
  S:='Project_To_Screen = '+S; writeln(TF,S);
  str(FPSong.CBTrans.ItemIndex,S); S:='SL_Trans = '+S; writeln(TF,S);
  str(FPrintSelect.PCBReport.ItemIndex,S); S:='Print_Report = '+S; writeln(TF,S);

  // If the temporary directory is set to something non-default, save it
  if bSetTemp then begin
    writeln( TF, 'Temp_Directory = ' + TempHost );
  end;

  if FSongbase.Database1.Count>END_MENU+1 then begin
    for i:=END_MENU+1 to FSongbase.Database1.Count-1 do begin
      S:='File = '+FSongbase.Database1.Items[i].Caption;
      DeAmp(S);
      writeln(TF,S);
    end;
  end;
  writeCCLIInfo(TF);
  CloseTextfile(TF,INI);

  LogThis( 'options file written' );
end;

procedure writeCCLIInfo(var TF : TextFile);
begin
  writeln(TF,'OrganisationName='+FSettings.EOrg.Text);
  writeln(TF,'Reference='+FSettings.ECustRef.Text);
  writeln(TF,'CCLicenceNo='+FSettings.ELicense.Text);
  writeln(TF,'MRLicenceNo='+FSettings.EMRLicence.Text);
  writeln(TF,'ExpiryDate='+DateToStr(FSettings.DTExpiry.Date));
  writeln(TF,'Address='+FSettings.EOrgAdd.Text);
  writeln(TF,'Town='+FSettings.EOrgTown.Text);
  writeln(TF,'PostCode='+FSettings.EOrgPostCode.Text);
  writeln(TF,'Country='+FSettings.EOrgCountry.Text);
  writeln(TF,'DaytimePhone='+FSettings.EOrgDAyTel.Text);
  writeln(TF,'EveningPhone='+FSettings.EOrgEveTel.Text);
  writeln(TF,'Fax='+FSettings.EOrgFax.Text);
  writeln(TF,'Email='+FSettings.EOrgEmail.Text);
  writeln(TF,'WebsiteURL='+FSettings.EOrgWebsite.Text);
  writeln(TF,'LicenceRepTitle='+FSettings.ERepTitle.Text);
  writeln(TF,'LicenceRepForename='+FSettings.ERepForename.Text);
  writeln(TF,'LicenceRepSurname='+FSettings.ERepSurname.Text);
  writeln(TF,'lrAddress='+FSettings.ERepAddress.Text);
  writeln(TF,'lrTown='+FSettings.ERepTown.Text);
  writeln(TF,'lrPostcode='+FSettings.ERepPostCode.Text);
  writeln(TF,'lrCountry='+FSettings.ERepCountry.Text);
  writeln(TF,'LrDaytimePhone='+FSettings.ERepDayTel.Text);
  writeln(TF,'LrEveningPhone='+FSettings.ERepEveTel.Text);
end;

function stripCommas(s : string) : string;
var i : integer;
    s2 : string;
begin
  s2:='';
  for i:=1 to length(s) do
    if s[i]<>',' then s2:=s2+s[i];
  stripCommas:=s2;
end;

procedure ReadParams(ini : string);
const EditScreenIdx: array[0..6] of integer =
      ( ITEM_IDX_FULL_SCREEN,  ITEM_IDX_640_480,
        ITEM_IDX_800_600,      ITEM_IDX_1024_768,
        ITEM_IDX_1152_864,     ITEM_IDX_1280_1024,
        ITEM_IDX_AS_PROJECTED );
var TF : TextFile;
    S, OldBackground : string;
    Code,I,lValue : integer;
    T : TColor;
    TMI : TMenuItem;
    FCount : byte;
    ch : char;
    b, bBGError : boolean;
    sExt, sName, sValue : string;
    szTargetSize : size;
    s_svr,s_port,s_use : string;
begin
  LogThis( 'Reading Options file: ' + ini );
  szTargetSize := FSongbase.szDisplaySize;
  FNetSetup.SGScreens.RowCount:=2;
  FNetSetup.SGScreens.FixedRows:=1;
  FNetSetup.CheckList.Clear;
  if FSettings.ImageTick.Checked then OldBackground := FSettings.ImageFile
                                 else OldBackground := '';
  FCount:=0;
  while (FSongbase.Database1.Count>END_MENU) do
  FSongbase.Database1.Delete(FSongbase.Database1.Count-1);

  if FileExists(INI) and OpenForRead(TF,INI) then begin
    while not eof(TF) do begin
      readln(TF,S);

      // Skip any lines without a '='
      i := Pos('=',S);
      if 0 = i then continue;

      // Get the option name and value
      sName  := trim( copy(S,1,i-1) );
      sValue := trim( copy(S,i+1,MaxInt ) );
      lValue := length(sValue);

      if sName = 'OrganisationName'   then FSettings.EOrg.Text:= sValue
      else if sName = 'Reference'          then FSettings.ECustRef.Text:=sValue
      else if sName = 'CCLicenceNo'        then FSettings.ELicense.Text:=sValue
      else if sName = 'MRLicenceNo'        then FSettings.EMRLicence.Text:=sValue
      else if sName = 'Address'            then FSettings.EOrgAdd.Text:=sValue
      else if sName = 'Town'               then FSettings.EOrgTown.Text:=sValue
      else if sName = 'PostCode'           then FSettings.EOrgPostCode.Text:=sValue
      else if sName = 'Country'            then FSettings.EOrgCountry.Text:=sValue
      else if sName = 'DaytimePhone'       then FSettings.EOrgDayTel.Text:=sValue
      else if sName = 'EveningPhone'       then FSettings.EOrgEveTel.Text:=sValue
      else if sName = 'Fax'                then FSettings.EOrgFax.Text:=sValue
      else if sName = 'Email'              then FSettings.EOrgEmail.Text:=sValue
      else if sName = 'WebsiteURL'         then FSettings.EOrgWebsite.Text:=sValue
      else if sName = 'LicenceRepTitle'    then FSettings.ERepTitle.Text:=sValue
      else if sName = 'LicenceRepForename' then FSettings.ERepForename.Text:=sValue
      else if sName = 'LicenceRepSurname'  then FSettings.ERepSurname.Text:=sValue
      else if sName = 'lrAddress'          then FSettings.ERepAddress.Text:=sValue
      else if sName = 'lrTown'             then FSettings.ERepTown.Text:=sValue
      else if sName = 'lrPostcode'         then FSettings.ERepPostCode.Text:=sValue
      else if sName = 'lrCountry'          then FSettings.ERepCountry.Text:=sValue
      else if sName = 'LrDaytimePhone'     then FSettings.ERepDayTel.Text:=sValue
      else if sName = 'LrEveningPhone'     then FSettings.ERepEveTel.Text:=sValue
      else if sName = 'ExpiryDate'         then FSettings.DTExpiry.Date:=StrToDate(sValue)
      else if sName = 'LicenseNo'          then FSettings.ELicense.Text:=sValue
      else if sName = 'Global_Font'        then FSettings.PrimaryFont.Name := sValue
      else if sName = 'Global_Size'        then val(sValue, FSettings.PrimaryFont.Size, Code)
      else if sName = 'Global_Bold'        then FSettings.PrimaryFont.Bold   := (sValue='1')
      else if sName = 'Global_Italic'      then FSettings.PrimaryFont.Italic := (sValue='1')
      else if sName = 'Global_FColour'     then val(sValue,FSettings.PrimaryFont.Color,Code)
      else if sName = 'Global_BColour'     then begin val(sValue,T,Code); FSettings.PColB.Color:=T; end
      else if sName = 'Global_Shadow'      then begin val(sValue,T,Code); FSettings.PShadowCol.Color:=T; end
      else if sName = 'Global Area'        then processRectStr( sValue, FSongbase.rTextArea )
      else if sName = 'Net_Local_IP'       then FNetSetup.LocalIP:=sValue
      else if sName = 'Net_Port'           then FNetSetup.port:=sValue
      else if SName = 'Net_Enable'         then FNetSetup.enabled:=(sValue='1')

      else if sName = 'Screens_Server'    then begin
        s_svr := trim(copy(svalue,0,pos(',',svalue)-1));
        svalue:=copy(svalue,pos(',',svalue)+1,length(svalue));
        s_port := trim(copy(svalue,0,pos(',',svalue)-1));
        svalue:=copy(svalue,pos(',',svalue)+1,length(svalue));
        s_use := trim(svalue);
        FNetSetup.CheckList.Add(s_use);
        FNetSetup.SGScreens.RowCount:=2+FNetSetup.CheckList.Count;
        FNetSetup.SGSCreens.Cells[0,FNetSetup.CheckList.Count]:=s_svr;
        FNetSetup.SGSCreens.Cells[1,FNetSetup.CheckList.Count]:=s_port;
 end
      //----- LEGACY OPTIONS ------
      else if sName = 'Global OffsetL'     then val(sValue,FSongbase.rTextArea.Left,Code)
      else if (sName = 'Global OffsetT') or (sName = 'Global VOffset') then
                                        val(sValue,FSongbase.rTextArea.Top,Code)
      else if (sName = 'Global OffsetR') then begin
        val(sValue,FSongbase.rTextArea.Right,Code);
        FSongbase.rTextArea.Right :=
                  FSongbase.szDisplaySize.cx - FSongbase.rTextArea.Right;
      end
      else if (sName = 'Global OffsetB') then begin
        val(sValue,FSongbase.rTextArea.Bottom,Code);
        FSongbase.rTextArea.Bottom :=
                  FSongbase.szDisplaySize.cy - FSongbase.rTextArea.Bottom;
      end
      //-----------------------------

      else if sName = 'Screen_X'   then begin val(sValue,T,Code); FSongbase.Left:=T; end
      else if sName = 'Screen_Y'   then begin val(sValue,T,Code); FSongbase.Top:=T; end
      else if sName = 'Display_W'  then begin val(sValue,T,Code); szTargetSize.cx:=T; end
      else if sName = 'Display_H'  then begin val(sValue,T,Code); szTargetSize.cy:=T; end

      else if sName = 'Preview_X'  then begin val(sValue,T,Code); FPreviewWindow.Left:=T; end
      else if sName = 'Preview_Y'  then begin val(sValue,T,Code); FPreviewWindow.Top:=T; end
      else if sName = 'Preview_W'  then begin val(sValue,T,Code); FSongbase.szPreviewSize.cx:=T; end
      else if sName = 'Preview_H'  then begin val(sValue,T,Code); FSongbase.szPreviewSize.cy:=T; end
      else if sName = 'LiveWin_X'  then begin val(sValue,T,Code); FLiveWindow.Left:=T; end
      else if sName = 'LiveWin_Y'  then begin val(sValue,T,Code); FLiveWindow.Top:=T; end
      else if sName = 'LiveWin_W'  then begin val(sValue,T,Code); FSongbase.szLiveSize.cx:=T; end
      else if sName = 'LiveWin_H'  then begin val(sValue,T,Code); FSongbase.szLiveSize.cy:=T; end

      else if sName = 'SearchResults_X' then begin val(sValue,T,Code); FSearchResults.Left :=T; end
      else if sName = 'SearchResults_Y' then begin val(sValue,T,Code); FSearchResults.Top  :=T; end

      else if sName = 'Title_X'     then begin val(sValue,T,Code); FTitle.PosX:=T; end
      else if sName = 'FLDes_X'     then begin val(sValue,T,Code); FLinkDesc.PosX:=T; end
      else if sName = 'FLDes_Y'     then begin val(sValue,T,Code); FLinkDesc.PosY:=T; end
      else if sName = 'FLink_X'     then begin val(sValue,T,Code); FLinkForm.PosX:=T; end
      else if sName = 'FLink_Y'     then begin val(sValue,T,Code); FLinkForm.PosX:=T; end
      else if sName = 'Title_Y'     then begin val(sValue,T,Code); FTitle.PosY:=T; end
      else if sName = 'Search_X'    then begin val(sValue,T,Code); FSearch.PosX:=T; end
      else if sName = 'Search_Y'    then begin val(sValue,T,Code); FSearch.PosY:=T; end
      else if sName = 'Import_X'    then begin val(sValue,T,Code); FImport.PosX:=T; end
      else if sName = 'Import_Y'    then begin val(sValue,T,Code); FImport.PosY:=T; end
      else if sName = 'Export_X'    then begin val(sValue,T,Code); FExport.PosX:=T; end
      else if sName = 'Export_Y'    then begin val(sValue,T,Code); FExport.PosY:=T; end
      else if sName = 'PrnSel_X'    then begin val(sValue,T,Code); FPrintSelect.posX:=T; end
      else if sName = 'PrnSel_Y'    then begin val(sValue,T,Code); FPrintSelect.PosY:=T; end
      else if sName = 'FPSong_X'    then begin val(sValue,T,Code); FPSong.posX:=T; end
      else if sName = 'FPSong_Y'    then begin val(sValue,T,Code); FPSong.PosY:=T; end
      else if sName = 'FPOHP_X'     then begin val(sValue,T,Code); FPOHP.posX:=T; end
      else if sName = 'FPOHP_Y'     then begin val(sValue,T,Code); FPOHP.PosY:=T; end
      else if sName = 'FGlob_X'     then begin val(sValue,T,Code); FSettings.posX:=T; end
      else if sName = 'FGlob_Y'     then begin val(sValue,T,Code); FSettings.PosY:=T; end
      else if sName = 'FAbout_X'    then begin val(sValue,T,Code); FAbout.posX:=T; end
      else if sName = 'FAbout_Y'    then begin val(sValue,T,Code); FAbout.PosY:=T; end
      else if sName = 'FSDetails_X' then begin val(sValue,T,Code); FSongDetails.PosX:=T; end
      else if sName = 'FSDetails_Y' then begin val(sValue,T,Code); FSongDetails.PosY:=T; end;

      if (FTitle.posX<=0) or (FTitle.posY<=0) then begin FTitle.posX:=FSongbase.left+5; FTitle.posY:=FSongbase.top+5; end;
      if (FSearch.posX<=0) or (FSearch.posY=0) then begin FSearch.posX:=FSongbase.left+5; FSearch.posY:=FSongbase.top+5; end;
      if (FImport.posX<=0) or (FImport.posY=0) then begin FImport.posX:=FSongbase.left+5; FImport.posY:=FSongbase.top+5; end;
      if (FExport.posX<=0) or (FExport.posY=0) then begin FExport.posX:=FSongbase.left+5; FExport.posY:=FSongbase.top+5; end;
      if (FPrintSelect.posX<=0) or (FPrintSelect.posY<=0) then begin FPrintSelect.posX:=FSongbase.left+5; FPrintSelect.posY:=FSongbase.top+5; end;
      if (FPSong.posX<=0) or (FPSong.posY<=0) then begin FPSong.posX:=FSongbase.left+5; FPSong.posY:=FSongbase.top+5; end;
      if (FPOHP.posX<=0) or (FPOHP.posY<=0) then begin FPOHP.posX:=FSongbase.left+5; FPOHP.posY:=FSongbase.top+5; end;
      if (FSettings.posX<=0) or (FSettings.posY<=0) then begin FSettings.posX:=FSongbase.left+5; FSettings.posY:=FSongbase.top+5; end;
      if (FAbout.posX<=0) or (FAbout.posY<=0) then begin FAbout.posX:=FSongbase.left+5; FAbout.posY:=FSongbase.top+5; end;

      if sName = 'Global_Forces' then begin
        Code := Min( lValue, 18 );
        for i := 1 to Code do begin
          b := ( copy( sValue, i, 1 ) = '1' );
          case i of
            1:  FSettings.PrimaryFont.ForceName    := b;
            2:  FSettings.PrimaryFont.ForceSize    := b;
            3:  FSettings.PrimaryFont.ForceBold    := b;
            4:  FSettings.PrimaryFont.ForceItalic  := b;
            5:  FSettings.PrimaryFont.ForceColor   := b;
            6:  FSettings.BackTick.Checked         := b;
            // 7: CBC1.Checked   := b;
            // 8: CBC2.Checked   := b
            9:  FSettings.AutoLoad1.Checked        := b;
            10: FSettings.AutoView1.Checked        := b;
//            11: FImport.CBLinks.Checked            := b;
            12: FSettings.ImageTick.Checked        := b;
            13: FSettings.AutoViewSingle1.Checked  := b;
            14: FSettings.CBRemoveSort.Checked     := b;
            15: FSettings.cbPowerPoint.Checked     := b;
            16: FSettings.cbProjectNext.Checked    := b;
            17: bIgnoreDoubleClicks                := b;
            18: FSettings.cbShadow.Checked         := b;
            19: FExport.CBLinks.Checked            := b;
          end;
        end;
      end;

      // COPYRIGHT FONT SETTINGS
      if sName = 'Copyright_Font'     then FSettings.CopyrightFont.Name := sValue;
      if sName = 'Copyright_Size'     then val( sValue, FSettings.CopyrightFont.Size,Code);
      if sName = 'Copyright_FColour'  then val( sValue, FSettings.CopyrightFont.Color,Code);
      if sName = 'Copyright_Area'     then processRectStr( sValue, FSongbase.rCopyArea );

      //---------- LEGACY OPTIONS ------------
      if sName = 'Copyright_Offset_X' then begin
        val( sValue, FSongbase.rCopyArea.Right,Code);
        FSongbase.rCopyArea.Right := FSongbase.szDisplaySize.cx -
                                     FSongbase.rCopyArea.Right;
        FSongbase.rCopyArea.Left  := FSongbase.rCopyArea.Right - 300;
      end;
      if sName = 'Copyright_Offset_Y' then begin
        val( sValue, FSongbase.rCopyArea.Bottom, Code);
        FSongbase.rCopyArea.Bottom := FSongbase.szDisplaySize.cy -
                                      FSongbase.rCopyArea.Bottom;
        FSongbase.rCopyArea.Top    := FSongbase.rCopyArea.Bottom - 150;
      end;
      //----------------------------------------

      if sName = 'Copyright_Forces'   then begin
        Code := Min( lValue, 7 );
        for i := 1 to Code do begin
          b := ( copy( sValue, i, 1 ) = '1' );
          case i of
            1:  FSettings.CopyrightFont.ForceName      := b;
            2:  FSettings.CopyrightFont.ForceSize      := b;
            3:  FSettings.CopyrightFont.ForceBold      := b;
            4:  FSettings.CopyrightFont.ForceItalic    := b;
            5:  FSettings.CopyrightFont.ForceColor     := b;
            6:  FSettings.CopyrightFont.Bold           := b;
            7:  FSettings.CopyrightFont.Italic         := b;
          end;
        end;
      end;

      // CCLI FONT SETTINGS
      if sName = 'CCLI_Font'     then FSettings.CCLIFont.Name := sValue;
      if sName = 'CCLI_Size'     then val( sValue, FSettings.CCLIFont.Size,  Code);
      if sName = 'CCLI_FColour'  then val( sValue, FSettings.CCLIFont.Color, Code);
      if sName = 'CCLI_Area'     then processRectStr( sValue, FSongbase.rCCLIArea );

      //---------- LEGACY OPTIONS -------------
      if sName = 'CCLI_Offset_X' then begin
        val( sValue, FSongbase.rCCLIArea.Left,Code);
        FSongbase.rCCLIArea.Right := FSongbase.rCCLIArea.Left + 300;
      end;
      if sName = 'CCLI_Offset_Y' then begin
        val( sValue, FSongbase.rCCLIArea.Bottom, Code);
        FSongbase.rCCLIArea.Bottom := FSongbase.szDisplaySize.cy -
                                      FSongbase.rCCLIArea.Bottom;
        FSongbase.rCCLIArea.Top    := FSongbase.rCCLIArea.Bottom - 150;
      end;
      //----------------------------------------

      if sName = 'CCLI_Forces'   then begin
        Code := Min( lValue, 7 );
        for i := 1 to Code do begin
          b := ( copy( sValue, i, 1 ) = '1' );
          case i of
            1:  FSettings.CCLIFont.ForceName      := b;
            2:  FSettings.CCLIFont.ForceSize      := b;
            3:  FSettings.CCLIFont.ForceBold      := b;
            4:  FSettings.CCLIFont.ForceItalic    := b;
            5:  FSettings.CCLIFont.ForceColor     := b;
            6:  FSettings.CCLIFont.Bold           := b;
            7:  FSettings.CCLIFont.Italic         := b;
          end;
        end;
      end;

      if sName = 'Default_Font'     then FTools.CBFont.ItemIndex:=FTools.CBFont.Items.IndexOf(sValue);
      if sName = 'Default_Size'     then begin val(sValue,I,Code); FTools.UpDown1.Position:=I; end;
      if sName = 'Default_Bold'     then FTools.BBold.Down   := (sValue='1');
      if sName = 'Default_Italic'   then FTools.BItalic.Down := (sValue='1');
      if sName = 'Default_FColour'  then begin val(sValue,T,Code); FTools.PCol2.Color:=T; end;
      if sName = 'Default_Shadow_Offset' then val(sValue,FSettings.iShadowOffset,Code);     
      if sName = 'Background_Image' then FSettings.ImageFile := sValue;
      if sName = 'Force_BG_Image'   then FSettings.ForceBGImage.Checked := (sValue='1');
      if sName = 'Blank_Image_File' then FProjWin.BlankImgFile := sValue;

      if sName = 'Background_List' then begin
        FSettings.lbBGImages.Clear;
        repeat
          i := Pos('"',sValue);
          if 0 = i then break;
          inc(i);
          sValue := Copy(sValue,i,Length(sValue));
          i      := Pos('"',sValue);
          if 0 = i then break;
          S      := Copy(sValue,0,i-1);
          if FileExists(S) then FSettings.lbBGImages.Items.Add(S);
          inc(i);
          sValue := Copy(sValue,i,Length(sValue));
        until sValue = '';
        if FSettings.lbBGImages.Count > 0 then begin
          FSettings.lbBGImages.Enabled := true;
          FSettings.lbBGImages.Font.Color := clWindowText;
          FSettings.cbBGOrder.Enabled := true;
        end;
      end;

      if sName = 'Background_ListOrder' then begin
        i := FSettings.cbBGOrder.Items.IndexOf(sValue);
        if i <> -1 then FSettings.cbBGOrder.ItemIndex := i;        
      end;

      if sName = 'Default_Just'     then begin
        if sValue = '0' then begin FTools.BCent.Down:=false; FTools.BRight.Down:=false; FTools.BLeft.Down :=true; end;
        if sValue = '1' then begin FTools.BLeft.Down:=false; FTools.BRight.Down:=false; FTools.BCent.Down :=true; end;
        if sValue = '2' then begin FTools.BCent.Down:=false; FTools.BLeft.Down :=false; FTools.BRight.Down:=true; end;
      end;
      if sName = 'Auto_TickOHP'    then FSettings.CBAutoOHP.Checked        := (sValue='1');
      if sName = 'Auto_Complete'   then FSongbase.AutoCompletion1.Checked  := (sValue='1');
      if sName = 'SearchText'      then FSearch.ESearchText.Text           := sValue;
      if sName = 'Search_OHP'      then FSearch.CBOHPSearch.Checked        := (sValue='1');
      if sName = 'Print_Prev'      then FPrintSelect.PCBPreview.Checked    := (sValue='1');
      if sName = 'SL_CSK'          then FPSong.CSK.checked                 := (sValue='1');
      if sName = 'SL_CIK'          then begin
                                      FPSong.CIK.checked     := (sValue='1');
                                      FPSong.CBTrans.Enabled := FPSong.CIK.Checked;
                                      FPSong.CBCapo.Enabled  := FPSong.CIK.Checked;
                                    end;
      if sName = 'SL_Trans'        then begin val(sValue,i,code); FPSong.CBTrans.ItemIndex:=i; end;
      if sName = 'SL_Capo'         then FPSong.CBCapo.Checked := (sValue='1');
      if sName = 'Search_Mus' then begin
        if lValue > 0 then FSearch.CKey.ItemIndex   := ord(sValue[1]) - 65;
        if lValue > 1 then FSearch.CMM.ItemIndex    := ord(sValue[2]) - 65;
        if lValue > 2 then FSearch.CCapo.ItemIndex  := ord(sValue[3]) - 65;
        if lValue > 3 then FSearch.CTempo.ItemIndex := ord(sValue[4]) - 65;
      end;
      if sName = 'Print_Trans'       then FPrintSelect.PCTrans.Checked := (sValue='1');
      if sName = 'Print_OHP'         then FPrintSelect.PCOHP.Checked   := (sValue='1');
      if sName = 'Print_Rec'         then FPrintSelect.PCRec.Checked   := (sValue='1');
      if sName = 'Print_All'         then FPrintSelect.PCAll.Checked   := (sValue='1');
      if sName = 'Print_Photo'       then FPrintSelect.PCPhoto.Checked := (sValue='1');
      if sName = 'Print_Print'       then FPrintSelect.PCPrint.Checked := (sValue='1');
      if sName = 'Print_Report'      then begin val(sValue,I,Code); FPrintSelect.PCBReport.ItemIndex:=I; end;
      if sName = 'Res'               then begin
        val(sValue,I,Code);
        if I < 0 then I := 0;
        if I > 6 then I := 6;
        FTools.CBScreen.ItemIndex := EditScreenIdx[I];
      end;
      if sName = 'Project_Scale'     then begin val(sValue,I,Code); FSettings.SetProjectScale(i); end;
      if sName = 'Project_To_Screen' then begin
        val(sValue,I,Code);
        FSongbase.ProjectScreen   := FSongbase.DefaultScreen;
        if I = 0 then begin
          FSongbase.bMultiMonConfig := false;
          FSongbase.bMultiMonitor   := false;
        end else begin
          FSongbase.bMultiMonitor   := FSongbase.bMultiMonCapable;
          FSongbase.bMultiMonConfig := true;
          if FSongbase.bMultiMonitor then begin
            FSongbase.ProjectScreen   := I;
            FSongbase.szDisplaySize   := FSongbase.szMultiMonSize;
          end;
        end;
      end;
      if sName = 'Temp_Directory' then begin TempHost := sValue; bSetTemp := true; end;
      if (sName = 'File') and (sValue <> '') then begin
        if FCount = 0 then begin
          TMI:=TMenuItem.Create(FSongbase);
          TMI.Caption:='-';
          FSongbase.Database1.add(TMI);
        end;
        TMI:=TMenuItem.Create(FSongbase);
        TMI.Caption := sValue;
        inc(FCount);
        ch:=chr(48+FCount);
        TMI.Shortcut:=shortcut(Word(ch),[ssCtrl]);
        if FCount=1 then TMI.OnClick:=FSongbase.Clicked_1;
        if FCount=2 then TMI.OnClick:=FSongbase.Clicked_2;
        if FCount=3 then TMI.OnClick:=FSongbase.Clicked_3;
        if FCount=4 then TMI.OnClick:=FSongbase.Clicked_4;
        FSongbase.Database1.Add(TMI);
      end;
    end;
    CloseTextfile(TF,INI);
    LogThis( 'Options file read' );
  end;
  FPrintSelect.PCTrans.Enabled := not FPrintSelect.PCAll.Checked;
  FPrintSelect.PCOHP.Enabled   := not FPrintSelect.PCAll.Checked;
  FPrintSelect.PCPrint.Enabled := not FPrintSelect.PCAll.Checked;
  FPrintSelect.PCRec.Enabled   := not FPrintSelect.PCAll.Checked;
  FPrintSelect.PCPhoto.Enabled := not FPRintSelect.PCAll.Checked;

  // Ensure that the background image exists.
  if FSettings.ImageTick.Checked then begin
    sExt := lowercase(ExtractFileExt(FSettings.ImageFile));
    if ((sExt = '.jpg') or (sExt = '.jpeg') or (sExt = '.bmp') or (sExt = '.pcx')) and
       FileExists( FSettings.ImageFile ) then begin
      if (OldBackground <> FSettings.ImageFile) then begin
        bBGError := false;
        try
          FSettings.BGTestImg.Picture.LoadFromFile( FSettings.ImageFile );
        except on EStreamError do bBGError := true end;
        if bBGError then begin
          FSettings.ImageTick.Checked := false;
        end;
      end;
    end
    else FSettings.ImageTick.Checked := false;
  end;

  // Scale offsets to account for changes in display size
  if (FSongbase.szDisplaySize.cx <> szTargetSize.cx) or
     (FSongbase.szDisplaySize.cy <> szTargetSize.cy) then
    FSongbase.rescaleOffsets( szTargetSize, FSongbase.szDisplaySize );

  // Ensure the blanking image exists 
  if '' <> FProjWin.BlankImgFile then begin
    if FileExists(FProjWin.BlankImgFile) then begin
      FProjWin.ImgBlank.Picture.LoadFromFile(FProjWin.BlankImgFile);
    end else begin
      FProjWin.BlankImgFile := '';
    end;
  end;

  LogThis( 'Global configuration updated succesfully' );
end;


// From http://community.borland.com/article/0,1410,15910,00.html
procedure FileCopy( Const sourcefilename, targetfilename: String );
Var
  S, T: TFileStream;
Begin
  LogThis( 'Copying File ''' + sourcefilename + ''' to ''' + targetfilename + '''' );
  S := TFileStream.Create( sourcefilename, fmOpenRead );
  try
    T := TFileStream.Create( targetfilename,
                             fmOpenWrite or fmCreate );
    try
      T.CopyFrom(S, S.Size ) ;
    finally
      T.Free;
    end;
  finally
    S.Free;
  end;
  LogThis( 'Copying File ''' + sourcefilename + ''' to ''' + targetfilename + '''' );
end;


procedure LogThis( sText : string );
var
  hText : TextFile;
begin
  if (nil   = FSongBase) or
     (false = FSongBase.EnableLogging) then Exit;

  AssignFile( hText, FSongBase.LogFile );
  if FileExists( FSongBase.LogFile ) then Append( hText )
                                     else Rewrite(hText );
  Writeln( hText, FormatDateTime('yyyy/mm/dd hh:nn:ss: ', Now) + sText );
  CloseFile( hText );
end;

function RectsEqual( hA, hB : TRect ) : boolean;
begin
  Result := ( hA.Left   = hB.Left   ) and
            ( hA.Right  = hB.Right  ) and
            ( hA.Top    = hB.Top    ) and
            ( hA.Bottom = hB.Bottom );
end;

function GetTempDirectory: String;
var
  tempFolder: array[0..MAX_PATH] of Char;
begin
  GetTempPath(MAX_PATH, @tempFolder);
  result := StrPas(tempFolder);
end;

procedure processRectStr( sStr : string; var rRect : TRect );
var iIdx, Code : integer;
begin
  // Split on commas
  iIdx := Pos( ',', sStr );
  val( copy(sStr,0,iIdx), rRect.Left, Code );

  sStr := copy(sStr,1+iIdx, Length(sStr));
  iIdx := Pos( ',', sStr );
  val( copy(sStr,0,iIdx), rRect.Top, Code );

  sStr := copy(sStr,1+iIdx, Length(sStr));
  iIdx := Pos( ',', sStr );
  val( copy(sStr,0,iIdx), rRect.Right, Code );

  sStr := copy(sStr,1+iIdx, Length(sStr));
  val( sStr, rRect.Bottom, Code );
end;

function RectToStr( rRect : TRect ) : string;
begin
  Result := IntToStr(rRect.Left)  +', '+ IntToStr(rRect.Top) +', '+
            IntToStr(rRect.Right) +', '+ IntToStr(rRect.Bottom);
end;


constructor TNumber.Create( iI : integer );
begin
  Self.iIdx := iI;
end;


end.
