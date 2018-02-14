{-------------------------------------------------------
 STATE: THIS SOFTWARE IS FREEWARE AND IS PROVIDED AS IS
        AND COMES WITH NO WARRANTY OF ANY KIND, EITHER
        EXPRESSED OR IMPLIED. IN NO EVENT WILL THE
        AUTHOR(S) BE LIABLE FOR ANY DAMAGES RESULTING
        FROM THE USE OF THIS SOFTWARE.
--------------------------------------------------------}



{  Demo zip project for use with InfoZip's Zip32.dll (ver 2.3) 

  CAUTION   : Don't forget to put the Info-Zip's Zip32.dll in the
              same directory as this project, or somewhere else
              in the path and include (uses) the Zip32.pas
  Tested    : Delphi 2, 3, 4, 5
  Author(s) :
              Theo Bebekis <bebekis@otenet.gr>
              original author
              Marcus Wirth <mwirth@generali-int.de>
              changes to make the demo compatible with the
              latest dll version
  }

unit Zip;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Buttons, Zip32;

type
  TfrmMain = class(TForm)
    Pager: TPageControl;
    tabZipOptions: TTabSheet;
    tabMessages: TTabSheet;
    chSuffix: TCheckBox;
    chEncrypt: TCheckBox;
    chSystem: TCheckBox;
    chVolume: TCheckBox;
    chExtra: TCheckBox;
    chNoDirEntries: TCheckBox;
    chExcludeDate: TCheckBox;
    chIncludeDate: TCheckBox;
    chVerbose: TCheckBox;
    chQuiet: TCheckBox;
    chCRLF_LF: TCheckBox;
    chLF_CRLF: TCheckBox;
    chJunkDir: TCheckBox;
    chGrow: TCheckBox;
    chForce: TCheckBox;
    chMove: TCheckBox;
    chDeleteEntries: TCheckBox;
    chUpdate: TCheckBox;
    chFreshen: TCheckBox;
    chJunkSFX: TCheckBox;
    chLatestTime: TCheckBox;
    chComment: TCheckBox;
    chOffsets: TCheckBox;
    chPrivilege: TCheckBox;
    chEncryption: TCheckBox;
    edtDate: TEdit;
    edtRootDir: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    btnGetOptions: TBitBtn;
    btnSetOptions: TBitBtn;
    lboZipVersion: TListBox;
    Label5: TLabel;
    lboFilesToZip: TListBox;
    Label6: TLabel;
    edtZipFileName: TEdit;
    SaveDialog: TSaveDialog;
    btnSaveTo: TBitBtn;
    btnZipFiles: TBitBtn;
    Memo: TMemo;
    Label8: TLabel;
    edtTempDir: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnGetOptionsClick(Sender: TObject);
    procedure btnSetOptionsClick(Sender: TObject);
    procedure btnSaveToClick(Sender: TObject);
    procedure btnZipFilesClick(Sender: TObject);
  private
    { Private declarations }
    procedure DisplayZipDllVersionInfo;
    procedure Get_ZipDllOptions;
    procedure Set_ZipDllOptions;
    procedure WMDropFiles(var Msg: TMessage); message WM_DropFiles;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;



{ global routines }
procedure ZipFiles(FileName : string; FileList: TStrings);
procedure SetDummyInitFunctions(var Z:TZipUserFunctions);

{ dummy helper initialization functions }
function DummyPrint(Buffer: PChar; Size: ULONG): integer; stdcall ;
function DummyPassword(P: PChar; N: Integer; M, Name: PChar): integer; stdcall ;
function DummyComment(Buffer: PChar): PChar; stdcall ;
function DummyService(Buffer: PChar; Size: ULONG): integer; stdcall;



implementation

{$R *.DFM}

uses
  ShellApi;


{ global routines }
{----------------------------------------------------------------------------------}
procedure ZipFiles(FileName : string; FileList: TStrings);
var
  i        : integer;
  ZipRec   : TZCL;
  ZUF      : TZipUserFunctions;
  FNVStart : PCharArray;
begin

  { precaution }
  if Trim(FileName) = '' then Exit;
  if FileList.Count <= 0 then Exit;

  { initialize the dll with dummy functions }
  SetDummyInitFunctions(ZUF);
  
  { number of files to zip }
  ZipRec.argc := FileList.Count;

  { name of zip file - allocate room for null terminated string  }
  GetMem(ZipRec.lpszZipFN, Length(FileName) + 1 );
  ZipRec.lpszZipFN := StrPCopy( ZipRec.lpszZipFN, FileName);
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
    FreeMem(ZipRec.lpszZipFN, Length(FileName) + 1 );
  end;    

