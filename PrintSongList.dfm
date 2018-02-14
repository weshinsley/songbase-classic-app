object FPSong: TFPSong
  Left = 814
  Top = 225
  Width = 308
  Height = 244
  Caption = 'Print Songlist'
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
  object LTitle: TLabel
    Left = 30
    Top = 20
    Width = 20
    Height = 13
    Caption = 'Title'
  end
  object LSubTitle: TLabel
    Left = 8
    Top = 52
    Width = 42
    Height = 13
    Caption = 'Sub-Title'
  end
  object ETitle: TEdit
    Left = 56
    Top = 16
    Width = 233
    Height = 21
    TabOrder = 0
  end
  object ESubTitle: TEdit
    Left = 56
    Top = 48
    Width = 233
    Height = 21
    TabOrder = 1
  end
  object CSK: TCheckBox
    Left = 56
    Top = 88
    Width = 129
    Height = 17
    Caption = 'Include short-cut keys'
    TabOrder = 2
  end
  object CIK: TCheckBox
    Left = 56
    Top = 114
    Width = 89
    Height = 17
    Caption = 'Include keys'
    TabOrder = 3
    OnClick = CIKClick
  end
  object CBTrans: TComboBox
    Left = 168
    Top = 112
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    Items.Strings = (
      'Don'#39't Transpose'
      'Transpose for C#/Db'
      'Transpose for D'
      'Transpose for D#/Eb'
      'Transpose for E'
      'Transpose for F'
      'Transpose for F#/Gb'
      'Transpose for G'
      'Transpose for G#/Ab'
      'Transpose for A'
      'Transpose for A#/Bb'
      'Transpose for B')
  end
  object CBCapo: TCheckBox
    Left = 56
    Top = 140
    Width = 145
    Height = 17
    Caption = 'Include Guitar Capo Key'
    TabOrder = 5
  end
  object BPrint: TButton
    Left = 72
    Top = 176
    Width = 75
    Height = 25
    Caption = '&Print'
    TabOrder = 6
    OnClick = BPrintClick
  end
  object BCancel: TButton
    Left = 160
    Top = 176
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 7
    OnClick = BCancelClick
  end
end
