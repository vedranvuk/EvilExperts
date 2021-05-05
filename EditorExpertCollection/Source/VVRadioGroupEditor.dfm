object vvRadioGroupEditorDialog: TvvRadioGroupEditorDialog
  Left = 192
  Top = 107
  Caption = '- RadioGroup Editor'
  ClientHeight = 266
  ClientWidth = 531
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
  object PnlButtons: TPanel
    Left = 0
    Top = 238
    Width = 531
    Height = 28
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      531
      28)
    object BtnOk: TButton
      Left = 366
      Top = 0
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 2
    end
    object BtnCancel: TButton
      Left = 448
      Top = 0
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 3
    end
    object BtnLoad: TButton
      Left = 8
      Top = 0
      Width = 75
      Height = 25
      Caption = 'Load...'
      TabOrder = 0
      OnClick = BtnLoadClick
    end
    object BtnClear: TButton
      Left = 91
      Top = 0
      Width = 75
      Height = 25
      Caption = 'Clear'
      TabOrder = 1
      OnClick = BtnClearClick
    end
  end
  object PnlOptions: TPanel
    Left = 0
    Top = 0
    Width = 253
    Height = 238
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      253
      238)
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 36
      Height = 13
      Caption = 'Caption'
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 40
      Height = 13
      Caption = 'Columns'
    end
    object Label3: TLabel
      Left = 8
      Top = 72
      Width = 25
      Height = 13
      Caption = 'Items'
    end
    object EdtCaption: TEdit
      Left = 60
      Top = 12
      Width = 185
      Height = 21
      TabOrder = 0
      OnChange = EdtCaptionChange
    end
    object EdtItems: TMemo
      Left = 8
      Top = 88
      Width = 237
      Height = 143
      Anchors = [akLeft, akTop, akBottom]
      ScrollBars = ssBoth
      TabOrder = 2
      WordWrap = False
      OnChange = EdtItemsChange
    end
    object TrkColumns: TTrackBar
      Left = 53
      Top = 36
      Width = 199
      Height = 33
      Min = 1
      PageSize = 1
      Position = 1
      TabOrder = 1
      TickMarks = tmTopLeft
      OnChange = TrkColumnsChange
    end
  end
  object PnlPreview: TPanel
    Left = 253
    Top = 0
    Width = 278
    Height = 238
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 8
    Constraints.MinHeight = 150
    Constraints.MinWidth = 100
    TabOrder = 2
    object GrpPreview: TRadioGroup
      Left = 8
      Top = 8
      Width = 262
      Height = 222
      Align = alClient
      TabOrder = 0
    end
  end
  object DlgOpen: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text Files|*.txt|All Files|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 180
    Top = 236
  end
end
