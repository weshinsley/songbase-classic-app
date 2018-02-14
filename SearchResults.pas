unit SearchResults;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls, StdCtrls, SearchThread, SBFiles;

type
  TFSearchResults = class(TForm)
    DrawGrid1: TDrawGrid;
    ProgressBar1: TProgressBar;
    RichEdit1: TRichEdit;
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      rRect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SearchComplete;
    procedure DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure DrawGrid1MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure DrawGrid1MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure DrawGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DrawGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
    auiIDs         : array of integer;
    auiPages       : array of integer;
    aasCaptions    : array of array[0..3] of string;
    auiSelectStart : array of array[0..3] of integer;
    auiSelectEnd   : array of array[0..3] of integer;
    iResultCount   : integer;
    SearchThread   : TTSearchThread;
    bEnableSelect  : boolean;

    // Used to keep this window off the projection screen
    procedure WMWindowPosChanging(var hMsg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
  public
    { Public declarations }
    posX, posY : integer;
    SSearchStart, SSearchResult, SSearchComplete : string;

    procedure AddRecord( iRecord, iPage : integer; hCurrent : SongRecord; sText : string; aSelectStart : array of integer; aSelectEnd : array of integer );
    procedure RemoveFromResults( iID : integer );
  end;

var
  FSearchResults: TFSearchResults;

implementation

uses SBMain, Search, PreviewWindow, EditProj;

{$R *.dfm}

procedure TFSearchResults.DrawGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; rRect: TRect; State: TGridDrawState);
const
  CELLPADDING = 2;
var
  iPenPosX   : integer;
  iPenPosY   : integer;
  S          : string;
  iStartBold : integer;
  iEndBold   : integer;
  iLength    : integer;
  sCaption   : string;
begin
  if ARow <= iResultCount then begin
    iPenPosX   := rRect.Left + CELLPADDING;
    iPenPosY   := rRect.Top  + CELLPADDING;
    iStartBold := auiSelectStart[ARow][ACol];
    iEndBold   := auiSelectEnd[ARow][ACol];
    sCaption   := aasCaptions[ARow][ACol];
    iLength    := length(sCaption);

    if ACol = 2 then begin
      iPenPosX := iPenPosX + (DrawGrid1.Canvas.TextWidth(sCaption) div 2) - 1;
    end;

    with DrawGrid1.Canvas do begin
      if iStartBold > 0 then begin
        Font.Style := [];
        S := Copy( sCaption, 0, iStartBold-1 );
        rRect.Left := iPenPosX;
        TextRect( rRect, iPenPosX, iPenPosY, S );
        iPenPosX := iPenPosX + TextWidth(S);
      end;
      if iEndBold > 0 then begin
        Font.Style := [fsBold];
        S := Copy( sCaption, iStartBold, iEndBold - iStartBold );
        rRect.Left := iPenPosX;
        TextRect( rRect, iPenPosX, iPenPosY, S );
        iPenPosX := iPenPosX + TextWidth(S);
      end;
      Font.Style := [];
      S := Copy( sCaption, iEndBold, 1+iLength - iEndBold );
      rRect.Left := iPenPosX;
      TextRect( rRect, iPenPosX, iPenPosY, S );
    end;
  end;
end;

procedure TFSearchResults.FormCreate(Sender: TObject);
begin
  setlength( aasCaptions, 1 );
  setlength( auiSelectStart, 1);
  setlength( auiSelectEnd, 1);
  aasCaptions[0][0] := 'Title';
  aasCaptions[0][1] := 'Author';
  aasCaptions[0][2] := 'P';
  aasCaptions[0][3] := 'Text';

  SSearchStart    := 'Searching for "%s"';
  SSearchResult   := 'Searching for "%s" (%d Results...)';
	SSearchComplete := 'Search Complete for "%s" (%d Results...)';
end;

procedure TFSearchResults.FormShow(Sender: TObject);
var
 myRect: TGridRect;
 S : string;
