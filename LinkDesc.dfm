object FLinkDesc: TFLinkDesc
  Left = 789
  Top = 261
  Width = 384
  Height = 115
  Caption = 'Edit Link Description'
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
    Top = 8
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object EDescription: TEdit
    Left = 8
    Top = 24
    Width = 360
    Height = 21
    TabOrder = 0
  end
  object BOK: TButton
    Left = 104
    Top = 56
    Width = 75
    Height = 25
    Caption = '&OK'
    TabOrder = 1
    OnClick = BOKClick
  end
  object BCancel: TButton
    Left = 192
    Top = 56
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = BCancelClick
  end
end
