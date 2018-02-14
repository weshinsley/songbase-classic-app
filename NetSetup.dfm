object FNetSetup: TFNetSetup
  Left = 1316
  Top = 110
  Width = 416
  Height = 479
  Caption = 'Network Services'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BOk: TButton
    Left = 136
    Top = 392
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = BOkClick
  end
  object BCancel: TButton
    Left = 216
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = BCancelClick
  end
  object GBListeners: TGroupBox
    Left = 8
    Top = 8
    Width = 385
    Height = 129
    Caption = '  Listen for Android and Viewer Requests  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object LInterface: TLabel
      Left = 72
      Top = 34
      Width = 135
      Height = 16
      Caption = 'Which IP to serve from:'
    end
    object LPort: TLabel
      Left = 126
      Top = 66
      Width = 79
      Height = 16
      Caption = 'Network Port:'
    end
    object LEnable: TLabel
      Left = 123
      Top = 98
      Width = 82
      Height = 16
      Caption = 'Enable server:'
    end
    object CBIPs: TComboBox
      Left = 216
      Top = 32
      Width = 145
      Height = 24
      ItemHeight = 16
      TabOrder = 0
    end
    object EPort: TEdit
      Left = 216
      Top = 64
      Width = 81
      Height = 24
      TabOrder = 1
      Text = '8080'
      OnChange = EPortChange
    end
    object CBEnabled: TCheckBox
      Left = 216
      Top = 96
      Width = 97
      Height = 24
      TabOrder = 2
    end
  end
  object GBLaunchers: TGroupBox
    Left = 8
    Top = 152
    Width = 385
    Height = 233
    Caption = '  Send to Remote Screens  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object SGScreens: TStringGrid
      Left = 24
      Top = 25
      Width = 321
      Height = 152
      ColCount = 3
      FixedCols = 0
      RowCount = 2
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      TabOrder = 0
      OnClick = SGScreensClick
      OnDrawCell = SGScreensDrawCell
      OnMouseDown = SGScreensMouseDown
      ColWidths = (
        258
        250
        64)
    end
    object BAddScreen: TButton
      Left = 104
      Top = 184
      Width = 75
      Height = 25
      Caption = 'Add'
      TabOrder = 1
      OnClick = BAddScreenClick
    end
    object BRemoveScreen: TButton
      Left = 184
      Top = 184
      Width = 75
      Height = 25
      Caption = 'Remove'
      TabOrder = 2
      OnClick = BRemoveScreenClick
    end
    object BTestScreens: TButton
      Left = 264
      Top = 184
      Width = 75
      Height = 25
      Caption = 'Test'
      TabOrder = 3
      OnClick = BTestScreensClick
    end
  end
  object IdEncoderMIME1: TIdEncoderMIME
    FillChar = '='
    Left = 8
    Top = 400
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 40
    Top = 400
  end
end
