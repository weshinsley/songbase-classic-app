unit OHPPrint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TFPOHP = class(TForm)
    RB1: TRadioButton;
    RBA: TRadioButton;
    BPrint: TButton;
    BCancel: TButton;
    procedure RBAClick(Sender: TObject);
    procedure RB1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
    procedure BPrintClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    Ok : boolean;
    posX,posY : integer;
    { Public declarations }
  end;

var
  FPOHP: TFPOHP;

implementation

{$R *.DFM}

procedure TFPOHP.RBAClick(Sender: TObject);
begin
  RB1.Checked:=false;
end;

procedure TFPOHP.RB1Click(Sender: TObject);
begin
  RBa.Checked:=false;
end;



procedure TFPOHP.FormActivate(Sender: TObject);
begin
  ok:=false;
end;

procedure TFPOHP.BCancelClick(Sender: TObject);
begin
  close;
end;

procedure TFPOHP.BPrintClick(Sender: TObject);
begin
  ok:=true;
  close;
end;

procedure TFPOHP.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  posX:=left;
  posY:=top;
end;

procedure TFPOHP.FormShow(Sender: TObject);
begin
  top:=posY;
  left:=posX;
end;

end.
