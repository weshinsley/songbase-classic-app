unit Appear;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, ConfigOffsets, SBFiles, ExtDlgs,
  ToolWin, MultiMon, ImgList, mbOfficeColorDialog;

type
  TFontInfo = record
    // Settings
    Name   : string;
    Size   : cardinal;
    Bold   : boolean;
    Italic : boolean;
    Color  : TColor;

    // Forces
    ForceName, ForceSize, ForceBold, ForceItalic, ForceColor : boolean;
  end;

  // The version of this structure in the MultiMon unit is wrong, see
  // http://qc.borland.com/wc/qcmain.aspx?d=3239
  tagMONITORINFOEXA = record
    cbSize: DWORD;
    rcMonitor: TRect;
    rcWork: TRect;
    dwFlags: DWORD;
    szDevice: array[0..CCHDEVICENAME - 1] of AnsiChar;
  end;


  TFSettings = class(TForm)
    Button1: TButton;
    TCSettings: TTabControl;
    PAppear: TPanel;
    BackTick: TCheckBox;
    ImageTick: TCheckBox;
    PCol2: TPanel;
    PColb: TPanel;
    Lb: TLabel;
    PGeneral: TPanel;
    AutoView1: TCheckBox;
    CBAutoOHP: TCheckBox;
    CBEnableSS: TCheckBox;
    MComps: TMemo;
    AutoViewSingle1: TCheckBox;
    CBPreviewAspect: TCheckBox;
    FileOpenPicture: TOpenPictureDialog;
    BGTestImg: TImage;
    CBRemoveSort: TCheckBox;
    LPrimaryFont: TLabel;
    PCopyFont: TPanel;
    PCYCol: TPanel;
    LCopyFont: TLabel;
    PCYItalic: TPanel;
    LCYItalic: TLabel;
    PCYBold: TPanel;
    LCYBold: TLabel;
    PPrimaryFont: TPanel;
    PPCol: TPanel;
    PPItalic: TPanel;
    LPItalic: TLabel;
    PPBold: TPanel;
    LPBold: TLabel;
    LCCLIFont: TLabel;
    PCCLIFont: TPanel;
    PCCCol: TPanel;
    PCCItalic: TPanel;
    LCCItalic: TLabel;
    PCCBold: TPanel;
    LCCBold: TLabel;
    LPFontSize: TLabel;
    LCYFontsize: TLabel;
    LCCFontsize: TLabel;
    EOffsets: TEdit;
    LOffsets: TLabel;
    cbPowerPoint: TCheckBox;
    BChangeFont: TButton;
    cbProjectNext: TCheckBox;
    PCCLI: TPanel;
    ELicense: TEdit;
    ECustRef: TEdit;
    LCRef: TLabel;
    LCCLicence: TLabel;
    EOrg: TEdit;
    LOrg: TLabel;
    LMRLicense: TLabel;
    EMRLicence: TEdit;
    LOrgAd: TLabel;
    EOrgAdd: TEdit;
    LOrgTown: TLabel;
    EOrgTown: TEdit;
    LOrgPC: TLabel;
    EOrgPostcode: TEdit;
    LOrgCountry: TLabel;
    EOrgCountry: TEdit;
    LOrgDayTel: TLabel;
    EOrgDayTel: TEdit;
    LOrgEveTel: TLabel;
    EOrgEveTel: TEdit;
    LOrgFax: TLabel;
    EOrgFax: TEdit;
    LOrgEmail: TLabel;
    EOrgEmail: TEdit;
    EOrgWebsite: TEdit;
    LOrgWeb: TLabel;
    LRepTitle: TLabel;
    ERepTitle: TEdit;
    ERepForename: TEdit;
    LRepForename: TLabel;
    LRepSurname: TLabel;
    ERepSurname: TEdit;
    ERepAddress: TEdit;
    LRepAdd: TLabel;
    LRepTown: TLabel;
    ERepTown: TEdit;
    ERepPostcode: TEdit;
    LRepPostCode: TLabel;
    LRepCountry: TLabel;
    ERepCountry: TEdit;
    ERepDayTel: TEdit;
    LRepDayTel: TLabel;
    LRepEveTel: TLabel;
    ERepEveTel: TEdit;
    LExpiry: TLabel;
    DTExpiry: TDateTimePicker;
    ETempFiles: TEdit;
    LTempFile: TLabel;
    AutoLoad1: TCheckBox;
    BitBtn1: TBitBtn;
    Bevel5: TBevel;
    Bevel6: TBevel;
    BImage: TBitBtn;
    EImage: TEdit;
    gbSongList: TGroupBox;
    gbProject: TGroupBox;
    gbFiles: TGroupBox;
    gbCCLI: TGroupBox;
    LRequired: TLabel;
    IgnoreDoubleClicks: TCheckBox;
    cbDualMonitor: TCheckBox;
    btMonitor: TButton;
    Label2: TLabel;
    cbShadow: TCheckBox;
    PShadowCol: TPanel;
    ForceBGImage: TCheckBox;
    TBShadowOffset: TTrackBar;
    LShadowOffset: TLabel;
    PPrimary: TPanel;
    PCopy: TPanel;
    PCCLIName: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ebMinLyricSearch: TEdit;
    cbSearchLyrics: TCheckBox;
    cbF2F3WinSearch: TCheckBox;
    lbBGImages: TListBox;
    bAddBG: TButton;
    bRemoveBG: TButton;
    cbBGOrder: TComboBox;
    Label6: TLabel;
    CBScaleProjRes: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    LScaleProj1: TLabel;
    Label11: TLabel;
    GroupBox1: TGroupBox;
    cbBlankImg: TCheckBox;
    EBlankImg: TEdit;
    BBlankImg: TBitBtn;
    ColorDialog2: TmbOfficeColorDialog;
    procedure BackTickClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PColbClick(Sender: TObject);
    procedure LbClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BImageClick(Sender: TObject);
    procedure TCSettingsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BChangeFontClick(Sender: TObject);
    procedure CBScaleProjResChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BGTestImgClick(Sender: TObject);
    procedure EImageChange(Sender: TObject);
    procedure cbDualMonitorClick(Sender: TObject);
    procedure btMonitorClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure PShadowColClick(Sender: TObject);
    procedure TBShadowOffsetChange(Sender: TObject);
    procedure PrimaryClick(Sender: TObject);
    procedure CopyClick(Sender: TObject);
    procedure CCLIClick(Sender: TObject);
    procedure ebMinLyricSearchChange(Sender: TObject);
    procedure cbSearchLyricsClick(Sender: TObject);
    procedure lbBGImagesClick(Sender: TObject);
    procedure bAddBGClick(Sender: TObject);
    procedure bRemoveBGClick(Sender: TObject);
    procedure lbBGImagesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BBlankImgClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    posX,posY        : integer;
    ImageFile        : String;
    PrimaryFont      : TFontInfo;
    CopyrightFont    : TFontInfo;
    CCLIFont         : TFontInfo;
    DefaultMainFont  : TFontInfo;
    DefaultSmallFont : TFontInfo;
    szProjectScale   : Size;
    SBGError, SDefaultFont, SColoured : string;
    SBold, SNoBold, SItalic, SNoItalic : string;
    SOffsetChHint, SOffsetChHintDisabled, STempWin : string;
    iShadowOffset    : integer;
    bShowingImg      : boolean;
    iMinSearchLyrics : integer;

    procedure UpdateFontInfo( hFont : TFontInfo;
                              var hName : TPanel;
                              var hSize : TLabel;
                              var hBoldPan, hItalicPan, hColPan : TPanel;
                              var hBoldLab, hItalicLab : TLabel );
    procedure SetLabelFont( var hLabel : TLabel; hSetFont, hDefaultFont : TFontInfo );
    procedure SetFontInfo( var FontInfo : TFontInfo;
                           SetName   : boolean; Name   : string;
                           SetSize   : boolean; Size   : cardinal;
                           SetBold   : boolean; Bold   : boolean;
                           SetItalic : boolean; Italic : boolean;
                           SetColor  : boolean; Color  : TColor );
    procedure SetTextDetails( var FontToSet,   DefaultFont : TFontInfo;
                              var SampleLabel, InfoLabel   : TLabel );
    procedure SetProjectScale( iItem : integer );
    function BrowseForFolder(const browseTitle: String; const initialFolder: String = ''): String;
    function GetNextBackground( sLast : string; bNewSong : boolean; iPage : integer ): string;
  end;

