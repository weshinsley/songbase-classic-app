object FEditProj: TFEditProj
  Left = 980
  Top = 172
  BorderStyle = bsNone
  Caption = 'Songbase - Projector Window'
  ClientHeight = 583
  ClientWidth = 713
  Color = clBlack
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnShortCut = FormShortCut
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LLicense: TLabel
    Left = 10
    Top = 531
    Width = 68
    Height = 18
    Caption = 'Licence #'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Cop2: TLabel
    Left = 112
    Top = 507
    Width = 89
    Height = 18
    Caption = 'Copyright #2'
    Color = clLime
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
    Visible = False
  end
  object Cop1: TLabel
    Left = 10
    Top = 507
    Width = 89
    Height = 18
    Caption = 'Copyright #1'
    Color = 4227327
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object ImgOnscreen: TImage
    Left = 416
    Top = 520
    Width = 41
    Height = 41
    Visible = False
  end
  object LHelp: TLabel
    Left = 258
    Top = 539
    Width = 32
    Height = 18
    Caption = 'Help'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
    Visible = False
  end
  object ImgBackground: TImage
    Left = 472
    Top = 520
    Width = 41
    Height = 41
    Visible = False
  end
  object ImgBlank: TImage
    Left = 528
    Top = 520
    Width = 41
    Height = 41
    Visible = False
  end
  object RESong: TRichEdit
    Left = 0
    Top = 0
    Width = 700
    Height = 500
    BorderStyle = bsNone
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -32
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    HideSelection = False
    Lines.Strings = (
      '')
    ParentFont = False
    TabOrder = 0
    Visible = False
  end
  object EBlind: TEdit
    Left = -100
    Top = 0
    Width = 40
    Height = 21
    BorderStyle = bsNone
    Color = clBlack
    TabOrder = 1
    OnExit = EBlindExit
    OnKeyDown = EBlindKeyDown
    OnKeyPress = EBlindKeyPress
  end
  object EBlind2: TEdit
    Left = -100
    Top = 20
    Width = 40
    Height = 21
    BorderStyle = bsNone
    Color = clBlack
    TabOrder = 2
    OnExit = EBlind2Exit
    OnKeyDown = EBlind2KeyDown
    OnKeyPress = EBlind2KeyPress
  end
end
