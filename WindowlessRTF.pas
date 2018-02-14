// Demonstration of using TOM.pas, the windowless rich-edit control, and
// the text object model
// http://www.cs.wisc.edu/~rkennedy/windowless-rtf

// Copyright © 2003-2006 Rob Kennedy. Some rights reserved.
// For license information, see http://www.cs.wisc.edu/~rkennedy/license

unit WindowlessRTF;

interface
uses Types, Graphics, TOM, RichTom;

type
  TWindowlessRTF = class(TObject)
  private
    FRect: TRect;
    FText: string;

    // Forces
    ForceName, ForceSize, ForceColor, ForceBold, ForceItalic : boolean;
    FontName      : string;
    FontSize      : cardinal;
    FontColor     : TColor;
    FontBold      : boolean;
    FontItalic    : boolean;

    // Shadow
    bShadow       : boolean;
    ShadowColor   : integer;
    iShadowOffset : integer;

    procedure Set_Text( sText : string );
    function  Get_Text : string;

  public
    FHost:     ITextHost;
    FServices: ITextServices;
    FDocument: ITextDocument;
    FHostImpl: TTextHostImpl;

    constructor Create();
    destructor  Destroy(); override;

    property    Text: string read Get_Text write Set_Text;

    procedure   SetClientRect( prc: TRect );
    procedure   SetTransparent( bTrans : boolean );
    procedure   SetWordWrap( bWrap : boolean );
    procedure   SetDPI( newDPI : integer );
    procedure   SetZoom( newZoom : extended );
    procedure   SetShadow( bShadow : boolean; cColor : TColor; iOffset : integer );

    procedure   ResetForces();
    procedure   SetFont( sName : string );
    procedure   SetFontSize( uiSize : cardinal  );
    procedure   SetColor( clColor : TColor );
    procedure   SetItalic( bItalic : boolean );
    procedure   SetBold( bBold : boolean );

    procedure   OnPaint( Canvas : TCanvas );
  end;


implementation

uses Windows, SysUtils, ComObj, ActiveX, RichEdit, Messages, Forms;

type
  PCookie = ^TCookie;
  TCookie = record
    dwSize, dwCount: Cardinal;
    Text: PChar;
  end;

  TDrawRTFTextHost = class(TTextHostImpl)
  private
    FDefaultCharFormat: PCharFormatW;
    FDefaultParaFormat: PParaFormat;
    iDPI:  integer;
    fZoom: extended;

  protected
    // TTextHostImpl
    function TxGetClientRect(out prc: TRect): HResult; override;
    function TxGetCharFormat(out ppCF: PCharFormatW): HResult; override;
    function TxGetParaFormat(out ppPF: PParaFormat): HResult; override;
    function TxGetBackStyle(out pstyle: TTxtBackStyle): HResult; override;
    function OnTxCharFormatChange(const pcf: TCharFormatW): HResult; override;
    function OnTxParaFormatChange(const ppf: TParaFormat): HResult; override;
    function TxGetPropertyBits(dwMask: DWord; out pdwBits: DWord): HResult; override;
    function TxNotify(iNotify: DWord; pv: Pointer): HResult; override;
    function TxGetExtent(out lpExtent: TSizeL): HResult; override;
  public
    FRect: TRect;
    FTransparent, FWordWrap: Boolean;
    
    constructor Create();
    destructor Destroy; override;
  end;

  // message constants
  const EM_GETZOOM = WM_USER + 224;
        EM_SETZOOM = WM_USER + 225;

function StrCpyN(dest: PChar; const src: PChar; cchMax: Integer): PChar; stdcall; external 'shlwapi.dll' name 'StrCpyNA';
function StrCpyNA(dest: PAnsiChar; const src: PAnsiChar; cchMax: Integer): PAnsiChar; stdcall; external 'shlwapi.dll';
function StrCpyNW(dest: PWideChar; const src: PWideChar; cchMax: Integer): PWideChar; stdcall; external 'shlwapi.dll';

function EditStreamInCallback(dwCookie: Longint; pbBuff: PByte; cb: Longint; var pcb: Longint): Longint; stdcall;
var
  Cookie: PCookie;
begin
  Result := 0;

  Cookie := PCookie(dwCookie);
	if Cookie.dwSize - Cookie.dwCount < Cardinal(cb) then pcb := Cookie.dwSize - Cookie.dwCount
	else pcb := cb;

  if pcb <= 0 then exit;

	CopyMemory(pbBuff, Cookie.Text, pcb);
	Inc(Cookie.dwCount, pcb);
  Inc(Cookie.Text, pcb);
