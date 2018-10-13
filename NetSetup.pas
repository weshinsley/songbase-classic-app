unit NetSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, WinSock, SyncObjs, IdGlobal, SBFiles, SBMain, Grids,
  IdBaseComponent, IdCoder, IdCoder3to4, IdCoderMIME, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP;
type
  TestHttpThread = class(TThread)
  private
    URL : string;
    test_row : integer;
  public
    procedure Execute; override;        
  end;

  TFNetSetup = class(TForm)
    BOk: TButton;
    BCancel: TButton;
    GBListeners: TGroupBox;
    GBLaunchers: TGroupBox;
    LInterface: TLabel;
    CBIPs: TComboBox;
    LPort: TLabel;
    EPort: TEdit;
    CBEnabled: TCheckBox;
    LEnable: TLabel;
    SGScreens: TStringGrid;
    BAddScreen: TButton;
    BRemoveScreen: TButton;
    IdEncoderMIME1: TIdEncoderMIME;
    IdHTTP1: TIdHTTP;
    BTestScreens: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EPortChange(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
    procedure BOkClick(Sender: TObject);
    procedure SGScreensDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SGScreensMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SGScreensClick(Sender: TObject);
    procedure BRemoveScreenClick(Sender: TObject);
    procedure BAddScreenClick(Sender: TObject);
    procedure BTestScreensClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    LocalIP : string;
    port : string;
    enabled : boolean;
    CheckList : TStringList;
  end;

var
  FNetSetup: TFNetSetup;
  ippref : string;


implementation

uses WebServer, AddScreen;

{$R *.dfm}

procedure TestHttpThread.Execute;
var Result : string;
    http : TIdHTTP;
    postage : TStringList;
begin
  http:=TIdHTTP.Create(FWebServer);
  postage := TStringList.Create;
  Result := 'FAIL';
  try
    postage.Add('command=info');
    Result:=http.Post(url,postage);
  except
    Result:='FAIL';
  end;
  postage.free;
  http.free;
  FNetSetup.SGScreens.Cells[3,test_row]:=Result;

end;

procedure TFNetSetup.FormShow(Sender: TObject);
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  Buffer: array[0..63] of Char;
  iI : integer;
  Pptr : PaPInAddr;
  pHE: PHostEnt;
  GInitData: TWSAData;
  s : string;
  clearRect : TGridRect;
begin
  s:='127.0.0.1';
  CBIps.Items.Clear;
  WSAStartup($101, GInitData);
  GetHostname(Buffer, sizeof(Buffer));
  pHE:=GetHostByName(buffer);
  if (pHE<>nil) then begin
    s:='';
    PPtr:=PaPInAddr(pHE^.H_Addr_List);
    iI:=0;
    while (pPtr^[iI]<>nil) do begin
      s:=Inet_NToA(PPtr^[iI]^);
      CBIps.Items.Add(s);
      inc(iI);
    end;
    WSACleanup;
  end;
  for ii:=0 to CBIps.Items.COunt-1 do begin
    if (CBIps.Items[ii]=LocalIP) then CBIps.ItemIndex:=ii;
  end;
  EPort.Text:=Port;
  CBEnabled.Checked:=(enabled);
  clearRect.Top:=-1;
  clearRect.Bottom:=-1;
  clearRect.Left:=-1;
  clearRect.Right:=-1;
  SGScreens.Selection:=clearRect;
  BRemoveScreen.Enabled:=false;
end;

procedure TFNetSetup.EPortChange(Sender: TObject);
var p : integer;
begin
  if (not tryStrToInt(EPort.Text,p)) then EPort.Text:='8080';
end;

procedure TFNetSetup.BCancelClick(Sender: TObject);
begin
  close;
end;

procedure TFNetSetup.BOkClick(Sender: TObject);
var p : integer;
begin
  close;
  localIP:=CBIps.Items[CBIps.ItemIndex];
  if (tryStrToInt(EPort.Text,p)) then port:=EPort.Text;
  enabled:=CBEnabled.Checked;
  FWebServer.serverEnabled(enabled);
  saveParams(INIFile);
end;

procedure TFNetSetup.FormCreate(Sender: TObject);
begin
  port:='8080';
  LocalIP:='127.0.0.1';
  enabled:=false;
  SGScreens.ColCount:=4;
  SGScreens.ColWidths[0]:=200;
  SGSCreens.ColWidths[1]:=trunc((SGScreens.Width-212)/3);
  SGSCreens.ColWidths[2]:=trunc((SGScreens.Width-212)/3);
  SGSCreens.ColWidths[3]:=trunc((SGScreens.Width-212)/3);
  SGScreens.FixedRows:=1;
  SGScreens.FixedCols:=0;
  SGScreens.RowCount:=2;
  SGScreens.Cells[0,0]:='Server URL';
  SGScreens.Cells[1,0]:='Port';
  SGScreens.Cells[2,0]:='Use';
  SGScreens.Cells[3,0]:='Test';
  BAddScreen.Enabled:=true;
  BRemoveScreen.Enabled:=false;
  BTestScreens.Enabled:=false;
  CheckList:=TStringList.Create;
  CheckList.Add('Y');
end;

procedure TFNetSetup.SGScreensDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  PADDING = 15;
var
  s: TSize;
  r: TRect;
  but : integer;
  SavedAlign : integer;
  St : String;
begin
  if (ACol = 2) and (ARow >= 1) then begin
    FillRect(SGScreens.Canvas.Handle, Rect, GetStockObject(WHITE_BRUSH));
    s.cx := GetSystemMetrics(SM_CXMENUCHECK);
    s.cy := GetSystemMetrics(SM_CYMENUCHECK);
    r.Top := Rect.Top + (Rect.Bottom - Rect.Top - s.cy) div 2;
    r.Bottom := r.Top + s.cy;
    r.Left := Rect.Left + PADDING;
    r.Right := r.Left + s.cx;
    if (ARow-1<CheckList.Count) then begin
      if (CheckList.Strings[ARow-1]='Y') then but:=DFCS_CHECKED
      else but:=DFCS_BUTTONCHECK;
      DrawFrameControl(SGScreens.Canvas.Handle, r, DFC_BUTTON, but);
    end;
  end else if (ACol>=1) then begin
    St := SGScreens.Cells[ACol, ARow]; // cell contents
    SavedAlign := SetTextAlign(SGScreens.Canvas.Handle, TA_CENTER);
    SGScreens.Canvas.TextRect(Rect,
      Rect.Left + (Rect.Right - Rect.Left) div 2, Rect.Top + 2, St);
    SetTextAlign(SGScreens.Canvas.Handle, SavedAlign);
  end;
end;

procedure TFNetSetup.SGScreensMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var ACol, ARow : integer;
begin
  if button = mbleft then begin
    SGScreens.MouseToCell(X, Y, ACol, ARow);
    if (ACol>=0) and (ACol<SGSCreens.ColCount) and (ARow>0) and (ARow<SGSCreens.RowCount) then begin
      SGScreens.Col := ACol;
      SGScreens.Row := ARow;
      if (ARow-1<CheckList.Count) then begin
        if (ACol=2) and (ARow>=1) then begin
          if CheckList.Strings[ARow-1]='Y' then begin
            CheckList.Strings[ARow-1]:='N';
          end else begin
            CheckList.Strings[ARow-1]:='Y';
          end;
        end;
      end;
    end;

    SGScreens.Update;
    SGSCreens.Repaint;
    sBFiles.saveParams(SBMain.INIFile);

  end;
end;

procedure TFNetSetup.SGScreensClick(Sender: TObject);
var sel_top,sel_bottom : integer;
begin
  sel_top:=SGScreens.Selection.Top;
  sel_bottom:=SGSCreens.Selection.Bottom;

  // Selection index starts from 1...
  if (sel_top>0) and (sel_bottom<=CheckList.Count) then begin
    BRemoveScreen.Enabled:=true;
    BTestScreens.Enabled:=true;
  end else begin
    BRemoveScreen.Enabled:=false;
    BTestScreens.Enabled:=false;
  end;
end;


procedure TFNetSetup.BRemoveScreenClick(Sender: TObject);
var sel_top, sel_bottom : integer;
    s1,s2 : string;
    i,j : integer;
Const
   NoSelection : TGridRect = (Left:-1; Top:-1; Right:-1; Bottom:-1 );
begin
  if (messageDlg('Confirm, delete screen?',mtConfirmation,[mbYes,mbCancel],0)=mrYes) then begin
    sel_top:=SGScreens.Selection.Top;
    sel_bottom:=SGScreens.Selection.Bottom;
    str(sel_top,s1);
    str(sel_bottom,s2);
    for i:=sel_bottom downto sel_top do begin
      CheckList.Delete(i-1);
      for j := 0 to SGScreens.ColCount do SGScreens.Cells[j, i]:='';
      for j := i to SGScreens.RowCount - 2 do
        SGScreens.Rows[j].Assign(SGScreens.Rows[j + 1]);
    end;
  end;
  SGScreens.RowCount := max(2, 1 + CheckList.Count);
  SGScreens.Selection:=NoSelection;
  SGScreensClick(Sender);
  sBFiles.saveParams(SBMain.INIFile);
end;

procedure TFNetSetup.BAddScreenClick(Sender: TObject);
var i : integer;
    found : boolean;
    ps : string;
Const
   NoSelection : TGridRect = (Left:-1; Top:-1; Right:-1; Bottom:-1 );
begin
  FAddScreen.ShowModal;
  found:=false;
  if (FAddScreen.Port<>-1) then begin
    for i:=0 to (CheckList.Count-1) do begin
      if (SGScreens.Cells[0,i+1]=FAddScreen.server) then begin
        found:=true;
      end;
    end;
    if (not found) then begin
      CheckList.Add('N');
      SGScreens.RowCount:=1+CheckList.Count;
      SGScreens.Cells[0,CheckList.Count]:=FAddScreen.server;
      str(FAddScreen.port,ps);
      SGScreens.Cells[1,CheckList.Count]:=ps;
      sBFiles.saveParams(SBMain.INIFile);
      SGScreens.Selection:=NoSelection;
      SGScreensClick(Sender);
    end;
  end;
  SGScreens.Repaint;
end;

procedure TFNetSetup.BTestScreensClick(Sender: TObject);
var sel_top, sel_bottom : integer;
    s1,s2 : string;
    i : integer;
    testThread : TestHttpThread;
begin
  sel_top:=SGScreens.Selection.Top;
  sel_bottom:=SGScreens.Selection.Bottom;
  str(sel_top,s1);
  str(sel_bottom,s2);
  for i:=sel_bottom downto sel_top do begin
    testThread:=TestHttpThread.Create(true);
    testThread.URL:=SGScreens.Cells[0,i]+':'+SGScreens.Cells[1,i];
    testThread.test_row:=i;
    testThread.Resume;
  end;
end;

end.