var
  FSettings: TFSettings;
  lg_StartFolder: String;

const SET_TAB_APPEARANCE : Integer = 0;
      SET_TAB_GENERAL    : Integer = 1;
      SET_TAB_CCLI       : Integer = 2;
      SET_TAB_SYSTEM     : Integer = 3;

implementation

uses SBMain, EditProj, PreviewWindow, shlobj, strutils, Math, SelectProjectScreen,
  FontConfig;

{$R *.DFM}

const ResWidth:  array[0..6] of integer = (0, 640, 800, 1024, 1152, 1280, 1366);
const ResHeight: array[0..6] of integer = (0, 480, 600,  768,  864, 1024, 768);
const BIF_NEWDIALOGSTYLE=$40;

{
procedure TFSettings.FontTickClick(Sender: TObject);
begin
  CBFont.Enabled:=FontTick.Checked;
end;

procedure TFSettings.SizeTickClick(Sender: TObject);
begin
  FontSize.Enabled:=SizeTick.Checked;
  UpDown1.Enabled:=SizeTick.Checked;
end;

procedure TFSettings.ForeTickClick(Sender: TObject);
begin
  PColf.Enabled:=ForeTick.Checked;
  PColF.Visible:=ForeTick.Checked;
end;
}

procedure TFSettings.BackTickClick(Sender: TObject);
begin
  PColb.Enabled:=BackTick.Checked;
  PColB.Visible:=BackTick.Checked;
