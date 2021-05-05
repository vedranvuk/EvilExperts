unit VVDesignHelpers;

interface

uses
	Windows, Classes, Controls, Graphics, ImgList, Menus, Forms, ExtCtrls,
	DesignIntf, DesignEditors, VCLEditors, VCLSprigs, DesignMenus, TreeIntf,
	IniFiles, Registry;

type
    { TComponentEditorEx }
	TComponentEditorEx = class(TComponentEditor)
	private
		FPropName  : string;
		FContinue  : Boolean;
		FPropEditor: IProperty;
		procedure EnumPropertyEditors(const PropertyEditor: IProperty);
		procedure TestPropertyEditor(const PropertyEditor: IProperty; var Continue: Boolean);
		procedure AlignMenuHandler(Sender: TObject);
		procedure ImageListMenuHandler(Sender: TObject);
		procedure RegIniFileMenuHandler(Sender: TObject);
	protected
		procedure DesignerModified;
		procedure EditPropertyByName(const APropName: string);
		function AlignMenuIndex: Integer; virtual;
		function MenuBitmapResourceName(Index: Integer): string; virtual;
		function GetCompRefData(Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string; var CompRefMenuHandler: TNotifyEvent): Boolean; virtual;
		procedure PrepareMenuItem(Index: Integer; const Item: TMenuItem); virtual;
	public
		procedure PrepareItem(Index: Integer; const AItem: IMenuItem); override;
	end;

    { TDefaultEditorEx }
	TDefaultEditorEx = class(TDefaultEditor)
	private
		FPropName  : string;
		FContinue  : Boolean;
		FPropEditor: IProperty;
		procedure EnumPropertyEditors(const PropertyEditor: IProperty);
		procedure TestPropertyEditor(const PropertyEditor: IProperty; var Continue: Boolean);
		procedure AlignMenuHandler(Sender: TObject);
		procedure ImageListMenuHandler(Sender: TObject);
		procedure RegIniFileMenuHandler(Sender: TObject);
	protected
		procedure DesignerModified;
		procedure EditPropertyByName(const APropName: string);
		function AlignMenuIndex: Integer; virtual;
		function MenuBitmapResourceName(Index: Integer): string; virtual;
		function GetCompRefData(Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string; var CompRefMenuHandler: TNotifyEvent): Boolean; virtual;
		procedure PrepareMenuItem(Index: Integer; const Item: TMenuItem); virtual;
	public
		procedure PrepareItem(Index: Integer; const AItem: IMenuItem); override;
	end;

function UniqueName(AComponent: TComponent): string;

implementation

uses
	SysUtils,
	TypInfo,
	StdCtrls,
	ComCtrls,
	Dialogs;

{$R VVDesignHelpers.res}

{=====================}
{== Support Methods ==}
{=====================}

// There is no UniqueName method for TFormDesigner in Delphi 1, so we need our
// own equivalent.  The local UniqueName function is also used for Delphi 2/3
// because it makes the names nicer by removing the 'cs' prefix normally
// included (by TFormDesigner.UniqueName) for objects of type TRzTabSheet.

// Test a component name for uniqueness and return True if it is unique or False
// if there is another component with the same name.

function TryName(const AName: string; AComponent: TComponent): Boolean;
var
	I: Integer;
begin
	Result := False;
	for I  := 0 to AComponent.ComponentCount - 1 do
	begin
		if CompareText(AComponent.Components[I].Name, AName) = 0 then
			Exit;
	end;
	Result := True;
end;


// Generate a unique name for a component.  Use the standard Delphi rules,
// e.g., <type><number>, where <type> is the component's class name without
// a leading 'T', and <number> is an integer to make the name unique.

function UniqueName(AComponent: TComponent): string;
var
	I  : Integer;
	Fmt: string;
begin
  // Create a Format string to use as a name template.
	if CompareText(Copy(AComponent.ClassName, 1, 3), 'TRz') = 0 then
		Fmt := Copy(AComponent.ClassName, 4, 255) + '%d'
	else
		Fmt := AComponent.ClassName + '%d';

	if AComponent.Owner = nil then
	begin
    // No owner; any name is unique. Use 1.
		Result := Format(Fmt, [1]);
		Exit;
	end
	else
	begin
    // Try all possible numbers until we find a unique name.
		for I := 1 to high(Integer) do
		begin
			Result := Format(Fmt, [I]);
			if TryName(Result, AComponent.Owner) then
				Exit;
		end;
	end;

  // This should never happen, but just in case...
	raise Exception.CreateFmt('Cannot create unique name for %s.', [AComponent.ClassName]);
