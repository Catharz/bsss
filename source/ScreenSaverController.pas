unit ScreenSaverController;

interface

uses
  SysUtils, Classes, ExtCtrls, Forms, Contnrs,
  ProjectList, ScreenSaverForm, ScreenSaverConfig, BuildResultsFile, RegistryDAO;

type
  TdmController = class(TDataModule)
    tmrUpdate: TTimer;
    procedure tmrUpdateTimer(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FSettingsDAO : TRegistryDAO;
    FConfig : TScreenSaverConfig;
    fScreenList : TObjectList;
    fProjectList : TProjectList;
    fBuildResultsFile : TBuildResultsFile;
    procedure ReadProjectStatus;
    procedure UpdateProjectLabels;
    procedure SetupScreen(form: TfrmScreenSaver; monitor: TMonitor; animationFrequency: Integer; projectList: TProjectList);
    procedure SetConfig(const Value: TScreenSaverConfig);
  public
    { Public declarations }
    property Config : TScreenSaverConfig read fConfig write SetConfig;
    property ProjectList : TProjectList read fProjectList write fProjectList;
    procedure StartScreenSaver(var AScreenList : TObjectList);
  end;

var
  dmController: TdmController;

implementation

{$R *.dfm}

uses
  Dialogs;

procedure TdmController.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FSettingsDAO := TRegistryDAO.Create;
  fConfig := TScreenSaverConfig.Create(FSettingsDAO);
  if not fConfig.LoadConfig then
  begin
    MessageDlg('Could not load registry settings for screen saver!', mtError, [mbOk], 0);
    Application.Terminate;
  end;
  fProjectList := TProjectList.Create(fConfig);
  fBuildResultsFile := TBuildResultsFile.Create(fConfig);
end;

procedure TdmController.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(fBuildResultsFile);
  FreeAndNil(fProjectList);
  FSettingsDAO := nil;
  FreeAndNil(fConfig);
  inherited;
end;

procedure TdmController.ReadProjectStatus;
begin
  fProjectList.Clear;
  FreeAndNil(fProjectList);
  fProjectList := TProjectList.Create(fConfig);
  fBuildResultsFile.Load(config.XmlFileURL, fProjectList);
end;

procedure TdmController.SetConfig(const Value: TScreenSaverConfig);
begin
  fConfig.Assign(Value);
  tmrUpdate.Interval := fConfig.UpdateFrequency * 60000; //Convert to minutes
end;

procedure TdmController.StartScreenSaver(var AScreenList : TObjectList);
var
  i : Integer;
  tempForm : TfrmScreenSaver;
begin
  ReadProjectStatus;

  //Add the first (existing) screen to the list
  Application.CreateForm(TfrmScreenSaver, frmScreenSaver);
  fScreenList := AScreenList;
  SetupScreen(frmScreenSaver, Screen.Monitors[0], fConfig.AnimationFrequency, fProjectList);

  //Setup subsequent screens
  for i := 1 to Screen.MonitorCount - 1 do
  begin
    tempForm := TfrmScreenSaver.Create(Application);
    SetupScreen(tempForm, Screen.Monitors[i], fConfig.AnimationFrequency, fProjectList);
  end;
  tmrUpdate.Enabled := True;
end;

procedure TdmController.SetupScreen(form: TfrmScreenSaver; monitor: TMonitor; animationFrequency: Integer; projectList: TProjectList);
begin
  fScreenList.Add(form);
  form.AnimationFrequency := animationFrequency;
  form.UpdateProjects(projectList);
  form.Show;
  form.Monitor := monitor;
  form.Animate;
end;

procedure TdmController.tmrUpdateTimer(Sender: TObject);
begin
  tmrUpdate.Enabled := False;
  UpdateProjectLabels;
  tmrUpdate.Enabled := True;
end;

procedure TdmController.UpdateProjectLabels;
var
  i : Integer;
begin
  ReadProjectStatus;
  for i := 0 to fScreenList.Count - 1 do
    TfrmScreenSaver(fScreenList.Items[i]).UpdateProjects(fProjectList);
end;

end.
