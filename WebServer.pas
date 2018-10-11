unit WebServer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPServer, IdCustomHTTPServer,
  IdHTTPServer, IdHTTP, idSocketHandle, IdGlobal, WinSock, Grids, PageCache, SBFiles, SearchThread,
  StdCtrls, ComCtrls, IdCoder, IdCoder3to4, IdCoderMIME, IdTCPConnection,
  IdTCPClient;

type
  HTTPThread = class(TThread)
  private
    URL : string;
    postage : TStringList;
  public
    procedure Execute; override;
  end;

  TFWebServer = class(TForm)
    WebServer: TIdHTTPServer;
    RichEdit1: TRichEdit;
    RichEdit2: TRichEdit;
    IdHTTP1: TIdHTTP;
    IdEncoderMIME1: TIdEncoderMIME;
    procedure WebServerCommandGet(Thread: TIdPeerThread;
      RequestInfo: TIdHTTPRequestInfo;
      ResponseInfo: TIdHTTPResponseInfo);
    function GetMIMEType(sFile: TFileName): String;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure writeDefaultFiles();
    function getFirstLines() : string;
    procedure syncRequestSong();
    procedure syncRequestPart();
    procedure syncSelectIndex();
    procedure sendToScreens(rtf : string);
    function notMatch(s1 : string; s2 : string): boolean;
  private

  public

    last_page : word;
    ListText : string;
    SearchResults : string;
    NoSearchResults : integer;
    PageRTF : string;
    PageRTF_Textformat : string;
    function serverEnabled(b : boolean) : boolean;
    function isServerEnabled() : boolean;
    procedure nextPageTicket(s : word);
    procedure nextListTicket();
    procedure nextRTF(iPage : integer; scs_thing : word);


  end;

var FWebServer: TFWebServer;
    MIMEMap: TIdMIMETable;
    page_ticket,list_ticket : integer;
    viewer_version_error : boolean;


implementation

uses SBMain, PreviewWindow, EditProj, Search, NetSetup;


{$R *.dfm}

procedure HTTPThread.Execute;
var Result : string;
    http : TIdHTTP;
begin
  http:=TIdHTTP.Create(FWebServer);
  try
    Result:=http.Post(url,postage);
  except
  end;
  postage.free;
  http.free;

end;

procedure TFWebServer.sendToScreens(rtf : string);
var b64 : string;
    hThread: HTTPThread;
    i : integer;
begin
  for i:=0 to FNetSetup.CheckList.Count-1 do begin
    if (FNetSetup.CheckList[i]='Y') then begin
      hThread := HttpThread.Create(true); // Suspend
      hThread.postage := TStringList.Create;
      hThread.postage.add('command=lyrics');
      b64 := FNetSetup.IdEncoderMIME1.EncodeString(rtf);
      hThread.postage.add('lyrics='+b64);
      hThread.URL:=FNetSetup.SGScreens.Cells[0,i+1]+':'+FNetSetup.SGScreens.Cells[1,i+1];
      hThread.resume;
    end;
  end;
end;


function TFWebServer.notMatch(s1 : string; s2 : string) : boolean;
var i,c : integer;
begin
  s1:=uppercase(s1);
  s2:=uppercase(s2);
  i:=1;
  while (i<=length(s1)) do begin
    c:=ord(s1[i]);
    if ((c>=65) and (c<=90)) then inc(i)
    else delete(s1,i,1);
  end;
  i:=1;
  while (i<=length(s2)) do begin
    c:=ord(s2[i]);
    if ((c>=65) and (c<=90)) then inc(i)
    else delete(s2,i,1);
  end;
  notMatch:=(s1<>s2);
end;

function TFWebSErver.getFirstLines() : string;
var lines : array of TStringList;
    min,i,j : integer;
    res : string;
    done : boolean;
    oneline,rtftext : string;

