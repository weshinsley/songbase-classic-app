program SongBase;

{%ToDo 'SongBase.todo'}
{%File 'TODO.TXT'}
{%File 'CHANGES.TXT'}
{%File 'en_GB.xml'}

uses
  Forms,
  SBMain in 'SBMain.pas' {FSongbase},
  PrintSelect in 'PrintSelect.pas' {FPrintSelect},
  Search in 'Search.pas' {FSearch},
  EditProj in 'EditProj.pas' {FEditProj},
  Appear in 'Appear.pas' {FSettings},
  Export in 'Export.pas' {FExport},
  About in 'About.pas' {FAbout},
  PrintSongList in 'PrintSongList.pas' {FPSong},
  OHPPrint in 'OHPPrint.pas' {FPOHP},
  TitleSearch in 'TitleSearch.pas' {FTitle},
  LinkForm in 'LinkForm.pas' {FLinkForm},
  LinkDesc in 'LinkDesc.pas' {FLinkDesc},
  SBZipUtils in 'SBZipUtils.pas',
  SBFiles in 'SBFiles.pas',
  ConfigOffsets in 'ConfigOffsets.pas' {FConfigOffsets},
  Tools in 'Tools.pas' {FTools},
  PreviewWindow in 'PreviewWindow.pas' {FPreviewWindow},
  SongDetails in 'SongDetails.pas' {FSongDetails},
  SearchResults in 'SearchResults.pas' {FSearchResults},
  SearchThread in 'SearchThread.pas',
  InfoBox in 'InfoBox.pas' {FInfoBox},
  HelpWindow in 'HelpWindow.pas' {FHelpWindow},
  FontConfig in 'FontConfig.pas' {FFontConfig},
  PageCache in 'PageCache.pas',
  International in 'International.pas',
  WindowlessRTF in 'WindowlessRTF.pas',
  TOM in 'TOM.pas',
  SelectProjectScreen in 'SelectProjectScreen.pas' {FSelectProjectScreen},
  RichTom in 'RichTom.pas',
  Import in 'Import.pas' {FImport},
  VideoStreamer in 'VideoStreamer.pas' {VideoStream},
  SongList in 'SongList.pas' {FSongList},
  WebServer in 'WebServer.pas' {FWebServer},
  update in 'update.pas' {FUpdate},
  NetSetup in 'NetSetup.pas' {FNetSetup},
  AddScreen in 'AddScreen.pas' {FAddScreen};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Songbase';
  Application.CreateForm(TFSongbase, FSongbase);
  Application.CreateForm(TFPrintSelect, FPrintSelect);
  Application.CreateForm(TFSearch, FSearch);
  Application.CreateForm(TFSettings, FSettings);
  Application.CreateForm(TFExport, FExport);
  Application.CreateForm(TFAbout, FAbout);
  Application.CreateForm(TFPSong, FPSong);
  Application.CreateForm(TFPOHP, FPOHP);
  Application.CreateForm(TFTitle, FTitle);
  Application.CreateForm(TFLinkForm, FLinkForm);
  Application.CreateForm(TFLinkDesc, FLinkDesc);
  Application.CreateForm(TFConfigOffsets, FConfigOffsets);
  Application.CreateForm(TFTools, FTools);
  Application.CreateForm(TFPreviewWindow, FPreviewWindow);
  Application.CreateForm(TFSongDetails, FSongDetails);
  Application.CreateForm(TFSearchResults, FSearchResults);
  Application.CreateForm(TFInfoBox, FInfoBox);
  Application.CreateForm(TFHelpWindow, FHelpWindow);
  Application.CreateForm(TFFontConfig, FFontConfig);
  Application.CreateForm(TFSelectProjectScreen, FSelectProjectScreen);
  Application.CreateForm(TFImport, FImport);
  Application.CreateForm(TVideoStream, VideoStream);
  Application.CreateForm(TFSongList, FSongList);
  Application.CreateForm(TFWebServer, FWebServer);
  Application.CreateForm(TFUpdate, FUpdate);
  Application.CreateForm(TFNetSetup, FNetSetup);
  Application.CreateForm(TFAddScreen, FAddScreen);
  // More windowsy stuff...
  Application.CreateForm(TFPreviewWindow, FLiveWindow);
  Application.CreateForm(TFEditProj, FEditWin);
  Application.CreateForm(TFEditProj, FProjWin);
  Application.Run;
end.
