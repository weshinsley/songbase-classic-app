object FHelpWindow: TFHelpWindow
  Left = 1076
  Top = 334
  Width = 353
  Height = 355
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'SongBase - Help'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    337
    317)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 1
    Top = 0
    Width = 234
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      234
      17)
    object BBack: TButton
      Left = 62
      Top = 0
      Width = 55
      Height = 17
      Anchors = [akTop]
      Caption = 'Back'
      TabOrder = 1
      OnClick = BBackClick
    end
    object BForward: TButton
      Left = 118
      Top = 0
      Width = 55
      Height = 17
      Anchors = [akTop]
      Caption = 'Forward'
      TabOrder = 2
      OnClick = BForwardClick
    end
    object BContents: TButton
      Left = 0
      Top = 0
      Width = 55
      Height = 17
      Caption = 'Contents'
      TabOrder = 0
      OnClick = BContentsClick
    end
    object BClose: TButton
      Left = 179
      Top = 0
      Width = 55
      Height = 17
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Close'
      TabOrder = 3
      OnClick = BCloseClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 32
    Width = 345
    Height = 297
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
    object WebBrowser1: TWebBrowser
      Left = 1
      Top = 1
      Width = 343
      Height = 295
      Align = alClient
      TabOrder = 0
      OnCommandStateChange = WebBrowser1CommandStateChange
      OnTitleChange = WebBrowser1TitleChange
      ControlData = {
        4C000000732300007D1E00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
end
