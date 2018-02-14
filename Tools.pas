unit Tools;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ComCtrls, ToolWin, ExtCtrls, SBFiles, EditProj, SBZipUtils,
  Buttons, mbOfficeColorDialog;

type
  TFTools = class(TForm)
    PTools: TPanel;
    CBFont: TComboBox;
    FontSize: TEdit;
    UpDown1: TUpDown;
    PCol: TPanel;
    PCol2: TPanel;
    BTest: TButton;
    BExit: TButton;
    BReload: TButton;
    ToolBar1: TToolBar;
    ToolButton5: TToolButton;
    BSave: TToolButton;
    BPrint: TToolButton;
    ToolButton1: TToolButton;
    BUndo: TToolButton;
    BCut: TToolButton;
    BCopy: TToolButton;
    BPast: TToolButton;
    ToolButton3: TToolButton;
    BBold: TToolButton;
    BItalic: TToolButton;
    BUnder: TToolButton;
    ToolButton2: TToolButton;
    BLeft: TToolButton;
    BCent: TToolButton;
    BRight: TToolButton;
    ToolButton6: TToolButton;
    LPages: TLabel;
    BPL: TToolButton;
    PPage: TPanel;
    BPR: TToolButton;
    BPN: TToolButton;
    BPD: TToolButton;
    LKey: TLabel;
    CBSC: TComboBox;
    CBScreen: TComboBox;
    ToolbarImages: TImageList;
    BPickImage: TBitBtn;
    BNoImage: TBitBtn;
    ToolButton7: TToolButton;
    ColorDialog2: TmbOfficeColorDialog;
    procedure BSaveClick(Sender: TObject);
    procedure BPrintClick(Sender: TObject);
    procedure BUndoClick(Sender: TObject);
    procedure BCutClick(Sender: TObject);
    procedure BCopyClick(Sender: TObject);
    procedure BPastClick(Sender: TObject);
    procedure BBoldClick(Sender: TObject);
    procedure BItalicClick(Sender: TObject);
    procedure BUnderClick(Sender: TObject);
    procedure BLeftClick(Sender: TObject);
    procedure BCentClick(Sender: TObject);
    procedure BRightClick(Sender: TObject);
    procedure BPLClick(Sender: TObject);
    procedure BPRClick(Sender: TObject);
    procedure BPNClick(Sender: TObject);
    procedure BPDClick(Sender: TObject);
    procedure CBFontChange(Sender: TObject);
    procedure PCol2Click(Sender: TObject);
    procedure BReloadClick(Sender: TObject);
    procedure BTestClick(Sender: TObject);
    procedure BExitClick(Sender: TObject);
    procedure CBSCChange(Sender: TObject);
    procedure UpdateButtons;
    procedure FormShow(Sender: TObject);
    procedure CBScreenChange(Sender: TObject);
    procedure FontSizeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure BPickImageClick(Sender: TObject);
    procedure BNoImageClick(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure FontSizeChange(Sender: TObject);
    procedure CBFontCloseUp(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Changed : boolean;
    OldPages : integer;
    MsgLastPage : string;
    MsgUnsaved  : string;
    MsgConfirm  : string;
    bDisableEvents : boolean;
  end;

var
  FTools: TFTools;

implementation

uses SBMain, OHPPrint, PreviewWindow, PageCache, Appear;

{$R *.dfm}

procedure TFTools.BSaveClick(Sender: TObject);
var S, SOHP : string;
    hFiles : TStringList;
begin
  str(FEditWin.CurrentPage,S);
  S   :=TempDir+ FEditWin.GID+'-'+S+'.rtf';
  SOHP:=TempDir+ FEditWin.GID+'.ohp';

  PageCache_SaveRTF( FEditWin.RESong, FEditWin.GID, FEditWin.CurrentPage );
  FEditWin.FRTF.Text := PageCache_GetRichText( FEditWin.RESong );
  FEditWin.SaveOhp;

  // Check both files exist
  if not FileExists( S ) or not FileExists( SOHP ) then begin
    // Display error message
    messagedlg( 'A random, unexplainable and hitherto unexpected error occured during saving, awfully sorry!',
                        mtError, [mbOK],0);
    Exit;
  end;

  // Update the RTF and OHP files for this song in the Zip file
  // (note this is done as one call to Zip to retain integrity!)
  hFiles := TStringList.Create;
  hFiles.Add(S);
  hFiles.Add(SOHP);
  AddFilesToZip( hFiles, OHPFile, true );

  // And ensure we update the information about this song in the cache
  PageCache_ForceReload( FEditWin.GID );
  Changed := true;
end;

procedure TFTools.BPrintClick(Sender: TObject);
var i : integer;
    St,s : string;
begin
  if FEditWin.Pages=1 then begin
    FEditWin.RESong.SelectAll;
    FEditWin.RESong.SelAttributes.Color:=clBlack;
    FEditWin.RESong.SelLength:=0;
    FEditWin.RESong.Print(FEditWin.GTitle);
  end;
  if FEditWin.Pages>1 then begin
    FPOHP.showmodal;
    if FPOHP.Ok then begin
      if FPOHP.RB1.checked then begin
        FEditWin.RESong.SelectAll;
        FEditWin.RESong.SelAttributes.Color:=clBlack;
        FEditWin.RESong.SelLength:=0;
        FEditWin.RESong.print(FEditWin.GTitle);
       end
      else if FPOHP.RBA.checked then begin
        str(FEditWin.Pages,s);
        for i:=1 to FEditWin.Pages do begin
          PageCache_LoadRTF( FEditWin.RESong, FEditWin.GID, i );
          str(i,st);
          FEditWin.RESong.SelectAll;
          FEditWin.RESong.SelAttributes.Color:=clBlack;
          FEditWin.RESong.SelLength:=0;
          FEditWin.RESong.Print(FEditWin.GTitle+'   '+St+'/'+S);
        end;
      end;
    end;
  end;

  // Reload the current page
  PageCache_LoadRTF( FEditWin.RESong, FEditWin.GID, FEditWin.CurrentPage );
  FEditWin.FRTF.Text := PageCache_GetRichText( FEditWin.RESong );
end;


procedure TFTools.BUndoClick(Sender: TObject);
begin
  FEditWin.RESong.Undo;
end;

procedure TFTools.BCutClick(Sender: TObject);
begin
  FEditWin.RESong.CutToClipboard;
end;

procedure TFTools.BCopyClick(Sender: TObject);
begin
  FEditWin.RESong.CopyToClipboard;
end;
procedure TFTools.BPastClick(Sender: TObject);
begin
  FEditWin.RESong.PasteFromClipboard;
end;

procedure TFTools.BBoldClick(Sender: TObject);
begin
  if BBold.Down then begin
    FEditWin.RESong.SelAttributes.Style := FEditWin.RESong.SelAttributes.Style + [fsBold];
  end else begin
    FEditWin.RESong.SelAttributes.Style := FEditWin.RESong.SelAttributes.Style - [fsBold];
  end;
end;

procedure TFTools.BItalicClick(Sender: TObject);
begin
  if BItalic.Down then begin
    FEditWin.RESong.SelAttributes.Style := FEditWin.RESong.SelAttributes.Style + [fsItalic];
  end else begin
    FEditWin.RESong.SelAttributes.Style := FEditWin.RESong.SelAttributes.Style - [fsItalic];
  end;
end;

procedure TFTools.BUnderClick(Sender: TObject);
begin
  if BUnder.Down then begin
    FEditWin.RESong.SelAttributes.Style := FEditWin.RESong.SelAttributes.Style + [fsUnderline];
  end else begin
    FEditWin.RESong.SelAttributes.Style := FEditWin.RESong.SelAttributes.Style - [fsUnderline];
  end;
end;

procedure TFTools.BLeftClick(Sender: TObject);
begin
  BLeft.Down:=true;
  BCent.Down:=false;
  BRight.Down:=false;
  FEditWin.RESong.Paragraph.Alignment:=taLeftJustify;
end;


procedure TFTools.BCentClick(Sender: TObject);
begin
  BCent.Down:=true;
  BLeft.Down:=false;
  BRight.Down:=false;
  FEditWin.RESong.Paragraph.Alignment:=taCenter;
end;

procedure TFTools.BRightClick(Sender: TObject);
begin
  BRight.Down:=true;
  BLeft.Down:=false;
  BCent.Down:=false;
  FEditWin.RESong.Paragraph.Alignment:=taRightJustify;
end;

procedure TFTools.UpdateButtons;
var S,S2 : string;
begin
  BPR.Enabled:=(FEditWin.CurrentPage<FEditWin.Pages);
  BPL.Enabled:=(FEditWin.CurrentPage>1);
  str(FEditWin.CurrentPage,S);
  str(FEditWin.Pages,S2);
  PPage.Caption:=S+'/'+S2;
  if FEditWin.CurrentPage > 0 then begin
    S:=FEditWin.StringSC(FEditWin.SCs[(FEditWin.CurrentPage*2)-1],FEditWin.Scs[(FEditWin.CurrentPage*2)])
  end else begin
    S:=FEditWin.StringSC(0,0);
  end;
  CBSC.ItemIndex:=CBSC.Items.Indexof(S);
  if( length(FEditWin.Pics)> 0 ) then begin
    BNoImage.Enabled:=(length(FEditWin.Pics[FEditWin.CurrentPage-1])>1)
  end else begin
    BNoImage.Enabled:=false;
  end;
end;


procedure TFTools.BPLClick(Sender: TObject);
//var S : string;
begin
  if BSave.Enabled then BSaveClick(Sender);
  dec(FEditWin.CurrentPage);
  PageCache_LoadRTF( FEditWin.RESong, FEditWin.GID, FEditWin.CurrentPage );
  FEditWin.FRTF.Text := PageCache_GetRichText( FEditWin.RESong );

{  str(FEditWin.CurrentPage,S);
  S:=FEditWin.GID+'-'+S+'.rtf';
  FEditWin.RESong.Lines.LoadFromFile(TempDir+S);}

  FEditWin.SetGlobals;
  UpdateButtons;
  FEditWin.RESong.SelStart := length( FEditWin.RESong.Lines.Text );
  BSave.Enabled := false;
  BReload.Enabled := false;
end;

procedure TFTools.BPRClick(Sender: TObject);
//var S : string;
begin
  if BSave.Enabled then BSaveClick(Sender);
  inc(FEditWin.CurrentPage);

  PageCache_LoadRTF( FEditWin.RESong, FEditWin.GID, FEditWin.CurrentPage );
  FEditWin.FRTF.Text := PageCache_GetRichText( FEditWin.RESong );

{  str(FEditWin.CurrentPage,S);
  S:=FEditWin.GID+'-'+S+'.rtf';
  FEditWin.RESong.Lines.LoadFromFile(TempDir+S);}

  FEditWin.SetGlobals;
  UpdateButtons;
  FEditWin.RESong.SelStart := length( FEditWin.RESong.Lines.Text );
  BSave.Enabled := false;
  BReload.Enabled := false;
end;


procedure TFTools.BPNClick(Sender: TObject);
var S,S2 : string;
    i : integer;
    bRetainOrder, bResult, bIsNaturalOrder : boolean;
    hFiles : TStringList;
const
    CHAR_BASE = Ord('1');
begin
  if BSave.Enabled then BSaveClick(Sender);
  hFiles := TStringList.Create;

  // Ask the user, or check options.
  bRetainOrder    := FEditWin.IsDefaultOrdering;
  bResult         := true;
  bIsNaturalOrder := true;

  if FEditWin.CurrentPage<FEditWin.Pages then
  begin
    // Unzip all the pages for this song which
    // come after the current page...
    for i := FEditWin.CurrentPage+1 to FEditWin.Pages do begin
      str(i,S);
      S:=FEditWin.GID+'-'+S+'.rtf';
      hFiles.Add( S );

      // Check for the natural order of the later pages - Modifier state
      // should be unset and the order should be 1,2,3(i),4,5....
      if (FEditWin.SCS[((i+1)*2)-1] <> 0) and
         (FEditWin.SCS[((i+1)*2)] <> (CHAR_BASE + i)) then begin
        bIsNaturalOrder := false;
      end;
    end;
    ExtractFilesFromZip( OHPFile, hFiles, TempDir );
    hFiles.Clear;

    // ... and check they exist and COPY them (to update timestamp)
    for i := FEditWin.Pages downto FEditWin.CurrentPage+1 do begin
      str(i,S);    S := TempDir+ FEditWin.GID+'-'+S +'.rtf';
      str(i+1,S2); S2:= TempDir+ FEditWin.GID+'-'+S2+'.rtf';
      if not FileExists( S ) then begin bResult := false; break; end;
      FileCopy( S, S2 );
      if not FileExists( S2 ) then begin bResult := false; break; end;
      DeleteFile( S );
      hFiles.Add( S2 );
    end;

    // Did we fail?
    if false = bResult then begin
      hFiles.Free;
      messagedlg( 'An unexpected error occured during creating a new page, awfully sorry!',
                        mtError, [mbOK],0);
      Exit;
    end;

    // If that was successful, update the OHP details and write them
    for i := FEditWin.CurrentPage+1 to FEditWin.Pages do begin
      if not bRetainOrder or not bIsNaturalOrder then begin
        FEditWin.SCs[(i+1)*2]     := FEditWin.SCs[ i*2   ];
        FEditWin.SCs[((i+1)*2)-1] := FEditWin.Scs[(i*2)-1];
      end else begin
        // Automatically update the last page.
        FEditWin.SCs[(i+1)*2]     := FEditWin.SCs[ i*2   ]+1;
        FEditWin.SCs[((i+1)*2)-1] := FEditWin.Scs[(i*2)-1];
      end;
    end;
  end;

  // Zero the new current page so we give it the new shortcut...
  if bRetainOrder then begin
    FEditWin.SCS[((1+FEditWin.CurrentPage)*2)  ] := 0;
    FEditWin.SCS[((1+FEditWin.CurrentPage)*2)-1] := 0;
  end;

  // Update things...
  inc(FEditWin.CurrentPage);
  inc(FEditWin.Pages);
  setlength(FEditWin.Pics,FEditWin.Pages);

  // Switch to the new page
  FEditWin.SaveAtts;
  FEditWin.RESong.Lines.Clear;
  PageCache_SaveRTF( FEditWin.RESong, FEditWin.GID, FEditWin.CurrentPage );
  str(FEditWin.CurrentPage,S); S := TempDir+ FEditWin.GID+'-'+ S +'.rtf';
  hFiles.Add(S);

  // And retain the same defaults as before
  FEditWin.RESong.SelectAll;
  FEditWin.RestAtts;

  if bRetainOrder then begin
    CBSC.ItemIndex:=FEditWin.NextShortCut;
    CBSCChange(Sender);
  end else begin
    UpdateButtons;
  end;
  FEditWin.SaveOHP;

  // Include the saved OHP file
  S := TempDir + FEditWin.GID + '.ohp';
  if not FileExists( S ) then begin
    hFiles.Free;
      messagedlg( 'An unexpected error occured whilst trying to create a new page, we''re very sorry!',
                        mtError, [mbOK],0);
    Exit;
  end;
  hFiles.Add( S );

  // and update the Zip file with the new changes
  AddFilesToZip( hFiles, OHPFile, true );
  hFiles.Free;

  // Then update the interface
  PageCache_ForceReload( FEditWin.GID );
  UpdateButtons;
  FEditWin.RESong.SelStart := length( FEditWin.RESong.Lines.Text );
  BSave.Enabled := false;
  BReload.Enabled := false;
  Changed := true;
end;


procedure TFTools.BPDClick(Sender: TObject);
var i, iPages : integer;
    S,S2 : string;
    bRetainOrder, bResult : boolean;
    hFiles : TStringList;
begin
  if FEditWin.Pages <= 1 then begin
    messagedlg( MsgLastPage, mtError, [mbOK],0);
    Exit;
  end;

  if messagedlg(MsgConfirm,mtConfirmation,[mbYes,mbNo],0)=mrYes then
  begin
    // If the song was in order before, retain ordering afterwards.
    bRetainOrder := FEditWin.IsDefaultOrdering( FEditWin.CurrentPage );
    iPages := FEditWin.Pages;
    dec(FEditWin.Pages);

    // IMPROVE: ERROR HANDLING!
    hFiles  := TStringList.Create;
    bResult := true;
    if FEditWin.CurrentPage < iPages then begin
      for i:=FEditWin.CurrentPage+1 to iPages do begin
        str(i,S); S:=FEditWin.Gid+'-'+S+'.rtf';
        hFiles.Add(S);
      end;
      ExtractFilesFromZip( OHPFile, hFiles, TempDir );
      hFiles.Clear;

      // Did we get all the pages?
      for i:=FEditWin.CurrentPage+1 to iPages do begin
        str(i,S); S:=TempDir+FEditWin.Gid+'-'+S+'.rtf';
        str(i-1,S2); S2:=TempDir+FEditWin.GID+'-'+S2+'.rtf';

        // It's not an error if the file doesn't actually exist, but it IS
        // an error if we then fail to update it... (we copy to update the
        // timestamp on the file so it's newer than the Zip file)
        if FileExists( S ) then begin
          FileCopy(S, S2);
          if not FileExists( S2 ) then begin bResult := false; break; end;
          DeleteFile(S);
        end;

        // Now add the file to the list to be restored to the ZIP file
        if bResult and FileExists(S2) then hFiles.Add(S2);
      end;
    end;

    // Update shortcuts
    if bResult then begin
      for i:=FEditWin.CurrentPage+1 to iPages do begin
        if not bRetainOrder then begin
          FEditWin.SCs[((i-1)*2)-1] :=FEditWin.SCs[(i*2)-1];
          FEditWin.SCS[((i-1)*2)  ] :=FEditWin.SCS[(i*2)  ];
        end else begin
          FEditWin.SCs[((i-1)*2)-1] :=FEditWin.SCs[(i*2)-1];
          FEditWin.SCS[((i-1)*2)  ] :=FEditWin.SCS[(i*2)  ] -1;
        end;
      end;

      FEditWin.SaveOHP;
      if not FileExists( TempDir + FEditWin.GID + '.ohp' ) then bResult := false;
    end;

    if not bResult then begin
      hFiles.Free;
      messagedlg( 'An unexpected error occured whilst removing this page, awfully sorry!',
                        mtError, [mbOK],0);
      Exit;
    end;
    hFiles.Add( TempDir + FEditWin.GID +'.ohp' );

    // Finally, remove the overhanging page from the ZIP file,
    // then update it with the updated items
    str( iPages, S );
    S := FEditWin.GID+'-'+S+'.rtf';
    DeleteFileFromZIP( OHPFile, S );

    // Update the ZIP file
    AddFilesToZip( hFiles, OHPFile, true );

    // And update
    if FEditWin.CurrentPage>FEditWin.Pages then FEditWin.CurrentPage:=FEditWin.Pages;

    // IMPROVE: If deleting the last page, just clear and re-save the current/last page
{    if FEditWin.CurrentPage=0 then begin
      FEditWin.CurrentPage:=1; FEditWin.Pages:=1;
      FEditWin.UpdateLabels(FEditWin.CurrentPage);
      str(FEditWin.CurrentPage,S); s:=FEditWin.GID+'-'+S+'.rtf';
      FEditWin.RESong.Lines.Clear;
      FEditWin.RESong.Lines.Add(FEditWin.GTitle);
      FEditWin.RESong.Lines.SaveToFile(TempDir+S);
    end;                                          }

    PageCache_ForceReload( FEditWin.GID );
    PageCache_LoadRTF( FEditWin.RESong, FEditWin.GID, FEditWin.CurrentPage );
    FEditWin.FRTF.Text := PageCache_GetRichText( FEditWin.RESong );

    FEditWin.SetGlobals;
    BSave.Enabled := false;
    Changed := true;
    UpdateButtons;
  end;
end;

procedure TFTools.CBFontChange(Sender: TObject);
begin
  FEditWin.RESong.SelAttributes.Name:=CBFont.Text;
end;

procedure TFTools.PCol2Click(Sender: TObject);
begin
  if ColorDialog2.Execute then begin
    PCol2.Color:=ColorDialog2.SelectedColor;
    FEditWin.RESong.SelAttributes.Color:=PCol2.Color;
  end;
end;


procedure TFTools.BReloadClick(Sender: TObject);
//var S : string;
begin
  if messagedlg(MsgUnsaved,mtConfirmation,[mbYes,mbNo],0)=mrYes then begin
{    str(FEditWin.CurrentPage,S);
    S:=FEditWin.GID+'-'+S+'.rtf';
    FEditWin.RESong.Lines.LoadFromFile(TempDir+S);}

    PageCache_LoadRTF( FEditWin.RESong, FEditWin.GID, FEditWin.CurrentPage );
    FEditWin.FRTF.Text := PageCache_GetRichText( FEditWin.RESong );
    FEditWin.SetGlobals;
  end;
end;

procedure TFTools.BTestClick(Sender: TObject);
begin
  if BSave.Enabled then BSaveClick(Sender);
  FEditWin.RESong.Visible := false;
//  FEditWin.ImgOnScreen.Visible := true;
  //EditProj.BlindMode := SHOWING_SONG;
  ShowCursor(false);

  FEditWin.bScaleProjection := (0 <> FSettings.szProjectScale.cx);
  FTools.Hide;
  FEditWin.bHasTools := false;
  FEditWin.Cop1.Visible:= true; FEditWin.Cop1.Enabled := true;
  FEditWin.Cop2.Visible:= true; FEditWin.Cop2.Enabled := true;
  FEditWin.LLicense.Visible:=true;
  FEditWin.Invalidate;

  { Handle scaling }
  if FEditWin.bScaleProjection and
     (FSettings.szProjectScale.cx = FEditWin.Width) and
     (FSettings.szProjectScale.cy = FEditWin.Height) then
     FEditWin.bScaleProjection := false;

  if FEditWin.bScaleProjection then begin
    FSongbase.SetImageSize( FEditWin, FEditWin.ImgOffscreen, FSettings.szProjectScale.cx, FSettings.szProjectScale.cy );
    if FEditWin.bHighQuality then begin
      FSongbase.SetImageSize( FEditWin, FEditWin.ImgScaler, FEditWin.ImgOffscreen.Width, FEditWin.ImgOffscreen.Height );
    end;
    FEditWin.FRTF.SetZoom(
            (FEditWin.CurrentDisplayArea.Bottom - FEditWin.CurrentDisplayArea.Top)
            / FSettings.szProjectScale.cy );
  end;
  { Handled scaling }

  FEditWin.SetGlobals;
  FEditWin.EBlind.SetFocus;
  FEditWin.EBlind.SendToBack;
  FEditWin.EBlind.Update;
end;

procedure TFTools.BExitClick(Sender: TObject);
begin
  if BSave.Enabled then
    BSaveClick(Sender);
  if Changed then begin
    UpdateFSH(FEditWin.GID,OHPFile,QSFile);
    FSongbase.Changelist(false,false);
  end;
  FEditWin.ActiveControl := nil;
  FEditWin.close;
  close;
  if Changed then begin
    FPreviewWindow.RefreshAll;
    if FProjWin.Visible and (FProjWin.LastID = FEditWin.GID) and (FProjWin.CurrentPage <> 0) then
      FProjWin.CurrentPage := 0;
  end;
end;

procedure TFTools.CBSCChange(Sender: TObject);
var A,B : word;
    S : string;

begin
  if not bDisableEvents then begin
    if FEditWin.ShortCutInUse(CBSC.ItemIndex) then begin
      // Are we in order?
  //    if FEditWin.IsDefaultOrdering then begin
  //    if A = mrYes then FEditWin.ReorderShortcuts(CBSC.ItemIndex)
      // Otherwise, just choose the next available shortcut
    {  else  }
      CBSC.ItemIndex:=FEditWin.NextShortCut;
    end;

    {Check for already in use}
    A:=0;
    S:=CBSC.Items.Strings[CBSC.ItemIndex];
    if pos('Shift',S)>0 then A:=A+1;
    if pos('Ctrl',S)>0 then A:=A+2;
    if pos('Alt',S)>0 then A:=A+4;
    while pos('+',S)>0 do S:=copy(S,pos('+',S)+1,length(S));
    B:=ord(S[1]);
    if S='None' then begin A:=0; B:=0; end;
    FEditWin.SCS[(FEditWin.CurrentPage*2)-1]:=A;
    FEditWin.SCS[(FEditWin.CurrentPage*2)]:=B;

    BSave.Enabled := true;
  end;
end;

procedure TFTools.FormShow(Sender: TObject);
begin
  FTools.BringToFront;
end;

procedure TFTools.CBScreenChange(Sender: TObject);
begin
  FEditWin.SetEditWidth;
  FEditWin.Invalidate;
  FEditWin.RESong.Invalidate;
end;

procedure TFTools.FontSizeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_Return) then FEditWin.RESong.SetFocus;
end;

procedure TFTools.UpDown1Click(Sender: TObject; Button: TUDBtnType);
var S : string;
begin
  str(FTools.UpDown1.Position,S);
  FTools.FontSize.Text:=S;
  FEditWin.RESong.SelAttributes.Size:=FTools.UpDown1.Position;
end;

procedure TFTools.BPickImageClick(Sender: TObject);
begin
  with FSettings.FileOpenPicture do begin
    Filter := FSongbase.SBGFilter;
    Title  := 'Choose Background image';
    if Execute then begin
      FEditWin.Pics[FEditWin.CurrentPage-1]:=FileName;
      BSave.Enabled := true;
    end;
  end;
  FEditWin.SetGlobals;
  Updatebuttons;
end;

procedure TFTools.BNoImageClick(Sender: TObject);
begin
  FEditWin.Pics[FEditWin.CurrentPage-1]:='';
  FEditWin.SetGlobals;
  BSave.Enabled := true;
  UpdateButtons;
end;

procedure TFTools.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
var bHandleThis : boolean;
begin
  if Msg.CharCode = VK_ESCAPE then begin
    bHandleThis := true;
    BExitClick(Self);
  end
  // Ignore anything else without the control key down
  else if GetKeyState(VK_CONTROL)<0 then begin
    bHandleThis := true;
    case Msg.CharCode of
      Ord('A'):  FEditWin.RESong.SelectAll;
      Ord('B'):  begin BBold.Down   := not BBold.Down;   BBold.Click;   end;
      Ord('I'):  begin BItalic.Down := not BItalic.Down; BItalic.Click; end;
      Ord('U'):  begin BUnder.Down  := not BUnder.Down;  BUnder.Click;  end;
      Ord('X'):  BCut.Click;
      Ord('C'):  BCopy.Click;
      Ord('V'):  BPast.Click;
      Ord('Z'):  if BUndo.Enabled then BUndo.Click;
      Ord('N'):  BPN.Click;
      VK_DELETE: BPD.Click;
      Ord('S'):  BSave.Click;
      Ord('P'):  BPrint.Click;

      // Justification
      Ord('L'):  begin BLeft.Down  := not BLeft.Down;  BLeft.Click;  end;
      Ord('E'):  begin BCent.Down  := not BCent.Down;  BCent.Click;  end;
      Ord('R'):  begin BRight.Down := not BRight.Down; BRight.Click; end;

      // Disable these...
      Ord('O'):; Ord('F'):; Ord('T'):;
      Ord('1'):; Ord('2'):; Ord('3'):;
      Ord('G'):;

    else
      // If it wasn't in the list above, it wasn't eaten by the tools menu.
      bHandleThis := false;
    end;
  end else if GetKeyState(VK_MENU)<0 then begin
    // Anything with an Alt key is handled
    bHandleThis := true;
    case Msg.CharCode of
      Ord('R'):  if BPR.Enabled then BReload.Click;
      Ord('T'):  BTest.Click;
      Ord('X'):  BExit.Click;
      VK_LEFT:   if BPL.Enabled then BPL.Click;
      VK_RIGHT:  if BPR.Enabled then BPR.Click;
      VK_UP:     if UpDown1.Enabled then begin
                    UpDown1.Position := UpDown1.Position + 1; UpDown1Click(Self,btNext); end;
      VK_DOWN:   if UpDown1.Enabled then begin
                    UpDown1.Position := UpDown1.Position - 1; UpDown1Click(Self,btPrev); end;
      VK_F4:     BExit.Click;

      // Disable the following main-menu shortcuts
      Ord('A'):; Ord('E'):; Ord('L'):; Ord('N'):; Ord('O'):;
      Ord('D'):; Ord('S'):; Ord('H'):;
    end;
  end else
    bHandleThis := false;
  Handled := bHandleThis;
end;

procedure TFTools.FontSizeChange(Sender: TObject);
var V,C : integer;
begin
  if not bDisableEvents then begin
    val(FTools.FontSize.Text,V,C);
    if (C=0) and (V>0) then begin
      FTools.UpDown1.Position:=V;
      UpDown1Click(Sender, btNext);
    end;
  end;
end;

procedure TFTools.CBFontCloseUp(Sender: TObject);
begin
  FEditWin.RESong.SetFocus;
end;

procedure TFTools.FormCreate(Sender: TObject);
begin
  MsgLastPage := 'Sorry! All songs must have at least one page';
  MsgConfirm  := 'Delete this page? Please confirm';
  MsgUnsaved  := 'You will lose changes made to this page - ok?';
  bDisableEvents := false;
end;

end.
