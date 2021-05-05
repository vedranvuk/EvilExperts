unit VVListBoxEditor;

interface

uses
  Menus,
  DesignIntf,
  DesignEditors,
  DesignMenus,
  VVDesignEditors,
  StdCtrls;

type
  TvvListBoxEditor = class(TvvDefaultEditor)
  protected
    function ListBox: TListBox; virtual;
  public
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure PrepareItem(Index: integer; const AItem: IMenuItem); override;
    procedure ExecuteVerb(Index: integer); override;

    procedure ColumnsMenuHandler(Sender: TObject);
  end;


implementation

uses
  Controls,
  Forms,
  Variants;


 {==============================}
 {== TvvListBoxEditor Methods ==}
 {==============================}

function TvvListBoxEditor.ListBox: TListBox;
begin
  // Helper function to provide quick access to component being edited.
  // Also makes sure Component is a TListBox
  Result := Component as TListBox;
end;


function TvvListBoxEditor.GetVerbCount: integer;
begin
  { Return the number of new menu items to display }
  Result := 5;
end;


function TvvListBoxEditor.GetVerb(Index: integer): string;
begin
  { Menu item caption for context menu }
  case Index of
    0: Result := 'Edit Items...';
    1: Result := '-';
    2: Result := 'Sorted';
    3: Result := 'MultiSelect';
    4: Result := 'Columns';
  end;
end;


procedure TvvListBoxEditor.PrepareItem(Index: integer; const AItem: IMenuItem);

  procedure CreateColumnItem(Col: integer; const Caption: string);
  var
    NewItem: IMenuItem;
  begin
    NewItem     := AItem.AddItem(Caption, 0, ListBox.Columns = Col, True, ColumnsMenuHandler);
    NewItem.Tag := Col;
  end;

begin
  case Index of
    2:
      AItem.Checked := ListBox.Sorted;

    3:
      AItem.Checked := ListBox.MultiSelect;

    4:
    begin
      CreateColumnItem(0, 'None');
      CreateColumnItem(1, '1 - One');
      CreateColumnItem(2, '2 - Two');
      CreateColumnItem(3, '3 - Three');
    end;
  end;
end;


procedure TvvListBoxEditor.ExecuteVerb(Index: integer);
begin
  case Index of
    0:
      EditPropertyByName('Items');

    2:
    begin
      ListBox.Sorted := not ListBox.Sorted;
      Designer.Modified;
    end;

    3:
    begin
      ListBox.MultiSelect := not ListBox.MultiSelect;
      Designer.Modified;
    end;
  end;
end;


procedure TvvListBoxEditor.ColumnsMenuHandler(Sender: TObject);
var
  Col: integer;
begin
  Col := TMenuItem(Sender).Tag;
  case Col of
    0: ListBox.Columns := 0;
    1: ListBox.Columns := 1;
    2: ListBox.Columns := 2;
    3: ListBox.Columns := 3;
  end;

  Designer.Modified;
end;

end.
