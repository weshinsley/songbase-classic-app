unit LinkForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFLinkForm = class(TForm)
    BLocate: TButton;
    ELocation: TEdit;
    EDescription: TEdit;
    LDescription: TLabel;
    LLocation : TLabel;
    BOK: TButton;
    BCancel: TButton;
    procedure BCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BLocateClick(Sender: TObject);
    procedure BOKClick(Sender: TObject);
    procedure ELocationChange(Sender: TObject);
    procedure EDescriptionChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    Mode : byte;
    Description : string;
    Location: String;
    posX,posY : integer;
    { Public declarations }
  end;

var
  FLinkForm: TFLinkForm;
implementation

uses SBMain;

{$R *.DFM}

procedure TFLinkForm.BCancelClick(Sender: TObject);
begin
  Description:='';
  EDescription.Text:='';
  Location:='';
  ELocation.Text:='';
  close;
end;

procedure TFLinkForm.FormActivate(Sender: TObject);
begin
  Description:='';
  Location:='';
  if Mode=1 then begin
    BLocateClick(Sender);
    ELocationChange(Sender);
    EDescription.SetFocus;
    EDescription.SelectAll;
    Mode:=0;
  end;
end;

procedure TFLinkForm.BLocateClick(Sender: TObject);
  var extend : String;
  StoreFile : String;
begin
  FSongbase.FileOpen.Filter:='All Files|*.*';
  if (FSongbase.FileOpen.Execute) then begin
    ELocation.Text:=FSongbase.FileOpen.FileName;
  end;
  extend:='';
  StoreFile:=ELocation.Text;
  while (pos('.',StoreFile)>0) do begin
    extend:=Storefile[length(Storefile)]+extend;
    Storefile:=copy(Storefile,1,length(Storefile)-1);
  end;

  if (EDescription.Text='') then
    EDescription.Text:=FSongbase.ETitle.Text+ ' - '+extend;
  ELocationChange(Sender);
end;

procedure TFLinkForm.BOKClick(Sender: TObject);
begin
  Description:=EDescription.text;
  Location:=ELocation.text;
  close;
end;

procedure TFLinkForm.ELocationChange(Sender: TObject);
begin
  BOK.Enabled:=(ELocation.Text<>'') and (EDescription.Text<>'') and (FileExists(ELocation.Text));
end;

procedure TFLinkForm.EDescriptionChange(Sender: TObject);
begin
  BOK.Enabled:=(ELocation.Text<>'') and (EDescription.Text<>'');
end;

procedure TFLinkForm.FormShow(Sender: TObject);
begin
  top:=posY;
  left:=posX;
end;

end.
