unit ConfigOffsets;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons;

type
  TFConfigOffsets = class(TForm)
    btClose: TButton;
    LCCLIDesc: TLabel;
    LCopyDesc: TLabel;
    MainOffsetTL: TLabel;
    LCopy2: TLabel;
    LCCLI2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure BCCLIChangeClick(Sender: TObject);
    procedure BCopyChangeClick(Sender: TObject);
    procedure BMainChangeClick(Sender: TObject);
    procedure BMoveRightClick(Sender: TObject);
    procedure BMoveUpClick(Sender: TObject);
    procedure BMoveDownClick(Sender: TObject);
    procedure BMoveLeftClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainOffsetTLMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainOffsetTLMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure LCopyDescMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure LCopyDescMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LCCLIDescMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LCCLIDescMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure HandlerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    Moving     : TControl;
    pptOffsets : ^TPoint;
    bReady     : boolean;
  public
    { Public declarations }
    rOffsets, rScreenArea, rDrawArea, rCCLIArea, rCopyArea : TRect;

    STop, SLeft, SRight, SBottom : string;
    SClose, SDone, SCCLI, SCopy, SMain : string;
    iSelected, iOver : integer;
    iSideX, iSideY   : integer;
    rClickOffset     : TRect;

    aCaptions : array[1..3] of TLabel;
    aRects    : array[1..3] of PRect;

    procedure UpdateOffsets;
    procedure UpdateFontInfo;
    procedure ShowOnly( aSelected : array of TControl );
    procedure ShowAll;
    function  isIn( hObj : TControl; aArr : array of TControl ) : boolean;
    procedure SetMoveButtons( Sender: TControl );
    procedure MoveMe( iHoriz, iVert : integer );
    procedure OnAppMsg(var Msg: TMsg; var Handled: Boolean);
  end;

var
  FConfigOffsets: TFConfigOffsets;

const
  TEXT_SPACE   = 10;
  BEVEL_TEXT_SPACE = 4;
  BUTTON_SPACE = 5;
  ARROW_SPACE  = 2;
  BORDER_SPACE = 1;

implementation

uses Appear, FontConfig, Math, SBMain;

{$R *.dfm}

procedure TFConfigOffsets.FormShow(Sender: TObject);
var
  iX, iY : integer;
begin
  SetBounds( 0, 0, Screen.Width, Screen.Height );
  Color := $404040;

  iX := (Width  - FSongbase.szDisplaySize.cx) div 2;
  iY := (Height - FSongbase.szDisplaySize.cy) div 2;

  rScreenArea := Rect( iX, iY,
                       iX + FSongbase.szDisplaySize.cx,
                       iY + FSongbase.szDisplaySize.cy );
  Moving       := nil;
  bReady       := false;

  aCaptions[1] := MainOffsetTL;
  aCaptions[2] := LCCLI2;
  aCaptions[3] := LCopy2;

  rDrawArea    := FSongbase.rTextArea;
  rCopyArea    := FSongbase.rCopyArea;
  rCCLIArea    := FSongbase.rCCLIArea;
  OffsetRect( rDrawArea, rScreenArea.Left, rScreenArea.Top );
  OffsetRect( rCCLIArea, rScreenArea.Left, rScreenArea.Top );
  OffsetRect( rCopyArea, rScreenArea.Left, rScreenArea.Top );

  aRects[1]    := @rDrawArea;
  aRects[2]    := @rCCLIArea;
  aRects[3]    := @rCopyArea;

  // Set up the box, then the initial state of the panel
{  udTop.Position    := udTop.Max   - rOffsets.Top;
  udRight.Position  := udRight.Max - rOffsets.Right;
  udLeft.Position   := rOffsets.Left;
  udBottom.Position := rOffsets.Bottom;

  udTopChangingEx(    Self, bChangeVal, udTop.Position,    updNone );
  udBottomChangingEx( Self, bChangeVal, udBottom.Position, updNone );
  udRightChangingEx(  Self, bChangeVal, udRight.Position,  updNone );
  udLeftChangingEx(   Self, bChangeVal, udLeft.Position,   updNone );}

{  LOffsetL.Font.Color := LMainText.Font.Color;
  LOffsetT.Font.Color := LMainText.Font.Color;
  LOffsetR.Font.Color := LMainText.Font.Color;
  LOffsetB.Font.Color := LMainText.Font.Color;}

