object FSongDetails: TFSongDetails
  Left = 0
  Top = 322
  Width = 633
  Height = 557
  Caption = 'Further Song Information'
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
  object P4: TPanel
    Left = 3
    Top = 243
    Width = 620
    Height = 280
    BevelOuter = bvNone
    TabOrder = 1
    object LKey: TLabel
      Left = 32
      Top = 44
      Width = 64
      Height = 13
      Caption = 'Preferred Key'
    end
    object LCapo: TLabel
      Left = 32
      Top = 76
      Width = 66
      Height = 13
      Caption = 'Guitarist Capo'
    end
    object LTempo: TLabel
      Left = 72
      Top = 108
      Width = 33
      Height = 13
      Caption = 'Tempo'
    end
    object LC1: TLabel
      Left = 8
      Top = 188
      Width = 76
      Height = 13
      Caption = 'Copyright Line 1'
    end
    object LC2: TLabel
      Left = 8
      Top = 220
      Width = 76
      Height = 13
      Caption = 'Copyright Line 2'
    end
    object Label1: TLabel
      Left = 32
      Top = 252
      Width = 57
      Height = 13
      Caption = 'Other Notes'
    end
    object LAuto: TLabel
      Left = 330
      Top = 164
      Width = 22
      Height = 13
      Caption = 'Auto'
    end
    object Label3: TLabel
      Left = 112
      Top = 12
      Width = 185
      Height = 16
      Caption = 'Music and Other Information'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 440
      Top = 12
      Width = 105
      Height = 16
      Caption = 'Multimedia Links'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object CKey: TComboBox
      Left = 120
      Top = 40
      Width = 65
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = EMusChange
      Items.Strings = (
        'C'
        'C#/Db'
        'D'
        'D#/Eb'
        'E'
        'F'
        'F#/Gb'
        'G'
        'G#/Ab'
        'A'
        'A#/Bb'
        'B')
    end
    object CMM: TComboBox
      Left = 184
      Top = 40
      Width = 97
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = EMusChange
      Items.Strings = (
        'Major'
        'Minor')
    end
    object CCapo: TComboBox
      Left = 120
      Top = 72
      Width = 65
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = EMusChange
      Items.Strings = (
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
    object CTempo: TComboBox
      Left = 120
      Top = 104
      Width = 161
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      OnChange = EMusChange
      Items.Strings = (
        'Flexible'
        'Fastest'
        'Medium/Fast'
        'Medium'
        'Slow/Medium'
        'Slow')
    end
    object ECop1: TEdit
      Left = 120
      Top = 184
      Width = 209
      Height = 21
      TabOrder = 4
      OnChange = EMusChange
    end
    object ECop2: TEdit
      Left = 120
      Top = 216
      Width = 209
      Height = 21
      TabOrder = 6
      OnChange = EMusChange
    end
    object ENotes: TEdit
      Left = 120
      Top = 248
      Width = 481
      Height = 21
      TabOrder = 8
      OnChange = EMusChange
    end
    object CBC1: TCheckBox
      Left = 336
      Top = 188
      Width = 20
      Height = 17
      TabOrder = 5
    end
    object CBC2: TCheckBox
      Left = 336
      Top = 218
      Width = 20
      Height = 17
      TabOrder = 7
    end
    object LBLinks: TListBox
      Left = 384
      Top = 40
      Width = 217
      Height = 169
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 9
      OnClick = LBLinksClick
    end
    object BAddLink: TButton
      Left = 328
      Top = 40
      Width = 57
      Height = 25
      BiDiMode = bdLeftToRight
      Caption = '&Add Link'
      Enabled = False
      ParentBiDiMode = False
      TabOrder = 10
      OnClick = BAddLinkClick
    end
    object BShowLink: TButton
      Left = 328
      Top = 64
      Width = 57
      Height = 25
      Caption = '&Show'
      Enabled = False
      TabOrder = 11
      OnClick = BShowLinkClick
    end
    object BExtract: TButton
      Left = 328
      Top = 88
      Width = 57
      Height = 25
      Caption = '&Extract'
      Enabled = False
      TabOrder = 12
      OnClick = BExtractClick
    end
    object BRenLink: TButton
      Left = 328
      Top = 112
      Width = 57
      Height = 25
      Caption = '&Rename'
      Enabled = False
      TabOrder = 13
      OnClick = BRenLinkClick
    end
    object BDelLink: TButton
      Left = 328
      Top = 136
      Width = 57
      Height = 25
      Caption = '&Delete'
      Enabled = False
      TabOrder = 14
      OnClick = BDelLinkClick
    end
  end
  object P2: TPanel
    Left = 3
    Top = 3
    Width = 620
    Height = 233
    BevelOuter = bvNone
    TabOrder = 0
    object LMus: TLabel
      Left = 40
      Top = 55
      Width = 91
      Height = 13
      Caption = 'Title of Music Book'
    end
    object LTune: TLabel
      Left = 16
      Top = 151
      Width = 128
      Height = 16
      Caption = 'Tune Name (if known)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Larr1: TLabel
      Left = 32
      Top = 189
      Width = 114
      Height = 16
      Caption = 'Composer/Arranger'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Larr2: TLabel
      Left = 34
      Top = 205
      Width = 108
      Height = 13
      Caption = '(if different from author)'
      Transparent = True
    end
    object LPub: TLabel
      Left = 64
      Top = 111
      Width = 60
      Height = 13
      Caption = '(pr publisher)'
    end
    object LIsbn: TLabel
      Left = 48
      Top = 95
      Width = 82
      Height = 13
      Caption = '10-digit ISBN No.'
    end
    object CPhoto: TCheckBox
      Left = 200
      Top = 3
      Width = 281
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Music photocopied from the following source'
      TabOrder = 0
      OnClick = EMusChange
    end
    object EMus: TEdit
      Left = 160
      Top = 51
      Width = 409
      Height = 21
      TabOrder = 1
      OnChange = EMusChange
      OnExit = EMusExit
      OnKeyUp = EMusKeyUp
    end
    object EISBN: TEdit
      Left = 160
      Top = 99
      Width = 409
      Height = 21
      TabOrder = 2
      OnChange = EMusChange
    end
    object ETune: TEdit
      Left = 160
      Top = 147
      Width = 409
      Height = 21
      TabOrder = 3
      OnChange = EMusChange
    end
    object EArr: TEdit
      Left = 160
      Top = 195
      Width = 409
      Height = 21
      TabOrder = 4
      OnChange = EMusChange
    end
  end
  object SaveDialog1: TSaveDialog
  end
end
