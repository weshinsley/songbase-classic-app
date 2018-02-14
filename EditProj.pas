  unit EditProj;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Printers, StdCtrls, ComCtrls, ExtCtrls, ImgList, ToolWin, SBZipUtils, SBFiles, RichEdit, JPEG,
  IdBaseComponent, IdComponent, WindowlessRTF;

type
  PTImage = ^TImage;

  TFEditProj = class(TForm)
    RESong: TRichEdit;
    Cop1: TLabel;
    Cop2: TLabel;
    EBlind: TEdit;
    EBlind2: TEdit;
    LLicense: TLabel;
    ImgOnscreen: TImage;
    LHelp: TLabel;
    ImgBackground: TImage;
    ImgBlank: TImage;
    procedure FormShow(Sender: TObject);
    procedure ActualFormShow(Sender: TObject; from_webserver : boolean);
    procedure RESongSelectionChange(Sender: TObject);
    procedure InitFiles(Sender : TObject; from_webserver : boolean);
    function StringSC(A,B : word) : string;
    procedure SaveOHP;
    Procedure SaveAtts;
    Procedure RestAtts;
    procedure EBlindKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EBlindExit(Sender: TObject);
    procedure ZipMeUp;
    procedure FormCreate(Sender: TObject);
    procedure ShowLabels(x,y:integer; bRight:boolean = false);
    procedure UpdateLabels(i : integer);
    procedure HideLabels;
    procedure EBlind2Exit(Sender: TObject);
    procedure EBlind2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LoadOHPData(FS : string);
    procedure MarkOHP(cID : string);
    function NextShortCut : integer;
    function ShortCutInUse(i : integer) : boolean;
    procedure LoadCopyRight(cid : string);
    procedure SetGlobals;
    function SearchRTF(S : string; cID : string) : boolean;
    procedure FindRTFText(Ss : string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetEditWidth;
    procedure EBlindKeyPress(Sender: TObject; var Key: Char);
    procedure EBlind2KeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure ShowTheSong(id : string);
    procedure RESongEdited(Sender: TObject);
    procedure UpdateDisplay;
    procedure RightAlignCaptions;
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure FormPaint(Sender: TObject);
//    procedure FormResize(Sender: TObject);
    procedure SelectPage( iSong : string; iPage : integer; from_webserver : boolean);
    procedure ShowSelectLabels( iOffset : integer = 0 );

  private
    { Private declarations }
    bReady    : boolean;
    bHasImgBackground : boolean;
    //bHasBlankPic : boolean;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;



//    procedure DrawIt( hTextImg, hBackImg, hOutImg : TImage );
  public

    bForceRedraw : boolean;
    bDrawable : boolean;
    bHighQuality : boolean;
    bScaleProjection : boolean;
    bShowHighlight : boolean;
    GHighlight : string;
    GID : string;  { Public declarations }
    GTitle : string;
    GCopy1 : string;
    GCopy2 : string;
    EditGID : string;   { If we wish to Edit rather than view a song }
    LastID   : string;  { Remember last displayed song for recall }
    LastPage : integer; { Remember last displayed page for recall }
    AutoUpdateOHP : boolean;
    Pages : integer;
    ShowPage : integer;
    Pics : array of string;
    SearchNo,CurrentPage : integer;
    bSetOffsets : boolean;
    CurrentDisplayArea : TRect;
    LastPic : string;
    CurrentSong : string;
    ImgOffscreen : TImage;
    ImgScaler: TImage;
    WindowBackground : TColor;
    {}
    OrigData : string;
    TitleList : TStringlist;
    {}
    BlindMode : byte;
    bHasTools : boolean;
    Scs : ShortcutArray;
    SaveB,SaveI,SaveU : boolean;
    SaveCol : TColor;
    ResultVal,SaveSize,SaveFont : Integer;
    PageLabs : array[1..99] of TLabel;
    SaveJ : byte;
    SearchID,SearchString : string;
    SearchResults : TStringList;
    Blanked : boolean;
    ShowImage : boolean;
    ShowPageLabels : boolean;
    BlankImgFile : string;
    {}
    FRTF : TWindowlessRTF;
    {}
    procedure PrepareWindow;
    procedure BlankWindow(var bUnhandled : boolean; from_webserver : boolean);
    function IsDefaultOrdering( iExclude : integer = 0 ) : boolean;
    procedure ShowHighlight( bShow : boolean );
    procedure SelectSong( SongID : string; bNoInitial : boolean; from_webserver : boolean);
    

 //   procedure ReorderShortcuts(i : integer);
  end;

const ITEM_IDX_AS_PROJECTED = 0;
      ITEM_IDX_FULL_SCREEN  = 1;
      ITEM_IDX_640_480      = 2;
      ITEM_IDX_800_600      = 3;
      ITEM_IDX_1024_768     = 4;
      ITEM_IDX_1152_864     = 5;
      ITEM_IDX_1280_1024    = 6;

var
  FProjWin: TFEditProj;
  FEditWin: TFEditProj;

  SModeExit, SModeSearchWords, SModeSearchTitle : string;
  SModeSearchResultCount, SModeSearchResultIdx : string;
  SModeSelect, SModeSearchResultNone,  SModeShortcut  : string;

  hLastKeyTime     : TDateTime;
  hLastKeyValue    : word;

const NOT_DISPLAYING = 255;
const SELECTING_SONG = 0;
const SHOWING_SONG = 1;
const FINDING_TITLE = 2;
const SEARCHING_TEXT = 3;
const CHOOSING_RESULT = 4;
const QUITTING = 5;
const chr128 = chr(128);
const TEXT_OFFSET = 5;
const VK_B   = ord('B');
const VK_ONE = ord('1');

  implementation

uses Appear, Math, SBMain, OHPPrint, Tools, PreviewWindow, PageCache, ActiveX, DateUtils,
  WebServer, NetSetup;

{$R *.DFM}

function PrintToCanvas(ACanvas : TCanvas; FromChar, ToChar : integer;
                      ARichEdit : TRichEdit; AWidth, AHeight : integer) : Longint;
var
  Range    : TFormatRange;
begin
   FillChar(Range, SizeOf(TFormatRange), 0);
   Range.hdc        := ACanvas.handle;
   Range.hdcTarget  := ACanvas.Handle;
   Range.rc.left    := 0;
   Range.rc.top     := 0;
   Range.rc.right   := AWidth  * 1440 div Screen.PixelsPerInch; // ?
   Range.rc.Bottom  := AHeight * 1440 div Screen.PixelsPerInch;
   Range.chrg.cpMax := ToChar;
   Range.chrg.cpMin := FromChar;
   Result := SendMessage(ARichedit.Handle, EM_FORMATRANGE, 1, Longint(@Range));
   SendMessage(ARichEdit.handle, EM_FORMATRANGE, 0,0);
end;

procedure TFEditProj.ShowLabels(x,y : integer; bRight: boolean = false );
const cols : array[0..7] of TColor =(clWhite,clAqua,clFuchsia,clLime,clOlive,clPurple,clTeal,clMaroon);
var i, w, xOrigin, xLast : integer;
    hFontStyle : TFontInfo;
    uiStyle : TFontStyles;
begin
  xLast := 0;
  if bRight then hFontStyle := FSettings.CopyrightFont
            else hFontStyle := FSettings.CCLIFont;

  w := 0;
  uiStyle := [];
  if hFontStyle.ForceBold   and hFontStyle.Bold   then include( uiStyle, fsBold   );
  if hFontStyle.ForceItalic and hFontStyle.Italic then include( uiStyle, fsItalic );

  if FSongbase.bProjectHints then begin
    if not bRight then xOrigin := x else xOrigin := 0;
    for i:=1 to Pages do begin
      Pagelabs[i].Caption:=chr(SCS[i*2]);
      if hFontStyle.ForceName then Pagelabs[i].Font.Name  := hFontStyle.Name
                              else Pagelabs[i].Font.Name  := FSettings.DefaultSmallFont.Name;
      if hFontStyle.ForceSize then Pagelabs[i].Font.Size  := hFontStyle.Size
                              else Pagelabs[i].Font.Size  := FSettings.DefaultSmallFont.Size;
      Pagelabs[i].Font.Style := uiStyle;
      if hFontStyle.ForceColor then Pagelabs[i].Font.Color := hFontStyle.Color
                               else Pagelabs[i].Font.Color:=Cols[SCS[(i*2)-1]];
      if bScaleProjection then
        Pagelabs[i].Font.Size := (Pagelabs[i].Font.Size * Height) div FSettings.szProjectScale.cy;

      if 0 = w then w := Pagelabs[i].Width;
      Pagelabs[i].Left:=xOrigin + (i-1)*((4*w) div 3);
      xLast := Pagelabs[i].Left + Pagelabs[i].Width;
      PageLabs[i].TransParent:=true;
      Pagelabs[i].Top:=y;
      PageLabs[i].Parent:=FProjWin;
    end;
    for i:=Pages+1 to 99 do begin
      PageLabs[i].Visible:=false;
      PageLabs[i].Enabled:=false;
      PageLabs[i].Parent:=FProjWin;
    end;

    for i:=1 to Pages do begin
      if bRight then begin
        Pagelabs[i].Left := x - (xLast - Pagelabs[i].Left);
      end;
      PageLabs[i].Visible:=true; PageLabs[i].Enabled:=true;
    end;

  end;
  ShowPageLabels := (Pages>0);
end;

procedure TFEditProj.UpdateLabels(i : integer);
var j : integer;
begin
  if (not FWebServer.isServerEnabled) then begin
  if FSongbase.bProjectHints then begin
    for j:=1 to Pages do begin
      if (PageLabs[j]<>nil) then begin
        PageLabs[j].Enabled:=false;
        Pagelabs[j].Visible:=false;
        if (j=i) then
          Pagelabs[j].Font.Style:=[fsBold]
          else Pagelabs[j].Font.Style:=[];
        PageLabs[j].Enabled:=true;
      end;
    end;
  end;
  end;
  ShowPageLabels := (Pages>0);
end;

procedure TFEditProj.Hidelabels;
var i : integer;
begin
  for i:=1 to 99 do PageLabs[i].Visible:=false;
  ShowPageLabels := false;
end;



procedure TFEditProj.FindRTFText(Ss : string);
var i : integer;
    SearchIDs : TStringList;
begin
  SearchResults.Clear;
  SearchIDs := TStringList.Create;
  PageCache_TextSearch( Ss, SearchIDs, High(integer), false, true );
  for i := 0 to SearchIDs.Count-1 do begin
    SearchResults.Add( PageCache_GetSongName( SearchIDs[i] ) );
  end;

end;


function TFEditProj.SearchRTF(S : string; cID : string) : boolean;
{var S2 : string;
    TF : textfile;
    found : boolean;}
begin
  SearchRTF := PageCache_TextContains( cID, S );

end;

procedure TFEditProj.SetGlobals;
var displayed : boolean;
    i, iDisplayY : integer;
    // iDisplayX : integer;
    sNextBG : string;
begin
  displayed:=false;
  RESong.HideSelection:=true;
  RESong.SelectAll;

  // Is there an individual background graphic for this page?
  bHasImgBackground := false;

  // If blanked, and there's a blanking image, don't show the BG image
  if Blanked and (BlankImgFile <> '') then begin
    displayed := true;
  end;

  if not FTools.Visible then begin
    if FSettings.PrimaryFont.ForceName then RESong.SelAttributes.Name:=FSettings.PrimaryFont.Name;
    if FSettings.PrimaryFont.ForceSize then RESong.SelAttributes.Size:=FSettings.PrimaryFont.Size;
    if FSettings.PrimaryFont.ForceBold then begin
      if FSettings.PrimaryFont.Bold
            then RESong.SelAttributes.Style:=RESong.SelAttributes.Style+[fsBold]
            else RESong.SelAttributes.Style:=RESong.SelAttributes.Style-[fsBold]
    end;
    if FSettings.PrimaryFont.ForceItalic then begin
      if FSettings.PrimaryFont.Italic
            then RESong.SelAttributes.Style:=RESong.SelAttributes.Style+[fsItalic]
            else RESong.SelAttributes.Style:=RESong.SelAttributes.Style-[fsItalic]
    end;
    if FSettings.PrimaryFont.ForceColor   then RESong.SelAttributes.Color := FSettings.PrimaryFont.Color;

    if not displayed
          and (CurrentPage>0)
          and (length(Pics)>=CurrentPage)
          and ( '' <> Pics[CurrentPage-1])
          and FileExists(Pics[CurrentPage-1])
          and (not FSettings.ImageTick.Checked or
               not FSettings.ForceBGImage.Checked) then begin
      displayed := true;
      if (Pics[CurrentPage-1]<>LastPic) then begin
        LastPic:=Pics[CurrentPage-1];
        LogThis( 'Custom Background image ' );
        LogThis( 'Loading Background image ' + Pics[CurrentPage-1] );
        ImgBackground.Picture.LoadFromFile(Pics[CurrentPage-1]);
        LogThis( 'Background image loaded' );
      end;
      bHasImgBackground := true;
    end;
  end;

  // Are we using a background list?
  if not displayed and
     FSettings.cbBGOrder.Enabled and
     (FSettings.cbBGOrder.ItemIndex <> -1) then begin
    sNextBG := FSettings.GetNextBackground(LastPic,LastID <> CurrentSong,CurrentPage);
    if (sNextBG <> '') and FileExists(sNextBG) then begin
      displayed := true;
      if sNextBG <> LastPic then begin
        LastPic := sNextBG;
        LogThis( 'Loading next Background image ''' + sNextBG + '''' );
        ImgBackground.Picture.LoadFromFile(sNextBG);
      end;
      bHasImgBackground := true;
    end;
  end;

  // Deal with backgrounds
  if Color        <> clBlack then Color        := clBlack;
  if RESong.Color <> clBlack then RESong.Color := clBlack;

  if not FTools.Visible and not displayed then begin
    if FSettings.ImageTick.Checked then begin
      displayed := true;
      if (FSettings.ImageFile<>LastPic) then begin
        if FileExists(FSettings.ImageFile) then begin
          LastPic := FSettings.ImageFile;
          LogThis( 'Loading Background image ' + FSettings.ImageFile + '' );
          ImgBackground.Picture.LoadFromFile(FSettings.ImageFile);
          LogThis( 'Background image loaded' );
          bHasImgBackground := true;
        end;
      end else begin
        bHasImgBackground := true;
      end;
    end else if (FSettings.BackTick.checked) then begin
      RESong.Color := FSettings.PColb.Color;
      displayed := true;
  //    LogThis( 'Background colour set to ' + IntToStr(RichEdit1.Color) );
    end;
  end;

  if not displayed then begin
    bHasImgBackground := false;
    LastPic := '';
  end;

  if bHasTools then begin
    if displayed and bHasImgBackground then begin
      bHasImgBackground := false;
      RESong.Color      := clBlack;
    end;
    Color := WindowBackground;
  end;

  if (FSettings.ELicense.Text<>'') then begin
    LLicense.Caption:='CCLI License No. '+FSettings.ELicense.Text;
    LLicense.Visible:=true;
    LLicense.Enabled:=true;
  end else begin
    LLicense.Enabled := false;
    LLicense.Visible := false;
  end;

  RESong.selLength:=0;
  RESong.HideSelection:=false;

  LLicense.Left:= CurrentDisplayArea.Left + FSongbase.rCCLIArea.Left + TEXT_OFFSET;

  FSettings.SetLabelFont( Cop1, FSettings.CopyrightFont, FSettings.DefaultSmallFont );
  FSettings.SetLabelFont( Cop2, FSettings.CopyrightFont, FSettings.DefaultSmallFont );
  FSettings.SetLabelFont( LLicense,  FSettings.CCLIFont, FSettings.DefaultSmallFont );

//iDisplayX := CurrentDisplayArea.Right  - CurrentDisplayArea.Left;
  iDisplayY := CurrentDisplayArea.Bottom - CurrentDisplayArea.Top;

  if bScaleProjection then begin
    Cop1.Font.Size     := (Cop1.Font.Size     * iDisplayY) div FSettings.szProjectScale.cy;
    Cop2.Font.Size     := (Cop2.Font.Size     * iDisplayY) div FSettings.szProjectScale.cy;
    LLicense.Font.Size := (LLicense.Font.Size * iDisplayY) div FSettings.szProjectScale.cy;
  end;

  Cop2.Top      := FSongbase.rCopyArea.Bottom - TEXT_OFFSET - Cop2.Height;
  Cop1.Top      := Cop2.Top - Cop1.Height - 2;
  LLicense.Top  := FSongbase.rCCLIArea.Bottom - TEXT_OFFSET - LLicense.Height;

  if (Self = FEditWin) and bScaleProjection then begin
    Cop1.Top     := (Cop1.Top     * iDisplayY) div FSettings.szProjectScale.cy;
    Cop2.Top     := (Cop2.Top     * iDisplayY) div FSettings.szProjectScale.cy;
    LLicense.Top := (LLicense.Top * iDisplayY) div FSettings.szProjectScale.cy;
  end;

  for i:=1 to Pages do begin
    Pagelabs[i].Top:=Cop1.Top;
  end;

  // Hide the labels when we're editing
  if FTools.Visible then begin
    LLicense.Visible := false;
    Cop1.Visible     := false;
    Cop2.Visible     := false;
  end;

  UpdateDisplay;
end;

function TFEditProj.NextShortCut : integer;
var Got : String;
    I,J : integer;
    A,B : Word;
    C : boolean;
begin
  i:=1;
  repeat
    inc(i);
    Got:=FTools.CBSC.Items.Strings[i];
    C:=false;
    j:=1;
    while (j<Pages) and (not C) do begin
      A:=SCS[(j*2)-1];
      B:=SCS[(J*2)];
      if StringSC(A,B)=Got then c:=true;
      inc(j);
    end;
  until not c;
  NextShortCut:=i;
end;

function TFEditProj.ShortCutInUse(i : integer) : boolean;
var C : boolean;
    j : integer;
    A,B : word;
begin
  C:=false;
  j:=1;
  while (j<=Pages) and (not C) do begin
    A:=SCS[(J*2)-1];
    B:=SCS[(J*2)];
    if (FTools.CBSC.Items.IndexOf(StringSC(A,B))=i) then c:=true;
    inc(J);
  end;
  ShortCutInUse:=C;
end;

// Returns true if the shortcuts for the current song are in the normal 1,2,3... order
function TFEditProj.IsDefaultOrdering( iExclude : integer = 0 ) : boolean;
var p : integer;
begin
  for p := 1 to Pages do begin
    if (iExclude <> p) and ( SCS[(p*2)] <> (p + (VK_ONE-1)) ) then begin
      IsDefaultOrdering := false;
      Exit;
    end;
  end;
  IsDefaultOrdering := true;
end;


{
procedure TFEditProj.ReorderShortcuts(i : integer);
var C : boolean;
    j : integer;
    A,B : word;
    NewA, NewB : word;
    S : string;
begin
  // Get the key data for the 'Next Shortcut'
  S:=FTools.CBSC.Items[NextShortcut];
  NewA:=0;
  if pos('Shift',S)>0 then NewA:=A+1;
  if pos('Ctrl',S)>0  then NewA:=A+2;
  if pos('Alt',S)>0   then NewA:=A+4;
  while pos('+',S)>0 do S:=copy(S,pos('+',S)+1,length(S));
  NewB:=ord(S[1]);
  if S='None' then begin NewA:=0; NewB:=0; end;

  // Find the page that matches this shortcut
  C:=false;
  j:=1;
  while (j<=Pages) and (not C) do begin
    A:=SCS[(J*2)-1];
    B:=SCS[(J*2)];
    if (FTools.CBSC.Items.IndexOf(StringSC(A,B))=i) then begin
      c:=true;
      SCS[(J*2)-1] := NewA;
      SCS[(J*2)]   := NewB;
    end;
    inc(J);
  end;
end;          }


procedure TFEditProj.MarkOHP(CID : string);
var S,Orig : string;
    TF,GF : Textfile;
    SR : SongRecord;
begin
  if not OpenForRead(TF,FileName) then Exit;
  if not OpenForWrite(GF,TempDir+'potato') then begin CloseTextfile(TF,FileName); Exit; end;
  while not eof(TF) do begin
    readln(TF,S); Orig:=S;
    Delimit(S,SR);
    if CID<>SR.ID then begin
      writeln(GF,Orig)
    end else begin
      SR.OHP:='1';
      PageCache_UpdateSR( SR );
      S := PageCache_GetSrcLine( SR.Id );
      writeln(GF,S);
    end;
  end;
  CloseTextfile(TF,FileName);
  CloseTextfile(GF,TempDir+'potato');
  erase(TF);
  rename(GF,FileName);
end;

procedure TFEditProj.ZipMeUp;
var i : integer;
    S : string;
begin
  AddFileToZip(TempDir+GID+'.ohp',OHPFile,true);
  for i:=1 to Pages do begin
    str(i,s);
    AddFileToZip(TempDir+GID+'-'+S+'.rtf',OHPFile,true);
  end;

  // Delete any previous random pages which are hanging about here...
end;

function TFEditProj.StringSC(A,B : word) : string;
var Sh : string;
begin
  sh:='';
  if A=1 then sh:='Shift+';
  if A=2 then sh:='Ctrl+';
  if A=3 then sh:='Shift+Ctrl+';
  if A=4 then sh:='Alt+';
  if A=5 then sh:='Shift+Alt+';
  if A=6 then sh:='Ctrl+Alt+';
  if A=7 then sh:='Shift+Ctrl+Alt+';
  if B<>0 then sh:=sh+chr(B);
  if sh='' then sh:='None';
  StringSC:=sh;
end;



procedure TFEditPRoj.LoadCopyRight(cid : string);
var SR : SongRecord;
begin
  PageCache_GetSong( cid, SR );
{  if OpenForRead(TF,FileName) then begin
    while not eof(TF) do begin
      readln(TF,S);
      Delimit(S,SR);
      if CID=SR.ID then begin }
        GTitle     := PageCache_GetSongName(cid);
        if SR.Cl1<>'' then GCopy1:=SR.Cl1 else GCopy1:='© '+SR.CopDate+' '+SR.Author;
        if SR.Cl2<>'' then GCopy2:=SR.CL2 else GCopy2:=SR.CopyRight;
        Cop1.Caption:=GCopy1; Cop1.Visible := true; Cop1.Enabled := true;
        Cop2.Caption:=GCopy2; Cop2.Visible := true; Cop2.Enabled := true;
        RightAlignCaptions;
//        if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateCopyright;
{      end;
    end;
    CloseTextfile(TF,FileName);
  end;}
end;


procedure TFEditProj.LoadOHPData(FS : string);
var i : integer;
begin
  bForceRedraw := false;
  Pages := PageCache_GetPageCount(FS);
  setlength(Pics,Pages);
  if Pages>0 then begin
    for i:=1 to Pages do begin
      PageCache_GetPageShortcut( FS, i, SCS[(i*2)-1], SCS[(i*2)] );
      Pics[i-1]:= PageCache_GetPagePicture(FS,i);
    end;
  end;
end;


procedure TFEditProj.InitFiles(Sender : TObject; from_webserver : boolean);
var hFiles : TStringList;
        SR : SongRecord;
begin

  Pages := PageCache_GetPageCount( GID );
  if Pages=0 then begin
    PageCache_GetSong( GID, SR );
    RESong.Lines.Clear;
    RESong.Lines.Add( SR.Title );
    RESong.Lines.SaveToFile(TempDir+GID+'-1.rtf');

    // Set up the shortcut to '1'
    Pages := 1;
    ShowPage := 1;
    SCS[2] := ord('1');
    SCS[1] := 0;
    SaveOHP;

    hFiles := TStringList.Create;
    hFiles.Add( TempDir+GID+'-1.rtf' );
    hFiles.Add( TempDir+GID+'.ohp' );
    AddFilesToZip( hFiles, OHPFile, true );
    hFiles.Free;

    PageCache_ForceReload(GID);
    UpdateFsH( GID, OHPFile, QSFile );
    LoadOHPData(GID);
  end;

  if Pages>=1 then begin
    if (ShowPage <= Pages) and (ShowPage > 0) then SelectPage( GID, ShowPage, from_webserver )
                                              else SelectPage( GID, 1, from_webserver);
  end;
  SetGlobals;

  if bHasTools then FTools.UpdateButtons;
//  if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateCopyright;
end;


procedure TFEditProj.SetEditWidth;
var //iW, iH : integer;
    rScreenArea, rRenderRect : TRect;
begin
  // Default is Full-screen
  CurrentDisplayArea := Rect( 0,0, Width, Height );

  if bHasTools then begin
    if FTools.CBScreen.ItemIndex<0 then FTools.CBScreen.ItemIndeX:=0;
    case FTools.CBScreen.ItemIndex of
      ITEM_IDX_AS_PROJECTED: begin
          CurrentDisplayArea.Right  := FSongbase.szDisplaySize.cx;
          CurrentDisplayArea.Bottom := FSongbase.szDisplaySize.cy;
        end;
      ITEM_IDX_640_480: begin
          CurrentDisplayArea.Right  := 640;
          CurrentDisplayArea.Bottom := 480;
        end;
      ITEM_IDX_800_600: begin
          CurrentDisplayArea.Right  := 800;
          CurrentDisplayArea.Bottom := 600;
        end;
      ITEM_IDX_1024_768: begin
          CurrentDisplayArea.Right  := 1024;
          CurrentDisplayArea.Bottom := 768;
        end;
      ITEM_IDX_1152_864: begin
          CurrentDisplayArea.Right  := 1152;
          CurrentDisplayArea.Bottom := 864;
        end;
      ITEM_IDX_1280_1024: begin
          CurrentDisplayArea.Right  := 1280;
          CurrentDisplayArea.Bottom := 1024;
        end;
    end;

    // Clip to screen
    if CurrentDisplayArea.Right  > Width  then CurrentDisplayArea.Right  := Width;
    if CurrentDisplayArea.Bottom > Height then CurrentDisplayArea.Bottom := Height;
  end;

  // And then centre on screen (at top)
//  iW := CurrentDisplayArea.Right;
//  iH := CurrentDisplayArea.Bottom;
  rScreenArea := CurrentDisplayArea;
  if bHasTools then begin
    OffsetRect( CurrentDisplayArea, (Width - CurrentDisplayArea.Right) div 2, 0 );
  end else if bScaleProjection then begin
//    iW := FSettings.szProjectScale.cx;
   // iH := FSettings.szProjectScale.cy;
  end;

  // Select the render position, and centre
  if bHasTools then begin
    rRenderRect.Left   := CurrentDisplayArea.Left + ((FSongbase.rTextArea.Left   * rScreenArea.Right ) div FSongbase.szDisplaySize.cx);
    rRenderRect.Right  := CurrentDisplayArea.Left + ((FSongbase.rTextArea.Right  * rScreenArea.Right ) div FSongbase.szDisplaySize.cx);
    rRenderRect.Top    := CurrentDisplayArea.Top  + ((FSongbase.rTextArea.Top    * rScreenArea.Bottom) div FSongbase.szDisplaySize.cy);
    rRenderRect.Bottom := CurrentDisplayArea.Top  + ((FSongbase.rTextArea.Bottom * rScreenArea.Bottom) div FSongbase.szDisplaySize.cy);
  end else begin
    rRenderRect := FSongbase.rTextArea;
  end;

  // Then put the RichEdit control in it (take of 40 more pixels at the bottom for 'captions')
  RESong.SetBounds( rRenderRect.Left,  rRenderRect.Top,
                    rRenderRect.Right  - rRenderRect.Left,
                    rRenderRect.Bottom - rRenderRect.Top );
  FRTF.SetClientRect( rRenderRect );

  RightAlignCaptions;
end;

procedure TFEditPRoj.SaveAtts;
begin
  SaveB:=[fsBold]<=RESong.SelAttributes.Style;
  SaveI:=[fsItalic]<=RESong.SelAttributes.Style;
  SaveU:=[fsUnderline]<=RESong.SelAttributes.Style;
  SaveCol:=RESong.SelAttributes.Color;
  SaveFont:=FTools.CBFont.Items.IndexOf(RESong.SelAttributes.Name);
  SaveSize:=RESong.SelAttributes.size;
  if RESong.Paragraph.Alignment=taCenter then SaveJ:=1;
  if RESong.Paragraph.Alignment=taRightJustify then SaveJ:=2;
  if RESong.Paragraph.Alignment=taLeftJustify then SaveJ:=3;
end;

procedure TFEditPRoj.RestAtts;
begin
  if SaveB then RESong.SelAttributes.Style:=RESong.SelAttributes.Style+[fsBold];
  if SaveI then RESong.SelAttributes.Style:=RESong.SelAttributes.Style+[fsItalic];
  if SaveU then RESong.SelAttributes.Style:=RESong.SelAttributes.Style+[fsUnderline];
  RESong.SelATtributes.Color:=SaveCol;
  RESong.SelAttributes.Name:=FTools.CBFont.Items.Strings[SaveFont];
  RESong.SelAttributes.Size:=SaveSize;
  if SaveJ=1 then Resong.Paragraph.Alignment:=taCenter;
  if SaveJ=2 then RESong.Paragraph.Alignment:=taRightJustify;
  if SaveJ=3 then RESong.Paragraph.Alignment:=taLeftJustify;
end;

procedure TFEditProj.RESongSelectionChange(Sender: TObject);
begin
  FTools.bDisableEvents := true;
  FTools.BBold.Down:=[fsBold]<=RESong.SelAttributes.Style;
  FTools.BItalic.Down:=[fsItalic]<=RESong.SelAttributes.Style;
  FTools.BUnder.Down:=[fsUnderline]<=RESong.SelAttributes.Style;
  FTools.PCol2.Color:=RESong.SelAttributes.Color;
  FTools.CBFont.ItemIndex:=FTools.CBFont.Items.IndexOf(RESong.SelAttributes.Name);
  FTools.UpDown1.Position:=RESong.SelAttributes.size;
  if RESong.Paragraph.Alignment=taLeftJustify then begin FTools.BLeft.Down:=true; FTools.BRight.Down:=false; FTools.BCent.Down:=false; end;
  if RESong.Paragraph.Alignment=taRightJustify then begin FTools.BRight.Down:=true; FTools.BLeft.Down:=false; FTools.BCent.Down:=false; end;
  if RESong.Paragraph.Alignment=taCenter then begin FTools.BCent.Down:=true; FTools.BRight.Down:=false; FTools.BLeft.Down:=false; end;
  FTools.bDisableEvents := false;
end;

procedure TFEditProj.SaveOHP;
var S,S2 : string;
    TF : Textfile;
    i : integer;
    ps : string;
begin
  LLicense.Visible := true;
  S:=GID+'.ohp';
  if OpenForWrite(TF,TempDir+S) then begin
    str(Pages,S);
    writeln(TF,S);
    for i:=1 to Pages do begin
      str(SCS[(i*2)-1],S);
      str(SCS[(I*2)],S2);
      if( Length(Pics)>0 ) then Ps:=Pics[i-1] else Ps:='';
      writeln(TF,S+'~'+S2+'$'+Ps);
    end;
    CloseTextfile(TF, TempDir+S);

    if FTools.Visible then begin
      FTools.BReload.Enabled := false;
      FTools.BSave.Enabled := false;
    end;
  end;
end;


procedure TFEditProj.EBlindKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var A,B : word;
    i : integer;
begin
  A:=0;
  B:=Key;
  if B=VK_ESCAPE then begin
//    TransparentColor := false;
    FTools.show;
    RESong.Visible := true;
    bScaleProjection := false;

    // Load in the text for the current page - as RESong may
    // differ from the Projection context
    PageCache_LoadRTF( FEditWin.RESong, FEditWin.GID, FEditWin.CurrentPage );
    FTools.BSave.Enabled   := false;
    FTools.BReload.Enabled := false;

//    ImgOnScreen.Visible := false;
    bHasTools := true;
    FTools.UpdateButtons;
    SetGlobals;
    ShowCursor(true);
    Cop1.Visible:=false; Cop1.Enabled := false;
    Cop2.Visible:=false; Cop2.Enabled := false;
    LLicense.Visible := false;
    Invalidate;
  end else
  if (B=VK_RIGHT) and ((CurrentPage<Pages) or Blanked) then begin
    i := CurrentPage;
    inc(i);
    if i>Pages then i:=Pages;
    SelectPage( GID, i, false);
  end else
  if (B=VK_LEFT) and ((CurrentPage>1) or Blanked) then begin
    i := CurrentPage;
    dec(i);
    if i<1 then i:=1;
    if i <= Pages then begin
      SelectPage( GID, i, false);
    end;
  end else
  if (B=VK_HOME) and ((CurrentPage<>1) or Blanked) then begin
    if Pages > 0 then begin
      SelectPage( GID, 1, false);
    end;
  end else
  if (B=VK_END) and ((Blanked) or (CurrentPage<>Pages)) then begin
    if Pages<>0 then begin
      SelectPage( GID, Pages, false);
    end;
  end else begin
    if [ssShift]<=Shift then A:=A+1;
    if [ssCtrl]<=Shift then A:=A+2;
    if [ssCtrl]<=Shift then A:=A+4;
    i:=0;
    repeat
      inc(i);
    until ((SCS[(i*2)-1]=A) and (SCS[(i*2)]=B)) or (i>Pages);
    if (i<=Pages) and (Blanked or (i<>CurrentPage)) then begin
      i := CurrentPage;
      SelectPage( GID, i, false);
    end;
  end;
  EBlind.TexT:='';
  EBlind.SetFocus;
  EBlind.SendToBack;
end;

procedure TFEditProj.EBlindExit(Sender: TObject);
begin
 if not FTools.Visible and (BlindMode = NOT_DISPLAYING) then EBlind.SetFocus;
end;

procedure TFEditProj.FormCreate(Sender: TObject);
var i : integer;
begin
  FRTF := TWindowlessRTF.Create();
  FRTF.SetTransparent(true);
  FRTF.SetWordWrap(true);
  bHasImgBackground := false;

  if Self = FEditWin then begin
    // Editor window - redraws the 'live window' when text changes
    RESong.OnChange          := RESongEdited;
    RESong.OnSelectionChange := RESongSelectionChange;
  end;
  Titlelist:=TStringlist.create;
  Titlelist.sorted:=true;
  for i:=1 to 99 do begin
    Pagelabs[i]:=TLabel.Create(self);
  end;
  SearchResults:=TStringList.Create;
  height:=screen.height;
  width :=screen.width;
  top:=0;
  left:=0;
  Cop1.Top:=Height - 40;
  Cop2.Top:=Height - 20;
  bSetOffsets := false;
  bReady      := false;
  bScaleProjection := false;
  bHighQuality := true;
  ImgScaler := nil;
  ImgOffscreen := nil;
  BlankImgFile := '';
  bShowHighlight := false;
  WindowBackground := clBlack;
  bForceRedraw := false;

  SModeSelect            := 'Select';
  SModeSearchResultCount := 'Search Results (%d)';
  SModeSearchResultIdx   := 'Search Result (%d/%d)';
  SModeSearchResultNone  := 'Select (No Results)';
  SModeShortcut          := 'Shortcut=%s';
  SModeSearchWords       := 'Search Text';
  SModeSearchTitle       := 'Find Title';
  SModeExit              := 'Exit (Y/N)';
end;

procedure TFEditProj.EBlind2Exit(Sender: TObject);
begin
  if BlindMode<>NOT_DISPLAYING then begin
    LogThis( 'Blind2 regaining focus' );
    EBlind2.SetFocus;
    EBlind2.SendToBack;
  end;
end;

function before(S1,S2 : string) : boolean;
var A,B,C,D : string;
    i : integer;
begin
  A:=uppercase(S1); C:='';
  B:=uppercase(S2); D:='';
  for i:=1 to length(A) do if pos(A[i],'ABCDEFGHIJKLMNOPQRSTUVWXYZ')>0 then C:=C+A[i];
  for i:=1 to length(B) do if pos(B[i],'ABCDEFGHIJKLMNOPQRSTUVWXYZ')>0 then D:=D+B[i];
  before:=(C<D) and (copy(C,1,length(D))<>D);
end;

procedure TFEditPRoj.ShowTheSong(id : string);
begin
  LogThis( 'Projecting song ' + id + ', page ' + IntToStr(CurrentPage) );
  GID:=id;

  LoadOHPData(GID);
  LoadCopyright(GID);
  CurrentPage:=0;
  LastID := GID;      // Also here sets LastID so that Selecting a song works!
  UpdateLabels(CurrentPage);
  if not bHasTools then BlindMode:=SHOWING_SONG;
  ShowLabels(LLicense.Left,LLicense.Top - LLicense.Height - TEXT_OFFSET );
  MarkOHP(GId);
  If (( (Pages=1) and (FSettings.AutoViewSingle1.Checked) )
     or (FSettings.AutoView1.Checked) ) then begin
    SelectPage( GID, 1, false);
  end;
  Cop1.Visible:=true; Cop1.Enabled := true;
  Cop2.Visible:=true; Cop2.Enabled := true;
  ShowHighlight( false );
end;


procedure TFEditProj.EBlind2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Code,i,count : integer;
    done : boolean;
    S,CheckID,CheckK : string;
    A,B,CheckA,CheckB : word;
    bA, bB : boolean;
    SR : SongRecord;
    bUnhandled : boolean;
    hTimeNow   : TDateTime;
    OldMode    : byte;
    SPostfix   : string;
begin
  A:=0;
  B:=Key;
  bUnhandled := true;
  LogThis( 'Projection Window handling key ' + IntToStr(Key) );
  OldMode  := BlindMode;
  SPostfix := '';

  // Pressing the same key twice in very quick succession is assumed to be
  // a mistake! Unless we're in a mode where we enter text, or the key in question
  // is a cursor.
  hTimeNow := GetTime();
  if bIgnoreDoubleClicks and (Key <> VK_LEFT) and (Key <> VK_RIGHT) and
     (Key <> VK_ESCAPE) and
     (hLastKeyValue = Key) and
     (BlindMode <> FINDING_TITLE) and (BlindMode <> SEARCHING_TEXT) and
     (MilliSecondsBetween( hTimeNow, hLastKeyTime ) < DoubleClickDelay) then begin
    bUnhandled := false;
    B := 0;
  end else
    hLastKeyTime := hTimeNow;
  hLastKeyValue  := Key;

  if bUnhandled and
     FSongbase.bMultiMonitor and
     (BlindMode <> FINDING_TITLE) and
     (BlindMode <> SEARCHING_TEXT) and
     (BlindMode <> CHOOSING_RESULT) then begin
    // SPACE/RETURN triggers projection
    if ( (B = VK_SPACE) or (B = VK_RETURN) ) then begin
      LogThis( 'Space/Enter key in projection window' );
      FPreviewWindow.BProjectSong.Click();
      bUnhandled := false;
    end
    // LEFT/RIGHT/RETURN gets sent back to the Preview Window
    else if (Sender <> FPreviewWindow) and
            ( (B=VK_LEFT) or (B=VK_RIGHT) ) then begin
      FPreviewWindow.FormKeyDown(Self,Key,Shift);
      bUnhandled := false;
    end;
  end;

  if bUnhandled and (BLindMode=QUITTING) then begin
    Cop1.Visible:=false;  Cop1.Enabled := false;
    if B=89 then close;
//    ShowHighlight( false );

    BlindMode:=SELECTING_SONG;
    bUnhandled := false;
    
{    ShowSelectLabels;

    if not FSongbase.bProjectHints then begin Cop2.Visible := false; Cop2.Enabled := true; end;
    Cop2.Caption:='Select';
    RightAlignCaptions;
    if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;}
  end else if bUnhandled and (BlindMode=SELECTING_SONG) then begin
    if (B=VK_F3) and FSettings.cbF2F3WinSearch.Checked then begin
      FSongbase.Find1Click(Self);
      bUnhandled := false;
    end else
    if (B=VK_CAPITAL) or (B=VK_F3) then begin
      BlindMode:=SEARCHING_TEXT;
      SearchString:='';
      SearchID:='';
      ShowHighlight( false );
      Cop1.Caption:=SearchString;
      Cop1.Enabled := true;
      Cop1.Visible := FSongbase.bProjectHints;
      Cop2.Enabled := true;
      Cop2.Visible := FSongbase.bProjectHints;
      Cop2.Caption:='Search Text';
      RightAlignCaptions;
      if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
      bUnhandled := false;
    end else
    if (B=223) or (B=VK_F2) then begin
      if (B=VK_F2) and FSettings.cbF2F3WinSearch.Checked then begin
        FSongbase.TitleSearchClick(Self);
      end else begin
        BlindMode:=FINDING_TITLE;
        SearchString:='';
        SearchID:='';
        SearchNo:=1;
        HideLabels();
        ShowHighlight( false );
        Cop1.Visible:= FSongbase.bProjectHints;
        Cop1.Enabled:=true;
        Cop1.Caption:=SearchString;
        Cop2.Visible:= FSongbase.bProjectHints;
        Cop2.Enabled:=true;
        Cop2.Caption:='Find Title';
        RightAlignCaptions;
        if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
      end;
      bUnhandled := false;
    end else
    if (B=VK_BACK) then begin
      if not Blanked then BlankWindow(bUnhandled,false)
      else if LastID <> '-1' then begin
        SelectPage( LastID, LastPage, false);
        LastID   := CurrentSong;
        LastPage := CurrentPage;
      end;
    end
    else if (B=VK_B) and FSettings.cbPowerPoint.Checked then begin
      BlankWindow(bUnhandled,false);
    end
    else
    if B=VK_ESCAPE then begin
      Cop2.Caption:='Exit (Y/N)';
      RightAlignCaptions;
      HideLabels();
      LLicense.Visible := false;
      ShowHighlight( false );
      Cop2.Visible := FSongbase.bProjectHints;
      Cop2.Enabled:=true;
      Cop1.Visible := false;
      Cop1.Enabled := false;
      BlindMode:=QUITTING;
      bUnhandled := false;
      if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
    end else
    if (B=VK_BACK) and (LastID<>'-1') then begin
      SelectPage( LastID, LastPage, false);
      LastID   := CurrentSong;
      LastPage := CurrentPage;
      bUnhandled := false;
    end else

    if not FLiveWindow.Visible and (B=VK_LEFT) then begin
      ShowSelectLabels(-1);
    end else

    if not FLiveWindow.Visible and (B=VK_RIGHT) then begin
      ShowSelectLabels(+1);
    end else

    if not FLiveWindow.Visible and (B=VK_RETURN) then begin
      SelectSong( GID, false,false);
    end else

    // If we're supporting powerpoint keys - Page Up will select the previous song
    if FSettings.cbPowerPoint.Checked and (B=VK_PRIOR) then begin
      S:=SBMain.OrderData; CheckID:=''; CheckK := '';
      count:=-1;
      repeat
        inc(count);
        CheckID:=CheckK;
        CheckK :=copy(S,1,pos(chr128,S)-1);
        S:=copy(S,pos(chr128,S)+1,length(S));
        S:=copy(S,pos(chr128,S)+1,length(S));
      until (CheckK=LastID) or (S='');
      if (CheckK=LastID) and (CheckID<>'') then begin
        bUnhandled := false;
        SelectSong( CheckID, true,false);
        FSongbase.StringGrid1.Row:=Count;
      end;
    end else

    // If we're supporting powerpoint keys - Page Down will select the next song
    if FSettings.cbPowerPoint.Checked and (B=VK_NEXT) then begin
      S:=SBMain.OrderData; CheckID:='-1'; CheckK := '';
      count:=-1;
      repeat
        inc(count);
        CheckK:=CheckID;
        CheckID:=copy(S,1,pos(chr128,S)-1);
        S:=copy(S,pos(chr128,S)+1,length(S));
        S:=copy(S,pos(chr128,S)+1,length(S));
      until (CheckK=LastID) or (S='');
      if (CheckK=LastID) and (CheckID<>'') then begin
        bUnhandled := false;
        SelectSong( CheckID, true ,false);
        FSongbase.StringGrid1.Row:=Count;
      end;
    end else

    // Otherwise, find the song with given shortcut
    begin
      if [ssShift]<=Shift then A:=A+1;
      if [ssCtrl]<=Shift then A:=A+2;
      if [ssCtrl]<=Shift then A:=A+4;
      S:=SBMain.OrderData; CheckID:='';
      count:=-1;
      repeat
        inc(count);
        CheckID:=copy(S,1,pos(chr128,S)-1);
        S:=copy(S,pos(chr128,S)+1,length(S));
        CheckK:=copy(S,1,pos(chr128,S)-1);
        val(CheckK,CheckA,Code);
        val(Copy(CheckK,pos('~',CheckK)+1,length(CheckK)),CheckB,Code);
        S:=copy(S,pos(chr128,S)+1,length(S));
      until ((CheckA=A) and (CheckB=B)) or (S='');
      if (CheckA=A) and (CheckB=B) then begin
        bUnhandled := false;
        SelectSong( CheckID, false,false);
        FSongbase.StringGrid1.Row:=count;
      end;
    end;
  end else
  if bUnhandled and (BlindMode=SEARCHING_TEXT) then begin
    if (B=VK_ESCAPE) or (B=VK_CAPITAL) or (B=VK_F3) then begin
      BlindMode  := SELECTING_SONG;
      bUnhandled := false;
{      ShowHighlight( false );
      Cop1.Visible:=false;  Cop1.Enabled:=false;
      Cop2.Visible:=FSongbase.bProjectHints; Cop2.Enabled:=true;
      Cop2.Caption:='Select';
      SearchString:='';
      SearchID:='';
      ShowSelectLabels;
      RightAlignCaptions;
      if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;}
    end else
    if (B=VK_RETURN) then begin
      bUnhandled := false;
      ShowHighlight( false );
      Cop1.Visible:=FSongbase.bProjectHints; Cop1.Enabled:=true;
      Cop2.Visible:=FSongbase.bProjectHints; Cop2.Enabled:=true;
      Cop1.Caption:='...';
      Cop1.Update;
      Cop2.Caption:='Searching';
      RightAlignCaptions;
      FindRTFText(SearchString);
      if (SearchResults.Count>0) then begin
        ResultVal:=0;
        Cop1.Caption:=SearchResults.Strings[ResultVal];
        BlindMode:=CHOOSING_RESULT;
        Cop2.Caption:='Search Results ('+ IntToStr(SearchResults.Count) +')';
        RightAlignCaptions;
        SearchString:='';
      end else begin
        BlindMode:=SELECTING_SONG;
        SPostfix := ' (No Results)';
{        Cop2.Caption:='Select (No Results)';
        Cop1.Caption:='';
        SearchString:='';
        ShowSelectLabels;
        RightAlignCaptions;}
      end;
      if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
    end else begin
      ShowHighlight( false );
      Cop1.Visible:=FSongbase.bProjectHints; Cop1.Enabled:=true;
      if (pos(chr(Key),' ,.-ABCDEFGHIJKLMNOPQRSTUVWXYZ')>0) then begin
        SearchString:=SearchString+chr(Key);
        bUnhandled := false;
      end;
      if (Key=VK_DELETE) or (Key=VK_BACK) then begin
        SearchString:=copy(SearchString,1,length(SearchString)-1);
        bUnhandled := false;
      end;
      Cop1.Caption:=SearchString;
      RightAlignCaptions;
      if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
    end;
  end else
  if bUnhandled and (BlindMode=CHOOSING_RESULT) then begin
    ShowHighlight( false );
    Cop1.Visible:=false; Cop1.Enabled:=false;
    Cop2.Visible:=FSongbase.bProjectHints; Cop2.Enabled:=true;
    if (B=VK_BACK) then begin
      if not Blanked then BlankWindow(bUnhandled,false)
      else if LastID <> '-1' then begin
        SelectPage( LastID, LastPage, false);
        LastID   := CurrentSong;
        LastPage := CurrentPage;
      end;
    end;
    if (B=VK_ESCAPE) or (B=VK_CAPITAL) or (B=VK_F3) then begin
      BlindMode:=SELECTING_SONG;
      bUnhandled := false;
{      Cop2.Caption:='Select';
//      Cop1.Caption:='';
      RightAlignCaptions;
      ShowSelectLabels;
      SearchString:='';
      SearchID:='';}
//      if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
    end else
    if (B=VK_LEFT) and (ResultVal>0) then begin
      dec(ResultVal);
      Cop1.Caption:=SearchResults.Strings[ResultVal];
      Cop2.Caption:='Search Result ('+ IntToStr(1+ResultVal) + '/' + IntToStr(SearchResults.Count) +')';
      Cop1.Visible:=FSongbase.bProjectHints; Cop1.Enabled:=true;
      Cop2.Visible:=FSongbase.bProjectHints; Cop2.Enabled:=true;
      RightAlignCaptions;
      if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
      SearchString:='';
      bUnhandled := false;
    end else
    if (B=VK_RIGHT) and (ResultVal<SearchResults.Count-1) then begin
      inc(ResultVal);
      Cop1.Caption:=SearchResults.Strings[ResultVal];
      Cop2.Caption:='Search Result ('+ IntToStr(1+ResultVal) + '/' + IntToStr(SearchResults.Count) +')';
      Cop1.Visible:=FSongbase.bProjectHints; Cop1.Enabled:=true;
      Cop2.Visible:=FSongbase.bProjectHints; Cop2.Enabled:=true;
      RightAlignCaptions;
      if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
      SearchString:='';
      bUnhandled := false;
    end else
    if (B=VK_RETURN) then begin
      bUnhandled := false;
      GID := PageCache_GetByTitle( Cop1.Caption );
      ShowTheSong(GID);
      if FPreviewWindow.Visible then FSongbase.PreviewID(GID);
    end else begin
      ShowHighlight( false );
      Cop1.Visible:= FSongbase.bProjectHints; Cop1.Enabled:=true;
      if (pos(chr(Key),'ABCDEFGHIJKLMNOPQRSTUVWXYZ')>0) then begin
        bUnhandled := false;
        SearchString:=SearchString+chr(Key);
        i:=0;
        while (i<SearchResults.Count-1) and (before(SearchResults.Strings[i],SearchString)) do inc(i);
        if i>SearchREsults.Count-1 then i:=SearchResults.Count-1;
        Cop1.Caption:=SearchResults.Strings[i];
        RightAlignCaptions;
        if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
      end;
    end;
  end else
  if bUnhandled and (BlindMode=FINDING_TITLE) then begin
    if (B=VK_ESCAPE) or (B=223) or (B=VK_F2) then begin
      BlindMode:=SELECTING_SONG;
      bUnhandled := false;
{      Cop2.Caption:='Select';
      Cop1.Visible := false; Cop1.Enabled := false;
      ShowHighlight( false );
      SearchString:='';
      SearchID:='';
      RightAlignCaptions;
      ShowSelectLabels;
      if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;}
    end else
    if (B=VK_LEFT) and (SearchNo>1) then begin
//      SearchString:='';
      dec(SearchNo);
      SR.Title:=TitleList.Strings[SearchNo-1];
      SR.Title:=copy(SR.Title,pos('~',SR.Title)+1,length(SR.Title));
      SearchID:=copy(SR.Title,pos('~',SR.Title)+1,length(SR.Title));
      SR.Title:=copy(SR.Title,1,pos('~',SR.Title)-1);
      Cop1.Caption:=SR.Title;
      Cop1.Enabled := true; Cop1.Visible := FSongbase.bProjectHints;
      RightAlignCaptions;
      if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
      ShowHighlight( false );
      bUnhandled := false;
    end else
    if (B=VK_RIGHT) and (SearchNo<TitleList.Count) then begin
      inc(SearchNo);
      SR.Title:=TitleList.Strings[SearchNo-1];
      SR.Title:=copy(SR.Title,pos('~',SR.Title)+1,length(SR.Title));
      SearchID:=copy(SR.Title,pos('~',SR.Title)+1,length(SR.Title));
      SR.Title:=copy(SR.Title,1,pos('~',SR.Title)-1);
      Cop1.Caption := SR.Title;
      Cop1.Enabled := true; Cop1.Visible := FSongbase.bProjectHints;
      RightAlignCaptions;
      if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
      ShowHighlight( false );
      bUnhandled := false;
  //    SearchString:='';
    end else
    if (B=VK_RETURN) then begin
      bUnhandled := false;
      if SearchID<>'' then begin
        GID:=SearchID;
        LoadOHPData(SearchID);
        LoadCopyright(SearchID);
        CurrentPage:=0;
        UpdateLabels(CurrentPage);
        BlindMode:=SHOWING_SONG;
        ShowHighlight( false );
        Cop1.Visible := FSongbase.bProjectHints; Cop2.Visible := FSongbase.bProjectHints;
        Cop1.Enabled := true;
        Cop2.Enabled := true;
        ShowLabels(LLicense.Left,LLicense.Top - LLicense.Height - TEXT_OFFSET );
        MarkOHP(GId);
        if FPreviewWindow.Visible then FSongbase.PreviewID(GID);
        If (( (Pages=1) and (FSettings.AutoViewSingle1.Checked) )
           or (FSettings.AutoView1.Checked) ) then begin
          SelectPage( GID, 1, false);
        end;
      end else begin
        BlindMode:=SELECTING_SONG;
{        HideLabels;
        Cop1.Visible:=false; Cop1.Enabled:=false;
        Cop2.Caption:='Select';
        SearchString:='';
        SEarchID:='';
        RightAlignCaptions;
        ShowSelectLabels;}
      end;
      if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
    end else begin
      if (pos(chr(Key),'ABCDEFGHIJKLMNOPQRSTUVWXYZ')>0) or (Key = VK_BACK) then begin
        bUnhandled := false;
        if Key = VK_BACK then SearchString := Copy( SearchString, 0, Length(SearchString)-1 )
                         else SearchString:=SearchString+chr(Key);
        S:='';
        if before(searchString,TitleList.Strings[SearchNo-1]) then
          while (SearchNo>1) and
              (not before(TitleList.Strings[SearchNo-1],searchString)) do
                dec(SearchNo);
        while (SearchNo<TitleList.Count) and
            (before(TitleList.Strings[SearchNo-1],searchString)) do
              inc(SearchNo);
        S := TitleList.Strings[SearchNo-1];
        S := copy(S,pos('~',S)+1,length(S));
        SearchID:=copy(S,pos('~',S)+1,length(S));
        S:=copy(S,1,pos('~',S)-1);

        Cop1.Enabled := false; Cop1.Visible := false;

        // IMPROVE: Just repaint the area occupied by the highlight
        GHighlight := S;
        ShowHighlight( true );
        if FLiveWindow.Visible then begin
          FSongbase.RenderSearchText( FLiveWindow.ImgHighlight.Canvas,
                                      FLiveWindow.PHighlight.Width - 3, 1,
                                      Cop1.Font, clBlack, $007F7F );
        end;

      {    FSongbase.RenderSearchText( Canvas,
              LCopyright1.ClientOrigin.X - Self.ClientOrigin.X + LCopyright1.Width,
              LCopyright1.ClientOrigin.Y - Self.ClientOrigin.Y );}
        Invalidate;        // IMPROVE: Do not redraw the entire window
      end;
    end;
  end else
  if bUnhandled and (BlindMode=SHOWING_SONG) then begin
    ShowHighlight(false);
    Cop1.Visible:=true; Cop2.Visible:=true;
    Cop1.Enabled:=true; Cop2.Enabled:=true;
    if (B=VK_F4) then begin // Add to order
      bUnhandled := false;
      if FSongbase.EOrder.Text = '' then FSongbase.BNewOrder.Click;
      S:=SBMain.OrderData;
      done:=false;
      while ((S<>'') and (not done)) do begin
        if copy(S,1,pos(chr128,S)-1)=gID then done:=true;
        S:=copy(S,pos(chr128,S)+1,length(S));
        S:=copy(S,pos(chr128,S)+1,length(S));
      end;
      if not done then begin
        S := FSongbase.AddItemToOrder( GID, true );
        if FSongbase.bProjectHints then begin
          S:=LLicense.Caption;
          i:=LLicense.Left;
          bA:=LLicense.Visible; bB:=LLicense.Enabled;
          LLicense.Caption:='Shortcut='+FSongbase.CBSC.Text;
          LLicense.Left:= CurrentDisplayArea.Left + FSongbase.rCCLIArea.Left + TEXT_OFFSET;
          LLicense.Visible := true; LLicense.Enabled := true;
          LLicense.update;
          sleep(1500);
          LLicense.Caption:=S;
          LLicense.Left:=i;
          LLicense.Visible := bA; LLicense.Enabled := bB;
          LLicense.update;
        end;
      end;
    end;
    if ( ((B=VK_NEXT)  and FSettings.cbPowerPoint.Checked) or
         ((B=VK_RIGHT) and not FSongbase.bMultiMonitor) )
       and (Blanked or (CurrentPage<Pages)) then begin
      bUnhandled := false;
      i := CurrentPage;
      inc(i);
      if i>Pages then i:=Pages;
      SelectPage( GID, i, false);
    end else
    if (B=VK_BACK) then begin
      if not Blanked then BlankWindow(bUnhandled,false)
      else if LastID <> '-1' then begin
        SelectPage( LastID, LastPage, false);
        LastID   := CurrentSong;
        LastPage := CurrentPage;
      end;
    end
    else if ( ((B=VK_PRIOR) and FSettings.cbPowerPoint.Checked) or
              ((B=VK_LEFT)  and (not FSongbase.bMultiMonitor)) )
         and (Blanked or (CurrentPage>1) or (CurrentPage=0)) then begin
      bUnhandled := false;
      i := CurrentPage;
      if i=0 then i:=2;
      dec(i);
      if i=0 then i:=1;
      if i<=Pages then begin
        SelectPage( GID, i, false);
      end;
    end else

    if not FLiveWindow.Visible and ((B=VK_RETURN) and (CurrentPage < 1) or Blanked) then begin
      SelectPage( GID, 1, false);
    end else

    // If we reach the end or start of a song, select the previous/next song
    if FSettings.cbPowerPoint.Checked and ((B=VK_NEXT) or (B=VK_PRIOR)) then begin
      BlindMode := SELECTING_SONG;
      EBlind2KeyDown( Sender, B, Shift );
      OldMode   := BlindMode;
    end else
    if (B=VK_HOME) and (Blanked or (CurrentPage<>1)) then begin
      bUnhandled := false;
      if Pages > 0 then begin
        SelectPage( GID, 1, false);
      end;
    end else
    if (B=VK_END) and (Blanked or (CurrentPage<>Pages)) then begin
      bUnhandled := false;
      if Pages<>0 then begin
        SelectPage( GID, Pages, false);
      end;
    end else
    if (B=VK_ESCAPE) then begin
      bUnhandled := false;
      BlindMode:=SELECTING_SONG;

{      ShowHighlight( false );
      Cop1.Visible := false;
      Cop1.Enabled := false;
      Cop2.Visible := FSongbase.bProjectHints;
      Cop2.Caption:='Select';
      ShowSelectLabels;
      if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;}

    end else
    if (B=VK_B) and FSettings.cbPowerPoint.Checked then begin
      BlindMode:=SELECTING_SONG;
      {
      ShowHighlight( false );
      Cop1.Visible := false;
      Cop1.Enabled := false;
      Cop2.Visible := FSongbase.bProjectHints;
      Cop2.Caption:='Select';
      ShowSelectLabels;
      RightAlignCaptions;
      if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
      HideLabels;
      }
    end else begin
      if [ssShift]<=Shift then A:=A+1;
      if [ssCtrl]<=Shift then A:=A+2;
      if [ssCtrl]<=Shift then A:=A+4;
      i:=0;
      repeat
        inc(i);
      until ((SCS[(i*2)-1]=A) and (SCS[(i*2)]=B)) or (i>Pages);
      if (i<=Pages) then begin
        bUnhandled := false;
        SelectPage( GID, i, false);
      end;
    end;
    EBlind2.TexT:='';
    EBlind2.SetFocus;
    EBlind2.SendToBack;
  end;

  // Update the captions if we've changed mode
  if OldMode <> BlindMode then begin
    case BlindMode of
      NOT_DISPLAYING: begin
        ShowHighlight( false );
        HideLabels;
//        HideHighlight;
        Cop1.Enabled := false; Cop1.Visible := false;
        Cop2.Enabled := false; Cop1.Visible := false;
      end;

      SELECTING_SONG: begin
        ShowHighlight( false );
        BlindMode:=SELECTING_SONG;
        ShowSelectLabels;

        Cop2.Caption := 'Select' + SPostfix;
        Cop2.Enabled := true;     Cop2.Visible := FSongbase.bProjectHints;
        Cop1.Enabled := false;    Cop1.Visible := false;
        RightAlignCaptions;
      end;
    end;
    if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
  end;

  if bUnhandled and FSongbase.bMultiMonitor and (Sender <> FPreviewWindow) then begin
    // Unprocessed key, send it back to the main app (unless that's where it came from)
    FPreviewWindow.FormKeyDown(Self,Key,Shift);
  end else
    Key := 0;    // Prevent the key being passed on tacitly.
end;


procedure TFEditProj.ShowSelectLabels( iOffset : integer = 0 );
var CheckB, CheckA, Code, iSelect, iC : Integer;
    S, sID, CheckK, CheckID, SNext, sS, SPrev : string;
    bSet : boolean;
begin
  if FSongbase.bProjectHints then begin
    Pages   := 0;
    iSelect := -1;
    SPrev   := '';
    SNext   := '';
    sID     := GID;
    bSet    := false;
    CurrentPage := 0;      // hack!
    S:=SBMain.OrderData;
    if S <> '' then begin
      repeat
        CheckID:=copy(S,1,pos(chr128,S)-1);
        S:=copy(S,pos(chr128,S)+1,length(S));
        CheckK:=copy(S,1,pos(chr128,S)-1);
        val(CheckK,CheckA,Code);
        val(Copy(CheckK,pos('~',CheckK)+1,length(CheckK)),CheckB,Code);
        S:=copy(S,pos(chr128,S)+1,length(S));

        inc(Pages);
        SCS[(2*Pages)-1] := CheckA;
        SCS[(2*Pages)  ] := CheckB;

        if bSet and (SNext = '') then SNext := CheckID;
        if sID = CheckID then begin
          iSelect := Pages;
          bSet    := true;
        end;
        if not bSet then SPrev := CheckID;
      until S='';
    end;

    if (iOffset > 0) and (iSelect < Pages) and (sNext <> '') then begin
      sID := SNext;
      iSelect := iSelect + iOffset;
    end;
    if (iOffset < 0) and (iSelect > 1) and (sPrev <> '') then begin
      sID := SPrev;
      iSelect := iSelect + iOffset;
    end;

    GID := sID;
    RightAlignCaptions;
    ShowLabels(Cop2.Left + Cop2.Width,Cop1.Top,true);
    UpdateLabels(iSelect);

    iC := PageCache_GetPageCount(sID);
    if iC > 1 then sS := 's' else sS := '';
    LLicense.Caption := PageCache_GetSongName(sID) + ' (' + IntToStr(iC) +' page'+sS+')';
    LLicense.Visible := true;
    LLicense.Enabled := true;
  end else begin
    HideLabels;
  end;
end;


procedure TFEditProj.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if bHasTools then FTools.hide;
  LastPic:='';
  FPreviewWindow.RefreshAll;
  if (Self = FProjWin) and FLiveWindow.Visible then begin
    FLiveWindow.Closer := Self;
    FLiveWindow.Close;
    FSongbase.BProjNow.Caption := FSongbase.SProjNowText;
    FSongbase.BProjNow.Hint    := FSongbase.SProjNowHint;
  end else if Self = FEditWin then begin
    CurrentPage := -1;
    CurrentSong := '';
  end;
end;

procedure TFEditProj.EBlindKeyPress(Sender: TObject; var Key: Char);
begin
 Key:=#0;
end;

procedure TFEditProj.EBlind2KeyPress(Sender: TObject; var Key: Char);
begin
  LogThis( 'Ignoring keypress ' + Key );
  Key:=#0;
end;

procedure TFEditProj.FormDestroy(Sender: TObject);
var i : integer;
begin
  SearchResults.free;
  for i:=1 to 99 do Pagelabs[i].free;
  Titlelist.free;
  if ImgScaler    <> nil then ImgScaler.Free;
  if ImgOffscreen <> nil then ImgOffscreen.Free;
  FRTF := nil;
end;

procedure TFEditProj.PrepareWindow;
begin
  LastID:='-1';

  // Get the list of titles and alt titles
  PageCache_CreateSearchList( Titlelist );

  if not bReady then
    bReady := true;
end;

procedure TFEditProj.FormShow(Sender: TObject);
begin
  ActualFormShow(Sender,false);
end;
procedure TFEditProj.ActualFormShow(Sender: TObject; from_webserver : boolean);
var  I : integer;
     bBlank : boolean;
begin
  ASSERT( bReady );
  hLastKeyTime  := 0;
  hLastKeyValue := 0;
  bDrawable := false;
  Cop1.BringToFront;
  Cop2.BringToFront;
  LLicense.BringToFront;
  FSongbase.bProjectHints := not FSongbase.bMultiMonitor or FSettings.cbPowerPoint.Checked;
  bScaleProjection := (Self = FProjWin) and (0 <> FSettings.szProjectScale.cx);
  if bScaleProjection and
     (FSettings.szProjectScale.cx = Width) and
     (FSettings.szProjectScale.cy = Height) then
     bScaleProjection := false;

  if bScaleProjection then begin
    FSongbase.SetImageSize( Self, ImgOffscreen, FSettings.szProjectScale.cx, FSettings.szProjectScale.cy );
    if bHighQuality then begin
      FSongbase.SetImageSize( Self, ImgScaler, ImgOffscreen.Width, ImgOffscreen.Height );
    end;
    FRTF.SetZoom( Height / FSettings.szProjectScale.cy );
  end else begin
    FSongbase.SetImageSize( Self, ImgOffscreen, Width, Height );
    FRTF.SetZoom(1.0);
  end;
  FRTF.SetShadow( FSettings.cbShadow.Checked, FSettings.PShadowCol.Color, FSettings.iShadowOffset );

{  ImgOnscreen.SetBounds( 0,0, Width, Height );
  ImgOnScreen.Visible := true;}
  HideLabels;
  if EditGID<>'' then begin
    WindowBackground := $202020;
    Cursor := crIBeam;
    RESong.Cursor := crIBeam;
    BlindMode:=NOT_DISPLAYING;
    FTools.Left:=(Width-FTools.Width) div 2;
    FTools.Top:=(Height-FTools.Height)-5;
    FTools.CBSC.Items.Clear; FTools.CBSC.Items.Add('None');
    for i:=0 to 9 do FTools.CBSC.Items.Add(chr(48+i));
    for i:=1 to 26 do FTools.CBSC.Items.Add(chr(64+i));
    for i:=0 to 9 do FTools.CBSC.Items.Add('Shift+'+chr(48+i));
    for i:=1 to 26 do FTools.CBSC.Items.Add('Shift+'+chr(64+i));
    for i:=0 to 9 do FTools.CBSC.Items.Add('Ctrl+'+chr(48+i));
    for i:=1 to 26 do FTools.CBSC.Items.Add('Ctrl+'+chr(64+i));
    for i:=0 to 9 do FTools.CBSC.Items.Add('Alt+'+chr(48+i));
    for i:=1 to 26 do FTools.CBSC.Items.Add('Alt+'+chr(64+i));
    for i:=0 to 9 do FTools.CBSC.Items.Add('Shift+Ctrl+'+chr(48+i));
    for i:=1 to 26 do FTools.CBSC.Items.Add('Shift+Ctrl+'+chr(64+i));
    for i:=0 to 9 do FTools.CBSC.Items.Add('Shift+Alt+'+chr(48+i));
    for i:=1 to 26 do FTools.CBSC.Items.Add('Shift+Alt+'+chr(64+i));
    for i:=0 to 9 do FTools.CBSC.Items.Add('Ctrl+Alt+'+chr(48+i));
    for i:=1 to 26 do FTools.CBSC.Items.Add('Ctrl+Alt+'+chr(64+i));
    for i:=0 to 9 do FTools.CBSC.Items.Add('Shift+Ctrl+Alt+'+chr(48+i));
    for i:=1 to 26 do FTools.CBSC.Items.Add('Shift+Ctrl+Alt+'+chr(64+i));
    GID := EditGID;
    bHasTools := true;
    RESong.Visible := true;
    FTools.show;
    setEditWidth();
    InitFiles(Sender,false);
    RESongSelectionChange(Sender);
    bringtofront;

    FTools.Changed := false;
    FTools.OldPages := Pages;
    FTools.BringToFront;
    FTools.UpdateButtons;
    FTools.BSave.Enabled := false;
    FTools.BReload.Enabled := false;
    RESong.SelStart := length( RESong.Lines.Text );
  end else begin    { Live }
//    Cursor := crNone;
//    RESong.Cursor := crNone;
    WindowBackground := clBlack;
    SetEditWidth();
    // FTools.hide;
    if( GID <> '' ) then begin
      BlindMode:=SHOWING_SONG;
      InitFiles(Sender, false);
      UpdateLabels(CurrentPage);
      ShowLabels(LLicense.Left,LLicense.Top - LLicense.Height - TEXT_OFFSET );
      MarkOHP(GId);
      LastID := GID;
      ShowHighlight( false );
      Cop1.Visible := true; Cop1.Enabled := true;
      Cop2.Visible := true; Cop2.Enabled := true;
    end else begin
      // Blank, select mode
      BlankWindow(bBlank,from_webserver);
      CurrentPage := 0;
      Pages       := 0;
      SetGlobals;
      ShowHighlight( false );
      BlindMode:=SELECTING_SONG;
      Cop2.Visible := FSongbase.bProjectHints; Cop2.Enabled := true;
      Cop2.Caption :='Select';
      Cop1.Visible := false; Cop1.Enabled := false;
      RightAlignCaptions;
      ShowSelectLabels;
      if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
    end;
    EBlind2.Text:='';
    EBlind2.setFocus;
    EBlind2.SendToBack;
    EBlind2.Update;
    BringToFront;
    RESong.sendtoback;
{    ImgOnScreen.BringToFront;}

    if (Self = FProjWin) and FSongbase.bMultiMonitor and not FLiveWindow.Visible then begin
      FLiveWindow.bNoResizeMsg := true;
      FLiveWindow.Show;
      FLiveWindow.bNoResizeMsg := false;
      FSongbase.BProjNow.Caption := 'B&lank Screen';
      FSongbase.BProjNow.Hint    := 'Blank the Projection screen';
    end;
  end;
  bDrawable := true;
//  Invalidate();
end;

procedure TFEditProj.RESongEdited(Sender: TObject);
begin
  if FTools.Visible then begin
    FTools.BSave.Enabled := true;
    FTools.BReload.Enabled := true;
  end;
end;

procedure TFEditProj.BlankWindow( var bUnhandled : boolean; from_webserver : boolean );
begin
  bDrawable := false;
  //RESong.Lines.Clear;
  SelectPage( GID, 0, from_webserver);

  Blanked:=true;
  Cop1.Visible := false; Cop1.Enabled := false;
  Cop2.Visible := false; Cop2.Enabled := false;
  bUnhandled := false;
  bDrawable := true;
  UpdateDisplay;
end;

procedure TFEditProj.UpdateDisplay;
begin
  LogThis( 'Projection Window updating display' );

  // Don't do anything if we're Editing
  if RESong.Visible then Exit;
  if nil = ImgOffscreen then Exit;

  // Prevent crashes!
{  bDrawHQ := bHighQuality;
  if nil = ImgScaler then bDrawHQ := false;

  // Decide where we're drawing to
  bDrawBG := FSettings.ImageTick.Checked and not bHasTools;

  if bDrawBG or bScaleProjection
             then DestCanvas := ImgOffscreen.Canvas
             else DestCanvas := ImgOnscreen.Canvas;

  // Firstly clear the image to the current background colour
  DestCanvas.Brush.Color := RESong.Color;
  DestCanvas.FillRect( Imgoffscreen.ClientRect );

  // Then render the RichEdit control (to offscreen img, if there's a BG)
  with fmt do
  begin
    hdc:= DestCanvas.Handle;
    hdcTarget:= hdc;

    // rect needs to be specified in twips (1/1440 inch) as unit
    rc:=  Rect(RESong.BoundsRect.Left   * 1440 div PixelsPerInch,
               RESong.BoundsRect.Top    * 1440 div PixelsPerInch,
               RESong.BoundsRect.Right  * 1440 div PixelsPerInch,
               RESong.BoundsRect.Bottom * 1440 div PixelsPerInch);
    rcPage:= rc;

    chrg.cpMin := 0;
    chrg.cpMax := RESong.GetTextLen;
  end;

  RESong.Perform(EM_FORMATRANGE, 1, Integer(@fmt));
  RESong.Perform(EM_FORMATRANGE, 0, 0);

//  DrawIt(Imgoffscreen, ImgBackground, Imgonscreen);

  // Now, if there's no background, we've already drawn straight onto the
  // 'onscreen image'.

  // Otherwise, we have to render the background and RichText to 'onscreen'
  if bDrawBG or bScaleProjection then begin
    // Firstly clear the image to the current background colour
    ImgOnScreen.Canvas.Brush.Color := RESong.Color;
    ImgOnScreen.Canvas.FillRect( ImgOnScreen.ClientRect );

    DrawImage := ImgOnScreen;
    DrawArea  := CurrentDisplayArea;
    if bDrawBG then begin
      if bDrawHQ and bScaleProjection then begin
        DrawImage := ImgScaler;
        DrawArea  := DrawImage.ClientRect;
      end;
      DrawImage.Canvas.CopyMode := cmSrcCopy;
      DrawImage.Canvas.StretchDraw( DrawArea, ImgBackground.Picture.Graphic );
    end;

    DrawImage.Canvas.CopyMode := cmSrcPaint;
    DrawImage.Canvas.StretchDraw(DrawImage.ClientRect, ImgOffscreen.Picture.Graphic );

    if DrawImage <> ImgOnScreen then begin
      SetStretchBltMode(ImgOnscreen.Canvas.Handle, STRETCH_HALFTONE	);
      SetBrushOrgEx(ImgOnscreen.Canvas.Handle, 0, 0, nil);
      StretchBlt( ImgOnscreen.Canvas.Handle,
                  ImgOnScreen.Left, ImgOnScreen.Top, ImgOnScreen.Width, ImgOnScreen.Height,
                  ImgScaler.Canvas.Handle,
                  0,0, ImgScaler.Width, ImgScaler.Height, cmSrcCopy );
    end;
  end;}

  if FLiveWindow.Visible then FLiveWindow.UpdateContent;

  LogThis( 'Display Updated' );
end;

procedure TFEditProj.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
begin
  // Edit Mode, as normal. Projection mode, disable background redraws
  if RESong.Visible then inherited
                    else Msg.Result := 1;
end;

procedure TFEditProj.RightAlignCaptions;
begin
  Cop1.Left := CurrentDisplayArea.Left + FSongbase.rCopyArea.Right - Cop1.Width - TEXT_OFFSET;
  Cop2.Left := CurrentDisplayArea.Left + FSongbase.rCopyArea.Right - Cop2.Width - TEXT_OFFSET;
end;

procedure TFEditProj.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  LogThis( 'Shortcut!' );

  // Edit proj shortcuts?
  if FTools.Visible then FTools.FormShortCut( Msg, Handled );
end;

procedure TFEditProj.SelectSong( SongID : string; bNoInitial : boolean; from_webserver : boolean);
begin
  GID:=SongID;

  LoadOHPData(GID);
  LoadCopyright(GID);

  UpdateLabels(0);
  LastID := GID;        // HMMM.... Just added this so that selecting a song sets LastId
  BlindMode:=SHOWING_SONG;
  ShowHighlight( false );
  Cop1.Visible:= FSongbase.bProjectHints; Cop1.Enabled:=true;
  Cop2.Visible:= FSongbase.bProjectHints; Cop2.Enabled:=true;
  ShowLabels(LLicense.Left,LLicense.Top - LLicense.Height - TEXT_OFFSET );
  MarkOHP(GId);
  If (not bNoInitial) and
      (( (Pages=1) and (FSettings.AutoViewSingle1.Checked) )
      or (FSettings.AutoView1.Checked) ) then begin
    SelectPage( GID, 1, from_webserver);
  end else begin
    LLicense.Caption := GTitle;
    LLicense.Visible := FSongbase.bProjectHints;
    LLicense.Enabled := true;

    if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
  end;
end;



procedure TFEditProj.FormPaint(Sender: TObject);
begin
  if not RectsEqual(ClientRect, CurrentDisplayArea) then begin
    Canvas.Brush.Color := WindowBackground;
    Canvas.FillRect( ClientRect );
  end;

  if FTools.Visible then begin
    Canvas.Brush.Color := $404040;
    Canvas.FillRect( CurrentDisplayArea );
  end else begin
    if Blanked and (BlankImgFile <> '') then begin
      Canvas.StretchDraw( CurrentDisplayArea, ImgBlank.Picture.Graphic );
    end
    else if bHasImgBackground then begin
      Canvas.StretchDraw( CurrentDisplayArea, ImgBackground.Picture.Graphic );
    end else begin
      if FSettings.BackTick.checked then Canvas.Brush.Color := FSettings.PColB.Color
                                    else Canvas.Brush.Color := clBlack;
      Canvas.FillRect( CurrentDisplayArea );
    end;

    FRTF.OnPaint( Canvas );

    if bShowHighlight and FSongbase.bProjectHints then begin
      FSongbase.RenderSearchText( Canvas, Cop1.Left + Cop1.Width, Cop1.Top, Cop1.Font );
    end;
  end;
end;

procedure TFEditProj.SelectPage( iSong : string; iPage : integer; from_webserver : boolean);
var want_html, want_screen : boolean;
    i : integer;
begin
  LastID   := CurrentSong;
  LastPage := CurrentPage;
  if (iPage <> CurrentPage) or (iSong <> CurrentSong) or bForceRedraw then begin
    LoadOHPData(iSong);
    CurrentPage := iPage;
    CurrentSong := iSong;
    GID         := CurrentSong;
    if iPage <> 0 then begin
      FRTF.Text := PageCache_GetPageText( iSong, iPage );
      FRTF.ResetForces();
      if FSettings.PrimaryFont.ForceName   then FRTF.SetFont(     FSettings.PrimaryFont.Name   );
      if FSettings.PrimaryFont.ForceSize   then FRTF.SetFontSize( FSettings.PrimaryFont.Size   );
      if FSettings.PrimaryFont.ForceColor  then FRTF.SetColor(    FSettings.PrimaryFont.Color  );
      if FSettings.PrimaryFont.ForceItalic then FRTF.SetItalic(   FSettings.PrimaryFont.Italic );
      if FSettings.PrimaryFont.ForceBold   then FRTF.SetBold(     FSettings.PrimaryFont.Bold   );
    end else begin
      FRTF.Text := '';
    end;
    if FTools.Visible then PageCache_SetRichText( RESong, FRTF.Text );
    FRTF.SetShadow( FSettings.cbShadow.Checked, FSettings.PShadowCol.Color, FSettings.iShadowOffset );

    want_html:=FWebServer.isServerEnabled();
    for i:=0 to FNetSetup.Checklist.Count-1 do begin
      if (FNetSetup.CheckList.Strings[i]='Y') then begin
        want_html:=true;
        want_screen:=true;
      end;
    end;

    if (want_html) then begin
      FWebServer.PageRTF:=FRTF.text;
      FWebServer.RichEdit2.Clear;
      PageCache_SetRichText(FWebServer.RichEdit2,FRTF.text);
      FWebServer.PageRTF_Textformat:=FWebServer.RichEdit2.Text;
    end;

    if (FWebServer.isServerEnabled()) then begin
      if (iPage>0) then FWebServer.nextRTF(iPage,SCS[iPage*2])
      else FWebServer.nextRTF(iPage,0);
    end;
    if (want_screen) then begin
      FWebServer.SendToScreens(FWebServer.PageRTF_Textformat);
    end;

    Blanked:=false;
    SetGlobals;
  end;

  UpdateLabels(iPage);
  LoadCopyright(GID);
  if (Self = FProjWin) and FLiveWindow.Visible then FLiveWindow.UpdateContent;
  Invalidate;
  if (CurrentPage <> 0) then begin
    Blanked  := false;
  end;

end;

procedure TFEditProj.ShowHighlight( bShow : boolean );
begin
  if bShowHighlight <> bShow then begin
    bShowHighlight := bShow;
    Invalidate;
    if FLiveWindow.Visible then begin
      FLiveWindow.PHighlight.Visible := bShow;
      if bShow then begin
        FLiveWindow.PHighlight.SetBounds( FLiveWindow.PButtons.Left + 2, 2,
               FLiveWindow.PButtons.Width - 4,
               FLiveWindow.LCopyright1.Height + FLiveWindow.LCopyright1.Top + 2 );
        FLiveWindow.ImgHighlight.Canvas.Brush.Color := clBtnFace;
        FLiveWindow.ImgHighlight.Canvas.FillRect( FLiveWindow.ImgHighlight.ClientRect );
      end;
    end;
  end;
end;

end.

