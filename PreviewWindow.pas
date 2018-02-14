unit PreviewWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, RichEdit, ImgList, ToolWin, SBZipUtils,
  SBFiles, EditProj, Buttons, WindowlessRTF;

type
  TFPreviewWindow = class(TForm)
    ToolbarImages: TImageList;
    PButtons: TPanel;
    BackgroundPic: TImage;
    LPages: TLabel;
    PPages: TPanel;
    PCaption: TPanel;
    LCopyright1: TLabel;
    PButtonPanel: TPanel;
    LCopyright2: TLabel;
    Timer1: TTimer;
    PProjectSong: TPanel;
    BProjectSong: TButton;
    BNext: TBitBtn;
    BPrevious: TBitBtn;
    BBlank: TBitBtn;
    BEditOHP: TButton;
    PHighlight: TPanel;
    ImgHighlight: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure BEditOHPClick(Sender: TObject);
    procedure BProjectSongClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BBlankClick(Sender: TObject);
    procedure BNextClick(Sender: TObject);
    procedure BPreviousClick(Sender: TObject);

  private
    { Private declarations }
    bHasButtons    : boolean;
    bHasInfo       : boolean;
    bDisplayButs   : boolean;
    hExtRichEdit   : TRichEdit;
    sLastPic       : string;
    Pics           : array of string;
    SCS            : ShortcutArray;
    bHasBackground : boolean;

    iCurrentPage   : integer;
    iPages         : integer;
    szLastSize     : size;

    iPagesVisible  : integer;
    FRTF           : TWindowlessRTF;
    FRenderArea    : TRect;
    RenderImage    : TImage;
    RenderSize     : size;
    BackColor      : TColor;

    procedure SetHasButtons(Value: boolean);
    procedure SetHasInfo(Value: boolean);

    // Used to keep this window off the projection screen
    procedure WMWindowPosChanging(var hMsg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;

  public
    { Public declarations }
    PageButtons    : array of TButton;
    LastID         : string;
    Closer : TObject;
    sCurrentCaption : string;
    bNoResizeMsg   : boolean;
//    UnscaledImg : TImage;

    SLivePrefix : string;
    SModeSelect,      SModeSong             : string;
    SModeSearchWords, SModeSearchTitle      : string;
    SModeSearching,   SModeExit, SModeBlank : string;

//    procedure RichEditRender(RichEdit: TRichEdit; iW,iH:integer);
    procedure LoadOHP( ID : string; Page : integer );
    procedure RefreshAll();
    procedure BPageButtonClick( Sender : TObject );
    procedure UpdateContent;
    procedure UpdatePageButtons;
//    procedure UpdateCopyright;
    procedure UpdateArrows;
    procedure UpdateCaptions;
  published
    property HasButtons: boolean read bHasButtons write SetHasButtons;
    property HasInfo: boolean read bHasInfo write SetHasInfo;
    property CurrentPage: integer read iCurrentPage;
    property Pages: integer read iPages;
  end;

var
  FPreviewWindow:   TFPreviewWindow;
  FLiveWindow:      TFPreviewWindow;
  hLastProjectTime: TDateTime;

implementation

uses Appear, SBMain, Math, PageCache, DateUtils;

{$R *.dfm}

{procedure TFPreviewWindow.RichEditRender(RichEdit: TRichEdit; iW,iH:integer );
var
  ImageCanvas: TCanvas;
  fmt: TFormatRange;
begin
  ASSERT( FRTF <> nil );

  FRTF.SetClientRect( RichEdit.BoundsRect );
  FRTF.OnPaint( Self.Canvas );

  ImageCanvas := UnscaledImg.Canvas;

  with fmt do
  begin
    hdc:= ImageCanvas.Handle;
    hdcTarget:= hdc;

    // rect needs to be specified in twips (1/1440 inch) as unit
    rc:=  Rect(RichEdit.BoundsRect.Left   * 1440 div FProjWin.PixelsPerInch,
               RichEdit.BoundsRect.Top    * 1440 div FProjWin.PixelsPerInch,
               RichEdit.BoundsRect.Right  * 1440 div FProjWin.PixelsPerInch,
               RichEdit.BoundsRect.Bottom * 1440 div FProjWin.PixelsPerInch);
    rcPage:= Rect( 0,0,
                   iW * 1440 div FProjWin.PixelsPerInch,
                   iH * 1440 div FProjWin.PixelsPerInch );
    chrg.cpMin := 0;
    chrg.cpMax := RichEdit.GetTextLen;
  end;

//  SetBkMode(ImageCanvas.Handle, TRANSPARENT);
  RichEdit.Perform(EM_FORMATRANGE, 1, Integer(@fmt));
  // next call frees some cached data
  RichEdit.Perform(EM_FORMATRANGE, 0, 0);


end;                                     }



procedure TFPreviewWindow.FormShow(Sender: TObject);
var
  iWidth,    iHeight   : integer;
  iPreviewW, iPreviewH : integer;
begin
  LogThis( 'Showing window ''' + Caption + '''' );
  hLastProjectTime  := 0;

  if Self = FPreviewWindow then begin
    iPreviewW := FSongbase.szPreviewSize.cx;
    iPreviewH := FSongbase.szPreviewSize.cy;
  end else begin
    iPreviewW := FSongbase.szLiveSize.cx;
    iPreviewH := FSongbase.szLiveSize.cy;
    hExtRichEdit := FProjWin.RESong;
  end;

  if iPreviewW = 0 then begin
    iWidth  := FSongBase.szDisplaySize.cx div 2 + (Width - ClientRect.Right);
  end else begin
    iWidth  := iPreviewW;
  end;
  if iPreviewH = 0 then begin
    iHeight := FSongBase.szDisplaySize.cy div 2 + (Height - ClientRect.Bottom);
    if bDisplayButs then
      iHeight := iHeight + PButtons.Height;
  end else begin
    iHeight := iPreviewH;
  end;

  width:=iWidth;
  height:=iHeight;
  FSongbase.SetImageSize( Self, RenderImage,
                FSongbase.szDisplaySize.cx, FSongbase.szDisplaySize.cy );
  RenderSize := FSongbase.szDisplaySize;

  //LogThis( 'Resizing (' + IntToStr(Left)   + ', ' + IntToStr(Top)     +') '+
//                    '(' + IntToStr(iWidth) + ', ' + IntToStr(iHeight) +')' );
  LogThis( 'Resized' );

  PButtons.Visible     := bDisplayButs;
  PButtonPanel.Visible := bHasButtons;
  PCaption.Visible     := bHasInfo;
  DoubleBuffered := true;

  FLiveWindow.UpdateContent;
end;


procedure TFPreviewWindow.FormResize(Sender: TObject);
begin
  if Visible then begin
    LogThis( 'Resizing...' );
    if bDisplayButs then begin
      PButtons.Top   := ClientRect.Bottom - PButtons.Height;
      PButtons.Width := ClientRect.Right;
      PCaption.Left  := PButtons.ClientRect.Right - 4 - PCaption.Width;
    end;
    szLastSize.cx := Width;
    szLastSize.cy := Height;
    if Self = FPreviewWindow then begin
      FSongbase.szPreviewSize := szLastSize;
    end else begin
      FSongbase.szLiveSize := szLastSize;
    end;
    FRenderArea := Rect( 0, 0, ClientRect.Right, PButtons.Top );

    if not bNoResizeMsg then begin
      Timer1.Enabled := false;
      Timer1.Enabled := true;
      LogThis( 'Starting resize info timer' );
      UpdateCaptions;
    end;

    Refresh;
  end;
end;


procedure TFPreviewWindow.FormPaint(Sender: TObject);
var
  WindowRect       : TRect;
  TextRect         : TRect;
  SourceRTFControl : TWindowlessRTF;
  BGPix            : TGraphic;
  fZoom            : extended;
begin
  BGPix := nil;
//  LogThis( Caption + ' repaints' );

  WindowRect := Rect( 0,0, FSongBase.szDisplaySize.cx, FSongBase.szDisplaySize.cy );
  TextRect   := FSongbase.rTextArea;

  if Self = FPreviewWindow then begin
    if (0 <> FSettings.szProjectScale.cx) then begin
      fZoom := FSettings.szProjectScale.cy / FSongbase.szDisplaySize.cy;
      TextRect.Top      := Round( TextRect.Top      * fZoom );
      TextRect.Left     := Round( TextRect.Left     * fZoom );
      TextRect.Right    := Round( TextRect.Right    * fZoom );
      TextRect.Bottom   := Round( TextRect.Bottom   * fZoom );
      WindowRect.Right  := Round( WindowRect.Right  * fZoom );
      WindowRect.Bottom := Round( WindowRect.Bottom * fZoom );
    end;

    FRTF.SetClientRect( TextRect );
    SourceRTFControl := FRTF;
    if bHasBackground then begin
      BGPix := BackgroundPic.Picture.Graphic;
    end;
  end else begin
    SourceRTFControl := FProjWin.FRTF;
    BGPix            := FProjWin.ImgBackground.Picture.Graphic;
    if FProjWin.Blanked and (FProjWin.BlankImgFile <> '') then
               BGPix := FProjWin.ImgBlank.Picture.Graphic;
    if FSettings.BackTick.checked then BackColor := FSettings.PColB.Color
                                  else BackColor := clBlack;
  end;

  // Ensure the renderable image is large enough
  if (RenderSize.cx <> WindowRect.Right) or
     (RenderSize.cy <> WindowRect.Bottom) then begin
    FSongbase.SetImageSize( Self, RenderImage,
                  WindowRect.Right, WindowRect.Bottom );
    RenderSize.cx := WindowRect.Right;
    RenderSize.cy := WindowRect.Bottom;
  end;

  // Now render the background
  if BGPix <> nil then begin
    RenderImage.Canvas.StretchDraw( WindowRect, BGPix );
  end else begin
    RenderImage.Canvas.Brush.Color := BackColor;
    RenderImage.Canvas.FillRect( WindowRect );
  end;

  // Then the text
  ASSERT( SourceRTFControl <> nil );
  SourceRTFControl.OnPaint( RenderImage.Canvas );

  // Finally blit it to the screen
  if FProjWin.bHighQuality then begin
    SetStretchBltMode(Canvas.Handle, STRETCH_HALFTONE	);
    SetBrushOrgEx(Canvas.Handle, 0, 0, nil);

    // Then use StretchBlt to render it onto the screen
    StretchBlt( Canvas.Handle,
                0, 0, FRenderArea.Right, FRenderArea.Bottom,
                RenderImage.Canvas.Handle,
                0,0, WindowRect.Right, WindowRect.Bottom, cmSrcCopy );
  end else begin
    Canvas.StretchDraw( FRenderArea, RenderImage.Picture.Graphic );
  end;

//  LogThis( Caption + ' repainted' );
end;


procedure TFPreviewWindow.RefreshAll();
var
  sID : string;
begin
  // Remember, but blank out the last id... then reload it
  LogThis( 'Refreshing everything in Preview Window' );

  sID := LastID;
  LastID := '';
  if( iCurrentPage < 1 ) then iCurrentPage := 1;
  LoadOHP( sID, iCurrentPage );
end;


// When LiveWindow content is updated, this updates the captions
// copyright info and buttons.
procedure TFPreviewWindow.UpdateContent;
begin
  UpdateCaptions;
  UpdatePageButtons;
  Invalidate;

//  UpdateCopyright;
end;


procedure TFPreviewWindow.LoadOHP( ID : string; Page : integer );
var
  bHandled       : boolean;
  i              : integer;
  sText, sNextBG : string;
  bNewSong       : boolean;
begin
  LogThis( '''' + Self.Caption +''' loading ' + ID + ', page ' + IntToStr(Page) );
  LogThis( '''' + Self.Caption +''' LAST(' + LastID + '), Last page ' + IntToStr(CurrentPage) );

  bNewSong     := false;

  if (ID <> LastID) then begin
    bNewSong := true;
    if ID = '' then begin
      LogThis( 'Blanking Screen' );
      BEditOHP.Enabled := false;
      iPages := 0;
      iCurrentPage := 0;
    end else begin
      LogThis( 'Loading song ''' + ID + '''' );

      // Get the number of pages...
      BEditOHP.Enabled := true;
      iPages := PageCache_GetPageCount( ID );
      if -1 = iPages then begin
        // DON'T PREVIEW!
        LogThis( 'Song OHP file ''' + ID + ''' not found' );
        iPages := 0;
        iCurrentPage := 0;
      end else begin
        setlength(Pics,iPages);

        // Get the images and key-shortcuts
        if iPages>0 then begin
          BEditOHP.Caption := 'Edit Page';
          for i:=1 to iPages do begin
            PageCache_GetPageShortcut( ID, i, SCS[(i*2)+1], SCS[(i*2)] );
            Pics[i-1] := PageCache_GetPagePicture( ID, i );
          end;
        end;
        LogThis( 'Song OHP file ''' + ID + ''' read successfully - # pages ' + IntToStr(iPages) );
      end;
    end;

    // Unzip the RTF pages for this song.
{    if iPages>=1 then begin
      for i:=1 to iPages do begin
        str(i,S);
        S:=ID+'-'+S+'.rtf';
        if not FileExists(TempDir+S) then ExtractFileFromZip(OHPFile,S,TempDir);
      end;
      LogThis( 'pages extracted' );
    end;}
  end;

  // Try loading the current song into the preview window
  if Page > iPages then begin
    Page := iPages;
    LogThis( 'Page requested was beyond song length, clipping to '+ IntToStr(iPages) );
  end;

  // Load the page!
//  RichEdit1.Color := clBlack;
  if Page > 0 then begin
    LogThis( 'Loading RTF - ID=' +ID+ ', Page=' +IntToStr(Page) );
    sText := PageCache_GetPageText( ID, Page );
    BProjectSong.Enabled := true;

    FRTF.Text := sText;
    FRTF.ResetForces();
    if FSettings.PrimaryFont.ForceName   then FRTF.SetFont(     FSettings.PrimaryFont.Name   );
    if FSettings.PrimaryFont.ForceSize   then FRTF.SetFontSize( FSettings.PrimaryFont.Size   );
    if FSettings.PrimaryFont.ForceColor  then FRTF.SetColor(    FSettings.PrimaryFont.Color  );
    if FSettings.PrimaryFont.ForceItalic then FRTF.SetItalic(   FSettings.PrimaryFont.Italic );
    if FSettings.PrimaryFont.ForceBold   then FRTF.SetBold(     FSettings.PrimaryFont.Bold   );
  end else begin
    LogThis( 'Cleared Preview RichText box' );
//    RichEdit1.Lines.Clear;
    FRTF.Text := '';
    BProjectSong.Enabled := false;
  end;

  // Only select the text if we need to...
  LastID:=ID;
  //if iCurrentPage <> Page then bPageChanged := true;
  iCurrentPage := Page;
  bHandled     := false;

  // Is there an individual background graphic for this page?
  if (iCurrentPage>0)
        and ('' <> Pics[iCurrentPage-1])
        and FileExists(Pics[iCurrentPage-1])
        and (not FSettings.ImageTick.Checked or
             not FSettings.ForceBGImage.Checked) then begin
    bHandled := true;
    if (Pics[iCurrentPage-1]<>sLastPic) then begin
      sLastPic:=Pics[iCurrentPage-1];
      LogThis( 'Custom Background image ' );
      LogThis( 'Loading Background image ' + Pics[iCurrentPage-1] );
      BackgroundPic.Picture.LoadFromFile(Pics[iCurrentPage-1]);
      LogThis( 'Background image loaded' );
    end;
    bHasBackground := true;
  end;

  // Are we using a background list?
  if not bHandled and
     FSettings.cbBGOrder.Enabled and
     (FSettings.cbBGOrder.ItemIndex <> -1) then begin
    sNextBG := FSettings.GetNextBackground(sLastPic,bNewSong,iCurrentPage);
    if (sNextBG <> '') and FileExists(sNextBG) then begin
      bHandled := true;
      if sNextBG <> sLastPic then begin
        sLastPic := sNextBG;
        LogThis( 'Loading next Background image ''' + sNextBG + '''' );
        BackgroundPic.Picture.LoadFromFile(sNextBG);
      end;
      bHasBackground := true;
    end;
  end;

  // Deal with backgrounds
  BackColor := clBlack;
  if not bHandled then begin
    if FSettings.ImageTick.Checked then begin
      bHandled := true;
      if (FSettings.ImageFile<>sLastPic) then begin
        if FileExists(FSettings.ImageFile) then begin
          sLastPic := FSettings.ImageFile;
          LogThis( 'Loading Background image ''' + FSettings.ImageFile + '''' );
          BackgroundPic.Picture.LoadFromFile(FSettings.ImageFile);
          LogThis( 'Background image loaded' );
          bHasBackground := true;
        end;
      end else begin
        bHasBackground := true;
      end;
    end else if (FSettings.BackTick.checked) then begin
      BackColor := FSettings.PColb.Color;
      bHandled  := true;
  //    LogThis( 'Background colour set to ' + IntToStr(RichEdit1.Color) );
    end;
  end;
  if not bHandled then begin
    bHasBackground := false;
    sLastPic := '';
  end;
  FRTF.SetShadow( FSettings.cbShadow.Checked, FSettings.PShadowCol.Color, FSettings.iShadowOffset );

  // Update buttons
  if bDisplayButs then begin
    UpdatePageButtons();
{    PPage.Caption := IntToStr(iCurrentPage) + '/' + IntToStr(iPages);
    BPL.Enabled := ( iCurrentPage > 1 );
    BPR.Enabled := ( iCurrentPage < iPages );}
  end;

  UpdateArrows;

  // Redraw!
  Invalidate;
end;

procedure TFPreviewWindow.UpdateArrows;
begin
  BNext.Enabled     := (iCurrentPage < iPages) and (0 <> iCurrentPage);
  BPrevious.Enabled := (iCurrentPage > 1);
  with FSongbase.StringGrid1 do begin
    if (false = BNext.Enabled) and (FSongbase.CurrentOrderIndex < RowCount-1) and DefaultDrawing
                                                                         then BNext.Enabled := true;
    if (false = BPrevious.Enabled) and (FSongbase.CurrentOrderIndex > 0) then BPrevious.Enabled := true;
  end;
end;

procedure TFPreviewWindow.BEditOHPClick(Sender: TObject);
begin
  FSongBase.EditOHPPage(CurrentPage);
end;

procedure TFPreviewWindow.BProjectSongClick(Sender: TObject);
var Key : Word;
    hTimeNow : TDateTime;
begin
  // If we press the 'project song' button twice in quick
  // succession, we ignore the second one.
  hTimeNow := GetTime();
  if bIgnoreDoubleClicks and
     (MilliSecondsBetween( hTimeNow, hLastProjectTime ) < DoubleClickDelay) then begin
    Exit;
  end;
  hLastProjectTime := hTimeNow;

  FSongBase.ProjectSong(LastID, CurrentPage, false);
  if FSongbase.bMultiMonitor and FSettings.cbProjectNext.Checked
                             and (CurrentPage < Pages) then begin
    Key := VK_F7;
    FormKeyDown( Sender, Key, [] );
  end;
end;

procedure TFPreviewWindow.UpdatePageButtons;
var
  i,j     : integer;
  s       : String;
begin
  LogThis( '''' + Self.Caption + ''' updating page buttons' );

  // Ensure we've got enough buttons created...

  // WES - weird thing - these buttons disappeared as soon as I created them when
  // doing so from the web interface. SO, going to create them all in advance.
  // Looks like the objects are "transient" when created from an explicit function
  // call, but persist when called from a genuine windows event. WEIRD.
  // ANYWAY - I've hacked below so it'll be fine for up to 10 pages of song...

  if (length(PageButtons)<10) then begin
    j := length( PageButtons );
    setlength( PageButtons, 10);
    for i := j to 9 do begin
      PageButtons[i] := TButton.Create(PPages);
      PageButtons[i].Top   := 4;
      PageButtons[i].Width := 13;
      PageButtons[i].Left  := 8 + LPages.Width + ( i * 13 );
      PageButtons[i].Parent:=PPages;
//      PPages.InsertControl(PageButtons[i]);
    end;
  end;

  // Update those buttons we're using.
  s:='';
  for i:=1 to iPages do begin
    PageButtons[i-1].Visible := true;
    PageButtons[i-1].Caption:= Chr( SCS[(i*2)] );
    s:=s+chr(SCS[(i*2)]);
    if i = CurrentPage then PageButtons[i-1].Font.Style := [fsBold]
                       else PageButtons[i-1].Font.Style := [];
    PageButtons[i-1].OnClick := BPageButtonClick;
  end;

  // And hide those we arn't
  for i:=iPages+1 to iPagesVisible do begin
    PageButtons[i-1].Visible:=false;
  end;

  // Then update the width of the thingy...
  i := 8 + LPages.Width;
  if iPages > 0 then begin
    i := PageButtons[ iPages-1 ].Left + PageButtons[ iPages-1 ].Width;
  end;
  PPages.Width   := i;
  LPages.Visible := ( iPages > 0 );
  iPagesVisible  := iPages;
  FSongbase.currentPageButtons:=s;
  repaint;
  LogThis( '''' + Self.Caption + ''' page buttons updated' );
end;


procedure TFPreviewWindow.UpdateCaptions;
var i, iRight : integer;
    S : string;
begin
  if Self = FLiveWindow then begin
    // Update the caption information
    iRight := PCaption.Left + PCaption.Width;
    if FProjWin.Cop1.Enabled then LCopyright1.Caption := FProjWin.Cop1.Caption
                             else LCopyright1.Caption := '';
    if FProjWin.Cop2.Enabled then LCopyright2.Caption := FProjWin.Cop2.Caption
                             else LCopyright2.Caption := '';
    if FProjWin.Cop1.Visible then LCopyright1.Font.Color := clBlack
                             else LCopyright1.Font.Color := clGray;
    if FProjWin.Cop2.Visible then LCopyright2.Font.Color := clBlack
                             else LCopyright2.Font.Color := clGray;
    PCaption.Width := Max( LCopyright1.Width, LCopyright2.Width );
    LCopyright1.Left := PCaption.Width - LCopyright1.Width;
    LCopyright2.Left := PCaption.Width - LCopyright2.Width;
    PCaption.Left := iRight - PCaption.Width;

    // Update the page labels
    if FProjWin.GID <> LastID then begin
      iPages := 0;
      LastID := FProjWin.GID;
    end;
    if FProjWin.Pages <> iPages then begin
      iPages := FProjWin.Pages;
      SCS := FProjWin.SCS;
    end;
    if FProjWin.CurrentPage <> iCurrentPage then begin
      iCurrentPage := FProjWin.CurrentPage;
    end;
    if (iPages<>0) and (not FProjWin.ShowPageLabels) then begin
      iPages := 0;
      for i := 1 to 200 do begin
        scs[i] := 0;
      end;
    end;
    LPages.Visible := FProjWin.ShowPageLabels;

    // And update the current Title of the LIVE window
    case FProjWin.BlindMode of
      SELECTING_SONG:  S:= SModeSelect;
      SHOWING_SONG:    S:= SModeSong + ' - ' + FProjWin.GTitle;
      FINDING_TITLE:   S:= SModeSearchTitle;
      SEARCHING_TEXT:  S:= SModeSearchWords;
      CHOOSING_RESULT: S:= SModeSearching;
      QUITTING:        S:= SModeExit;
      NOT_DISPLAYING:  S:= SModeBlank;
    end;
    FmtStr( sCurrentCaption, SLivePrefix, [S] );
  end;

  // When the window is resized, we add '(X x Y)' to the caption string,
  // then remove it on the next redraw.
  S := sCurrentCaption;
  if Timer1.Enabled then
    S := S + ' (' + IntToStr(szLastSize.cx) + 'x'
                  + IntToStr(szLastSize.cy - PButtons.Height) +')';
  Caption := S;
end;

procedure TFPreviewWindow.FormCreate(Sender: TObject);
var
  Flag: UINT;
  AppSysMenu: THandle;
begin
  SLivePrefix      := 'LIVE - %s';
  SModeSelect      := 'Select a song';
  SModeSong        := 'Showing song';
  SModeSearchWords := 'Search for Title';
  SModeSearchTitle := 'Search within Song Words';
  SModeSearching   := 'Search Results';
  SModeExit        := 'Quit?';
  SModeBlank       := '<blank>';

  hExtRichEdit   := nil;
  sLastPic       := '';
  iCurrentPage   := 0;
  iPages         := 0;
  LastID         := '';
  bHasBackground := false;
  bHasButtons    := false;
  bHasInfo       := false;
  bDisplayButs   := false;
  setlength( Pics, 0 );
//  RichEdit1.Color := clBlack;
  szLastSize.cx   := 0;
  szLastSize.cy   := 0;
  setlength( PageButtons, 0 );
  sCurrentCaption := Caption;
//  UnscaledImg := nil;
  iPagesVisible := 0;

  // Each PreviewWindow has a 'rendering image' used to scale the
  // full-size image down to 'preview' size.
  RenderImage := nil;

  // Disable the 'CLOSE' button on the menu bar in the preview window
  if Self = FPreviewWindow then begin
    // The Live window uses the RTF control from the FProjWin form directly
    FRTF := TWindowlessRTF.Create();
    FRTF.SetTransparent(true);
    FRTF.SetWordWrap(true);

    AppSysMenu:=GetSystemMenu(Handle,False);
    Flag:=MF_GRAYED or MF_DISABLED;
    EnableMenuItem(AppSysMenu,SC_CLOSE,MF_BYCOMMAND or Flag);
  end;
end;

procedure TFPreviewWindow.SetHasButtons(Value: boolean);
begin
  bHasButtons  := Value;
  bDisplayButs := bHasButtons or bHasInfo;
  if Visible then begin
    PButtons.Visible     := bDisplayButs;
    PButtonPanel.Visible := bHasButtons;
  end;
end;

procedure TFPreviewWindow.SetHasInfo(Value: boolean);
begin
  bHasInfo     := Value;
  bDisplayButs := bHasButtons or bHasInfo;
  if Visible then begin
    PButtons.Visible := bDisplayButs;
    PCaption.Visible := bHasInfo;
  end;
end;


procedure TFPreviewWindow.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  // We force aspect ratio to be maintained
  if FSettings.CBPreviewAspect.checked and
     (0 <> FSongbase.szDisplaySize.cx) and
     (0 <> FSongbase.szDisplaySize.cy) then begin
    NewHeight := (FSongBase.szDisplaySize.cy * NewWidth) div FSongBase.szDisplaySize.cx;
    Resize := true;
    if bDisplayButs then
      NewHeight := NewHeight + PButtons.Height;
  end;
//  Image1.SetBounds( 0,0, 400, 300 );
  LogThis( '''' + Self.Caption + ''' resized to (' + IntToStr(NewWidth) + ', '+ IntToStr(NewHeight) +')' );
end;

procedure TFPreviewWindow.BPageButtonClick( Sender : TObject );
var NewButton : TButton;
    i: integer;
    uiKey : word;
    Shift :TShiftState;
begin
  Shift := [];
  NewButton := TButton(Sender);
  if CurrentPage > 0 then
    PageButtons[CurrentPage-1].Font.Style := [];

  // Find the button
  for i := 1 to iPages do begin
    if PageButtons[i-1] = NewButton then begin
      if FPreviewWindow = Self then begin
        LoadOHP( LastID, i );
      end else if FProjWin.BlindMode = SHOWING_SONG then begin
        PageButtons[i-1].Font.Style := [fsBold];
        if( SCS[i*2+1] and 1 ) <> 0 then Shift := Shift + [ssShift];
        if( SCS[i*2+1] and 2 ) <> 0 then Shift := Shift + [ssCtrl];
        if( SCS[i*2+1] and 4 ) <> 0 then Shift := Shift + [ssAlt];
        uiKey := SCS[i*2];
        LogThis( 'Page Button Clicked - page ' + IntToStr(i) + ' - key '+ IntToStr(uiKey) );
        FProjWin.EBlind2KeyDown( Sender, uiKey, Shift );
      end;
      break;
    end;
  end;
end;

procedure TFPreviewWindow.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var iNewPage : integer;
    hSender  : TObject;
begin
  LogThis( '''' + Self.Caption + ''' Processing Key '+ IntToStr(Key) );
  if Self <> FPreviewWindow then begin
    FProjWin.EBlind2.SetFocus;
    FProjWin.EBlind2KeyDown( Sender, Key, Shift );
    LogThis( 'Key passed to Projection Window' );
  end else begin
    if (Key = VK_F7) or (Key = VK_RIGHT) then begin
      LogThis( 'F7/Right in projection window' );
      iNewPage := CurrentPage + 1;
      if iNewPage <= Pages then
        LoadOHP( FSongbase.EID.Text, iNewPage );
      Key := 0;
    end else if (Key = VK_F6) or (Key = VK_LEFT) then begin
      LogThis( 'F6/Left in projection window' );
      iNewPage := CurrentPage - 1;
      if iNewPage > 0 then
        LoadOHP( FSongbase.EID.Text, iNewPage );
      Key := 0;
    end else if Key = VK_F5 then begin
      LogThis( 'F5 in projection window' );
      Key := 0;
      FPreviewWindow.BProjectSong.Click();
    end else begin
      LogThis( 'Key passed back to main Songbase window' );
      if Sender <> FProjWin then hSender := Self else hSender := Sender;
      FSongBase.FormKeyDown(hSender,Key,Shift);
    end;
  end;
end;

procedure TFPreviewWindow.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  LogThis( '''' + Self.Caption + ''' Closing' );
  if (Self <> FPreviewWindow) and (Closer = nil) then FProjWin.Close;
  LogThis( '''' + Self.Caption + ''' Closed' );
end;

procedure TFPreviewWindow.FormActivate(Sender: TObject);
begin
  LogThis( '''' + Self.Caption + ''' Activated' );
  Closer := nil;
end;

{procedure TFPreviewWindow.UpdateCopyright;
begin
  LogThis( '''' + Self.Caption + ''' Copyright information updated' );
  Self.Invalidate;
end;}

procedure TFPreviewWindow.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  hButton : TButton;
  iIdx    : integer;
  rMouseRect : TRect;
begin
  LogThis( '''' + Self.Caption + ''' Window requested to close' );
  CanClose := true;
  if (Closer = nil) and (Self = FLiveWindow) then begin
    with CreateMessageDialog( FSongbase.SStopProjTxt,
                              mtConfirmation, [mbYes, mbNo] ) do
    try
      { Set the 'No' button as the default }
      for iIdx := 0 to ComponentCount-1 do begin
        if Components[iIdx] is TButton then begin
          hButton := TButton(Components[iIdx]);
          if hButton.Caption = '&No' then ActiveControl := hButton;
        end;
      end;
      { Centre it }
      DefaultMonitor := dmDesktop;
      Position := poScreenCenter;
      Caption  := FSongbase.SStopProjCap;
      { And display it }
      rMouseRect := BoundsRect;
      ClipCursor( @rMouseRect );
      CanClose := ( mrYes = ShowModal );
      ClipCursor( nil );
    finally
      Free;
    end;
  end;
  LogThis( 'Can Close? ' + BoolToStr(CanClose, true) );
end;

procedure TFPreviewWindow.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  UpdateCaptions();
  LogThis( 'Preview Window resize Timer finished' );
end;

procedure TFPreviewWindow.FormDestroy(Sender: TObject);
begin
  LogThis( 'Destroying Window ''' + Self.Caption +'''' );
//  if UnscaledImg <> nil then UnscaledImg.Free;

  FRTF := nil;
  if RenderImage <> nil then RenderImage.Destroy;
end;


procedure TFPreviewWindow.WMWindowPosChanging(var hMsg: TWMWindowPosChanging);
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

    LogThis( 'Window Restricted to ' + IntToStr(rCurRect.Left) + ', ' +IntToStr(rCurRect.Top) );
    hMsg.WindowPos.x := rCurRect.Left;
    hMsg.WindowPos.y := rCurRect.Top;
  end;
  inherited;
end;

procedure TFPreviewWindow.BBlankClick(Sender: TObject);
begin
  FSongbase.ProjectSong( '', 0, false);
end;

procedure TFPreviewWindow.BNextClick(Sender: TObject);
begin
  if FSongbase.bMultiMonitor then begin
    if (CurrentPage < Pages) then LoadOHP( FSongbase.EID.Text, CurrentPage+1 )
    else if( FSongbase.StringGrid1.Row < FSongbase.StringGrid1.RowCount ) then begin
      FSongbase.StringGrid1.Row := FSongbase.StringGrid1.Row + 1;
    end;
  end;
end;

procedure TFPreviewWindow.BPreviousClick(Sender: TObject);
begin
  if FSongbase.bMultiMonitor then begin
    if CurrentPage > 1 then LoadOHP( FSongbase.EID.Text, CurrentPage-1 )
    else if( FSongbase.StringGrid1.Row > 0 ) then begin
      FSongbase.StringGrid1.Row := FSongbase.StringGrid1.Row - 1;
      LoadOHP( FSongbase.EID.Text, Pages );
    end;
  end;
end;

procedure TFPreviewWindow.CMDialogKey(var Message: TCMDialogKey);
begin
  if (Message.Charcode = VK_RETURN) or (Message.Charcode = VK_SPACE) then begin
    ActiveControl := nil;
    Message.Charcode := 0;
  end;
  if (Message.Charcode = VK_DOWN) or (Message.Charcode = VK_UP) or
     (Message.Charcode = VK_RIGHT) or (Message.Charcode = VK_LEFT) then begin
    Message.Charcode := 0;
  end;
  inherited;
end;

end.

