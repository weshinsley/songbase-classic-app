object FConfigOffsets: TFConfigOffsets
  Left = 180
  Top = 159
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Anchors = [akLeft, akTop, akRight, akBottom]
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 536
  ClientWidth = 665
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  OnShow = FormShow
  DesignSize = (
    665
    536)
  PixelsPerInch = 96
  TextHeight = 13
  object MainOffsetTL: TLabel
    Left = 29
    Top = 3
    Width = 52
    Height = 13
    Cursor = crSizeAll
    Anchors = []
    Caption = 'Top Offset'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
    OnMouseDown = MainOffsetTLMouseDown
    OnMouseMove = MainOffsetTLMouseMove
    OnMouseUp = HandlerMouseUp
  end
  object LCopyDesc: TLabel
    Left = 516
    Top = 432
    Width = 85
    Height = 13
    Cursor = crSizeAll
    Anchors = [akRight, akBottom]
    Caption = 'COPYRIGHT TEXT'
    Color = 65408
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
    OnMouseDown = LCopyDescMouseDown
    OnMouseMove = LCopyDescMouseMove
    OnMouseUp = HandlerMouseUp
  end
  object LCCLIDesc: TLabel
    Left = 0
    Top = 434
    Width = 49
    Height = 13
    Cursor = crSizeAll
    Anchors = [akLeft, akBottom]
    Caption = 'CCLI Desc'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    OnMouseDown = LCCLIDescMouseDown
    OnMouseMove = LCCLIDescMouseMove
    OnMouseUp = HandlerMouseUp
  end
  object LCopy2: TLabel
    Left = 516
    Top = 448
    Width = 51
    Height = 13
    Cursor = crSizeAll
    Anchors = [akRight, akBottom]
    Caption = 'Copy Desc'
    Color = clLime
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
    OnMouseDown = LCopyDescMouseDown
    OnMouseMove = LCopyDescMouseMove
    OnMouseUp = HandlerMouseUp
  end
  object LCCLI2: TLabel
    Left = 8
    Top = 450
    Width = 49
    Height = 13
    Cursor = crSizeAll
    Anchors = [akLeft, akBottom]
    Caption = 'CCLI Desc'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    OnMouseDown = LCCLIDescMouseDown
    OnMouseMove = LCCLIDescMouseMove
    OnMouseUp = HandlerMouseUp
  end
  object btClose: TButton
    Left = 278
    Top = 219
    Width = 72
    Height = 23
    Anchors = []
    Caption = 'Close'
    TabOrder = 0
    OnClick = btCloseClick
  end
end