end;

{== Base Component Editors ====================================================}

{================================}
{== TvvComponentEditor Methods ==}
{================================}

procedure TComponentEditorEx.EnumPropertyEditors(const PropertyEditor: IProperty);
begin
	if FContinue then
		TestPropertyEditor(PropertyEditor, FContinue);
end;

procedure TComponentEditorEx.TestPropertyEditor(const PropertyEditor: IProperty; var Continue: Boolean);
begin
	if not Assigned(FPropEditor) and (CompareText(PropertyEditor.GetName, FPropName) = 0) then
	begin
		Continue    := False;
		FPropEditor := PropertyEditor;
	end;
end;

procedure TComponentEditorEx.EditPropertyByName(const APropName: string);
var
	Components: IDesignerSelections;
begin
	Components := TDesignerSelections.Create;
	FContinue  := True;
	FPropName  := APropName;
	Components.Add(Component);
	FPropEditor := nil;
	try
		GetComponentProperties(Components, tkAny, Designer, EnumPropertyEditors);
		if Assigned(FPropEditor) then
			FPropEditor.Edit;
	finally
		FPropEditor := nil;
	end;
end;

procedure TComponentEditorEx.DesignerModified;
begin
	if Designer <> nil then
		Designer.Modified;
end;

function TComponentEditorEx.AlignMenuIndex: Integer;
begin
	Result := - 1;
end;

function TComponentEditorEx.MenuBitmapResourceName(Index: Integer): string;
begin
	Result := '';
end;

function TComponentEditorEx.GetCompRefData(Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string; var CompRefMenuHandler: TNotifyEvent): Boolean;
begin
	Result := False;
end;

procedure TComponentEditorEx.PrepareMenuItem(Index: Integer; const Item: TMenuItem);
var
	ResName           : string;
	I, CompRefCount   : Integer;
	CompOwner         : TComponent;
	CompRefClass      : TComponentClass;
	CompRefPropName   : string;
	CompRefMenuHandler: TNotifyEvent;

	procedure CreateAlignItem(AlignValue: TAlign; const Caption: string);
	var
		NewItem: TMenuItem;
	begin
		NewItem         := TMenuItem.Create(Item);
		NewItem.Caption := Caption;
		NewItem.Tag     := Ord(AlignValue);
		NewItem.Checked := TControl(Component).Align = AlignValue;
		case AlignValue of
			alNone:
			NewItem.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_NONE');
			alTop:
			NewItem.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_TOP');
			alBottom:
			NewItem.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_BOTTOM');
			alLeft:
			NewItem.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_LEFT');
			alRight:
			NewItem.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_RIGHT');
			alClient:
			NewItem.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_CLIENT');
		end;
		NewItem.OnClick := AlignMenuHandler;
		Item.Add(NewItem);
	end;

	procedure CreateCompRefMenu(CompRef: TComponent; const CompRefPropName: string; CompRefMenuHandler: TNotifyEvent);
	var
		NewItem: TMenuItem;
	begin
		NewItem             := TMenuItem.Create(Item);
		NewItem.AutoHotkeys := maManual;
		NewItem.Caption     := CompRef.Name;
		NewItem.Checked     := GetObjectProp(Component, CompRefPropName) = CompRef;
		NewItem.OnClick     := CompRefMenuHandler;
		Item.Add(NewItem);
	end;

begin {= TvvComponentEditor.PrepareMenuItem =}
      // Descendant classes override this method to consistently handle preparing menu items in
      // Delphi 5, Delphi 6 and higher.

	ResName := MenuBitmapResourceName(index);
	if ResName <> '' then
		Item.Bitmap.LoadFromResourceName(HInstance, ResName);

	if index = AlignMenuIndex then
	begin
		case TControl(Component).Align of
			alNone:
			Item.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_NONE');
			alTop:
			Item.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_TOP');
			alBottom:
			Item.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_BOTTOM');
			alLeft:
			Item.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_LEFT');
			alRight:
			Item.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_RIGHT');
			alClient:
			Item.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_CLIENT');
		end;

		CreateAlignItem(alClient, 'Client');
		CreateAlignItem(alLeft, 'Left');
		CreateAlignItem(alTop, 'Top');
		CreateAlignItem(alRight, 'Right');
		CreateAlignItem(alBottom, 'Bottom');
		CreateAlignItem(alNone, 'None');
	end;

	if GetCompRefData(index, CompRefClass, CompRefPropName, CompRefMenuHandler) then
	begin
		Item.AutoHotkeys := maManual;
		CompRefCount     := 0;
		CompOwner        := Designer.GetRoot;

		if not Assigned(CompRefMenuHandler) then
		begin
			if CompRefClass = TCustomImageList then
				CompRefMenuHandler := ImageListMenuHandler
			else
			  if CompRefClass = TRegIniFile.ClassInfo then
				CompRefMenuHandler := RegIniFileMenuHandler;
		end;

		if CompOwner <> nil then
		begin
			for I := 0 to CompOwner.ComponentCount - 1 do
			begin
				if CompOwner.Components[I] is CompRefClass then
				begin
					Inc(CompRefCount);
					CreateCompRefMenu(CompOwner.Components[I], CompRefPropName,
					  CompRefMenuHandler);
				end;
			end;
		end;
		Item.Enabled := CompRefCount > 0;
	end;

