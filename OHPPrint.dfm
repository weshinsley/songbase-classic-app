object FPOHP: TFPOHP
  Left = 666
  Top = 145
  Width = 203
  Height = 120
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'OHP Page Print'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RB1: TRadioButton
    Left = 40
    Top = 8
    Width = 113
    Height = 17
    Caption = 'Just This Page'
    Checked = True
    TabOrder = 0
    TabStop = True
    OnClick = RB1Click
  end
  object RBA: TRadioButton
    Left = 56
    Top = 32
    Width = 73
    Height = 17
    Caption = 'All Pages'
    TabOrder = 1
    OnClick = RBAClick
  end
  object BPrint: TButton
    Left = 8
    Top = 56
    Width = 65
    Height = 25
    Caption = 'Print'
    TabOrder = 2
    OnClick = BPrintClick
  end
  object BCancel: TButton
    Left = 104
    Top = 56
    Width = 65
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = BCancelClick
  end
end
