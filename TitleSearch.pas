unit TitleSearch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SBFiles, Appear, ExtCtrls;

type
  TFTitle = class(TForm)
    ESong: TEdit;
    LBSongs: TListBox;
    BCancel: TButton;
    BOk: TButton;
    PButtons: TPanel;
    procedure FormActivate(Sender: TObject);
    procedure ESongChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BCancelClick(Sender: TObject);

    procedure ESongKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BOkClick(Sender: TObject);
    procedure LBSongsDblClick(Sender: TObject);
    procedure LBSongsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LBSongsEnter(Sender: TObject);
    procedure LBSongsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LBSongsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);

  private
    { Private declarations }
    Results : TStringList;

    // Used to keep this window off the projection screen
    procedure WMWindowPosChanging(var hMsg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;

  public
    FileName : string;
    ResultSong : integer;
    ResultID : string;
    PosX,PosY : integer;
    Initial  : string;
    MoreThan : string;
    FirstQuickSearch : integer;
    CroppedLyrics : boolean;
    { Public declarations }
  end;

var
  FTitle: TFTitle;
  BigSonglist : TStringlist;
  MiniSonglist : TStringlist;

  iSongCount : integer;
  aUsed      : array of boolean;

implementation

uses SBMain, EditProj, PageCache;

{$R *.DFM}

procedure TFTitle.FormActivate(Sender: TObject);
begin
  Results := nil;
  SetLength(aUsed,0);
  ESong.Text:= Initial;
  ESongChange(Sender);
  ESong.SetFocus;
  ESong.SelStart := Length(Initial);
  FirstQuickSearch := 0;
  CroppedLyrics    := false;
end;

procedure TFTitle.ESongChange(Sender: TObject);
var i : integer;
    SR : SongRecord;
begin
  if Results <> nil then Results.free;

  iSongCount := 0;
  SetLength(aUsed, 0);
  CroppedLyrics := false;
  Results := PageCache_SearchTitles( ESong.Text );

  FirstQuickSearch := Results.Count;
  LBSongs.items.clear;
  if Results.Count > 10 then begin
    LBSongs.items.add(MoreThan);
    LBSongs.enabled:=false;
  end else begin
    LBSongs.enabled:=true;

    if( FSettings.cbSearchLyrics.Checked and
        (Results.Count < FSettings.iMinSearchLyrics)) then begin
      CroppedLyrics := not PageCache_TextSearch( ESong.Text, Results,
                                                 10 - FirstQuickSearch, true, false );
      if CroppedLyrics then Results.Delete( Results.Count-1 );
    end;

    iSongCount := Results.Count;
    SetLength(aUsed, iSongCount);

    for i := 0 to iSongCount-1 do begin
      if Copy(Results[i],1,1) = '~' then begin
        Results[i] := copy( Results[i], 2, length(Results[i]) );
        PageCache_GetSong( Results[i], SR );
        LBSongs.Items.Add( SR.AltTitle + ' [' + SR.Title +']' );
      end else begin
        LBSongs.Items.Add( PageCache_GetSongName( Results[i] ) );
      end;

//      if FSettings.cbGrayUnusedSearch
      begin
        PageCache_GetSong( Results[i], SR );
        aUsed[i] := (SR.OHP <> '0');
      end;
    end;

    if 0 = LBSongs.Items.Count then LBSongs.Enabled := false;
    if LBSongs.ItemIndex = -1 then LBSongs.ItemIndex := 0;
    if CroppedLyrics then LBSongs.Items.Add( MoreThan );
  end;

  BOK.Enabled := LBSongs.Enabled;
end;

procedure TFTitle.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Results <> nil then Results.free;
  BigSonglist.free;
  MiniSonglist.free;
  PosX:=left;
  PosY:=top;
end;

procedure TFTitle.BCancelClick(Sender: TObject);
begin
  resultsong:=-1;
  close;
end;

procedure TFTitle.ESongKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DOWN) and LBSongs.Enabled then begin
    LBSongs.ItemIndex := LBSongs.ItemIndex + 1;
    Key := 0;
  end;
  if (Key=VK_UP) and LBSongs.Enabled and (LBSongs.ItemIndex > 0) then begin
    LBSongs.ItemIndex := LBSongs.ItemIndex - 1;
    Key := 0;
  end;
end;

procedure TFTitle.BOkClick(Sender: TObject);
begin
  if LBSongs.Items.Count > 0 then begin
    if LBSongs.ItemIndex=-1 then LBSongs.ItemIndex:=0;
    LBSongsDblClick(Sender);
  end else close;
end;

procedure TFTitle.LBSongsDblClick(Sender: TObject);
var S2 : string;
    found : integer;
begin
  S2 := Results[LBSongs.ItemIndex];

  PageCache_EnsureID( S2, found );
  ResultSong := found + 1;
  close;
end;

procedure TFTitle.LBSongsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_RETURN) and (LBSongs.ItemIndex>=0) then LBSongsDblClick(Sender);
end;

procedure TFTitle.LBSongsEnter(Sender: TObject);
begin
  if LBSongs.ItemIndex>=0 then BOk.Enabled:=true;
end;


procedure TFTitle.LBSongsClick(Sender: TObject);
begin
  BOk.Enabled:=(LBSongs.ItemIndex>=0);
end;

procedure TFTitle.FormShow(Sender: TObject);
begin
  if (PosX<0) then PosX:=0;
  if (PosY<0) then PosY:=0;
  top:=PosY;
  left:=PosX;
  BigSonglist:=TStringlist.create;
  BigSonglist.sorted:=true;
  MiniSongList:=TStringlist.create;
  MiniSonglist.sorted:=true;
  resultsong:=-1;
end;

procedure TFTitle.WMWindowPosChanging(var hMsg: TWMWindowPosChanging);
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

procedure TFTitle.LBSongsDrawItem(Control: TWinControl; Index: Integer;
                                  Rect: TRect; State: TOwnerDrawState);
var
	Offset: Integer;      { text offset width }
  Lister: TListBox;
begin
  Lister := (Control as TListBox);
  Font.Style := [];
	with Lister.Canvas do
	begin
    if (Index < iSongCount) and aUsed[Index] then begin
     Font.Style := Font.Style + [fsBold];
    end;

    FillRect(Rect);       { clear the rectangle }
    Offset := 2;          { provide default offset }
    if not Lister.Enabled then Font.Color := clGray;
    if CroppedLyrics and (Index = Lister.Count-1) then Font.Color := clGray
    else
    if (Index < iSongCount) and
       (Index >= FirstQuickSearch) then begin
      Font.Style := Font.Style + [fsItalic];
//      if Font.Color = clWindowText then Font.Color := clBlue;
    end;
    TextOut(Rect.Left + Offset, Rect.Top, Lister.Items[Index])  { display the text }
	end;
end;

procedure TFTitle.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  NewHeight := Height;
end;

end.
