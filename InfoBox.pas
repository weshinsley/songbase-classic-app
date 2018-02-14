unit InfoBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFInfoBox = class(TForm)
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowBox( Sender : TForm; sStr : string );
  end;

var
  FInfoBox: TFInfoBox;

implementation

{$R *.dfm}

procedure TFInfoBox.ShowBox( Sender : TForm; sStr : string );
var stSize : TSize;
begin
  Label1.Caption := sStr;
  Top  := Sender.Top  + ( Sender.Height - Height ) div 2;
  Left := Sender.Left + ( Sender.Width  - Width  ) div 2;
  Show;
  Canvas.Font := Label1.Font;
  stSize := Canvas.TextExtent( Label1.Caption );
  Canvas.TextOut( Label1.Left + ( Label1.Width  - stSize.cx ) div 2,
                  Label1.Top  + ( Label1.Height - stSize.cy ) div 2,
                  Label1.Caption );
end;

end.
