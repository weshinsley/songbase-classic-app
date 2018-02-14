unit Search;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TFSearch = class(TForm)
    ESearchText: TEdit;
    LText: TLabel;
    BOk: TButton;
    BCancel: TButton;
    CBOHPSearch: TCheckBox;
    LKey: TLabel;
    CKey: TComboBox;
    CMM: TComboBox;
    CCapo: TComboBox;
    LCapo: TLabel;
    LTempo: TLabel;
    CTempo: TComboBox;
    Panel1: TPanel;
    BOptions: TButton;
    procedure BCancelClick(Sender: TObject);
    procedure BOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ESearchTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure BOptionsClick(Sender: TObject);
    procedure ESearchTextEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    // Used to keep this window off the projection screen
    procedure WMWindowPosChanging(var hMsg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
  public
    bShowOptions : boolean;
    SearchText : string;
    CRec,posX,posY : integer;
    Entered : boolean;
    SAdvanced, SSimple : string;
  
    { Public declarations }
  end;

var
  FSearch: TFSearch;

implementation

uses SearchResults, SBMain, EditProj;

{$R *.DFM}

procedure TFSearch.BCancelClick(Sender: TObject);
begin
  SearchTexT:='';
  Entered:=false;
  close;
end;

procedure TFSearch.BOkClick(Sender: TObject);
begin
  SearchText:=ESearchText.Text;
  Entered:=true;
  CRec:=0;
  close;
end;

procedure TFSearch.FormActivate(Sender: TObject);
begin
  ESearchText.SelectAll;
end;

procedure TFSearch.ESearchTextKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then BCancelClick(Sender);
  if Key=VK_RETURN then BOkClick(Sender);
end;

procedure TFSearch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  posX:=left;
  posY:=top;
end;

procedure TFSearch.FormShow(Sender: TObject);
begin
  top:=posY;
  left:=posX;
  Height := BOptions.Top + BOptions.Height + (Height - ClientRect.Bottom);
  if FSearchResults.Visible then
    FSearchResults.Hide;

  // If the options are not being shown then reset the hidden ones to 'don't care'
  bShowOptions := not bShowOptions;
  BOptionsClick(Sender);
  ESearchText.SetFocus;
end;

procedure TFSearch.BOptionsClick(Sender: TObject);
begin
  bShowOptions := not bShowOptions;
  if bShowOptions then begin
    Height := Panel1.Top + Panel1.Height + (Height - ClientRect.Bottom);
    BOptions.Caption := SSimple;
  end else begin
    CCapo.ItemIndex  := 0;
    CKey.ItemIndex   := 0;
    CMM.ItemIndex    := 0;
    CTempo.ItemIndex := 0;
    Height := BOptions.Top + BOptions.Height + (Height - ClientRect.Bottom);
    BOptions.Caption := SAdvanced;
  end;
  ESearchText.SetFocus;
end;

procedure TFSearch.ESearchTextEnter(Sender: TObject);
begin
  ESearchText.SelectAll;
end;

procedure TFSearch.FormCreate(Sender: TObject);
begin
  bShowOptions := false;
  SAdvanced    := 'Advanced >>';
  SSimple      := '<< Simple';
end;

procedure TFSearch.WMWindowPosChanging(var hMsg: TWMWindowPosChanging);
var rBadRect, rCurRect : TRect;
var ptBadCentre : TPoint;
begin
  // Only restrict access once projection form is visible
  if FSongbase.BProjectReady and FProjWin.Visible then begin
    // Get the desktop rectangle that we don't want to let this screen have
    // any intersections with.
    rBadRect := Rect( FSongBase.ptDisplayOrigin.X,
                      FSongBase.ptDisplayOrigin.Y,
                      FSongBase.ptDisplayOrigin.X + FSongBase.szDisplaySize.cx,
                      FSongBase.ptDisplayOrigin.Y + FSongBase.szDisplaySize.cy );
    rCurRect := Rect( hMsg.WindowPos.x, hMsg.WindowPos.y,
                      hMsg.WindowPos.x + Width, hMsg.WindowPos.y + Height );

    // Work out centre of 'illegal' area so we can work out which side to push off
    ptBadCentre.X := FSongBase.ptDisplayOrigin.X + (FSongBase.szDisplaySize.cx div 2);
    ptBadCentre.Y := FSongBase.ptDisplayOrigin.Y + (FSongBase.szDisplaySize.cy div 2);

    // And do the logic to prevent overlap in X
    if (rCurRect.Right < ptBadCentre.X) and (rCurRect.Right > rBadRect.Left) then begin
      rCurRect.Left  := rBadRect.Left - (rCurRect.Right - rCurRect.Left);
      rCurRect.Right := rBadRect.Left;
    end;
    if (rCurRect.Left > ptBadCentre.X) and (rCurRect.Left < rBadRect.Right) then begin
      rCurRect.Right := rBadRect.Right + (rCurRect.Right - rCurRect.Left);
      rCurRect.Left  := rBadRect.Right;
    end;

    hMsg.WindowPos.x := rCurRect.Left;
    hMsg.WindowPos.y := rCurRect.Top;
  end;
  inherited;
end;

end.
