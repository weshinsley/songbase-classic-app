object FUpdate: TFUpdate
  Left = 364
  Top = 277
  Width = 399
  Height = 312
  Caption = 'Update Songbase'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LUpdateVer: TLabel
    Left = 16
    Top = 16
    Width = 3
    Height = 13
  end
  object LAction: TLabel
    Left = 16
    Top = 216
    Width = 3
    Height = 13
  end
  object MUpdateVerText: TMemo
    Left = 16
    Top = 40
    Width = 345
    Height = 145
    Lines.Strings = (
      'MUpdateVerText')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object BUpdateVer: TButton
    Left = 80
    Top = 240
    Width = 75
    Height = 25
    Caption = '&Update'
    TabOrder = 1
    OnClick = BUpdateVerClick
  end
  object BUpdateLater: TButton
    Left = 224
    Top = 240
    Width = 75
    Height = 25
    Caption = '&Later'
    TabOrder = 2
    OnClick = BUpdateLaterClick
  end
  object PBUpdate: TProgressBar
    Left = 16
    Top = 192
    Width = 345
    Height = 17
    TabOrder = 3
  end
end
