unit HelpWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, ExtCtrls, StdCtrls;

type
  TFHelpWindow = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    WebBrowser1: TWebBrowser;
    BBack: TButton;
    BForward: TButton;
    BContents: TButton;
    BClose: TButton;
    procedure FormShow(Sender: TObject);
    procedure WebBrowser1TitleChange(Sender: TObject;
      const Text: WideString);
    procedure FormResize(Sender: TObject);
    procedure BContentsClick(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
    procedure BBackClick(Sender: TObject);
    procedure BForwardClick(Sender: TObject);
    procedure WebBrowser1CommandStateChange(Sender: TObject;
      Command: Integer; Enable: WordBool);
  private
    { Private declarations }

    // Used to keep this window off the projection screen
    procedure WMWindowPosChanging(var hMsg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;

  public
    { Public declarations }
  end;

var
  FHelpWindow: TFHelpWindow;

implementation

uses SBMain, About, EditProj;

{$R *.dfm}

procedure TFHelpWindow.FormShow(Sender: TObject);
begin
  Left := FAbout.posX;
  Top  := FAbout.posY;
  BContentsClick(Sender);
end;

procedure TFHelpWindow.WebBrowser1TitleChange(Sender: TObject;
  const Text: WideString);
begin
  Caption := Text;
end;

procedure TFHelpWindow.FormResize(Sender: TObject);
begin
  Panel2.SetBounds( 0, 0, ClientWidth, Panel2.Height );
  Panel1.SetBounds( 0, Panel2.Height, ClientWidth, ClientHeight - Panel2.Height );
end;

procedure TFHelpWindow.BContentsClick(Sender: TObject);
begin
  WebBrowser1.Navigate( SBMain.RunDir + 'html\index.html' );
end;

procedure TFHelpWindow.BCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFHelpWindow.BBackClick(Sender: TObject);
begin
  WebBrowser1.GoBack;
end;

procedure TFHelpWindow.BForwardClick(Sender: TObject);
begin
  WebBrowser1.GoForward;
end;

procedure TFHelpWindow.WebBrowser1CommandStateChange(Sender: TObject;
  Command: Integer; Enable: WordBool);
begin
  case Command of
    CSC_NAVIGATEFORWARD:
      BForward.Enabled := Enable;
    CSC_NAVIGATEBACK:
      BBack.Enabled := Enable;
  end;
end;


procedure TFHelpWindow.WMWindowPosChanging(var hMsg: TWMWindowPosChanging);
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

end.
