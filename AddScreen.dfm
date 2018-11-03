object FAddScreen: TFAddScreen
  Left = 1395
  Top = 712
  Width = 301
  Height = 177
  Caption = 'Add Network Screen'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object LPort: TLabel
    Left = 94
    Top = 58
    Width = 65
    Height = 13
    Caption = 'Network Port:'
  end
  object LServer: TLabel
    Left = 30
    Top = 26
    Width = 37
    Height = 13
    Caption = 'Host/IP'
  end
  object BOk: TButton
    Left = 80
    Top = 95
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = BOkClick
  end
  object BCancel: TButton
    Left = 168
    Top = 95
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = BCancelClick
  end
  object EPort: TEdit
    Left = 168
    Top = 56
    Width = 81
    Height = 21
    TabOrder = 2
    Text = '8080'
    OnChange = EPortChange
  end
  object EServer: TEdit
    Left = 72
    Top = 24
    Width = 177
    Height = 21
    TabOrder = 3
    Text = '8080'
    OnChange = EServerChange
  end
end