end;



constructor TWindowlessRTF.Create;
var Unknown    : IUnknown;
    ActualHost : TDrawRTFTextHost;
begin
  FHostImpl := TDrawRTFTextHost.Create();
  FHost     := CreateTextHost(FHostImpl);
  OleCheck(CreateTextServices(nil, FHost, Unknown));
  FServices := Unknown as ITextServices;
  FDocument := Unknown as ITextDocument;
  Unknown   := nil;
  PatchTextServices(FServices);

  // Initialise shadow as black
  bShadow       := true;
  ShadowColor   := RGB(0,0,0);
  iShadowOffset := 4;

  // Unset all the forces
  ResetForces();

  ActualHost        := TDrawRTFTextHost(FHostImpl);
  ActualHost.iDPI   := Application.MainForm.PixelsPerInch;
  ActualHost.fZoom  := 1.0;
end;

destructor TWindowlessRTF.Destroy;
begin
  FHostImpl := nil;
  FHost     := nil;
  FServices := nil;
  FDocument := nil;
end;

procedure TWindowlessRTF.SetClientRect( prc: TRect );
var ActualHost: TDrawRTFTextHost;
begin
  ActualHost := TDrawRTFTextHost(FHostImpl);
  ActualHost.FRect := prc;
  FRect := prc;
  if FServices <> nil then begin
    FServices.OnTxPropertyBitsChange( TXTBIT_CLIENTRECTCHANGE, TXTBIT_CLIENTRECTCHANGE );
  end;
end;

procedure TWindowlessRTF.SetTransparent( bTrans : boolean );
var ActualHost: TDrawRTFTextHost;
begin
  ActualHost := TDrawRTFTextHost(FHostImpl);
  ActualHost.FTransparent := bTrans;
  if FServices <> nil then begin
    FServices.OnTxPropertyBitsChange( TXTBIT_BACKSTYLECHANGE, TXTBIT_BACKSTYLECHANGE );
  end;
end;

procedure TWindowlessRTF.SetWordWrap( bWrap : boolean );
var ActualHost: TDrawRTFTextHost;
begin
  ActualHost := TDrawRTFTextHost(FHostImpl);
  ActualHost.FWordWrap := bWrap;
  if FServices <> nil then begin
    FServices.OnTxPropertyBitsChange( TXTBIT_WORDWRAP, TXTBIT_WORDWRAP );
  end;
end;

function TWindowlessRTF.Get_Text : string;
begin
  Result := FText;
end;

procedure TWindowlessRTF.Set_Text( sText : string );
begin
  FText := sText;
  // Invalidate(); ?
end;

procedure TWindowlessRTF.SetDPI( newDPI : integer );
var ActualHost: TDrawRTFTextHost;
begin
  ActualHost := TDrawRTFTextHost(FHostImpl);
  ActualHost.iDPI := newDPI;
end;

procedure TWindowlessRTF.SetZoom( newZoom : extended );
var ActualHost: TDrawRTFTextHost;
begin
  ActualHost := TDrawRTFTextHost(FHostImpl);
  ActualHost.fZoom := newZoom;
end;

procedure TWindowlessRTF.SetShadow( bShadow : boolean; cColor : TColor; iOffset : integer );
begin
  Self.ShadowColor   := RGB( GetRValue(cColor), GetGValue(cColor), GetBValue(cColor) );
  Self.bShadow       := bShadow;
  Self.iShadowOffset := iOffset;
end;

procedure TWindowlessRTF.SetFont( sName : string );
begin
  Self.FontName  := sName;
  Self.ForceName := true;
end;

procedure TWindowlessRTF.SetFontSize( uiSize : cardinal  );
begin
  Self.FontSize  := uiSize;
  Self.ForceSize := true;
end;

procedure TWindowlessRTF.SetColor( clColor : TColor );
begin
  Self.FontColor  := clColor;
  Self.ForceColor := true;
end;

procedure TWindowlessRTF.SetItalic( bItalic : boolean );
begin
  Self.FontItalic  := bItalic;
  Self.ForceItalic := true;
end;

procedure TWindowlessRTF.SetBold( bBold : boolean );
begin
  Self.FontBold  := bBold;
  Self.ForceBold := true;
end;

