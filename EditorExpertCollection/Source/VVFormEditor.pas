unit VVFormEditor;

interface

uses
  Menus, DesignIntf, DesignEditors, DesignMenus, VVDesignEditors, Controls, Forms, StdCtrls, ExtCtrls;

type
  TvvFormEditor = class(TvvDefaultEditor)
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

function TvvFormEditor.Control: TControl;
begin
  Result := Component as TForm;
end;

function TvvFormEditor.GetVerb(Index: integer): string;

begin
  if Index = 0 then
  begin
    Result := 'Add Control';
  end;
end;

function TvvFormEditor.GetVerbCount: integer;
begin
  Result := 1;
end;

procedure TvvFormEditor.ExecuteVerb(Index: integer);
begin
 //
end;

procedure TvvFormEditor.PrepareItem(Index: Integer; const AItem: IMenuItem);

  procedure CreateItem(Control: integer; const Caption: string );
  begin
    with AItem.AddItem(Caption, 0, False, True, OnClick) do
      Tag := Control;
  end;

begin
  if Index = 0 then
  begin
    CreateItem(0, 'Panel');
  end;
end;

procedure TvvFormEditor.OnClick(Sender: TObject);
begin
  case TMenuItem(Sender).Tag of
    0: TPanel.Create(Control);
  end;

  Designer.Modified;
end;


end.
