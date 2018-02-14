unit VideoStreamer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DSPack, DSUtil, DirectShow9, jpeg, ExtCtrls, WindowlessRTF;

type
  TVideoStream = class(TForm)
    VideoWindow: TVideoWindow;
    FilterGraph: TFilterGraph;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
   // VMRBitmap:  TVMRBitmap;
  end;

var
  VideoStream: TVideoStream;

implementation

{$R *.dfm}


procedure TVideoStream.FormDestroy(Sender: TObject);
begin
  FilterGraph.ClearGraph;
  FilterGraph.Active := false;
end;

procedure TVideoStream.FormShow(Sender: TObject);
const
   MaxRGBQuads = MaxInt div SizeOf(TRGBQuad) - 1;
type
   TRGBQuadArray = array[0..MaxRGBQuads] of TRGBQuad;
   PRGBQuadArray = ^TRGBQuadArray;
var
    Bitmap: TBitmap;
    VMRBitmap : IVMRMixerBitmap9;
    VMRRect : TVMR9NormalizedRect;
    FVMRALPHABITMAP: TVMR9ALPHABITMAP;

    bmi: BITMAPINFO;
    BMP: Windows.TBITMAP;
    NewBMP, OldBMPDC: HBITMAP;
    HWinDC, HWinBMPDC : HDC;
    cx, cy : cardinal;
    rRenderRect : TRect;
    pvBits : Pointer;

    ImageBits: PRGBQuadArray;
begin
  FilterGraph.ClearGraph;
  FilterGraph.Active := true;
  FilterGraph.RenderFile('video.avi');

  Bitmap := TBitmap.Create();
  Bitmap.LoadFromFile( 'bitmap.bmp' );

  VideoWindow.QueryInterface(IVMRMixerBitmap9, VMRBitmap);

  FillChar(FVMRALPHABITMAP, SizeOf(FVMRALPHABITMAP), 0);
  FVMRALPHABITMAP.dwFlags      := VMR9AlphaBitmap_hDC;
  FVMRALPHABITMAP.hdc          := Bitmap.Canvas.Handle;

  // The source rectangle is the entire bitmap.
  FVMRALPHABITMAP.rSrc := Rect( 0,0, Bitmap.Width, Bitmap.Height );

  // The target rectangle is the upper left corner of the video image,
  // expressed as a percentage of the image.
  FVMRALPHABITMAP.rDest.left := 0;
  FVMRALPHABITMAP.rDest.top := 0;
  FVMRALPHABITMAP.rDest.right := 1;
  FVMRALPHABITMAP.rDest.bottom := 1;
  FVMRALPHABITMAP.fAlpha := 0.7;

  VMRBitmap.SetAlphaBitmap( @FVMRALPHABITMAP );


{  with VMRBitmap, Canvas do
  begin
    LoadEmptyBitmap(300,200,pf24bit, clSilver);
    Source := VMRBitmap.Canvas.ClipRect;
    Options := VMRBitmap.Options + [vmrbSrcColorKey];
    ColorKey := clSilver;
    Brush.Color := clSilver;
    Font.Color := clWhite;
    Font.Style := [fsBold];
    Font.Size := 30;
    Font.Name := 'Arial';
    TextOut(0,0,'Hello Word :)');
    DrawTo(0,0,1,1,1);
  end;}

  {Begin
    Bitmap:= TBitmap.Create;
    Bitmap.Canvas.Pen.Color := clRed;
    Bitmap.Canvas.FillRect( rect(0,0,300,300) );
    try
      VMRBitmap.LoadBitmap(Bitmap);
      VMRBitmap.Source := VMRBitmap.Canvas.ClipRect;
      VMRBitmap.DrawTo(0,0,0.5,0.5, 0.5);
    finally
      Bitmap.Free;
    end;
  end;}

  FilterGraph.Play;
end;

end.