end; {= TvvComponentEditor.PrepareMenuItem =}

procedure TComponentEditorEx.PrepareItem(Index: Integer; const AItem: IMenuItem);
var
	CompRef : IInterfaceComponentReference;
	MenuItem: TMenuItem;
begin
	CompRef  := AItem as IInterfaceComponentReference;
	MenuItem := CompRef.GetComponent as TMenuItem;
	PrepareMenuItem(index, MenuItem);
end;

procedure TComponentEditorEx.AlignMenuHandler(Sender: TObject);
begin
	TControl(Component).Align := TAlign(TMenuItem(Sender).Tag);
	DesignerModified;
end;

procedure TComponentEditorEx.ImageListMenuHandler(Sender: TObject);
var
	S        : string;
	ImageList: TCustomImageList;
begin
	if Designer.GetRoot <> nil then
	begin
		S         := TMenuItem(Sender).Caption;
		ImageList := Designer.GetRoot.FindComponent(S) as TCustomImageList;
		SetObjectProp(Component, 'Images', ImageList);
		DesignerModified;
	end;
end;

procedure TComponentEditorEx.RegIniFileMenuHandler(Sender: TObject);
var
	S         : string;
	RegIniFile: TRegIniFile;
begin
	if Designer.GetRoot <> nil then
	begin
		S          := TMenuItem(Sender).Caption;
		RegIniFile := TRegIniFile(Designer.GetRoot.FindComponent(S));
		SetObjectProp(Component, 'RegIniFile', RegIniFile);
		DesignerModified;
	end;
end;

{==============================}
{== TvvDefaultEditor Methods ==}
{==============================}

procedure TDefaultEditorEx.EnumPropertyEditors(const PropertyEditor: IProperty);
begin
	if FContinue then
		TestPropertyEditor(PropertyEditor, FContinue);
end;

procedure TDefaultEditorEx.TestPropertyEditor(const PropertyEditor: IProperty; var Continue: Boolean);
begin
	if not Assigned(FPropEditor) and (CompareText(PropertyEditor.GetName, FPropName) = 0) then
	begin
		Continue    := False;
		FPropEditor := PropertyEditor;
	end;
end;

procedure TDefaultEditorEx.EditPropertyByName(const APropName: string);
var
	Components: IDesignerSelections;
begin
	Components := TDesignerSelections.Create;
	FContinue  := True;
	FPropName  := APropName;
	Components.Add(Component);
	FPropEditor := nil;
	try
		GetComponentProperties(Components, tkAny, Designer, EnumPropertyEditors);
		if Assigned(FPropEditor) then
			FPropEditor.Edit;
	finally
		FPropEditor := nil;
	end;
end;

procedure TDefaultEditorEx.DesignerModified;
begin
	if Designer <> nil then
		Designer.Modified;
end;

function TDefaultEditorEx.AlignMenuIndex: Integer;
begin
	Result := - 1;
end;

function TDefaultEditorEx.MenuBitmapResourceName(Index: Integer): string;
begin
	Result := '';
end;

function TDefaultEditorEx.GetCompRefData(Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string; var CompRefMenuHandler: TNotifyEvent): Boolean;
begin
	Result := False;
end;

