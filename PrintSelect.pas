unit PrintSelect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SBFiles,SBMain;

type
  TFPrintSelect = class(TForm)
    PCOHP: TCheckBox;
    PCPrint: TCheckBox;
    PCRec: TCheckBox;
    PCAll: TCheckBox;
    Label1: TLabel;
    BOk: TButton;
    BCancel: TButton;
    PCBReport: TComboBox;
    Label2: TLabel;
    PCPhoto: TCheckBox;
    PCBPreview: TCheckBox;
    PCTrans: TCheckBox;
    procedure PCAllClick(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
    procedure BOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    Result : boolean;
    posX,posY : integer;
    { Public declarations }
  end;

var
  FPrintSelect: TFPrintSelect;

implementation

{$R *.DFM}

procedure TFPrintSelect.PCAllClick(Sender: TObject);
begin
  PCOHP.Enabled:=not PCAll.Checked;
  PCPrint.Enabled:=not PCAll.Checked;
  PCRec.Enabled:=not PCAll.Checked;
  PCPhoto.Enabled:=not PCAll.Checked;
  PCTrans.Enabled:=not PCAll.Checked;
end;

procedure TFPrintSelect.BCancelClick(Sender: TObject);
begin
  Result:=false;
  SaveParams(INIFile);
  close;
end;

procedure TFPrintSelect.BOkClick(Sender: TObject);
begin
  Result:=true;
  SaveParams(INIFile);
  close;
end;

procedure TFPrintSelect.FormActivate(Sender: TObject);
begin
  if PCBReport.ItemIndex=-1 then PCBReport.ItemIndex:=0;
end;

procedure TFPrintSelect.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  posX:=left;
  posY:=top;
end;

procedure TFPrintSelect.FormShow(Sender: TObject);
begin
  top:=posY;
  left:=posX;
end;

end.
