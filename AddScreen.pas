unit AddScreen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdHTTP;

type
  TestHttpThread = class(TThread)
  private
  public
    procedure Execute; override;
  end;
  TFAddScreen = class(TForm)
    BOk: TButton;
    BCancel: TButton;
    BTestScreens: TButton;
    LPort: TLabel;
    EPort: TEdit;
    EServer: TEdit;
    LServer: TLabel;
    procedure BOkClick(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
    procedure EServerChange(Sender: TObject);
    procedure EPortChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
   public
    server : string;
    port : integer;
  end;

var
  FAddScreen: TFAddScreen;

implementation

uses WebServer;

{$R *.dfm}

procedure TestHttpThread.Execute;
var Result : string;
    http : TIdHTTP;
begin
  http:=TIdHTTP.Create(FWebServer);
  try
//    Result:=http.Post(url,postage);
  except
  end;
//  postage.free;
  http.free;

end;
procedure TFAddScreen.BOkClick(Sender: TObject);
var p : integer;
    code : integer;
begin
  server:=EServer.Text;
  val(EPort.text,port,code);
  close;
end;

procedure TFAddScreen.BCancelClick(Sender: TObject);
begin
  server:='';
  port:=-1;
  close;
end;

procedure TFAddScreen.EServerChange(Sender: TObject);
begin
  EPortChange(sender);
end;

procedure TFAddScreen.EPortChange(Sender: TObject);
var valid : boolean;
    code,p : integer;
begin
  valid:=true;
  val(EPort.Text,p,code);
  if (code<>0) then valid:=false;
  if (EPort.Text='') then valid:=false;
  if (EServer.Text='') then valid:=false;
  BOk.Enabled:=valid;
end;
procedure TFAddScreen.FormActivate(Sender: TObject);
begin
  Eserver.text:='http://';
  Eport.text:='8080';
  port:=-1;
  server:='';

end;
end.
