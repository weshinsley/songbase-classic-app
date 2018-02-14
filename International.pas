unit International;

interface
  uses XMLIntf, Controls, Classes, StdCtrls;

  procedure International_LoadLanguage( sLang : string );
  function  International_GetItem( hXML : IXMLNode; sItem : string ) : IXMLNode;
  function  International_Process( sItem : string ) : string;
  procedure International_SetComponent( hXML : IXMLNode; hComp : TControl; sItem : string );
  procedure International_ReadArray( hXML : IXMLNode; hResult : TStrings; sPrefix : string );
  procedure International_MultipleLines( hComps : array of TLabel; sLine : string );
  function International_FormatApp( sString : string ) : TCaption;

implementation

uses XMLDoc, SBMain, SysUtils, StrUtils, Menus, PreviewWindow,
     EditProj, TitleSearch, Tools, InfoBox, Appear, Search, SongDetails,
     ConfigOffsets, SearchResults, About, Import, Export, PrintSelect, 
     PrintSongList, OHPPrint, LinkDesc, LinkForm, HelpWindow, FontConfig,
     SBFiles;

procedure International_LoadLanguage( sLang : string );
const
  aMainMenuTitles : array[0..4] of string = ( 'Database', 'Song', 'Tools', 'Settings', 'Help' );
var
  hXML  : IXMLDocument;
  hStrings, hMain, hMenu, hItem : IXMLNode;
  i, iItem, iOff, iIdx : integer;
  hMenuItem : TMenuItem;
  sCancel, sOK : string;
