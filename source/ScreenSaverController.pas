unit ScreenSaverController;

interface

uses
  SysUtils, Classes, ExtCtrls, Forms, Contnrs, ProjectList, ScreenSaverForm;

type
  TdmScreenSaverController = class(TDataModule)
    tmrUpdate: TTimer;
    procedure tmrUpdateTimer(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FFileName : String;
    fScreenList : TObjectList;
    fProjectList : TProjectList;
    fUpdateFrequency, fAnimationFrequency : Integer;
    procedure ReadProjectStatus;
    procedure UpdateProjectLabels;
    procedure SetUpdateFrequency(const Value: Integer);
    procedure SetupScreen(form: TfrmScreenSaver; monitor: TMonitor; animationFrequency: Integer; projectList: TProjectList);
  public
    { Public declarations }
    property FileName : String read FFileName write FFileName;
    property UpdateFrequency : Integer read fUpdateFrequency write SetUpdateFrequency;
    property AnimationFrequency : Integer read fAnimationFrequency write fAnimationFrequency;
    property ProjectList : TProjectList read fProjectList write fProjectList;
    procedure StartScreenSaver;
  end;

var
  dmScreenSaverController: TdmScreenSaverController;

implementation

{$R *.dfm}

procedure TdmScreenSaverController.DataModuleCreate(Sender: TObject);
begin
  inherited;
  fProjectList := TProjectList.Create;
end;

procedure TdmScreenSaverController.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(fProjectList);
  inherited;
end;

procedure TdmScreenSaverController.ReadProjectStatus;
begin
  fProjectList.Clear;
  fProjectList.loadFromFile(fFileName);
end;

procedure TdmScreenSaverController.SetUpdateFrequency(const Value: Integer);
begin
  fUpdateFrequency := Value;
  tmrUpdate.Interval := Value + 60000; //Convert to minutes
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
  SetupScreen(frmScreenSaver, Screen.Monitors[0], fAnimationFrequency, fProjectList);
  //Setup subsequent screens
  for i := 1 to Screen.MonitorCount - 1 do
  begin
    tempForm := TfrmScreenSaver.Create(Application);
    SetupScreen(tempForm, Screen.Monitors[i], fAnimationFrequency, fProjectList);
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
