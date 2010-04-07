object frmScreenSaver: TfrmScreenSaver
  Left = 223
  Top = 134
  BorderStyle = bsNone
  ClientHeight = 266
  ClientWidth = 567
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  PixelsPerInch = 96
  TextHeight = 13
  object tmrAnimate: TTimer
    Enabled = False
    OnTimer = tmrAnimateTimer
    Left = 120
    Top = 96
  end
end
