unit About;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TFAbout = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PChanges: TPanel;
    MReadme: TMemo;
    BVersionInfo: TButton;
    CheckFor: TLabel;
    BToDo: TButton;
    procedure OKButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BVersionInfoClick(Sender: TObject);
    procedure BToDoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
  public
    posX,posY : integer;
    
  end;

var
  FAbout: TFAbout;

implementation

uses SBMain, ShellApi;

{$R *.DFM}

procedure TFAbout.OKButtonClick(Sender: TObject);
begin
  close;
end;

procedure TFAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  posY:=top;
  posX:=left;
end;

procedure TFAbout.BVersionInfoClick(Sender: TObject);
begin
  if PChanges.Visible = False then begin
    MReadme.Lines.LoadFromFile( SBMain.RunDir+'CHANGES.TXT' );
    PChanges.Visible := True;
    PChanges.BringToFront();
  end else begin
    PChanges.Visible := False;
  end;
end;

procedure TFAbout.BToDoClick(Sender: TObject);
begin
  MReadme.Lines.LoadFromFile( SBMain.RunDir+'TODO.TXT' );
  PChanges.Visible := True;
  PChanges.BringToFront();
end;

procedure TFAbout.FormShow(Sender: TObject);
begin
  Version.Caption := 'version ' + VERSION_NAME + ' - ' + VERSION_DATE;
  top:=posY;
  left:=posX;
end;

procedure TFAbout.Label2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open',
    'https://www.teapotrecords.co.uk',nil,nil, SW_SHOWNORMAL);
end;

procedure TFAbout.Label1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open',
    'mailto:songbase@teapotrecords.co.uk',nil,nil, SW_SHOWNORMAL);
end;

end.