//  LCopyText2.Font := LCopyText1.Font;
  bReady := true;
  UpdateOffsets;
end;

procedure TFConfigOffsets.UpdateFontInfo;
begin
  // Set Drawing Area
  rDrawArea.Left   := rScreenArea.Left   + rOffsets.Left;
  rDrawArea.Top    := rScreenArea.Top    + rOffsets.Top;
  rDrawArea.Bottom := rScreenArea.Bottom - rOffsets.Bottom;
  rDrawArea.Right  := rScreenArea.Right  - rOffsets.Right;

  rCopyArea.Left   := rScreenArea.Left;
  rCopyArea.Bottom := rScreenArea.Bottom;
  rCopyArea.Top    := rScreenArea.Bottom - 100;
  rCopyArea.Right  := rScreenArea.Left   + 250;

  rCCLIArea.Right  := rScreenArea.Right;
  rCCLIArea.Bottom := rScreenArea.Bottom;
  rCCLIArea.Left   := rScreenArea.Right  - 250;
  rCCLIArea.Top    := rScreenArea.Bottom - 100;

{  udLeft.Left   := rDrawArea.Left;
  udRight.Left  := rDrawArea.Right - udRight.Width;
  udTop.Top     := rDrawArea.Top;
  udBottom.Top  := rDrawArea.Bottom - udBottom.Height;}

  // Centre the arrows.
{  udLeft.Top    := ((rDrawArea.Top  + rDrawArea.Bottom - udLeft.Height) div 2);
  udTop.Left    :=  rDrawArea.Left  + TEXT_SPACE;
  udRight.Top   := udLeft.Top;
  udBottom.Left := ((rDrawArea.Left + rDrawArea.Right  - udBottom.Width  ) div 2);}

{  LOffsetL.Left := udLeft.Left  + ARROW_SPACE;
  LOffsetT.Top  := udTop.Top    + ARROW_SPACE;
  LOffsetR.Left := udRight.Left + udRight.Width   - LOffsetR.Width  - ARROW_SPACE;
  LOffsetB.Top  := udBottom.Top + udBottom.Height - LOffsetB.Height - ARROW_SPACE;

  LOffsetL.Top  := udLeft.Top    + udLeft.Height  + ARROW_SPACE;
  LOffsetB.Left := udBottom.Left + udBottom.Width + ARROW_SPACE;
  LOffsetR.Top  := LOffsetL.Top;
  LOffsetT.Left := udTop.Left + udTop.Width + ARROW_SPACE;;}