begin
  // Attempt to deduce three useful "first lines" for these pages.

  // 1. Just load the text into lines - lines[x] is for song x, starting at zero.
  //    Number of songs = length(lines)
  //    And lines[x] itself is a list of strings, length lines[x].count
  //    Each line is non-blank.

  res:='';
  if (length(FPreviewWindow.PageButtons)>0) then begin       // If there's >=1 song

    SetLength(lines, length(FSongbase.CurrentPageButtons));
    for i:=0 to length(FSongbase.CurrentPageButtons)-1 do begin
      lines[i]:=TStringList.Create;
      RichEdit1.Clear;
      PageCache_LoadRTF( RichEdit1,FPreviewWindow.LASTID,(i+1));
      rtftext:=RichEdit1.Text;
      while (pos(newline,rtfText)>0) do begin
        oneline:=copy(rtfText,1,pos(newline,rtfText)-1);
        rtfText:=copy(rtfText,pos(newline,rtfText)+length(newline),length(rtfText));
        if (length(trim(oneline))>0) then lines[i].Add(oneline);
      end;
    end;

    // Now the tricky bit, as we need to handle rubbish at least acceptably too.
    // Algorithm: assume page 1

    if (length(lines)>0) then begin

      // Assume the first page is the master page. Use first real line.

      if (lines[0].Count>0) then res:=Lines[0].Strings[0]
      else res:='[Blank Page]';

      // Then for all other pages

      for i:=1 to length(lines)-1 do begin
        res:=res+tab;
        min:=lines[0].count;
        if (lines[i].count<min) then min:=lines[i].count;

        // Minimum number of lines to compare.

        done:=false;

        for j:=0 to min-1 do begin
          if (not done) then begin
            if (notMatch(lines[0].Strings[j],lines[i].Strings[j])) then begin
              res:=res+lines[i].Strings[j];
              done:=true;
            end;
          end;
        end;

        // If we didn't find an appropriate first line.

        if (not done) then begin
          if (lines[i].count=0) then res:=res+'[Blank Page]'
          else res:=res+lines[i].Strings[0];
        end;

      end;
      for i:=0 to length(FSongbase.CurrentPageButtons)-1 do begin
        lines[i].Clear;
      end;
      setlength(lines,0);
    end;
  end;
  getFirstLines:=res;

end;

procedure TFWebServer.nextRTF(iPage : integer; scs_thing : word);
begin
//  web_lock.Acquire;    -- only ever called from Web Server lock.
//  web_lock.Release;
  if (iPage>0) then begin
    nextPageTicket(scs_thing);
  end else begin
    nextPageTicket(0);
  end;
end;

procedure TFWebServer.nextPageTicket(s : word);
//var T : TextFile;
begin
//  web_lock.Acquire;  -- only ever called from nextRTF !
  inc(page_ticket);
  if (page_ticket>99999) then page_ticket:=1;
  last_page:=s;
//  web_lock.Release;
end;

procedure TFWebServer.nextListTicket();
//var T : TextFile;
begin
  // This is only called once - within a acquire already. So don't do acquire release.
  inc(list_ticket);
  if (list_ticket>99999) then list_ticket:=1;
end;

function TFWebServer.isServerEnabled() : boolean;
begin
  isServerEnabled:=WebServer.Active;
end;



procedure TFWebServer.writeDefaultFiles();
begin
  PageRTF:='{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil Arial;}{\f1\fnil\fcharset0 Arial;}}';
  PageRTF:=PageRTF+'{\colortbl ;\red255\green255\blue255;}';
  PageRTF:=PageRTF+'\viewkind4\uc1\pard\qc\cf1\b\f0\fs48';
  PageRTF:=PageRTF+'\par';
  PageRTF:=PageRTF+'\par This is the Songbase Remote Viewer';
  PageRTF:=PageRTF+'\par \lang2057\f1';
  PageRTF:=PageRTF+'\par';
  PageRTF:=PageRTF+'\par This page will be updated when a';
  PageRTF:=PageRTF+'\par new page is displayed on the main screen';
  PageRTF:=PageRTF+'\par \i';
  PageRTF:=PageRTF+'\par }';
  FSongbase.changeList(true,true);
  page_ticket:=0;
  list_ticket:=0;
  last_page:=0;

end;

