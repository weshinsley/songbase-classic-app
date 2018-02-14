object FTitle: TFTitle
  Left = 622
  Top = 394
  Width = 269
  Height = 232
  ActiveControl = ESong
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Quick Title Search'
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCanResize = FormCanResize
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    253
    194)
  PixelsPerInch = 96
  TextHeight = 13
  object ESong: TEdit
    Left = 8
    Top = 8
    Width = 245
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnChange = ESongChange
    OnKeyDown = ESongKeyDown
  end
  object LBSongs: TListBox
    Left = 8
    Top = 32
    Width = 245
    Height = 136
    Style = lbOwnerDrawFixed
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 1
    OnClick = LBSongsClick
    OnDblClick = LBSongsDblClick
    OnDrawItem = LBSongsDrawItem
    OnEnter = LBSongsEnter
    OnKeyDown = LBSongsKeyDown
  end
  object PButtons: TPanel
    Left = 50
    Top = 169
    Width = 166
    Height = 25
    Anchors = [akBottom]
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      166
      25)
    object BOk: TButton
      Left = 92
      Top = 0
      Width = 74
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = BOkClick
    end
    object BCancel: TButton
      Left = 0
      Top = 0
      Width = 74
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = BCancelClick
    end
  end
end
