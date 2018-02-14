object FSettings: TFSettings
  Left = 704
  Top = 200
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Global Settings'
  ClientHeight = 480
  ClientWidth = 403
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 256
    Top = 178
    Width = 69
    Height = 13
    AutoSize = False
    Caption = ', using Monitor'
    OnClick = Label2Click
  end
  object Label7: TLabel
    Left = 27
    Top = 312
    Width = 146
    Height = 13
    Caption = 'Scale projection as if screen is:'
  end
  object Label8: TLabel
    Left = 292
    Top = 309
    Width = 11
    Height = 13
    Caption = 'px'
  end
  object Button1: TButton
    Left = 170
    Top = 448
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object TCSettings: TTabControl
    Left = 0
    Top = 0
    Width = 401
    Height = 439
    TabOrder = 0
    Tabs.Strings = (
      'Appearance'
      'General'
      'CCLI')
    TabIndex = 0
    OnChange = TCSettingsChange
    object PGeneral: TPanel
      Left = 8
      Top = 24
      Width = 385
      Height = 405
      TabOrder = 2
      object gbSongList: TGroupBox
        Left = 14
        Top = 247
        Width = 359
        Height = 81
        Caption = 'Song Lists'
        TabOrder = 0
        object CBRemoveSort: TCheckBox
          Left = 68
          Top = 14
          Width = 277
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Key shortcuts stay with songs when moved in orders'
          TabOrder = 0
        end
        object CBPreviewAspect: TCheckBox
          Left = 70
          Top = 34
          Width = 275
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Retain aspect ratio when resizing Preview Windows'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object CBAutoOHP: TCheckBox
          Left = 95
          Top = 55
          Width = 250
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Tick OHP used box when songs are displayed'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
      end
      object gbProject: TGroupBox
        Left = 14
        Top = 7
        Width = 359
        Height = 237
        Caption = 'Projecting'
        TabOrder = 1
        object Label2: TLabel
          Left = 235
          Top = 146
          Width = 69
          Height = 13
          AutoSize = False
          Caption = ', using Monitor'
          OnClick = Label2Click
        end
        object Label4: TLabel
          Left = 242
          Top = 174
          Width = 15
          Height = 13
          AutoSize = False
          Caption = 'if <'
        end
        object Label5: TLabel
          Left = 298
          Top = 174
          Width = 51
          Height = 13
          Caption = 'titles found'
        end
        object LScaleProj1: TLabel
          Left = 77
          Top = 204
          Width = 146
          Height = 13
          Caption = 'Scale projection as if screen is:'
        end
        object Label11: TLabel
          Left = 334
          Top = 203
          Width = 11
          Height = 13
          Caption = 'px'
        end
        object cbProjectNext: TCheckBox
          Left = 152
          Top = 58
          Width = 193
          Height = 17
          Alignment = taLeftJustify
          Caption = 'On '#39'Project Page'#39' select next page'
          TabOrder = 0
        end
        object cbPowerPoint: TCheckBox
          Left = 111
          Top = 78
          Width = 234
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Make '#39'B'#39' key blank screen, like Powerpoint'
          TabOrder = 1
        end
        object AutoViewSingle1: TCheckBox
          Left = 48
          Top = 37
          Width = 297
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Automatically view first page of songs with only one page'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object AutoView1: TCheckBox
          Left = 112
          Top = 17
          Width = 233
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Automatically view first page for every song'
          TabOrder = 3
        end
        object IgnoreDoubleClicks: TCheckBox
          Left = 168
          Top = 98
          Width = 177
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Ignore accidental double-clicks'
          TabOrder = 4
        end
        object cbDualMonitor: TCheckBox
          Left = 69
          Top = 145
          Width = 165
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Enable Dual-Screen projection'
          TabOrder = 5
          OnClick = cbDualMonitorClick
        end
        object btMonitor: TButton
          Left = 308
          Top = 143
          Width = 38
          Height = 22
          Caption = '1'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
          OnClick = btMonitorClick
        end
        object ebMinLyricSearch: TEdit
          Left = 261
          Top = 172
          Width = 33
          Height = 21
          Enabled = False
          TabOrder = 7
          Text = '4'
          OnChange = ebMinLyricSearchChange
        end
        object cbSearchLyrics: TCheckBox
          Left = 51
          Top = 173
          Width = 185
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Include Song lyrics in title searches'
          Checked = True
          State = cbChecked
          TabOrder = 8
          OnClick = cbSearchLyricsClick
        end
        object cbF2F3WinSearch: TCheckBox
          Left = 53
          Top = 118
          Width = 292
          Height = 17
          Alignment = taLeftJustify
          Caption = 'F2/F3 uses normal search windows in dual-screen mode'
          Checked = True
          State = cbChecked
          TabOrder = 9
        end
        object CBScaleProjRes: TComboBox
          Left = 228
          Top = 201
          Width = 103
          Height = 21
          ItemHeight = 13
          TabOrder = 10
          Text = '<none>'
          OnChange = CBScaleProjResChange
        end
      end
      object gbFiles: TGroupBox
        Left = 15
        Top = 331
        Width = 358
        Height = 63
        Caption = 'Files'
        TabOrder = 2
        object LTempFile: TLabel
          Left = 42
          Top = 37
          Width = 107
          Height = 13
          Caption = 'Put Temporary Files in:'
        end
        object ETempFiles: TEdit
          Left = 152
          Top = 34
          Width = 170
          Height = 21
          TabOrder = 0
          Text = 'C:\Temp'
        end
        object BitBtn1: TBitBtn
          Left = 323
          Top = 34
          Width = 22
          Height = 21
          TabOrder = 1
          OnClick = BitBtn1Click
          Glyph.Data = {
            D6020000424DD6020000000000003600000028000000100000000E0000000100
            180000000000A0020000120B0000120B00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F6A6A6A6A6A6A6A6A6A6A6A6A6A
            6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A7F7F7FFFFFFFFFFFFF1D82B5
            1B81B3187EB0167CAE1379AB1076A80D73A50B71A3086EA0066C9E046A9C0268
            9A0167994A4A4A7F7F7F2287BA67CCFF2085B899FFFF6FD4FF6FD4FF6FD4FF6F
            D4FF6FD4FF6FD4FF6FD4FF6FD4FF3BA0D399FFFF0167996B6B6B258ABD67CCFF
            278CBF99FFFF7BE0FF7BE0FF7BE0FF7BE0FF7BE0FF7BE0FF7BE0FF7BE0FF44A9
            DC99FFFF02689A6A6A6A288DC067CCFF2D92C599FFFF85EBFF85EBFF85EBFF85
            EBFF85EBFF85EBFF85EBFF85EBFF4EB3E699FFFF046A9C6A6A6A2A8FC267CCFF
            3398CB99FFFF91F7FF91F7FF91F7FF91F7FF91F7FF91F7FF91F7FF91F7FF57BC
            EF99FFFF066C9E6A6A6A2D92C56FD4FF3499CC99FFFF99FFFF99FFFF99FFFF99
            FFFF99FFFF99FFFF99FFFF99FFFF60C5F899FFFF086EA06B6B6B2F94C77BE0FF
            2D92C5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF81E6
            FFFFFFFF0B71A38888883196C985EBFF81E6FF2D92C52D92C52D92C52D92C52D
            92C52D92C5288DC02489BC2085B81C81B41B81B31B81B3FFFFFF3398CB91F7FF
            8EF4FF8EF4FF8EF4FF8EF4FF8EF4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF167C
            AE888888FFFFFFFFFFFF3499CCFFFFFF99FFFF99FFFF99FFFF99FFFFFFFFFF25
            8ABD2287BA1F84B71D82B51B81B3187EB0FFFFFFFFFFFFFFFFFFFFFFFF3499CC
            FFFFFFFFFFFFFFFFFFFFFFFF2A8FC2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3499CC3398CB3196C92F94C7FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        end
        object AutoLoad1: TCheckBox
          Left = 61
          Top = 13
          Width = 283
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Automatically Load Most Recent Database on Startup'
          TabOrder = 2
        end
      end
    end
    object PNetwork: TPanel
      Left = 8
      Top = 24
      Width = 385
      Height = 405
      TabOrder = 1
      Visible = False
      object CBEnableSS: TCheckBox
        Left = 40
        Top = 16
        Width = 265
        Height = 17
        Caption = 'Send messages to Songbase Servants running on'
        TabOrder = 0
      end
      object MComps: TMemo
        Left = 40
        Top = 48
        Width = 297
        Height = 337
        TabOrder = 1
      end
    end
    object PCCLI: TPanel
      Left = 8
      Top = 24
      Width = 385
      Height = 405
      TabOrder = 3
      Visible = False
      object LCRef: TLabel
        Left = 8
        Top = 20
        Width = 67
        Height = 13
        Caption = 'Customer Ref.'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentColor = False
        ParentFont = False
      end
      object LCCLicence: TLabel
        Left = 11
        Top = 45
        Width = 64
        Height = 13
        Caption = 'CCLI Licence'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object LOrg: TLabel
        Left = 16
        Top = 95
        Width = 59
        Height = 13
        Caption = 'Organisation'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object LMRLicense: TLabel
        Left = 17
        Top = 70
        Width = 58
        Height = 13
        Caption = 'MR Licence'
      end
      object LOrgAd: TLabel
        Left = 37
        Top = 120
        Width = 38
        Height = 13
        Caption = 'Address'
      end
      object LOrgTown: TLabel
        Left = 48
        Top = 145
        Width = 27
        Height = 13
        Caption = 'Town'
      end
      object LOrgPC: TLabel
        Left = 30
        Top = 170
        Width = 45
        Height = 13
        Caption = 'Postcode'
      end
      object LOrgCountry: TLabel
        Left = 39
        Top = 195
        Width = 36
        Height = 13
        Caption = 'Country'
      end
      object LOrgDayTel: TLabel
        Left = 19
        Top = 220
        Width = 56
        Height = 13
        Caption = 'Daytime Tel'
      end
      object LOrgEveTel: TLabel
        Left = 18
        Top = 245
        Width = 57
        Height = 13
        Caption = 'Evening Tel'
      end
      object LOrgFax: TLabel
        Left = 58
        Top = 270
        Width = 17
        Height = 13
        Caption = 'Fax'
      end
      object LOrgEmail: TLabel
        Left = 47
        Top = 295
        Width = 28
        Height = 13
        Caption = 'E-mail'
      end
      object LOrgWeb: TLabel
        Left = 36
        Top = 320
        Width = 39
        Height = 13
        Caption = 'Website'
      end
      object LExpiry: TLabel
        Left = 220
        Top = 285
        Width = 54
        Height = 13
        Caption = 'Expiry Date'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object LRequired: TLabel
        Left = 186
        Top = 304
        Width = 188
        Height = 33
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Underlined items are all required for CCLI report generation'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
        Layout = tlBottom
        WordWrap = True
      end
      object ELicense: TEdit
        Left = 80
        Top = 41
        Width = 97
        Height = 21
        TabOrder = 1
      end
      object ECustRef: TEdit
        Left = 80
        Top = 16
        Width = 97
        Height = 21
        TabOrder = 0
      end
      object EOrg: TEdit
        Left = 80
        Top = 91
        Width = 97
        Height = 21
        TabOrder = 3
      end
      object EMRLicence: TEdit
        Left = 80
        Top = 66
        Width = 97
        Height = 21
        TabOrder = 2
      end
      object EOrgAdd: TEdit
        Left = 80
        Top = 116
        Width = 97
        Height = 21
        TabOrder = 4
      end
      object EOrgTown: TEdit
        Left = 80
        Top = 141
        Width = 97
        Height = 21
        TabOrder = 5
      end
      object EOrgPostcode: TEdit
        Left = 80
        Top = 166
        Width = 97
        Height = 21
        TabOrder = 6
      end
      object EOrgCountry: TEdit
        Left = 80
        Top = 191
        Width = 97
        Height = 21
        TabOrder = 7
      end
      object EOrgDayTel: TEdit
        Left = 80
        Top = 216
        Width = 97
        Height = 21
        TabOrder = 8
      end
      object EOrgEveTel: TEdit
        Left = 80
        Top = 241
        Width = 97
        Height = 21
        TabOrder = 9
      end
      object EOrgFax: TEdit
        Left = 80
        Top = 266
        Width = 97
        Height = 21
        TabOrder = 10
      end
      object EOrgEmail: TEdit
        Tag = 12
        Left = 80
        Top = 291
        Width = 97
        Height = 21
        TabOrder = 11
      end
      object EOrgWebsite: TEdit
        Tag = 13
        Left = 80
        Top = 316
        Width = 97
        Height = 21
        TabOrder = 12
      end
      object DTExpiry: TDateTimePicker
        Tag = 23
        Left = 278
        Top = 281
        Width = 97
        Height = 21
        Date = 38668.457391956020000000
        Time = 38668.457391956020000000
        TabOrder = 13
      end
      object gbCCLI: TGroupBox
        Left = 188
        Top = 12
        Width = 187
        Height = 255
        Caption = 'Representative'#39's Details'
        TabOrder = 14
        object LRepTown: TLabel
          Left = 39
          Top = 126
          Width = 27
          Height = 13
          Caption = 'Town'
        end
        object LRepTitle: TLabel
          Left = 46
          Top = 26
          Width = 20
          Height = 13
          Caption = 'Title'
        end
        object LRepSurname: TLabel
          Left = 24
          Top = 76
          Width = 42
          Height = 13
          Caption = 'Surname'
        end
        object LRepPostCode: TLabel
          Left = 21
          Top = 151
          Width = 45
          Height = 13
          Caption = 'Postcode'
        end
        object LRepForename: TLabel
          Left = 19
          Top = 51
          Width = 47
          Height = 13
          Caption = 'Forename'
        end
        object LRepEveTel: TLabel
          Left = 9
          Top = 226
          Width = 57
          Height = 13
          Caption = 'Evening Tel'
        end
        object LRepDayTel: TLabel
          Left = 10
          Top = 201
          Width = 56
          Height = 13
          Caption = 'Daytime Tel'
        end
        object LRepCountry: TLabel
          Left = 30
          Top = 176
          Width = 36
          Height = 13
          Caption = 'Country'
        end
        object LRepAdd: TLabel
          Left = 28
          Top = 101
          Width = 38
          Height = 13
          Caption = 'Address'
        end
        object ERepAddress: TEdit
          Tag = 17
          Left = 71
          Top = 98
          Width = 104
          Height = 21
          TabOrder = 3
        end
        object ERepTown: TEdit
          Tag = 18
          Left = 71
          Top = 123
          Width = 104
          Height = 21
          TabOrder = 4
        end
        object ERepTitle: TEdit
          Tag = 14
          Left = 71
          Top = 23
          Width = 104
          Height = 21
          TabOrder = 0
        end
        object ERepSurname: TEdit
          Tag = 16
          Left = 71
          Top = 73
          Width = 104
          Height = 21
          TabOrder = 2
        end
        object ERepPostcode: TEdit
          Tag = 19
          Left = 71
          Top = 148
          Width = 104
          Height = 21
          TabOrder = 5
        end
        object ERepForename: TEdit
          Tag = 15
          Left = 71
          Top = 48
          Width = 104
          Height = 21
          TabOrder = 1
        end
        object ERepEveTel: TEdit
          Tag = 22
          Left = 71
          Top = 223
          Width = 104
          Height = 21
          TabOrder = 8
        end
        object ERepDayTel: TEdit
          Tag = 21
          Left = 71
          Top = 198
          Width = 104
          Height = 21
          TabOrder = 7
        end
        object ERepCountry: TEdit
          Tag = 20
          Left = 71
          Top = 173
          Width = 104
          Height = 21
          TabOrder = 6
        end
      end
    end
    object PAppear: TPanel
      Left = 8
      Top = 24
      Width = 385
      Height = 405
      TabOrder = 0
      DesignSize = (
        385
        405)
      object LPrimaryFont: TLabel
        Left = 23
        Top = 14
        Width = 61
        Height = 13
        Caption = 'Primary Font:'
        OnClick = PrimaryClick
      end
      object LCopyFont: TLabel
        Left = 13
        Top = 39
        Width = 71
        Height = 13
        Caption = 'Copyright Font:'
        OnClick = CopyClick
      end
      object LCCLIFont: TLabel
        Left = 34
        Top = 65
        Width = 50
        Height = 13
        Caption = 'CCLI Font:'
        OnClick = CCLIClick
      end
      object LOffsets: TLabel
        Left = 13
        Top = 132
        Width = 73
        Height = 13
        Caption = 'Screen Offsets:'
      end
      object Bevel5: TBevel
        Left = -2
        Top = 115
        Width = 387
        Height = 6
        Shape = bsBottomLine
      end
      object LShadowOffset: TLabel
        Left = 338
        Top = 91
        Width = 24
        Height = 13
        Alignment = taRightJustify
        Caption = '9999'
      end
      object PCopyFont: TPanel
        Left = 88
        Top = 36
        Width = 274
        Height = 23
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          274
          23)
        object LCYFontsize: TLabel
          Left = 178
          Top = 4
          Width = 21
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = '88pt'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          OnClick = CopyClick
        end
        object PCYCol: TPanel
          Left = 253
          Top = 1
          Width = 21
          Height = 21
          Anchors = [akTop, akRight]
          BevelInner = bvRaised
          BevelOuter = bvLowered
          ParentBackground = True
          TabOrder = 0
          OnClick = CopyClick
        end
        object PCYItalic: TPanel
          Left = 230
          Top = 1
          Width = 21
          Height = 21
          Anchors = [akTop, akRight]
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 1
          OnClick = CopyClick
          object LCYItalic: TLabel
            Left = 8
            Top = 1
            Width = 5
            Height = 20
            Caption = 'i'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnShadow
            Font.Height = -17
            Font.Name = 'Times New Roman'
            Font.Style = [fsBold, fsItalic]
            ParentFont = False
            Transparent = True
            OnClick = CopyClick
          end
        end
        object PCYBold: TPanel
          Left = 207
          Top = 1
          Width = 21
          Height = 21
          Anchors = [akTop, akRight]
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 2
          OnClick = CopyClick
          object LCYBold: TLabel
            Left = 4
            Top = -1
            Width = 12
            Height = 21
            Caption = 'B'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnShadow
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
            OnClick = CopyClick
          end
        end
        object PCopy: TPanel
          Left = 0
          Top = 0
          Width = 169
          Height = 22
          Alignment = taLeftJustify
          BevelInner = bvLowered
          BevelOuter = bvLowered
          TabOrder = 3
          OnClick = CopyClick
        end
      end
      object PPrimaryFont: TPanel
        Left = 88
        Top = 10
        Width = 274
        Height = 22
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          274
          22)
        object LPFontSize: TLabel
          Left = 178
          Top = 4
          Width = 21
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = '88pt'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          OnClick = PrimaryClick
        end
        object PPCol: TPanel
          Left = 253
          Top = 1
          Width = 20
          Height = 21
          Anchors = [akTop, akRight]
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          OnClick = PrimaryClick
        end
        object PPItalic: TPanel
          Left = 230
          Top = 1
          Width = 21
          Height = 21
          Anchors = [akTop, akRight]
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 1
          OnClick = PrimaryClick
          object LPItalic: TLabel
            Left = 8
            Top = 1
            Width = 5
            Height = 20
            Caption = 'i'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnShadow
            Font.Height = -17
            Font.Name = 'Times New Roman'
            Font.Style = [fsBold, fsItalic]
            ParentFont = False
            Transparent = True
            OnClick = PrimaryClick
          end
        end
        object PPBold: TPanel
          Left = 207
          Top = 1
          Width = 21
          Height = 21
          Anchors = [akTop, akRight]
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 2
          OnClick = PrimaryClick
          object LPBold: TLabel
            Left = 4
            Top = -1
            Width = 12
            Height = 21
            Caption = 'B'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnShadow
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
            OnClick = PrimaryClick
          end
        end
        object PPrimary: TPanel
          Left = 0
          Top = 0
          Width = 169
          Height = 22
          Alignment = taLeftJustify
          BevelInner = bvLowered
          BevelOuter = bvLowered
          TabOrder = 3
          OnClick = PrimaryClick
        end
      end
      object PCCLIFont: TPanel
        Left = 89
        Top = 62
        Width = 273
        Height = 22
        BevelOuter = bvNone
        TabOrder = 2
        DesignSize = (
          273
          22)
        object LCCFontsize: TLabel
          Left = 177
          Top = 4
          Width = 21
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = '88pt'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          OnClick = CCLIClick
        end
        object PCCCol: TPanel
          Left = 252
          Top = 1
          Width = 21
          Height = 21
          Anchors = [akTop, akRight]
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          OnClick = CCLIClick
        end
        object PCCItalic: TPanel
          Left = 229
          Top = 1
          Width = 21
          Height = 21
          Anchors = [akTop, akRight]
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 1
          OnClick = CCLIClick
          object LCCItalic: TLabel
            Left = 8
            Top = 1
            Width = 5
            Height = 20
            Caption = 'i'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnShadow
            Font.Height = -17
            Font.Name = 'Times New Roman'
            Font.Style = [fsBold, fsItalic]
            ParentFont = False
            Transparent = True
            OnClick = CCLIClick
          end
        end
        object PCCBold: TPanel
          Left = 206
          Top = 1
          Width = 21
          Height = 21
          Anchors = [akTop, akRight]
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 2
          OnClick = CCLIClick
          object LCCBold: TLabel
            Left = 4
            Top = -1
            Width = 12
            Height = 21
            Caption = 'B'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnShadow
            Font.Height = -17
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
            OnClick = CCLIClick
          end
        end
        object PCCLIName: TPanel
          Left = 0
          Top = 0
          Width = 169
          Height = 22
          Alignment = taLeftJustify
          BevelInner = bvLowered
          BevelOuter = bvLowered
          TabOrder = 3
          OnClick = CCLIClick
        end
      end
      object EOffsets: TEdit
        Left = 91
        Top = 129
        Width = 173
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
        Text = '(0px,0px, 0px,0px)'
      end
      object BChangeFont: TButton
        Left = 271
        Top = 129
        Width = 92
        Height = 21
        Anchors = [akTop, akRight]
        Caption = 'Change'
        TabOrder = 4
        OnClick = BChangeFontClick
      end
      object cbShadow: TCheckBox
        Left = 26
        Top = 91
        Width = 209
        Height = 17
        Alignment = taLeftJustify
        Anchors = [akTop, akRight]
        Caption = 'Shadow Text (Colour and Offset)'
        TabOrder = 5
      end
      object PShadowCol: TPanel
        Left = 239
        Top = 89
        Width = 21
        Height = 21
        Anchors = [akTop, akRight]
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Color = clBlack
        TabOrder = 6
        OnClick = PShadowColClick
      end
      object TBShadowOffset: TTrackBar
        Left = 265
        Top = 88
        Width = 73
        Height = 25
        Min = -10
        Frequency = 5
        TabOrder = 7
        OnChange = TBShadowOffsetChange
      end
      object GroupBox1: TGroupBox
        Left = 6
        Top = 155
        Width = 373
        Height = 243
        Caption = 'Backgrounds'
        TabOrder = 8
        object Bevel6: TBevel
          Left = 10
          Top = 41
          Width = 137
          Height = 104
        end
        object Label6: TLabel
          Left = 13
          Top = 159
          Width = 29
          Height = 13
          Caption = 'Order:'
        end
        object BGTestImg: TImage
          Left = 11
          Top = 42
          Width = 135
          Height = 102
          Stretch = True
          OnClick = BGTestImgClick
        end
        object ForceBGImage: TCheckBox
          Left = 156
          Top = 80
          Width = 154
          Height = 17
          Caption = 'Force Background Image'
          TabOrder = 0
        end
        object PCol2: TPanel
          Left = 10
          Top = 17
          Width = 137
          Height = 21
          TabOrder = 1
          object PColb: TPanel
            Left = 4
            Top = 4
            Width = 128
            Height = 13
            BevelOuter = bvNone
            Color = 4194368
            Enabled = False
            TabOrder = 0
            Visible = False
            OnClick = PColbClick
            object Lb: TLabel
              Left = 61
              Top = 0
              Width = 7
              Height = 13
              Caption = 'b'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 16744576
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              OnClick = LbClick
            end
          end
        end
        object BackTick: TCheckBox
          Left = 156
          Top = 19
          Width = 146
          Height = 17
          Caption = 'Default Background Colour'
          TabOrder = 2
          OnClick = BackTickClick
        end
        object ImageTick: TCheckBox
          Left = 156
          Top = 42
          Width = 154
          Height = 17
          Caption = 'Default Background Image'
          TabOrder = 3
        end
        object EImage: TEdit
          Left = 155
          Top = 59
          Width = 182
          Height = 21
          TabOrder = 4
          Text = 'C:\Temp'
          OnChange = EImageChange
        end
        object BImage: TBitBtn
          Left = 339
          Top = 59
          Width = 22
          Height = 21
          TabOrder = 5
          OnClick = BImageClick
          Glyph.Data = {
            D6020000424DD6020000000000003600000028000000100000000E0000000100
            180000000000A0020000120B0000120B00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F6A6A6A6A6A6A6A6A6A6A6A6A6A
            6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A7F7F7FFFFFFFFFFFFF1D82B5
            1B81B3187EB0167CAE1379AB1076A80D73A50B71A3086EA0066C9E046A9C0268
            9A0167994A4A4A7F7F7F2287BA67CCFF2085B899FFFF6FD4FF6FD4FF6FD4FF6F
            D4FF6FD4FF6FD4FF6FD4FF6FD4FF3BA0D399FFFF0167996B6B6B258ABD67CCFF
            278CBF99FFFF7BE0FF7BE0FF7BE0FF7BE0FF7BE0FF7BE0FF7BE0FF7BE0FF44A9
            DC99FFFF02689A6A6A6A288DC067CCFF2D92C599FFFF85EBFF85EBFF85EBFF85
            EBFF85EBFF85EBFF85EBFF85EBFF4EB3E699FFFF046A9C6A6A6A2A8FC267CCFF
            3398CB99FFFF91F7FF91F7FF91F7FF91F7FF91F7FF91F7FF91F7FF91F7FF57BC
            EF99FFFF066C9E6A6A6A2D92C56FD4FF3499CC99FFFF99FFFF99FFFF99FFFF99
            FFFF99FFFF99FFFF99FFFF99FFFF60C5F899FFFF086EA06B6B6B2F94C77BE0FF
            2D92C5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF81E6
            FFFFFFFF0B71A38888883196C985EBFF81E6FF2D92C52D92C52D92C52D92C52D
            92C52D92C5288DC02489BC2085B81C81B41B81B31B81B3FFFFFF3398CB91F7FF
            8EF4FF8EF4FF8EF4FF8EF4FF8EF4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF167C
            AE888888FFFFFFFFFFFF3499CCFFFFFF99FFFF99FFFF99FFFF99FFFFFFFFFF25
            8ABD2287BA1F84B71D82B51B81B3187EB0FFFFFFFFFFFFFFFFFFFFFFFF3499CC
            FFFFFFFFFFFFFFFFFFFFFFFF2A8FC2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3499CC3398CB3196C92F94C7FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        end
        object lbBGImages: TListBox
          Left = 9
          Top = 178
          Width = 297
          Height = 57
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInactiveCaption
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          MultiSelect = True
          ParentFont = False
          TabOrder = 6
          OnMouseDown = lbBGImagesMouseDown
        end
        object cbBGOrder: TComboBox
          Left = 48
          Top = 155
          Width = 258
          Height = 21
          Style = csDropDownList
          Enabled = False
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 7
          Text = '[Add images below]'
          Items.Strings = (
            '[Add images below]'
            'Random (each Page)'
            'Random (each Song)'
            'Cycle (per Page in Song)'
            'Cycle (every Page)'
            'Cycle (each Song)')
        end
        object bRemoveBG: TButton
          Left = 311
          Top = 211
          Width = 50
          Height = 18
          Caption = 'Remove'
          TabOrder = 8
          OnClick = bRemoveBGClick
        end
        object bAddBG: TButton
          Left = 311
          Top = 190
          Width = 50
          Height = 18
          Caption = 'Add'
          TabOrder = 9
          OnClick = bAddBGClick
        end
        object cbBlankImg: TCheckBox
          Left = 156
          Top = 107
          Width = 154
          Height = 17
          Caption = 'Blank Screen Image'
          TabOrder = 10
        end
        object EBlankImg: TEdit
          Left = 155
          Top = 124
          Width = 182
          Height = 21
          TabOrder = 11
          Text = 'blank-image.jpg'
          OnChange = EImageChange
        end
        object BBlankImg: TBitBtn
          Left = 339
          Top = 124
          Width = 22
          Height = 21
          TabOrder = 12
          OnClick = BBlankImgClick
          Glyph.Data = {
            D6020000424DD6020000000000003600000028000000100000000E0000000100
            180000000000A0020000120B0000120B00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F6A6A6A6A6A6A6A6A6A6A6A6A6A
            6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A7F7F7FFFFFFFFFFFFF1D82B5
            1B81B3187EB0167CAE1379AB1076A80D73A50B71A3086EA0066C9E046A9C0268
            9A0167994A4A4A7F7F7F2287BA67CCFF2085B899FFFF6FD4FF6FD4FF6FD4FF6F
            D4FF6FD4FF6FD4FF6FD4FF6FD4FF3BA0D399FFFF0167996B6B6B258ABD67CCFF
            278CBF99FFFF7BE0FF7BE0FF7BE0FF7BE0FF7BE0FF7BE0FF7BE0FF7BE0FF44A9
            DC99FFFF02689A6A6A6A288DC067CCFF2D92C599FFFF85EBFF85EBFF85EBFF85
            EBFF85EBFF85EBFF85EBFF85EBFF4EB3E699FFFF046A9C6A6A6A2A8FC267CCFF
            3398CB99FFFF91F7FF91F7FF91F7FF91F7FF91F7FF91F7FF91F7FF91F7FF57BC
            EF99FFFF066C9E6A6A6A2D92C56FD4FF3499CC99FFFF99FFFF99FFFF99FFFF99
            FFFF99FFFF99FFFF99FFFF99FFFF60C5F899FFFF086EA06B6B6B2F94C77BE0FF
            2D92C5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF81E6
            FFFFFFFF0B71A38888883196C985EBFF81E6FF2D92C52D92C52D92C52D92C52D
            92C52D92C5288DC02489BC2085B81C81B41B81B31B81B3FFFFFF3398CB91F7FF
            8EF4FF8EF4FF8EF4FF8EF4FF8EF4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF167C
            AE888888FFFFFFFFFFFF3499CCFFFFFF99FFFF99FFFF99FFFF99FFFFFFFFFF25
            8ABD2287BA1F84B71D82B51B81B3187EB0FFFFFFFFFFFFFFFFFFFFFFFF3499CC
            FFFFFFFFFFFFFFFFFFFFFFFF2A8FC2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3499CC3398CB3196C92F94C7FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        end
      end
    end
  end
  object FileOpenPicture: TOpenPictureDialog
    Filter = 
      'All (*.jpg;*.jpeg;*.bmp)|*.jpg;*.jpeg;*.bmp|JPEG Image File (*.j' +
      'pg)|*.jpg|JPEG Image File (*.jpeg)|*.jpeg|Bitmaps (*.bmp)|*.bmp'
    Left = 341
    Top = 448
  end
  object ColorDialog2: TmbOfficeColorDialog
    Left = 40
    Top = 448
  end
end