function TFWebServer.serverEnabled(b : boolean) : boolean;
var Binding : TIdSocketHandle;
var res : boolean;
begin
  res:=true;
  if not WebServer.Active then begin
    WebServer.Bindings.Clear;
    Binding := WebServer.Bindings.Add;
    Binding.Port := StrToInt(FNetSetup.Port);
    Binding.IP := FNetSetup.LocalIP;
    writeDefaultFiles();
  end;

  if b then begin
    try WebServer.Active := true;
    except
      on e: exception do begin
        res:=false;
      end;
    end;
  end else begin
    WebServer.Active := false;
  end;
  serverEnabled:=res;
end;

procedure TFWebServer.syncRequestSong();
var i,count : integer;
    s,CheckID: string;
begin
  s:=FSongbase.sync_s;
  for i:=0 to FSongbase.StringGrid1.RowCount do begin
    if (FSongbase.StringGrid1.Cells[0,i]=s) then begin
      last_page:=0;
      if (FSongbase.StringGrid1.Row=i) then begin
        FSongbase.StringGrid1.Row:=i;
        FSongbase.StringGridUpdated(i);
      end else begin
        FSongbase.StringGrid1.Row:=i;
      end;

      if (not FLiveWindow.Visible) then begin
        s:=SBMain.OrderData;
        for count:=0 to i-1 do begin
          S:=copy(S,pos(chr128,S)+1,length(S));
          S:=copy(S,pos(chr128,S)+1,length(S));
        end;
        CheckID:=copy(S,1,pos(chr128,S)-1);
        FProjWin.SelectSong(CheckID,false,true);
      end;
    end;
  end;
end;

procedure TFWebServer.syncRequestPart();
var s : string;
    i : integer;
    dummy : boolean;
begin
  s:=FSongbase.sync_s;
  dummy:=false;
  if (s='-1') then begin
    if (FLiveWindow.Visible=true) then begin
      FSongbase.ProjectSong( '', 0, true);
      PageRTF:='';
    end else begin
      FProjWin.BlankWindow(dummy, true);
      PageRTF:='';
    end;
  end else begin
    for i:=0 to length(FPreviewWindow.PageButtons)-1 do begin
      if (FPreviewWindow.PageButtons[i].Caption=s) then begin
        if (FLiveWindow.Visible) then begin
          FPreviewWindow.BPageButtonClick(FPreviewWindow.PageButtons[i]);
          FPreviewWindow.BProjectSongClick(FPreviewWindow);
        end else begin
          FProjWin.SelectPage( FSongbase.EID.Text,i+1, true);
        end;
        break;
      end;
    end;
  end;
end;

procedure TFWebServer.syncSelectIndex();
var s : string;
    sbrec_change : TNotifyEvent;
begin
  s:=FSongbase.sync_s;
  sbrec_change:=FSongbase.SBRecNo.OnChange;
  FSongbase.SBRecNo.OnChange:=nil;
  FSongbase.SBRecNo.Position:=1+StrToInt(s);
  FSongbase.SBRecNo.OnChange:=sbrec_change;
  FSongbase.ActualSBRecNoChange(true);
  if (FLiveWindow.Visible=false) then begin
    FProjWin.SelectSong(FSongbase.EID.Text,false,true);
  end;
end;

procedure TFWebServer.WebServerCommandGet(Thread: TIdPeerThread;
  RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);

var
  rootDir : string;
  i : integer;
  s : string;
  PageString : string;
  SR : SongRecord;
  SearchThread   : TTSearchThread;
  sbv_wanted : string;
  sbv_wanted_internal : integer;
  vw_version : integer;
  dltype,rc_type : string;
 //   TF : TextFile;


