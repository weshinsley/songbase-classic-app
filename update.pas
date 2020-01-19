unit update;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtActns;

type
  TFUpdate = class(TForm)
    MUpdateVerText: TMemo;
    BUpdateVer: TButton;
    BUpdateLater: TButton;
    LUpdateVer: TLabel;
    PBUpdate: TProgressBar;
    LAction: TLabel;

    procedure BUpdateLaterClick(Sender: TObject);
    procedure BUpdateVerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function BetterDownloadFile(strRemoteFileName, strLocalFileName : string) : integer;

  private
     procedure URL_OnDownloadProgress
        (Sender: TDownLoadURL;
         Progress, ProgressMax: Cardinal;
         StatusCode: TURLDownloadStatus;
         StatusText: String; var Cancel: Boolean) ;
  public
    { Public declarations }
   Files : TStringList;
   Dests : TStringList;
  end;

var
  FUpdate: TFUpdate;

implementation

uses SBMain;

{$R *.dfm}

procedure TFUpdate.URL_OnDownloadProgress;
begin
   PBUpdate.Max:=ProgressMax;
   PBUpdate.Position:=Progress;
end;

function TFUpdate.BetterDownloadFile(strRemoteFileName, strLocalFileName : string) : integer;
var res : integer;
begin
  LAction.Caption:='Downloading '+strLocalFileName+'...';
  LAction.Update;
  res:=0;
  if (FileExists('tmp.download')) then deletefile('tmp.download');
  if (FileExists('tmp.replace')) then deletefile('tmp.replace');
  with TDownloadURL.Create(self) do begin
    try
      URL:='https://www.teapotrecords.co.uk/bfree/Songbase/'+strRemoteFileName+'?d='+DateTimeToStr(Now);
      FileName := 'tmp.download';
      OnDownloadProgress := URL_OnDownloadProgress;
      ExecuteTarget(nil);
    except
      res:=999
    end;

    Free;
  end;
  if (FileExists(strLocalFileName+'.preupdate')) then DeleteFile(strLocalFileName+'.preupdate');
  RenameFile(strLocalFileName,strLocalFileName+'.preupdate');
  RenameFile('tmp.download',strLocalFileName);
  BetterDownloadFile:=res;
end;

procedure TFUpdate.BUpdateLaterClick(Sender: TObject);
begin
  close;
end;

procedure TFUpdate.BUpdateVerClick(Sender: TObject);
var i : integer;
begin
  BUpdateVer.Enabled:=false;
  BUpdateLater.Enabled:=false;
  BUpdateVer.Update;
  BUpdateLater.Update;
  for i:=0 to Files.Count-1 do begin
    BetterDownloadFile(Files[i],Dests[i]);
  end;
  messagedlg('Update done - Songbase will now restart',mtInformation,[mbOk],0);
  winexec('songbase.exe',SW_NORMAL);
  close;
  FSongbase.close;
end;

procedure TFUpdate.FormCreate(Sender: TObject);
begin
  Files:=TStringList.Create;
  Dests:=TStringList.Create;
end;

end.
