unit SongDetails;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SBZipUtils, ShellAPI;

type
  TFSongDetails = class(TForm)
    P4: TPanel;
    LKey: TLabel;
    LCapo: TLabel;
    LTempo: TLabel;
    LC1: TLabel;
    LC2: TLabel;
    Label1: TLabel;
    LAuto: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CKey: TComboBox;
    CMM: TComboBox;
    CCapo: TComboBox;
    CTempo: TComboBox;
    ECop1: TEdit;
    ECop2: TEdit;
    ENotes: TEdit;
    CBC1: TCheckBox;
    CBC2: TCheckBox;
    LBLinks: TListBox;
    BAddLink: TButton;
    BShowLink: TButton;
    BExtract: TButton;
    BRenLink: TButton;
    BDelLink: TButton;
    P2: TPanel;
    LMus: TLabel;
    LTune: TLabel;
    Larr1: TLabel;
    Larr2: TLabel;
    LPub: TLabel;
    LIsbn: TLabel;
    CPhoto: TCheckBox;
    EMus: TEdit;
    EISBN: TEdit;
    ETune: TEdit;
    EArr: TEdit;
    SaveDialog1: TSaveDialog;
    procedure EMusKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EMusExit(Sender: TObject);
    procedure LBLinksClick(Sender: TObject);
    procedure BAddLinkClick(Sender: TObject);
    procedure BDelLinkClick(Sender: TObject);
    procedure BRenLinkClick(Sender: TObject);
    procedure BShowLinkClick(Sender: TObject);
    procedure BExtractClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EMusChange(Sender: TObject);
  private
    { Private declarations }

    // Used to keep this window off the projection screen
    procedure WMWindowPosChanging(var hMsg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;

  public
    { Public declarations }
    PosX,PosY : integer;
  end;

var
  FSongDetails: TFSongDetails;

implementation

uses SBMain, LinkForm, LinkDesc, EditProj;

{$R *.dfm}

procedure TFSongDetails.EMusKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var S,I,T : string;
    R : integer;
begin
  if (Key>64) and (Key<91) and (lengtH(FSongbase.ECopyRight.Text)>0) then begin
    T:=copy(EMus.Text,1,EMus.SelStart);
    FSongbase.LookupPhotoHistory(T,S,I,PhotoFile);
    R:=EMus.SelStart;
    if S<>'' then begin
      EMus.Text:=S;
      EMus.SelStart:=R;
      EMus.Sellength:=length(S);
    end;
  end;
end;

procedure TFSongDetails.EMusExit(Sender: TObject);
var T,S,I : string;
begin
  T:=EMus.Text;
  FSongbase.LookupPhotoHistory(T,S,I,PhotoFile);
  if (I<>'') and (EISBN.TexT='') then EISBN.Text:=I;
end;

procedure TFSongDetails.LBLinksClick(Sender: TObject);
begin
  BShowLink.Enabled:=(LBLinks.ItemIndex>=0);
  BDelLink.Enabled:=BShowLink.Enabled;
  BExtract.Enabled:=BDelLink.Enabled;
end;

procedure TFSongDetails.BAddLinkClick(Sender: TObject);
var StoreFile : string;
    extend : string;
    SrcFile : string;
begin
  FLinkForm.Mode:=1; // Add Link Flag
  FLinkForm.showModal;
  if (FLinkForm.Description<>'') and (FLinkForm.Location<>'') then begin
    StoreFile:=FLinkForm.Location;
    extend:='';
    while (pos('.',StoreFile)>0) do begin
      extend:=Storefile[length(Storefile)]+extend;
      Storefile:=copy(Storefile,1,length(Storefile)-1);
    end;
    str(LinkNextID,StoreFile);
    StoreFile:=FSongBase.EID.Text+'-'+StoreFile+'L'+extend;
    SrcFile:=FLinkForm.Location;
    CopyFile(PChar(SrcFile),PChar(StoreFile),FALSE);
    AddFileToZip(StoreFile,OHPFile,false);
    DeleteFile(StoreFile);
    inc(LinkNextID);
    LinkDescriptions:=LinkDescriptions+FLinkForm.Description+chr129;
    LinkFiles:=LinkFiles+StoreFile+chr129;
    LBLinks.Items.Add(FLinkForm.Description);
    FSongBase.SaveRec;
  end;
end;

procedure TFSongDetails.BRenLinkClick(Sender: TObject);
var i : integer;
    s,d1 : string;

begin
  FLinkDesc.Description:=LBLinks.Items.Strings[LBLinks.ItemIndex];
  FLinkDesc.showmodal;
  LBLinks.Items.Strings[LBLinks.ItemIndex]:=FLinkDesc.Description;
  i:=0;
  s:='';
  D1:=LinkDescriptions;
  while (i<LBLinks.Itemindex) do begin
    s:=s+copy(d1,1,pos(chr129,d1));
    d1:=copy(d1,pos(chr129,d1)+1,length(d1));
  end;
  d1:=copy(d1,pos(chr129,d1)+1,length(d1));
  s:=s+FLinkDesc.Description+chr129+d1;
  LinkDescriptions:=s;
end;

procedure TFSongDetails.BDelLinkClick(Sender: TObject);
var found : boolean;
    NewDescs : String;
    NewFiles : String;
    D1,F1 : string;
begin
  if (messagedlg(FSongbase.SCheckDelete,mtWarning,[mbOK,mbCancel],0)=mrOK) then begin
    Found:=false;
    if pos(chr129,LinkDescriptions)=0 then LinkDescriptions:=LinkDescriptions+chr129;
    if pos(chr129,LinkFiles)=0 then LinkFiles:=LinkFiles+chr129;
    while (not Found) do begin
      D1:=copy(LinkDescriptions,1,pos(chr129,LinkDescriptions)-1);
      F1:=copy(LinkFiles,1,pos(chr129,LinkFiles)-1);
      LinkDescriptions:=copy(LinkDescriptions,pos(chr129,LinkDescriptions)+1,length(LinkDescriptions));
      LinkFiles:=copy(LinkFiles,pos(chr129,LinkFiles)+1,length(LinkFiles));
      if (D1=LBLinks.Items.Strings[LbLinks.ItemIndex]) then begin
        found:=true;
        NewDescs:=NewDescs+LinkDescriptions;
        NewFiles:=NewFiles+LinkFiles;
        LBLinks.Items.Delete(LBLinks.ItemIndex);
        DeleteFileFromZip(OHPFile,F1);
        FSongBase.SaveRec;
      end else begin
        NewDescs:=NewDescs+D1;
        NewFiles:=NewFiles+F1;
      end;
    end;
    LinkDescriptions:=NewDescs;
    LinkFiles:=NewFiles;
    LbLinks.ItemIndex:=-1;
    BDelLink.Enabled:=false;
    BShowLink.Enabled:=false;
    BExtract.Enabled:=false;
  end;
end;

procedure TFSongDetails.BExtractClick(Sender: TObject);
var i : integer;
    s : string;
    ext,F1,D1 : string;
begin
  i:=0;
  s:='';
  F1:=LinkFiles;
  d1:=LinkDescriptions;
  while (i<LBLinks.Itemindex) do begin
    f1:=copy(f1,pos(chr129,f1)+1,length(f1));
    d1:=copy(d1,pos(chr129,d1)+1,length(d1));
    inc(i);
  end;
  f1:=copy(f1,1,pos(chr129,f1)-1);
  d1:=copy(d1,1,pos(chr129,d1)-1);
  i:=length(f1);
  ext:='';
  while (f1[i]<>'.') do begin
    ext:=f1[i]+ext;
    dec(i);
  end;

  d1:=d1+'.'+ext;

  SaveDialog1.FileName:=d1;
  SaveDialog1.Title:='Extract '+d1;
  SaveDialog1.Options:=[ofOverWritePrompt];
  if savedialog1.execute then begin
    ExtractFileFromZip(OHPFile,f1,TempDir);
    d1:=savedialog1.filename;
    renamefile(TempDir+f1,d1);
  end;
end;

procedure TFSongDetails.BShowLinkClick(Sender: TObject);
var i : integer;
    s,F1 : string;
begin
  i:=0;
  s:='';
  F1:=LinkFiles;
  while (i<LBLinks.Itemindex) do begin
    f1:=copy(f1,pos(chr129,f1)+1,length(f1));
    inc(i);
  end;

  f1:=copy(f1,1,pos(chr129,f1)-1);
  ExtractFileFromZip(OHPFile,f1,TempDir);
  shellexecute(Application.handle,nil,pchar(TempDir+f1),nil,nil,SW_SHOW);
end;

procedure TFSongDetails.FormShow(Sender: TObject);
begin
  top:=PosY;
  left:=PosX;
end;

procedure TFSongDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  PosY := top;
  PosX := left;
end;

procedure TFSongDetails.WMWindowPosChanging(var hMsg: TWMWindowPosChanging);
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

procedure TFSongDetails.EMusChange(Sender: TObject);
begin
  if not FSongbase.bDisableEvents then begin
    FSongbase.CurrentSongIsReadable( true );
    Unsaved := true;
    FSongbase.LUnsaved.visible:=true;
    FSongbase.SaveChanges1.Enabled:=true;
    FSongbase.BEditSong.Enabled := true;
  end;
end;

end.
