unit SongBase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus;

type
  TFSongBase = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    NewDatabase: TMenuItem;
    OpenDatabase: TMenuItem;
    CloseDatabase: TMenuItem;
    SaveAs: TMenuItem;
    Print1: TMenuItem;
    Exit1: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSongBase: TFSongBase;

implementation

{$R *.DFM}

end.