procedure TDefaultEditorEx.PrepareMenuItem(Index: Integer; const Item: TMenuItem);
var
	ResName           : string;
	I, CompRefCount   : Integer;
	CompOwner         : TComponent;
	CompRefClass      : TComponentClass;
	CompRefPropName   : string;
	CompRefMenuHandler: TNotifyEvent;

	procedure CreateAlignItem(AlignValue: TAlign; const Caption: string);
	var
		NewItem: TMenuItem;
	begin
		NewItem         := TMenuItem.Create(Item);
		NewItem.Caption := Caption;
		NewItem.Tag     := Ord(AlignValue);
		NewItem.Checked := TControl(Component).Align = AlignValue;
		case AlignValue of
			alNone:
			NewItem.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_NONE');
			alTop:
			NewItem.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_TOP');
			alBottom:
			NewItem.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_BOTTOM');
			alLeft:
			NewItem.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_LEFT');
			alRight:
			NewItem.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_RIGHT');
			alClient:
			NewItem.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN_CLIENT');
		end;
		NewItem.OnClick := AlignMenuHandler;
		Item.Add(NewItem);
	end;

	procedure CreateCompRefMenu(CompRef: TComponent; const CompRefPropName: string; CompRefMenuHandler: TNotifyEvent);
	var
		NewItem: TMenuItem;
	begin
		NewItem             := TMenuItem.Create(Item);
		NewItem.AutoHotkeys := maManual;
		NewItem.Caption     := CompRef.Name;
		NewItem.Checked     := GetObjectProp(Component, CompRefPropName) = CompRef;
		NewItem.OnClick     := CompRefMenuHandler;
		Item.Add(NewItem);
	end;

begin {= TvvDefaultEditor.PrepareMenuItem =}
      // Descendant classes override this method to consistently handle preparing
      // menu items in Delphi 5, Delphi 6 and higher.

	ResName := MenuBitmapResourceName(index);
	if ResName <> '' then
		Item.Bitmap.LoadFromResourceName(HInstance, ResName);

	if index = AlignMenuIndex then
	begin
		Item.Bitmap.LoadFromResourceName(HInstance, 'RZDESIGNEDITORS_ALIGN');

		CreateAlignItem(alClient, 'Client');
		CreateAlignItem(alLeft, 'Left');
		CreateAlignItem(alTop, 'Top');
		CreateAlignItem(alRight, 'Right');
		CreateAlignItem(alBottom, 'Bottom');
		CreateAlignItem(alNone, 'None');
	end;

	if GetCompRefData(index, CompRefClass, CompRefPropName, CompRefMenuHandler) then
	begin
		Item.AutoHotkeys := maManual;
		CompRefCount     := 0;
		CompOwner        := Designer.GetRoot;

		if not Assigned(CompRefMenuHandler) then
		begin
			if CompRefClass = TCustomImageList then
				CompRefMenuHandler := ImageListMenuHandler
			else
			  if CompRefClass = TRegIniFile.ClassInfo then
				CompRefMenuHandler := RegIniFileMenuHandler;
		end;

		if CompOwner <> nil then
		begin
			for I := 0 to CompOwner.ComponentCount - 1 do
			begin
				if CompOwner.Components[I] is CompRefClass then
				begin
					Inc(CompRefCount);
					CreateCompRefMenu(CompOwner.Components[I], CompRefPropName,
					  CompRefMenuHandler);
				end;
			end;
		end;
		Item.Enabled := CompRefCount > 0;
	end;

end;

procedure TDefaultEditorEx.PrepareItem(Index: Integer; const AItem: IMenuItem);
var
	CompRef : IInterfaceComponentReference;
	MenuItem: TMenuItem;
begin
	CompRef  := AItem as IInterfaceComponentReference;
	MenuItem := CompRef.GetComponent as TMenuItem;
	PrepareMenuItem(index, MenuItem);
end;

procedure TDefaultEditorEx.AlignMenuHandler(Sender: TObject);
begin
	TControl(Component).Align := TAlign(TMenuItem(Sender).Tag);
	DesignerModified;
end;

procedure TDefaultEditorEx.ImageListMenuHandler(Sender: TObject);
var
	S        : string;
	ImageList: TCustomImageList;
begin
	if Designer.GetRoot <> nil then
	begin
		S         := TMenuItem(Sender).Caption;
		ImageList := Designer.GetRoot.FindComponent(S) as TCustomImageList;
		SetObjectProp(Component, 'Images', ImageList);
		DesignerModified;
	end;
end;

procedure TDefaultEditorEx.RegIniFileMenuHandler(Sender: TObject);
var
	S         : string;
	RegIniFile: TRegIniFile;
begin
	if Designer.GetRoot <> nil then
	begin
		S          := TMenuItem(Sender).Caption;
		RegIniFile := TregIniFile(Designer.GetRoot.FindComponent(S));
		SetObjectProp(Component, 'RegIniFile', RegIniFile);
		DesignerModified;
	end;
end;

end.
