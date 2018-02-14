object FSearchResults: TFSearchResults
  Left = 486
  Top = 266
  Width = 665
  Height = 95
  Caption = 'Search Results'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCanResize = FormCanResize
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DrawGrid1: TDrawGrid
    Left = 6
    Top = 8
    Width = 643
    Height = 28
    ColCount = 4
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goRowSelect]
    ScrollBars = ssVertical
    TabOrder = 1
    OnDblClick = DrawGrid1DblClick
    OnDrawCell = DrawGrid1DrawCell
    OnKeyDown = DrawGrid1KeyDown
    OnMouseDown = DrawGrid1MouseDown
    OnMouseWheelDown = DrawGrid1MouseWheelDown
    OnMouseWheelUp = DrawGrid1MouseWheelUp
    OnSelectCell = DrawGrid1SelectCell
    ColWidths = (
      197
      119
      15
      304)
    RowHeights = (
      24
      24)
  end
  object ProgressBar1: TProgressBar
    Left = 6
    Top = 36
    Width = 643
    Height = 25
    TabOrder = 2
  end
  object RichEdit1: TRichEdit
    Left = 0
    Top = 0
    Width = 25
    Height = 17
    Lines.Strings = (
      'Ric'
      'hE'
      'dit1')
    TabOrder = 0
    Visible = False
  end
end
