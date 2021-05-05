unit VVAlignEditor;

interface

uses
	Menus, DesignIntf, DesignEditors, DesignMenus, VVDesignEditors, Controls;

type
	TvvAlignEditor = class(TDefaultEditor)
	protected
		function Control: TControl; virtual;
	public
		function GetVerb(Index: integer): string; override;
		function GetVerbCount: integer; override;
		procedure ExecuteVerb(Index: integer); override;
		procedure PrepareItem(Index: Integer; const AItem: IMenuItem); override;
		procedure OnClick(Sender: TObject);
	end;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
implementation

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

function TvvAlignEditor.Control: TControl;
begin
	Result := Component as TControl;
end;

function TvvAlignEditor.GetVerb(Index: integer): string;
begin
	if index = 0 then
	begin
		Result := 'Align';
	end;
end;

function TvvAlignEditor.GetVerbCount: integer;
begin
	Result := 1;
end;

procedure TvvAlignEditor.ExecuteVerb(Index: integer);
begin
 //
end;

procedure TvvAlignEditor.PrepareItem(Index: Integer; const AItem: IMenuItem);

	procedure CreateItem(AlignValue: TAlign; const Caption: string);
	begin
		with AItem.AddItem(Caption, 0, Control.Align = AlignValue, True, OnClick) do
			case AlignValue of
				alNone:
				Tag := 0;
				alTop:
				Tag := 1;
				alBottom:
				Tag := 2;
				alLeft:
				Tag := 3;
				alRight:
				Tag := 4;
				alClient:
				Tag := 5;
				alCustom:
				Tag := 6;
			end;
	end;

begin
	if index = 0 then
	begin
		CreateItem(alClient, 'Client');
		CreateItem(alNone, 'None');
		CreateItem(alCustom, 'Custom');
		CreateItem(alLeft, 'Left');
		CreateItem(alTop, 'Top');
		CreateItem(alRight, 'Right');
		CreateItem(alBottom, 'Bottom');
	end;
end;

procedure TvvAlignEditor.OnClick(Sender: TObject);
begin
	Control.Align := TAlign(TMenuItem(Sender).Tag);
	Designer.Modified;
end;

end.
