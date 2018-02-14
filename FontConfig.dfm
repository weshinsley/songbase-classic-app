object FFontConfig: TFFontConfig
  Left = 209
  Top = 116
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Font Configuration'
  ClientHeight = 249
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 81
    Top = 43
    Width = 44
    Height = 13
    Caption = 'Font Size'
  end
  object SBold: TSpeedButton
    Left = 159
    Top = 62
    Width = 23
    Height = 22
    AllowAllUp = True
    GroupIndex = 2
    Caption = 'B'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Layout = blGlyphBottom
    ParentFont = False
    OnClick = SBoldClick
  end
  object SItalic: TSpeedButton
    Left = 159
    Top = 88
    Width = 23
    Height = 22
    AllowAllUp = True
    GroupIndex = 1
    Caption = 'i'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    Layout = blGlyphTop
    ParentFont = False
    OnClick = SItalicClick
  end
  object Label1: TLabel
    Left = 94
    Top = 117
    Width = 54
    Height = 13
    Caption = 'Text Colour'
  end
  object CBFont: TComboBox
    Left = 9
    Top = 11
    Width = 177
    Height = 21
    Style = csDropDownList
    Enabled = False
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
    OnChange = CBFontChange
  end
  object FontTick: TCheckBox
    Left = 201
    Top = 11
    Width = 110
    Height = 17
    Caption = 'Force this setting'
    TabOrder = 1
    OnClick = FontTickClick
  end
  object SizeTick: TCheckBox
    Left = 201
    Top = 37
    Width = 110
    Height = 17
    Caption = 'Force this setting'
    TabOrder = 2
    OnClick = SizeTickClick
  end
  object FontSize: TEdit
    Left = 137
    Top = 37
    Width = 30
    Height = 21
    Hint = 'Font Size|Select font size'
    Enabled = False
    TabOrder = 3
    Text = '24'
  end
  object UpDown1: TUpDown
    Left = 167
    Top = 37
    Width = 15
    Height = 21
    Associate = FontSize
    Enabled = False
    Position = 24
    TabOrder = 4
    OnClick = UpDown1Click
  end
  object BoldTick: TCheckBox
    Left = 201
    Top = 62
    Width = 110
    Height = 17
    Caption = 'Force this setting'
    TabOrder = 5
    OnClick = BoldTickClick
  end
  object ItalTick: TCheckBox
    Left = 201
    Top = 88
    Width = 110
    Height = 17
    Caption = 'Force this setting'
    TabOrder = 6
    OnClick = ItalTickClick
  end
  object PCol1: TPanel
    Left = 159
    Top = 113
    Width = 22
    Height = 22
    TabOrder = 7
    OnClick = PCol1Click
    object PColf: TPanel
      Left = 4
      Top = 4
      Width = 14
      Height = 14
      BevelOuter = bvNone
      Color = clHighlightText
      TabOrder = 0
      OnClick = PColfClick
    end
  end
  object ForeTick: TCheckBox
    Left = 201
    Top = 113
    Width = 110
    Height = 17
    Caption = 'Force this setting'
    TabOrder = 8
    OnClick = ForeTickClick
  end
  object PSample: TPanel
    Left = 7
    Top = 150
    Width = 300
    Height = 70
    BevelInner = bvLowered
    BevelOuter = bvLowered
    Caption = 'PSample'
    TabOrder = 9
    object LSample: TLabel
      Left = 2
      Top = 2
      Width = 295
      Height = 65
      Alignment = taCenter
      AutoSize = False
      Caption = 'LSample'
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -32
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
  end
  object BOK: TButton
    Left = 136
    Top = 224
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 10
    OnClick = BOKClick
  end
  object ColorDialog2: TmbOfficeColorDialog
    Left = 32
    Top = 224
  end
end