begin
  // This will produce errors if there's a problem
  hXML := LoadXMLDocument( RunDir+sLang + '.xml' );
  if nil = hXML then begin
    Exit;
  end;
  hStrings := hXML.ChildNodes.FindNode( 'strings' );

  {============================================================================
                               Shared items/messages
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'messages' );
  if hMain <> nil then begin
    sCancel := International_Process( International_GetItem( hMain, 'Cancel' ).Attributes['name'] );
    sOK     := International_Process( International_GetItem( hMain, 'OK'     ).Attributes['name'] );
    FInfoBox.Caption          := International_FormatApp( International_GetItem( hMain, 'Message' ).ChildNodes[0].NodeValue );
    FSongbase.SValidateCache  := International_GetItem( hMain, 'CatCheck' ).ChildNodes[0].NodeValue;
    FSongbase.SValidateUpdate := International_GetItem( hMain, 'CatCorrect' ).ChildNodes[0].NodeValue;
    FSongbase.SSure           := International_GetItem( hMain, 'CheckSure' ).ChildNodes[0].NodeValue;
    FSongbase.SSaveUnsaved    := International_GetItem( hMain, 'CheckSave' ).ChildNodes[0].NodeValue;
    FSongbase.SCheckDelete    := International_GetItem( hMain, 'CheckDelete' ).ChildNodes[0].NodeValue;
    FSongbase.SCheckReset     := International_GetItem( hMain, 'CheckReset' ).ChildNodes[0].NodeValue;
    FSongbase.SCheckDumpAuto  := International_GetItem( hMain, 'CheckDumpAuto' ).ChildNodes[0].NodeValue;
    FSongbase.SBuildQS        := International_FormatApp( International_GetItem( hMain, 'QuickSearch' ).ChildNodes[0].NodeValue );
    FSongbase.SBGFilter       := International_GetItem( hMain, 'BackgroundFilter' ).ChildNodes[0].NodeValue;
    FSettings.SBGError        := International_GetItem( hMain, 'BackgroundErr' ).ChildNodes[0].NodeValue;
    FExport.SWaitMessage      := International_GetItem( hMain, 'CatExport' ).ChildNodes[0].NodeValue;

    hItem := International_GetItem( hMain, 'StopProject' );
    FSongbase.SStopProjCap := hItem.Attributes['name'];
    FSongbase.SStopProjTxt := hItem.ChildNodes[0].NodeValue;

    hItem := International_GetItem( hMain, 'Tempo' );
    FSearch.LTempo.Caption := hItem.Attributes['name'];
    International_ReadArray( hItem, FSearch.CTempo.Items, '' );

    hItem := International_GetItem( hMain, 'Capo' );
    FSearch.LCapo.Caption  := hItem.Attributes['name'];
    International_ReadArray( hItem, FSearch.CCapo.Items, '' );

    hItem := International_GetItem( hMain, 'Key' );
    FSearch.LKey.Caption   := hItem.Attributes['name'];
    International_ReadArray( hItem, FSearch.CKey.Items, '' );
    International_ReadArray( hItem, FSearch.CMM.Items,  'mode' );

    // Copy from SongDetails to Search screen
    FSongDetails.LTempo.Caption := FSearch.LTempo.Caption;
    FSongDetails.LCapo.Caption  := FSearch.LCapo.Caption;
    FSongDetails.LKey.Caption   := FSearch.LKey.Caption;

    // SongDetail lists don't have an 'Any' item
    FSongDetails.CTempo.Items   := FSearch.CTempo.Items;
    FSongDetails.CCapo.Items    := FSearch.CCapo.Items;
    FSongDetails.CKey.Items     := FSearch.CKey.Items;
    FSongDetails.CMM.Items      := FSearch.CMM.Items;
    FSongDetails.CTempo.Items.Delete(0);
    FSongDetails.CCapo.Items.Delete(0);
    FSongDetails.CKey.Items.Delete(0);
    FSongDetails.CMM.Items.Delete(0);
  end;

  {============================================================================
                               Main Form
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'main' );
  if hMain <> nil then begin
    // Build up the menu
    for iIdx := 0 to length(aMainMenuTitles)-1 do begin
      hMenu := International_GetItem( hMain, aMainMenuTitles[iIdx] );
      if hMenu <> nil then begin
        hMenuItem := FSongbase.MainMenu1.Items[iIdx];
        hMenuItem.Caption := International_Process( hMenu.Attributes['name'] );
        iOff := 0;
        for iItem := 0 to hMenu.ChildNodes.Count-1 do begin
          hItem := hMenu.ChildNodes[iItem];
          if hMenuItem.Items[iItem+iOff].IsLine then inc(iOff);
          hMenuItem.Items[iItem+iOff].Caption :=
                International_Process( hItem.Attributes['name'] );
          if hItem.HasChildNodes then
            hMenuItem.Items[iItem+iOff].Hint := hItem.ChildNodes[0].NodeValue;
        end;
      end;
    end;

    hMenu := hMain.ChildNodes.FindNode( 'songinfo' );
    if hMenu <> nil then begin
      FSongbase.PSongInfo.Caption  := hMenu.Attributes['name'];
      FSongbase.LTitle.Caption     := International_GetItem( hMenu, 'Title'      ).Attributes['name'];
      FSongbase.LATitle.Caption    := International_GetItem( hMenu, 'AltTitle'   ).Attributes['name'];
      FSongbase.LAuthor.Caption    := International_GetItem( hMenu, 'Author'     ).Attributes['name'];
      FSongbase.LCopyright.Caption := International_GetItem( hMenu, 'CopyHolder' ).Attributes['name'];
      FSongbase.LCopDate.Caption   := International_GetItem( hMenu, 'CopyDate'   ).Attributes['name'];
      FSongbase.LOfficeNo.Caption  := International_GetItem( hMenu, 'CCLI'       ).Attributes['name'];
      FSongbase.GBUsedBy.Caption   := International_GetItem( hMenu, 'Used'       ).Attributes['name'];

      International_SetComponent( hMenu, FSongbase.BMoreInfo, 'MoreInfo' );
      International_SetComponent( hMenu, FSongbase.BAddToOrder, 'Add' );
      International_SetComponent( hMenu, FSongbase.BEditSong, 'Save' );
      FSongbase.SSaveChanges := FSongbase.BEditSong.Caption;
      FSongbase.SSaveHint    := FSongbase.BEditSong.Hint;

      International_SetComponent( hMenu, FSongbase.BEditSong, 'Edit' );
      FSongbase.SEditSong := FSongbase.BEditSong.Caption;
      FSongbase.SEditHint := FSongbase.BEditSong.Hint;

      International_SetComponent( hMenu, FSongbase.COHP,   'UsedVid' );
      International_SetComponent( hMenu, FSongbase.CRec,   'UsedRec' );
      International_SetComponent( hMenu, FSongbase.CTrans, 'UsedTrans' );
      International_SetComponent( hMenu, FSongbase.CSheet, 'UsedSheet' );

      International_SetComponent( hMenu, FSongbase.BExpandPanel, 'Expand' );
      International_SetComponent( hMenu, FSongbase.BExpandPanel, 'Shrink' );
      International_SetComponent( hMenu, FSongbase.LUnsaved, 'Unsaved' );
    end;

    hMenu := hMain.ChildNodes.FindNode( 'songlist' );
    if hMenu <> nil then begin
      FSongbase.POrder.Caption     := hMenu.Attributes['name'];

      International_SetComponent( hMenu, FSongbase.BDropDownOrders, 'Drop' );
      International_SetComponent( hMenu, FSongbase.BNewOrder,       'New' );
      International_SetComponent( hMenu, FSongbase.EOrder,          'NewBox' );
      International_SetComponent( hMenu, FSongbase.BEarlier,        'Earlier' );
      International_SetComponent( hMenu, FSongbase.BRemFromOrder,   'Remove' );
      International_SetComponent( hMenu, FSongbase.BLater,          'Later' );
      International_SetComponent( hMenu, FSongbase.LKeyShortcut,    'Key' );

      International_SetComponent( hMenu, FSongbase.BProjNow,        'Blank' );
      FSongbase.SBlankText   := FSongbase.BProjNow.Caption;
      FSongbase.SBlankHint   := FSongbase.BProjNow.Hint;
      International_SetComponent( hMenu, FSongbase.BProjNow,        'Live' );
      FSongbase.SProjNowText := FSongbase.BProjNow.Caption;
      FSongbase.SProjNowHint := FSongbase.BProjNow.Hint;

      International_SetComponent( hMenu, FSongbase.BSaveOrder,   'Save' );
      International_SetComponent( hMenu, FSongbase.BDelOrder,    'Remove' );
