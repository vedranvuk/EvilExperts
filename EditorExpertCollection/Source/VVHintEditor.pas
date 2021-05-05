unit VVHintEditor;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls, Buttons, DesignEditors, DesignIntf, ExtCtrls;

type
	TEditorHint = class(TForm)
		invTip: TMemo;
		invHint: TEdit;
		Label2: TLabel;
		Label1: TLabel;
		btnOK: TButton;
		btnCancel: TButton;
		Bevel1: TBevel;
		procedure btnOkClick(Sender: TObject);
		procedure btnCancelClick(Sender: TObject);
	end;

    { }
	THintProperty = class(TStringProperty)
	public
		procedure Edit; override;
		function GetAttributes: TPropertyAttributes; override;
		function Lines2String(Lines: TStrings): string;
		procedure String2Lines(S: string; t: TStrings);
	end;

implementation

{$R *.DFM}


function THintProperty.GetAttributes: TPropertyAttributes;
begin
	Result := [paDialog, paMultiSelect, paAutoUpdate];
end;

function THintProperty.Lines2String(Lines: TStrings): string;
var
	S: string;
	i: integer;
begin
	S      := '';
	for i  := 0 to Lines.Count - 1 do
		S  := S + Lines[i] + #13;
	S      := copy(S, 1, length(S) - 1);
	Result := S;
end;

procedure THintProperty.String2Lines(S: string; t: TStrings);
var
	i: integer;
begin
	while S <> '' do
	begin
		i := pos(#13, S);
		if i = 0 then
		begin
			t.Add(S);
			S := '';
		end
		else
		begin
			t.Add(copy(S, 1, i - 1));
			Delete(S, 1, i);
		end;
	end;
end;

procedure THintProperty.Edit;
var
	EditorHint: TEditorHint;
	S         : string;
	p         : integer;
begin
	EditorHint := TEditorHint.Create(Application);
	S          := GetStrValue;

	p := pos('|', S);
	if p > 0 then
	begin
		EditorHint.invHint.Text := copy(S, p + 1, length(S));
		String2Lines(copy(S, 1, p - 1), EditorHint.invTip.Lines);
	end
	else
		EditorHint.invHint.Text := S;

	if EditorHint.ShowModal = mrOk then
	begin
		S := Lines2String(EditorHint.invTip.Lines);
		if S <> '' then
			S := S + '|';
		if EditorHint.invHint.Text <> '' then
			S := S + EditorHint.invHint.Text;
		SetStrValue(S);
	end;

	EditorHint.Free;
end;

procedure TEditorHint.btnOkClick(Sender: TObject);
begin
	ModalResult := mrOk;
end;

procedure TEditorHint.btnCancelClick(Sender: TObject);
begin
	ModalResult := mrCancel;
end;

end.
