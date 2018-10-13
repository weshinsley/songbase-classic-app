object FWebServer: TFWebServer
  Left = 1241
  Top = 796
  Width = 459
  Height = 221
  Caption = 'FWebServer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object RichEdit1: TRichEdit
    Left = 40
    Top = 8
    Width = 185
    Height = 89
    Lines.Strings = (
      'RichEdit1')
    TabOrder = 0
  end
  object RichEdit2: TRichEdit
    Left = 232
    Top = 8
    Width = 185
    Height = 89
    Lines.Strings = (
      'RichEdit1')
    TabOrder = 1
  end
  object WebServer: TIdHTTPServer
    Bindings = <>
    CommandHandlers = <>
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    OnCommandGet = WebServerCommandGet
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Top = 32
  end
  object IdEncoderMIME1: TIdEncoderMIME
    FillChar = '='
    Top = 64
  end
end
