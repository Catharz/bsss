unit ScreenSaverForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, StdCtrls, Forms,
  Dialogs, ExtCtrls, Contnrs, ProjectList;

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
  private
    { Private declarations }
    fMonitor : TMonitor;
    labelList : TObjectList;
    FAnimationFrequency : Integer;
    procedure SetAnimationFrequency(const Value: Integer);
    procedure SetMonitor(const Value: TMonitor);
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

uses
  Project;

{$R *.dfm}

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

procedure TfrmScreenSaver.tmrAnimateTimer(Sender: TObject);
begin
  Animate;
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
begin
  //Remove all the labels
  while labelList.Count > 0 do
  begin
    tmpLabel := TLabel(labelList.Items[0]);
    labelList.Remove(tmpLabel);
  end;
  labelList.Clear;

  //Create the labels
  for iCounter := 0 to projectList.Count - 1 do
  begin
    tmpLabel := TLabel.Create(self);
    tmpLabel.Caption := TProject(projectList[iCounter]).Name;
    tmpLabel.Font.Name := 'Ariel';
    if TProject(projectList[iCounter]).Activity = 'Building' then
    begin
      if TProject(projectList[iCounter]).lastBuildStatus = 'Success' then
        tmpLabel.Font.Color := clYellow
      else
        tmpLabel.Font.Color := clPurple;
      tmpLabel.Font.Style := [fsItalic];
    end
    else
    begin
      if TProject(projectList[iCounter]).lastBuildStatus = 'Success' then
        tmpLabel.Font.Color := clGreen
      else
        tmpLabel.Font.Color := clRed;
      tmpLabel.Font.Style := [];
    end;
    tmpLabel.Font.Size := 32;
    tmpLabel.AutoSize := True;
    tmpLabel.Transparent := True;
    tmpLabel.Parent := Self;
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
begin
  while True do
  begin
    aLabel.Top := random(Height - aLabel.Height);
    aLabel.Left := random(Width - aLabel.Width);
    if not NewControlWillOverlap(aLabel, labelList) then
      Break;
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
