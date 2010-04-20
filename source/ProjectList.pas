unit ProjectList;

interface

uses
  Contnrs, Classes, Project, ScreenSaverConfig;

type
  TProjectList = class(TObject)
    FObjectList : TObjectList;
    FConfig : TScreenSaverConfig;
  private
    function GetCount: Integer;
  protected
    function GetItem(Index: Integer): TProject;
    procedure SetItem(Index: Integer; const Value: TProject);
  public
    constructor Create(config : TScreenSaverConfig); overload;
    destructor Destroy; override;
    function Add(buildProject : TProject) : Integer;
    function Remove(proj: TProject): Integer;
    function IndexOf(proj: TProject): Integer;
    procedure Clear;

    property Count : Integer read GetCount;
    property Items[Index: Integer]: TProject read GetItem write SetItem; default;
  end;

implementation

uses
  SysUtils,
  OmniXML,
  WinInet,
  Types,
  Forms,
  Dialogs;

{ TProjectList }

function TProjectList.Add(buildProject: TProject): Integer;
begin
  Result := FObjectList.Add(buildProject);
end;

procedure TProjectList.Clear;
begin
  while FObjectList.Count > 0 do
    FObjectList.Remove(FObjectList.Items[0]);
end;

constructor TProjectList.Create(config : TScreenSaverConfig);
begin
  inherited Create;
  FObjectList := TObjectList.Create(True);
  FConfig := config;
end;

destructor TProjectList.Destroy;
begin
  Clear;
  FreeAndNil(FObjectList);
  inherited;
end;

function TProjectList.GetCount: Integer;
begin
  if (FObjectList = nil) then
    Result := 0
  else
    Result := FObjectList.Count;
end;

function TProjectList.GetItem(Index: Integer): TProject;
begin
  Result := TProject(FObjectList.Items[Index]);
end;

function TProjectList.IndexOf(proj: TProject): Integer;
var
  iTemp : Integer;
  bFound : Boolean;
begin
  bFound := False;
  for iTemp := 0 to FObjectList.Count - 1 do
    if (TProject(FObjectList[iTemp]).Name = proj.Name) then
    begin
      bFound := True;
      break;
    end;

  if bFound then
    Result := iTemp
  else
    Result := -1;
end;

function TProjectList.Remove(proj: TProject): Integer;
begin
  Result := FObjectList.Remove(proj);
end;

procedure TProjectList.SetItem(Index: Integer; const Value: TProject);
begin
  FObjectList.Items[Index] := Value;
end;

end.
