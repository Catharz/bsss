unit ScreenSaverForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Contnrs, ProjectList;

type
  TfrmScreenSaver = class(TForm)
    tmrAnimate: TTimer;
    tmrUpdate: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure tmrAnimateTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tmrUpdateTimer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    labelList : TObjectList;
    projList : TProjectList;
    FFileName : String;
    FUpdateFrequency : Integer;
    FAnimationFrequency : Integer;
    procedure SetAnimationFrequency(const Value: Integer);
    procedure SetUpdateFrequency(const Value: Integer);
  public
    { Public declarations }
    property FileName : String read FFileName write FFileName;
    property UpdateFrequency : Integer read FUpdateFrequency write SetUpdateFrequency;
    property AnimationFrequency : Integer read FAnimationFrequency write SetAnimationFrequency;
    procedure UpdateProjectStatus;
    procedure Animate;
  end;

var
  frmScreenSaver: TfrmScreenSaver;

implementation

uses
  StdCtrls, Project;

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
    tmpLabel.Top := random(Height - tmpLabel.Height);
    tmpLabel.Left := random(Width - tmpLabel.Width);
  end;
  tmrAnimate.Enabled := True;
end;

//TODO: Make this work with screens of any size in any arrangement.
procedure TfrmScreenSaver.FormActivate(Sender: TObject);
var
  iCounter, iTotalWidth, iMaxHeight : Integer;
begin
  Top := 0;
  Left := 0;
  iMaxHeight := 0;
  iTotalWidth := 0;
  for iCounter := 0 to Screen.MonitorCount - 1 do
  begin
    if Screen.Monitors[iCounter].Height > iMaxHeight then
      iMaxHeight := Screen.Monitors[iCounter].Height;
    iTotalWidth := iTotalWidth + Screen.Monitors[iCounter].Width;
  end;
  Width := iTotalWidth;
  Height := iMaxHeight;
end;

procedure TfrmScreenSaver.tmrAnimateTimer(Sender: TObject);
begin
  Animate;
end;

procedure TfrmScreenSaver.tmrUpdateTimer(Sender: TObject);
begin
  UpdateProjectStatus;
end;

procedure TfrmScreenSaver.FormCreate(Sender: TObject);
begin
  inherited;
  ShowCursor(False);
  labelList := TObjectList.Create(True);
  projList := TProjectList.Create;
end;

procedure TfrmScreenSaver.FormDestroy(Sender: TObject);
begin
  FreeAndNil(projList);
  FreeAndNil(labelList);
  ShowCursor(True);
  inherited;
end;

procedure TfrmScreenSaver.UpdateProjectStatus;
var
  iCounter : Integer;
  tmpLabel : TLabel;
begin
  tmrUpdate.Enabled := False;
  //Remove all the labels
  while labelList.Count > 0 do
  begin
    tmpLabel := TLabel(labelList.Items[0]);
    labelList.Remove(tmpLabel);
  end;
  labelList.Clear;

  //Clear out the projects
  projList.Clear;
  projList.loadFromFile(FFileName);

  //Create the labels
  for iCounter := 0 to projList.Count - 1 do
  begin
    tmpLabel := TLabel.Create(self);
    tmpLabel.Caption := TProject(projList[iCounter]).Name;
    tmpLabel.Font.Name := 'Ariel';
    if TProject(projList[iCounter]).Activity = 'Building' then
    begin
      if TProject(projList[iCounter]).lastBuildStatus = 'Success' then
        tmpLabel.Font.Color := clYellow
      else
        tmpLabel.Font.Color := clWebOrangeRed;
      tmpLabel.Font.Style := [fsItalic];
    end
    else
    begin
      if TProject(projList[iCounter]).lastBuildStatus = 'Success' then
        tmpLabel.Font.Color := clGreen
      else
        tmpLabel.Font.Color := clRed;
      tmpLabel.Font.Style := [];
    end;
    tmpLabel.Font.Size := 32;
    tmpLabel.Transparent := True;
    tmpLabel.Parent := Self;
    tmpLabel.Visible := True;
    labelList.Add(tmpLabel);
  end;
  tmrUpdate.Enabled := True;
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

procedure TfrmScreenSaver.SetAnimationFrequency(const Value: Integer);
begin
  FAnimationFrequency := Value;
  tmrAnimate.Interval := Value * 1000; //Convert to seconds
end;

procedure TfrmScreenSaver.SetUpdateFrequency(const Value: Integer);
begin
  FUpdateFrequency := Value;
  tmrUpdate.Interval := Value + 60000; //Convert to minutes
end;

end.