end;
{----------------------------------------------------------------------------------}
procedure SetDummyInitFunctions(var Z:TZipUserFunctions);
begin
  { prepare ZipUserFunctions structure }
  with Z do
  begin
    @Print     := @DummyPrint;
    @Comment   := @DummyComment;
    @Password  := @DummyPassword;
    @Service   := @DummyService;
  end;
  { send it to dll }
  ZpInit(Z);
end;
{----------------------------------------------------------------------------------}
function DummyPrint(Buffer: PChar; Size: ULONG): integer;
begin
  frmMain.Memo.Lines.Add(Buffer);
  Result := Size;
end;
{----------------------------------------------------------------------------------}
function DummyPassword(P: PChar; N: Integer; M, Name: PChar): integer;
begin
  Result := 1;
end;
{----------------------------------------------------------------------------------}
function DummyComment(Buffer: PChar): PChar;
begin
  Result := Buffer;
end;
{----------------------------------------------------------------------------------}
function DummyService(Buffer: PChar; Size: ULONG): integer;
begin
  frmMain.Memo.Lines.Add('> '+StrPas(Buffer));
  Result := 0;
end;


{ form's methods }
{----------------------------------------------------------------------------------
 here I use the dll's version info mechanism to get the information
 The Zip32.pas includes the function IsExpectedZipDllVersion: boolean;
 which checks both, the version number and the company name.
 I recommend to call the IsExpectedZipDllVersion function as the very
 first step to ensure that is the right dll and not any other with a
 similar name etc.
----------------------------------------------------------------------------------}
procedure TfrmMain.DisplayZipDllVersionInfo;
var
  S: string;
  ZipLibVer : TZpVer;
begin

  { get dll's version information }
  ZipLibVer.StructLen := ZPVER_LEN;
  ZpVersion(ZipLibVer);


  { display the information }
  with lboZipVersion.Items do
  begin
    Clear;
    Add('Flag         : ' + IntToStr(ZipLibVer.Flag) + ' [1: is_beta, ?: uses_zlib]');
    Add('BetaLevel    : ' + ZipLibVer.BetaLevel);
    Add('Date         : ' + ZipLibVer.Date);
    Add('ZLib_Version : ' + ZipLibVer.ZLib_Version);
    S := IntToStr(ZipLibVer.Zip.Major);
    S := S + '.' + IntToStr(ZipLibVer.Zip.Minor);
    Add('Zip          : ' + S);
    S := IntToStr(ZipLibVer.WinDll.Major);
    S := S + '.' + IntToStr(ZipLibVer.WinDll.Minor);
    Add('WinDll       : ' + S);
  end;
end;
{----------------------------------------------------------------------------------}
procedure TfrmMain.Get_ZipDllOptions;
var
  ZipOptions: TZPOpt;
begin
  { get the options from the dll }
  ZipOptions := ZpGetOptions;

  edtDate.Text           := ZipOptions.Date;
  edtRootDir.Text        := ZipOptions.szRootDir;
  edtTempDir.Text        := ZipOptions.szTempDir;
  chSuffix.Checked       := ZipOptions.fSuffix = True;
  chEncrypt.Checked      := ZipOptions.fEncrypt = True;
  chSystem.Checked       := ZipOptions.fSystem = True;
  chVolume.Checked       := ZipOptions.fVolume = True;
  chExtra.Checked        := ZipOptions.fExtra = True;
  chNoDirEntries.Checked := ZipOptions.fNoDirEntries = True;
  chExcludeDate.Checked  := ZipOptions.fExcludeDate = True;
  chIncludeDate.Checked  := ZipOptions.fIncludeDate = True;
  chVerbose.Checked      := ZipOptions.fVerbose = True;
  chQuiet.Checked        := ZipOptions.fQuiet = True;
  chCRLF_LF.Checked      := ZipOptions.fCRLF_LF = True;
  chLF_CRLF.Checked      := ZipOptions.fLF_CRLF = True;
  chJunkDir.Checked      := ZipOptions.fJunkDir = True;
  chGrow.Checked         := ZipOptions.fGrow = True;
  chForce.Checked        := ZipOptions.fForce = True;
  chMove.Checked         := ZipOptions.fMove = True;
  chDeleteEntries.Checked:= ZipOptions.fDeleteEntries = True;
  chUpdate.Checked       := ZipOptions.fUpdate = True;
  chFreshen.Checked      := ZipOptions.fFreshen = True;
  chJunkSFX.Checked      := ZipOptions.fJunkSFX = True;
  chLatestTime.Checked   := ZipOptions.fLatestTime = True;
  chComment.Checked      := ZipOptions.fComment = True;
  chOffsets.Checked      := ZipOptions.fOffsets = True;
  chPrivilege.Checked    := ZipOptions.fPrivilege = True;
  chEncryption.Checked   := ZipOptions.fEncryption = True;
  edtRecurse.Text        := IntToStr(ZipOptions.fRecurse);
  edtRepair.Text         := IntToStr(ZipOptions.fRepair);
  edtLevel.Text          := ZipOptions.fLevel;
end;
{----------------------------------------------------------------------------------}
procedure TfrmMain.Set_ZipDllOptions;
var
  ZipOptions : TZPOpt;
begin
(*
  ZipOptions.Date           := PChar(edtDate.Text);
  ZipOptions.szRootDir      := PChar(edtRootDir.Text);
  ZipOptions.szTempDir      := PChar(edtTempDir.Text);
*)
  ZipOptions.Date           := nil;
  ZipOptions.szRootDir      := nil;
  ZipOptions.szTempDir      := nil;
  ZipOptions.fSuffix        := chSuffix.Checked;
  ZipOptions.fEncrypt       := chEncrypt.Checked;
  ZipOptions.fSystem        := chSystem.Checked;
  ZipOptions.fVolume        := chVolume.Checked;
  ZipOptions.fExtra         := chExtra.Checked;
  ZipOptions.fNoDirEntries  := chNoDirEntries.Checked;
  ZipOptions.fExcludeDate   := chExcludeDate.Checked;
  ZipOptions.fIncludeDate   := chIncludeDate.Checked;
  ZipOptions.fVerbose       := chVerbose.Checked;
  ZipOptions.fQuiet         := chQuiet.Checked;
  ZipOptions.fCRLF_LF       := chCRLF_LF.Checked;
  ZipOptions.fLF_CRLF       := chLF_CRLF.Checked;
  ZipOptions.fJunkDir       := chJunkDir.Checked;
  ZipOptions.fGrow          := chGrow.Checked;
  ZipOptions.fForce         := chForce.Checked;
  ZipOptions.fMove          := chMove.Checked;
  ZipOptions.fDeleteEntries := chDeleteEntries.Checked;
  ZipOptions.fUpdate        := chUpdate.Checked;
  ZipOptions.fFreshen       := chFreshen.Checked;
  ZipOptions.fJunkSFX       := chJunkSFX.Checked;
  ZipOptions.fLatestTime    := chLatestTime.Checked;
  ZipOptions.fComment       := chComment.Checked;
  ZipOptions.fOffsets       := chOffsets.Checked;
  ZipOptions.fPrivilege     := chPrivilege.Checked;
  ZipOptions.fEncryption    := chEncryption.Checked;
  ZipOptions.fRecurse       := StrToInt(edtRecurse.Text);
  ZipOptions.fRepair        := StrToInt(edtRepair.Text);
  if edtLevel.Text = ''
    then ZipOptions.fLevel := '6'
    else ZipOptions.fLevel := edtLevel.Text[1];

  { send the options to the dll }
  if not ZpSetOptions(ZipOptions) then ShowMessage('Error setting Zip Options')
end;
{----------------------------------------------------------------------------------
 Description    : this message handler allows us to drag n drop files from Explorer
 NOTE           : for more info about this handler check the Win32.hlp for the
                  WM_DROPFILES, DragQueryFile, DragAcceptFiles and DragFinish topics
-----------------------------------------------------------------------------------}
procedure TfrmMain.WMDropFiles(var Msg: TMessage);
var
  hDrop    : THandle;
  FileName : array[0..254] of Char;
  iFiles   : integer;
  i        : integer;
begin
  hDrop  := Msg.WParam;
  iFiles := DragQueryFile(hDrop, $FFFFFFFF, FileName, 254);

  for i := 0 to iFiles - 1 do
  begin
    DragQueryFile(hDrop, i, FileName, 254);
    if (lboFilesToZip.Items.IndexOf(FileName) = -1)
    then lboFilesToZip.Items.Add(FileName);
  end;

  DragFinish(hDrop);
end;


{ event handlers }
{----------------------------------------------------------------------------------}
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  if not IsExpectedZipDllVersion then Application.Terminate;
  DisplayZipDllVersionInfo;
  { see WMDropFiles method comments }
  DragAcceptFiles(Handle, True);
end;
{----------------------------------------------------------------------------------}
procedure TfrmMain.btnGetOptionsClick(Sender: TObject);
begin
  Get_ZipDllOptions;
end;
{----------------------------------------------------------------------------------}
procedure TfrmMain.btnSetOptionsClick(Sender: TObject);
begin
  Set_ZipDllOptions;
end;
{----------------------------------------------------------------------------------}
procedure TfrmMain.btnSaveToClick(Sender: TObject);
begin
  if SaveDialog.Execute then edtZipFileName.Text := SaveDialog.FileName;
end;
{----------------------------------------------------------------------------------}
procedure TfrmMain.btnZipFilesClick(Sender: TObject);
begin
  Memo.Lines.Clear;
  ZipFiles(edtZipFileName.Text, lboFilesToZip.Items);
end;

end.