end;

procedure TFSettings.SetFontInfo( var FontInfo : TFontInfo;
                           SetName   : boolean; Name   : string;
                           SetSize   : boolean; Size   : cardinal;
                           SetBold   : boolean; Bold   : boolean;
                           SetItalic : boolean; Italic : boolean;
                           SetColor  : boolean; Color  : TColor );
begin
  FontInfo.Name   := Name;
  FontInfo.Size   := Size;
  FontInfo.Bold   := Bold;
  FontInfo.Italic := Italic;
  FontInfo.Color  := Color;

  FontInfo.ForceName   := SetName;
  FontInfo.ForceSize   := SetSize;
  FontInfo.ForceBold   := SetBold;
  FontInfo.ForceItalic := SetItalic;
  FontInfo.ForceColor  := SetColor;
end;


{
procedure TFSettings.BoldTickClick(Sender: TObject);
begin
  SBold.Enabled:=BoldTick.Checked;
end;

procedure TFSettings.ItalTickClick(Sender: TObject);
begin
  SItalic.Enabled:=ItalTick.Checked;
end;
}

procedure TFSettings.Button1Click(Sender: TObject);
begin
  SaveParams(SBMain.INIFile);
  close;
end;

{
procedure TFSettings.PColfClick(Sender: TObject);
begin
  ColorDialog1.Color:=PColF.Color;
  if ColorDialog1.Execute then PColF.Color:=Colordialog1.Color;
end;
}

{
procedure TFSettings.LfClick(Sender: TObject);
begin
  PColfClick(Sender);
end;
}

procedure TFSettings.PColbClick(Sender: TObject);
begin
  if ColorDialog2.Execute(PColB.Color) then PColB.Color:=Colordialog2.SelectedColor;

end;

procedure TFSettings.LbClick(Sender: TObject);
begin
  PColBClick(Sender);
end;

{
procedure TFSettings.UpDown1Click(Sender: TObject; Button: TUDBtnType);
var S : string;
begin
  str(UpDown1.Position,S);
  FontSize.Text:=S;
end;
}

procedure TFSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  posX:=left;
  posY:=top;

  if( ImageTick.Checked and not FileExists( ImageFile ) ) then
    ImageTick.Checked := false;

  if( cbBlankImg.Checked and FileExists( EBlankImg.Text ) ) then begin
    FProjWin.BlankImgFile := EBlankImg.Text;
    FProjWin.ImgBlank.Picture.LoadFromFile( FProjWin.BlankImgFile );
  end else begin
    FProjWin.BlankImgFile := '';
  end;

  if FProjWin.Visible then FProjWin.bForceRedraw := true;
  
  // Ensure the offset is a legal one
  FProjWin.bSetOffsets := false;
  bIgnoreDoubleClicks  := IgnoreDoubleClicks.Checked;
end;

procedure TFSettings.BImageClick(Sender: TObject);
{var bBGError : boolean;
    sErrStr  : string;  }
begin
//  bBGError := false;
  if FileOpenPicture.Execute then begin
    ImageTick.Checked := true;
    EImage.Text       := FileOpenPicture.FileName;
{    try
      FSettings.BGTestImg.Picture.LoadFromFile( ImageFile );
    except on EStreamError do bBGError := true end;
    if bBGError then begin
      FmtStr( sErrStr, SBGError, [ ImageFile ] );
      MessageDlg( sErrStr, mtError, [mbOK], 0 );
      FSettings.ImageTick.Checked := false;
    end;
    EImage.Text := ImageFile;}
  end;
end;

procedure TFSettings.TCSettingsChange(Sender: TObject);
begin
  PAppear.Visible    := TCSettings.TabIndex = SET_TAB_APPEARANCE;
  PGeneral.Visible   := TCSettings.TabIndex = SET_TAB_GENERAL;
  PCCLI.Visible      := TCSettings.TabIndex = SET_TAB_CCLI;
end;

procedure TFSettings.FormCreate(Sender: TObject);
var i : integer;
    S : string;