begin
  Top  := posY;
  Left := posX;
  RichEdit1.Width := 1280;
  RichEdit1.Height := 1024;

  iResultCount := 0;
  setlength( aasCaptions, 1 );
  setlength( auiSelectStart, 1);
  setlength( auiSelectEnd, 1);

  DrawGrid1.RowCount := 2;
  ProgressBar1.Visible := true;
  ProgressBar1.Top := DrawGrid1.BoundsRect.Bottom + 5;
  FmtStr( S, SSearchStart, [FSearch.ESearchText.Text] );
  Caption := S;
  Height  := 93;

  // Unselect any rows...
  myRect.Left   := 0;
  myRect.Top    := MaxLongInt;
  myRect.Right  := 0;
  myRect.Bottom := MaxLongInt;
  DrawGrid1.Selection := myRect;
  bEnableSelect := false;

  // Trigger off the Searcher thread...
  SearchThread := TTSearchThread.Create(true);
  with SearchThread do begin
    RemoteSearch    := false;
    FileName        := SBMain.FileName;
    QuickSearchFile := SBMain.QSFile;
    OHPFile         := SBMain.OHPFile;
    TempDir         := SBMain.TempDir;
    PRichEditCtrl   := @RichEdit1;
    with FSearch do begin
      SearchStr       := ESearchText.Text;
      iMusicKeyIdx    := CKey.ItemIndex;
      iMusicScaleIdx  := CMM.ItemIndex;
      iMusicCapoIdx   := CCapo.ItemIndex;
      iMusicTempoIdx  := CTempo.ItemIndex;
      bSearchRTF      := CBOHPSearch.Checked;
      bAdvanced       := bShowOptions;
    end;
  end;
  SearchThread.Suspended := false;
end;

procedure TFSearchResults.AddRecord( iRecord, iPage : integer; hCurrent : SongRecord; sText : string; aSelectStart : array of integer; aSelectEnd : array of integer );
var iSelected, iHeight : integer;
    myRect: TGridRect;
    S : string;
begin
  iSelected := DrawGrid1.Row;
  inc( iResultCount );
  setlength( auiIDs,         1+iResultCount );
  setlength( auiPages,       1+iResultCount );
  setlength( aasCaptions,    1+iResultCount );
  setlength( auiSelectStart, 1+iResultCount );
  setlength( auiSelectEnd,   1+iResultCount );
  aasCaptions[iResultCount][0] := hCurrent.Title;
  aasCaptions[iResultCount][1] := hCurrent.Author;
  aasCaptions[iResultCount][3] := sText;
  if iPage > 0 then
    aasCaptions[iResultCount][2] := IntToStr(iPage);
  auiIDs[iResultCount] := iRecord;
  if 0 = iPage then iPage := 1;
  auiPages[iResultCount] := iPage;

  // Copy the selection ranges
  auiSelectStart[iResultCount][0] := aSelectStart[0];
  auiSelectStart[iResultCount][1] := aSelectStart[1];
  auiSelectStart[iResultCount][3] := aSelectStart[2];
  auiSelectEnd[iResultCount][0]   := aSelectEnd[0];
  auiSelectEnd[iResultCount][1]   := aSelectEnd[1];
  auiSelectEnd[iResultCount][3]   := aSelectEnd[2];
  DrawGrid1.RowCount := 1+iResultCount;

  // Unselect any rows...
 if( iSelected = MaxLongInt ) then begin
    // Unselect any rows...
    myRect.Left   := 0;
    myRect.Top    := MaxLongInt;
    myRect.Right  := 0;
    myRect.Bottom := MaxLongInt;
    DrawGrid1.TopRow := 1;
    DrawGrid1.Selection := myRect;
  end else begin
    DrawGrid1.Row := iSelected;
  end;

  // Adjust drawgrid height to accomodate contents, but not until there's at least one entry.
  iHeight := 93 + ((1 + DrawGrid1.RowHeights[1]) * iResultCount);
  if iHeight > 400 then
    iHeight := 400;
  Height := iHeight;
  FmtStr( S, SSearchResult, [ FSearch.ESearchText.Text, IntToStr(iResultCount) ] );
  Caption := S;
end;

procedure TFSearchResults.SearchComplete;
var iHeight : integer;
    S : string;