//  BMainBevel.Left  := rDrawArea.Left  + TEXT_SPACE + ptOffsetMain.X;
//  BMainBevel.Width := rDrawArea.Right - TEXT_SPACE - BMainBevel.Left;
//  BMainBevel.Top   := rDrawArea.Top   + ptOffsetMain.Y;
//  LMainDesc.Left   := BMainBevel.Left + BEVEL_TEXT_SPACE;
//  LMainDesc.Top    := BMainBevel.Top  + BMainBevel.Height - LMainDesc.Height - BEVEL_TEXT_SPACE;
//  LMainText.Top    := BMainBevel.Top  + BEVEL_TEXT_SPACE;
//  LMainText.Left   := BMainBevel.Left + ( BMainBevel.Width - LMainText.Width ) div 2;    // Centre main text

  // Work out how wide the Copyright and CCLI boxes are
{  iCopyWidth := Max( Max(LCopyText1.Width, LCopyText2.Width), LCopyDesc.Width );
  iCCLIWidth := Max( LCCLIText.Width, LCCLIDesc.Width );
  BCCLIBevel.Width := TEXT_SPACE * 2 + iCCLIWidth + BCCLIMove.Width;
  BCopyBevel.Width := TEXT_SPACE * 2 + iCopyWidth + BCopyMove.Width;

  // Move buttons
  BCopyBevel.Left  := rDrawArea.Right  - BCopyBevel.Width  + ptOffsetCopy.X;
  BCopyBevel.Top   := rDrawArea.Bottom - BCopyBevel.Height + ptOffsetCopy.Y;
  iCopyRight       := BCopyBevel.Left + BCopyBevel.Width - BORDER_SPACE;
  LCopyText2.Left  := iCopyRight - LCopyText2.Width - BEVEL_TEXT_SPACE;
  LCopyText2.Top   := BCopyBevel.Top + BCopyBevel.Height
                          - BORDER_SPACE - BEVEL_TEXT_SPACE - LCopyText2.Height;
  LCopyText1.Left  := iCopyRight - LCopyText1.Width - BEVEL_TEXT_SPACE;
  LCopyText1.Top   := LCopyText2.Top - LCopyText1.Height - 2;
  LCopyDesc.Left   := iCopyRight - LCopyDesc.Width - BEVEL_TEXT_SPACE;
  LCopyDesc.Top    := BCopyBevel.Top + BORDER_SPACE + BEVEL_TEXT_SPACE;

  BCopyMove.Left   := BCopyBevel.Left + BORDER_SPACE;
//  BCopyChange.Left := BCopyMove.Left;
//  BCopyAsCCLI.Left := BCopyMove.Left;
//  BCopyAsMain.Left := BCopyMove.Left;

//  BCopyAsCCLI.Top  := BCopyBevel.Top  + BCopyBevel.Height - BCopyAsCCLI.Height - BORDER_SPACE;
//  BCopyAsMain.Top  := BCopyAsCCLI.Top - BCopyAsMain.Height;
//  BCopyChange.Top  := BCopyAsMain.Top - BCopyChange.Height;
//  BCopyMove.Top    := BCopyChange.Top - BCopyMove.Height;

  // Move buttons
  BCCLIBevel.Left  := rDrawArea.Left + ptOffsetCCLI.X;
  BCCLIBevel.Top   := rDrawArea.Bottom - BCCLIBevel.Height + ptOffsetCCLI.Y;
  LCCLIText.Left   := BCCLIBevel.Left + BORDER_SPACE + BEVEL_TEXT_SPACE;
  LCCLIDesc.Left   := LCCLIText.Left;
  LCCLIDesc.Top    := BCCLIBevel.Top  + BORDER_SPACE + BEVEL_TEXT_SPACE;
  LCCLIText.Top    := BCCLIBevel.Top  + BCCLIBevel.Height - LCCLIText.Height - BORDER_SPACE - BEVEL_TEXT_SPACE;

  iCCLIRightAlign  := BCCLIBevel.Left + BCCLIBevel.Width - BCCLIMove.Width - BORDER_SPACE;
  BCCLIMove.Left   := iCCLIRightAlign;
//  BCCLIChange.Left := iCCLIRightAlign;
//  BCCLIAsCopy.Left := iCCLIRightAlign;
//  BCCLIAsMain.Left := iCCLIRightAlign;
//  BCCLIAsCopy.Top  := BCCLIBevel.Top  + BCCLIBevel.Height - BCCLIAsCopy.Height;
//  BCCLIAsMain.Top  := BCCLIAsCopy.Top - BCCLIAsMain.Height;
//  BCCLIChange.Top  := BCCLIAsMain.Top - BCCLIChange.Height;
//  BCCLIMove.Top    := BCCLIChange.Top - BCCLIMove.Height;

  // Move buttons
//  iMainRight       := BMainBevel.Left + BMainBevel.Width - BMainMove.Width - BORDER_SPACE;
//  BMainMove.Left   := iMainRight;
//  BMainChange.Left := iMainRight;
//  BMainChange.Top  := BMainBevel.Top + BMainBevel.Height - BMainChange.Height - BORDER_SPACE;
//  BMainMove.Top    := BMainChange.Top - BMainMove.Height;     }
end;

procedure TFConfigOffsets.btCloseClick(Sender: TObject);
begin
  Close;
  {
  if btClose.Caption = 'Close' then begin
    FConfigOffsets.Close();
  end else begin
    ShowAll;
    btClose.Caption    := 'Close';
    Moving := nil;
    Application.OnMessage := nil;
    UpdateFontInfo;
  end;}
end;

{procedure TFConfigOffsets.udRightChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  if (NewValue >= 0) and (NewValue <= udRight.Max) then begin
    rOffsets.Right   := udRight.Max - NewValue;
    LOffsetR.Caption := SRight + ' ' + IntToStr( rOffsets.Right ) + 'px';
    AllowChange      := true;
    if bReady then begin
      UpdateFontInfo;
      Invalidate;
    end;
  end;
end;}

{
// func to activate or deactivate the screensaver

function ActivateScreenSaver(Activate: boolean): boolean;
var
  IntActive: byte;
begin
  // False (0) is off, True (1) is on.
  if Activate then
    IntActive := 1
  else
    IntActive := 0;

  Result := SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, IntActive, nil, 0);
end;
}

