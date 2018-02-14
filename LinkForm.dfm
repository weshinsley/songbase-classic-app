object FLinkForm: TFLinkForm
  Left = 689
  Top = 220
  Width = 384
  Height = 170
  Caption = 'Locate Multimedia Link'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LDescription: TLabel
    Left = 8
    Top = 48
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object LLocation: TLabel
    Left = 8
    Top = 8
    Width = 41
    Height = 13
    Caption = 'Location'
  end
  object BLocate: TButton
    Left = 296
    Top = 24
    Width = 75
    Height = 22
    Caption = '&Locate File'
    TabOrder = 0
    OnClick = BLocateClick
  end
  object ELocation: TEdit
    Left = 8
    Top = 24
    Width = 281
    Height = 21
    TabOrder = 1
    OnChange = ELocationChange
  end
  object EDescription: TEdit
    Left = 8
    Top = 64
    Width = 360
    Height = 21
    TabOrder = 2
    OnChange = EDescriptionChange
  end
  object BOK: TButton
    Left = 104
    Top = 96
    Width = 75
    Height = 25
    Caption = '&OK'
    TabOrder = 3
    OnClick = BOKClick
  end
  object BCancel: TButton
    Left = 192
    Top = 96
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 4
    OnClick = BCancelClick
  end
end
