unit SBZipUtils;

interface
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Printers, StdCtrls, ComCtrls, ExtCtrls, ImgList, ToolWin, Zip32, UnZip32;

  procedure Set_UserFunctions(var Z:TUserFunctions);
  procedure SetDummyInitFunctions(var Z : TZipUserFunctions);

  function DllPrnt(Buffer: PChar; Size: ULONG): integer; stdcall;
  function DllPassword(P: PChar; N: Integer; M, Name: PChar): integer; stdcall;
  function DllService(CurFile: PChar; Size: ULONG): integer; stdcall;
  function DllReplace(FileNam: PChar): integer; stdcall;
  procedure DllMessage(UnCompSize : ULONG;
                     CompSize   : ULONG;
                     Factor     : UINT;
                     Month      : UINT;
                     Day        : UINT;
                     Year       : UINT;
                     Hour       : UINT;
                     Minute     : UINT;
                     C          : Char;
                     FileNam    : PChar;
                     MethBuf    : PChar;
                     CRC        : ULONG;
                     Crypt      : Char); stdcall;

  function DummyPrint(Buffer : PChar; Size: ULONG) : integer; stdcall;
  function DummyPassword(P : PChar; N : Integer; M,Name : PChar) : integer; stdcall;
  function DummyComment(Buffer : PChar): Pchar; stdcall;
  function DummyService(Buffer : PChar; size : ULong) : integer; stdcall;
  function ListItemCallback(CurFile : PChar; Size : ULOng) : integer; stdcall;

  procedure ExtractFileFromZip(ZipFile : string; FileName : string; XPath : string);
  procedure ExtractFilesFromZip( ZipFile : string; Files : TStringList; XPath : string);
  procedure AddFileToZip(St : string; ZipFile : string; moveFile : boolean);
  procedure AddFilesToZip( hFiles : TStringList; ZipFile : string; moveFile : boolean);
  procedure DeleteFileFromZIP(ZIPFile : String; Name : String);
  function  GetFileDataFromZip(ZipFile, FileName: string; var FileData : string; bSB : boolean ) : boolean;
//  function  GetDataFromZip(ZipFile, FileName: string; var lpData : PChar; var uiLen : integer ) : boolean;
  function  ListZipEntries(ZipFile : string; FilePath : string; XPath : string) : TStringList;

  implementation

  var UF : TUserFunctions;
  var hFileList : TStringList;


procedure AddFileToZip(St : string; ZipFile : string; moveFile : boolean);
var ZO : TZPOPt;
    ZUF : TZipUserFunctions;
    ZipRec : TZCL;
    i : integer;
    FNVStart : PCharArray;
    FileNam : string;
    FileList : TStrings;
begin
  // This function adds the specified filename to the zip file specified
  // by OHPFile... This is a bit rough, and shouldn't be in this unit.
  // V3!

  ZO:=ZpGetOptions;
  ZO.fGrow:=true;
  ZO.fUpdate:=true;
  ZO.fJunkDir:=true;
  ZO.fNoDirEntries:=true;
  ZO.fMove:=moveFile;
  ZO.fLevel:='9';
  ZO.fDeleteEntries:=false;
  ZpSetOptions(ZO);
  SetDummyInitFunctions(ZUF);
  FileNam:=ZipFile;
  FileList:=TStringList.create;
  FileList.Add(St);
  { precaution }
  if Trim(FileNam) = '' then Exit;
  if FileList.Count <= 0 then Exit;

  { initialize the dll with dummy functions }
  SetDummyInitFunctions(ZUF);

  { number of files to zip }
  ZipRec.argc := FileList.Count;

  { name of zip file - allocate room for null terminated string  }
  GetMem(ZipRec.lpszZipFN, Length(FileNam) + 1 );
  ZipRec.lpszZipFN := StrPCopy( ZipRec.lpszZipFN, FileNam);
  try
    { dynamic array allocation }
    GetMem(ZipRec.FNV, ZipRec.argc * SizeOf(PChar));
    FNVStart := ZipRec.FNV;
    try
      { copy the file names from FileList to ZipRec.FNV dynamic array }
      for i := 0 to ZipRec.argc - 1 do
      begin
        GetMem(ZipRec.FNV^[i], Length(FileList[i]) + 1 );
        StrPCopy(ZipRec.FNV^[i], FileList[i]);
      end;
      try
        { send the data to the dll }
        ZpArchive(ZipRec);
      finally
        { release the memory for the file list }
        ZipRec.FNV := FNVStart;
        for i := (ZipRec.argc - 1) downto 0 do
          FreeMem(ZipRec.FNV^[i], Length(FileList[i]) + 1 );
      end;

    finally
      { release the memory for the ZipRec.FNV dynamic array }
      ZipRec.FNV := FNVStart;
      FreeMem(ZipRec.FNV, ZipRec.argc * SizeOf(PChar));
    end;
  finally
    { release the memory for the FileName }
    FreeMem(ZipRec.lpszZipFN, Length(FileNam) + 1 );
  end;
  FileList.Free;