begin
  TCSettings.TabIndex := 0;
  PAppear.Visible     := true;
  PGeneral.Visible    := false;
  iShadowOffset   := 4;
  bShowingImg     := false;

  // Default font
  SetFontInfo( DefaultMainFont,
               false, 'Arial',
               false, 24,
               false, false,
               false, false,
               false, clWhite );

  SetFontInfo( DefaultSmallFont,
               false, 'Arial',
               false, 12,
               false, false,
               false, false,
               false, clWhite );

  // Get the fonts
  PrimaryFont   := DefaultMainFont;
  CCLIFont      := DefaultSmallFont;
  CopyrightFont := DefaultSmallFont;

  // Fill in the projection resolutions box
  for i := 0 to Length(ResWidth)-1 do begin
    if ResWidth[i] = 0 then S:= 'Full Screen'
                       else S:= IntToStr(ResWidth[i]) +'x'+ IntToStr(ResHeight[i]);
    CBScaleProjRes.Items.Add( S );
  end;
  CBScaleProjRes.ItemIndex := 0;
  szProjectScale.cx := 0;
  szProjectScale.cy := 0;

  SBGError := 'Background Image "%s" could not be loaded';
  SDefaultFont := '<Default Font>';
  SBold     := 'Bold';    SNoBold   := 'Not Bold';
  SItalic   := 'Italic';  SNoItalic := 'Not Italic';
  SColoured := 'Coloured';
  STempWin  := 'Select Temporary Directory';
  ebMinLyricSearchChange(Self);
end;

procedure TFSettings.FormShow(Sender: TObject);
begin
  lefT:=posX;
  top:=posY;
  PAppear.top:=24;
  PAppear.left:=8;
  PGeneral.left:=8;
  PGeneral.top:=24;

  if CBScaleProjRes.ItemIndex < 0 then CBScaleProjRes.ItemIndex := 0;

  FSettings.EOffsets.Text  := '(' + IntToStr( FSongbase.rTextArea.Left   ) + 'px,'  +
                                    IntToStr( FSongbase.rTextArea.Top    ) + 'px) -> (' +
                                    IntToStr( FSongbase.rTextArea.Right  ) + 'px,'  +
                                    IntToStr( FSongbase.rTextArea.Bottom ) + 'px)';
  IgnoreDoubleClicks.Checked := bIgnoreDoubleClicks;
  ETempFiles.Text := TempHost;
  EImage.Text := ImageFile;

  // Set up the blanking image
  EBlankImg.Text := FProjWin.BlankImgFile;
  cbBlankImg.Checked := FProjWin.BlankImgFile <> '';

  TBShadowOffset.Position := max( TBShadowOffset.min,
                                  min( TBShadowOffset.Max, iShadowOffset ) );

  if ImageTick.Checked then try
    BGTestImg.Picture.LoadFromFile( ImageFile );
  except on EStreamError do BGTestImg.Enabled := false; end;

  // Set up the font information boxes
  UpdateFontInfo( PrimaryFont, PPrimary, LPFontsize,
                  PPBold, PPItalic, PPCol,
                  LPBold, LPItalic );
  UpdateFontInfo( CopyrightFont, PCopy, LCYFontsize,
                  PCYBold, PCYItalic, PCYCol,
                  LCYBold, LCYItalic );
  UpdateFontInfo( CCLIFont, PCCLIName, LCCFontsize,
                  PCCBold, PCCItalic, PCCCol,
                  LCCBold, LCCItalic );

  cbDualMonitor.Enabled := FSongbase.bMultiMonCapable;
  Label2.Enabled        := FSongbase.bMultiMonCapable;
  cbDualMonitor.Checked := FSongbase.bMultiMonitor;
  btMonitor.Enabled     := FSongbase.bMultiMonitor;
  btMonitor.Caption     := IntToStr(FSongbase.ProjectScreen);

  // Show 'Click to select Backgrounds' message
  if 0 = lbBGImages.Count then bRemoveBG.Click;

  // If the live window is showing then don't allow us to change the monitor
  if cbDualMonitor.Enabled then begin
    cbDualMonitor.Enabled := not FLiveWindow.Visible;
    Label2.Enabled        := cbDualMonitor.Enabled;
    btMonitor.Enabled     := cbDualMonitor.Enabled;
    if FLiveWindow.Visible then begin
      cbDualMonitor.Hint := 'Cannot change monitor whilst Projecting';
      cbDualMonitor.ShowHint := true;
    end;
  end;

 // cbMonitorDropDown.Items.Clear;
 // EnumDisplayMonitors( 0, nil, MultiMonEnumCallback, 0 );
end;

