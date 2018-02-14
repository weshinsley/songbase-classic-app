object FSearch: TFSearch
  Left = 308
  Top = 271
  BorderStyle = bsSingle
  Caption = 'SongBase - Find Song'
  ClientHeight = 268
  ClientWidth = 424
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LText: TLabel
    Left = 160
    Top = 8
    Width = 107
    Height = 16
    Caption = 'Text to search for:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object ESearchText: TEdit
    Left = 16
    Top = 32
    Width = 393
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnEnter = ESearchTextEnter
    OnKeyDown = ESearchTextKeyDown
  end
  object BOk: TButton
    Left = 112
    Top = 96
    Width = 75
    Height = 25
    Caption = '&Search'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = BOkClick
  end
  object BCancel: TButton
    Left = 200
    Top = 96
    Width = 75
    Height = 25
    Caption = '&Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = BCancelClick
  end
  object CBOHPSearch: TCheckBox
    Left = 132
    Top = 64
    Width = 173
    Height = 17
    Caption = 'Include OHP Text in search'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 16
    Top = 161
    Width = 393
    Height = 97
    TabOrder = 5
    object LTempo: TLabel
      Left = 102
      Top = 15
      Width = 33
      Height = 13
      Caption = 'Tempo'
    end
    object LKey: TLabel
      Left = 71
      Top = 68
      Width = 64
      Height = 13
      Caption = 'Preferred Key'
    end
    object LCapo: TLabel
      Left = 69
      Top = 42
      Width = 66
      Height = 13
      Caption = 'Guitarist Capo'
    end
    object CTempo: TComboBox
      Left = 143
      Top = 11
      Width = 161
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      Items.Strings = (
        'Any'
        'Flexible'
        'Fastest'
        'Medium/Fast'
        'Medium'
        'Slow/Medium'
        'Slow')
    end
    object CMM: TComboBox
      Left = 208
      Top = 65
      Width = 97
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      Items.Strings = (
        'Any'
        'Major'
        'Minor')
    end
    object CCapo: TComboBox
      Left = 143
      Top = 38
      Width = 65
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'Any'
        'None'
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '9'
        '10'
        '11'
        '12')
    end
    object CKey: TComboBox
      Left = 143
      Top = 65
      Width = 65
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        'Any'
        'C'
        'C# / Db'
        'D'
        'D# / Eb'
        'E'
        'F'
        'F# / Gb'
        'G'
        'G# / Ab'
        'A'
        'A# / Bb'
        'B')
    end
  end
  object BOptions: TButton
    Left = 16
    Top = 136
    Width = 89
    Height = 25
    Caption = 'Advanced >>'
    TabOrder = 4
    OnClick = BOptionsClick
  end
end