//      International_SetComponent( hMenu, FSongbase.BPrintOrder,  'Print' );
      FSongbase.CBSC.Hint := FSongbase.LKeyShortcut.Hint;
    end;

    International_SetComponent( hMain, FSongbase.BTitleSearch,      'FindTitle'  );
    International_SetComponent( hMain, FSongbase.BTextSearch,       'Search'     );
    International_SetComponent( hMain, FSongbase.BTitleSearchMulti, 'Songlist'   );
    International_SetComponent( hMain, FSongbase.ImgMultiMon,       'DualScreen' );

    FSongbase.SVersionStr := International_GetItem( hMain, 'Welcome'  ).ChildNodes[0].NodeValue;
    FSongbase.STitleStr   := International_GetItem( hMain, 'Title'    ).ChildNodes[0].NodeValue;
    FSongbase.SShift      := International_GetItem( hMain, 'KeyShift' ).Attributes['name'];
    FSongbase.SCtrl       := International_GetItem( hMain, 'KeyCtrl'  ).Attributes['name'];
    FSongbase.SAlt        := International_GetItem( hMain, 'KeyAlt'   ).Attributes['name'];
  end;

  {============================================================================
                               Edit Form
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'edit' );
  if hMain <> nil then with FTools do begin
    Caption := International_GetItem( hMain, 'Title' ).ChildNodes[0].NodeValue;
    International_SetComponent( hMenu, BTest,   'View'   );
    International_SetComponent( hMenu, BReload, 'Reload' );
    International_SetComponent( hMenu, BExit,   'Exit' );

    BSave.Hint   := International_GetItem( hMain, 'Save' ).ChildNodes[0].NodeValue;
    BPrint.Hint  := International_GetItem( hMain, 'Print' ).ChildNodes[0].NodeValue;
    BUndo.Hint   := International_GetItem( hMain, 'Undo' ).ChildNodes[0].NodeValue;
    BCut.Hint    := International_GetItem( hMain, 'Cut' ).ChildNodes[0].NodeValue;
    BCopy.Hint   := International_GetItem( hMain, 'Copy' ).ChildNodes[0].NodeValue;
    BPast.Hint   := International_GetItem( hMain, 'Paste' ).ChildNodes[0].NodeValue;
    BBold.Hint   := International_GetItem( hMain, 'Bold' ).ChildNodes[0].NodeValue;
    BItalic.Hint := International_GetItem( hMain, 'Italic' ).ChildNodes[0].NodeValue;
    BUnder.Hint  := International_GetItem( hMain, 'Underline' ).ChildNodes[0].NodeValue;
    BLeft.Hint   := International_GetItem( hMain, 'Left' ).ChildNodes[0].NodeValue;
    BCent.Hint   := International_GetItem( hMain, 'Centre' ).ChildNodes[0].NodeValue;
    BRight.Hint  := International_GetItem( hMain, 'Right' ).ChildNodes[0].NodeValue;
    BPL.Hint     := International_GetItem( hMain, 'Prev' ).ChildNodes[0].NodeValue;
    BPR.Hint     := International_GetItem( hMain, 'Next' ).ChildNodes[0].NodeValue;
    BPN.Hint     := International_GetItem( hMain, 'New' ).ChildNodes[0].NodeValue;
    BPD.Hint     := International_GetItem( hMain, 'Delete' ).ChildNodes[0].NodeValue;
    BPickImage.Hint := International_GetItem( hMain, 'Background' ).ChildNodes[0].NodeValue;
    LKey.Caption    := International_GetItem( hMain, 'Key' ).Attributes['name']+ ' ';
    LPages.Caption  := International_GetItem( hMain, 'Pages' ).Attributes['name'] + ' ';

    MsgLastPage := International_GetItem( hMain, 'DeleteErr'  ).ChildNodes[0].NodeValue;
    MsgConfirm  := International_GetItem( hMain, 'DeleteChk'  ).ChildNodes[0].NodeValue;
    MsgUnsaved  := International_GetItem( hMain, 'UnsavedChk' ).ChildNodes[0].NodeValue;

    hMenu := hMain.ChildNodes.FindNode( 'sizes' );
    if hMenu <> nil then begin
      i := CBScreen.ItemIndex;
      CBScreen.Items.Clear;
      for iItem := 0 to hMenu.ChildNodes.Count-1 do begin
        hItem := hMenu.ChildNodes[iItem];
        CBScreen.Items.Add( hItem.NodeValue );
      end;
      CBScreen.ItemIndex := i;
    end;
  end;

  {============================================================================
                               Offsets Form
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'setoffsets' );
  if hMain <> nil then with FConfigOffsets do begin
    STop    := International_GetItem( hMain, 'Top'    ).ChildNodes[0].NodeValue;
    SLeft   := International_GetItem( hMain, 'Left'   ).ChildNodes[0].NodeValue;
    SRight  := International_GetItem( hMain, 'Right'  ).ChildNodes[0].NodeValue;
    SBottom := International_GetItem( hMain, 'Bottom' ).ChildNodes[0].NodeValue;
    SClose  := International_GetItem( hMain, 'Close'  ).Attributes['name'];
    SDone   := International_GetItem( hMain, 'Done'   ).Attributes['name'];