{
var
   DisDev, DisDevMon: TDisplayDevice;
begin
   result:= '';
   DisDev.cb:= SizeOf(TDisplayDevice);
   DisDevMon.cb:= SizeOf(TDisplayDevice);
   if EnumDisplayDevices(NIL, Index, DisDev, 0) then begin
      if DisDev.StateFlags = DISPLAY_DEVICE_MIRRORING_DRIVER then exit;
      while EnumDisplayDevices(@DisDev.DeviceName, 0, DisDevMon, 0) do begin
         result:= DisDevMon.DeviceString;
         if (DisDevMon.StateFlags <> DISPLAY_DEVICE_ACTIVE) then break;
      end;
   end;
}

{function MultiMonEnumCallback(hm: HMONITOR; dc: HDC; r: PRect; l: LPARAM): Boolean; stdcall;
var
  hMonitorInfo   : TMonitorInfoEx;
  hDisplayDevice : TDisplayDevice;
begin
  hMonitorInfo.cbSize := sizeof(tagMONITORINFOEXA);
  hDisplayDevice.cb   := sizeof(TDisplayDevice);
  if GetMonitorInfo( hm, @hMonitorInfo ) then begin
    if EnumDisplayDevices( @hMonitorInfo.szDevice, 0, hDisplayDevice, 0 ) then begin
      FSettings.cbMonitorDropDown.Items.Add( hDisplayDevice.DeviceString );
    end;
  end;
end;
}


procedure TFSettings.BChangeFontClick(Sender: TObject);
begin
  FConfigOffsets.ShowModal();
  FSettings.EOffsets.Text  := '(' + IntToStr( FSongbase.rTextArea.Left   ) + 'px,'  +
                                    IntToStr( FSongbase.rTextArea.Top    ) + 'px) -> (' +
                                    IntToStr( FSongbase.rTextArea.Right  ) + 'px,'  +
                                    IntToStr( FSongbase.rTextArea.Bottom ) + 'px)';
end;

procedure TFSettings.UpdateFontInfo( hFont : TFontInfo;
                                     var hName : TPanel; var hSize : TLabel;
                                     var hBoldPan, hItalicPan, hColPan : TPanel;
                                     var hBoldLab, hItalicLab : TLabel );
begin
  if hFont.ForceName   then hName.Font.Color      := clBtnText
                       else hName.Font.Color      := clBtnShadow;
  if hFont.ForceBold   then hBoldLab.Font.Color   := clBtnText
                       else hBoldLab.Font.Color   := clBtnShadow;
  if hFont.ForceItalic then hItalicLab.Font.Color := clBtnText
                       else hItalicLab.Font.Color := clBtnShadow;
  if hFont.ForceSize   then hSize.Font.Color      := clBtnText
                       else hSize.Font.Color      := clBtnShadow;
  if hFont.ForceColor  then hColPan.Font.Color    := clBtnText
                       else hColPan.Font.Color    := clBtnShadow;

  hName.Caption         := hFont.Name;
  hSize.Caption         := IntToStr(hFont.Size) + 'pt';
  if hFont.ForceColor  then hColPan.Color := hFont.Color
                       else hColPan.Color := clBtnFace;
  if hFont.ForceColor  then hColPan.BevelInner := bvLowered
                       else hColPan.BevelInner := bvRaised;
  if hFont.ForceBold   and hFont.Bold   then hBoldPan.BevelInner   := bvLowered
                                        else hBoldPan.BevelInner   := bvRaised;
  if hFont.ForceItalic and hFont.Italic then hItalicPan.BevelInner := bvLowered
                                        else hItalicPan.BevelInner := bvRaised;
end;


procedure TFSettings.SetTextDetails( var FontToSet,   DefaultFont : TFontInfo;
                                     var SampleLabel, InfoLabel   : TLabel );
var SetFont : TFontInfo;
    sStyle  : string;
    hStyle  : TFontStyles;
begin
  SetFont := DefaultFont;
  hStyle  := [];
  sStyle  := '';

  if FontToSet.ForceName then begin
    SetFont.Name   := FontToSet.Name;
    sStyle := SetFont.Name;
  end
  else sStyle := SDefaultFont;
  if FontToSet.ForceSize then begin
    SetFont.Size   := FontToSet.Size;
    if sStyle <> '' then sStyle := sStyle + ', ';
    sStyle := sStyle + IntToStr(SetFont.Size) + 'pt';
  end;
  if FontToSet.ForceBold then begin
    SetFont.Bold   := FontToSet.Bold;
    if sStyle <> '' then sStyle := sStyle + ', ';
    if SetFont.Bold then begin
      sStyle := sStyle + SBold;
      include( hStyle, fsBold );
    end else
      sStyle := sStyle + SNoBold;
  end;
  if FontToSet.ForceItalic then begin
    SetFont.Italic := FontToSet.Italic;
    if sStyle <> '' then sStyle := sStyle + ', ';
    if SetFont.Italic then begin
      sStyle := sStyle + SItalic;
      include( hStyle, fsItalic );
    end else
      sStyle := sStyle + SNoItalic;
  end;
  if FontToSet.ForceColor then begin
    SetFont.Color  := FontToSet.Color;
    if sStyle <> '' then sStyle := sStyle + ', ';
    sStyle := sStyle + SColoured;
  end;

  SampleLabel.Font.Name  := SetFont.Name;
  SampleLabel.Font.Size  := SetFont.Size;
  SampleLabel.Font.Color := SetFont.Color;
  SampleLabel.Font.Style := hStyle;
  InfoLabel.Font.Color   := SetFont.Color;
  InfoLabel.Caption      := sStyle;