end;

procedure AddFilesToZip( hFiles : TStringList; ZipFile : string; moveFile : boolean);
var ZO : TZPOPt;
    ZUF : TZipUserFunctions;
    ZipRec : TZCL;
    i : integer;
    FNVStart : PCharArray;
    FileNam : string;
begin
  // This function adds the specified filename to the zip file specified
  // by OHPFile... This is a bit rough, and shouldn't be in this unit.
  // V3!

  ZO:=ZpGetOptions;
  ZO.fGrow:=true;
  ZO.fUpdate:=false;
  ZO.fJunkDir:=true;
  ZO.fNoDirEntries:=true;
  ZO.fMove:=moveFile;
  ZO.fLevel:='9';
  ZO.fDeleteEntries:=false;
  ZpSetOptions(ZO);
  SetDummyInitFunctions(ZUF);
  FileNam  := ZipFile;

  //----------------------------------------------------------------------------
  // NOTE: We turn "Range checking" off at several points here, as Delphi
  // is unswerving in its assertion that FNV is always a 0 length array,
  // and we just allocate enough space for what we need instead in its place.
  //----------------------------------------------------------------------------

{  FileList:=TStringList.create;
  for i := 0 to length(aSt)-1 do begin
    FileList.Add(aSt[i]);
  end;}

  { precaution }
  if Trim(FileNam) = '' then Exit;
  if hFiles.Count <= 0 then Exit;

  { initialize the dll with dummy functions }
  SetDummyInitFunctions(ZUF);

  { number of files to zip }
  ZipRec.argc := hFiles.Count;

  { name of zip file - allocate room for null terminated string  }
  try
    GetMem(ZipRec.lpszZipFN, Length(FileNam) + 1 );
    ZipRec.lpszZipFN := StrPCopy( ZipRec.lpszZipFN, FileNam );

    try
      { dynamic array allocation }
      GetMem(ZipRec.FNV, ZipRec.argc * SizeOf(PChar));
  //    ZipRec.FNV^ := FNV;
      FNVStart := ZipRec.FNV;
  //    try
      { copy the file names from FileList to ZipRec.FNV dynamic array }
      {$R-}
      for i := 0 to ZipRec.argc - 1 do
      begin
        GetMem( ZipRec.FNV^[i], Length(hFiles[i]) + 1 );
        StrPCopy(ZipRec.FNV^[i], hFiles[i]);
      end;
      {$R+}

      try
        { send the data to the dll }
        ZpArchive(ZipRec);
      finally
        { release the memory for the file list }
        {$R-}
        ZipRec.FNV := FNVStart;
        for i := (ZipRec.argc - 1) downto 0 do
          FreeMem(ZipRec.FNV[i], Length(hFiles[i]) + 1 );
        {$R+}
      end;

    finally
      // release the memory for the ZipRec.FNV dynamic array
      ZipRec.FNV := FNVStart;
      FreeMem(ZipRec.FNV, ZipRec.argc * SizeOf(PChar));
    end;
  finally
    { release the memory for the FileName }
    ZipRec.FNV := FNVStart;
    FreeMem(ZipRec.lpszZipFN, Length(FileNam) + 1 );
  end;
//  FileList.Free;
end;


