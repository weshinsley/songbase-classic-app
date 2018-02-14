unit LinkDesc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFLinkDesc = class(TForm)
    EDescription: TEdit;
    BOK: TButton;
    BCancel: TButton;
    LDescription: TLabel;
    procedure BCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    posX,posY : integer;
    Description : string;
  end;

var
  FLinkDesc: TFLinkDesc;

implementation

{$R *.DFM}

procedure TFLinkDesc.BCancelClick(Sender: TObject);
begin
  close;
end;

procedure TFLinkDesc.FormActivate(Sender: TObject);
begin
  EDescription.Text:=Description;
end;

procedure TFLinkDesc.BOKClick(Sender: TObject);
begin
  Description:=EDescription.Text;
  close;
end;

procedure TFLinkDesc.FormShow(Sender: TObject);
begin
  top:=posY;
  left:=posX;
end;

end.