begin
  FmtStr( S, SSearchComplete, [ FSearch.ESearchText.Text, IntToStr(iResultCount) ] );
  Caption := S;
  ProgressBar1.Visible := false;
  iHeight := 95 + ((1 + DrawGrid1.RowHeights[1]) * iResultCount);
  if iHeight > 400 then
    iHeight := 400;
  Height := iHeight;
  FormResize(FSearchResults);
end;

procedure TFSearchResults.DrawGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if bEnableSelect and (ARow < DrawGrid1.RowCount) and (ARow > 0) then begin
    // The song is actually loaded in the event handler for the 'set position'...
    FSongBase.SBRecNo.Position := auiIDs[ARow];
    if (auiPages[ARow] <> 1) then begin
      if (ACol >= 2) or (
          (auiSelectStart[ARow][0] = 0) and (auiSelectStart[ARow][1] = 0)) then begin
        FPreviewWindow.LoadOHP( FSongBase.EID.Text, auiPages[ARow] );
      end;
    end;
  end;
end;

procedure TFSearchResults.DrawGrid1MouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  bEnableSelect := true;
  if DrawGrid1.Row = MaxLongInt then begin
    DrawGrid1.Row := DrawGrid1.RowCount -1;
    Handled       := true;
  end;
end;

procedure TFSearchResults.DrawGrid1MouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  bEnableSelect := true;
  if DrawGrid1.Row = MaxlongInt then begin
    DrawGrid1.Row := 1;
    Handled       := true;
  end;
end;

procedure TFSearchResults.FormResize(Sender: TObject);
begin
  if ProgressBar1.Visible then begin
    ProgressBar1.Top := ClientRect.Bottom - ProgressBar1.Height - 6;
    DrawGrid1.Height := ProgressBar1.Top - 5;
  end else begin
    DrawGrid1.Height := ClientRect.Bottom - 15;
  end;
end;

procedure TFSearchResults.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  NewWidth := DrawGrid1.Width + 20;
end;

procedure TFSearchResults.DrawGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  bEnableSelect := true;
end;

procedure TFSearchResults.DrawGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var bEnable : boolean;
begin
  bEnable       := bEnableSelect;
  bEnableSelect := true;
  if bEnable and (DrawGrid1.Row <> MaxlongInt) and (VK_RETURN=Key) then begin
    Close;
  end;
  if not bEnable and (DrawGrid1.Row = MaxlongInt) then begin
    if (VK_RETURN = Key) then DrawGrid1.Row := 1;
  end;
end;

procedure TFSearchResults.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  posY := Top;
  posX := Left;
end;


procedure TFSearchResults.WMWindowPosChanging(var hMsg: TWMWindowPosChanging);
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

procedure TFSearchResults.DrawGrid1DblClick(Sender: TObject);
begin
  // Select cell should have already fired
  Close;
end;

procedure TFSearchResults.RemoveFromResults( iID : integer );
var iRow, iCol : integer;
    bRemoved : boolean;
begin
  bRemoved := false;
  for iRow := 1 to iResultCount do
  begin
    if auiIDs[iRow] = iID then begin
      bRemoved := true;
    end;

    if bRemoved and (iRow < iResultCount) then
    begin
      auiIDs[iRow] := auiIDs[1+iRow];
      auiPages[iRow] := auiPages[1+iRow];
      for iCol := 0 to 3 do begin
        aasCaptions[iRow][iCol]    := aasCaptions[1+iRow][iCol];
        auiSelectStart[iRow][iCol] := auiSelectStart[1+iRow][iCol];
        auiSelectEnd[iRow][iCol]   := auiSelectEnd[1+iRow][iCol];
      end;
    end;

    if auiIDs[iRow] > iID then begin
      auiIDs[iRow] := auiIDs[iRow] - 1;
    end;

    if bRemoved and (iRow = iResultCount-1) then Break;
  end;

  if bRemoved then begin
    setlength( auiIDs,         iResultCount );
    setlength( auiPages,       iResultCount );
    setlength( aasCaptions,    iResultCount );
    setlength( auiSelectStart, iResultCount );
    setlength( auiSelectEnd,   iResultCount );
    DrawGrid1.RowCount      := iResultCount;
    dec( iResultCount );
    DrawGrid1.Invalidate;
    SearchComplete;
  end;
end;

end.
