unit MsgWndConsoleApp;

interface

procedure Register;

implementation

uses
    Classes, SysUtils, WinAPi.Windows, ToolsApi, Dialogs;

type
    TSourceIndex = (siXPAppProject, siXPAppModule);

    { TMsgWndAppProjectCreator }
    TMsgWndAppProjectCreator = class(TInterfacedObject, IOTACreator, IOTAProjectCreator, IOTAProjectCreator50)
    public
        { IOTACreator }
        function GetCreatorType: string; virtual;
        function GetExisting: Boolean; virtual;
        function GetFileSystem: string; virtual;
        function GetOwner: IOTAModule; virtual;
        function GetUnnamed: Boolean; virtual;
        { IOTAProjectCreator }
        function GetFileName: string; virtual;
        function GetOptionFileName: string; virtual;
        function GetShowSource: Boolean; virtual;
        procedure NewDefaultModule; virtual;
        function NewOptionSource(const ProjectName: string): IOTAFile; virtual;
        procedure NewProjectResource(const Project: IOTAProject); virtual;
        function NewProjectSource(const ProjectName: string): IOTAFile; virtual;
        { IOTAProjectCreator50 }
        procedure NewDefaultProjectModule(const Project: IOTAProject); virtual;
    end;

    { TMsgWndAppProjectWizard }
    TMsgWndAppProjectWizard = class(TNotifierObject, IOTAWizard, IOTARepositoryWizard,
      IOTARepositoryWizard60, IOTARepositoryWizard80, IOTAProjectWizard)
    public
        function GetDesigner: string;
        function GetPersonality: string;
        function GetGalleryCategory: IOTAGalleryCategory;
        { IOTAWizard declarations }
        function GetIDString: string;
        function GetName: string;
        function GetState: TWizardState;
        procedure Execute;
        { IOTARepositoryWizard declarations }
        function GetAuthor: string;
        function GetComment: string;
        function GetPage: string;
        function GetGlyph: Cardinal;
    end;

    { TMsgWndProjectSource }
    TMsgWndProjectSource = class(TInterfacedObject, IOTAFile)
    private
        FProjectName: string;
    public
        constructor Create(const ProjectName: string);
        function GetAge: TDateTime;
        function GetSource: string;
    end;

{ TMsgWndAppProjectCreator }

function TMsgWndAppProjectCreator.GetCreatorType: string;
begin
    Result := sApplication;
end;

function TMsgWndAppProjectCreator.GetExisting: Boolean;
begin
    Result := False;
end;

function TMsgWndAppProjectCreator.GetFileName: string;
begin
    Result := '';
end;

function TMsgWndAppProjectCreator.GetFileSystem: string;
begin
    Result := '';
end;

function TMsgWndAppProjectCreator.GetOptionFileName: string;
begin
    Result := '';
end;

function TMsgWndAppProjectCreator.GetOwner: IOTAModule;
begin
    Result := nil;
end;

function TMsgWndAppProjectCreator.GetShowSource: Boolean;
begin
    Result := True;
end;

function TMsgWndAppProjectCreator.GetUnnamed: Boolean;
begin
    Result := True;
end;

procedure TMsgWndAppProjectCreator.NewDefaultModule;
begin

end;

procedure TMsgWndAppProjectCreator.NewDefaultProjectModule(const Project: IOTAProject);
begin

end;

function TMsgWndAppProjectCreator.NewOptionSource(const ProjectName: string): IOTAFile;
begin
    Result := nil;
end;

procedure TMsgWndAppProjectCreator.NewProjectResource(const Project: IOTAProject);
begin
end;

function TMsgWndAppProjectCreator.NewProjectSource(const ProjectName: string): IOTAFile;
begin
    Result := TMsgWndProjectSource.Create(ProjectName);
end;

{ TMsgWndAppProjectWizard }

function TMsgWndAppProjectWizard.GetAuthor: string;
begin
    Result := 'EvilWorks';
end;

function TMsgWndAppProjectWizard.GetDesigner: string;
begin
    Result := ToolsApi.dVCL;
end;

function TMsgWndAppProjectWizard.GetGalleryCategory: IOTAGalleryCategory;
begin
    Result := (BorlandIDEServices as IOTAGalleryCategoryManager).FindCategory(sCategoryDelphiNew);
end;

function TMsgWndAppProjectWizard.GetGlyph: Cardinal;
begin
    Result := LoadIcon(HInstance, 'MAINICON');
end;

function TMsgWndAppProjectWizard.GetPage: string;
begin
    Result := 'New';
end;

function TMsgWndAppProjectWizard.GetPersonality: string;
begin
    Result := ToolsApi.sDelphiPersonality;
end;

function TMsgWndAppProjectWizard.GetState: TWizardState;
begin
    Result := [wsEnabled];
end;

procedure TMsgWndAppProjectWizard.Execute;
begin
    (BorlandIDEServices as IOTAModuleServices).CreateModule(TMsgWndAppProjectCreator.Create);
end;

function TMsgWndAppProjectWizard.GetComment: string;
begin
    Result := 'Creates a new console application with a message loop.';
end;

function TMsgWndAppProjectWizard.GetIDString: string;
begin
    Result := 'EvilWorks.MsgWndConsoleApp';
end;

function TMsgWndAppProjectWizard.GetName: string;
begin
    Result := 'Message Window Console App';
end;

procedure Register;
begin
    RegisterPackageWizard(TMsgWndAppProjectWizard.Create);
end;

{ TMsgWndProjectSource }

constructor TMsgWndProjectSource.Create(const ProjectName: string);
begin
    FProjectName := ProjectName;
end;

function TMsgWndProjectSource.GetAge: TDateTime;
begin
    Result := -1;
end;

function TMsgWndProjectSource.GetSource: string;
{$I MsgWndConsoleAppCode.inc}
begin
    Result := Format(ProjectSource, [FProjectName, FProjectName]);
end;

end.
