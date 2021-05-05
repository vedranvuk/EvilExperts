unit VVDesignEditors;

interface

uses
  DesignIntf,
  DesignEditors,
  VCLEditors,
  DesignMenus,
  Menus,
  Windows,
  Classes,
  Graphics;

type
  {==========================================}
  {== TvvComponentEditor Class Declaration ==}
  {==========================================}

  TvvComponentEditor = class(TComponentEditor)
  private
    FPropName:   string;
    FContinue:   boolean;
    FPropEditor: IProperty;
    procedure EnumPropertyEditors(const PropertyEditor: IProperty);
    procedure TestPropertyEditor(const PropertyEditor: IProperty; var Continue: boolean);
  protected
    procedure EditPropertyByName(const APropName: string);
  end;


  {========================================}
  {== TvvDefaultEditor Class Declaration ==}
  {========================================}

  TvvDefaultEditor = class(TDefaultEditor)
  private
    FPropName:   string;
    FContinue:   boolean;
    FPropEditor: IProperty;
    procedure EnumPropertyEditors(const PropertyEditor: IProperty);
    procedure TestPropertyEditor(const PropertyEditor: IProperty; var Continue: boolean);
  protected
    procedure EditPropertyByName(const APropName: string);
  end;


{== Category Classes ================================================================================================}


resourcestring
  sRkGlyphCategoryName = 'Glyph';
  sRkBorderStyleName   = 'Border Style';

implementation

uses
  SysUtils,
  TypInfo;


{== Base Component Editors ============================================================================================}

 {==============================}
 {== TvvDefaultEditor Methods ==}
 {==============================}

procedure TvvComponentEditor.EnumPropertyEditors(const PropertyEditor: IProperty);
begin
  if FContinue then
    TestPropertyEditor(PropertyEditor, FContinue);
end;


procedure TvvComponentEditor.TestPropertyEditor(const PropertyEditor: IProperty; var Continue: boolean);
begin
  if not Assigned(FPropEditor) and
    (CompareText(PropertyEditor.GetName, FPropName) = 0) then
  begin
    Continue    := False;
    FPropEditor := PropertyEditor;
  end;
end;


procedure TvvComponentEditor.EditPropertyByName(const APropName: string);
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


 {==============================}
 {== TvvDefaultEditor Methods ==}
 {==============================}

procedure TvvDefaultEditor.EnumPropertyEditors(const PropertyEditor: IProperty);
begin
  if FContinue then
    TestPropertyEditor(PropertyEditor, FContinue);
end;


procedure TvvDefaultEditor.TestPropertyEditor(const PropertyEditor: IProperty; var Continue: boolean);
begin
  if not Assigned(FPropEditor) and
    (CompareText(PropertyEditor.GetName, FPropName) = 0) then
  begin
    Continue    := False;
    FPropEditor := PropertyEditor;
  end;
end;


procedure TvvDefaultEditor.EditPropertyByName(const APropName: string);
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


end.
