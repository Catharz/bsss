unit ScreenSaverController;

interface

uses
  SysUtils, Classes, ExtCtrls, Forms, Contnrs,
  ProjectList, ScreenSaverForm, ScreenSaverConfig;

type
  TdmScreenSaverController = class(TDataModule)
    tmrUpdate: TTimer;
    procedure tmrUpdateTimer(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FConfig : TScreenSaverConfig;
    fScreenList : TObjectList;
    fProjectList : TProjectList;
    procedure ReadProjectStatus;
    procedure UpdateProjectLabels;
    procedure SetupScreen(form: TfrmScreenSaver; monitor: TMonitor; animationFrequency: Integer; projectList: TProjectList);
    procedure SetConfig(const Value: TScreenSaverConfig);
  public
    { Public declarations }
    property Config : TScreenSaverConfig read fConfig write SetConfig;
    property ProjectList : TProjectList read fProjectList write fProjectList;
    procedure StartScreenSaver;
  end;

var
  dmScreenSaverController: TdmScreenSaverController;

implementation

{$R *.dfm}

uses
  Dialogs;

procedure TdmScreenSaverController.DataModuleCreate(Sender: TObject);
begin
  inherited;
  fProjectList := TProjectList.Create;
  fConfig := TScreenSaverConfig.Create;
  if not fConfig.LoadConfig then
  begin
    MessageDlg('Could not load registry settings for screen saver!', mtError, [mbOk], 0);
    Application.Terminate;
  end;
end;

procedure TdmScreenSaverController.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(fConfig);
  FreeAndNil(fProjectList);
  inherited;
end;

procedure TdmScreenSaverController.ReadProjectStatus;
begin
  fProjectList.Clear;
  fProjectList.loadFromFile(config.XmlFileURL);
end;

procedure TdmScreenSaverController.SetConfig(const Value: TScreenSaverConfig);
begin
  fConfig.Assign(Value);
  tmrUpdate.Interval := fConfig.UpdateFrequency * 60000; //Convert to minutes
end;

procedure TdmScreenSaverController.StartScreenSaver;
var
  i : Integer;
  tempForm : TfrmScreenSaver;
begin
  ReadProjectStatus;
  fScreenList := TObjectList.Create;
  //Add the first (existing) screen to the list
  Application.CreateForm(TfrmScreenSaver, frmScreenSaver);
  SetupScreen(frmScreenSaver, Screen.Monitors[0], fConfig.AnimationFrequency, fProjectList);
  //Setup subsequent screens
  for i := 1 to Screen.MonitorCount - 1 do
  begin
    tempForm := TfrmScreenSaver.Create(Application);
    SetupScreen(tempForm, Screen.Monitors[i], fConfig.AnimationFrequency, fProjectList);
  end;
  tmrUpdate.Enabled := True;
end;

procedure TdmScreenSaverController.SetupScreen(form: TfrmScreenSaver; monitor: TMonitor; animationFrequency: Integer; projectList: TProjectList);
begin
  fScreenList.Add(form);
  frmScreenSaver.Monitor := monitor;
  frmScreenSaver.AnimationFrequency := animationFrequency;
  frmScreenSaver.UpdateProjects(projectList);
  frmScreenSaver.Show;
  frmScreenSaver.Animate;
end;

procedure TdmScreenSaverController.tmrUpdateTimer(Sender: TObject);
begin
  tmrUpdate.Enabled := False;
  UpdateProjectLabels;
  tmrUpdate.Enabled := True;
end;

procedure TdmScreenSaverController.UpdateProjectLabels;
var
  i : Integer;
begin
  ReadProjectStatus;
  for i := 0 to fScreenList.Count - 1 do
    TfrmScreenSaver(fScreenList.Items[i]).UpdateProjects(fProjectList);
end;

end.