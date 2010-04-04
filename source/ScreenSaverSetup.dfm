object frmScreenSaverSetup: TfrmScreenSaverSetup
  Left = 245
  Top = 199
  ActiveControl = edtFileName
  BorderStyle = bsDialog
  Caption = 'ccTray Screen Saver Config'
  ClientHeight = 220
  ClientWidth = 466
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 433
    Height = 129
    Shape = bsFrame
  end
  object lblFileName: TLabel
    Left = 79
    Top = 20
    Width = 38
    Height = 13
    Caption = '&File URL'
    FocusControl = edtFileName
  end
  object lblAnimationFrequency: TLabel
    Left = 16
    Top = 52
    Width = 101
    Height = 13
    Caption = '&Animation Frequency'
  end
  object lblUpdateFrequency: TLabel
    Left = 28
    Top = 92
    Width = 89
    Height = 13
    Caption = '&Update Frequency'
    FocusControl = tbUpdateFrequency
  end
  object btnOk: TBitBtn
    Left = 152
    Top = 172
    Width = 75
    Height = 25
    DoubleBuffered = True
    Kind = bkOK
    ParentDoubleBuffered = False
    TabOrder = 2
  end
  object btnCancel: TBitBtn
    Left = 240
    Top = 172
    Width = 75
    Height = 25
    DoubleBuffered = True
    Kind = bkCancel
    ParentDoubleBuffered = False
    TabOrder = 3
  end
  object edtFileName: TEdit
    Left = 127
    Top = 16
    Width = 298
    Height = 21
    Hint = 'Enter the URL of the CCTray file'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object tbAnimationFrequency: TTrackBar
    Left = 120
    Top = 48
    Width = 312
    Height = 33
    Hint = 'Select the frequency of the animation (1-10 seconds)'
    Min = 1
    ParentShowHint = False
    Position = 3
    ShowHint = True
    TabOrder = 1
  end
  object tbUpdateFrequency: TTrackBar
    Left = 120
    Top = 89
    Width = 312
    Height = 33
    Hint = 'Select the CCTray update frequency (0-10 minutes)'
    ParentShowHint = False
    Position = 3
    ShowHint = True
    TabOrder = 4
  end
  object xpmnfst1: TXPManifest
    Left = 40
    Top = 172
  end
end