procedure TFConfigOffsets.FormCreate(Sender: TObject);
begin
  STop    := 'Top of Screen:';       SLeft  := 'Left of Screen:';
  SBottom := 'Bottom of Screen:';    SRight := 'Right of Screen:';
  SClose  := 'Close';                SDone  := 'Done';
  SCCLI   := 'CCLI Font';            SCopy  := 'Copyright Font';
  SMain   := 'Main Font';

  rOffsets.Left   := 0;
  rOffsets.Right  := 0;
  rOffsets.Top    := 0;
  rOffsets.Bottom := 0;
//  ptOffsetMain.X  := 0;
//  ptOffsetMain.Y  := 0;
//  ptOffsetCCLI    := ptOffsetMain;
//  ptOffsetCopy    := ptOffsetMain;
  DoubleBuffered  := true;
end;

procedure TFConfigOffsets.FormPaint(Sender: TObject);
begin
  if FSettings.ImageTick.Checked and (FSettings.BGTestImg <> nil) then begin
    Canvas.StretchDraw( rScreenArea, FSettings.BGTestImg.Picture.Graphic );
  end else begin
    Canvas.Pen.Style   := psClear;
    Canvas.Brush.Color := clBlack;
    Canvas.Rectangle( rScreenArea );
  end;

  // Draw Main Area
  Canvas.Pen.Mode    := pmMaskPenNot;
  Canvas.Pen.Color   := clWhite;
  Canvas.Pen.Style   := psDot;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle( rDrawArea );

  // Draw CCLI Area
  Canvas.Pen.Color   := clBlue;
  Canvas.Pen.Style   := psDot;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle( rCCLIArea );

  // Draw Copyright Area
  Canvas.Pen.Color   := clRed;
  Canvas.Pen.Style   := psDot;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle( rCopyArea );
end;

procedure TFConfigOffsets.BCCLIChangeClick(Sender: TObject);
begin
  FFontConfig.DefaultFont := FSettings.DefaultSmallFont;
  FFontConfig.Font        := FSettings.CCLIFont;
  FFontConfig.Caption     := SCCLI;
  FFontConfig.ShowModal;
  FSettings.CCLIFont      := FFontConfig.Font;
//  FSettings.SetTextDetails( FSettings.CCLIFont, FSettings.DefaultSmallFont, LCCLIText, LCCLIDesc );
  UpdateFontInfo;
  Invalidate;
end;

procedure TFConfigOffsets.BCopyChangeClick(Sender: TObject);
begin
  FFontConfig.DefaultFont := FSettings.DefaultSmallFont;
  FFontConfig.Font        := FSettings.CopyrightFont;
  FFontConfig.Caption     := SCopy;
  FFontConfig.ShowModal;
  FSettings.CopyrightFont := FFontConfig.Font;
//  FSettings.SetTextDetails( FSettings.CopyrightFont, FSettings.DefaultSmallFont, LCopyText1, LCopyDesc );
//  LCopyText2.Font := LCopyText1.Font;
  UpdateFontInfo;
  Invalidate;
end;

procedure TFConfigOffsets.BMainChangeClick(Sender: TObject);
begin
  FFontConfig.DefaultFont := FSettings.DefaultMainFont;
  FFontConfig.Font        := FSettings.PrimaryFont;
  FFontConfig.Caption     := SMain;
  FFontConfig.ShowModal;
  FSettings.PrimaryFont   := FFontConfig.Font;
//  FSettings.SetTextDetails( FSettings.PrimaryFont, FSettings.DefaultMainFont, LMainText, LMainDesc );

{  LOffsetL.Font.Color := LMainText.Font.Color;
  LOffsetT.Font.Color := LMainText.Font.Color;
  LOffsetR.Font.Color := LMainText.Font.Color;
  LOffsetB.Font.Color := LMainText.Font.Color;}

  UpdateFontInfo;
  Invalidate;