end;

procedure TFSettings.SetLabelFont( var hLabel : TLabel; hSetFont, hDefaultFont : TFontInfo );
var hFont  : TFontInfo;
    hStyle : TFontStyles;
begin
  hFont  := hDefaultFont;
  hStyle := [];

  if hSetFont.ForceName   then hFont.Name   := hSetFont.Name;
  if hSetFont.ForceSize   then hFont.Size   := hSetFont.Size;
  if hSetFont.ForceBold   then hFont.Bold   := hSetFont.Bold;
  if hSetFont.ForceItalic then hFont.Italic := hSetFont.Italic;
  if hSetFont.ForceColor  then hFont.Color  := hSetFont.Color;

  if hFont.Bold   then include( hStyle, fsBold );
  if hFont.Italic then include( hStyle, fsItalic );

  hLabel.Font.Name  := hFont.Name;
  hLabel.Font.Size  := hFont.Size;
  hLabel.Font.Color := hFont.Color;
  hLabel.Font.Style := hStyle;
end;

procedure TFSettings.CBScaleProjResChange(Sender: TObject);
begin
  // Update the size of the output context
  szProjectScale.cx := ResWidth[ CBScaleProjRes.ItemIndex];
  szProjectScale.cy := ResHeight[CBScaleProjRes.ItemIndex];
end;

procedure TFSettings.SetProjectScale( iItem : integer );
begin
  if (iItem < CBScaleProjRes.Items.Count) and (iItem > 0) then
    CBScaleProjRes.ItemIndex := iItem;
  szProjectScale.cx := ResWidth[ CBScaleProjRes.ItemIndex];
  szProjectScale.cy := ResHeight[CBScaleProjRes.ItemIndex];
end;

procedure TFSettings.BitBtn1Click(Sender: TObject);
begin
  ETempFiles.Text := BrowseForFolder( STempWin, ETempFiles.Text );
end;

///////////////////////////////////////////////////////////////////
// Call back function used to set the initial browse directory.
///////////////////////////////////////////////////////////////////
function BrowseForFolderCallBack(Wnd: HWND; uMsg: UINT;
        lParam, lpData: LPARAM): Integer stdcall;
begin
  if uMsg = BFFM_INITIALIZED then
    SendMessage(Wnd,BFFM_SETSELECTION,1,Integer(@lg_StartFolder[1]));
  result := 0;
end;

///////////////////////////////////////////////////////////////////
// This function allows the user to browse for a folder
//
// Arguments:-
//    browseTitle : The title to display on the browse dialog.
//  initialFolder : Optional argument. Use to specify the folder
//                  initially selected when the dialog opens.
//
// Returns: The empty string if no folder was selected (i.e. if the
//          user clicked cancel), otherwise the full folder path.
///////////////////////////////////////////////////////////////////
function TFSettings.BrowseForFolder(const browseTitle: String; const initialFolder: String =''): String;
var
  browse_info: TBrowseInfo;
  folder: array[0..MAX_PATH] of char;
  find_context: PItemIDList;