begin
 // FSongbase.web_lock.Acquire;
  rootDir:='';
  PageString:='  ';
  dltype:='text';

  // Version checks.

  if (copy(RequestInfo.Document,1,12)='/_Handshake_') then begin
    s:=copy(RequestInfo.Document,13,length(RequestInfo.Document));
    rc_type:=copy(s,1,pos('_',s)-1);
    s:=copy(s,pos('_',s)+1,length(s));
    vw_version:=StrToInt(copy(s,1,pos('_',s)-1));
    s:=copy(s,pos('_',s)+1,length(s));
    sbv_wanted_internal:=StrToInt(copy(s,1,pos('_',s)-1));
    s:=copy(s,pos('_',s)+1,length(s));
    sbv_wanted:=s;

    if (rc_type='VW') then begin
      rc_type:='Songbase Viewer ';
      if (vw_version<VIEWER_INTERNAL_REQUIRED) then begin
        PageString:='VIEWER_VER'+tab+VIEWER_NAME_REQUIRED;
      end else if (sbv_wanted_internal>VERSION_INTERNAL) then begin
        PageString:='SB_VER'+tab+VERSION_NAME;
      end else PageString:='OK'+tab+IntToStr(VIEWER_LATEST)+tab+VIEWER_NAME_LATEST;


    end else if (rc_type='AC') then begin
      rc_type:='Songbase-Android Controller ';
      if (vw_version<ANDROID_INTERNAL_REQUIRED) then begin
        PageString:='ANDROID_VER'+tab+ANDROID_NAME_REQUIRED;
      end else if (sbv_wanted_internal>VERSION_INTERNAL) then begin
        PageString:='SB_VER'+tab+VERSION_NAME;
      end else PageString:='OK'+tab+IntToStr(VERSION_INTERNAL);
    end;

    if (sbv_Wanted_internal>VERSION_INTERNAL) then begin
      if (not viewer_version_error) then begin
        messagedlg('A '+rc_type+'could not be run, because it needed you to upgrade to version '+sbv_wanted+' or later.',mtWarning,[mbOk],0);
        viewer_version_error:=true;
      end;
    end;
  end

  // Request for viewer update

  else if (copy(RequestInfo.Document,1,22)='/_Update_Viewer_Please') then begin
    dltype:='binary';
    ResponseInfo.ContentType:='application/x-msdownload';
    ResponseInfo.ResponseNo:=200;
    WebServer.ServeFile(Thread,ResponseInfo,'viewer.exe')
  end

  // Handle request for SB to take focus

  else if (copy(RequestInfo.Document,1,16)='/_Request_Focus_') then begin
    Application.Restore; // unminimize window, makes no harm always call it
    SetWindowPos(Fsongbase.Handle, HWND_NOTOPMOST,0,0,0,0, SWP_NOMOVE or SWP_NOSIZE);
    SetWindowPos(FSongbase.Handle, HWND_TOPMOST,0,0,0,0, SWP_NOMOVE or SWP_NOSIZE);
    SetWindowPos(FSongBase.Handle, HWND_NOTOPMOST,0,0,0,0, SWP_SHOWWINDOW or SWP_NOMOVE or SWP_NOSIZE);  end

  else if (copy(RequestInfo.Document,1,20)='/_Request_LoseFocus_') then begin
    Application.Minimize;
  end

  // Handle request for a specific song

  else if (copy(RequestInfo.Document,1,15)='/_Request_Song_') then begin
    PageString:='  ';
    s:=copy(RequestInfo.Document,16,length(RequestInfo.Document));
    FSongbase.sync_s:=s;
    thread.Synchronize(syncRequestSong);


  // Handle request for a specific page of a song

  end else if (copy(RequestInfo.Document,1,15)='/_Request_Part_') then begin
    PageString:='  ';
    s:=copy(RequestInfo.Document,16,length(RequestInfo.Document));
    FSongbase.sync_s:=s;
    thread.Synchronize(syncRequestPart);

  end else if (copy(RequestInfo.Document,1,9)='/page.txt') then begin
    PageString:=IntToStr(page_ticket)+newline+IntToStr(list_ticket)+newline+IntToStr(last_page)+newline;
    if (length(PageString)<2) then PageString:='  ';

  end else if (copy(RequestInfo.Document,1,9)='/page.rtf') then begin
    PageString:=PageRtf;
    if (length(PageString)<2) then PageString:='  ';

  end else if (copy(RequestInfo.Document,1,12)='/pagertf.txt') then begin
    PageString:=PageRTF_Textformat;
    if (length(PageString)<2) then PageString:='  ';

  end else if (copy(RequestInfo.Document,1,17)='/current_list.txt') then begin
    PageString:=ListText;
    if (length(PageString)<2) then PageString:='  ';

  end else if (copy(RequestInfo.Document,1,18)='/complete_list.txt') then begin
    PageString:=IntToStr(FSongBase.SBrecNo.Max)+newline;
    for i:=0 to FSongbase.SBRecNo.Max-1 do begin
      if (PageCache_GetSongFromIndex(i,SR)) then begin
        PageString:=PageString+IntToStr(i)+tab+SR.Title+tab+SR.AltTitle+newline;
      end;
    end;

  end else if (copy(RequestInfo.Document,1,15)='/_Select_Index_') then begin
    s:=copy(RequestInfo.Document,16,length(RequestInfo.Document));
    FSongbase.sync_s:=s;
    PageString:='  ';
    thread.synchronize(SyncSelectIndex);

  end else if (copy(RequestInfo.Document,1,14)='/_Search_Text_') then begin

    s:=copy(RequestInfo.Document,15,length(RequestInfo.Document));
    SearchThread := TTSearchThread.Create(true);
    SearchResults :='';
    NoSearchResults:=0;
    with SearchThread do begin
      RemoteSearch    := true;
      FileName        := SBMain.FileName;
      QuickSearchFile := SBMain.QSFile;
      OHPFile         := SBMain.OHPFile;
      TempDir         := SBMain.TempDir;
      PRichEditCtrl   := @RichEdit1;

      with FSearch do begin
        SearchStr       := s;
        iMusicKeyIdx    := -1;
        iMusicScaleIdx  := -1;
        iMusicCapoIdx   := -1;
        iMusicTempoIdx  := -1;
        bSearchRTF      := true;

      end;
    end;
    SearchThread.reallyExecute;
    PageString:=SearchResults;
    if (length(PageString)<2) then PageString:='  ';

  end else if (copy(RequestInfo.Document,1,12)='/_Pull_Part_') then begin
    s:=copy(RequestInfo.Document,13,length(RequestInfo.Document));
    for i:=0 to length(FPreviewWindow.PageButtons)-1 do begin
      if (FPreviewWindow.PageButtons[i].Caption=s) then begin
        PageString:=PageCache_GetPageText( FPreviewWindow.LastID, i+1);
      end;
    end;
    if (length(PageString)<2) then PageString:='  ';

  end else if (copy(RequestInfo.Document,1,15)='/_Pull_PartTXT_') then begin
    s:=copy(RequestInfo.Document,16,length(RequestInfo.Document));
    for i:=0 to length(FPreviewWindow.PageButtons)-1 do begin
      if (FPreviewWindow.PageButtons[i].Caption=s) then begin
        RichEdit1.Clear;
        RichEdit1.Width:=1280;
        RichEdit1.Height:=1024;
        PageCache_LoadRTF( RichEdit1,FPreviewWindow.LASTID,(i+1));
        PageString:=RichEdit1.Text;
        break;
      end;
    end;
    if (length(PageString)<2) then PageString:='  ';




  end else begin
    PageString:='  ';
    dltype:='text';
  end;

  if (dltype='text') then begin
    ResponseInfo.ContentType:='text/plain';
    ResponseInfo.ResponseNo:=200;
    ResponseInfo.ContentStream:=TMemoryStream.Create;
    ResponseInfo.ContentStream.Write(PageString[1],length(PageString)*sizeof(PageString[1]));
    ResponseInfo.ContentLength:=length(PageString)*sizeof(PageString[1]);
  end;
//  FSongbase.web_lock.release;
end;

function TFWebServer.GetMIMEType(sFile: TFileName): String;
begin
  result := MIMEMap.GetFileMIMEType(sFile);
end;


procedure TFWebServer.FormCreate(Sender: TObject);
begin
  MIMEMap := TIdMIMETable.Create(true);
  page_ticket:=1;
  list_ticket:=1;

  RichEdit1.Width:=1280;
  RichEdit1.Height:=1024;
  RichEdit2.Width:=1280;
  RichEdit2.Height:=1024;
  viewer_version_error:=false;

end;

procedure TFWebServer.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  WebServer.Active:=false;
end;

procedure TFWebServer.FormDestroy(Sender: TObject);
begin
 MIMEMap.Free;

end;

end.
