object FPrintSelect: TFPrintSelect
  Left = 17
  Top = 411
  Width = 347
  Height = 295
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'SongBase Print Selection'
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
  object Label1: TLabel
    Left = 40
    Top = 40
    Width = 244
    Height = 16
    Caption = 'Include songs with these boxes ticked:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 56
    Top = 12
    Width = 59
    Height = 13
    Caption = 'Report Type'
  end
  object PCOHP: TCheckBox
    Left = 104
    Top = 72
    Width = 113
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Video-Proj used'
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object PCPrint: TCheckBox
    Left = 104
    Top = 104
    Width = 113
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Printed Sheet'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object PCRec: TCheckBox
    Left = 104
    Top = 120
    Width = 113
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Recorded'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object PCAll: TCheckBox
    Left = 104
    Top = 168
    Width = 113
    Height = 17
    Alignment = taLeftJustify
    Caption = 'All Songs'
    TabOrder = 3
    OnClick = PCAllClick
  end
  object BOk: TButton
    Left = 208
    Top = 232
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 4
    OnClick = BOkClick
  end
  object BCancel: TButton
    Left = 56
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = BCancelClick
  end
  object PCBReport: TComboBox
    Left = 120
    Top = 8
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    Items.Strings = (
      'Song Report'
      'Photocopying Report')
  end
  object PCPhoto: TCheckBox
    Left = 104
    Top = 136
    Width = 113
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Photocopied'
    Checked = True
    State = cbChecked
    TabOrder = 7
    OnClick = PCAllClick
  end
  object PCBPreview: TCheckBox
    Left = 72
    Top = 200
    Width = 169
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Preview Table before printing'
    TabOrder = 8
  end
  object PCTrans: TCheckBox
    Left = 104
    Top = 88
    Width = 113
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Printed OHP used'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
end