procedure DeleteFileFromZIP(ZIPFile : String; Name : String);
var ZO : TZPOPt;
    ZUF : TZipUserFunctions;
    ZipRec : TZCL;
    i : integer;
    FNVStart : PCharArray;
    FileList : TStrings;

begin
  ZO:=ZpGetOptions;
  ZO.fGrow:=false;
  ZO.fUpdate:=false;
  ZO.fMove:=false;
  ZO.fDeleteEntries:=true;
  ZpSetOptions(ZO);
  SetDummyInitFunctions(ZUF);
  FileList:=TStringList.create;
  FileList.Add(Name);
  { precaution }
  if Trim(Name) = '' then Exit;
  if FileList.Count <= 0 then Exit;

  { initialize the dll with dummy functions }
  SetDummyInitFunctions(ZUF);

  { number of files to zip }
  ZipRec.argc := FileList.Count;

  { name of zip file - allocate room for null terminated string  }
  GetMem(ZipRec.lpszZipFN, Length(ZipFile) + 1 );
  ZipRec.lpszZipFN := StrPCopy( ZipRec.lpszZipFN, ZipFile);
  try
    { dynamic array allocation }
    GetMem(ZipRec.FNV, ZipRec.argc * SizeOf(PChar));
    FNVStart := ZipRec.FNV;
    try
      { copy the file names from FileList to ZipRec.FNV dynamic array }
      for i := 0 to ZipRec.argc - 1 do
      begin
        GetMem(ZipRec.FNV^[i], Length(FileList[i]) + 1 );
        StrPCopy(ZipRec.FNV^[i], FileList[i]);
      end;
      try
        { send the data to the dll }
        ZpArchive(ZipRec);
      finally
        { release the memory for the file list }
        ZipRec.FNV := FNVStart;
        for i := (ZipRec.argc - 1) downto 0 do
          FreeMem(ZipRec.FNV^[i], Length(FileList[i]) + 1 );
      end;

    finally
      { release the memory for the ZipRec.FNV dynamic array }
      ZipRec.FNV := FNVStart;
      FreeMem(ZipRec.FNV, ZipRec.argc * SizeOf(PChar));
    end;
  finally
    { release the memory for the FileName }
    FreeMem(ZipRec.lpszZipFN, Length(ZipFile) + 1 );
  end;
  FileList.Free;
end;

