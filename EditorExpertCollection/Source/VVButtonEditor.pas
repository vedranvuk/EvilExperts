unit VVButtonEditor;

interface

uses
  DesignIntf, DesignEditors, Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TvvButtonEditor = class(TDefaultEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  end;

  TVVButtonEditDialog = class(TForm)
    GrpPreview: TGroupBox;
    BtnPreview: TButton;
    BtnOK:      TButton;
    BtnCancel:  TButton;
    GrpModalResult: TRadioGroup;
    GrpSize:    TGroupBox;
    OptStandardSize: TRadioButton;
    OptLargeSize: TRadioButton;
    OptCustomSize: TRadioButton;
    EdtWidth:   TEdit;
    EdtHeight:  TEdit;
    SpnWidth:   TUpDown;
    SpnHeight:  TUpDown;
    LblWidth:   TLabel;
    LblHeight:  TLabel;
    GrpSpecial: TGroupBox;
    BtnOKTemplate: TButton;
    BtnCancelTemplate: TButton;
    BtnHelpTemplate: TButton;
    GrpKeyboard: TGroupBox;
    ChkDefault: TCheckBox;
    ChkCancel:  TCheckBox;
    GrpCaption: TGroupBox;
    EdtCaption: TEdit;
    Label1:     TLabel;
    Label4:     TLabel;
    Label5:     TLabel;
    BtnYesTemplate: TButton;
    BtnNoTemplate: TButton;
    EdtModalResult: TEdit;
    ChkEnabled: TCheckBox;
    SpnModalResult: TUpDown;
    procedure EdtCaptionChange(Sender: TObject);
    procedure ChkDefaultClick(Sender: TObject);
    procedure ChkCancelClick(Sender: TObject);
    procedure ButtonSizeClick(Sender: TObject);
    procedure EdtSizeKeyPress(Sender: TObject; var Key: char);
    procedure SpnSizeClick(Sender: TObject; Button: TUDBtnType);
    procedure EdtSizeChange(Sender: TObject);
    procedure ChkEnabledClick(Sender: TObject);
    procedure GrpModalResultClick(Sender: TObject);
    procedure BtnOKTemplateClick(Sender: TObject);
    procedure BtnCancelTemplateClick(Sender: TObject);
    procedure BtnHelpTemplateClick(Sender: TObject);
    procedure BtnYesTemplateClick(Sender: TObject);
    procedure BtnNoTemplateClick(Sender: TObject);
  private
    procedure EnableWidthHeight(Enable: boolean);
    procedure UpdateWidthHeight;
  public
    procedure UpdateControls;
  end;


implementation

{$R *.dfm}


 {=============================}
 {== TvvButtonEditor Methods ==}
 {=============================}

function TvvButtonEditor.GetVerbCount: integer;
begin
  Result := 7;           // Return the number of new menu items to display
end;


function TvvButtonEditor.GetVerb(Index: integer): string;
begin
  case Index of
    0: Result := 'Resize to default';
    1: Result := 'Edit Button...';
    2: Result := '-';
    3: Result := 'Help';
    4: Result := 'Ok';
    5: Result := 'Cancel';
    6: Result := 'Apply';
  end;
end;


{=========================================================================
  TvvButtonEditor.ExecuteVerb

  This method will be invoked by Delphi whenever the user selects one of
  the newly created item on the components context menu while in the
  Form Designer. If the first item is selected (i.e. Edit Button...), then
  the TRkButtonEditDlg form is displayed. If one of the other menu items
  is selected, the button's properties are changed appropriately.
=========================================================================}

procedure TvvButtonEditor.ExecuteVerb(Index: integer);
var
  D: TVVButtonEditDialog;

  procedure CopyButton(Dest, Source: TButton);
  begin
    Dest.Caption      := Source.Caption;
    Dest.ModalResult  := Source.ModalResult;
    Dest.Default      := Source.Default;
    Dest.Cancel       := Source.Cancel;
    Dest.Width        := Source.Width;
    Dest.Height       := Source.Height;
    Dest.Enabled      := Source.Enabled;
  end;

begin
  case Index of

    0:
    begin
      with Component as TButton do
      begin
        Width := 75;
        Height := 25;
      end;
      Designer.Modified;
    end;

    1:                                    // User selected "Edit Button..."
    begin
      D := TVVButtonEditDialog.Create(Application);

      try
        // Copy component attributes to the BtnPreview component
        CopyButton(D.BtnPreview, Component as TButton);

        // Set the dialog's Caption to reflect component being edited
        D.Caption := Component.Owner.Name + '.' + Component.Name + D.Caption;

        D.UpdateControls;              // Update all controls on dialog box

        if D.ShowModal = mrOk then               // Display the dialog box
        begin
          CopyButton(Component as TButton, D.BtnPreview);
          // Tell the Form Designer to set the Modified flag for the form
          Designer.Modified;
        end;
      finally
        D.Free;
      end;
    end;

    3:                                           // User selected "Help"
    begin
      with Component as TButton do
      begin
        Caption := '&Help';
        Default := False;
        Cancel  := False;
        ModalResult := mrNone;
        Width   := 75;
        Height  := 25;
        Name := 'btnHelp';
        Enabled := True;
      end;
      Designer.Modified;
    end;

    4:                                           // User selected "OK"
    begin
      with Component as TButton do
      begin
        Caption := '&OK';
        Default := True;
        Cancel  := False;
        ModalResult := mrOk;
        Width   := 75;
        Height  := 25;
        Name := 'btnOK';
        Enabled := True;
      end;
      Designer.Modified;
    end;

    5:                                         // User selected "Cancel"
    begin
      with Component as TButton do
      begin
        Caption := '&Cancel';
        Default := False;
        Cancel  := True;
        ModalResult := mrCancel;
        Width   := 75;
        Height  := 25;
        Name := 'btnCancel';
        Enabled := True;
      end;
      Designer.Modified;
    end;

    6:                                         // User selected "Cancel"
    begin
      with Component as TButton do
      begin
        Caption := '&Apply';
        Default := False;
        Cancel  := True;
        ModalResult := mrCancel;
        Width   := 75;
        Height  := 25;
        Name := 'btnApply';
        Enabled := True;
      end;
      Designer.Modified;
    end;

  end; { case }
end; {= TvvButtonEditor.ExecuteVerb =}


 {==============================}
 {== TRkButtonEditDlg Methods ==}
 {==============================}

procedure TVVButtonEditDialog.UpdateControls;
begin
  EdtCaption.Text := BtnPreview.Caption;
  if BtnPreview.ModalResult < 11 then
    GrpModalResult.ItemIndex := BtnPreview.ModalResult;
  SpnModalResult.Position := BtnPreview.ModalResult;
  ChkDefault.Checked := BtnPreview.Default;
  ChkCancel.Checked  := BtnPreview.Cancel;
  ChkEnabled.Checked := BtnPreview.Enabled;

  if (BtnPreview.Width = 75) and (BtnPreview.Height = 25) then
    OptStandardSize.Checked := True
  else if (BtnPreview.Width = 100) and (BtnPreview.Height = 35) then
    OptLargeSize.Checked  := True
  else
    OptCustomSize.Checked := True;
  SpnWidth.Position := BtnPreview.Width;
  SpnHeight.Position := BtnPreview.Height;

end; {= TRkButtonEditDlg.UpdateControls =}


procedure TVVButtonEditDialog.EdtCaptionChange(Sender: TObject);
begin
  BtnPreview.Caption := EdtCaption.Text;
end;

procedure TVVButtonEditDialog.ChkDefaultClick(Sender: TObject);
begin
  BtnPreview.Default := ChkDefault.Checked;
end;

procedure TVVButtonEditDialog.ChkCancelClick(Sender: TObject);
begin
  BtnPreview.Cancel := ChkCancel.Checked;
end;

procedure TVVButtonEditDialog.EnableWidthHeight(Enable: boolean);
begin
  LblWidth.Enabled  := Enable;
  EdtWidth.Enabled  := Enable;
  SpnWidth.Enabled  := Enable;
  LblHeight.Enabled := Enable;
  EdtHeight.Enabled := Enable;
  SpnHeight.Enabled := Enable;
end;


procedure TVVButtonEditDialog.UpdateWidthHeight;
begin
  BtnPreview.Width  := SpnWidth.Position;
  BtnPreview.Height := SpnHeight.Position;
end;


procedure TVVButtonEditDialog.ButtonSizeClick(Sender: TObject);
begin
  EnableWidthHeight(Sender = OptCustomSize);
  if Sender = OptStandardSize then
  begin
    SpnWidth.Position  := 75;
    SpnHeight.Position := 25;
  end
  else if Sender = OptLargeSize then
  begin
    SpnWidth.Position  := 100;
    SpnHeight.Position := 35;
  end
  else begin
    SpnWidth.Position  := BtnPreview.Width;
    SpnHeight.Position := BtnPreview.Height;
  end;

  UpdateWidthHeight;
end;

procedure TVVButtonEditDialog.EdtSizeKeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['0'..'9', #8]) then
  begin
    MessageBeep(0);
    Key := #0;
  end;
end;

procedure TVVButtonEditDialog.EdtSizeChange(Sender: TObject);
begin
  UpdateWidthHeight;
end;

procedure TVVButtonEditDialog.SpnSizeClick(Sender: TObject; Button: TUDBtnType);
begin
  UpdateWidthHeight;
end;

procedure TVVButtonEditDialog.ChkEnabledClick(Sender: TObject);
begin
  BtnPreview.Enabled := ChkEnabled.Checked;
end;

procedure TVVButtonEditDialog.GrpModalResultClick(Sender: TObject);
begin
  EdtModalResult.Enabled := GrpModalResult.ItemIndex = 11;

  if GrpModalResult.ItemIndex < 11 then
  begin
    BtnPreview.ModalResult  := TModalResult(GrpModalResult.ItemIndex);
    SpnModalResult.Position := GrpModalResult.ItemIndex;
  end
  else
    BtnPreview.ModalResult := SpnModalResult.Position;
end;

{ Special Buttons }

procedure TVVButtonEditDialog.BtnOKTemplateClick(Sender: TObject);
begin
  with BtnPreview do
  begin
    Caption := '&OK';
    Default := True;
    Cancel  := False;
    ModalResult := mrOk;
    Width   := 75;
    Height  := 25;
    Enabled := True;
  end;
  UpdateControls;
end;

procedure TVVButtonEditDialog.BtnCancelTemplateClick(Sender: TObject);
begin
  with BtnPreview do
  begin
    Caption := '&Cancel';
    Default := False;
    Cancel  := True;
    ModalResult := mrCancel;
    Width   := 75;
    Height  := 25;
    Enabled := True;
  end;
  UpdateControls;

end;

procedure TVVButtonEditDialog.BtnHelpTemplateClick(Sender: TObject);
begin
  with BtnPreview do
  begin
    Caption := '&Help';
    Default := False;
    Cancel  := False;
    ModalResult := mrNone;
    Width   := 75;
    Height  := 25;
    Enabled := True;
  end;
  UpdateControls;
end;

procedure TVVButtonEditDialog.BtnYesTemplateClick(Sender: TObject);
begin
  with BtnPreview do
  begin
    Caption := '&Yes';
    Default := False;
    Cancel  := False;
    ModalResult := mrYes;
    Width   := 75;
    Height  := 25;
    Enabled := True;
  end;
  UpdateControls;
end;

procedure TVVButtonEditDialog.BtnNoTemplateClick(Sender: TObject);
begin
  with BtnPreview do
  begin
    Caption := '&No';
    Default := False;
    Cancel  := False;
    ModalResult := mrNo;
    Width   := 75;
    Height  := 25;
    Enabled := True;
  end;
  UpdateControls;
end;


end.