begin
  FillChar(browse_info,SizeOf(browse_info),#0);
  lg_StartFolder := initialFolder;
  browse_info.pszDisplayName := @folder[0];
  browse_info.lpszTitle := PChar(browseTitle);
  browse_info.ulFlags := BIF_RETURNONLYFSDIRS or BIF_NEWDIALOGSTYLE;
  browse_info.hwndOwner := Application.Handle;
  if initialFolder <> '' then
    browse_info.lpfn := BrowseForFolderCallBack;
  find_context := SHBrowseForFolder(browse_info);
  if Assigned(find_context) then
  begin
    if SHGetPathFromIDList(find_context,folder) then
      result := folder
    else
      result := '';
    GlobalFreePtr(find_context);
  end
  else
    result := '';
end;

procedure TFSettings.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  // Do we need to update the TempDir?
  ETempFiles.Text := ExcludeTrailingPathDelimiter(ETempFiles.Text);
  if( TempHost <> ETempFiles.Text ) then begin
    FSongbase.CleanUpDatabase;
    TempHost := ETempFiles.Text;
    if false = FSongbase.EnsureTemporaryDirectory then begin
      CanClose := false;
    end;
  end;
end;

procedure TFSettings.BGTestImgClick(Sender: TObject);
begin
  if EImage.Enabled then BImage.Click;
end;

procedure TFSettings.EImageChange(Sender: TObject);
var sFile, sExt : string;
    bSet        : boolean;
begin
  sFile := EImage.Text;
  bSet  := false;
  if (sFile <> ImageFile) or not bShowingImg then begin
    ImageFile := sFile;
    sExt      :=lowercase(ExtractFileExt(sFile));
    if ((sExt = '.jpg') or (sExt = '.jpeg') or (sExt = '.bmp') or (sExt = '.pcx')) and
       FileExists( sFile ) then begin
      try
        BGTestImg.Picture.LoadFromFile( ImageFile );
        bSet        := true;
        bShowingImg := true;
      except on EStreamError do end;
    end;

    if false = bSet then begin
      BGTestImg.Picture.Bitmap := nil;
      ImageTick.Checked        := false;
      bShowingImg              := true;
    end;
  end;
end;

procedure TFSettings.cbDualMonitorClick(Sender: TObject);
var iMonitorNum : integer;
    hMonitor    : TMonitor;
    szOldSize   : size;
begin
  FSongbase.bMultiMonConfig := cbDualMonitor.Checked;
  FSongbase.bMultiMonitor   := cbDualMonitor.Checked and FSongbase.bMultiMonCapable;
  btMonitor.Enabled         := FSongbase.bMultiMonitor;

  // Update the screen size
  if not FSongbase.bMultiMonitor then iMonitorNum := FSongbase.Monitor.MonitorNum
                                 else iMonitorNum := FSongbase.ProjectScreen-1;

  hMonitor := Screen.Monitors[iMonitorNum];
  szOldSize := FSongbase.szDisplaySize;
  FSongbase.szDisplaySize.cx  := hMonitor.Width;
  FSongbase.szDisplaySize.cy  := hMonitor.Height;
  FSongbase.ptDisplayOrigin.X := hMonitor.Left;
  FSongbase.ptDisplayOrigin.Y := hMonitor.Top;

  // Rescale offsets
  if (szOldSize.cx <> FSongbase.szDisplaySize.cx) or
     (szOldSize.cy <> FSongbase.szDisplaySize.cy) then begin
    FSongbase.rescaleOffsets( szOldSize, FSongbase.szDisplaySize );
    FSettings.EOffsets.Text  := '(' + IntToStr( FSongbase.rTextArea.Left   ) + 'px,'  +
                                      IntToStr( FSongbase.rTextArea.Top    ) + 'px) -> (' +
                                      IntToStr( FSongbase.rTextArea.Right  ) + 'px,'  +
                                      IntToStr( FSongbase.rTextArea.Bottom ) + 'px)';
  end;
end;

procedure TFSettings.btMonitorClick(Sender: TObject);
begin
  FSelectProjectScreen.Show;
end;

procedure TFSettings.Label2Click(Sender: TObject);
begin
  cbDualMonitor.Checked := not cbDualMonitor.Checked;
  cbDualMonitorClick(Sender);
end;

{procedure TFSettings.pShadowClick(Sender: TObject);
begin
  ColorDialog1.Color := pShadow.Color;
  if ColorDialog1.Execute then begin
    pShadow.Color    := ColorDialog1.Color;
    cbShadow.Checked := true;
  end;
end;}

procedure TFSettings.PShadowColClick(Sender: TObject);
begin
  if ColorDialog2.Execute(PShadowCol.Color) then PShadowCol.Color:=Colordialog2.SelectedColor;
end;

procedure TFSettings.TBShadowOffsetChange(Sender: TObject);
begin
  iShadowOffset := TBShadowOffset.Position;
  LShadowOffset.Caption := IntToStr( TBShadowOffset.Position );
end;

procedure TFSettings.PrimaryClick(Sender: TObject);
begin
  FFontConfig.DefaultFont := DefaultMainFont;
  FFontConfig.Left := Self.Left + PPrimary.Left;
  FFontConfig.Top  := Self.Top  + PPrimary.Top + PPrimary.Height;
  FFontConfig.Font := PrimaryFont;

  FFontConfig.ShowModal;

  PrimaryFont := FFontConfig.Font;
  UpdateFontInfo( PrimaryFont, PPrimary, LPFontsize,
                  PPBold, PPItalic, PPCol,
                  LPBold, LPItalic );
end;

procedure TFSettings.CopyClick(Sender: TObject);
begin
  FFontConfig.DefaultFont := DefaultSmallFont;
  FFontConfig.Left := Self.Left + PCopy.Left;
  FFontConfig.Top  := Self.Top  + PCopy.Top + PCopy.Height;
  FFontConfig.Font := CopyrightFont;

  FFontConfig.ShowModal;

  CopyrightFont := FFontConfig.Font;
  UpdateFontInfo( CopyrightFont, PCopy, LCYFontsize,
                  PCYBold, PCYItalic, PCYCol,
                  LCYBold, LCYItalic );
end;

procedure TFSettings.CCLIClick(Sender: TObject);
begin
  FFontConfig.DefaultFont := DefaultSmallFont;
  FFontConfig.Left := Self.Left + PCCLIName.Left;
  FFontConfig.Top  := Self.Top  + PCCLIName.Top + PCCLIName.Height;
  FFontConfig.Font := CCLIFont;

  FFontConfig.ShowModal;

  CCLIFont := FFontConfig.Font;
  UpdateFontInfo( CCLIFont, PCCLIName, LCCFontsize,
                  PCCBold, PCCItalic, PCCCol,
                  LCCBold, LCCItalic );

end;

procedure TFSettings.ebMinLyricSearchChange(Sender: TObject);
var Code : integer;
begin
  Val( ebMinLyricSearch.Text, iMinSearchLyrics, Code );
  if iMinSearchLyrics > 10 then begin
    iMinSearchLyrics := 10; ebMinLyricSearch.Text := '10';
  end;
end;

procedure TFSettings.cbSearchLyricsClick(Sender: TObject);
begin
  ebMinLyricSearch.Enabled := not ebMinLyricSearch.Enabled;
end;

procedure TFSettings.lbBGImagesClick(Sender: TObject);
begin
  if clInactiveCaption = lbBGImages.Font.Color then bAddBG.Click;
end;

procedure TFSettings.bAddBGClick(Sender: TObject);
var hOpOpts : TOpenOptions;
begin
  hOpOpts := FileOpenPicture.Options;
  if clInactiveCaption = lbBGImages.Font.Color then lbBGImages.Items.Clear;
  FileOpenPicture.Options := FileOpenPicture.Options + [ofAllowMultiSelect];
  if FileOpenPicture.Execute then begin
    // Load the image immediately
    lbBGImages.Items.AddStrings( FileOpenPicture.Files );
    lbBGImages.Font.Color := clWindowText;
    cbBGOrder.Enabled := true;
    if 0 = cbBGOrder.ItemIndex then cbBGOrder.ItemIndex := 1;
  end;
  if 0 = lbBGImages.Items.Count then bRemoveBG.Click;
  FileOpenPicture.Options := hOpOpts;
end;

procedure TFSettings.bRemoveBGClick(Sender: TObject);
begin
  lbBGImages.DeleteSelected;
  if 0 = lbBGImages.Items.Count then begin
    lbBGImages.Font.Color := clInactiveCaption;
    lbBGImages.Items.Add('Click to add a list of images');
    cbBGOrder.Enabled := false;
  end;
end;

function TFSettings.GetNextBackground( sLast : string; bNewSong : boolean; iPage : integer ): string;
var iNext : integer;
    iRnd  : integer;
    sRes  : string;
begin
  sRes := sLast;
  dec(iPage);
  if iPage < 0 then iPage := 0;

  // (Get random value if needed)
  if (1 = cbBGOrder.ItemIndex) or
     ( bNewSong and (2 = cbBGOrder.ItemIndex)) then begin
    repeat
      iRnd := round( random(lbBGImages.Count) );
      if iRnd >= lbBGImages.Count then iRnd := lbBGImages.Count-1;

      // Random (each Page) - IMPROVE: only update when page or state changes
      sRes := lbBGImages.Items.Strings[iRnd];

      // Repeat
      if lbBGImages.Count <= 1 then break;
    until (sRes <> sLast);
  end;

  // Cycle (per page in song)
  if (3 = cbBGOrder.ItemIndex) then begin
    iPage := iPage mod lbBGImages.Count;
    sRes := lbBGImages.Items.Strings[iPage];
  end;

  // Cycles - firstly 'per page' OR 'per song'
  if (cbBGOrder.ItemIndex = 4) or
     ( bNewSong and (cbBGOrder.ItemIndex = 5) ) then begin
    iNext := lbBGImages.Items.IndexOf( sLast ) +1;
    if iNext >= lbBGImages.Items.Count then iNext := 0;
    sRes := lbBGImages.Items.Strings[iNext];
  end;

  Result := sRes;
end;



procedure TFSettings.lbBGImagesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if clInactiveCaption = lbBGImages.Font.Color then bAddBG.Click;
end;

procedure TFSettings.BBlankImgClick(Sender: TObject);
begin
  if FileOpenPicture.Execute then begin
    cbBlankImg.Checked := true;
    EBlankImg.Text    := FileOpenPicture.FileName;
  end;
end;

end.
