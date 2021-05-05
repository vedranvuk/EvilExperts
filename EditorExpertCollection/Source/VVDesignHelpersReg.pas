unit VVDesignHelpersReg;

interface

uses
	Classes,
	Forms,
	DesignIntf,
	ActnList,
	Controls,
	StdCtrls,
	ExtCtrls,
	VVHintEditor,
	VVListBoxEditor,
	VVButtonEditor,
	VVRadioGroupEditor,
	VVAlignEditor;

procedure Register;

implementation

procedure Register;
begin
	// RegisterPropertyEditor(TypeInfo(string), TComponent, 'Hint', THintProperty);

	RegisterComponentEditor(TListBox, TVVListBoxEditor);
	RegisterComponentEditor(TButton, TvvButtonEditor);
	RegisterComponentEditor(TRadioGroup, TvvRadioGroupEditor);
	RegisterComponentEditor(TControl, TVVAlignEditor);
    RegisterComponentEditor(TWinControl, TvvAlignEditor);
end;

end.
