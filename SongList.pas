unit SongList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, SBFiles, Math, PageCache, ComCtrls, ImgList;

type
  TFSongList = class(TForm)
    sgSongs: TListView;
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure sgSongsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgSongsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure sgSongsData(Sender: TObject; Item: TListItem);
    procedure sgSongsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure sgSongsColumnClick(Sender: TObject; Column: TListColumn);
  private
    { Private declarations }
    aRowToID : array of integer;
    aIDToRow : array of integer;
    aData    : array of array of string;
    iCount   : integer;
    bReady   : boolean;

    iCurrentSort : integer;
    bSortDesc    : boolean;
  public
    { Public declarations }
    bDisableEvent : boolean;
    procedure RemoveFromResults( iID : Integer );
    procedure UpdateRow( iID : integer );
    procedure SortIt( iItem : integer );
    procedure SelectItem( iIdx : integer );
  end;

var
  FSongList: TFSongList;
  function SortSongs(List: TStringList; Index1, Index2: Integer): Integer;

implementation

uses SBMain;

{$R *.dfm}

procedure TFSongList.FormShow(Sender: TObject);
var i : integer;
    SR : SongRecord;
begin
  iCount := PageCache_GetSongCount();
  SetLength( aData, iCount, 7 );
  SetLength( aRowToID, iCount );
  SetLength( aIDToRow, iCount );

  // And set up rows
  for i := 0 to iCount-1 do begin
    if PageCache_GetSongFromIndex( i, SR ) then begin
      aData[i][0] := SR.Title;
      aData[i][1] := SR.AltTitle;
      aData[i][2] := SR.Author;
      aData[i][3] := SR.CopDate;
      aData[i][4] := SR.CopyRight;
      aData[i][5] := SR.OfficeNo;
      if SR.OHP = '0' then aData[i][6] := 'No'
                      else aData[i][6] := 'Yes';
      aIDToRow[i] := i;
      aRowToID[i] := i;
    end;
  end;

  // Finally, set the physical number of rows
  sgSongs.Items.Count := iCount;
  bReady := true;
end;

procedure TFSongList.FormResize(Sender: TObject);
begin
  sgSongs.Invalidate;
end;

procedure TFSongList.sgSongsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if bReady then FSongbase.SBRecNo.Position:= aRowToID[ ARow ];
end;

procedure TFSongList.RemoveFromResults( iID : Integer );
var i, j : integer;
begin
  dec(iCount);
  for i := iID to iCount do begin
    for j := 0 to 6 do begin
      aData[i-1][j] := aData[i][j];
    end;
  end;
  sgSongs.Items.Count := sgSongs.Items.Count - 1;
  sgSongs.Invalidate;
end;

procedure TFSongList.sgSongsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_LEFT) or (Key = VK_RIGHT) then FSongbase.OnKeyDown(Sender,Key,Shift);
end;


procedure TFSongList.UpdateRow( iID : integer );
var SR : SongRecord;
begin
  sgSongs.Invalidate;
end;

procedure TFSongList.FormCreate(Sender: TObject);
begin
  bReady := false;
  bDisableEvent := false;
  iCurrentSort  := 0;
  bSortDesc     := true;
end;

procedure TFSongList.SortIt( iItem : integer );
var i : integer;
    ColData : TStringList;
begin
  ColData := TStringList.Create;
  for i := 0 to iCount-1 do begin
    ColData.AddObject( aData[i][iItem], TNumber.Create(i) );
  end;

  // Sort it
  ColData.CustomSort(SortSongs);

  // Then reorder the rows by their row indexes
  for i := 0 to iCount-1 do begin
    aRowToID[i] := (ColData.Objects[i] as TNumber).iIdx;
    aIDToRow[ aRowToID[i] ] := i;
  end;

  ColData.Destroy;
  sgSongs.Invalidate;
end;

procedure TFSongList.sgSongsData(Sender: TObject; Item: TListItem);
var i : integer;
begin
  i := aRowToID[ Item.Index ];
  Item.Caption := aData[i][0];
  Item.SubItems.Add( aData[i][1] );
  Item.SubItems.Add( aData[i][2] );
  Item.SubItems.Add( aData[i][3] );
  Item.SubItems.Add( aData[i][4] );
  Item.SubItems.Add( aData[i][5] );
  Item.SubItems.Add( aData[i][6] );
end;

procedure TFSongList.sgSongsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then begin
    bDisableEvent := true;
    FSongbase.SBRecNo.Position := aRowToID[ Item.Index ]+1;
    bDisableEvent := false;
  end;
end;

procedure TFSonglist.SelectItem( iIdx : integer );
var iRow : integer;
begin
  if not FSongList.bDisableEvent and FSonglist.Visible then
  begin
    iRow := aIDToRow[iIdx];
    sgSongs.ItemIndex := iRow;
    sgSongs.ItemFocused := sgSongs.Items.Item[iRow];
    sgSongs.Items.Item[iRow].MakeVisible(false);
  end;
end;


procedure TFSongList.sgSongsColumnClick(Sender: TObject;
  Column: TListColumn);
var i, iSelected: integer;
begin
  if iCurrentSort = Column.Index then bSortDesc := not bSortDesc
                                 else bSortDesc := true;
  iCurrentSort := Column.Index;

  if sgSongs.ItemIndex = -1 then iSelected := -1
  else
    iSelected := aRowToID[sgSongs.ItemIndex];

  if 0 = iCurrentSort then begin
    if bSortDesc then begin
      for i:=0 to iCount-1 do begin
        aIDToRow[i] := i;
        aRowToID[i] := i;
      end;
    end
    else begin
      for i:=0 to iCount-1 do begin
        aIDToRow[i] := (iCount-1) - i;
        aRowToID[i] := (iCount-1) - i;
      end;
    end;
    sgSongs.Invalidate;
  end
  else begin
    SortIt( iCurrentSort );
  end;

  if iSelected <> -1 then begin
    i := aIDToRow[iSelected];
    sgSongs.ItemIndex := i;
    sgSongs.ItemFocused := sgSongs.Items.Item[i];
    sgSongs.Items.Item[i].MakeVisible(false);
  end;
end;


function SortSongs(List: TStringList; Index1, Index2: Integer): Integer;
var iResult : integer;
    iCCLI1, iCCLI2, iC1, iC2 : integer;
    bSet : boolean;
    s1, s2 : string;
begin
  bSet := false;
  if (FSongList.iCurrentSort = 3) or
     (FSongList.iCurrentSort = 5) then
  begin
    val( List.Strings[Index1], iCCLI1, iC1 );
    val( List.Strings[Index2], iCCLI2, iC2 );
    if (0 = iC1) and (0 = iC2) then begin
      iResult := iCCLI1 - iCCLI2;
      bSet    := true;
    end;
  end;

  // If not CCLI, or CCLI field contains non-number sort by text
  if not bSet then begin
    s1 := List.Strings[Index1];
    s2 := List.Strings[Index2];
    if (s1 = '') and (s2 <> '') then iResult := 1
    else
    if (s2 = '') and (s1 <> '') then iResult := -1
    else
      iResult := AnsiCompareText( s1, s2 );
  end;

  // If the same, sort by song id. 
  if 0 = iResult then begin
    iResult := (List.Objects[Index1] as TNumber).iIdx -
               (List.Objects[Index2] as TNumber).iIdx;
  end;
  if not FSonglist.bSortDesc then iResult := -iResult;
  Result := iResult;
end;

end.

