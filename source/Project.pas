unit Project;

interface

type
  TProject = class(TObject)
  private
    FName : String;
    FActivity : String;
    FLastBuildStatus : String;
    FLastBuildTime : String;
    FURL : String;
  public
    function Equals(proj : TProject) : boolean; reintroduce;
    constructor Create; overload;
    constructor Create(aName, aActivity, aBuildStatus, aBuildTime, aURL : String); overload;
    procedure Assign(aProject : TProject);
    property Name : String read FName write FName;
    property Activity : String read FActivity write FActivity;
    property LastBuildStatus : String read FLastBuildStatus write FLastBuildStatus;
    property LastBuildTime : String read FLastBuildTime write FLastBuildTime;
    property URL : String read FURL write FURL;
  end;

implementation

{ TProject }

procedure TProject.Assign(aProject: TProject);
begin
  FName            := aProject.Name;
  FActivity        := aProject.Activity;
  FLastBuildStatus := aProject.LastBuildStatus;
  FLastBuildTime   := aProject.LastBuildTime;
  FURL             := aProject.URL;
end;

constructor TProject.Create(aName, aActivity, aBuildStatus, aBuildTime,
  aURL: String);
begin
  inherited Create;
  FName := aName;
  FActivity := aActivity;
  FLastBuildStatus := aBuildStatus;
  FLastBuildTime := aBuildTime;
  FURL := aURL;
end;

constructor TProject.Create;
begin
  inherited;
  FName := 'Unnamed Project';
  FActivity := 'Sleeping';
  FLastBuildStatus := 'Success';
  FLastBuildTime := '1980-01-01T00:00:00.0000000+10:00';
  FURL := '';
end;

function TProject.Equals(proj: TProject): boolean;
begin
  Result := (proj.Name = FName) and
            (proj.Activity = FActivity) and
            (proj.LastBuildStatus = FLastBuildStatus) and
            (proj.LastBuildTime = FLastBuildTime) and
            (proj.URL = FURL);
end;

end.