procedure ExtractFileFromZip(ZipFile : string; FileName : string; XPath : string);
var
  Opt : TDCL;
  i : integer;
  SelectedList : TstringList;
  FNV          : array[0..999] of PChar;
  argc         : integer;
  S1,S2 : string;

  begin
  { precautions }
  Set_UserFunctions(UF);
  SelectedList:=TStringList.Create;
  SelectedList.Clear;

  with Opt do
  begin
    ExtractOnlyNewer  := Integer(False);  { true if you are to extract only newer }
    SpaceToUnderscore := Integer(False);  { true if convert space to underscore }
    PromptToOverwrite := Integer(False);  { true if prompt to overwrite is wanted }
    fQuiet            := 2;               { quiet flag. 1 = few messages, 2 = no messages, 0 = all messages }
    nCFlag            := Integer(False);   { write to stdout if true }
    nTFlag            := Integer(False);  { test zip file }
    nVFlag            := Integer(False);  { verbose listing }
    nUFlag            := Integer(False);   { "update" (extract only newer/new files) }
    nZFlag            := Integer(False);  { display zip file comment }
    nDFlag            := Integer(True);  { all args are files/dir to be extracted }
    nOFlag            := Integer(True);  { true if you are to always over-write files, false if not }
    nAFlag            := Integer(False);   { do end-of-line translation }
    nZIFlag           := Integer(False);  { get zip info if true }
    C_flag            := Integer(True);   { be case insensitive if TRUE }
    fPrivilege        := 1;               { 1 => restore Acl's, 2 => Use privileges }

    S1:=XPath;
    while S1[length(S1)]<>'\' do S1:=copy(S1,1,length(S1)-1);
    S1:=copy(S1,1,length(S1)-1);
    S2:=ZipFile;
    lpszExtractDir    := PChar(S1);  { zip file name }
    lpszZipFN         := PChar(S2);  { Directory to extract to. NULL for the current directory }
  end;

  { get the selected files }

    SelectedList.Add(FileName);


  { if there are any selected files }
  if  SelectedList.Count > 0 then
  begin
    { copy the file names from SelectedList to FNV dynamic array }
    for i := 0 to SelectedList.Count - 1 do
    begin
     GetMem(FNV[i], Length(SelectedList[i]) + 1 );
      StrPCopy(FNV[i], SelectedList[i]);
    end;

    argc := SelectedList.Count;

    { unzip  }
    Wiz_SingleEntryUnzip(argc,             { number of file names being passed }
                         @FNV,             { file names to be unarchived }
                         0,                { number of "file names to be excluded from processing" being  passed }
                         nil,              { file names to be excluded from the unarchiving process }
                         Opt,              { pointer to a structure with the flags for setting the  various options }
                         UF);              { pointer to a structure that contains pointers to user functions }

    { release the memory }
    for i := (SelectedList.Count - 1) downto 0 do
      FreeMem(FNV[i], Length(SelectedList[i]) + 1 );

  end;
  SelectedList.Free;
end;

procedure ExtractFilesFromZip( ZipFile:string; Files:TStringList; XPath:string );
var
  Opt   : TDCL;
  i     : integer;
  FNV   : array[0..999] of PChar;
  argc  : integer;
  S1,S2 : string;

  begin
  { precautions }
  Set_UserFunctions(UF);

  with Opt do
  begin
    ExtractOnlyNewer  := Integer(False);  { true if you are to extract only newer }
    SpaceToUnderscore := Integer(False);  { true if convert space to underscore }
    PromptToOverwrite := Integer(False);  { true if prompt to overwrite is wanted }
    fQuiet            := 2;               { quiet flag. 1 = few messages, 2 = no messages, 0 = all messages }
    nCFlag            := Integer(False);   { write to stdout if true }
    nTFlag            := Integer(False);  { test zip file }
    nVFlag            := Integer(False);  { verbose listing }
    nUFlag            := Integer(False);   { "update" (extract only newer/new files) }
    nZFlag            := Integer(False);  { display zip file comment }
    nDFlag            := Integer(True);  { all args are files/dir to be extracted }
    nOFlag            := Integer(True);  { true if you are to always over-write files, false if not }
    nAFlag            := Integer(False);   { do end-of-line translation }
    nZIFlag           := Integer(False);  { get zip info if true }
    C_flag            := Integer(True);   { be case insensitive if TRUE }
    fPrivilege        := 1;               { 1 => restore Acl's, 2 => Use privileges }

    S1:=XPath;
    while S1[length(S1)]<>'\' do S1:=copy(S1,1,length(S1)-1);
    S1:=copy(S1,1,length(S1)-1);
    S2:=ZipFile;
    lpszExtractDir    := PChar(S1);  { zip file name }
    lpszZipFN         := PChar(S2);  { Directory to extract to. NULL for the current directory }
  end;

  { if there are any selected files }
  if Files.Count > 0 then
  begin
    { copy the file names from SelectedList to FNV dynamic array }
    for i := 0 to Files.Count - 1 do
    begin
      GetMem(FNV[i], Length(Files[i]) + 1 );
      StrPCopy(FNV[i], Files[i]);
    end;

    argc := Files.Count;

    { unzip  }
    Wiz_SingleEntryUnzip(argc,             { number of file names being passed }
                         @FNV,             { file names to be unarchived }
                         0,                { number of "file names to be excluded from processing" being  passed }
                         nil,              { file names to be excluded from the unarchiving process }
                         Opt,              { pointer to a structure with the flags for setting the  various options }
                         UF);              { pointer to a structure that contains pointers to user functions }

    { release the memory }
    for i := (Files.Count - 1) downto 0 do begin
      FreeMem(FNV[i], Length(Files[i]) + 1 );
    end;

  end;
end;

function ListZipEntries(ZipFile : string; FilePath : string; XPath : string) : TStringList;
var
  Opt : TDCL;
  i : integer;
  SelectedList : TstringList;
  FNV          : array[0..999] of PChar;
  argc         : integer;
  S1,S2 : string;

  begin
  { precautions }
  Set_UserFunctions(UF);
  @UF.ServCallBk := @ListItemCallback;

  SelectedList:=TStringList.Create;
  SelectedList.Clear;

  hFileList := TStringList.Create;
  hFileList.Clear;

  with Opt do
  begin
    ExtractOnlyNewer  := Integer(False);  { true if you are to extract only newer }
    SpaceToUnderscore := Integer(False);  { true if convert space to underscore }
    PromptToOverwrite := Integer(False);  { true if prompt to overwrite is wanted }
    fQuiet            := 2;               { quiet flag. 1 = few messages, 2 = no messages, 0 = all messages }
    nCFlag            := Integer(True);   { write to stdout if true }
    nTFlag            := Integer(False);  { test zip file }
    nVFlag            := Integer(True);  { verbose listing }
    nUFlag            := Integer(False);   { "update" (extract only newer/new files) }
    nZFlag            := Integer(False);  { display zip file comment }
    nDFlag            := Integer(True);  { all args are files/dir to be extracted }
    nOFlag            := Integer(True);  { true if you are to always over-write files, false if not }
    nAFlag            := Integer(False);   { do end-of-line translation }
    nZIFlag           := Integer(False);  { get zip info if true }
    C_flag            := Integer(True);   { be case insensitive if TRUE }
    fPrivilege        := 1;               { 1 => restore Acl's, 2 => Use privileges }

    S1:=XPath;
    while S1[length(S1)]<>'\' do S1:=copy(S1,1,length(S1)-1);
    S1:=copy(S1,1,length(S1)-1);
    S2:=ZipFile;
    lpszExtractDir    := PChar(S1);  { zip file name }
    lpszExtractDir    := nil;
    lpszZipFN         := PChar(S2);  { Directory to extract to. NULL for the current directory }
  end;

  { get the selected files }
    SelectedList.Add(FilePath);


  { if there are any selected files }
  if  SelectedList.Count > 0 then
  begin
    { copy the file names from SelectedList to FNV dynamic array }
    for i := 0 to SelectedList.Count - 1 do
    begin
     GetMem(FNV[i], Length(SelectedList[i]) + 1 );
      StrPCopy(FNV[i], SelectedList[i]);
    end;

    argc := SelectedList.Count;

    { unzip  }
    Wiz_SingleEntryUnzip(argc,             { number of file names being passed }
                         @FNV,             { file names to be unarchived }
                         0,                { number of "file names to be excluded from processing" being  passed }
                         nil,              { file names to be excluded from the unarchiving process }
                         Opt,              { pointer to a structure with the flags for setting the  various options }
                         UF);              { pointer to a structure that contains pointers to user functions }

    { release the memory }
    for i := (SelectedList.Count - 1) downto 0 do
      FreeMem(FNV[i], Length(SelectedList[i]) + 1 );

  end;
  SelectedList.Free;

  Result := hFileList;
end;


{
	Unzips a file from the ZIP file straight into memory
	and returns a string handle to the contents.
}   {
function  GetDataFromZip(ZipFile, FileName: string; var lpData : PChar; var uiLen : integer ) : boolean;
var
  Buffer       : TUzpBuffer;
  lpszZipFile  : PChar;
  lpszFilename : PChar;
  lpszResult   : PChar;
begin
  // precautions - set up the User Functions list
  Set_UserFunctions(UF);
  GetDataFromZip := false;

  // convert arguments to PChars
  lpszZipFile   := PChar(ZipFile);  // zip file name
  lpszFilename  := PChar(FileName); // filename from zip to extract

  // unzip it! - it will allocate a buffer
  if 0 = Wiz_UnzipToMemory( lpszZipFile, lpszFilename, UF, Buffer ) then begin
    Exit;
  end;

  // release the allocated buffer. IMPROVE: Just point at the data!!
  //UzpFreeMemBuffer( Buffer );
  lpData := Buffer.StrPtr;
  uiLen  := Buffer.StrLength;
  GetDataFromZip := true;
end;
        }

{
	Unzips a file from the ZIP file straight into memory
	and returns a string handle to the contents.
}
function GetFileDataFromZip(ZipFile, FileName: string; var FileData : string; bSB : boolean ) : boolean;
var
  Buffer       : TUzpBuffer;
  lpszZipFile  : PChar;
  lpszFilename : PChar;
  sResult      : string;
  lpszResult   : PChar;
begin
  { precautions - set up the User Functions list}
  Set_UserFunctions(UF);
  GetFileDataFromZip := false;

  { convert arguments to PChars }
  lpszZipFile   := PChar(ZipFile);  { zip file name }
  lpszFilename  := PChar(FileName); { filename from zip to extract }

  { unzip it! - it will allocate a buffer }
  if 0 = Wiz_UnzipToMemory( lpszZipFile, lpszFilename, UF, Buffer ) then begin
    Exit;
  end;

  // OK, this is wrong, bad, bad-wrong, badong, but I'm going to do it here
  // anyway, because it's quicker like that...
  {-------------- SONGBASE 2.0 FILE FORMAT SPECFIC BIT ----------------}
  lpszResult := Buffer.StrPtr;
  if bSB then begin
    if (Buffer.StrLength < 4) or
       ( (0 <> AnsiStrLComp( Buffer.StrPtr, '!SB!', 4 ))    and
         (0 <> AnsiStrLComp( Buffer.StrPtr, 'SDB2', 4 )) ) then begin
      messagedlg('The file '+FileName+' did not contain a valid version string',mtError,[mbOk],0);
      Exit;
    end;

    // Skip the version line...
    while Ord(lpszResult[0]) > 20 do inc(lpszResult);
    while Ord(lpszResult[0]) < 20 do inc(lpszResult);
  end;
  {------------ END OF SONGBASE 2.0 FILE FORMAT SPECFIC BIT -------------}

  { convert the buffer to a Delphi string }
  SetString( sResult, lpszResult, Buffer.StrLength - ( lpszResult - Buffer.StrPtr ) );

  { release the allocated buffer. IMPROVE: Just point at the data!! }
  UzpFreeMemBuffer( Buffer );

  FileData := sResult;
  GetFileDataFromZip := true;
end;



procedure Set_UserFunctions(var Z:TUserFunctions);
begin
  { prepare TUserFunctions structure }
  with Z do
  begin
    @Print                  := @DllPrnt;
    @Sound                  := nil;
    @Replace                := @DllReplace;
    @Password               := @DllPassword;
    @SendApplicationMessage := @DllMessage;
    @ServCallBk             := @DllService;
  end;
end;

procedure SetDummyInitFunctions(var Z : TZipUserFunctions);
begin
  with Z do begin
    @Print := @DummyPrint;
    @Comment := @DummyComment;
    @Password := @DummyPassword;
    @Service := @DummyService;
  end;
  ZpInit(Z);
end;

function DummyPrint(Buffer : PChar; Size: ULONG) : integer;
begin
  Result:=size;
end;
function DummyPassword(P : PChar; N : INteger; M, Name : Pchar) : integer;
begin
  result:=1;
end;
function DummyComment(Buffer : PChar) : PChar;
begin
  result:=Buffer;
end;
function DummyService(Buffer : PChar; Size : ULONG) : integer;
begin
  result:=0;
end;


procedure DllMessage(UnCompSize,Compsize : Ulong; Factor,Month,Day,Year,Hour,Minute : UInt;
  C : Char; FileNam,MethBuf : PChar; CRC : ULong; Crypt : Char);
begin
{}
end;
function DllPassword(P : PChar; N : Integer; M,Name : PChar): integer;
begin
  Result:=1;
end;
function DllService(CurFile : PChar; Size : ULOng) : integer;
begin
  result:=0;
end;
function DllReplace(FileNam : PChar) : integer;
begin
  result:=1;
end;
function DllPrnt(Buffer: PChar; Size : ULong) : integer;
begin
  Result:=size;
end;

function ListItemCallback(CurFile : PChar; Size : ULOng) : integer;
var sResult : string;
begin
  sResult := CurFile;
  hFileList.Add( sResult );
  result:=0;
end;

end.