end;


procedure TFConfigOffsets.ShowOnly( aSelected : array of TControl );
var iIdx : integer;
    hControl : TControl;
begin
  for iIdx := 0 to ControlCount-1 do begin
    hControl := Controls[iIdx];
    if hControl.Visible and not isIn(hControl, aSelected) then
      hControl.Visible := false;
  end;
end;

procedure TFConfigOffsets.ShowAll;
var iIdx : integer;
begin
  for iIdx := 0 to ControlCount-1 do begin
    Controls[iIdx].Visible := true;
  end;
end;

function TFConfigOffsets.isIn( hObj : TControl; aArr : array of TControl ) : boolean;
var iIdx : integer;
begin
  isIn := false;
  for iIdx := 0 to Length(aArr)-1 do begin
    if aArr[iIdx] = hObj then begin
      isIn := true;
      Exit;
    end;
  end;
end;


procedure TFConfigOffsets.SetMoveButtons( Sender: TControl );
begin
  Application.OnMessage := OnAppMsg;
end;

procedure TFConfigOffsets.MoveMe( iHoriz, iVert : integer );
var hControl : TControl;
    iIdx     : integer;
begin
  for iIdx := 0 to ControlCount-1 do begin
    hControl := Controls[iIdx];
    if hControl.Visible and (hControl <> btClose) then begin
      hControl.Top  := hControl.Top  + iVert;
      hControl.Left := hControl.Left + iHoriz;
    end;
  end;
  if pptOffsets <> nil then begin
    pptOffsets.Y  := pptOffsets.Y  + iVert;
    pptOffsets.X  := pptOffsets.X  + iHoriz;
  end;
end;

procedure TFConfigOffsets.OnAppMsg(var Msg: TMsg; var Handled: Boolean);
var iVert, iHoriz : integer;
begin
  if Msg.Message = WM_KEYDOWN then begin
    if Moving <> nil then begin
      iVert  := 0;
      iHoriz := 0;
      if Msg.wParam = VK_UP     then iVert  := -1;
      if Msg.wParam = VK_DOWN   then iVert  :=  1;
      if Msg.wParam = VK_LEFT   then iHoriz := -1;
      if Msg.wParam = VK_RIGHT  then iHoriz :=  1;
      if Msg.wParam = VK_RETURN then btCloseClick(Self);
      if (iHoriz<>0) or (iVert<>0) then begin
        MoveMe( iHoriz, iVert );
        Handled := true;
      end;
    end;
  end;
end;

procedure TFConfigOffsets.BMoveRightClick(Sender: TObject);
begin
  MoveMe( 1, 0 );
end;

procedure TFConfigOffsets.BMoveUpClick(Sender: TObject);
begin
  MoveMe( 0, -1 );
end;

procedure TFConfigOffsets.BMoveDownClick(Sender: TObject);
begin
  MoveMe( 0, 1 );
end;

procedure TFConfigOffsets.BMoveLeftClick(Sender: TObject);
begin
  MoveMe( -1, 0 );
end;

const Side_Left   = 1;
      Side_Right  = 2;

      Side_Top    = 1;
      Side_Bottom = 2;

      Side_Move   = 3;

      Change_Main = 1;
      Change_CCLI = 2;
      Change_Copy = 3;

      DRAG_TOL    = 6;
      MIN_AREA    = 30;


procedure TFConfigOffsets.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  iIdx     : integer;
  bChanged : boolean;
  prRect   : PRect;
  rRect    : TRect;
