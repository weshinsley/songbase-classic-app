unit FontConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, ComCtrls, StdCtrls, Appear,
  mbOfficeColorDialog;

type
  TFFontConfig = class(TForm)
    CBFont: TComboBox;
    FontTick: TCheckBox;
    SizeTick: TCheckBox;
    FontSize: TEdit;
    Label3: TLabel;
    UpDown1: TUpDown;
    SBold: TSpeedButton;
    BoldTick: TCheckBox;
    ItalTick: TCheckBox;
    SItalic: TSpeedButton;
    Label1: TLabel;
    PCol1: TPanel;
    PColf: TPanel;
    ForeTick: TCheckBox;
    LSample: TLabel;
    PSample: TPanel;
    BOK: TButton;
    ColorDialog2: TmbOfficeColorDialog;
    procedure FontTickClick(Sender: TObject);
    procedure ForeTickClick(Sender: TObject);
    procedure ItalTickClick(Sender: TObject);
    procedure PColfClick(Sender: TObject);
    procedure LfClick(Sender: TObject);
    procedure SizeTickClick(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure BoldTickClick(Sender: TObject);
    procedure SBoldClick(Sender: TObject);
    procedure SItalicClick(Sender: TObject);
    procedure BOKClick(Sender: TObject);
    procedure CBFontChange(Sender: TObject);
    procedure PCol1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    Font        : TFontInfo;
    Caption     : string;
    DefaultFont : TFontInfo;

    procedure UpdatePreview;
{    procedure ReadSettings( var bFontForce   : boolean; var sFontName : string;
                            var bSizeForce   : boolean; var uiSize    : cardinal;
                            var bBoldForce   : boolean; var bBold     : boolean;
                            var bItalicForce : boolean; var bItalic   : boolean;
                            var bColForce    : boolean; var hFGCol    : TColor );}
  end;

var
  FFontConfig: TFFontConfig;

implementation

{$R *.dfm}

procedure TFFontConfig.UpdatePreview;
var hFont  : TFontInfo;
    hStyle : TFontStyles;
    Code   : integer;
begin
  hFont  := DefaultFont;
  hStyle := [];

  if FontTick.Checked then hFont.Name   := CBFont.Items[CBFont.ItemIndex];
  if ForeTick.Checked then hFont.Color  := PColf.Color;
  if BoldTick.Checked then hFont.Bold   := SBold.Down;
  if ItalTick.Checked then hFont.Italic := SItalic.Down;
  if SizeTick.Checked then Val( FontSize.Text, hFont.Size, Code );

  if hFont.Bold   then include( hStyle, fsBold );
  if hFont.Italic then include( hStyle, fsItalic );

  LSample.Caption    := Caption;
  LSample.Font.Name  := hFont.Name;
  LSample.Font.Size  := hFont.Size;
  LSample.Font.Color := hFont.Color;
  LSample.Font.Style := hStyle;

  //  if FSettings.BackTick.Checked        then hBGCol := FSettings.PColb.Color;
end;


{procedure TFFontConfig.ReadSettings( var bFontForce   : boolean; var sFontName : string;
                                     var bSizeForce   : boolean; var uiSize    : cardinal;
                                     var bBoldForce   : boolean; var bBold     : boolean;
                                     var bItalicForce : boolean; var bItalic   : boolean;
                                     var bColForce    : boolean; var hFGCol    : TColor );
var Code : integer;
begin
  bFontForce   := FontTick.Checked;
  bSizeForce   := SizeTick.Checked;
  bBoldForce   := BoldTick.Checked;
  bItalicForce := ItalTick.Checked;
  bColForce    := ForeTick.Checked;

  sFontName    := CBFont.Items[CBFont.ItemIndex];
  Val( FontSize.Text, uiSize, Code );
  bBold   := SBold.Down;
  bItalic := SItalic.Down;
  hFGCol  := PColf.Color;
end;}

procedure TFFontConfig.FontTickClick(Sender: TObject);
begin
  CBFont.Enabled:=FontTick.Checked;
  UpdatePreview;
end;

procedure TFFontConfig.SizeTickClick(Sender: TObject);
begin
  FontSize.Enabled:=SizeTick.Checked;
  UpDown1.Enabled:=SizeTick.Checked;
  UpdatePreview;
end;

procedure TFFontConfig.ForeTickClick(Sender: TObject);
begin
  PColf.Visible := ForeTick.Checked;
  if ForeTick.Checked then begin
    PCol1.BevelInner := bvNone;
    PCol1.BevelOuter := bvRaised;
  end else begin
    PCol1.BevelInner := bvRaised;
    PCol1.BevelOuter := bvLowered;
  end;
  UpdatePreview;
end;

procedure TFFontConfig.BoldTickClick(Sender: TObject);
begin
  SBold.Enabled:=BoldTick.Checked;
  UpdatePreview;
end;

procedure TFFontConfig.ItalTickClick(Sender: TObject);
begin
  SItalic.Enabled:=ItalTick.Checked;
  UpdatePreview;
end;

procedure TFFontConfig.PColfClick(Sender: TObject);
begin
  if PColf.Visible then begin
    if ColorDialog2.Execute(PColF.Color) then PColF.Color:=Colordialog2.SelectedColor;
    UpdatePreview;
  end;
end;

procedure TFFontConfig.LfClick(Sender: TObject);
begin
  PColfClick(Sender);
end;

procedure TFFontConfig.UpDown1Click(Sender: TObject; Button: TUDBtnType);
var S : string;
begin
  str(UpDown1.Position,S);
  FontSize.Text:=S;
  UpdatePreview;
end;

procedure TFFontConfig.SBoldClick(Sender: TObject);
begin
  UpdatePreview;
end;

procedure TFFontConfig.SItalicClick(Sender: TObject);
begin
  UpdatePreview;
end;

procedure TFFontConfig.BOKClick(Sender: TObject);
begin
  close;
end;

procedure TFFontConfig.CBFontChange(Sender: TObject);
begin
  UpdatePreview;
end;

procedure TFFontConfig.PCol1Click(Sender: TObject);
begin
  PColfClick(Sender);
end;

procedure TFFontConfig.FormShow(Sender: TObject);
begin
  FontTick.Checked  := Font.ForceName;
  SizeTick.Checked  := Font.ForceSize;
  BoldTick.Checked  := Font.ForceBold;
  ItalTick.Checked  := Font.ForceItalic;
  ForeTick.Checked  := Font.ForceColor;

  CBFont.ItemIndex := CBFont.Items.IndexOf( Font.Name );
  if -1 = CBFont.ItemIndex then CBFont.ItemIndex := CBFont.Items.IndexOf( DefaultFont.Name );
  if -1 = CBFont.ItemIndex then CBFont.ItemIndex := 0;
  FontSize.Text := IntToStr(Font.Size);
  SBold.Down    := Font.Bold;
  SItalic.Down  := Font.Italic;
  PColf.Color   := Font.Color;

  PColf.Visible := Font.ForceColor;
  if Font.ForceColor then begin
    PCol1.BevelInner := bvNone;
    PCol1.BevelOuter := bvRaised;
  end else begin
    PCol1.BevelInner := bvRaised;
    PCol1.BevelOuter := bvLowered;
  end;

  UpdatePreview;
end;

procedure TFFontConfig.FormClose(Sender: TObject;
  var Action: TCloseAction);
var Code : integer;
begin
  Font.ForceName   := FontTick.Checked;
  Font.ForceSize   := SizeTick.Checked;
  Font.ForceBold   := BoldTick.Checked;
  Font.ForceItalic := ItalTick.Checked;
  Font.ForceColor  := ForeTick.Checked;

  Font.Name        := CBFont.Items[CBFont.ItemIndex];
  Val( FontSize.Text, Font.Size, Code );
  Font.Bold        := SBold.Down;
  Font.Italic      := SItalic.Down;
  Font.Color       := PColf.Color;
end;

end.
