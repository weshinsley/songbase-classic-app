unit SelectProjectScreen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFSelectProjectScreen = class(TForm)
    Label1: TLabel;
    CrossHair: TImage;
    BCancel: TButton;
    Timer1: TTimer;
    LScreen: TLabel;
    procedure CrossHairMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CrossHairMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BCancelClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MonitorNum : integer;
  end;

var
  FSelectProjectScreen: TFSelectProjectScreen;

implementation

uses Appear, SBMain;

{$R *.dfm}

procedure TFSelectProjectScreen.CrossHairMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor  := crCross;
  SetCapture(Self.Handle);
  Timer1.Enabled := true;
end;

procedure TFSelectProjectScreen.CrossHairMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var hMonitor, hPrimary : TMonitor;
begin
  ReleaseCapture;
  Screen.Cursor  := crDefault;
  Timer1.Enabled := false;
  if not PtInRect( Self.BoundsRect, Mouse.CursorPos ) then begin
    hMonitor := Screen.Monitors[MonitorNum-1];
    FSongbase.DefaultScreen     := MonitorNum;
    FSongbase.ProjectScreen     := MonitorNum;
    FSongbase.szDisplaySize.cx  := hMonitor.Width;
    FSongbase.szDisplaySize.cy  := hMonitor.Height;
    FSongbase.ptDisplayOrigin.X := hMonitor.Left;
    FSongbase.ptDisplayOrigin.Y := hMonitor.Top;
    FSettings.btMonitor.Caption := IntToStr(MonitorNum);

    // If this is the monitor that currently contains the main window then
    // we disable multimonitor support.
    hPrimary := Screen.MonitorFromPoint( Point( FSongbase.Left, FSongbase.Top ),
                                         mdPrimary );
    FSongbase.bMultiMonitor         := (hMonitor <> hPrimary);
    FSettings.btMonitor.Enabled     := FSongbase.bMultiMonitor;
    FSettings.cbDualMonitor.Checked := FSongbase.bMultiMonitor;
    Close;
  end;
end;

procedure TFSelectProjectScreen.BCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFSelectProjectScreen.Timer1Timer(Sender: TObject);
var hMonitor : TMonitor;
begin
  if not PtInRect( Self.BoundsRect, Mouse.CursorPos ) then begin
    hMonitor := Screen.MonitorFromPoint( Mouse.CursorPos, mdNull );
    if nil <> hMonitor then begin
      LScreen.Caption := 'Screen ' + IntToStr(1+hMonitor.MonitorNum);
      MonitorNum := 1+hMonitor.MonitorNum;
    end;
  end;
end;

procedure TFSelectProjectScreen.FormShow(Sender: TObject);
begin
  MonitorNum := FSongbase.DefaultScreen;
  LScreen.Caption := 'Screen ' + IntToStr(MonitorNum);
end;

end.
