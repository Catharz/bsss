unit ScreenSaverForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, StdCtrls, Forms,
  Dialogs, ExtCtrls, Contnrs,
  Project, ProjectList;

type
  TfrmScreenSaver = class(TForm)
    tmrAnimate: TTimer;
    procedure tmrAnimateTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    fMonitor : TMonitor;
    labelList : TObjectList;
    FAnimationFrequency : Integer;
    procedure SetAnimationFrequency(const Value: Integer);
    procedure SetMonitor(const Value: TMonitor);
    procedure ClearLabels;
    procedure ConfigureLabel(var tmpLabel: TLabel; tmpProject: TProject);
  public
    { Public declarations }
    property Monitor : TMonitor read fMonitor write SetMonitor;
    property AnimationFrequency : Integer read FAnimationFrequency write SetAnimationFrequency;
    procedure PlaceLabel(aLabel : TLabel);
    function NewControlWillOverlap(newControl : TControl; controlList : TList) : Boolean;
    procedure UpdateProjects(projectList : TProjectList);
    procedure Animate;
  end;

var
  frmScreenSaver: TfrmScreenSaver;

implementation

{$R *.dfm}

uses
  ScreenSaverController, FontList;

procedure TfrmScreenSaver.Animate;
var
  i : Integer;
  tmpLabel : TLabel;
begin
  tmrAnimate.Enabled := False;
  for I := 0 to labelList.Count - 1 do
  begin
    tmpLabel := TLabel(labelList.Items[I]);
    PlaceLabel(tmpLabel);
  end;
  tmrAnimate.Enabled := True;
end;

procedure TfrmScreenSaver.ConfigureLabel(var tmpLabel: TLabel; tmpProject: TProject);
begin
  tmpLabel.Caption := tmpProject.Name;
  tmpLabel.Font.Assign(dmController.Config.FontList.Font[tmpProject.Activity, tmpProject.BuildStatus]);
  tmpLabel.AutoSize := True;
  tmpLabel.Transparent := True;
  tmpLabel.Parent := Self;
end;

procedure TfrmScreenSaver.ClearLabels;
begin
  labelList.Clear;
end;

procedure TfrmScreenSaver.tmrAnimateTimer(Sender: TObject);
begin
  Animate;
end;

procedure TfrmScreenSaver.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmScreenSaver.FormCreate(Sender: TObject);
begin
  inherited;
  ShowCursor(False);
  labelList := TObjectList.Create(True);
end;

procedure TfrmScreenSaver.FormDestroy(Sender: TObject);
begin
  FreeAndNil(labelList);
  ShowCursor(True);
  inherited;
end;

procedure TfrmScreenSaver.UpdateProjects(projectList: TProjectList);
var
  iCounter : Integer;
  tmpLabel : TLabel;
  tmpProject : TProject;
begin
  ClearLabels;

  //Create the labels
  for iCounter := 0 to projectList.Count - 1 do
  begin
    tmpProject := TProject(projectList[iCounter]);
    tmpLabel := TLabel.Create(self);
    ConfigureLabel(tmpLabel, tmpProject);
    PlaceLabel(tmpLabel);
    tmpLabel.Visible := True;
    labelList.Add(tmpLabel);
  end;
end;

procedure TfrmScreenSaver.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Application.Terminate;
end;

procedure TfrmScreenSaver.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Application.Terminate;
end;

function TfrmScreenSaver.NewControlWillOverlap(newControl: TControl;
  controlList: TList): Boolean;
var
  i : Integer;
  oldControl : TControl;
  newRect, oldRect : TRect;
begin
  newRect := newControl.BoundsRect;
  for I := 0 to controlList.Count - 1 do
  begin
    oldControl := TControl(controlList.Items[i]);
    if newControl = oldControl then
      Continue;
    oldRect := oldControl.BoundsRect;
    if not ((newRect.Top > oldRect.Bottom) or
        (newRect.Left > oldRect.Right) or
        (newRect.Bottom < oldRect.Top) or
        (newRect.Right < oldRect.Left)) then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

procedure TfrmScreenSaver.PlaceLabel(aLabel: TLabel);
var
  iTries : Integer;
begin
  iTries := 0;
  while True do
  begin
    aLabel.Top := random(Height - aLabel.Height);
    aLabel.Left := random(Width - aLabel.Width);
    if not NewControlWillOverlap(aLabel, labelList) then
      Break
    else
      //If it takes more than 100 tries to find a clear spot, then just overlap
      if (iTries > 100) then
        Break;
    inc(iTries);
  end;
end;

procedure TfrmScreenSaver.SetAnimationFrequency(const Value: Integer);
begin
  FAnimationFrequency := Value;
  tmrAnimate.Interval := Value * 1000; //Convert to seconds
end;

procedure TfrmScreenSaver.SetMonitor(const Value: TMonitor);
begin
  fMonitor := Value;
  top := fMonitor.Top;
  left := fMonitor.Left;
  width := fMonitor.Width;
  height := fMonitor.Height;
end;

end.