//    LMainText.Caption  := International_GetItem( hMain, 'MAIN' ).ChildNodes[0].NodeValue;
//    LCCLIText.Caption  := International_GetItem( hMain, 'CCLI' ).ChildNodes[0].NodeValue;
{    International_MultipleLines( [LCopyText1, LCopyText2],
         International_GetItem( hMain, 'COPY' ).ChildNodes[0].NodeValue );
    if LCopyText2.Caption = '' then begin
      LCopyText2.Caption := LCopyText1.Caption;
      LCopyText1.Caption := '';
    end;}

    hItem := hMain.ChildNodes.FindNode( 'dialogs' );
    if hItem <> nil then begin
      SCCLI := International_GetItem( hItem, 'CCLI' ).ChildNodes[0].NodeValue;
      SCopy := International_GetItem( hItem, 'Copy' ).ChildNodes[0].NodeValue;
      SMain := International_GetItem( hItem, 'Main' ).ChildNodes[0].NodeValue;
    end;

    hItem := hMain.ChildNodes.FindNode( 'buttons' );
    if hItem <> nil then begin
//      BCCLIMove.Caption   := International_GetItem( hItem, 'Move'   ).ChildNodes[0].NodeValue;
//      BCCLIChange.Caption := International_GetItem( hItem, 'Change' ).ChildNodes[0].NodeValue;
//      BCCLIAsMain.Caption := International_GetItem( hItem, 'AsMain' ).ChildNodes[0].NodeValue;
//      BCopyAsCCLI.Caption := International_GetItem( hItem, 'AsCCLI' ).ChildNodes[0].NodeValue;
//      BCCLIAsCopy.Caption := International_GetItem( hItem, 'AsCopy' ).ChildNodes[0].NodeValue;

//      BCopyMove.Caption   := BCCLIMove.Caption;
//      BMainMove.Caption   := BCCLIMove.Caption;
//      BCopyChange.Caption := BCCLIChange.Caption;
//      BMainChange.Caption := BCCLIChange.Caption;
//      BCopyAsMain.Caption := BCCLIAsMain.Caption;
    end;
  end;

  {============================================================================
                               Settings Form
   ============================================================================}

  hMain := hStrings.ChildNodes.FindNode( 'settings' );
  if hMain <> nil then with FSettings do begin
    hMenu := International_GetItem( hMain, 'Appearance' );
    if hMenu <> nil then begin
      TCSettings.Tabs[SET_TAB_APPEARANCE] := hMenu.Attributes['name'];
      LPrimaryFont.Caption  := International_GetItem( hMenu, 'Primary' ).ChildNodes[0].NodeValue;
      LCopyFont.Caption     := International_GetItem( hMenu, 'Copyright' ).ChildNodes[0].NodeValue;
      LCCLIFont.Caption     := International_GetItem( hMenu, 'CCLI' ).ChildNodes[0].NodeValue;
      LOffsets.Caption      := International_GetItem( hMenu, 'Offsets' ).ChildNodes[0].NodeValue;
      BackTick.Caption      := International_GetItem( hMenu, 'BGColour' ).ChildNodes[0].NodeValue;
      ImageTick.Caption     := International_GetItem( hMenu, 'BGImage' ).ChildNodes[0].NodeValue;
      FileOpenPicture.Title := International_GetItem( hMenu, 'BGWin' ).ChildNodes[0].NodeValue;
      LScaleProj1.Caption   := International_GetItem( hMenu, 'Scale' ).ChildNodes[0].NodeValue;
      CBScaleProjRes.Items[0]  := International_GetItem( hMenu, 'ScaleFull' ).Attributes['name'];
      BChangeFont.Caption   := International_GetItem( hMenu, 'Change' ).Attributes['name'];
      CBShadow.Caption      := International_GetItem( hMenu, 'Shadow' ).ChildNodes[0].NodeValue;
      ForceBGImage.Caption  := International_GetItem( hMenu, 'ForceBGImage' ).ChildNodes[0].NodeValue;

      AutoLoad1.Caption     := International_GetItem( hMenu, 'AutoLoad' ).ChildNodes[0].NodeValue;
      LTempFile.Caption     := International_GetItem( hMenu, 'TempFile' ).ChildNodes[0].NodeValue;
      STempWin              := International_GetItem( hMenu, 'TempWin' ).ChildNodes[0].NodeValue;
      gbFiles.Caption       := International_GetItem( hMenu, 'Files' ).ChildNodes[0].NodeValue;

      hItem := International_GetItem( hMenu, 'Fonts' );
      SBold        := hItem.Attributes['bold'];
      SNoBold      := hItem.Attributes['nobold'];
      SItalic      := hItem.Attributes['italic'];
      SNoItalic    := hItem.Attributes['noitalic'];
      SColoured    := hItem.Attributes['coloured'];
      SDefaultFont := hItem.Attributes['default'];
    end;

