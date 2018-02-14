object FSongList: TFSongList
  Left = 131
  Top = 146
  Width = 1036
  Height = 469
  Caption = 'Song List'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sgSongs: TListView
    Left = 0
    Top = 0
    Width = 1028
    Height = 442
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    Columns = <
      item
        Caption = 'Title'
        Width = 290
      end
      item
        Caption = 'Alt Title'
        Width = 200
      end
      item
        Caption = 'Author'
        Width = 176
      end
      item
        Caption = 'Date'
        Width = 40
      end
      item
        Caption = 'Copyright'
        Width = 180
      end
      item
        Caption = 'CCLI'
        Width = 66
      end
      item
        AutoSize = True
        Caption = 'Projected'
      end>
    GridLines = True
    HideSelection = False
    IconOptions.AutoArrange = True
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = sgSongsColumnClick
    OnData = sgSongsData
    OnKeyDown = sgSongsKeyDown
    OnSelectItem = sgSongsSelectItem
  end
end
