unit PrintSongList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SBFiles;

type
  TFPSong = class(TForm)
    ETitle: TEdit;
    LTitle: TLabel;
    ESubTitle: TEdit;
    LSubTitle: TLabel;
    CSK: TCheckBox;
    CIK: TCheckBox;
    CBTrans: TComboBox;
    CBCapo: TCheckBox;
    BPrint: TButton;
    BCancel: TButton;
    procedure CIKClick(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
    procedure BPrintClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DataF : string;
    OrderD : string;
    posX,posY : integer;
  end;

var
  FPSong: TFPSong;
const
  Kys : array[0..11] of string =
  ('C','C#','D','Eb','E','F','F#','G','Ab','A','Bb','B');
  chr128 = chr(128);

implementation

uses SBMain;

{$R *.DFM}

procedure TFPSong.CIKClick(Sender: TObject);
begin
  CBTrans.Enabled:=CIK.Checked;
  CBCapo.Enabled:=CIK.Checked;
end;

procedure TFPSong.BCancelClick(Sender: TObject);
begin
  close;
end;

function Transpose(i,j : byte) : byte;
var k : integer;
begin
  k:=i-j;
  if k<0 then k:=k+12;
  Transpose:=k;
end;

procedure TFPSong.BPrintClick(Sender: TObject);
var SCNo,KeyNo,SC1,SC2 : byte;
    DF : TextFile;
    code,i : integer;
    SR : SongRecord;
    findId,S,SO,St: string;

begin
 { FPreview.F1Book1.MaxRow:=9999;
  FPreview.F1Book1.MaxCol:=20;
  FPreview.F1Book1.ColText[1]:='';
  FPreview.F1Book1.ColText[2]:='';
  FPreview.F1Book1.ColText[3]:='';
  FPreview.F1Book1.TextRC[1,1]:=ETitle.Text;
  FPreview.F1Book1.TextRC[2,1]:=ESubTitle.Text;
  FPreview.F1Book1.TextRC[1,2]:='';  FPreview.F1Book1.TextRC[2,2]:='';
  FPreview.F1Book1.TextRC[1,3]:='';  FPreview.F1Book1.TextRC[2,3]:='';
  FPreview.F1Book1.TextRC[4,1]:='Title';
  SCNo:=0; KeyNo:=0;
  if CSK.Checked then begin SCNo:=2; FPreview.F1Book1.TextRC[4,2]:='Shortcut'; end;
  if CIK.Checked then KeyNo:=ScNo+1;
  if KeyNo=1 then KeyNo:=2;
  if KeyNo>0 then begin
    FPreview.F1Book1.TextRC[4,KeyNo]:='Key';
    if (CBTrans.ItemIndex>0) then FPreview.F1Book1.TextRC[4,KeyNo]:=FPreview.F1Book1.TextRC[5,KeyNO]+' ('+Kys[CBTrans.ItemIndex]+')';
  end;
  for i:=1 to 3 do FPreview.F1Book1.TextRC[5,i]:='';
  SO:=chr128;
  SO:=OrderD;
  i:=6;
  while SO<>'' do begin
    findID:=copy(SO,1,pos(chr128,SO)-1);
    SO:=copy(SO,pos(chr128,SO)+1,lengtH(SO));
    val(copy(SO,1,pos('~',SO)-1),SC1,Code);
    SO:=copy(SO,pos('~',SO)+1,lengtH(SO));
    val(copy(SO,1,pos(chr128,SO)-1),SC2,Code);
    SO:=copy(SO,pos(chr128,SO)+1,lengtH(SO));
    if not OpenForRead(DF,DataF) then Exit;
    repeat
      readln(DF,St);
      Delimit(St,SR);
    until SR.ID=findID;
    CloseTextfile(DF,DataF);
    FPreview.F1Book1.TextRC[i,1]:=SR.Title;
    if ScNo>0 then FPreview.F1Book1.TextRC[i,2]:=FSongbase.StringSC(SC1,SC2);
    if KeyNo>0 then begin
      S:='';
      if SR.Key<>-1 then begin
       S:=Kys[Transpose(SR.Key,CBTrans.ItemIndex)];
        if (CBCapo.Checked) and (SR.Capo>0) then begin
          str(SR.Capo,St);
          S:=S+' (Capo '+St+', '+Kys[Transpose(SR.Key,SR.Capo)]+')';
        end;
      end;
      FPreview.F1Book1.TextRC[i,KeyNo]:=s;
    end;
    inc(i);
  end;
  dec(i);

  // for i:=1 to 3 do FPreview.F1Book1.Coltext[i]:='';
  if ScNo>=KeyNo then KeyNo:=ScNo+1;

  FPreview.F1Book1.SetColWidth(1,1,10000,false);
  FPreview.F1Book1.SetColWidth(2,3,5000,false);
  FPreview.F1Book1.SetRowHeightAuto(1,1,i+1,6,true);
  FPreview.F1Book1.PrintColHeading:=false;
  FPreview.F1Book1.PrintFooter:='';
  FPreview.F1Book1.PrintHeader:='';
  FPreview.F1Book1.SetSelection(1,1,i,KeyNo);
  //s:=FPreview.F1Book1.TextRC[7,1];
  FPreview.F1Book1.SetPrintAreaFromSelection;
  FPreview.F1Book1.FilePrint(true);  }
  close;
end;

procedure TFPSong.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  posY:=top;
  posX:=left;
end;

procedure TFPSong.FormShow(Sender: TObject);
begin
  top:=posY;
  left:=posX;
end;

end.