{    hMenu := International_GetItem( hMain, 'Network' );
    if hMenu <> nil then begin
      TCSettings.Tabs[SET_TAB_NETWORK] := hMenu.Attributes['name'];
      CBEnableSS.Caption := International_FormatApp(
              International_GetItem( hMenu, 'Send' ).ChildNodes[0].NodeValue );
    end;}

    hMenu := International_GetItem( hMain, 'General' );
    if hMenu <> nil then begin
      TCSettings.Tabs[SET_TAB_GENERAL] := hMenu.Attributes['name'];
      AutoView1.Caption       := International_GetItem( hMenu, 'FirstPageEvery' ).ChildNodes[0].NodeValue;
      AutoViewSingle1.Caption := International_GetItem( hMenu, 'FirstPageSingle' ).ChildNodes[0].NodeValue;
      cbPowerPoint.Caption    := International_GetItem( hMenu, 'PPKeys' ).ChildNodes[0].NodeValue;
      cbProjectNext.Caption   := International_GetItem( hMenu, 'ProjectNext' ).ChildNodes[0].NodeValue;
      CBRemoveSort.Caption    := International_GetItem( hMenu, 'SongsMove' ).ChildNodes[0].NodeValue;
      CBPreviewAspect.Caption :=International_GetItem( hMenu, 'RetainAspect' ).ChildNodes[0].NodeValue;
      CBAutoOHP.Caption       := International_GetItem( hMenu, 'TickOHPUsed' ).ChildNodes[0].NodeValue;
      gbProject.Caption       := International_GetItem( hMenu, 'Projecting' ).ChildNodes[0].NodeValue;
      gbSongList.Caption      := International_GetItem( hMenu, 'SongLists' ).ChildNodes[0].NodeValue;
      cbF2F3WinSearch.Caption := International_GetItem( hMenu, 'F2F3WinSearch' ).ChildNodes[0].NodeValue;
    end;

    hMenu := International_GetItem( hMain, 'CCLI' );
    if hMenu <> nil then begin
      TCSettings.Tabs[SET_TAB_CCLI] := hMenu.Attributes['name'];
      gbCCLI.Caption       := International_GetItem( hMenu, 'Rep' ).ChildNodes[0].NodeValue;
      LRepTitle.Caption    := International_GetItem( hMenu, 'RepTitle' ).ChildNodes[0].NodeValue;
      LRepForename.Caption := International_GetItem( hMenu, 'RepFore' ).ChildNodes[0].NodeValue;
      LRepSurname.Caption  := International_GetItem( hMenu, 'RepSur' ).ChildNodes[0].NodeValue;
      LRepAdd.Caption      := International_GetItem( hMenu, 'RepAddr' ).ChildNodes[0].NodeValue;
      LRepTown.Caption     := International_GetItem( hMenu, 'RepTown' ).ChildNodes[0].NodeValue;
      LRepPostCode.Caption := International_GetItem( hMenu, 'RepPost' ).ChildNodes[0].NodeValue;
      LRepCountry.Caption  := International_GetItem( hMenu, 'RepCountry' ).ChildNodes[0].NodeValue;
      LRepDayTel.Caption   := International_GetItem( hMenu, 'RepDayTel' ).ChildNodes[0].NodeValue;
      LRepEveTel.Caption   := International_GetItem( hMenu, 'RepEveTel' ).ChildNodes[0].NodeValue;
      LExpiry.Caption      := International_GetItem( hMenu, 'Expiry' ).ChildNodes[0].NodeValue;
      LCRef.Caption        := International_GetItem( hMenu, 'Ref' ).ChildNodes[0].NodeValue;
      LCCLicence.Caption   := International_GetItem( hMenu, 'CCLILicence' ).ChildNodes[0].NodeValue;
      LMRLicense.Caption   := International_GetItem( hMenu, 'MRLicence' ).ChildNodes[0].NodeValue;
      LOrg.Caption         := International_GetItem( hMenu, 'Org' ).ChildNodes[0].NodeValue;
      LOrgAd.Caption       := International_GetItem( hMenu, 'Addr' ).ChildNodes[0].NodeValue;
      LOrgTown.Caption     := International_GetItem( hMenu, 'Town' ).ChildNodes[0].NodeValue;
      LOrgPC.Caption       := International_GetItem( hMenu, 'Post' ).ChildNodes[0].NodeValue;
      LOrgCountry.Caption  := International_GetItem( hMenu, 'Country' ).ChildNodes[0].NodeValue;
      LOrgDayTel.Caption   := International_GetItem( hMenu, 'DayTel' ).ChildNodes[0].NodeValue;
      LOrgEveTel.Caption   := International_GetItem( hMenu, 'EveTel' ).ChildNodes[0].NodeValue;
      LOrgFax.Caption      := International_GetItem( hMenu, 'Fax' ).ChildNodes[0].NodeValue;
      LOrgEmail.Caption    := International_GetItem( hMenu, 'Email' ).ChildNodes[0].NodeValue;
      LOrgWeb.Caption      := International_GetItem( hMenu, 'Website' ).ChildNodes[0].NodeValue;
      LRequired.Caption    := International_GetItem( hMenu, 'Required' ).ChildNodes[0].NodeValue;
    end;
  end;

  {============================================================================
                               Preview Window
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'preview' );
  if hMain <> nil then begin
    hMenu := hMain.ChildNodes.FindNode( 'livemodes' );
    if hMenu <> nil then with FProjWin do begin
      SModeSelect            := International_GetItem( hMenu, 'Select' ).ChildNodes[0].NodeValue;
      SModeSearchResultCount := International_GetItem( hMenu, 'SearchResultCount' ).ChildNodes[0].NodeValue;
      SModeSearchResultIdx   := International_GetItem( hMenu, 'SearchResultIndex' ).ChildNodes[0].NodeValue;
      SModeSearchResultNone  := International_GetItem( hMenu, 'SearchResultNone' ).ChildNodes[0].NodeValue;
      SModeShortcut          := International_GetItem( hMenu, 'Shortcut' ).ChildNodes[0].NodeValue;
      SModeSearchWords       := International_GetItem( hMenu, 'SearchWords' ).ChildNodes[0].NodeValue;
      SModeSearchTitle       := International_GetItem( hMenu, 'SearchTitle' ).ChildNodes[0].NodeValue;
      SModeExit              := International_GetItem( hMenu, 'Exit' ).ChildNodes[0].NodeValue;
    end;

    International_SetComponent( hMain, FPreviewWindow.BEditOHP,     'EditPage' );
    International_SetComponent( hMain, FPreviewWindow.BProjectSong, 'ProjectPage' );
    International_SetComponent( hMain, FPreviewWindow.BPrevious,    'Prev' );
    International_SetComponent( hMain, FPreviewWindow.BNext,        'Next' );
    FPreviewWindow.Caption := International_GetItem( hMain, 'PreviewTitle' ).ChildNodes[0].NodeValue;
    FPreviewWindow.LPages.Caption := International_GetItem( hMain, 'Pages' ).Attributes['name'];

    International_SetComponent( hMain, FLiveWindow.BEditOHP,     'EditPage' );
    International_SetComponent( hMain, FLiveWindow.BProjectSong, 'ProjectPage' );
    International_SetComponent( hMain, FLiveWindow.BPrevious,    'Prev' );
    International_SetComponent( hMain, FLiveWindow.BNext,        'Next' );
    FLiveWindow.Caption := International_GetItem( hMain, 'PreviewTitle' ).ChildNodes[0].NodeValue;
    FLiveWindow.LPages.Caption := International_GetItem( hMain, 'Pages' ).Attributes['name'];
    FLiveWindow.SLivePrefix    := International_GetItem( hMain, 'LiveTitle' ).ChildNodes[0].NodeValue;

    hMenu := hMain.ChildNodes.FindNode( 'previewmodes' );
    if hMenu <> nil then with FLiveWindow do begin
      SModeSelect      := International_GetItem( hMenu, 'Select' ).ChildNodes[0].NodeValue;
      SModeSong        := International_GetItem( hMenu, 'Song' ).ChildNodes[0].NodeValue;
      SModeSearchWords := International_GetItem( hMenu, 'SearchWords' ).ChildNodes[0].NodeValue;
      SModeSearchTitle := International_GetItem( hMenu, 'SearchTitle' ).ChildNodes[0].NodeValue;
      SModeSearching   := International_GetItem( hMenu, 'Searching' ).ChildNodes[0].NodeValue;
      SModeExit        := International_GetItem( hMenu, 'Exit' ).ChildNodes[0].NodeValue;
      SModeBlank       := International_GetItem( hMenu, 'Blank' ).ChildNodes[0].NodeValue;
    end;
  end;

  {============================================================================
                               Search Window
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'search' );
  if hMain <> nil then with FSearch do begin
    Caption := International_FormatApp( hMain.Attributes['name'] );
    LText.Caption := International_GetItem( hMain, 'Text' ).ChildNodes[0].NodeValue;
    CBOHPSearch.Caption := International_GetItem( hMain, 'OHP' ).ChildNodes[0].NodeValue;
    BOK.Caption := International_Process( International_GetItem( hMain, 'SearchButton' ).Attributes['name'] );
    SAdvanced := International_GetItem( hMain, 'Advanced' ).Attributes['name'];
    SSimple   := International_GetItem( hMain, 'Simple' ).Attributes['name'];
    BOptions.Caption := SAdvanced;
    BCancel.Caption  := sCancel;

    FSearchResults.SSearchStart    := International_GetItem( hMain, 'SearchStart'  ).ChildNodes[0].NodeValue;
    FSearchResults.SSearchResult   := International_GetItem( hMain, 'SearchResult' ).ChildNodes[0].NodeValue;
    FSearchResults.SSearchComplete := International_GetItem( hMain, 'SearchComplete' ).ChildNodes[0].NodeValue;
  end;

  {============================================================================
                               Search Form
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'titlesearch' );
  if hMain <> nil then with FTitle do begin
    Caption  := hMain.Attributes['name'];
    MoreThan := hMain.ChildNodes[0].NodeValue;
    BCancel.Caption := sCancel;
    BOK.Caption := sOK;
  end;

  {============================================================================
                               Print Select Window
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'printselect' );
  if hMain <> nil then with FPrintSelect do begin
    BCancel.Caption    := sCancel;
    BOK.Caption        := sOK;
    hItem := International_GetItem( hMain, 'ReportType' );
    International_ReadArray( hItem, PCBReport.Items, '' );
    Label2.Caption     := hItem.Attributes['name'];
    Label1.Caption     := International_GetItem( hMain, 'Include'     ).Attributes['name'];
    PCOHP.Caption      := International_GetItem( hMain, 'VidProj'     ).Attributes['name'];
    PCTrans.Caption    := International_GetItem( hMain, 'PrintOHP'    ).Attributes['name'];
    PCPrint.Caption    := International_GetItem( hMain, 'PrintSheet'  ).Attributes['name'];
    PCRec.Caption      := International_GetItem( hMain, 'Recorded'    ).Attributes['name'];
    PCPhoto.Caption    := International_GetItem( hMain, 'Photocopied' ).Attributes['name'];
    PCAll.Caption      := International_GetItem( hMain, 'AllSongs'    ).Attributes['name'];
    PCBPreview.Caption := International_GetItem( hMain, 'Preview'     ).Attributes['name'];
  end;

  {============================================================================
                               Import Window
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'import' );
  if hMain <> nil then with FImport do begin
    Caption := hMain.Attributes['name'];

    // States
    hItem   := International_GetItem( hMain, 'States' );
    SongStates[0] := hItem.Attributes['same'];
    SongStates[1] := hItem.Attributes['new'];
    SongStates[2] := hItem.Attributes['newer'];
    SongStates[3] := hItem.Attributes['older'];

    // Title