procedure TWindowlessRTF.ResetForces();
begin
  Self.ForceName   := false;
  Self.ForceSize   := false;
  Self.ForceColor  := false;
  Self.ForceBold   := false;
  Self.ForceItalic := false;
end;


procedure TWindowlessRTF.OnPaint( Canvas : TCanvas );
var Cookie : TCookie;
    Stream : TEditStream;
    res    : Integer;
    ShadowRect : TRect;
    Range  : ITextRange;
begin
//  Self.Canvas.Draw( 0,0, Image1.Picture.Graphic );

  Cookie.dwCount := 0;
  Cookie.dwSize := Length(FText);
  Cookie.Text := PChar(FText);
  Stream.dwCookie := Integer(@Cookie);
  Stream.dwError := 0;
  Stream.pfnCallback := EditStreamInCallback;
  OleCheck(FServices.TxSendMessage(em_StreamIn, sf_RTF or sff_PlainRTF, lParam(@Stream), res));

  if bShadow then begin
    ShadowRect := Rect( FRect.Left  + iShadowOffset, FRect.Top    + iShadowOffset,
                        FRect.Right + iShadowOffset, FRect.Bottom + iShadowOffset );

    Range := FDocument.Range( 0, Length(FText) );
    if ForceName   then Range.Font.Name      := FontName;
    if ForceSize   then Range.Font.Size      := FontSize;
    if ForceItalic then begin
      if FontItalic then Range.Font.Italic := tomTrue else Range.Font.Italic := tomFalse;
    end;
    if ForceBold   then begin
      if FontBold then Range.Font.Bold := tomTrue else Range.Font.Bold := tomFalse;
    end;
    Range.Font.ForeColor := ShadowColor;
    OleCheck(FServices.TxDraw(dvAspect_Content, 0, nil, nil, Canvas.Handle, 0,
             ShadowRect, PRect(nil)^, PRect(nil)^, nil, 0, txtView_Inactive));
  end;

  Cookie.dwCount := 0;
  Cookie.dwSize := Length(FText);
  Cookie.Text := PChar(FText);
  Stream.dwCookie := Integer(@Cookie);
  Stream.dwError := 0;
  Stream.pfnCallback := EditStreamInCallback;
  OleCheck(FServices.TxSendMessage(em_StreamIn, sf_RTF or sff_PlainRTF, lParam(@Stream), res));

  // Set any forces on the text
  if ForceName or ForceSize or ForceColor or ForceItalic or ForceBold then
  begin
    Range := FDocument.Range( 0, Length(FText) );
    if ForceName   then Range.Font.Name      := FontName;
    if ForceSize   then Range.Font.Size      := FontSize;
    if ForceColor  then Range.Font.ForeColor := FontColor;
    if ForceItalic then begin
      if FontItalic then Range.Font.Italic := tomTrue else Range.Font.Italic := tomFalse;
    end;
    if ForceBold   then begin
      if FontBold then Range.Font.Bold := tomTrue else Range.Font.Bold := tomFalse;
    end;
  end;

  OleCheck(FServices.TxDraw(dvAspect_Content, 0, nil, nil, Canvas.Handle, 0,
           FRect, PRect(nil)^, PRect(nil)^, nil, 0, txtView_Inactive));

  // If there's a selection, highlight it!
{  if  <> nil then begin
    FDocument.Selection.GetPoint( tomStart, iStartX, iStartY );
    FDocument.Selection.GetPoint( tomEnd,   iEndX,   iEndY );
    brush := CreateSolidBrush( RGB(255,255,255) );
    SelectObject( Canvas.Handle, brush );
    PatBlt( Canvas.Handle, iX, iY, 300, 100, PATINVERT );
  end;}
end;

{ TDrawRTFTextHost }