begin
  iOver    := 0;
  bChanged := false;
  if 0 = iSelected then begin
    iSideX := 0;
    iSideY := 0;

    for iIdx := 1 to 3 do
    begin
      // Secondly, check the sides
      prRect := aRects[iIdx];
      if (X > prRect^.Left - DRAG_TOL) and
         (X < prRect^.Left + DRAG_TOL) and
         (Y > prRect^.Top)             and
         (Y < prRect^.Bottom) then begin
        iOver   := iIdx;
        iSideX  := Side_Left;
        Cursor  := crSizeWE;
      end;

      if (X > prRect^.Right - DRAG_TOL) and
         (X < prRect^.Right + DRAG_TOL) and
         (Y > prRect^.Top)              and
         (Y < prRect^.Bottom) then begin
        iOver   := iIdx;
        iSideX  := Side_Right;
        Cursor  := crSizeWE;
      end;

      if (Y > prRect^.Top - DRAG_TOL) and
         (Y < prRect^.Top + DRAG_TOL) and
         (X > prRect^.Left)           and
         (X < prRect^.Right) then begin
        iOver   := iIdx;
        iSideY  := Side_Top;
        Cursor  := crSizeNS;
      end;

      if (Y > prRect^.Bottom - DRAG_TOL) and
         (Y < prRect^.Bottom + DRAG_TOL) and
         (X > prRect^.Left)              and
         (X < prRect^.Right) then begin
        iOver  := iIdx;
        iSideY := Side_Bottom;
        Cursor := crSizeNS;
      end;

      if 0 = iOver then Cursor := crDefault;
      if (iSideX <> 0) and (iSideY <> 0) then
        if iSideX <> iSideY then Cursor := crSizeNESW
                            else Cursor := crSizeNWSE;

      if 0 <> iOver then break;
    end;
  end else begin
    prRect := aRects[iSelected];
    if Side_Top    = iSideY then begin prRect^.Top    := Y; bChanged := true; end;
    if Side_Bottom = iSideY then begin prRect^.Bottom := Y; bChanged := true; end;
    if Side_Left   = iSideX then begin prRect^.Left   := X; bChanged := true; end;
    if Side_Right  = iSideX then begin prRect^.Right  := X; bChanged := true; end;
    if Side_Move   = iSideX then begin
      prRect^ := rClickOffset;
      OffsetRect( prRect^, X, Y );

      if prRect^.Bottom > rScreenArea.Bottom then begin
        prRect^.Top    := rScreenArea.Bottom - (prRect^.Bottom - prRect^.Top);
        prRect^.Bottom := rScreenArea.Bottom;
      end;
      if prRect^.Top < rScreenArea.Top then begin
        prRect^.Bottom := rScreenArea.Top + (prRect^.Bottom - prRect^.Top);
        prRect^.Top    := rScreenArea.Top;
      end;

      if prRect^.Right > rScreenArea.Right then begin
        prRect^.Left  := rScreenArea.Right - (prRect^.Right - prRect^.Left);
        prRect^.Right := rScreenArea.Right;
      end;
      if prRect^.Left < rScreenArea.Left then begin
        prRect^.Right := rScreenArea.Left + (prRect^.Right - prRect^.Left);
        prRect^.Left  := rScreenArea.Left;
      end;
      bChanged := true;
    end;

    if bChanged then begin
      prRect^.Left   := Min( Max( rScreenArea.Left,   prRect^.Left   ), rScreenArea.Right  - MIN_AREA );
      prRect^.Top    := Min( Max( rScreenArea.Top,    prRect^.Top    ), rScreenArea.Bottom - MIN_AREA );
      prRect^.Right  := Max( Min( rScreenArea.Right,  prRect^.Right  ), rScreenArea.Left   + MIN_AREA );
      prRect^.Bottom := Max( Min( rScreenArea.Bottom, prRect^.Bottom ), rScreenArea.Top    + MIN_AREA );

      if prRect^.Right  < prRect^.Left   + MIN_AREA then prRect^.Right  := prRect^.Left   + MIN_AREA;
      if prRect^.Left   > prRect^.Right  - MIN_AREA then prRect^.Left   := prRect^.Right  - MIN_AREA;
      if prRect^.Bottom < prRect^.Top    + MIN_AREA then prRect^.Bottom := prRect^.Top    + MIN_AREA;
      if prRect^.Top    > prRect^.Bottom - MIN_AREA then prRect^.Top    := prRect^.Bottom - MIN_AREA;

      UpdateOffsets;
    end;
  end;
end;

procedure TFConfigOffsets.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  iSelected := iOver;
end;

procedure TFConfigOffsets.FormMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  iSelected := 0;
end;

procedure TFConfigOffsets.UpdateOffsets;
var   iIdx       : integer;
      aPrefixes  : array[1..3] of string;
      aPosBR     : array[1..3, 0..1] of boolean;
      rScrRect, rTxtRect : TRect;