//    lvFileList.Columns[0].Caption := International_GetItem( hMain, 'ColTitle' ).Attributes['name'];

    BCancel.Caption := International_GetItem( hMain, 'Cancel' ).Attributes['name'];
//    CBLinks.Caption := International_GetItem( hMain, 'Multimedia' ).Attributes['name'];
    BImport.Caption := International_GetItem( hMain, 'Import' ).Attributes['name'];
  end;

  {============================================================================
                               Export Window
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'export' );
  if hMain <> nil then with FExport do begin
    Caption   := International_GetItem( hMain, 'TitleChoose' ).Attributes['name'];
    FileTitle := International_GetItem( hMain, 'TitleFile'   ).Attributes['name'];

    // Title
    lvFileList.Columns[0].Caption := International_GetItem( hMain, 'ColTitle' ).Attributes['name'];

    BCancel.Caption := International_GetItem( hMain, 'Cancel' ).Attributes['name'];
    CBLinks.Caption := International_GetItem( hMain, 'Multimedia' ).Attributes['name'];
    BExport.Caption := International_GetItem( hMain, 'Export' ).Attributes['name'];
  end;

  {============================================================================
                               About Window
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'about' );
  if hMain <> nil then with FAbout do begin
    Caption := International_FormatApp( hMain.Attributes['name'] );
    International_MultipleLines( [Copyright, Label3], International_Process(
            International_GetItem( hMain, 'CopyRight' ).ChildNodes[0].NodeValue ));
    Comments.Caption  := International_GetItem( hMain, 'Copy' ).ChildNodes[0].NodeValue;
    CheckFor.Caption  := International_GetItem( hMain, 'Updates' ).ChildNodes[0].NodeValue;
  end;

  {============================================================================
                               Report Preview
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'reportpreview' );
  if hMain <> nil then begin
  {  FPreview.Caption := hMain.Attributes['name'];}
  end;

  {============================================================================
                               Print Songlist
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'printlist' );
  if hMain <> nil then with FPSong do begin
    Caption := hMain.Attributes['name'];
    LTitle.Caption    := International_GetItem( hMain, 'Title' ).Attributes['name'];
    LSubTitle.Caption := International_GetItem( hMain, 'SubTitle' ).Attributes['name'];
    CSK.Caption       := International_GetItem( hMain, 'ShortCut' ).Attributes['name'];
    CIK.Caption       := International_GetItem( hMain, 'IncludeKeys' ).Attributes['name'];
    CBCapo.Caption    := International_GetItem( hMain, 'IncludeCapo' ).Attributes['name'];
    BPrint.Caption    := International_Process( International_GetItem( hMain, 'Print' ).Attributes['name'] );
    BCancel.Caption   := sCancel;
  end;

  {============================================================================
                               Print OHP
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'printohp' );
  if hMain <> nil then with FPOHP do begin
    Caption          := hMain.Attributes['name'];
    RB1.Caption      := International_GetItem( hMain, 'ThisPage' ).Attributes['name'];
    RBA.Caption      := International_GetItem( hMain, 'AllPage' ).Attributes['name'];
    BPrint.Caption   := International_Process( International_GetItem( hMain, 'Print' ).Attributes['name'] );
    BCancel.Caption  := sCancel;
  end;

  {============================================================================
                               Multimedia Links
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'multimedia' );
  if hMain <> nil then begin
    FLinkForm.Caption              := hMain.Attributes['name'];
    FLinkForm.LLocation.Caption    := International_GetItem( hMain, 'Location' ).Attributes['name'];
    FLinkForm.LDescription.Caption := International_GetItem( hMain, 'Description' ).Attributes['name'];
    FLinkForm.BLocate.Caption      := International_Process( International_GetItem( hMain, 'Locate' ).Attributes['name'] );
    FLinkDesc.LDescription.Caption := FLinkForm.LDescription.Caption;
    FLinkDesc.Caption              := International_GetItem( hMain, 'Describe' ).Attributes['name'];

    FLinkForm.BOK.Caption          := sOK;
    FLinkForm.BCancel.Caption      := sCancel;
    FLinkDesc.BOK.Caption          := sOK;
    FLinkDesc.BCancel.Caption      := sCancel;
  end;

  {============================================================================
                              More Info
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'moreinfo' );
  if hMain <> nil then with FSongDetails do begin
    Caption        := hMain.Attributes['name'];
    CPhoto.Caption := International_GetItem( hMain, 'Photocopied' ).ChildNodes[0].NodeValue;
    LMus.Caption   := International_GetItem( hMain, 'MusicBook' ).ChildNodes[0].NodeValue;
    International_MultipleLines( [LIsbn, LPub],
            International_GetItem( hMain, 'ISBN' ).ChildNodes[0].NodeValue );
    LTune.Caption  := International_GetItem( hMain, 'Tune' ).ChildNodes[0].NodeValue;
    International_MultipleLines( [LArr1, LArr2],
            International_GetItem( hMain, 'Composer' ).ChildNodes[0].NodeValue );
    Label3.Caption := International_GetItem( hMain, 'MusicOther' ).ChildNodes[0].NodeValue;
    LAuto.Caption  := International_GetItem( hMain, 'Auto' ).ChildNodes[0].NodeValue;
    Label4.Caption := International_GetItem( hMain, 'Multimedia' ).Attributes['name'];
    LC1.Caption    := International_GetItem( hMain, 'Copy1' ).Attributes['name'];
    LC2.Caption    := International_GetItem( hMain, 'Copy2' ).Attributes['name'];
    Label1.Caption := International_GetItem( hMain, 'Notes' ).Attributes['name'];
    LKey.Caption   := International_GetItem( hMain, 'Key' ).Attributes['name'];
    LCapo.Caption  := International_GetItem( hMain, 'Capo' ).Attributes['name'];
    LTempo.Caption := International_GetItem( hMain, 'Tempo' ).Attributes['name'];

    BAddLink.Caption  := International_Process( International_GetItem( hMain, 'AddLink' ).Attributes['name'] );
    BShowLink.Caption := International_Process( International_GetItem( hMain, 'Show' ).Attributes['name'] );
    BExtract.Caption  := International_Process( International_GetItem( hMain, 'Extract' ).Attributes['name'] );
    BRenLink.Caption  := International_Process( International_GetItem( hMain, 'Rename' ).Attributes['name'] );
    BDelLink.Caption  := International_Process( International_GetItem( hMain, 'Delete' ).Attributes['name'] );
  end;

  {============================================================================
                              Help
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'help' );
  if hMain <> nil then with FHelpWindow do begin
    Caption       := hMain.Attributes['name'];
    BBack.Caption := International_GetItem(     hMain, 'Contents' ).Attributes['name'];
    BClose.Caption := International_GetItem(    hMain, 'Back'     ).Attributes['name'];
    BContents.Caption := International_GetItem( hMain, 'Forward'  ).Attributes['name'];
    BForward.Caption := International_GetItem(  hMain, 'Close'    ).Attributes['name'];
  end;

  {============================================================================
                              Font Configuration
   ============================================================================}
  hMain := hStrings.ChildNodes.FindNode( 'fonts' );
  if hMain <> nil then with FFontConfig do begin
    Caption          := hMain.Attributes['name'];
    FontTick.Caption := International_GetItem( hMain, 'Force' ).Attributes['name'];
    Label1.Caption   := International_GetItem( hMain, 'Text' ).Attributes['name'];
    Label3.Caption   := International_GetItem( hMain, 'Size' ).Attributes['name'];
    SizeTick.Caption := FontTick.Caption;
    BoldTick.Caption := FontTick.Caption;
    ItalTick.Caption := FontTick.Caption;
    ForeTick.Caption := FontTick.Caption;
    BOK.Caption      := sOK;
  end;