constructor TDrawRTFTextHost.Create();
begin
  inherited Create;

  GetMem(FDefaultCharFormat, SizeOf(FDefaultCharFormat^));
  FillChar(FDefaultCharFormat^, SizeOf(FDefaultCharFormat^), 0);
  FDefaultCharFormat.cbSize := SizeOf(FDefaultCharFormat^);

  Cardinal(FDefaultCharFormat.dwMask) := cfm_Bold or cfm_Charset or {cfm_Color or}
                                         cfm_Face or cfm_Italic or cfm_Offset or
                                         cfm_Protected or {cfm_Size or} cfm_Strikeout or cfm_Underline;
  FDefaultCharFormat.dwEffects := 0;
  FDefaultCharFormat.yHeight := 8 * 20;
  FDefaultCharFormat.crTextColor := ColorToRGB(clBlack);
  FDefaultCharFormat.bCharSet := Default_Charset;
  FDefaultCharFormat.bPitchAndFamily := Default_Pitch or ff_DontCare;
  StrCpyNW(FDefaultCharFormat.szFaceName, 'Tahoma', SizeOf(FDefaultCharFormat.szFaceName) div SizeOf(FDefaultCharFormat.szFaceName[0]));

  GetMem(FDefaultParaFormat, SizeOf(FDefaultParaFormat^));
  FillChar(FDefaultParaFormat^, SizeOf(FDefaultParaFormat^), 0);
  FDefaultParaFormat.cbSize := SizeOf(FDefaultParaFormat^);

  FDefaultParaFormat.dwMask := pfm_All;
  FDefaultParaFormat.wAlignment := pfa_Left;
  FDefaultParaFormat.cTabCount := 1;
  FDefaultParaFormat.rgxTabs[0] := lDefaultTab;
end;


destructor TDrawRTFTextHost.Destroy;
begin
  FreeMem(FDefaultCharFormat);
  FreeMem(FDefaultParaFormat);
  inherited;
end;

function TDrawRTFTextHost.OnTxCharFormatChange(const pcf: TCharFormatW): HResult;
var
  NewCharFormat: PCharFormatW;
begin
  try
    GetMem(NewCharFormat, pcf.cbSize);
    Move(pcf, NewCharFormat^, pcf.cbSize);
    FreeMem(FDefaultCharFormat);
    PCharFormatW(FDefaultCharFormat) := NewCharFormat;
    Result := S_OK;
  except
    Result := E_Fail;
  end;
end;

function TDrawRTFTextHost.OnTxParaFormatChange(const ppf: TParaFormat): HResult;
var
  NewParaFormat: PParaFormat;
begin
  try
    GetMem(NewParaFormat, ppf.cbSize);
    Move(ppf, NewParaFormat^, ppf.cbSize);
    FreeMem(FDefaultParaFormat);
    PParaFormat(FDefaultParaFormat) := NewParaFormat;
    Result := S_OK;
  except
    Result := E_Fail;
  end;
end;

function TDrawRTFTextHost.TxGetExtent(out lpExtent: TSizeL): HResult;
var fExtend : extended;
  //  ActualHost: TDrawRTFTextHost;
begin
//  ActualHost := TDrawRTFTextHost(Self);

  fExtend := ((FRect.Bottom - FRect.Top) * 2540) / (fZoom * iDPI);
  lpExtent.cy := Round( fExtend );
  Result := S_OK;

// [HIMETRIC vertical extent - 100ths of mm] =
//      ([pixel height of the client rect] * 2540) /
//      ([vertical zoom factor] * [pixel per vertical inch (from device context)])
end;

function TDrawRTFTextHost.TxGetBackStyle(out pstyle: TTxtBackStyle): HResult;
begin
  if FTransparent then
    pstyle := txtBack_Transparent
  else
    pstyle := txtBack_Opaque;
  Result := S_OK;
end;

function TDrawRTFTextHost.TxGetCharFormat(out ppCF: PCharFormatW): HResult;
begin
  ppCF := PCharFormatW(FDefaultCharFormat);
  Result := S_OK;
end;

function TDrawRTFTextHost.TxGetClientRect(out prc: TRect): HResult;
begin
  prc := FRect;
  Result := S_OK;
end;

function TDrawRTFTextHost.TxGetParaFormat(out ppPF: PParaFormat): HResult;
begin
  ppPF := PParaFormat(FDefaultParaFormat);
  Result := S_OK;
end;

function TDrawRTFTextHost.TxGetPropertyBits(dwMask: DWord; out pdwBits: DWord): HResult;
begin
  pdwBits := txtBit_DisableDrag or txtBit_Multiline or txtBit_RichText;
  if FWordWrap then
    pdwBits := pdwBits or txtBit_WordWrap;
  pdwBits := pdwBits and dwMask;
  Result := S_OK;
end;

function TDrawRTFTextHost.TxNotify(iNotify: DWord; pv: Pointer): HResult;
begin
  case iNotify of
    en_Update: Result := S_OK;
    else Result := inherited TxNotify(iNotify, pv);
  end;
end;

end.
