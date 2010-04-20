object frmScreenSaverSetup: TfrmScreenSaverSetup
  Left = 245
  Top = 199
  ActiveControl = edtFileName
  BorderStyle = bsDialog
  Caption = 'Build Status Screen Saver Config'
  ClientHeight = 449
  ClientWidth = 473
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 458
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
    Left = 155
    Top = 412
    Width = 75
    Height = 25
    DoubleBuffered = True
    Kind = bkOK
    ParentDoubleBuffered = False
    TabOrder = 2
  end
  object btnCancel: TBitBtn
    Left = 243
    Top = 412
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
    Width = 325
    Height = 21
    Hint = 'Enter the URL of the CCTray file'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnChange = edtFileNameChange
  end
  object tbAnimationFrequency: TTrackBar
    Left = 120
    Top = 48
    Width = 339
    Height = 33
    Hint = 'Select the frequency of the animation (1-10 seconds)'
    Min = 1
    ParentShowHint = False
    Position = 3
    PositionToolTip = ptBottom
    ShowHint = True
    TabOrder = 1
    OnChange = tbAnimationFrequencyChange
  end
  object tbUpdateFrequency: TTrackBar
    Left = 120
    Top = 89
    Width = 339
    Height = 33
    Hint = 'Select the CCTray update frequency (0-10 minutes)'
    Min = 1
    ParentShowHint = False
    Position = 3
    PositionToolTip = ptBottom
    ShowHint = True
    TabOrder = 4
    OnChange = tbUpdateFrequencyChange
  end
  object Fonts: TGroupBox
    Left = 8
    Top = 144
    Width = 458
    Height = 263
    Caption = 'Fonts'
    TabOrder = 5
    object lbCurrentlActivity: TLabel
      Left = 8
      Top = 16
      Width = 76
      Height = 13
      Caption = 'Current Activity'
    end
    object lblLastBuildStatus: TLabel
      Left = 232
      Top = 16
      Width = 79
      Height = 13
      Caption = 'Last Build Status'
    end
    object lblFontExample: TLabel
      AlignWithMargins = True
      Left = 5
      Top = 156
      Width = 448
      Height = 102
      Hint = 'Click me to change this font'
      Align = alBottom
      Alignment = taCenter
      AutoSize = False
      Caption = 'Sleeping Successful'
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -43
      Font.Name = 'Ariel'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Transparent = False
      Layout = tlCenter
      WordWrap = True
      OnClick = ChangeFont
      ExplicitLeft = 2
      ExplicitTop = 135
      ExplicitWidth = 429
    end
    object sbAddActivity: TSpeedButton
      Left = 176
      Top = 56
      Width = 44
      Height = 22
      Caption = 'Add'
      Enabled = False
      OnClick = sbAddActivityClick
    end
    object sbDeleteActivity: TSpeedButton
      Left = 176
      Top = 80
      Width = 44
      Height = 22
      Caption = 'Delete'
      Enabled = False
      OnClick = sbDeleteActivityClick
    end
    object sbRenameActivity: TSpeedButton
      Left = 176
      Top = 104
      Width = 44
      Height = 22
      Caption = 'Rename'
      Enabled = False
      OnClick = sbRenameActivityClick
    end
    object sbAddStatus: TSpeedButton
      Left = 400
      Top = 56
      Width = 44
      Height = 22
      Caption = 'Add'
      Enabled = False
      OnClick = sbAddStatusClick
    end
    object sbDeleteStatus: TSpeedButton
      Left = 400
      Top = 80
      Width = 44
      Height = 22
      Caption = 'Delete'
      Enabled = False
      OnClick = sbDeleteStatusClick
    end
    object sbRenameStatus: TSpeedButton
      Left = 400
      Top = 104
      Width = 44
      Height = 22
      Caption = 'Rename'
      Enabled = False
      OnClick = sbRenameStatusClick
    end
    object lbActivity: TListBox
      Left = 8
      Top = 56
      Width = 160
      Height = 97
      ItemHeight = 13
      Items.Strings = (
        'Sleeping'
        'Building'
        'CheckingModifications')
      TabOrder = 0
      OnClick = ChangeFontContext
    end
    object lbStatus: TListBox
      Left = 232
      Top = 56
      Width = 160
      Height = 97
      ItemHeight = 13
      Items.Strings = (
        'Success'
        'Failure'
        'Exception'
        'Unknown')
      TabOrder = 1
      OnClick = ChangeFontContext
    end
    object edtActivity: TEdit
      Left = 8
      Top = 32
      Width = 160
      Height = 21
      TabOrder = 2
      Text = 'Sleeping'
      OnChange = edtActivityChange
    end
    object edtStatus: TEdit
      Left = 232
      Top = 32
      Width = 160
      Height = 21
      TabOrder = 3
      Text = 'Success'
      OnChange = edtStatusChange
    end
  end
  object fd: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 336
    Top = 408
  end
end
