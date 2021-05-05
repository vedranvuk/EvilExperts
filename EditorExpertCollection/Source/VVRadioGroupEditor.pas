unit VVRadioGroupEditor;

interface

uses
  Classes,
  Windows,
  Controls,
  Graphics,
  Forms,
  vvDesignEditors,
  Menus,
  DesignIntf,
  DesignEditors,
  DesignMenus,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  Dialogs,
  Variants;

type
  TvvRadioGroupEditor = class(TvvDefaultEditor)
  protected
    function RadioGroup: TRadioGroup; virtual;
  public
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;

    procedure PrepareItem(Index: integer; const AItem: IMenuItem); override;

    procedure ExecuteVerb(Index: integer); override;
    procedure ItemsMenuHandler(Sender: TObject);
  end;


  TvvRadioGroupEditorDialog = class(TForm)
    PnlButtons: TPanel;
    BtnOk:      TButton;
    BtnCancel:  TButton;
    PnlOptions: TPanel;
    PnlPreview: TPanel;
    EdtCaption: TEdit;
    Label1:     TLabel;
    EdtItems:   TMemo;
    TrkColumns: TTrackBar;
    GrpPreview: TRadioGroup;
    Label2:     TLabel;
    BtnLoad:    TButton;
    Label3:     TLabel;
    BtnClear:   TButton;
    DlgOpen:    TOpenDialog;
    procedure EdtCaptionChange(Sender: TObject);
    procedure TrkColumnsChange(Sender: TObject);
    procedure EdtItemsChange(Sender: TObject);
    procedure BtnLoadClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
  private
    FUpdating: boolean;
  public
    procedure UpdateControls;
  end;


implementation

{$R *.dfm}


 {=================================}
 {== TvvRadioGroupEditor Methods ==}
 {=================================}

function TvvRadioGroupEditor.RadioGroup: TRadioGroup;
begin
  // Helper function to provide quick access to component being edited.
  // Also makes sure Component is a TRadioGroup
  Result := Component as TRadioGroup;
end;


function TvvRadioGroupEditor.GetVerbCount: integer;
begin
  // Return the number of new menu items to display
  if RadioGroup.Items.Count > 0 then
    Result := 2
  else
    Result := 1;
end;


function TvvRadioGroupEditor.GetVerb(Index: integer): string;
begin
  case Index of
    0: Result := 'Edit Items...';
    1: Result := 'Select Item';
  end;
end;


procedure TvvRadioGroupEditor.PrepareItem(Index: integer; const AItem: IMenuItem);
var
  I: integer;

  procedure CreateItemMenu(Index: integer; const Caption: string);
  var
    NewItem: IMenuItem;
  begin
    NewItem     := AItem.AddItem(Caption, 0, RadioGroup.ItemIndex = Index, True, ItemsMenuHandler);
    NewItem.Tag := Index;
  end;

begin
  if Index = 1 then
    for I := 0 to RadioGroup.Items.Count - 1 do
      CreateItemMenu(I, RadioGroup.Items[I]);
end;


procedure TvvRadioGroupEditor.ExecuteVerb(Index: integer);
var
  Dlg: TvvRadioGroupEditorDialog;

  procedure CopyRadioGroup(Dest, Source: TRadioGroup);
  begin
    Dest.Caption   := Source.Caption;
    Dest.Columns   := Source.Columns;
    Dest.Items     := Source.Items;
    Dest.ItemIndex := Source.ItemIndex;
  end;

begin
  if Index = 0 then
  begin
    Dlg := TvvRadioGroupEditorDialog.Create(Application);
    try
      // Copy component attributes to the GrpPreview component
      CopyRadioGroup(Dlg.GrpPreview, RadioGroup);

      // Set the dialog's Caption to reflect component being edited
      Dlg.Caption := Component.Owner.Name + '.' + Component.Name + Dlg.Caption;

      Dlg.UpdateControls;              // Update all controls on dialog box

      if Dlg.ShowModal = mrOk then
      begin
        CopyRadioGroup(RadioGroup, Dlg.GrpPreview);
        // Tell the Form Designer to set the Modified flag for the form
        Designer.Modified;
      end;
    finally
      Dlg.Free;
    end;
  end;
end; {= TvvRadioGroupEditor.ExecuteVerb =}


procedure TvvRadioGroupEditor.ItemsMenuHandler(Sender: TObject);
var
  Idx: integer;
begin
  Idx := TMenuItem(Sender).Tag;
  if RadioGroup.ItemIndex = Idx then
    RadioGroup.ItemIndex := -1
  else
    RadioGroup.ItemIndex := Idx;
  Designer.Modified;
end;


 {==================================}
 {== TRkRadioGroupEditDlg Methods ==}
 {==================================}

procedure TvvRadioGroupEditorDialog.UpdateControls;
begin
  FUpdating := True;
  try
    EdtCaption.Text     := GrpPreview.Caption;
    TrkColumns.Position := GrpPreview.Columns;
    EdtItems.Lines      := GrpPreview.Items;
  finally
    FUpdating := False;
  end;
end;

procedure TvvRadioGroupEditorDialog.EdtCaptionChange(Sender: TObject);
begin
  GrpPreview.Caption := EdtCaption.Text;
end;


procedure TvvRadioGroupEditorDialog.TrkColumnsChange(Sender: TObject);
begin
  GrpPreview.Columns := TrkColumns.Position;
end;


procedure TvvRadioGroupEditorDialog.EdtItemsChange(Sender: TObject);
begin
  if not FUpdating then
    GrpPreview.Items := EdtItems.Lines;
end;


procedure TvvRadioGroupEditorDialog.BtnLoadClick(Sender: TObject);
begin
  if DlgOpen.Execute then
    EdtItems.Lines.LoadFromFile(DlgOpen.FileName);
end;


procedure TvvRadioGroupEditorDialog.BtnClearClick(Sender: TObject);
begin
  EdtItems.Lines.Clear;
  GrpPreview.Items.Clear;
end;


end.