begin
  aPrefixes[1] := 'TEXT AREA ';
  aPrefixes[2] := 'CCLI TEXT ';
  aPrefixes[3] := '';
  aPosBR[1,0] := false; aPosBR[1,1] := false;
  aPosBR[2,0] := true;  aPosBR[2,1] := false;
  aPosBR[3,0] := true;  aPosBR[3,1] := true;

  for iIdx := 1 to 3 do begin
    rScrRect := aRects[iIdx]^;
    rTxtRect := rScrRect;
    OffsetRect( rTxtRect, -rScreenArea.Left, -rScreenArea.Top );

    aCaptions[iIdx].Caption := aPrefixes[iIdx] + '(' +
            IntToStr(rTxtRect.Left) +', '+
            IntToStr(rTxtRect.Top) + ') (' +
            IntToStr(rTxtRect.Right  - rTxtRect.Left) + ' x ' +
            IntToStr(rTxtRect.Bottom - rTxtRect.Top)  + ')';

    if aPosBR[iIdx,0] then aCaptions[iIdx].Top  := rScrRect.Bottom - 2 - aCaptions[iIdx].Height
                      else aCaptions[iIdx].Top  := rScrRect.Top    + 2;
    if aPosBR[iIdx,1] then aCaptions[iIdx].Left := rScrRect.Right  - 2 - aCaptions[iIdx].Width
                      else aCaptions[iIdx].Left := rScrRect.Left   + 2;
  end;

  LCopyDesc.Top  := LCopy2.Top  - LCopyDesc.Height;
  LCopyDesc.Left := LCopy2.Left + LCopy2.Width - LCopyDesc.Width;

  LCCLIDesc.Top  := LCCLI2.Top  - LCCLIDesc.Height;
  LCCLIDesc.Left := LCCLI2.Left;
  invalidate;
end;


//------------------------------------------------------------------------------

procedure TFConfigOffsets.MainOffsetTLMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  iSelected    := 1;
  iSideX       := Side_move;
  rClickOffset := rDrawArea;
  OffsetRect( rClickOffset,
              -( MainOffsetTL.Left + X ),
              -( MainOffsetTL.Top  + Y ) );
end;

procedure TFConfigOffsets.LCCLIDescMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  iSelected    := 2;
  iSideX       := Side_move;
  rClickOffset := rCCLIArea;
  OffsetRect( rClickOffset,
              -( LCCLIDesc.Left + X ),
              -( LCCLIDesc.Top  + Y ) );
end;

procedure TFConfigOffsets.LCopyDescMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  iSelected    := 3;
  iSideX       := Side_move;
  rClickOffset := rCopyArea;
  OffsetRect( rClickOffset,
              -( LCopyDesc.Left + X ),
              -( LCopyDesc.Top  + Y ) );
end;

//------------------------------------------------------------------------------

procedure TFConfigOffsets.MainOffsetTLMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if 1 = iSelected then
    Self.FormMouseMove(Sender,Shift,
                         MainOffsetTL.Left + X,
                         MainOffsetTL.Top  + Y);
end;

procedure TFConfigOffsets.LCCLIDescMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if 2 = iSelected then
    Self.FormMouseMove(Sender,Shift,
                         LCCLIDesc.Left + X,
                         LCCLIDesc.Top  + Y);
end;

procedure TFConfigOffsets.LCopyDescMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if 3 = iSelected then
    Self.FormMouseMove(Sender,Shift,
                         LCopyDesc.Left + X,
                         LCopyDesc.Top  + Y);
end;

//------------------------------------------------------------------------------

procedure TFConfigOffsets.HandlerMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  iSelected := 0;
end;

procedure TFConfigOffsets.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if VK_ESCAPE = Key then Close;
end;

procedure TFConfigOffsets.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  OffsetRect( rDrawArea, -rScreenArea.Left, -rScreenArea.Top );
  OffsetRect( rCCLIArea, -rScreenArea.Left, -rScreenArea.Top );
  OffsetRect( rCopyArea, -rScreenArea.Left, -rScreenArea.Top );

  FSongbase.rTextArea := rDrawArea;
  FSongbase.rCCLIArea := rCCLIArea;
  FSongbase.rCopyArea := rCopyArea;
end;

end.