end;

function International_Process( sItem : string ) : string;
begin
  sItem := AnsiReplaceStr( sItem, '_', '&' );
  sItem := AnsiReplaceStr( sItem, '&copy;', Chr(169) );
  International_Process := sItem;
end;

procedure International_SetComponent( hXML : IXMLNode; hComp : TControl; sItem : string );
var hItem : IXMLNode;
    sName : string;
begin
  hItem := International_GetItem( hXML, sItem );
  if hItem <> nil then begin
    if hItem.HasAttribute('name') then begin
      sName := International_Process( hItem.Attributes['name'] );
      if      hComp is TLabel    then   TLabel(hComp).Caption    := sName
      else if hComp is TCheckBox then   TCheckBox(hComp).Caption := sName
      else if hComp is TButton   then   TButton(hComp).Caption   := sName;
    end;
    if hItem.HasChildNodes then hComp.Hint := hItem.ChildNodes[0].NodeValue;
  end;
end;


function International_GetItem( hXML : IXMLNode; sItem : string ) : IXMLNode;
var hNode : IXMLNode;
begin
  International_GetItem := nil;
  hNode := hXML.ChildNodes.First;
  while hNode <> nil do begin
    if hNode.Attributes['id'] = sItem then begin
      International_GetItem := hNode;
      Exit;
    end;
    hNode := hNode.NextSibling;
  end;
end;

function International_FormatApp( sString : string ) : TCaption;
var sStr : string;
begin
  FmtStr( sStr, sString, [APPNAME] );
  International_FormatApp := sStr;
end;

procedure International_ReadArray( hXML : IXMLNode; hResult : TStrings; sPrefix : string );
var hNode   : IXMLNode;
    iItem   : integer;
begin
  for iItem := 0 to hResult.Capacity-1 do begin
    hNode := International_GetItem( hXML, sPrefix + IntToStr(iItem) );
    if hNode <> nil then begin
      hResult[iItem] := String(hNode.ChildNodes[0].NodeValue);
    end;
  end;
end;

procedure International_MultipleLines( hComps : array of TLabel; sLine : string );
var i, iOff    : integer;
    sRemainStr : string;
begin
  sRemainStr := sLine;
  for i := 0 to Length(hComps)-1 do begin
    iOff := Pos( Chr(10), sRemainStr );
    if iOff = 0 then begin
      hComps[i].Caption := sRemainStr;
      sRemainStr := '';
    end else begin
      hComps[i].Caption := LeftStr( sRemainStr, iOff-1 );
      sRemainStr := Copy( sRemainStr, 1+iOff, Length(sRemainStr) );
    end;
  end;
end;

end.
