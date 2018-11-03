unit SBMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ComCtrls, AxCtrls, OleCtrls, vcf1, ComObj, ExtCtrls, SBZipUtils,
  SBFiles, Buttons, Grids, MultiMon, FileCtrl, SongList, VideoStreamer,
  IdBaseComponent, IdComponent, IdTCPServer, IdCustomHTTPServer,
  IdHTTPServer, IdTCPConnection, IdTCPClient, IdHTTP, SyncObjs;

type
  TFSongbase = class(TForm)

    LTitle: TLabel;
    ETitle : TEdit;
    FileOpen: TOpenDialog;
    MainMenu1: TMainMenu;
    Database1: TMenuItem;
    Song1: TMenuItem;
    Tools1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    N1: TMenuItem;
    SaveAs1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Exit1: TMenuItem;
    AddNewSong1: TMenuItem;
    SaveChanges1: TMenuItem;
    DeleteThisSong1: TMenuItem;
    N4: TMenuItem;
    Find1: TMenuItem;
    N5: TMenuItem;
    NextSong1: TMenuItem;
    PreviousSong1: TMenuItem;
    ResetUsage1: TMenuItem;
    N6: TMenuItem;
    AutoCompletion1: TMenuItem;
    ClearHistory1: TMenuItem;
    RecreateHistory1: TMenuItem;
    SaveDialog1: TSaveDialog;
    LAuthor: TLabel;
    EAuthor: TEdit;
    EID: TEdit;
    PrinterSetupDialog1: TPrinterSetupDialog;
    ImportSongs1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Settings1: TMenuItem;
    Global1: TMenuItem;
    TitleSearch: TMenuItem;
    EAltTitle: TEdit;
    LATitle: TLabel;
    N7: TMenuItem;
    RebuildFastSearch1: TMenuItem;
    ESongbaseID: TEdit;
    LKeyShortcut: TLabel;
    EOrder: TEdit;
    BDelOrder: TButton;
    BSaveOrder: TButton;
    CBSC: TComboBox;
    BEarlier: TButton;
    BLater: TButton;
    BProjNow: TButton;
    LBOrders: TListBox;
    POrder: TGroupBox;
    PSongInfo: TGroupBox;
    PSongScroll: TPanel;
    SBRecNo: TScrollBar;
    BTitleSearch: TBitBtn;
    BTextSearch: TBitBtn;
    PSongWords: TPanel;
    BEditSong: TButton;
    StringGrid1: TStringGrid;
    BRemFromOrder: TButton;
    BDropDownOrders: TBitBtn;
    POrderSelect: TPanel;
    POrderItems: TPanel;
    POrderItemButtons: TPanel;
    BNewOrder: TButton;
    ImgMultiMon: TImage;
    BAddToOrder: TButton;
    BExpandPanel: TBitBtn;
    PHides: TPanel;
    PSaved: TPanel;
    LUnsaved: TLabel;
    LRec: TLabel;
    LCopyright: TLabel;
    ECopyright: TEdit;
    LCopDate: TLabel;
    ECopDate: TEdit;
    LOfficeNo: TLabel;
    EOfficeNo: TEdit;
    COHP: TCheckBox;
    CTrans: TCheckBox;
    CSheet: TCheckBox;
    CRec: TCheckBox;
    GBUsedBy: TGroupBox;
    SBInfo: TStatusBar;
    BMoreInfo : TButton;
    Help2: TMenuItem;
    N8: TMenuItem;
    BTitleSearchMulti: TBitBtn;
    AddMultipleSongs1: TMenuItem;
    ExportCCLIasCSV1: TMenuItem;
    ExportSong1: TMenuItem;
    N9: TMenuItem;
    Showallsongs1: TMenuItem;
    N10: TMenuItem;
    MRunNetwork: TMenuItem;
    IdHTTPServer2: TIdHTTPServer;
    MUpdate: TMenuItem;
    IdHTTP: TIdHTTP;
    procedure BuildOrderList;
    procedure Exit1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure SBRecNoChange(Sender: TObject);
    procedure ActualSBRecNoChange(from_web : boolean);
    procedure ETitleChange(Sender: TObject);
    procedure NextSong1Click(Sender: TObject);
    procedure PreviousSong1Click(Sender: TObject);
    procedure EAuthorChange(Sender: TObject);
    procedure ECopyrightChange(Sender: TObject);
    procedure ECopDateChange(Sender: TObject);
    procedure EOfficeNoChange(Sender: TObject);
    procedure COHPClick(Sender: TObject);
    procedure CSheetClick(Sender: TObject);
    procedure CRecClick(Sender: TObject);
    procedure AddNewSong1Click(Sender: TObject);
    procedure SaveRec;
    procedure DeleteRec;
    procedure LoadRec(i : integer; from_web : boolean);
    function CheckFileSave : boolean;
    procedure SaveChanges1Click(Sender: TObject);
    procedure DeleteThisSong1Click(Sender: TObject);
    procedure ResetUsage1Click(Sender: TObject);
    procedure ResetAll;
    procedure ClearHistory1Click(Sender: TObject);
    procedure AddToHistory(H : string; F : string);
    procedure AddPhotoToHistory(B,ISBN : string; F : string);
    procedure AutoCompletion1Click(Sender: TObject);
    procedure LookupHistory(Orig : string; var N : string; F : string);
    procedure LookupPhotoHistory(Orig : string; var S,I : string; F : string);
    procedure ECopyrightKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EAuthorKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CountRecs;
    procedure RecreateHistory1Click(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Ready;
    procedure NotReady;
    function CountAndReturn(St : string) : integer;
    procedure BEditOHPClick(Sender: TObject);
    procedure GetID;
    procedure GetOrder(I : integer);
    procedure UpdateOrderButtons;
    procedure ShowOrder(S : string);
    function  AddItemToOrder( ID : string; bSelect : boolean = false ) : string;
    procedure EOrderExit(Sender: TObject);
    procedure BNewOrderClick(Sender: TObject);
    procedure BSaveOrderClick(Sender: TObject);
    procedure BAddToOrderClick(Sender: TObject);
    procedure BRemFromOrderClick(Sender: TObject);
    procedure BDelOrderClick(Sender: TObject);
    function StringSC(A,B : word) : string;
    procedure BProjNowClick(Sender: TObject);
    function NextShortCut : integer;
    function ShortCutInUse(i : integer) : boolean;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
//    procedure bGlobProjClick(Sender: TObject);
    procedure Clicked_1(Sender: TObject);
    procedure Clicked_2(Sender: TObject);
    procedure Clicked_3(Sender: TObject);
    procedure Clicked_4(Sender: TObject);
    procedure TryOpen(Sender : TObject);
    procedure CPhotoClick(Sender: TObject);
    procedure EMusChange(Sender: TObject);
    procedure EISBNChange(Sender: TObject);
    procedure ETuneChange(Sender: TObject);
    procedure EArrChange(Sender: TObject);
    procedure CCapoChange(Sender: TObject);
    procedure ECop1Change(Sender: TObject);
    procedure CKeyChange(Sender: TObject);
    procedure CMMChange(Sender: TObject);
    procedure ECop2Change(Sender: TObject);
    procedure ENotesChange(Sender: TObject);
    procedure ECopyrightExit(Sender: TObject);
    procedure ECopDateExit(Sender: TObject);
    procedure EAuthorExit(Sender: TObject);
    procedure ImportSongs1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Global1Click(Sender: TObject);
    procedure BEarlierClick(Sender: TObject);
    procedure BLaterClick(Sender: TObject);
    procedure BPrintOrderClick(Sender: TObject);
    function squash(a : string) : string;
    procedure TitleSearchClick(Sender: TObject);
    procedure MultiTitleSearchClick(Sender: TObject);
    procedure EAltTitleChange(Sender: TObject);
    procedure CTransClick(Sender: TObject);
    procedure RebuildFastSearch1Click(Sender: TObject);
    procedure CBSCClick(Sender: TObject);
    procedure RemoveFromOrders(ID : string);
    procedure LBOrdersClick(Sender: TObject);
    procedure EOrderKeyPress(Sender: TObject; var Key: Char);
    procedure BProjectSongClick(Sender: TObject);
    procedure CurrentSongIsReadable( bReadable : boolean );
    procedure BEditSongClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BTextSearchClick(Sender: TObject);
    procedure BTitleSearchClick(Sender: TObject);
    procedure BTitleSearchMultiClick(Sender: TObject);
    procedure BMoreInfoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BDropDownOrdersClick(Sender: TObject);
    procedure POrderItemsExit(Sender: TObject);
    procedure POrderClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BExpandPanelClick(Sender: TObject);
    procedure BPreviewHidClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Help2Click(Sender: TObject);
    procedure CleanUpDatabase;
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function CurrentlyEditing : boolean;
    procedure FormDestroy(Sender: TObject);
    procedure ExportCCLIasCSV1Click(Sender: TObject);
    procedure PreviewID( ID : string );
    procedure ExportSong1Click(Sender: TObject);
    procedure rescaleOffsets( szOldSize, szNewSize : size );
    procedure SetImageSize( hOwner : TComponent; var hImg : TImage; iWidth, iHeight : integer );
    procedure ChangeResolution( szNewSize : size );
    procedure Showallsongs1Click(Sender: TObject);
    procedure MRunNetworkClick(Sender: TObject);
    procedure ChangeList(force : boolean; from_web : boolean);
    procedure StringGridUpdated(aRow : integer);
    procedure MUpdateClick(Sender: TObject);
    procedure downloadFile(remoteFile, localFile : string);

  private
    { Private declarations }
    SelectCellEnabled : boolean;

    // Used to keep this window off the projection screen
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure WMWindowPosChanging(var hMsg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure LoadRecentDatabase( Sender : TObject; iItem : integer );
    function  OrderContainsSong( ID : string ) : boolean;
    function  NextEditable( iDiff : integer ) : TWinControl;
    function  FilterString( sTitle, sSearch : string ) : string;

  public
    IgnoreKey         : boolean;
    BProjectReady     : boolean;
    szPreviewSize     : size;
    szLiveSize        : size;
    CurrentOrderIndex : integer;
    bMultiMonitor     : boolean;
    bMultiMonConfig   : boolean;
    bMultiMonCapable  : boolean;
    bProjectHints     : boolean;
    ptDisplayOrigin   : TPoint;
    szDisplaySize     : size;
    szMultiMonSize    : size;
    EditingSong       : boolean;
    EnableLogging     : boolean;
    LogFile           : string;
    EditableControls  : array of TEdit;
    MemStream         : TMemoryStream;
    bDisableEvents    : boolean;
    currentPageButtons : String;
    disableStringSelect : boolean;
    sync_s : string;
    //web_lock : TCriticalSection;

    // Where to project Text/CCLI/Copyright info
    rTextArea, rCCLIArea, rCopyArea : TRect;    


    SSaveChanges, SEditSong       : string;
    SSaveHint,    SEditHint       : string;
    SExpandPanel, SShrinkPanel    : string;
    SProjNowText, SBlankText      : string;
    SProjNowHint, SBlankHint      : string;
    SVersionStr,  STitleStr       : string;
    SShift, SCtrl, SAlt           : string;
    SValidateCache, SSure         : string;
    SValidateUpdate, SSaveUnsaved : string;
    SCheckDelete, SCheckReset     : string;
    SCheckDumpAuto, SBuildQS      : string;
    SStopProjCap, SStopProjTxt, SBGFilter : string;
    ProjectScreen, DefaultScreen  : integer;

    function before(a,b : string) : boolean;
    procedure EditOHPPage( Page : integer );
    procedure ProjectSong( ID : string; Page : integer; from_webserver : boolean);
    procedure OrderAddString( sStr : string; iKey : integer; iMod : integer );
    procedure OrderItemsSize;
    procedure ApplicationSettingChanged(Sender: TObject; Flag: Integer; const Section: string; var Result: Longint);
    procedure SetMultiMonitor( bMultiMon : boolean; iMonitorCount : integer );
    procedure SetPanelStateExpanded( bExpanded : boolean );
    function  LoadUnzippedRTF( hRichEdit : TRichEdit; sZIP, sFile : string ) : boolean;
    function  EnsureTemporaryDirectory : boolean;
    function  GetMonitorNum( hm : HMONITOR ) : integer;
    procedure RenderSearchText( hCanvas : TCanvas; x, y : integer; hFont : TFont;
                                hFG : TColor = clWhite; hHL :TColor = clYellow );
    { Public declarations }
  end;


  // My version information

const VERSION_INTERNAL = 44;
      VERSION_NAME  = '3.7.0';
      VERSION_DATE = '03/11/2018';

  // The minimum version of Viewer that I *can* work with:-

      VIEWER_INTERNAL_REQUIRED = 17;
      VIEWER_NAME_REQUIRED = '1.7';

  // The version of the Viewer I was packaged with:-

      VIEWER_LATEST = 22;
      VIEWER_NAME_LATEST = '1.12';

  // The minimum version of Android Controller that I *can* work with:-

      ANDROID_INTERNAL_REQUIRED = 2;
      ANDROID_NAME_REQUIRED = '1.0';
      newline = chr(13)+chr(10);
      tab = chr(9);


      {NOTE TO SELF:
      In Songbase.dpr

      Application.CreateForm(TFEditProj, FEditWin);
      Application.CreateForm(TFEditProj, FProjWin);

      Don't let it autochange to TFProjWin or it won't compile}


var
  FSongbase: TFSongbase;
  UnSaved : boolean;
  bNewSong : boolean;
  FileName : string;
  QSFile : string;
  INIFile,AuthFile,CopFile,PhotoFile,OHPFile,Orderfile : string;
  BlankFlag : boolean;
  LastLoaded : integer;
  Cancelling : boolean;
  TotalOrders,OrderNo : integer;
  OrderCurrentSong : string;
  OrderData,OrigOrderName : string;
  LinkNextID : integer;
  LinkDescriptions : string;
  StringClickDisable : boolean;



  RunDir : string;
  LinkFiles : string;
  TempDir : string;
  TempHost : string;
  bSetTemp : boolean;
  bSupressPreview : boolean;
  bLoadingDefault : boolean;
  bPanelExpanded : boolean;
  bIgnoreDoubleClicks : boolean;
  DoubleClickDelay    : integer;
  function MultiMonEnumCallback(hm: HMONITOR; dc: HDC; r: PRect; l: LPARAM): Boolean; stdcall;

const
  END_MENU = 11;
  chr128 = chr(128);
  chr129 = chr(129);
  MAX_ORDER_HEIGHT = 160;
  APPNAME = 'Songbase';

implementation

uses PrintSelect, Search, EditProj, Appear, Import, Export, About,
  PrintSongList, TitleSearch, OHPPrint, LinkForm, LinkDesc,
  Tools, PreviewWindow, SongDetails, SearchResults, InfoBox, Math, ShellAPI,
  HelpWindow, FontConfig, StrUtils, PageCache, DateUtils, International, Network,
  WebServer, update, NetSetup;

{$R *.DFM}



procedure TFSongbase.UpdateOrderButtons;
var L,S : string;
    B : boolean;
begin
  S:=OrderData;
  LogThis( 'Updating Order: ' + S );
//  BPrintOrder.Enabled:=(OrderData<>'') and (OrderNo>0);
  B:=EOrder.Text<>'';
  if B then while (S<>'') and B do begin
     L:=copy(S,1,pos(chr128,S)-1);
     if L=EID.Text then B:=false;
     S:=copy(S,pos(chr128,S)+1,length(S));
     S:=copy(S,pos(chr128,S)+1,length(S));
  end;
  BRemFromOrder.Enabled:=(CurrentOrderIndex<>-1);
  BDelOrder.Enabled:=(EOrder.Text<>'');
  BSaveOrder.Enabled:=BDelOrder.Enabled;
  EOrder.Enabled:=BDelOrder.Enabled;
  if EOrder.Enabled then begin
    EOrder.Color := clWindow;
    EOrder.Hint := '';
    EOrder.ParentShowHint := true;
  end else begin
    EOrder.Color := clBtnFace;
    POrderSelect.Hint := 'Click "New" or select a previous songlist';
    EOrder.ParentShowHint := false;
  end;
  POrderSelect.Color := EOrder.Color;
  CBSC.Enabled:=(CurrentOrderIndex<>-1);
  if CBSC.Enabled then begin
    CBSC.Color := clWindow;
  end else begin
    CBSC.Color := clBtnFace;
    CBSC.ItemIndex := -1;
  end;
  BLater.Enabled:=(CurrentOrderIndex<StringGrid1.RowCount-1) and (CurrentOrderIndex<>-1);
  BEarlier.Enabled:=(CurrentOrderIndex>0);
  LKeyShortcut.Enabled:=(CurrentOrderIndex<>-1);
  LogThis( 'Updated Order' );
end;

function TFSongbase.NextShortCut : integer;
var S,K,Got : String;
    I,Code : integer;
    A,B : Word;
    C : boolean;
begin
  i:=1;
  repeat
    inc(i);
    Got:=CBSC.Items.Strings[i];
    C:=false;
    S:=OrderData;
    while (S<>'') and (not C) do begin
      S:=copy(S,pos(chr128,S)+1,length(S));
      K:=copy(S,1,pos(chr128,S)-1);
      val(K,A,Code);
      val(copy(K,pos('~',K)+1,length(K)),B,Code);
      if StringSC(A,B)=Got then c:=true;
      S:=copy(S,pos(chr128,S)+1,length(S));
    end;
  until not c;
  NextShortCut:=i;
end;

function TFSongbase.ShortCutInUse(i : integer) : boolean;
var S,K : string;
    C : boolean;
    Code : integer;
    Ct,A,B : word;
begin
  S:=OrderData;
  Ct:=0;
  C:=false;
  while (S<>'') and (not C) do begin
    S:=copy(S,pos(chr128,S)+1,length(S));
    K:=copy(S,1,pos(chr128,S)-1);
    val(K,A,Code);
    val(copy(K,pos('~',K)+1,length(K)),B,Code);
    if (CBSC.Items.IndexOf(StringSC(A,B))=i) and (Ct<>CurrentOrderIndex) then c:=true;
    inc(Ct);
    S:=copy(S,pos(chr128,S)+1,length(S));
  end;
  ShortCutInUse:=c;
end;



procedure TFSongbase.ShowOrder(S : string);
var St,L,K,M : string;
    SR : SongRecord;
    Key, Code, Modifier : integer;
    CanSelect : boolean;

begin
  St:=S;

  StringGrid1.DefaultDrawing := false;
  StringGrid1.RowCount := 1;
  StringGrid1.Color := clBtnFace;
  StringGrid1.Options := [];
  CBSC.Enabled := false;
  CBSC.Color := clBtnFace;
  CanSelect := bSupressPreview;
  bSupressPreview := true;
  CBSC.ItemIndex := -1;
  StringGrid1.Canvas.Brush.Color := clBtnFace;
  StringGrid1.Canvas.FillRect( StringGrid1.ClientRect );
  sr.id:='';
  while ST<>'' do begin
    // Get the song title and the shortcut info...
    L:=copy(St,1,pos(chr128,St)-1);
    M:=copy(St,pos(chr128,St)+1,length(St));
    K:=copy(M,1,pos(chr128,M)-1);
    val(K,Modifier,Code);
    val(copy(K,pos('~',K)+1,length(K)),Key,Code);

    // Get the song title for the selected item.
    disableStringSelect:=true;
    OrderAddString( PageCache_GetSongName( L ), Key, Modifier);
    disableStringSelect:=false;

    // and select the next item
    St:=copy(St,pos(chr128,St)+1,length(St));
    L:=copy(St,1,pos(chr128,St)-1);
    St:=copy(St,pos(chr128,St)+1,length(St));
  end;
  bSupressPreview := CanSelect;
  if StringGrid1.DefaultDrawing and (StringGrid1.RowCount > 0) then begin
    if CurrentOrderIndex <0  then CurrentOrderIndex := 0;
    if StringGrid1.DefaultDrawing and (CurrentOrderIndex < StringGrid1.RowCount) then begin
      if CurrentOrderIndex = StringGrid1.Row then
           StringGrid1SelectCell(StringGrid1, 1, CurrentOrderIndex, CanSelect )
      else StringGrid1.Row := CurrentOrderIndex;
    end;
  end
  else if FPreviewWindow.Visible then FPreviewWindow.UpdateArrows;

  // Update the songlist exported by the web server.
end;

procedure TFSongbase.ChangeList(force: boolean; from_web : boolean);
var i : integer;
    S,CL : string;
    listIDSelected : integer;
    songid : integer;
    actualSongCount : integer;

begin
  ListIDSelected:=-1;
  S:=OrderData;
  if ((force) or (FWebServer.isServerEnabled())) then begin
    if (s='') then begin
      CurrentOrderIndex:=-999;
      ListIdSelected:=-999;
    end;

    for i:=0 to CurrentOrderIndex do begin
      ListIdSelected:=StrToInt(copy(s,1,pos(chr128,S)-1));
      S:=copy(S,pos(chr128,S)+1,length(S));
      S:=copy(S,pos(chr128,S)+1,length(S));
    end;

    if (StringGrid1.RowCount=1) and (trim(StringGrid1.Cells[1,0])='') then begin
      CL:='0'+newline;
      actualSongCount:=0;
    end else begin
      CL:=IntToStr(STringGrid1.RowCount)+newline;
      actualSongCount:=StringGrid1.RowCount;
    end;

    if (EID.Text='abc') then songid:=-2
    else songid:=StrToInt(EID.Text);

    if (ListIDSelected=songid) then begin
      CL:=CL+IntToStr(CurrentOrderIndex)+newline;
    end else begin
      CL:=CL+'-1'+newline;
    end;

    // CurrentPageButtons is the 12C bit.
    // 3.5.7 - Add some text about each page.

    CL:=CL+CurrentPageButtons+tab+FWebServer.getFirstLines()+newline;


    for i:=0 to ActualSongCount-1 do begin
      CL:=CL+StringGrid1.Cells[0,i]+'*'+StringGrid1.Cells[1,i]+newline;
    end;
    if (ListIDSelected<>songid) then begin
      CL:=CL+'X*'+ETitle.Text;
      if (length(EAltTitle.Text)>1) then begin
        CL:=CL+' ('+EAltTitle.Text+')';
      end;
      CL:=CL+newline;
    end;

    //if (not from_web) then FSongbase.web_lock.Acquire;
    FWebServer.ListText:=CL;
    FWebServer.last_page:=0;
    FWebServer.nextListTicket();
   // if (not from_web) then FSongbase.web_lock.Release;
  end;
end;

procedure TFSongbase.BuildOrderList;
var TF : TextFile;
    S : string;
begin
  LBOrders.Items.Clear;
  TotalOrders:=0;
  if FileExists(OrderFile) then begin
    if OpenForRead(TF,OrderFile) then begin
      while (not eof(TF)) do begin
        readln(TF,S);
        inc(TotalOrders);
        LBOrders.Items.Insert(0,copy(S,pos(chr128,S)+1,length(S)));
        readln(TF,S);
      end;
      CloseTextfile(TF,OrderFile);
    end;
  end;
  CurrentOrderIndex := -1;
  EOrder.Text := '';
  ShowOrder('');
  UpdateOrderButtons;
end;

procedure TFSongbase.GetOrder(I : integer);
var TF : TextFile;
    S : string;
begin
  ShowOrder('');
  TotalOrders:=0;
  OrderNo:=0;
  OrigOrderName:='';
  if OpenForRead(TF,OrderFile) then begin
    while (not eof(TF)) do begin
      readln(TF,S);
      inc(TotalOrders);
      if TotalOrders=I then begin
        OrderNo:=I;
        OrigOrderName:=S;
        readln(TF,S);
        OrderData:=S;
        ShowOrder(OrderData);
      end else begin
        readln(TF,S);
      end;
    end;
    CloseTextfile(TF,OrderFile);
  end;
  EOrder.Text:=copy(OrigOrderName,pos(chr128,origordername)+1,length(OrigOrderName));
  LBOrders.ItemIndex:=LBOrders.Items.Count-I;
  if StringGrid1.DefaultDrawing then CurrentOrderIndex := StringGrid1.Row
  else CurrentOrderIndex := -1;
{  CurrentOrderIndex := ;
  UpdateOrderButtons(I-1);}
end;

procedure TFSongbase.RemoveFromOrders(ID : string);
var TF,TW : TextFile;
    SC_IN,ID_IN,S,S2 : string;
begin
  if not FileExists(OrderFile)  and
     OpenForWrite(TF,OrderFile) then begin
    CloseTextfile(TF,OrderFile);
  end;
  if OpenForRead(TF,OrderFile) then begin
    if OpenForWrite(TW,TempDir+'potato') then begin
      while (not eof(TF)) do begin
        readln(TF,S); writeln(TW,S);
        S2:='';
        readln(TF,S);
        while (pos(chr128,S)<>0) do begin
          ID_IN := copy(S,1,pos(chr128,S)-1);
          S:=copy(S,pos(chr128,S)+1,length(S));
          SC_IN := copy(S,1,pos(chr128,S)-1);
          S:=copy(S,pos(chr128,S)+1,length(S));
          if ID_IN<>ID then S2:=S2+ID_IN+chr128+SC_IN+chr128;
        end;
        writeln(TW,S2);
      end;
      CloseTextfile(TW,TempDir+'potato');
      CloseTextfile(TF,OrderFile);
      erase(TF);
      rename(TW,OrderFile);
    end
    else CloseTextfile(TF,OrderFile);
  end;
  if OrderNo>0 then GetOrder(OrderNo);
end;


function TFSongbase.squash(a : string) : string;
var s,t : string;
    i : integer;
begin
  s:=uppercase(a);
  t:='';
  for i:=1 to length(S) do
    if ((ord(s[i])>=65) and (ord(s[i])<=90)) then t:=t+s[i];
  squash:=t;
end;


function TFSongbase.before(a,b : string) : boolean;
var c,d : string;
begin
  c:=squash(a);
  d:=squash(b);
  if c=copy(d,1,length(c)) then before:=true else
  if d=copy(c,1,length(d)) then before:=false else
  before:=(c<d);
end;

procedure TFSongbase.ResetAll;
  var TF,TF2 : textfile;
      S : string;
      SR : SongRecord;
begin
  PageCache_FlushAll;
  if OpenForRead(TF,FileName) then begin
    if OpenForWrite(TF2,TempDir+'songbase.tmp') then begin
      while not eof(TF) do begin
        readln(Tf,S);
        if length(S)>5 then begin
          Delimit(S,SR);
          SR.OHP:='0'; SR.Sheet:='0'; SR.Rec:='0'; SR.Photo:='0'; SR.Trans:='0';
          Limit(S,SR);
          writeln(TF2,S);
        end;
      end;
      CloseTextfile(TF2,TempDir+'songbase.tmp');
    end;
    CloseTextfile(TF,FileName);
  end;
end;

procedure TFSongbase.LoadRec(i : integer; from_web : boolean);
  var S : string;
      Code : integer;
      SR : SongRecord;
begin
  LogThis( 'Loading Record ' + IntToStr(i) );
  s:='';
  if i <= 0 then Exit;

  if PageCache_GetSongFromIndex( i-1, SR ) then begin
    LastLoaded:=i;
    ETitle.Text:=SR.Title;
    EAltTitle.Text:=SR.AltTitle;
    EAuthor.Text:=SR.Author;
    ECopDate.Text:=SR.CopDate;
    ECopyright.Text:=SR.Copyright;
    EOfficeNo.Text:=SR.OfficeNo;
    EID.Text:=SR.ID;
    bNewSong := false;
    ESongbaseID.Text:=SR.UniqueID;
    with( FSongDetails) do begin
      EISBN.Text:=SR.ISBN;
      EMus.Text:=SR.MusBook;
      EArr.Text:=SR.Arr;
      ETune.Text:=SR.Tune;
      COHP.Checked:=(SR.OHP='1');
      CSheet.Checked:=(SR.Sheet='1');
      CRec.Checked:=(SR.Rec='1');
      CPhoto.Checked:=(SR.Photo='1');
      CTrans.Checked:=(SR.Trans='1');
      ENotes.TexT:=SR.Notes;
      ECop1.Text:=SR.CL1;
      ECop2.Text:=SR.CL2;
      CKey.ItemIndex:=SR.Key;
      CCapo.ItemIndex:=SR.Capo;
      CTempo.ItemIndex:=SR.Tempo;
      CMM.ItemIndex:=SR.MM;
      LinkNextID:=1;
      LinkDescriptions:='';
      LinkFiles:='';
      LBLinks.Items.Clear;
      if (pos(chr129,SR.Links)>0) then begin
        val(copy(SR.Links,1,pos(chr129,SR.Links)-1),LinkNextID,Code);
        SR.Links:=copy(SR.Links,pos(chr129,SR.Links)+1,length(SR.Links));
        while (pos(chr129,SR.Links)>0) do begin
          LinkDescriptions:=LinkDescriptions+copy(SR.Links,1,pos(chr129,SR.Links)-1)+chr129;
          LBLinks.Items.Add(copy(SR.Links,1,pos(chr129,SR.Links)-1));
          SR.Links:=copy(SR.Links,pos(chr129,SR.Links)+1,length(SR.Links));
          if pos(chr129,SR.Links)>0 then LinkFiles:=LinkFiles+copy(SR.Links,1,pos(chr129,SR.Links)-1)+chr(129)
          else LinkFiles:=LinkFiles+SR.Links;
          SR.Links:=copy(SR.Links,pos(chr129,SR.Links)+1,length(SR.Links));
        end;
      end;
    end;

    BlankFlag:=false;
    UnSaved:=false; LUnsaved.Visible:=false;
    SaveChanges1.Enabled:=false;
//    Result:=S;

    // Set the 'hint' values for the items which are read-only
    CurrentSongIsReadable( false );

    LogThis( 'Record Loaded ' + SR.ID );

    // Try loading the current song into the preview window
    if not bSupressPreview then begin
      FPreviewWindow.LoadOHP( SR.ID, 1 );
      ChangeList(false, from_web);
      LogThis( 'Preview Window updated ' + SR.ID );
    end;
  end;
end;

function TFSongbase.CountAndReturn(St : string) : integer;
  var Count : integer;
      S : string;
      R,Min,Max : integer;

begin
  LogThis( 'Counting records' );

  PageCache_EnsureID( St, R );
  Count := PageCache_GetSongCount;

{  Count:=0; R:=0;
  if OpenForRead(TF,FileName) then begin
    while not eof(TF) do begin
      readln(TF,S);
      if (length(S)>3) then inc(Count);
      if S=St then R:=Count;
    end;
    CloseTextfile(TF,FileName);
  end;}

  if Count>=1 then Min:=1 else Min:=0;
  max:=Count;
  SBRecNo.SetParams(SBRecNo.Position,Min,Max);
  SBRecNo.LargeChange:=(Count div 10)+1;
  SBRecNo.SmallChange:=1;
  str(SbRecNo.Position,S);
  LRec.Caption:=S+'/';
  str(SbRecNo.Max,S);
  LRec.Caption:=LRec.Caption+S;
  CountAndReturn:=R + 1;
  LogThis( 'Counted records: ' + IntToStr(R) );
end;

procedure TFSongbase.CountRecs;
  var Count : integer;
      S : string;
      iMin,iMax : integer;
begin
  LogThis( 'Counting recs in ' + FileName );

{  Count:=0;
  if OpenForRead(TF,FileName) then begin
    while not eof(TF) do begin
      readln(TF,S);
      if (length(S)>3) then inc(Count);
    end;
    CloseTextfile(TF,FileName);
  end;}

  Count := PageCache_GetSongCount;
  iMin := min( 1, Count );
  iMax := Count;

  SBRecNo.SetParams(SBRecNo.Position,iMin,iMax);
  SBRecNo.LargeChange:=(Count div 10)+1;
  SBRecNo.SmallChange:=1;
  str(SbRecNo.Position,S);
  LRec.Caption:=S+'/';
  str(SbRecNo.Max,S);
  LRec.Caption:=LRec.Caption+S;

  LogThis( 'Preparing projection windows' );

  FProjWin.PrepareWindow;
  FEditWin.PrepareWindow;

  LogThis( 'Counted records ' + FileName );
end;

procedure TFSongbase.DeleteRec;
  var TFSH,BFSH : textfile;
  var TSDB,BSDB : textfile;
      Count : integer;
      Delled : boolean;
      S, sSrcLine : string;
begin
  Count:=0;
  if MessageDlg(SSure, mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    if bNewSong then begin
      // If it's just a new song, then it hasn't been added to the catalogue yet,
      // just select the next song and surpress the 'save it' request
      // THIS SHOULD NEVER GET CALLED!
      MessageDlg( 'Oi!', mtConfirmation, [mbYes, mbNo], 0);
      Exit;
    end;
    Delled:=false;

    // Get the currently loaded line from the SDB, and then throw away
    // everything that we ever knew about this song...
    sSrcLine := PageCache_GetSrcLine( EID.Text );
    PageCache_FlushID( EID.Text );

    // First, process the fsh file
    if not OpenForRead(TFSH,QSFile)      then Exit;
    if not OpenForWrite(BFSH,TempDir+'temp.fsh') then begin
      CloseTextfile(TFSH,QSFile);
      Exit;
    end;

    while not eof(TFSH) do begin
      readln(TFSH,S);
      if copy(S,1,pos('~',S)-1)<>EID.Text then writeln(BFSH,S);
    end;
    CloseTextfile(TFSH,QSFile);
    CloseTextfile(BFSH,TempDir+'temp.fsh');

    // Now the sdb file
    if not OpenForRead(TSDB,FileName) then begin
      erase(BFSH);
      Exit;
    end;
    if not OpenForWrite(BSDB,TempDir+'temp.sdb') then begin
      CloseTextfile(TSDB,FileName);
      erase(BFSH);
      Exit;
    end;

    while not eof(TSDB) do begin
      readln(TSDB,S);
      if not Delled then inc(Count);
      if (S<>sSrcLine) then begin writeln(BSDB,S); end;
      if S=sSrcLine then Delled:=true;
    end;
    CloseTextfile(TSDB,FileName);
    CloseTextfile(BSDB,TempDir+'temp.sdb');

    // Done, we can now overwrite the current files with the new ones.
    erase(TFSH);
    rename(BFSH,QSFile);
    erase(TSDB);
    rename(BSDB,FileName);
    DeleteFileFromZip(OHPFile,EID.Text+'.ohp');
    DeleteFileFromZip(OHPFile,EID.Text+'-*.rtf');

    RemoveFromOrders(EID.Text);
    if FSearchResults.Visible then FSearchResults.RemoveFromResults(Count);
    if FSongList.Visible then FSongList.RemoveFromResults(Count);

    // And reload
    PageCache_FlushAll;
    if Count>=1 then dec(Count);
    CountRecs;
    if Count>SBRecNo.Max then Count:=SBRecNo.Max;
    if SBRecNo.Max>0 then begin
      if Count<SBRecNo.Max then LoadRec(Count+1,false) else LoadRec(Count,false);
      DeleteThisSong1.Enabled:=true;
      FSongDetails.BAddLink.Enabled:=true;
    end else begin NotReady; AddNewSong1.Enabled:=true; end;
  end;
end;

procedure TFSongbase.SaveRec;
  var T : string;
      TF,BF : textfile;
      S, sSrcLine : string;
      Written : boolean;
      Count : integer;
      SR : SongRecord;
begin
  SR.Id:=Trim( EID.Text );
  LogThis( 'Saving record ' + SR.ID );
  SR.Title:=Trim( ETitle.Text );
  SR.UniqueID:=Trim( ESongbaseID.Text );
  SR.Author:=Trim( EAuthor.Text );
  SR.AltTitle:=Trim( EAltTitle.Text );
  SR.CopDate:=Trim( ECopDate.Text );
  SR.CopyRight:=Trim( ECopyRight.text );
  SR.OfficeNo:=Trim( EOfficeNo.text );
  AddToHistory(SR.CopyRight,CopFile);
  AddToHistory(SR.Author,AuthFile);
  with FSongDetails do begin
    SR.ISBN:=Trim( EISBN.Text );
    SR.Tune:=Trim( ETune.Text );
    SR.MusBook:=Trim( EMus.Text );
    SR.Arr:=Trim( EArr.Text );
    SR.Key:=CKey.ItemIndex;
    SR.Capo:=CCapo.ItemIndex;
    SR.MM:=CMM.ItemIndex;
    SR.Tempo:=CTempo.ItemIndex;
    SR.Cl1:=Trim( ECop1.Text );
    SR.CL2:=Trim( ECop2.Text );
    SR.NoteS:=ENotes.Text;
    if CTrans.Checked then SR.Trans:='1' else SR.Trans:='0';
    if COHP.Checked then SR.OHP:='1' else SR.OHP:='0';
    if CSheet.Checked then SR.Sheet:='1' else SR.Sheet:='0';
    if CRec.Checked then SR.Rec:='1' else SR.Rec:='0';
    if CPhoto.Checked then SR.Photo:='1' else SR.Photo:='0';
    str(LinkNextID,SR.Links);
    SR.Links:=SR.Links+chr129;
    s:=LinkDescriptions;
    T:=LinkFiles;
    while (length(s)>0) do begin
      SR.Links:=SR.Links+copy(s,1,pos(chr129,s)-1)+chr129;
      SR.Links:=SR.Links+copy(t,1,pos(chr129,t)-1)+chr129;
      s:=copy(s,pos(chr129,s)+1,length(s));
      t:=copy(t,pos(chr129,t)+1,length(t));
    end;
  end;
  Limit(T,SR);

  // Get previous source line and then forget about this song...
  sSrcLine := PageCache_GetSrcLine( SR.Id );

  if OpenForRead(TF,FileName) then begin
    if OpenForWrite(BF,TempDir+'songbase.tmp') then begin
      Written:=false;
      while not eof(TF) do begin
        readln(TF,S);
        if Before(T,S) and (Not Written) then begin writeln(BF,T); Written:=true; end;
        if (S<>sSrcLine) or (BlankFlag) then writeln(BF,S);
      end;
      if not Written then writeln(BF,T);
      CloseTextfile(TF,FileName);
      CloseTextfile(BF,TempDir+'songbase.tmp');
      erase(TF);
      rename(BF,FileName);
    end
    else CloseTextfile(TF,FileName);
  end;
  UnSaved:=false; LUnsaved.Visible:=false;
  DeleteThisSong1.Enabled:=true;
  FSongDetails.BAddLink.Enabled:=true;
  if bNewSong then PageCache_FlushAll
              else PageCache_ForceReload( SR.Id );
  bNewSong := false;
  PageCache_UpdateSR( SR );
  Count:=CountAndReturn(SR.ID);
  if SBRecNo.Max>=1 then begin
    Ready;
    LoadRec(Count,false);
    SBRecNo.Position:=Count;
    str(SbRecNo.Position,S);
    LRec.Caption:=S+'/';
    str(SbRecNo.Max,S);
    LRec.Caption:=LRec.Caption+S;
    UnSaved:=false; LUnsaved.visible:=false;

    // WHY Update the FastSearch here? It's only needed if SR.ID changes
//    UpdateFSH(SR.ID,OHPFile,QSFile);
  end;

  LogThis( 'Record saved: ' + SR.ID );

  // Update the songlist if this song is in it.
  if (OrderData <> '') and OrderContainsSong( SR.ID ) then begin
    Count := StringGrid1.Row;
    SelectCellEnabled := false;
    ShowOrder(OrderData);
    StringGrid1.Row := Count;
    SelectCellEnabled := true;
  end;

  if FSongList.Visible then FSongList.UpdateRow( SBRecNo.Position );
end;


procedure TFSongbase.Exit1Click(Sender: TObject);
begin
  if CheckFileSave then close;
end;

procedure TFSongbase.LookupPhotoHistory(Orig : string; var S,I : string; F : string);
  var TF : TextFile;
      FoundS,FoundI,St : string;
begin
  FoundS:=''; FoundI:='';
  if FileExists(F) and OpenForRead(TF,F) then begin
    while not (eof(TF) or (FoundS<>'')) do begin
      readln(TF,St);
      if Uppercase(Copy(St,1,length(Orig)))=Uppercase(Orig) then begin FoundS:=copy(St,1,pos('~',St)-1); FoundI:=copy(St,pos('~',St)+1,lengtH(St)); end;
    end;
    CloseTextfile(TF,F);
  end;
  S:=FoundS;
  I:=FoundI;
end;

procedure TFSongbase.LookupHistory(Orig : string; var N : string; F : string);
  var TF : TextFile;
      S : string;
      Found : string;
begin
  Found:='';
  if FileExists(F) and OpenForRead(TF,F) then begin
    while not (eof(TF) or (Found<>'')) do begin
      readln(TF,S);
      if Uppercase(Copy(S,1,length(Orig)))=Uppercase(Orig) then Found:=S;
    end;
    CloseTextfile(TF,F);
  end;
  N:=Found;
end;


procedure TFSongbase.AddPhotoToHistory(B,ISBN : string; F : string);
  var TF,TF2 : TextFile;
      S : string;
      Written,Found : boolean;
      F2 : string;
begin
  F2:=copy(F,1,pos('.',F))+'tmp';
  if not FileExists(F) and OpenForWrite(Tf,F) then begin CloseTextfile(Tf,F); end;
  if (lengtH(B)>2) then begin
    if not OpenForRead(TF,F) then Exit;
    if not OpenForWrite(TF2,F2) then begin CloseTextfile(TF,F); Exit; end;
    Found:=false;
    while not eof(TF) do begin
      readln(TF,S);
      if S=B+'~'+ISBN then begin writeln(TF2,S); Found:=true; end;
      if (copy(S,1,pos('~',S)-1)=B) and (copy(S,pos('~',S)+1,length(S))<>ISBN) then begin
        writeln(TF2,B+'~'+ISBN); Found:=true;
      end;
    end;
    CloseTextfile(TF,F);
    CloseTextfile(TF2,F2);
    if not Found then begin
      Written:=false;
      if not OpenForRead(TF,F) then Exit;
      if not OpenForWrite(TF2,F2) then begin CloseTextfile(TF,F); Exit; end;
      while not eof(TF) do begin
        readln(TF,S);
        if (length(copy(S,1,pos('~',S)-1))>=length(B)) and (not Written) then begin writeln(TF2,B+'~'+ISBN); Written:=true; end;
        if (length(copy(S,1,pos('~',S)-1))>3) then writeln(TF2,S);
      end;
      if not Written then begin writeln(TF2,B+'~'+ISBN); end;
      CloseTextfile(TF,F);
      CloseTextfile(TF2,F2);
      erase(TF);
      rename(TF2,F);
    end;
  end;
end;

procedure TFSongbase.AddToHistory(H : string; F : string);
  var TF,TF2 : TextFile;
      S : string;
      Written,Found : boolean;
      F2 : string;
begin
  // Create the file if it doesn't already exist
  if not FileExists(F) and OpenForWrite(Tf,F) then CloseTextfile(Tf,F);

  // Then open it for reading
  if not OpenForRead(TF,F) then Exit;
  Found:=false;
  while not eof(TF) do begin
    readln(TF,S);
    if S=H then Found:=true;
  end;
  CloseTextfile(TF,F);

  if not Found then begin
    Written:=false;
    F2:=copy(F,1,pos('.',F))+'tmp';
    if not OpenForRead(TF,F)    then Exit;
    if not OpenForWrite(TF2,F2) then begin CloseTextfile(TF,F); Exit; end;
    while not eof(TF) do begin
      readln(TF,S);
      if (length(S)>=length(H)) and (not Written) then begin writeln(TF2,H); Written:=true; end;
      if length(S)>3 then writeln(TF2,S);
    end;
    if not Written then begin writeln(TF2,H); end;
    CloseTextfile(TF,F);
    CloseTextfile(TF2,F2);
    erase(TF);
    rename(TF2,F);
  end;
end;


function TFSongbase.CheckFileSave : boolean;
var w : word;
begin
  CheckFileSave:=false;
  if not UnSaved then CheckFileSave:=true;
  if UnSaved then begin
    w:=MessageDlg(SSaveUnsaved, mtConfirmation, [mbYes, mbNo, mbCancel], 0);
    if (w=mrYes) then begin SaveRec; UnSaved:=false; CheckFileSave:=true; end;
    if (w=mrNo) then begin UnSAved:=false; CheckFileSave:=true; end;
    if (w=mrCancel) then CheckFileSave:=false;
    LUnsaved.Visible:=Unsaved;
  end;
end;


procedure TFSongbase.TryOpen(Sender : TObject);
var S,FN : string;
    TMI : TMenuItem;
begin
  LogThis( 'Opening catalogue file ' + Filename );

  // Prevent any new pages in the current song being shown, as it
  // may be from an old catalogue
  FProjWin.CurrentSong := '';
  FProjWin.CurrentPage := -1;
  FProjWin.GID         := '';
  FProjWin.Pages       := 0;

  // Discard the previous database, and deselect the current preview item
  PageCache_FlushAll;
  if FPreviewWindow.Visible then FPreviewWindow.LoadOHP( '', -1 );

  NotReady;
  S:=FileName;
  while S[length(S)]<>'.' do S:=copy(S,1,length(S)-1);
  OHPFile:=S+'ohp';
  QSFile:=S+'fsh';
  OrderFile:=S+'sor';
  PageCache_ValidateOHPFile( OHPFile, TempDir );

  UnSaved:=false; LUnsaved.Visible:=false;
  CountRecs;
  UnSaved:=false; LUnsaved.Visible:=false;
  ImportSongs1.Enabled:=true;
  if SBRecNo.Max>=1 then begin
    ExportSong1.Enabled:=true;
    if SBRecNo.Position <> 1 then SBRecNo.Position :=1 // force change
                             else SBRecNoChange(Sender);
    LoadRec(1,false);
    if not FileExists(QSFile) then begin
      messagedlg( SBuildQS, mtConfirmation,[mbOk],0);
      RebuildFastSearch1Click(Sender);
    end;
    Ready;
  end else begin
    FPreviewWindow.LoadOHP( '', 0 );
  end;
  FmtStr( S, STitleStr, [ FileName, APPNAME ] );
  FSongbase.Caption:= S;
  AddNewSong1.EnableD:=true;
  BuildOrderList;

  if DataBase1.Count=END_MENU then begin
    TMI:=TMenuItem.Create(Self);
    TMI.Caption:='-';
    Database1.add(TMI);
    TMI:=TMenuItem.Create(Self);
    TMI.Caption:=FileName;
    TMI.Shortcut:=shortcut(Word('1'),[ssCtrl]);
    TMI.OnClick:=Clicked_1;
    Database1.Add(TMI);
  end else begin
    FN:=DataBase1.Items[END_MENU+1].Caption;
    DeAmp(FN);
    if uppercase(FN)<>uppercase(FileName) then begin
      TMI:=TMenuItem.Create(Self);
      TMI.Caption:=FileName;
      TMI.OnClick:=Clicked_1;
      TMI.Shortcut:=shortcut(Word('1'),[ssCtrl]);
      Database1.Insert(END_MENU+1,TMI);
      if Database1.Count>END_MENU+2 then begin
        Database1.Items[END_MENU+2].OnClick:=Clicked_2;
        Database1.Items[END_MENU+2].ShortCut:=shortcut(Word('2'),[ssCtrl]);
      end;
      if Database1.Count>END_MENU+3 then begin
        Database1.Items[END_MENU+3].OnClick:=Clicked_3;
        Database1.Items[END_MENU+3].ShortCut:=shortcut(Word('3'),[ssCtrl]);
      end;
      if Database1.Count>END_MENU+4 then begin
        Database1.Items[END_MENU+4].OnClick:=Clicked_4;
        Database1.Items[END_MENU+4].ShortCut:=shortcut(Word('4'),[ssCtrl]);
      end;
      while (Database1.Count>END_MENU+5) do Database1.Delete(Database1.Count-1);
    end;
  end;
  ChangeList(false,false);
end;

procedure TFSongbase.Open1Click(Sender: TObject);
begin
  if CheckFileSave then begin
    FileOpen.Filter:='Songbase Files|*.sdb';
    if FileOpen.Execute then begin
      FileName:=FileOpen.FileName;
      TryOpen(Sender);
    end;
  end;
end;

procedure TFSongbase.NotReady;
const
  sROString : string = 'Click "Edit Song" button to make changes to these song details';
begin
  bDisableEvents := true;
  if FSearchResults.Visible then FSearchResults.Hide;
  if FSongList.Visible then FSongList.Hide;
  ETitle.Text:='';
  ESongbaseID.Text:='';
  EAltTitle.Text:='';
  EAuthor.Text:='';
  ECopDate.Text:='';
  ECopyright.Text:='';
  EOfficeNo.Text:='';
  ETitle.Enabled:=false;
  EAltTitle.Enabled:=false;
  EAuthor.Enabled:=false;
  ECopDate.Enabled:=false;
  ECopyright.Enabled:=false;
  EOfficeNo.Enabled:=false;
  LTitle.Enabled:=false;
  LATitle.Enabled:=false;
  LAuthor.Enabled:=false;
  LCopDate.Enabled:=false;
  LCopyRight.Enabled:=false;
  LOfficeNo.Enabled:=false;
  LKeyShortcut.Enabled:=false;

  ETitle.Hint   := sROString; EAltTitle.Hint  := sROString; EAuthor.Hint   := sROString;
  ECopDate.Hint := sROString; ECopyright.Hint := sROString; EOfficeNo.Hint := sROString;
  ETitle.Color     := clBtnFace; EAltTitle.Color := clBtnFace;
  EAuthor.Color    := clBtnFace; ECopDate.Color  := clBtnFace;
  ECopyright.Color := clBtnFace; EOfficeNo.Color := clBtnFace;
  ETitle.Cursor    := crArrow;  EAltTitle.Cursor  := crArrow;  EAuthor.Cursor   := crArrow;
  ECopDate.Cursor  := crArrow;  ECopyright.Cursor := crArrow;  EOfficeNo.Cursor := crArrow;

  with FSongDetails do begin
    EISBN.TexT:='';
    EMus.TexT:='';
    EArr.TexT:='';
    ETune.TexT:='';
    CCapo.ItemIndex:=-1;
    CTempo.ItemIndex:=-1;
    CMM.ItemIndex:=-1;
    CKey.ItemIndex:=-1;
    ECop1.TeXT:='';
    ECop2.TexT:='';
    ENotes.TexT:='';
    CCapo.Enabled:=false;
    CTempo.Enabled:=false;
    CMM.Enabled:=false;
    CKey.Enabled:=false;
    ECop1.Enabled:=false;
    ECop2.Enabled:=false;
    ENotes.Enabled:=false;
    EISBN.Enabled:=false;
    ETune.Enabled:=false;
    EMus.Enabled:=false;
    EArr.Enabled:=false;
    CPhoto.Enabled:=false;
    COHP.Enabled:=false;
    CTrans.Enabled:=false;
    CSheet.Enabled:=false;
    CRec.Enabled:=false;
    COHP.Enabled:=false;
    CTrans.Enabled:=false;
    CSheet.Enabled:=false;
    CRec.Enabled:=false;
    BAddLink.enabled:=false;
    BShowLink.enabled:=false;
    BExtract.enabled:=false;
    BRenLink.enabled:=false;
  end;
  SBRecNo.Enabled:=false;
  PreviousSong1.Enabled:=false;
  NextSong1.Enabled:=false;
  AddNewSong1.Enabled:=false;
  DeleteThisSong1.Enabled:=false;
  SaveChanges1.Enabled:=false;
  ResetUsage1.Enabled:=false;
  RecreateHistory1.Enabled:=false;
  LRec.Visible:=false;
  Find1.Enabled:=false;
  AddMultipleSongs1.Enabled:=false;
  TitleSearch.Enabled:=false;
  SaveAs1.Enabled:=false;
  ImportSongs1.Enabled:=false;
  ExportSong1.Enabled:=false;
  BTitleSearch.Enabled:=false;
  BTextSearch.Enabled:=false;
  BTitleSearchMulti.Enabled:=false;
  BAddToOrder.Enabled := false;
  BEditSong.Enabled := false;
  bDisableEvents := false;
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
begin
  TStrings(Data).Add(LogFont.lfFaceName);
  Result := 1;
end;


procedure TFSongbase.FormShow(Sender: TObject);
var i : integer;
    DC : HDC;
begin
  BProjectReady := true;
  StringGrid1.DefaultDrawing := false;
  StringGrid1.Options := [];
  StringGrid1.Color := clBtnFace;
  StringGrid1.Canvas.Brush.Color := clBtnFace;
  CurrentOrderIndex := -1;

  // Default strings...
  SSaveChanges    := '&Save Changes';      SSaveHint    := '';
  SEditSong       := BEditSong.Caption;    SEditHint    := BEditSong.Hint;
  SExpandPanel    := 'Click to reveal more details about this song';
  SShrinkPanel    := 'Click to hide some details about this song';
  SProjNowText    := BProjNow.Caption;     SProjNowHint := BProjNow.Hint;
  SBlankText      := 'B&lank Screen';      SBlankHint   := 'Blank the Projection screen';
  SVersionStr     := 'Welcome to %s (%s)';
  STitleStr       := '%s - %s';
  SShift          := 'Shift';              SCtrl := 'Ctrl';  SAlt := 'Alt';
	SValidateCache  := 'Please Wait... checking catalogue';
	SValidateUpdate := 'Please Wait... correcting catalogue';
	SSure           := 'Are You Sure?';
  SSaveUnsaved    := 'Unsaved Data on this page. Save it?';
	SCheckDelete    := 'Are you sure you want to delete this file from the archive?';
	SCheckReset     := 'This will reset ALL song usage data. Are you sure?';
	SCheckDumpAuto  := 'This will forget all data used for auto-completion. Are you sure?';
	SBuildQS        := 'Songbase is about to massively accelerate the search process, but it may take a while!! (Only need to do it once)';
  SStopProjCap    := 'Stop Projecting?';
  SStopProjTxt    := 'Are you sure you want to stop projecting?';
  SBGFilter       := 'Images|*.bmp;*.jpg;';

  szPreviewSize.cx := 0;
  szPreviewSize.cy := 0;
  szLiveSize.cx := 0;
  szLiveSize.cy := 0;

  RunDir := GetCurrentDir;
  if RightStr( RunDir, 1 ) <> '/' then RunDir := RunDir + '\'; 
  Inifile:=RunDir+'Songbase.ini';
  AuthFile:=RunDir+'authors.hst';
  CopFile:=RunDir+'copyr.hst';
  PhotoFile:=RunDir+'photo.hst';
  LogFile:=RunDir+'Songbase.log';
  Cancelling:=false;
  BlankFlag:=false;

  // Log file
  if FileExists(LogFile) then DeleteFile( LogFile );
  LogThis( 'Songbase ''' + VERSION_NAME + ''' Started' );

  NotReady;
  UnSaved:=false; LUnsaved.Visible:=false;
  FFontConfig.CBFont.Items.Clear;
  DC := GetDC(0);
  EnumFonts(DC, nil, @EnumFontsProc, Pointer(FFontConfig.CBFont.Items));
  EnumFonts(DC, nil, @EnumFontsProc, Pointer(FTools.CBFont.Items));
  ReleaseDC(0, DC);
  FFontConfig.CBFont.Sorted := True;
  FLiveWindow.Top := FPreviewWindow.Top + FPreviewWindow.Height + 4;

  ReadParams(INIFile);
  LogThis( 'Options ''' + INIFile + ''' loaded' );

  // Ensure that the Temporary directory exists
  if not EnsureTemporaryDirectory then begin
    Application.Terminate;
    Exit;
  end;

  LogThis( 'Temp Directory initialised, File permissions OK ''' + TempDir + '''' );

  // Load language
  International_LoadLanguage( 'en_GB' );

  // Build up the key shortcut list
  CBSC.Items.Clear; CBSC.Items.Add('None');
  for i:=0 to 9  do CBSC.Items.Add(chr(48+i));
  for i:=1 to 26 do CBSC.Items.Add(chr(64+i));
  for i:=0 to 9  do CBSC.Items.Add(SShift +'+'+ chr(48+i));
  for i:=1 to 26 do CBSC.Items.Add(SShift +'+'+ chr(64+i));
  for i:=0 to 9  do CBSC.Items.Add(SCtrl  +'+'+ chr(48+i));
  for i:=1 to 26 do CBSC.Items.Add(SCtrl  +'+'+ chr(64+i));
  for i:=0 to 9  do CBSC.Items.Add(SAlt   +'+'+ chr(48+i));
  for i:=1 to 26 do CBSC.Items.Add(SAlt   +'+'+ chr(64+i));
  for i:=0 to 9  do CBSC.Items.Add(SShift +'+'+ SCtrl +'+'+ chr(48+i));
  for i:=1 to 26 do CBSC.Items.Add(SShift +'+'+ SCtrl +'+'+ chr(64+i));
  for i:=0 to 9  do CBSC.Items.Add(SShift +'+'+ SAlt  +'+'+ chr(48+i));
  for i:=1 to 26 do CBSC.Items.Add(SShift +'+'+ SAlt  +'+'+ chr(64+i));
  for i:=0 to 9  do CBSC.Items.Add(SCtrl  +'+'+ SAlt  +'+'+ chr(48+i));
  for i:=1 to 26 do CBSC.Items.Add(SCtrl  +'+'+ SAlt  +'+'+ chr(64+i));
  for i:=0 to 9  do CBSC.Items.Add(SShift +'+'+ SCtrl +'+'+ SAlt  +'+'+ chr(48+i));
  for i:=1 to 26 do CBSC.Items.Add(SShift +'+'+ SCtrl +'+'+ SAlt  +'+'+ chr(64+i));

  // Set window size
  BExpandPanel.Glyph.LoadFromResourceName(HInstance,'DOWNARR');
  bPanelExpanded := false;
  SetPanelStateExpanded( false );

  // Display the welcome string
  FmtStr( SVersionStr, SVersionStr, [ APPNAME, VERSION_NAME + ' - ' + VERSION_DATE ] );
  SBInfo.SimpleText := SVersionStr;
  SBInfo.AutoHint := true;

  // Display the preview window
  FPreviewWindow.HasButtons := true;
  FPreviewWindow.bNoResizeMsg := true;
  FPreviewWindow.Show;
  FPreviewWindow.bNoResizeMsg := false;

  bLoadingDefault := true;
  if FSettings.AutoLoad1.Checked and (Database1.Count>END_MENU) then begin
    LogThis( 'Loading Default Catalogue' );
    Clicked_1(Sender);
  end;
  bLoadingDefault := false;

  // Create the secondary 'LIVE' window - as a clone of the PreviewWindow
  FLiveWindow.sCurrentCaption := 'LIVE';
  FLiveWindow.HasInfo := true;

  LogThis( 'Songbase main form is now showing...' );
  VideoStream.BringToFront;
  FWebServer.serverEnabled(FNetSetup.enabled);
end;

procedure TFSongbase.New1Click(Sender: TObject);
var TF : TextFile;
    S : string;
begin
  if CheckFileSave then begin
    SaveDialog1.Title:='New Song Database';
    SaveDialog1.Filter:='Songbase Files|*.sdb';
    SaveDialog1.Options:=[ofOverWritePrompt];
    if SaveDialog1.Execute then begin
      if pos('SDB',uppercase(SaveDialog1.FileName))=0 then SaveDialog1.FileName:=SaveDialog1.FileName+'.sdb';
      if not OpenForWrite(TF,SaveDialog1.FileName) then Exit;
      CloseTextfile(TF,SaveDialog1.FileName);
      FileName:=SaveDialog1.FileName;
      S:=FileName;
      while S[length(S)]<>'.' do S:=copy(S,1,length(S)-1);
      OhpFile:=S+'ohp';
      QSFile:=S+'fsh';
      OrderFile:=S+'sor';
      if OpenForWrite(TF,OrderFile) then begin
        CloseTextfile(TF,OrderFile);
        if OpenForWrite(TF,QSFile) then begin
          CloseTextfile(TF,QSFile);
          if not WriteEmptyZip(OHPFile) then Exit;
          FSongbase.Caption:=FileName+' - Songbase';
          AddNewSong1.Enabled:=true;
          UnSaved:=false; LUnsaved.Visible:=false;
          TryOpen(Sender);
        end;
      end;
    end;
  end;
end;

procedure TFSongbase.SBRecNoChange(Sender: TObject);
begin
  ActualSBRecNoChange(false);
end;

procedure TFSongbase.ActualSBRecNoChange(from_web : boolean);
var S : string;
    T : integer;

begin
  T:=SBRecNo.Position;
  if not Cancelling then begin
    if CheckFileSave then begin
      LogThis( 'Selecting Song: '+IntToStr(T) );
      SBRecNo.Position:=T;
      PreviousSong1.Enabled:=(SBRecNo.Position>1);
      NextSong1.Enabled:=(SBRecNo.Position<SBRecNo.Max) and (SBRecNo.Position>0);
      str(SBRecNo.Position,S);
      LRec.Caption:=S+'/';
      str(SbRecNo.Max,S);
      LRec.Caption:=LRec.Caption+S;
      if SBRecNo.Position>=1 then begin
        LoadRec(SBRecNo.Position,from_web);
        FSongDetails.BAddLink.Enabled:=true;
        DeleteThisSong1.Enabled:=true;
        str(SBRecNo.Position,S);
        LRec.Caption:=S+'/';
        str(SbRecNo.Max,S);
        LRec.Caption:=LRec.Caption+S;
      end;
    end else begin
      Cancelling:=true;
      SBRecNo.Position:=LastLoaded-1;
    end;
  end else Cancelling:=false;
  UpdateOrderButtons;

  FSonglist.SelectItem( T-1 );
  LogThis( 'Selected Song: '+ IntToStr(SBRecNo.Position) );
end;


procedure TFSongbase.ETitleChange(Sender: TObject);
var
  bEnabled : boolean;
begin
  if not bDisableEvents then begin
    unSaved:=true; LUnsaved.Visible:=true;
    bEnabled := (ETitle.Text <> '');
    SaveChanges1.Enabled            := bEnabled;
    BEditSong.Enabled               := bEnabled;
    FPreviewWindow.BEditOHP.Enabled := bEnabled;
  end;
end;

procedure TFSongbase.NextSong1Click(Sender: TObject);
begin
  SbRecNo.Position:=SbRecNo.Position+1;
end;

procedure TFSongbase.PreviousSong1Click(Sender: TObject);
begin
  SbRecNo.Position:=SbRecNo.Position-1;
end;

procedure TFSongbase.EAuthorChange(Sender: TObject);
begin
  if not bDisableEvents then begin
    UnSaved:=true; LUnsaved.Visible:=true;
    SaveChanges1.Enabled:=true;
    BEditSong.Enabled := true;
  end;
end;

procedure TFSongbase.ECopyrightChange(Sender: TObject);
begin
  if not bDisableEvents then begin
    UnSaved:=true; LUnsaved.Visible:=true;
    SaveChanges1.Enabled:=true;
    DeleteThisSong1.Enabled:=false;
    BEditSong.Enabled := true;
  end;
end;

procedure TFSongbase.ECopDateChange(Sender: TObject);
begin
  if not bDisableEvents then begin
    UnSaved:=true; LUnsaved.Visible:=true;
    SaveChanges1.Enabled:=true;
    DeleteThisSong1.Enabled:=false;
    BEditSong.Enabled := true;
  end;
end;

procedure TFSongbase.EOfficeNoChange(Sender: TObject);
begin
  if not bDisableEvents then begin
    UnSaved:=true; LUnsaved.Visible:=true;
    SaveChanges1.Enabled:=true;
    DeleteThisSong1.Enabled:=false;
    BEditSong.Enabled := true;
  end;
end;

procedure TFSongbase.COHPClick(Sender: TObject);
begin
  if not bDisableEvents then begin
    UnSaved:=true; LUnsaved.Visible:=true;
    SaveChanges1.Enabled:=true;
    DeleteThisSong1.Enabled:=false;
  end;
end;

procedure TFSongbase.CSheetClick(Sender: TObject);
begin
  UnSaved:=true; LUnsaved.Visible:=true;
  SaveChanges1.Enabled:=true;
  DeleteThisSong1.Enabled:=false;
end;

procedure TFSongbase.CRecClick(Sender: TObject);
begin
  UnSaved:=true; LUnsaved.Visible:=true;
  SaveChanges1.Enabled:=true;
  DeleteThisSong1.Enabled:=false;
end;

procedure TFSongbase.GetID;
var S : string;

begin
  Str( PageCache_GetNextFreeSongID, S );
  EID.Text := S;
end;



procedure TFSongbase.AddNewSong1Click(Sender: TObject);
begin
  if CheckFileSave then begin
    Ready;
    if not bPanelExpanded then BExpandPanelClick(Sender);
    ETitle.Text:='';
    ESongbaseID.Text:='';
    EAltTitle.Text:='';
    EAuthor.TexT:='';
    ECopDate.TexT:='';
    with FSongDetails do begin
      COHP.Checked:=false;
      CRec.Checked:=false;
      CSheet.Checked:=false;
      CPhoto.Checked:=false;
      CTrans.Checked:=false;
      ECopyright.TexT:='';
      EOfficeNo.TexT:='';
      EISBN.TexT:='';
      ETune.TexT:='';
      EArr.TexT:='';
      EMus.Text:='';
      CTempo.ItemIndex:=-1;
      CCapo.ItemIndex:=-1;
      CKey.ItemIndex:=-1;
      CMM.ItemIndex:=-1;
      ECop1.Text:='';
      ECop2.Text:='';
      ENotes.Text:='';
    end;
    GetID;
    bNewSong := true;
    BlankFlag:=true;
    CurrentSongIsReadable( true );
    FSongDetails.BAddLink.Enabled:=true;
    ETitle.SetFocus();
    FPreviewWindow.LoadOHP( '', 0 );
    FPreviewWindow.BEditOHP.Caption := 'Create Page';
  end;
end;

procedure TFSongbase.SaveChanges1Click(Sender: TObject);
begin
  if UnSaved then SaveRec;
  SaveChanges1.Enabled:=false;
end;

procedure TFSongbase.DeleteThisSong1Click(Sender: TObject);
begin
  DeleteRec;
end;

procedure TFSongbase.ResetUsage1Click(Sender: TObject);
var TF : Textfile;
    TF2 : TextFile;
    S : string;
    SR : SongRecord;
begin
  if MessageDlg(FSongbase.SCheckReset, mtWarning, [mbYes, mbNo], 0) = mrYes then begin
    PageCache_FlushAll;
    if not OpenForRead(TF,FileName) then Exit;
    if not OpenForWrite(TF2,TempDir+'Songbase.tmp') then begin CloseTextFile(TF,Filename); Exit; end;
    while not eof(TF) do begin
      readln(TF,S);
      if length(S)>3 then begin
        DeLimit(S,SR);
        SR.OHP:='0'; SR.Sheet:='0'; SR.Rec:='0'; SR.Photo:='0';
        Limit(S,SR);
        writeln(TF2,S);
      end;
    end;
    CloseTextfile(TF,FileName);
    CloseTextfile(TF2,TempDir+'Songbase.tmp');
    erase(TF);
    rename(TF2,FileName);
    LoadRec(SBRecNo.Position,false);
  end;
end;

procedure TFSongbase.ClearHistory1Click(Sender: TObject);
var TF : TextFile;
begin
  if MessageDlg('This will forget all data used for auto-completion. Are you sure?', mtWarning, [mbYes, mbNo], 0) = mrYes then begin
    if OpenForWrite(TF,CopFile)   then CloseTextfile(TF,CopFile);
    if OpenForWrite(TF,AuthFile)  then CloseTextfile(TF,AuthFile);
    if OpenForWrite(TF,PhotoFile) then CloseTextfile(TF,PhotoFile);
  end;
end;

procedure TFSongbase.AutoCompletion1Click(Sender: TObject);
begin
  AutoCompletion1.Checked:=not AutoCompletion1.Checked;
end;

procedure TFSongbase.ECopyrightKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var T,S : string;
    R : integer;
begin
  if ((not (([ssCtrl]<=Shift) or ([ssAlt]<=Shift))) and ((Key>64) and (Key<91) and (lengtH(ECopyRight.Text)>0))) then begin
    T:=copy(ECopyRight.Text,1,ECopyRight.SelStart);
    LookupHistory(T,S,CopFile);
    R:=ECopyRight.SelStart;
    if S<>'' then begin
      ECopyRight.Text:=S;
      ECopyRight.SelStart:=R;
      ECopyRight.Sellength:=length(S);
    end;
  end;
end;

procedure TFSongbase.EAuthorKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var T,S : string;
    R : integer;

begin
  if ((not (([ssCtrl]<=Shift) or ([ssAlt]<=Shift))) and ((Key>64) and (Key<91) and (lengtH(EAuthor.Text)>0))) then begin
    T:=copy(EAuthor.Text,1,EAuthor.SelStart);
    LookupHistory(T,S,AuthFile);
    R:=EAuthor.SelStart;
    if S<>'' then begin
      EAuthor.Text:=S;
      EAuthor.SelStart:=R;
      EAuthor.Sellength:=length(S);
    end;
  end;
end;

procedure TFSongbase.RecreateHistory1Click(Sender: TObject);
var TF : textfile;
    S : string;
    SR : SongRecord;
begin
  if OpenForRead(TF,FileName) then begin
    while not eof(TF) do begin
      readln(TF,S);
      Delimit(S,SR);
      AddToHistory(SR.Author,AuthFile);
      AddToHistory(SR.Arr,AuthFile);
      AddToHistory(SR.Copyright,CopFile);
      AddPhotoToHistory(SR.MusBook,SR.ISBN,PhotoFile);
    end;
    CloseTextfile(TF,FileName);
  end;
end;



procedure TFSongbase.Find1Click(Sender: TObject);
begin
  FSearch.Top:=FSongbase.Top+10;
  FSearch.Left:=FSongbase.Left+10;
  FSearch.ShowModal;
  if( FSearch.Entered ) then begin
    FSearchResults.Show;
  end;
end;

procedure TFSongbase.Ready;
begin
  ETitle.Enabled:=true;
  EAltTitle.Enabled:=true;
  EAuthor.Enabled:=true;
  ECopDate.Enabled:=true;
  ECopyright.Enabled:=true;
  EOfficeNo.Enabled:=true;
  LTitle.Enabled:=true;
  LATitle.Enabled:=true;
  LAuthor.Enabled:=true;
  LCopDate.Enabled:=true;
  LCopyRight.Enabled:=true;
  LOfficeNo.Enabled:=true;
  BTitleSearchMulti.Enabled:=true;
  BTitleSearch.Enabled:=true;
  BTextSearch.Enabled:=true;
  BAddToOrder.Enabled:=true;
  BEditSong.Enabled:=true;  
  AddNewSong1.Enabled:=true;
  ResetUsage1.Enabled:=true;
  RecreateHistory1.Enabled:=true;
  LRec.Visible:=true;
  Find1.Enabled:=true;
  AddMultipleSongs1.Enabled:=true;
  TitleSearch.Enabled:=true;
  SaveAs1.Enabled:=true;
  ImportSongs1.Enabled:=true;
  BDropDownOrders.Enabled:=true;
  BNewOrder.Enabled:=true;
  BProjNow.Enabled:=true;
  FPreviewWindow.BBlank.Enabled := true;
  with FSongDetails do begin
    COHP.Enabled:=true;
    CTrans.Enabled:=true;
    CSheet.Enabled:=true;
    CRec.Enabled:=true;
    SBRecNo.Enabled:=true;
    ETune.Enabled:=true;
    EISBN.Enabled:=true;
    EArr.Enabled:=true;
    EMus.Enabled:=true;
    CPhoto.Enabled:=true;
    CCapo.Enabled:=true;
    CMM.Enabled:=true;
    CKey.Enabled:=true;
    CTempo.Enabled:=true;
    ECop1.Enabled:=true;
    ECop2.Enabled:=true;
    ENotes.Enabled:=true;
  end;
end;

procedure TFSongbase.SaveAs1Click(Sender: TObject);
var S : string;
begin
  if Unsaved then SaveRec;
  SaveDialog1.Title:='Save Copy Of This Database';
  SaveDialog1.Filter:='Songbase Files|*.sdb';
  SaveDialog1.Options:=[ofOverWritePrompt];

  if SaveDialog1.Execute then begin
    if pos('SDB',uppercase(SaveDialog1.FileName))<=0 then SaveDialog1.Filename:=SaveDialog1.FileName+'.sdb';
    if (FileName<>SaveDialog1.FileName) then begin
      S:=SaveDialog1.FileName;
      CopyFile(PChar(FileName),PChar(SaveDialog1.FileName),false);
      while S[length(S)]<>'.' do S:=copy(S,1,length(S)-1);
      S:=S+'ohp';
      CopyFile(PChar(OhpFile),PChar(S),false); OhpFile:=S;
      while S[length(S)]<>'.' do S:=copy(S,1,length(S)-1);
      S:=S+'fsh';
      CopyFile(PChar(QSFile),PChar(S),false); QSFile:=S;
      while S[length(S)]<>'.' do S:=copy(S,1,length(S)-1);
      S:=S+'sor';
      CopyFile(PChar(OrderFile),PChar(S),false); OrderFile:=S;
      FileName:=SaveDialog1.FileName;
      FSongbase.Caption:=FileName+' - Songbase';
    end;
  end;
end;


procedure TFSongbase.BEditOHPClick(Sender: TObject);
begin
  EditOHPPage( 1 );
end;


procedure TFSongbase.EOrderExit(Sender: TObject);
var TF,GF : Textfile;
    S : string;
begin
  if OrigOrderName<>EOrder.Text then begin
    LBOrders.Items.Strings[LBOrders.ItemIndex]:=EOrder.Text;
    LogThis( 'Updating Order file ' + OrderFile );
    if not OpenForRead(TF,OrderFile) then Exit;
    if not OpenForWrite(GF,TempDir+'potato') then begin CloseTextFile(TF,OrderFile); Exit; end;
    while not eof(TF) do begin
      readln(TF,S);
      if S=OrigOrderName then begin
        S:=copy(S,1,pos(chr128,S))+EOrder.Text;
        OrigOrderName:=S;
      end;
      writeln(GF,S);
      readln(TF,S);
      writeln(GF,S);
    end;
    CloseTextfile(GF,TempDir+'potato');
    CloseTextfile(TF,OrderFile);
    erase(TF);
    rename(GF,OrderFile);
  end;
end;

procedure TFSongbase.BNewOrderClick(Sender: TObject);
var Tf : TextFile;
    TiCode,S : string;
    TI,TX,code : integer;
begin
  ti:=1;

  // If it doesn't already exist, create the .sor file
  if not FileExists(OrderFile) and OpenForWrite(TF,OrderFile) then CloseTextfile(TF,OrderFile);

  // Firstly, get the insert point
  if not openforread(Tf,Orderfile) then Exit;
  while not eof(TF) do begin
    readln(TF,S);
    S:=copy(S,1,pos(chr128,S)-1);
    val(S,TX,Code);
    if Tx>=Ti then Ti:=Tx+1;
    readln(Tf,S);
  end;
  CloseTextfile(TF,OrderFile);
  str(Ti,TiCode);

  // Then append
  if OpenForAppend(TF,OrderFile) then begin
    S:=DateTimeToStr(Date);
    OrigOrderName:='New '+S;
    EOrder.Text:=OrigOrderName;
    LBOrders.Items.Insert(0,OrigOrderName);
    OrigOrderName:=TiCode+chr128+OrigOrderName;
    writeln(TF,OrigOrderName); writeln(TF,'');
    CloseTextfile(TF,OrigOrderName);
    OrderNo:=TotalOrders+1;
    TotalOrders:=OrderNo;
    GetOrder(TotalOrders);
    CurrentOrderIndex := -1;
    UpdateOrderButtons;
    LBOrders.ItemIndex:=0;
    OrderItemsSize;
  end;
end;


procedure TFSongbase.BSaveOrderClick(Sender: TObject);
var Tf : TextFile;
    TiCode,S : string;
    TI,TX,code : integer;
begin
  ti:=1;
  if not openforread(Tf,Orderfile) then Exit;
  while not eof(TF) do begin
    readln(TF,S);
    S:=copy(S,1,pos(chr128,S)-1);
    val(S,TX,Code);
    if Tx>=Ti then Ti:=Tx+1;
    readln(Tf,S);
  end;
  CloseTextfile(TF,Orderfile);
  str(Ti,TiCode);

  if not OpenForAppend(TF,OrderFile) then Exit;
  OrigOrderName:='Copy of '+copy(OrigOrderName,pos(chr128,OrigOrdername)+1,length(OrigOrderName));
  EOrder.Text:=OrigOrderName;
  LBOrders.Items.Insert(0,OrigOrderName);
  OrigOrderName:=TiCode+chr128+OrigOrderName;
  writeln(TF,OrigOrderName); writeln(TF,OrderData); CloseTextfile(TF,OrigOrderName);
  OrderNo:=TotalOrders+1;
  inc(TotalOrders);
  LBOrders.ItemIndex:= 0;
  CurrentOrderIndex := StringGrid1.RowCount-1;
  UpdateOrderButtons;
  OrderItemsSize;
end;

procedure TFSongbase.BAddToOrderClick(Sender: TObject);
var bAlreadyInOrder : boolean;
    sSongID, s : string;
    iRow : integer;
begin
  // If there's not already an order, create one
  if EOrder.Text = '' then BNewOrder.Click;
  if Unsaved then SaveRec;

  // Ensure this song isn't already in the order
  bAlreadyInOrder := false;
  s := OrderData;
  for iRow:=0 to StringGrid1.RowCount-1 do begin
    sSongID :=copy(s,1,pos(chr128,S)-1);
    if sSongID = EID.Text then begin
      bAlreadyInOrder := true;
      break;
    end;
    S:=copy(S,pos(chr128,S)+1,length(S));
    S:=copy(S,pos(chr128,S)+1,length(S));
  end;

  if bAlreadyInOrder then begin
    // if it is already in the order select it.
    StringGrid1.Row := iRow;
  end else begin
    // otherwise, add to the order
    OrderData:=OrderData+EID.Text+chr128+chr128;
    ShowOrder(OrderData);
    StringGrid1.Row := StringGrid1.RowCount-1;
  //  LBOrder.ItemIndex:=LBOrder.Items.Count-1;
    CBSC.ItemIndex:=NextShortcut;
    CBSCClick(Sender);
    CurrentOrderIndex := StringGrid1.RowCount-1;
    UpdateOrderButtons;
    OverwriteOrder(OrigOrderName,OrderFile,OrderData);
  end;
  ChangeList(false,false);
end;

procedure TFSongbase.BRemFromOrderClick(Sender: TObject);
var S,L,S2,LK : string;
    Ind,I : integer;
    LastKey : string;
    bSetLastKey : boolean;
begin
  S:=OrderData;
//  IND:=LBOrder.ItemIndex;
  IND:=CurrentOrderIndex;
  I:=0;
  bSetLastKey := false;
  while S<>'' do begin
    L:=copy(S,1,pos(chr128,S)-1);
    if I<>Ind then begin
      S2:=S2+L+chr128;
      S:=copy(S,pos(chr128,S)+1,length(S));
      L:=copy(S,1,pos(chr128,S)-1);
      LK:=L;
      if bSetLastKey then begin
        LK      := LastKey;
        LastKey := L;
      end;
      S2:=S2+LK+chr128;
      S:=copy(S,pos(chr128,S)+1,length(S));
    end else begin
      S:=copy(S,pos(chr128,S)+1,length(S));
      if not FSettings.CBRemoveSort.Checked then begin
        bSetLastKey := true;
        LastKey := copy(S,0,pos(chr128,S)-1);
      end;
      S:=copy(S,pos(chr128,S)+1,length(S));
    end;
    inc(I);
  end;
  OrderData:=S2;
  SelectCellEnabled := false;
  ShowOrder(OrderData);
  SelectCellEnabled := true;
  OverwriteOrder(OrigOrderName,OrderFile,OrderData);
  if (StringGrid1.RowCount > 0) and (IND > 0) then begin
    StringGrid1.Row := Min( IND, StringGrid1.RowCount-1 );
  end;
  if 0 = StringGrid1.RowCount then BRemFromOrder.Enabled := false;
  ChangeList(false,false);
end;

procedure TFSongbase.BDelOrderClick(Sender: TObject);
var GF,Tf : Textfile;
    S : string;
    I : integer;
begin
  if messagedlg('Really delete this order?',mtconfirmation,[mbOK,mbCancel],0)=mrOK then begin
    if not OpenForRead(TF,Orderfile) then Exit;
    if not OpenForWrite(GF,TempDir+'potato') then begin CloseTextfile(TF,Orderfile); Exit; end;
    i:=0;
    while not eof(TF) do begin
      readln(TF,S);
      inc(I);
      if I<>OrderNo then begin
        writeln(GF,S);
        readln(TF,S);
        writeln(GF,S);
      end else begin
        readln(TF,S);
      end;
    end;
    flush(GF);
    CloseTextfile(TF,Orderfile);
    CloseTextfile(GF,TempDir+'potato');
    erase(TF);
    rename(GF,OrderFile);
    dec(TotalOrders);
    if (OrderNo>TotalOrders) then dec(OrderNo);
    if (OrderNo=0) and (TotalOrders>0) then OrderNo:=1;
    if TotalOrders=0 then begin
      OrderData:='';
    end;
    BuildOrderList;
    getOrder(OrderNo);
    CurrentOrderIndex := -1;
    UpdateOrderButtons;
    OrderItemsSize;
    BDropDownOrdersClick(Sender);
  end;
end;

function TFSongbase.StringSC(A,B : word) : string;
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

procedure TFSongbase.BProjNowClick(Sender: TObject);
begin
  ProjectSong( '', 0, false);
end;

procedure TFSongbase.LoadRecentDatabase( Sender : TObject; iItem : integer );
begin
  if CheckFileSave then begin
    FileName:=DataBase1.Items[END_MENU+ iItem].Caption;
    DEAmp(FileName);
    if FileExists(FileName) then begin
      LogThis( 'Loading Recent Database[' + IntToStr(iItem) + ']: ''' + Filename +'''' );
      TryOpen(Sender)
    end else begin
      if not bLoadingDefault then begin
        messagedlg('File "'+FileName+'" not found.',mtError,[mbOk],0);
        LogThis( 'Failed to load Default Database ''' + Filename +'''' );
      end else begin
        LogThis( 'Failed to load Recent Database[' + IntToStr(iItem) + ']: ''' + Filename +'''' );
      end;
      Database1.Delete(END_MENU+ iItem);
      SaveParams(INIFile);
      ReadParams(INIFile);
    end;
  end;
end;

procedure TFSongbase.Clicked_1(Sender : TObject);
begin
  LoadRecentDatabase( Sender, 1 );
end;

procedure TFSongbase.Clicked_2(Sender : TObject);
begin
  LoadRecentDatabase( Sender, 2 );
end;

procedure TFSongbase.Clicked_3(Sender : TObject);
begin
  LoadRecentDatabase( Sender, 3 );
end;

procedure TFSongbase.Clicked_4(Sender : TObject);
begin
  LoadRecentDatabase( Sender, 4 );
end;

procedure TFSongbase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LogThis( 'Request to close main application window recieved' );
  if not CheckFileSave then Action:=caNone
  else begin
    LogThis( 'Closing Database' );
    SaveParams(INIFile);
    CleanUpDatabase;
  end;
  BProjectReady := false;
end;

{procedure TFSongbase.bGlobProjClick(Sender: TObject);
begin
  FSettings.Top:=FSongbase.Top+10;
  FSettings.Left:=FSongbase.Left+10;
  FSettings.ShowModal;
  if( FPreviewWindow.Visible ) then FPreviewWindow.Refresh;
  if( FLiveWindow.Visible )    then FLiveWindow.Refresh;
end;
 }

procedure TFSongbase.CPhotoClick(Sender: TObject);
begin
  UnSaved:=true; LUnsaved.Visible:=true;
  SaveChanges1.Enabled:=true;
end;

procedure TFSongbase.EMusChange(Sender: TObject);
begin
  UnSaved:=true; LUnsaved.Visible:=true;
  SaveChanges1.Enabled:=true;
end;

procedure TFSongbase.EISBNChange(Sender: TObject);
begin
  UnSaved:=true; LUnsaved.Visible:=true;
  SaveChanges1.Enabled:=true;
end;

procedure TFSongbase.ETuneChange(Sender: TObject);
begin
  UnSaved:=true; LUnsaved.Visible:=true;
  SaveChanges1.Enabled:=true;
end;

procedure TFSongbase.EArrChange(Sender: TObject);
begin
  UnSaved:=true; LUnsaved.Visible:=true;
  SaveChanges1.Enabled:=true;
end;

procedure TFSongbase.CCapoChange(Sender: TObject);
begin
  if not bDisableEvents then begin
    UnSaved:=true; LUnsaved.Visible:=true;
    SaveChanges1.Enabled:=true;
    UnSaved:=true; LUnsaved.Visible:=true;
    SaveChanges1.Enabled:=true;
  end;
end;

procedure TFSongbase.ECop1Change(Sender: TObject);
begin
  UnSaved:=true; LUnsaved.Visible:=true;
  SaveChanges1.Enabled:=true;
end;

procedure TFSongbase.CKeyChange(Sender: TObject);
begin
  UnSaved:=true; LUnsaved.Visible:=true;
  SaveChanges1.Enabled:=true;
end;

procedure TFSongbase.CMMChange(Sender: TObject);
begin
  UnSaved:=true; LUnsaved.Visible:=true;
  SaveChanges1.Enabled:=true;
end;

procedure TFSongbase.ECop2Change(Sender: TObject);
begin
  UnSaved:=true; LUnsaved.Visible:=true;
  SaveChanges1.Enabled:=true;
end;

procedure TFSongbase.ENotesChange(Sender: TObject);
begin
  UnSaved:=true; LUnsaved.Visible:=true;
  SaveChanges1.Enabled:=true;
end;

procedure TFSongbase.ECopyrightExit(Sender: TObject);
var ou : string;
begin
  with FSongDetails do begin
    if (CBC2.Checked) then begin
      ou:='© '+ECopDate.TexT+' '+ECopyRight.Text;
      while pos('  ',Ou)>0 do
      Ou:=copy(Ou,1,pos('  ',Ou)-1)+copy(Ou,pos('  ',Ou)+1,length(Ou));
      while (length(ou)>1) and (ou[1]=' ') do ou:=copy(ou,2,length(ou));
      ECop2.Text:=ou;
    end;
  end;
end;

procedure TFSongbase.ECopDateExit(Sender: TObject);
begin
  ECopyrightExit(Sender);
end;

procedure TFSongbase.EAuthorExit(Sender: TObject);
var S,N,Ou : string;
    C : byte;
  begin
    with FSongDetails do begin
      if (ECop1.Text='') and (CBC1.Checked) then begin
      S:=EAuthor.Text;
      Ou:='';
      N:=S;
      while (pos(' and ',S)<>0) do
        S:=copy(S,1,pos(' and ',S)-1)+'/'+copy(S,pos(' and ',S)+5,length(S));
      repeat
        if pos('/',S)>0 then N:=copy(S,1,pos('/',S)-1) else N:=S;
        if N='' then S:='';
        if pos(',',N)>0 then begin
          N:=copy(N,pos(',',N)+1,length(N))+' '+copy(N,1,pos(',',N)-1)+', ';
          if pos('/',S)=0 then S:='' else S:=copy(S,pos('/',S)+1,length(S));
          Ou:=Ou+N;
        end else begin
          N:=S;
          Ou:=Ou+N;
          if pos('/',S)=0 then S:='' else S:=copy(S,pos('/',S)+1,length(S));
        end;
      until S='';
      if copy(Ou,length(Ou)-1,2)=', ' then Ou:=copy(Ou,1,length(Ou)-2);
      if pos(',',Ou)>0 then begin
        C:=length(Ou);
        while (Ou[C]<>',') do dec(C);
        Ou:=copy(Ou,1,C-1)+' and '+copy(Ou,C+1,lengtH(Ou));
      end;
      while pos('  ',Ou)>0 do
      Ou:=copy(Ou,1,pos('  ',Ou)-1)+copy(Ou,pos('  ',Ou)+1,length(Ou));
      while (length(ou)>1) and (ou[1]=' ') do ou:=copy(ou,2,length(ou));
      ECop1.TexT:=Ou;
    end;
  end;
end;

procedure TFSongbase.ImportSongs1Click(Sender: TObject);
begin
  // Firstly select the file to import
  FileOpen.Filter:='Songbase Files|*.sdb';
  FileOpen.Title:='Select file for import';
  if FileOpen.Execute and
     ('.sdb' = ExtractFileExt(FileOpen.FileName)) then begin
    if FileOpen.FileName = FileName then begin
      Application.MessageBox( 'Please select a different file', 'Cannot import a file into itself' );
    end else begin
      FImport.SDBInFile := FileOpen.FileName;
      FImport.OHPInFile := ChangeFileExt( FileOpen.FileName, '.ohp' );
      if FileExists( FImport.SDBInFile ) and
         FileExists( FImport.OHPInFile ) then begin
        FImport.Show;
      end;
    end;
  end;
end;

procedure TFSongbase.About1Click(Sender: TObject);
begin
  FAbout.Left:=FSongbase.Left+10;
  FAbout.Top:=FSongbase.Top+10;
  FAbout.ShowModal;
end;

procedure TFSongbase.Global1Click(Sender: TObject);
begin
  FSettings.Top:=FSongbase.Top+10;
  FSettings.Left:=FSongbase.Left+10;
  FSettings.ShowModal;
  if( FPreviewWindow.Visible ) then begin
    FPreviewWindow.RefreshAll;
  end;
end;

procedure TFSongbase.BEarlierClick(Sender: TObject);
var S : string;
    Code,A,B,i : integer;
    IDS,SCS : string;
    PasteID,PasteSC : string;
    NewOrder : string;
begin
  S:=OrderData;
  i:=0;
  PasteID:='';
  PasteSC:='';
  NewOrder:='';
  repeat
    NewOrder:=NewOrder+PasteID+PasteSC;
    IDS:=copy(S,1,pos(chr128,S)-1);
    S:=copy(S,pos(chr128,S)+1,length(S));
    SCS:=copy(S,1,pos(chr128,S)-1);
    S:=copy(S,pos(chr128,S)+1,length(S));
    PasteID:=IDS+chr128;
    PasteSC:=SCS+chr128;
    inc(i);
  until (i=CurrentOrderIndex);
  IDS:=copy(S,1,pos(chr128,S)-1);
  S:=copy(S,pos(chr128,S)+1,length(S));
  SCS:=copy(S,1,pos(chr128,S)-1);
  S:=copy(S,pos(chr128,S)+1,length(S));

  // If we want to get key shortcuts to follow the song then do it already!
  if FSettings.CBRemoveSort.Checked then begin
    NewOrder:=NewOrder+IDS+chr128+SCS+chr128+PasteID+PasteSC+S;
  end else begin
    NewOrder:=NewOrder+IDS+chr128+PasteSC+PasteID+SCS+chr128+S;
  end;

  // Swap the rows...
  S:=StringGrid1.Cells[1, CurrentOrderIndex-1];
  StringGrid1.Cells[1, CurrentOrderIndex-1] := StringGrid1.Cells[1, CurrentOrderIndex];
  StringGrid1.Cells[1, CurrentOrderIndex] := S;

  // And swap the keycode row if we need to do that as well
  if FSettings.CBRemoveSort.Checked then begin
    S:=StringGrid1.Cells[0, CurrentOrderIndex-1];
    StringGrid1.Cells[0, CurrentOrderIndex-1] := StringGrid1.Cells[0, CurrentOrderIndex];
    StringGrid1.Cells[0, CurrentOrderIndex] := S;
  end;

  // LBOrder.Items.Strings[LBOrder.ItemIndex-1];
  // LBOrder.Items.Strings[LBOrder.ItemIndex-1]:=LBOrder.Items.Strings[LBOrder.ItemIndex];
  // LBOrder.Items.Strings[LBOrder.ItemIndex]:=S;
  //  LBOrder.ITemIndex:=LBOrder.ItemIndex-1;
  OrderData:=NewOrder;
  S:=OrderData;
  for i:=0 to StringGrid1.Row do begin
    Ids:=copy(s,1,pos(chr128,S)-1);
    S:=copy(S,pos(chr128,S)+1,length(S));
    Scs:=copy(s,1,pos(chr128,s)-1);
    S:=copy(S,pos(chr128,S)+1,length(S));
  end;
  val(Scs,A,Code);
  val(copy(Scs,pos('~',Scs)+1,length(Scs)),B,Code);
  S:=StringSC(A,B);
  CBSC.ItemIndex:=CBSC.Items.Indexof(S);
//  UpdateOrderButtons(StringGrid1.Row);
  OverwriteOrder(OrigOrderName,OrderFile,OrderData);
  SelectCellEnabled := false;
  StringGrid1.Row := StringGrid1.Row - 1;
  SelectCellEnabled := true;
end;

procedure TFSongbase.BLaterClick(Sender: TObject);
var S : string;
    A,B,Code,i : integer;
    IDS,SCS : string;
    PasteID,PasteSC : string;
    NewOrder : string;
begin
  S:=OrderData;
  i:=0;
  PasteID:='';
  PasteSC:='';
  NewOrder:='';
  repeat
    NewOrder:=NewOrder+PasteID+PasteSC;
    IDS:=copy(S,1,pos(chr128,S)-1);
    S:=copy(S,pos(chr128,S)+1,length(S));
    SCS:=copy(S,1,pos(chr128,S)-1);
    S:=copy(S,pos(chr128,S)+1,length(S));
    PasteID:=IDS+chr128;
    PasteSC:=SCS+chr128;
    inc(i);
  until i>CurrentOrderIndex;
  IDS:=copy(S,1,pos(chr128,S)-1);
  S:=copy(S,pos(chr128,S)+1,length(S));
  SCS:=copy(S,1,pos(chr128,S)-1);
  S:=copy(S,pos(chr128,S)+1,length(S));

  // If we want to get key shortcuts to follow the song then do it already!
  if FSettings.CBRemoveSort.Checked then begin
    NewOrder:=NewOrder+IDS+chr128+SCS+chr128+PasteID+PasteSC+S;
  end else begin
    NewOrder:=NewOrder+IDS+chr128+PasteSC+PasteID+SCS+chr128+S;
  end;

  // Swap the rows..
  S:=StringGrid1.Cells[1, CurrentOrderIndex];
  StringGrid1.Cells[1, CurrentOrderIndex] := StringGrid1.Cells[1, CurrentOrderIndex + 1];
  StringGrid1.Cells[1, CurrentOrderIndex + 1] := S;

  // And swap the keycode row if we need to do that as well
  if FSettings.CBRemoveSort.Checked then begin
    S:=StringGrid1.Cells[0, CurrentOrderIndex+1];
    StringGrid1.Cells[0, CurrentOrderIndex+1] := StringGrid1.Cells[0, CurrentOrderIndex];
    StringGrid1.Cells[0, CurrentOrderIndex] := S;
  end;

{  S:=LBOrder.Items.Strings[LBOrder.ItemIndex];
  LBOrder.Items.Strings[LBOrder.ItemIndex]:=LBOrder.Items.Strings[LBOrder.ItemIndex+1];
  LBOrder.Items.Strings[LBOrder.ItemIndex+1]:=S;
  LBOrder.ItemIndex:=LBOrder.ItemIndex+1; }
  OrderData:=NewOrder;
  S:=OrderData;
  for i:=0 to StringGrid1.Row do begin
    Ids:=copy(s,1,pos(chr128,S)-1);
    S:=copy(S,pos(chr128,S)+1,length(S));
    Scs:=copy(s,1,pos(chr128,s)-1);
    S:=copy(S,pos(chr128,S)+1,length(S));
  end;
  val(Scs,A,Code);
  val(copy(Scs,pos('~',Scs)+1,length(Scs)),B,Code);
  S:=StringSC(A,B);
  CBSC.ItemIndex:=CBSC.Items.Indexof(S);
//  UpdateOrderButtons(StringGrid1.Row);
  OverwriteOrder(OrigOrderName,OrderFile,OrderData);

  SelectCellEnabled := false;
  StringGrid1.Row := StringGrid1.Row + 1;
  SelectCellEnabled := true;
end;

procedure TFSongbase.BPrintOrderClick(Sender: TObject);
begin
  FPSong.ETitle.Text:=EOrder.Text;
  FPSong.OrderD:=OrderData;
  FPSong.DataF:=FileName;
  FPSong.showModal;
end;

procedure TFSongbase.MultiTitleSearchClick(Sender: TObject);
begin
  FTitle.Initial := '';
  FTitle.Caption := 'Multiple Title Search';
  FTitle.FileName:=FileName;
  FTitle.BOk.Caption := 'Add Selected';
  FTitle.BCancel.Caption := 'Finished';
  repeat begin
    FTitle.ShowModal;
    if FTitle.ResultSong<>-1 then begin
      SBRecNo.Position:=FTitle.ResultSong;
      BAddToOrder.Click;
    end;
  end until FTitle.ResultSong = -1;
  SBRecNo.SetFocus;
end;

procedure TFSongbase.TitleSearchClick(Sender: TObject);
begin
  FTitle.Initial := '';
  FTitle.Caption := 'Quick Title Search';
  FTitle.FileName:=FileName;
  FTitle.BOk.Caption := 'OK';
  FTitle.BCancel.Caption := 'Cancel';
  FTitle.ShowModal;
  if FTitle.ResultSong<>-1 then SBRecNo.Position:=FTitle.ResultSong;
  SBRecNo.SetFocus;
end;

procedure TFSongbase.EAltTitleChange(Sender: TObject);
begin
  if not bDisableEvents then begin
    unSaved:=true; LUnsaved.Visible:=true;
    SaveChanges1.Enabled:=true;
    BEditSong.Enabled := true;
  end;
end;

procedure TFSongbase.CTransClick(Sender: TObject);
begin
  UnSaved:=true; LUnsaved.Visible:=true;
  SaveChanges1.Enabled:=true;
  DeleteThisSong1.Enabled:=false;

end;

procedure TFSongbase.RebuildFastSearch1Click(Sender: TObject);
var TF,SCH : Textfile;
    SR : SongRecord;
    S, sInfoStr : String;
    iTotal, iUpdate, iCount : integer;
begin
  sInfoStr := 'Please Wait... Rebuilding Fast-Search Index';
  FInfoBox.ShowBox( FSongbase, sInfoStr );
  PageCache_FlushAll;
  if OpenForRead(TF,FileName) then begin
    if OpenForWrite(SCH,QSFile) then begin
      // Calculate how many records we skip for each % update
      iTotal  := SBRecNo.Max;
      iUpdate := (2 * iTotal) div 100;      // every 2%
      if 0 = iUpdate then iUpdate := 1;
      iCount  := 0;
      while not eof(TF) do begin
        readln(TF,S);
        Delimit(S,SR);
        writeln(SCH,SR.ID+'~'+FastString(OHPFile,SR.ID));
        inc(iCount);
        if 1 = iCount mod iUpdate then begin
          FInfoBox.Label1.Caption := sInfoStr + ' (' + IntToStr( (iCount * 100) div iTotal ) + '%)';
          FInfoBox.Label1.Refresh;
        end;
      end;
      CloseTextfile(SCH,QSFile);
    end;
    CloseTextfile(TF,FileName);
  end;
  FInfoBox.Close;
end;

procedure TFSongbase.CBSCClick(Sender: TObject);
var I, iIdx : integer;
    NewStr,S2,S : string;
    ID,K : string;
    A,B : word;
begin
  {Check for already in use}
  if ShortCutInUse(CBSC.ItemIndex) then begin
    messagedlg('This short-cut is already in use. Next available short-cut has been assigned',mtConfirmation,[mbOk],0);
    CBSC.ItemIndex:=NextShortCut;
  end;
  A:=0;
  S:=CBSC.Items.Strings[CBSC.ItemIndex];
  if pos('Shift',S)>0 then A:=A+1;
  if pos('Ctrl',S)>0 then A:=A+2;
  if pos('Alt',S)>0 then A:=A+4;
  while pos('+',S)>0 do S:=copy(S,pos('+',S)+1,length(S));
  B:=ord(S[1]);
  str(A,S2);
  str(B,S);
  NewStr:=S2+'~'+S;
  S2:='';
  S:=OrderData;
  I:=0;
  iIdx := 0;
  repeat
    ID:=copy(S,1,pos(chr128,S)-1);
    S:=copy(S,pos(chr128,S)+1,length(S));
    K:=copy(S,1,pos(chr128,S)-1);
    S:=copy(S,pos(chr128,S)+1,length(S));
    if I=CurrentOrderIndex then begin
      K:=NewStr;
      iIdx := I;
    end;
    S2:=S2+ID+chr128+K+chr128;
    inc(I);
  until I>CurrentOrderIndex;
  S2:=S2+S;
  OrderData:=S2;
  OverwriteOrder(OrigOrderName,OrderFile,OrderData);

  // Update shortcut value...
  if (iIdx < StringGrid1.RowCount) and (B <> 0) then begin
    S := Chr(B);
    if A = 1 then S := 's' + S;
    if A = 2 then S := 'c' + S;
    if A = 3 then S := 'sc' + S;
    if A = 4 then S := 'a' + S;
    if A = 5 then S := 'sa' + S;
    if A = 6 then S := 'ca' + S;
    if A = 7 then S := 'sca' + S;
    StringGrid1.Cells[0,iIdx] := S;
  end;
end;

procedure TFSongbase.LBOrdersClick(Sender: TObject);
var c,i : integer;
begin
  c:= LBOrders.Items.Count;
  i:= LBOrders.ItemIndex;
  GetOrder(c-i);
  EOrder.Text:=LBOrders.Items.Strings[i];
  UpdateOrderButtons;
  StringGrid1.SetFocus;
end;

procedure TFSongbase.EOrderKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=chr(13) then begin
    EOrderExit(Sender);
    Key:=chr(0);
  end;
end;

{
procedure TFSongbase.Button1Click(Sender: TObject);
var SR : SongRecord;
    i : integer;
    Bf,Tf : TextFile;
    S : string;
begin
  i:=0;
  OpenForRead(TF,FileName);
  OpenForWrite(BF,'Songbase.tmp');
  while not eof(TF) do begin
    readln(TF,S);
    Delimit(S,SR);
    if (SR.OfficeNo<>'') and (SR.UniqueID='') then SR.UniqueID:=SR.OfficeNo;
    if (SR.OfficeNo='') and (SR.UniqueID='') then begin
      inc(i);
      SR.UniqueID:='SB-'+IntToStr(i);
    end;
    limit(S,SR);
    writeln(BF,S);
  end;
  CloseTextfile(TF,FileName);
  CloseTextfile(BF,'Songbase.tmp');
  rename(TF,'Songbase.bak');
  rename(BF,FileName);
end;
}

procedure TFSongbase.BProjectSongClick(Sender: TObject);
begin
  ProjectSong( EID.Text, 1, false);
end;

{ Project Song will always project on the currently selected Projection Device }
procedure TFSongbase.ProjectSong( ID : string; Page : integer; from_webserver : boolean);
var omx,omy : word;
begin
  LogThis( 'Request to project ' + ID + ', page ' + IntToStr(Page) );

  FProjWin.GID      := ID;
  FProjWin.ShowPage := Page;
  FProjWin.GTitle:='';
  FProjWin.GCopy1:='';
  FProjWin.GCopy2:='';
  FProjWin.EditGID:='';
  FProjWin.AutoUpdateOHP:=FSettings.CBAutoOHP.Checked;
  if bMultiMonitor then begin
    if FProjWin.Visible then begin
      FProjWin.FormShow(FProjWin);
    end else begin
      FProjWin.DefaultMonitor := dmDesktop;
      FProjWin.Left   := ptDisplayOrigin.X;
      FProjWin.Top    := ptDisplayOrigin.Y;
      FProjWin.Width  := szDisplaySize.cx;
      FProjWin.Height := szDisplaySize.cy;
      FProjWin.show;
    end;
  end else begin
    if FProjWin.Visible then begin
      FProjWin.ShowTheSong( ID );
    end else begin
      ShowCursor(false);
      omx:=Mouse.Cursorpos.x;
      omy:=Mouse.Cursorpos.y;
      SetCursorPos(Screen.width+20,Screen.height+20);
      FProjWin.Top:=0;
      FProjWin.Left:=0;
      FProjWin.Width  := szDisplaySize.cx;
      FProjWin.Height := szDisplaySize.cy;
      FProjWin.showModal;
      SetCursorpos(omx,omy);
      ShowCursor(true);
    end;
  end;

  LogThis( 'Finished ProjectSong' );
end;


procedure TFSongbase.EditOHPPage( Page : integer );
begin
  LogThis( 'EditOHP - page ' + IntToStr(Page) );
  if Unsaved then SaveRec;
  //OverwriteOrder(OrigOrderName,OrderFile,OrderData);
  FEditWin.EditGID:=EID.Text;
  FEditWin.ShowPage:=Page;
  FEditWin.GTitle:=ETitle.Text;
  with FSongDetails do begin
    if ECop1.Text=''  then FEditWin.GCopy1:='  (esc to exit)       © '+ECopDate.Text+' '+EAuthor.Text;
    if ECop1.Text<>'' then FEditWin.GCopy1:='  (esc to exit)       '+ECop1.Text;
    if ECop2.Text=''  then FEditWin.GCopy2:=ECopyright.Text;
    if ECop2.Text<>'' then FEditWin.GCopy2:=ECop2.Text;
  end;
  FEditWin.Cop1.Visible:=false;
  FEditWin.Cop2.Visible:=false;
  FEditWin.LLicense.Visible:=false;
  FEditWin.Top:=0;
  FEditWin.Left:=0;
  FEditWin.show;
  LogThis( 'Editor window showing' );
end;


procedure TFSongbase.CurrentSongIsReadable( bReadable : boolean );
const
  sROString : string = 'Click "Edit Song" button to make changes to these song details';
begin
  if bReadable then begin
    ETitle.Color      := clBtnHighlight; EAltTitle.Color  := clBtnHighlight; 
    EAuthor.Color     := clBtnHighlight; ECopDate.Color   := clBtnHighlight;
    ECopyright.Color  := clBtnHighlight; EOfficeNo.Color  := clBtnHighlight;

    ETitle.Cursor    := crDefault;  EAltTitle.Cursor  := crDefault;  EAuthor.Cursor   := crDefault;
    ECopDate.Cursor  := crDefault;  ECopyright.Cursor := crDefault;  EOfficeNo.Cursor := crDefault;
    ETitle.Cursor    := crDefault;  EAltTitle.Cursor  := crDefault;  EAuthor.Cursor   := crDefault;
    ECopDate.Cursor  := crDefault;  ECopyright.Cursor := crDefault;  EOfficeNo.Cursor := crDefault;
    BEditSong.Caption := SSaveChanges;
    BEditSong.Enabled := false;
    EditingSong := true;
  end else begin
    ETitle.Hint   := sROString; EAltTitle.Hint  := sROString; EAuthor.Hint   := sROString;
    ECopDate.Hint := sROString; ECopyright.Hint := sROString; EOfficeNo.Hint := sROString;
    ETitle.Color     := clBtnFace; EAltTitle.Color := clBtnFace;
    EAuthor.Color    := clBtnFace; ECopDate.Color  := clBtnFace;
    ECopyright.Color := clBtnFace; EOfficeNo.Color := clBtnFace;
    ETitle.Cursor    := crArrow;  EAltTitle.Cursor  := crArrow;  EAuthor.Cursor   := crArrow;
    ECopDate.Cursor  := crArrow;  ECopyright.Cursor := crArrow;  EOfficeNo.Cursor := crArrow;
    BEditSong.Caption := SEditSong;
    BEditSong.Enabled := true;
    EditingSong := false;
  end;
{  ETitle.Enabled   := bReadable;  EAltTitle.Enabled  := bReadable;  EAuthor.Enabled   := bReadable;
  ECopDate.Enabled := bReadable;  ECopyright.Enabled := bReadable;  EOfficeNo.Enabled := bReadable;}
  ETitle.ReadOnly     := not bReadable;  EAltTitle.ReadOnly := not bReadable;
  EAuthor.ReadOnly    := not bReadable;  ECopDate.ReadOnly  := not bReadable;
  ECopyright.ReadOnly := not bReadable;  EOfficeNo.ReadOnly := not bReadable;
end;


procedure TFSongbase.BEditSongClick(Sender: TObject);
begin
  if( ETitle.ReadOnly ) then begin
    CurrentSongIsReadable( true );
    ETitle.SetFocus();
  end else begin
    if( BEditSong.Enabled ) then begin
      // If changes occured, save them
      SaveRec;
    end;
    CurrentSongIsReadable( false );
  end;
end;

procedure TFSongbase.BTextSearchClick(Sender: TObject);
begin
  Find1Click(Sender);
end;

procedure TFSongbase.BTitleSearchClick(Sender: TObject);
begin
  TitleSearchClick(Sender);
end;

procedure TFSongbase.BTitleSearchMultiClick(Sender: TObject);
begin
  MultiTitleSearchClick(Sender);
end;

procedure TFSongbase.BMoreInfoClick(Sender: TObject);
begin
  FSongDetails.Show;
end;

{
procedure TFSongbase.FormKeyPress(Sender: TObject; var Key: Char);
var iKey, iCode : integer;
begin
  if BEditSong.Enabled then begin
    if ((Key >= 'A') and (Key <='Z')) or
       ((Key >= 'a') and (Key <='z')) then begin
      FTitle.Initial := Key;
      FTitle.FileName:=FileName;
      FTitle.ShowModal;
      if FTitle.ResultSong<>-1 then SBRecNo.Position:=FTitle.ResultSong;
      SBRecNo.SetFocus;
    end;
    if ((Key >= '1') and (Key <='9')) then begin
      val( Key, iKey, iCode);
      FPreviewWindow.LoadOHP( EID.Text, iKey );
    end;
  end;
end;
}

procedure TFSongbase.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var bHandled : boolean;
begin
  // Handle our own keys first...
  LogThis( 'Main Form handling key ' + IntToStr(Key) );
  if not BTitleSearch.Enabled then exit;

  bHandled := false;
  if FSettings.cbF2F3WinSearch.Checked then begin
    if VK_F2 = Key then begin
      FSongbase.TitleSearchClick(Sender);
      bHandled := true;
    end else
    if VK_F3 = Key then begin
      FSongbase.Find1Click(Sender);
      bHandled := true;
    end;
  end;

  if not bHandled then begin
    bHandled := true;
    case Key of
      VK_UP, VK_F8:
        if CurrentlyEditing then begin
          ActiveControl := NextEditable(-1);
        end else
        if POrderItems.Visible then begin
          if (LBOrders.ItemIndex > 0) then begin
            LBOrders.ItemIndex := LBOrders.ItemIndex - 1;
            GetOrder(LBOrders.Items.Count - LBOrders.ItemIndex);
            EOrder.Text:=LBOrders.Items.Strings[LBOrders.ItemIndex];
            UpdateOrderButtons;
          end;
        end else
        if StringGrid1.DefaultDrawing then begin
          if (StringGrid1.Row > 0) then
            StringGrid1.Row := StringGrid1.Row - 1;
        end
        else if SBRecNo.Position > SBRecNo.Min then
          SBRecNo.Position := SBRecNo.Position - 1;

      VK_DOWN, VK_F9:
        if CurrentlyEditing then begin
          ActiveControl := NextEditable(1);
        end else
        if POrderItems.Visible then begin
          if (LBOrders.ItemIndex < LBOrders.Items.Count-1) then begin
            LBOrders.ItemIndex := LBOrders.ItemIndex + 1;
            GetOrder(LBOrders.Items.Count - LBOrders.ItemIndex);
            EOrder.Text:=LBOrders.Items.Strings[LBOrders.ItemIndex];
            UpdateOrderButtons;
          end;
        end else
        if StringGrid1.DefaultDrawing then begin
          if ((1+StringGrid1.Row) < StringGrid1.RowCount) then
            StringGrid1.Row := StringGrid1.Row + 1;
        end
        else if SBRecNo.Position < SBRecNo.Max then
          SBRecNo.Position := SBRecNo.Position + 1;
    else
      bHandled := IgnoreKey;
    end;
  end;
  if bHandled then Key := 0;

  if (Key<>0) and (Sender <> FProjWin) and not CurrentlyEditing then begin
    if FProjWin.Visible then begin
      LogThis( 'Passing Key onto Projection Window' );
      FProjWin.EBlind2KeyDown(Sender, Key, Shift);
    end else if (Sender <> FPreviewWindow) and FPreviewWindow.Visible then begin
      LogThis( 'Passing Key onto Preview Window' );
      FPreviewWindow.FormKeyDown( Sender, Key, Shift );
    end;
  end;
  IgnoreKey := false;

  LogThis( 'Main Form finished handling key ' + IntToStr(Key) );
end;

procedure TFSongbase.OrderAddString( sStr : string; iKey : integer; iMod : integer );
var S : string;
begin
  if not StringGrid1.DefaultDrawing then with StringGrid1 do begin
    RowCount := 1;
    DefaultDrawing := true;
    Color := clWindow;
    Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goTabs, goRowSelect, goThumbTracking ];
  end else StringGrid1.RowCount := StringGrid1.RowCount + 1;
  StringGrid1.Cells[1,StringGrid1.RowCount-1] := sStr;
  if iKey <> 0 then begin
    S := Chr(iKey);
    if iMod = 1 then S := 's' + S;
    if iMod = 2 then S := 'c' + S;
    if iMod = 3 then S := 'sc' + S;
    if iMod = 4 then S := 'a' + S;
    if iMod = 5 then S := 'sa' + S;
    if iMod = 6 then S := 'ca' + S;
    if iMod = 7 then S := 'sca' + S;
    StringGrid1.Cells[0,StringGrid1.RowCount-1] := S;
  end else begin
    StringGrid1.Cells[0,StringGrid1.RowCount-1] := '';
  end;
end;

procedure TFSongbase.StringGridUpdated(arow : integer);
var K,S : string;
    SR : SongRecord;
    B,A,j,i,code : integer;
begin
  if (not disableStringSelect) then begin
    CurrentOrderIndex := aRow;
    UpdateOrderButtons;
    S:=OrderData;
    for i:=0 to aRow do begin
      SR.Id:=copy(s,1,pos(chr128,S)-1);
      S:=copy(S,pos(chr128,S)+1,length(S));
      K:=copy(s,1,pos(chr128,s)-1);
      S:=copy(S,pos(chr128,S)+1,length(S));
    end;
    val(K,A,Code);
    val(copy(K,pos('~',K)+1,length(K)),B,Code);
    S:=StringSC(A,B);
    LogThis( 'Row String: ' + S );
    CBSC.ItemIndex:=CBSC.Items.Indexof(S);
    if SelectCellEnabled and CheckFileSave then begin
      if PageCache_EnsureID( SR.ID, j ) then begin
        OrderCurrentSong := SR.ID;
        LogThis( 'Loading Record: ' + SR.ID + '   position ' + IntToStr(j) );
        if SBRecNo.Position = j+1 then LoadRec(j+1,false)
        else SBRecNo.Position := j+1;
      end;
    end;
    StringClickDisable := true;
    ChangeList(false,false);
  end;
end;

procedure TFSongbase.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);

begin
  LogThis( 'Selecting Row ' + IntToStr(ARow) +', Column ' + IntToStr(ACol) + ' in order' );
  if StringGrid1.DefaultDrawing then begin
    StringGridUpdated(ARow);
    CanSelect:=true;
  end;
  LogThis( 'Finished selection' );
end;

procedure TFSongbase.BDropDownOrdersClick(Sender: TObject);
begin
  if not POrderItems.Visible then begin
    POrderItems.Visible   := true;
    OrderItemsSize;
    LBOrders.SetFocus;
  end else POrderItems.Visible := false;
end;

procedure TFSongbase.OrderItemsSize;
var iOrderHeight : integer;
begin
  POrderItems.Top       := POrder.Top  + POrderSelect.Top + POrderSelect.Height;
  POrderItems.Left      := POrder.Left + POrderSelect.Left;
  POrderItems.Width     := POrderSelect.Width;
  LBOrders.Width        := POrderItems.ClientWidth;
  iOrderHeight          := (LBOrders.ItemHeight * LBOrders.Items.Count);
  LBOrders.ClientHeight := Min( iOrderHeight, MAX_ORDER_HEIGHT );
  POrderItemButtons.Top := LBOrders.BoundsRect.Bottom -1;
  POrderItemButtons.Width := POrderItems.ClientWidth;
  POrderItems.ClientHeight := POrderItemButtons.Top + POrderItemButtons.Height;
end;

procedure TFSongbase.POrderItemsExit(Sender: TObject);
begin
  if ActiveControl <> BDropDownOrders then begin
    POrderItems.Visible := false;
  end;
end;

procedure TFSongbase.POrderClick(Sender: TObject);
begin
  StringGrid1.SetFocus;
end;

procedure TFSongbase.FormCreate(Sender: TObject);
var iMonitor : integer;
begin
  Randomize;

  bDisableEvents    := false;
  szDisplaySize.cx  := Screen.Width;
  szDisplaySize.cy  := Screen.Height;
  ptDisplayOrigin.X := 0;
  ptDisplayOrigin.Y := 0;
  MemStream := TMemoryStream.Create;
  Application.OnSettingChange := ApplicationSettingChanged;
  iMonitor := GetSystemMetrics( SM_CMONITORS );

  DefaultScreen    := 1;
  ProjectScreen    := 1;
  bMultiMonCapable := false;
  SetMultiMonitor( iMonitor > 1, iMonitor );
  bMultiMonitor    := bMultiMonCapable;
  if bMultiMonitor then szDisplaySize := szMultiMonSize;

  // Set up the initial screen
  rTextArea.Left   := 0;
  rTextArea.Top    := 0;
  rTextArea.Right  := szDisplaySize.cx;
  rTextArea.Bottom := szDisplaySize.cy;

  rCCLIArea.Left   := 0;
  rCCLIArea.Top    := (szDisplaySize.cy * 8) div 10;
  rCCLIArea.Right  := (szDisplaySize.cx * 7) div 20;
  rCCLIArea.Bottom := szDisplaySize.cy;

  rCopyArea.Top    := rCCLIArea.Top;
  rCopyArea.Bottom := rCCLIArea.Bottom;
  rCopyArea.Left   := (szDisplaySize.cx * 13) div 20;
  rCopyArea.Right  := szDisplaySize.cx;

  StringClickDisable := false;
  OrderCurrentSong := '';
  BProjectReady := false;
  EditingSong := false;
  EnableLogging := true;
  SelectCellEnabled := true;
  PageCache_Initialise;
  IgnoreKey := false;
  bIgnoreDoubleClicks  := false;  // by default 'double click' protection is disabled
  DoubleClickDelay := GetDoubleClickTime();

  // Set the default temporary directory
  TempHost := GetTempDirectory;
  bSetTemp := false;

  SetLength( EditableControls, 6 );
  EditableControls[0] := ETitle;
  EditableControls[1] := EAltTitle;
  EditableControls[2] := EAuthor;
  EditableControls[3] := ECopyright;
  EditableControls[4] := ECopDate;
  EditableControls[5] := EOfficeNo;
//  web_lock := TCriticalSection.Create;

end;

procedure TFSongbase.ApplicationSettingChanged(Sender: TObject; Flag: Integer; const Section: string; var Result: Longint);
var bMon, bOldMon : boolean;
    iMonitor      : integer;
    szPrimary     : size;
begin
  LogThis( 'Application Setting Changed' );

  if Section <> 'Windows' then exit;

  // Have we gone from one-monitor to two or vice-versa?
  iMonitor         := GetSystemMetrics( SM_CMONITORS );
  bMultiMonCapable := (iMonitor > 1);
  bOldMon          := bMultiMonitor;
  if not bMultiMonCapable then bMultiMonitor := false;

  bMon := false;
  SetMultiMonitor( bMon, iMonitor );

  // IMPROVE: Don't close the live window on a resolution change!
  if (bMultiMonitor <> bOldMon) and FProjWin.Visible then FProjWin.Close;
  if bMultiMonitor then begin
    ChangeResolution( szMultiMonSize );
  end else begin
    szPrimary.cx := Monitor.Width;
    szPrimary.cy := Monitor.Height;
    ChangeResolution( szPrimary );
   end;

  if FSettings.Visible then begin
    FSettings.FormShow(Self);
  end;
  if FProjWin.Visible    then FProjWin.FormShow(FProjWin);
  if FLiveWindow.Visible then FLiveWindow.Invalidate;

  // Update the double click time
  DoubleClickDelay := GetDoubleClickTime();
end;

procedure TFSongbase.SetMultiMonitor( bMultiMon : boolean; iMonitorCount : integer );
begin
  ImgMultiMon.Visible := bMultiMon;
  bMultiMonCapable    := bMultiMon;
  EnumDisplayMonitors( 0, nil, MultiMonEnumCallback, 0 );

  LogThis( 'Multimonitor support: ' + BoolToStr(bMultiMonitor, true) );
end;

function MultiMonEnumCallback(hm: HMONITOR; dc: HDC; r: PRect; l: LPARAM): Boolean; stdcall;
begin
  if hm <> FSongbase.Monitor.HANDLE then begin
    FSongbase.bMultiMonCapable := true;
    FSongbase.DefaultScreen := FSongbase.GetMonitorNum( hm );
    FSongbase.ProjectScreen := FSongbase.DefaultScreen;
    FSongbase.szMultiMonSize.cx := r.Right  - r.Left;
    FSongbase.szMultiMonSize.cy := r.Bottom - r.Top;
    FSongbase.ptDisplayOrigin.X := r.Left;
    FSongbase.ptDisplayOrigin.Y := r.Top;
    LogThis( 'Display monitor: ' + IntToStr(FSongbase.szDisplaySize.cx) +'x'+ IntToStr(FSongbase.szDisplaySize.cy)
                                 + ' ' + IntToStr(FSongbase.ptDisplayOrigin.X) + ',' + IntToStr(FSongbase.ptDisplayOrigin.y) );
  end;
end;

procedure TFSongbase.BExpandPanelClick(Sender: TObject);
begin
  if bPanelExpanded then begin
    BExpandPanel.Glyph.LoadFromResourceName(HInstance,'DOWNARR');
    BExpandPanel.Hint := 'Click to reveal more details about this song';
    SetPanelStateExpanded(false);
  end else begin
    BExpandPanel.Glyph.LoadFromResourceName(HInstance,'UPARR');
    BExpandPanel.Hint := 'Click to hide some details about this song';
    SetPanelStateExpanded(true);
  end;
end;

procedure TFSongbase.SetPanelStateExpanded( bExpanded : boolean );
begin
  if false = bExpanded then begin
    PHides.Visible   := false;
    PSongWords.Top   := PHides.Top + 3;
    BExpandPanel.Top := PSongWords.Top + PSongWords.Height - BExpandPanel.Height + 7;
    PSongInfo.Height := BExpandPanel.BoundsRect.Bottom + 1;
    PSaved.Top       := PSongInfo.Height - PSaved.Height - 6;
    PSongWords.Left  := BExpandPanel.Left - PSongWords.Width - 10;
  end else begin
    PHides.Visible   := true;
    PSongInfo.Height := PHides.Top + PHides.Height + 4;
    PSongWords.Top   := EOfficeNo.Top + PHides.Top;
    PSongWords.Left  := BMoreInfo.Left + PHides.Left;
    PSaved.Top       := PSongInfo.Height - PSaved.Height - 6;
    BExpandPanel.Top := PSongInfo.ClientRect.Bottom - BExpandPanel.Height - 1;
  end;
  PSongScroll.Height := PSongInfo.Height + PSongInfo.Top + 2;
  POrder.Top         := PSongScroll.BoundsRect.Bottom + 6;
  Self.Height        := POrder.BoundsRect.Bottom + SBInfo.Height + 48;
  bPanelExpanded     := bExpanded;
end;

procedure TFSongbase.BPreviewHidClick(Sender: TObject);
begin
  if not FPreviewWindow.Visible then begin
    FPreviewWindow.Show;
  end;
end;

procedure TFSongbase.PreviewID( ID : string );
var iIdx : integer;
begin
  if PageCache_EnsureID( ID, iIdx ) then begin
    SBRecNo.Position := 1+iIdx;
  end;
end;

procedure TFSongbase.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  LogThis( 'Main Form Close query' );
  if FLiveWindow.Visible then FLiveWindow.close;
  CanClose := not FLiveWindow.Visible;
  LogThis( 'Main Form Closing? ' + BoolToStr(CanClose,true) );
end;

procedure TFSongbase.Help2Click(Sender: TObject);
begin
  FHelpWindow.Show;
end;

procedure TFSongbase.CleanUpDatabase;
var
  fos: TSHFileOpStruct;
  sTempDir : string;
begin
  sTempDir := ExcludeTrailingPathDelimiter(TempDir);
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc  := FO_DELETE;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    pFrom  := PChar(sTempDir + #0);
  end;
  ShFileOperation(fos);
end;

procedure TFSongbase.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and (StringGrid1.Row <> -1) then begin
    BRemFromOrder.Click;
  end;
end;

procedure TFSongbase.StringGrid1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var iRow : integer;
    CanSelect : boolean;
begin
  if not StringClickDisable and StringGrid1.DefaultDrawing then begin
    // If it's the same as the current row then 'SelectCell' should
    // handle it, otherwise check if we need to restore the current item.
    iRow := Y div StringGrid1.DefaultRowHeight;
    if (iRow = StringGrid1.Row) and (EID.Text <> OrderCurrentSong) then begin
      StringGrid1SelectCell(Sender, 1, iRow, CanSelect );
    end;
  end;
  StringClickDisable := false;
end;


procedure TFSongbase.WMWindowPosChanging(var hMsg: TWMWindowPosChanging);
var rBadRect, rCurRect : TRect;
var ptBadCentre : TPoint;
begin
  // Only restrict access once projection form is visible
  if FSongbase.BProjectReady and FProjWin.Visible then begin
    LogThis( 'Main window pos changing' );

    // Get the desktop rectangle that we don't want to let this screen have
    // any intersections with.
    rBadRect := Rect( FSongbase.ptDisplayOrigin.X,
                      FSongbase.ptDisplayOrigin.Y,
                      FSongbase.ptDisplayOrigin.X + FSongbase.szDisplaySize.cx,
                      FSongbase.ptDisplayOrigin.Y + FSongbase.szDisplaySize.cy );
    rCurRect := Rect( hMsg.WindowPos.x, hMsg.WindowPos.y,
                      hMsg.WindowPos.x + Width, hMsg.WindowPos.y + Height );

    // Work out centre of 'illegal' area so we can work out which side to push off
    ptBadCentre.X := FSongbase.ptDisplayOrigin.X + (FSongbase.szDisplaySize.cx div 2);
    ptBadCentre.Y := FSongbase.ptDisplayOrigin.Y + (FSongbase.szDisplaySize.cy div 2);

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

    LogThis( 'Main window pos constricted to ' + IntToStr(rCurRect.Left) +',' + IntToStr(rCurRect.Top) );
  end;
  inherited;
end;

function TFSongbase.CurrentlyEditing : boolean;
begin
  CurrentlyEditing := false;
  if EditingSong then
    if (ActiveControl = ETitle)   or (ActiveControl = EAltTitle)  or
       (ActiveControl = EAuthor)  or (ActiveControl = ECopyright) or
       (ActiveControl = ECopDate) or (ActiveControl = EOfficeNo)  then
      CurrentlyEditing := true;
  if ActiveControl = EOrder then
    CurrentlyEditing := true;
end;

function TFSongbase.OrderContainsSong( ID : string ) : boolean;
var S, Item : string;
    bFound  : boolean;
begin
  bFound := false;
  S      := OrderData;
  while (S<>'') and (not bFound) do begin
    Item := copy(S,0,pos(chr128,S)-1);
    S    := copy(S,pos(chr128,S)+1,length(S));
    if( Item = ID ) then bFound := true;
    S:=copy(S,pos(chr128,S)+1,length(S));
  end;
  OrderContainsSong := bFound;
end;

procedure TFSongbase.CMDialogKey(var Message: TCMDialogKey);
begin
  if not CurrentlyEditing then begin
    if (Message.Charcode = VK_RETURN) or (Message.Charcode = VK_SPACE) then begin
      if POrderItems.Visible then IgnoreKey := true;
      ActiveControl := nil;
      Message.Charcode := 0;
    end;
    if (Message.Charcode = VK_DOWN) or (Message.Charcode = VK_UP) or
       (Message.Charcode = VK_RIGHT) or (Message.Charcode = VK_LEFT) then begin
      Message.Charcode := 0;
    end;
  end;
  inherited;
end;

function TFSongbase.NextEditable( iDiff : integer ) : TWinControl;
var iIdx, iNextIdx, iLastVisible : integer;
begin
  // Firstly, lets find it.
  NextEditable := Self.ActiveControl;
  if bPanelExpanded then iLastVisible := 5
                    else iLastVisible := 2;

  for iIdx := 0 to 5 do begin
    if EditableControls[iIdx] = ActiveControl then begin
      // Now pick the 'next' one.
      iNextIdx := iIdx + iDiff;
      if (iNextIdx >= 0) and (iNextIdx <= iLastVisible) then begin
        NextEditable := EditableControls[iNextIdx];
      end;
    end;
  end;
end;


function TFSongbase.LoadUnzippedRTF( hRichEdit : TRichEdit; sZIP, sFile : string ) : boolean;
var
  s: string;
begin
  // Get the file
  LoadUnzippedRTF := false;
  if not GetFileDataFromZip( sZip, sFile, S, false ) then Exit;

  // Then write it into the memory stream
  MemStream.Clear;
  MemStream.WriteBuffer(Pointer(S)^, Length(S));
  MemStream.Position := 0;

  // Now load into the richedit control
  hRichEdit.PlainText := False;
  hRichEdit.Clear;
  hRichEdit.Lines.LoadFromStream(MemStream);

  // Then cleanup
  LoadUnzippedRTF := true;
end;

procedure TFSongbase.FormDestroy(Sender: TObject);
begin
//  web_lock.Free;
  MemStream.Free;
  PageCache_Finalise;
end;

function TFSongbase.GetMonitorNum( hm : HMONITOR ) : integer;
var i : integer;
begin
  for i := 0 to Screen.MonitorCount-1 do begin
    if hm = Screen.Monitors[i].Handle then begin
      Result := 1+i;
      Exit;
    end;
  end;
  Result := 0;
end;


function TFSongbase.EnsureTemporaryDirectory : boolean;
var bResult : boolean;
    iFH : integer;
begin
  bResult := false;
  repeat
    // Ensure that the 'host' Temporary directory exists - if
    // it doesn't then ask them to select another.
    while (TempHost = '') or not DirectoryExists( TempHost ) do begin
      if mrYes = MessageDlg( 'Temporary Directory "' + TempHost + '" does not exist, create it?',
                              mtWarning, [mbYes, mbNo], 0 ) then begin
        if CreateDir(TempHost) and DirectoryExists( TempHost ) then begin
          break;
        end;
        messagedlg('Failed to create directory "'+ TempHost +'"', mtError,[mbOk],0);
      end;

      // They clicked 'no', or we failed to create it - so give them
      // a choice about where they want to put it instead
      TempHost := FSettings.BrowseForFolder( 'Select Temporary Directory', TempHost );
    end;

    // Now try and create the 'Songbase' directory within.
    TempDir := TempHost + '\' + APPNAME;
    if not DirectoryExists(TempDir) then begin
      if false = CreateDir(TempDir) then begin
        messagedlg('Failed to create directory "'+ TempDir +'"', mtError,[mbOk],0);
        TempHost := '';
        continue;
      end;
    end;

    // Try to create a file in it, then remove it again
    iFH := FileCreate( TempDir + 'temp.txt' );
    if -1 = iFH then begin
      messagedlg('Directory "'+ TempDir +'" was not writable.', mtError,[mbOk],0);
      TempHost := '';
      continue;
    end;
    CloseHandle(iFH);

    if false = DeleteFile( TempDir + 'temp.txt' ) then begin
      messagedlg('This user does not have "delete" permissions in "'+ TempDir +'"', mtError,[mbOk],0);
      LogThis( 'Error: '+ IntToStr(GetLastError) );
      TempHost := '';
      continue;
    end;

    // Otherwise, if we got here, we can get out
    bResult := true;
    TempDir := TempDir + '\';
  until bResult;

  EnsureTemporaryDirectory := bResult;
end;

procedure TFSongbase.ExportCCLIasCSV1Click(Sender: TObject);
var TF : TextFile;
    DF : TextFile;
    S : String;
    SR : SongRecord;
    shortDate : string;
begin
  if ((FSettings.EOrg.Text='') or (FSettings.ECustRef.Text='') or
    (FSettings.ELicense.Text='')) then begin
    messagedlg('Missing CCLI Information. Please check Tools, Settings, CCLI',mtError,[mbOk],0);
  end else begin
    SaveDialog1.Filter:='Comma-separated Values (*.csv)|*.CSV';
    shortDate:=DateTimeToStr(FSettings.DTExpiry.Date);
    shortDate:=copy(shortDate,0,pos(' ',shortDate)-1);
    delete(shortDate,length(shortDate)-3,2);
    while (pos('/',shortDate)>=1) do
      shortDate:=copy(shortDate,1,pos('/',shortDate)-1)+copy(shortDate,pos('/',shortDate)+1,length(shortDate));
    SaveDialog1.FileName:='CopyReport_Report_'+FSettings.ECustRef.Text+'_'+shortDate+'.csv';
    if (SaveDialog1.Execute) then begin
      assignfile(TF,SaveDialog1.FileName);
      rewrite(TF);
      writeln(TF,'Type=Copy Report');
      writeln(TF,'Layout=1');
      writeln(TF,'ComVresion=2.1.6.1');
      shortDate:=DateTimeToStr(now());
      shortDate:=copy(shortDate,0,pos(' ',shortDate)-1);
      writeln(TF,'DataCreated='+shortDate);
      writeCCLIInfo(TF);
      writeln(TF,'');
      writeln(TF,'WordsID,MusicID,BookID,Print,Project,Record,Photocopy,CustomArrangement,Title,Author,Copyright,Number,Book,Publisher,ISBN,Catalog,Administrator');
      if OpenForRead(DF,FileName) then begin
        while not eof(DF) do begin
          readln(DF,S);
          DeLimit(S,SR);
          if (SR.Trans='1') or (SR.OHP='1') or (SR.Sheet='1') or (SR.Photo='1') or (SR.Rec='1') then begin
            s:=SR.OfficeNo+',-1,-1,';
            if (SR.Sheet='1') then S:=S+'1,' else s:=S+'0,';
            if (SR.Trans='1') or (SR.OHP='1') then s:=s+'1,' else s:=s+'0,';
            if (SR.Rec='1') then S:=S+'1,' else s:=S+'0,';
            if (SR.Photo='1') then S:=S+'1,' else S:=S+'0,';
            S:=S+'0,'; {Custom Arrangement!}
            S:=S+stripCommas(SR.Title)+','+stripCommas(SR.Author)+','+stripCommas(SR.CopDate)+' '+StripCommas(SR.CopyRight)+',,,,,'+StripCommas(SR.CopyRight)+','+StripCommas(SR.CopyRight);
            writeln(TF,S);
          end;
        end;
        flush(TF);
        closefile(TF);
        closetextfile(DF,'');
      end;
    end;
  end;
end;

procedure TFSongbase.RenderSearchText( hCanvas : TCanvas; x, y : integer; hFont : TFont;
                                        hFG : TColor = clWhite; hHL :TColor = clYellow );
var i : integer;
begin
  if FProjWin.Visible and FProjWin.bShowHighlight then begin
    hCanvas.Font       := hFont;
    hCanvas.Font.Color := hFG;
    i := x - hCanvas.TextWidth( FProjWin.GHighlight );
    hCanvas.TextOut( i, y, FProjWin.GHighlight );

    hCanvas.Font.Style := hCanvas.Font.Style + [fsUnderline];
    hCanvas.Font.Color := hHL;
    hCanvas.TextOut( i, y, FilterString(
                  FProjWin.GHighlight, FProjWin.SearchString ) );
  end;
end;

function TFSongbase.FilterString( sTitle, sSearch : string ) : string;
var len, i : integer;
    s, sFilter : string;
begin
  len := Length(sTitle);
  i   := Length(sSearch);
  repeat
    sFilter := Copy(sTitle, 0, i);
    inc(i);
    s := CapNoPunc(sFilter);
  until (s >= sSearch) or (i > len);
  if (s > sSearch) or (i > len) then sFilter := '';
  Result := sFilter;
end;

procedure TFSongbase.ExportSong1Click(Sender: TObject);
begin
  FExport.Show();
end;

// Update scale offsets to account for changes in monitor size
procedure TFSongbase.rescaleOffsets( szOldSize, szNewSize : size );
begin
  if (szOldSize.cy <= 0) or (szOldSize.cx <= 0) then exit;

  rTextArea.Left   := (szNewSize.cx * rTextArea.Left   ) div szOldSize.cx;
  rTextArea.Right  := (szNewSize.cx * rTextArea.Right  ) div szOldSize.cx;
  rTextArea.Top    := (szNewSize.cy * rTextArea.Top    ) div szOldSize.cy;
  rTextArea.Bottom := (szNewSize.cy * rTextArea.Bottom ) div szOldSize.cy;

  rCopyArea.Left   := (szNewSize.cx * rCopyArea.Left   ) div szOldSize.cx;
  rCopyArea.Right  := (szNewSize.cx * rCopyArea.Right  ) div szOldSize.cx;
  rCopyArea.Top    := (szNewSize.cy * rCopyArea.Top    ) div szOldSize.cy;
  rCopyArea.Bottom := (szNewSize.cy * rCopyArea.Bottom ) div szOldSize.cy;

  rCCLIArea.Left   := (szNewSize.cx * rCCLIArea.Left   ) div szOldSize.cx;
  rCCLIArea.Right  := (szNewSize.cx * rCCLIArea.Right  ) div szOldSize.cx;
  rCCLIArea.Top    := (szNewSize.cy * rCCLIArea.Top    ) div szOldSize.cy;
  rCCLIArea.Bottom := (szNewSize.cy * rCCLIArea.Bottom ) div szOldSize.cy;
end;

procedure TFSongbase.SetImageSize( hOwner : TComponent; var hImg : TImage; iWidth, iHeight : integer );
begin
  if hImg <> nil then begin
    if (hImg.Width = iWidth) and (hImg.Height = iHeight) then
      Exit;

    // Otherwise, destroy the image so we can replace it
    hImg.Free;
  end;

  hImg := TImage.Create(hOwner);
  hImg.SetBounds( 0,0, iWidth, iHeight );
end;

function TFSongbase.AddItemToOrder( ID : string; bSelect : boolean = false ) : string;
var S,K,Got : String;
    I,Code : integer;
    A,B : Word;
begin
  Got := '1';

  // Don't go for the NEXT AVAILBLE shortcut, go for the LAST shortcut
  i := LastDelimiter( chr128, OrderData );
  if i > 0 then begin
    S := copy( OrderData, 0, i-1 );
    i := LastDelimiter( chr128, S );
  end;
  if i > 0 then begin
    K := copy( S, i+1, Length(S) );
    S := copy( S, 0, i-1 );
    i := LastDelimiter( chr128, S );
    if i <> -1 then begin
      S := copy( S, i+1, length(s) );

      // Get the key codes
      val(K,A,Code);
      val(copy(K,pos('~',K)+1,length(K)),B,Code);
      K := StringSC(A,B);

      // Find this item in the CBSC list
      i := 1;
      while i < CBSC.Items.Count do begin
        if K = CBSC.Items.Strings[i] then begin
          inc(i);
          if i < CBSC.Items.Count then Got := CBSC.Items.Strings[i]
                                  else Got := CBSC.Items.Strings[NextShortcut()];
          break;  // then get the next item
        end;
        inc(i);
      end;
    end;
  end;

  // Get the key values
  S:=Got;
  A:=0;
  if pos('Shift',S)>0 then A:=A+1;
  if pos('Ctrl',S)>0 then A:=A+2;
  if pos('Alt',S)>0 then A:=A+4;
  while pos('+',S)>0 do S:=copy(S,pos('+',S)+1,length(S));
  B:=ord(S[1]);

  S:= IntToStr(A) + '~' + IntToStr(B);
  OrderData := OrderData+ID+chr128+S+chr128;
  FSongbase.ShowOrder(OrderData);
  OverwriteOrder(OrigOrderName,Orderfile,OrderData);

  if bSelect and (StringGrid1.RowCount > 0) then StringGrid1.Row := StringGrid1.RowCount-1;
  Result := Got;
end;

procedure TFSongbase.ChangeResolution( szNewSize : size );
var szOldSize : size;
begin
  szOldSize := FSongbase.szDisplaySize;
  if (szOldSize.cx <> szNewSize.cx) or
     (szOldSize.cy <> szNewSize.cy) then begin
    FSongbase.szDisplaySize := szNewSize;
    FSongbase.rescaleOffsets( szOldSize, FSongbase.szDisplaySize );
    FSettings.EOffsets.Text  := '(' + IntToStr( FSongbase.rTextArea.Left   ) + 'px,'  +
                                      IntToStr( FSongbase.rTextArea.Top    ) + 'px) -> (' +
                                      IntToStr( FSongbase.rTextArea.Right  ) + 'px,'  +
                                      IntToStr( FSongbase.rTextArea.Bottom ) + 'px)';
  end;
end;

procedure TFSongbase.Showallsongs1Click(Sender: TObject);
begin
  FSonglist.Show;
end;

procedure TFSongbase.MRunNetworkClick(Sender: TObject);
begin
  FNetSetup.Left:=20;
  FNetSEtup.Top:=20;
  FNetSetup.ShowModal;

end;


procedure TFSongbase.downloadFile(remoteFile, localFile : string);
var stream : TMemoryStream;
begin
  stream:=TMemoryStream.Create;
  try
    try
      idHttp.get(remoteFile, stream);
      if fileexists(localFile) then deletefile(localFile);
      stream.SaveToFile(LocalFile);
    except
    end;
  finally
    stream.free;
  end;
end;

procedure TFSongbase.MUpdateClick(Sender: TObject);
var TF : TextFile;
    S : string;
    first : boolean;
begin
  first:=true;
  downloadFile('http://www.teapotrecords.co.uk/bfree/Songbase/sbupdate.php?v='+intToStr(VERSION_INTERNAL),'update.txt');
  assignfile(Tf,'update.txt');
  reset(TF);
  readln(TF,S);
  if (S='OK') then begin
    MessageDlg('You already have the latest version',mtInformation,[mbOk],0);
    closefile(TF);
  end else if (S='UP') then begin
    readln(TF,S);
    FUpdate.LUpdateVer.Caption:='Version '+S+' is now available for update.';
    FUpdate.MUpdateVerText.Lines.Clear;
    readln(TF,S);
    while (S<>'END') do begin
      if (copy(S,1,7)='Changes') and (not first) then begin
        Fupdate.MUpdateVerText.Lines.add('');
      end;
      FUpdate.MUpdateVerText.Lines.Add(S);
      if (copy(S,1,7)='Changes') then begin
        first:=false;
        FUpdate.MUpdateVerText.Lines.Add('---------------------------------------------------');
      end;
      readln(TF,S);
    end;
    readln(TF,S);
    FUpdate.Files.Clear;
    FUpdate.Dests.Clear;
    while (S<>'END') do begin
      FUpdate.Files.Add(copy(S,6,length(S)));
      readln(TF,S);
      FUpdate.Dests.Add(copy(S,4,length(S)));
      readln(TF,S);
    end;
    closefile(TF);
    FUpdate.Left:=FSongbase.Left+50;
    FUpdate.Top:=FSongBase.Top+50;
    FUpdate.ShowModal;
  end else if (S='DEBUG') then begin
    MessageDlg('You have a version from the future. Perhaps you are developing Songbase.',mtInformation,[mbOk],0);
    closefile(TF);

  end;
end;

end.

