unit Project;

interface

type
  TProject = class(TObject)
  private
    FName : String;
    FActivity : String;
    FBuildStatus : String;
    FBuildLabel : String;
    FBuildTime : String;
    FURL : String;
  public
    function Equals(proj : TProject) : boolean; reintroduce;
    constructor Create; overload;
    constructor Create(aName, aActivity, aBuildStatus, aBuildLabel, aBuildTime, aURL : String); overload;
    procedure Assign(aProject : TProject);
    property Name : String read FName write FName;
    property Activity : String read FActivity write FActivity;
    property BuildStatus : String read FBuildStatus write FBuildStatus;
    property BuildLabel : String read FBuildLabel write FBuildLabel;
    property BuildTime : String read FBuildTime write FBuildTime;
    property URL : String read FURL write FURL;
  end;

implementation

{ TProject }

procedure TProject.Assign(aProject: TProject);
begin
  FName        := aProject.Name;
  FActivity    := aProject.Activity;
  FBuildStatus := aProject.BuildStatus;
  FBuildLabel  := aProject.BuildLabel;
  FBuildTime   := aProject.BuildTime;
  FURL         := aProject.URL;
end;

constructor TProject.Create(aName, aActivity, aBuildStatus, aBuildLabel, aBuildTime,
  aURL: String);
begin
  inherited Create;
  FName        := aName;
  FActivity    := aActivity;
  FBuildStatus := aBuildStatus;
  FBuildLabel  := aBuildLabel;
  FBuildTime   := aBuildTime;
  FURL         := aURL;
end;

constructor TProject.Create;
begin
  inherited;
  FName        := 'Unnamed Project';
  FActivity    := 'Sleeping';
  FBuildStatus := 'Success';
  FBuildLabel  := '0';
  FBuildTime   := '1980-01-01T00:00:00.0000000+10:00';
  FURL         := '';
end;

function TProject.Equals(proj: TProject): boolean;
begin
  Result := (proj.Name = FName) and
            (proj.Activity = FActivity) and
            (proj.BuildStatus = FBuildStatus) and
            (proj.BuildLabel = FBuildLabel) and
            (proj.BuildTime = FBuildTime) and
            (proj.URL = FURL);
end;

end.
