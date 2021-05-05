object VVButtonEditDialog: TVVButtonEditDialog
  Left = 240
  Top = 173
  BorderStyle = bsDialog
  Caption = ' - Button Editor'
  ClientHeight = 314
  ClientWidth = 550
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GrpPreview: TGroupBox
    Left = 8
    Top = 200
    Width = 261
    Height = 105
    Caption = 'Preview'
    TabOrder = 6
    object BtnPreview: TButton
      Left = 8
      Top = 16
      Width = 75
      Height = 25
      TabOrder = 0
    end
  end
  object BtnOK: TButton
    Left = 376
    Top = 280
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 8
  end
  object BtnCancel: TButton
    Left = 464
    Top = 280
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 9
  end
  object GrpModalResult: TRadioGroup
    Left = 280
    Top = 116
    Width = 261
    Height = 149
    Caption = 'Modal Result'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'mrNone'
      'mrOk'
      'mrCancel'
      'mrAbort'
      'mrRetry'
      'mrIgnore'
      'mrYes'
      'mrNo'
      'mrAll'
      'mrNoToAll'
      'mrYesToAll'
      'Custom')
    TabOrder = 4
    OnClick = GrpModalResultClick
  end
  object GrpSize: TGroupBox
    Left = 8
    Top = 116
    Width = 261
    Height = 77
    Caption = 'Size'
    TabOrder = 3
    object LblWidth: TLabel
      Left = 76
      Top = 50
      Width = 28
      Height = 13
      Caption = 'Width'
      Enabled = False
    end
    object LblHeight: TLabel
      Left = 164
      Top = 50
      Width = 31
      Height = 13
      Caption = 'Height'
      Enabled = False
    end
    object OptStandardSize: TRadioButton
      Left = 8
      Top = 20
      Width = 113
      Height = 17
      Caption = 'Standard (75 x 25)'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = ButtonSizeClick
    end
    object OptLargeSize: TRadioButton
      Left = 140
      Top = 20
      Width = 97
      Height = 17
      Caption = 'Large (100 x 35)'
      TabOrder = 1
      OnClick = ButtonSizeClick
    end
    object OptCustomSize: TRadioButton
      Left = 8
      Top = 48
      Width = 57
      Height = 17
      Caption = 'Custom'
      TabOrder = 2
      OnClick = ButtonSizeClick
    end
    object EdtWidth: TEdit
      Left = 108
      Top = 46
      Width = 33
      Height = 21
      Enabled = False
      TabOrder = 3
      Text = '4'
      OnChange = EdtSizeChange
      OnKeyPress = EdtSizeKeyPress
    end
    object EdtHeight: TEdit
      Left = 200
      Top = 46
      Width = 33
      Height = 21
      Enabled = False
      TabOrder = 4
      Text = '4'
      OnChange = EdtSizeChange
      OnKeyPress = EdtSizeKeyPress
    end
    object SpnWidth: TUpDown
      Left = 141
      Top = 46
      Width = 15
      Height = 21
      Associate = EdtWidth
      Enabled = False
      Min = 4
      Max = 300
      Position = 4
      TabOrder = 5
      OnClick = SpnSizeClick
    end
    object SpnHeight: TUpDown
      Left = 233
      Top = 46
      Width = 15
      Height = 21
      Associate = EdtHeight
      Enabled = False
      Min = 4
      Max = 300
      Position = 4
      TabOrder = 6
      OnClick = SpnSizeClick
    end
  end
  object GrpSpecial: TGroupBox
    Left = 280
    Top = 8
    Width = 261
    Height = 101
    Caption = 'Special Buttons'
    TabOrder = 1
    object BtnOKTemplate: TButton
      Left = 8
      Top = 20
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 0
      OnClick = BtnOKTemplateClick
    end
    object BtnCancelTemplate: TButton
      Left = 92
      Top = 20
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = BtnCancelTemplateClick
    end
    object BtnHelpTemplate: TButton
      Left = 176
      Top = 20
      Width = 75
      Height = 25
      Caption = '&Help'
      TabOrder = 2
      OnClick = BtnHelpTemplateClick
    end
    object BtnYesTemplate: TButton
      Left = 8
      Top = 56
      Width = 75
      Height = 25
      Caption = '&Yes'
      TabOrder = 3
      OnClick = BtnYesTemplateClick
    end
    object BtnNoTemplate: TButton
      Left = 92
      Top = 56
      Width = 75
      Height = 25
      Caption = '&No'
      TabOrder = 4
      OnClick = BtnNoTemplateClick
    end
  end
  object GrpKeyboard: TGroupBox
    Left = 8
    Top = 64
    Width = 261
    Height = 45
    Caption = 'Keyboard Interaction'
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 79
      Height = 13
      Caption = 'Button clicked if '
    end
    object Label4: TLabel
      Left = 140
      Top = 20
      Width = 5
      Height = 13
      Caption = '/'
    end
    object Label5: TLabel
      Left = 212
      Top = 20
      Width = 40
      Height = 13
      Caption = 'pressed.'
    end
    object ChkDefault: TCheckBox
      Left = 91
      Top = 19
      Width = 49
      Height = 17
      Caption = 'Enter'
      TabOrder = 0
      OnClick = ChkDefaultClick
    end
    object ChkCancel: TCheckBox
      Left = 151
      Top = 19
      Width = 61
      Height = 17
      Caption = 'Escape'
      TabOrder = 1
      OnClick = ChkCancelClick
    end
  end
  object GrpCaption: TGroupBox
    Left = 8
    Top = 8
    Width = 261
    Height = 49
    Caption = 'Caption'
    TabOrder = 0
    object EdtCaption: TEdit
      Left = 8
      Top = 20
      Width = 245
      Height = 21
      TabOrder = 0
      OnChange = EdtCaptionChange
    end
  end
  object EdtModalResult: TEdit
    Left = 480
    Top = 236
    Width = 33
    Height = 21
    TabOrder = 5
    Text = '0'
  end
  object ChkEnabled: TCheckBox
    Left = 280
    Top = 280
    Width = 69
    Height = 17
    Caption = 'Enabled'
    TabOrder = 7
    OnClick = ChkEnabledClick
  end
  object SpnModalResult: TUpDown
    Left = 513
    Top = 236
    Width = 15
    Height = 21
    Associate = EdtModalResult
    TabOrder = 10
  end
end
