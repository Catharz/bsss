unit ProjectTests;

interface

uses
  Windows, SysUtils, Classes, TestFramework, TestExtensions;

type
  TProjectTests = class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;

  published
    procedure TestCreate;
    procedure TestEquals;
    procedure TestAssign;
  end;

implementation

uses
  Project;

var
  FProject : TProject;

const
  PROJECT_NAME         = 'SAMS';
  PROJECT_ACTIVITY     = 'Sleeping';
  PROJECT_BUILD_STATUS = 'Success';
  PROJECT_BUILD_LABEL  = '0';
  PROJECT_BUILD_TIME   = '2010-03-24T12:30:52.4960000+10:00';
  PROJECT_URL          = 'http://asiscontint1.awmltd.com.au/FBServer6/BuildLog.aspx?ProjectName=SAMS 5.8.20 (Test Coverage)&amp;BuildID=Latest&amp;Filter=Auto&amp;Tab=Log';

procedure TProjectTests.Setup;
begin
  inherited;
  FProject := TProject.Create(
    PROJECT_NAME,
    PROJECT_ACTIVITY,
    PROJECT_BUILD_STATUS,
    PROJECT_BUILD_LABEL,
    PROJECT_BUILD_TIME,
    PROJECT_URL);
end;

procedure TProjectTests.TearDown;
begin
  FreeAndNil(FProject);
  inherited;
end;

procedure TProjectTests.TestAssign;
var
  tmpProject : TProject;
begin
  //arrange
  tmpProject := TProject.Create;

  //act
  tmpProject.Assign(FProject);

  //assert
  try
    CheckEquals(PROJECT_NAME,         tmpProject.Name);
    CheckEquals(PROJECT_ACTIVITY,     tmpProject.Activity);
    CheckEquals(PROJECT_BUILD_STATUS, tmpProject.BuildStatus);
    CheckEquals(PROJECT_BUILD_LABEL,  tmpProject.BuildLabel);
    CheckEquals(PROJECT_BUILD_TIME,   tmpProject.BuildTime);
    CheckEquals(PROJECT_URL,          tmpProject.URL);
  finally
    FreeAndNil(tmpProject);
  end;
  CheckNull(tmpProject);
end;

procedure TProjectTests.TestCreate;
var
  tmpProject : TProject;
begin
  //arrange
  //act
  tmpProject := TProject.Create(
    PROJECT_NAME,
    PROJECT_ACTIVITY,
    PROJECT_BUILD_STATUS,
    PROJECT_BUILD_LABEL,
    PROJECT_BUILD_TIME,
    PROJECT_URL);

  //assert
  try
    CheckEquals(PROJECT_NAME,         tmpProject.Name);
    CheckEquals(PROJECT_ACTIVITY,     tmpProject.Activity);
    CheckEquals(PROJECT_BUILD_STATUS, tmpProject.BuildStatus);
    CheckEquals(PROJECT_BUILD_LABEL,  tmpProject.BuildLabel);
    CheckEquals(PROJECT_BUILD_TIME,   tmpProject.BuildTime);
    CheckEquals(PROJECT_URL,          tmpProject.URL);
  finally
    FreeAndNil(tmpProject);
  end;
  CheckNull(tmpProject);
end;

procedure TProjectTests.TestEquals;
var
  tmpProject : TProject;
begin
  //arrange
  //act
  tmpProject := TProject.Create(
    PROJECT_NAME,
    PROJECT_ACTIVITY,
    PROJECT_BUILD_STATUS,
    PROJECT_BUILD_LABEL,
    PROJECT_BUILD_TIME,
    PROJECT_URL);

  //assert
  try
    CheckTrue(fProject.Equals(tmpProject));
  finally
    FreeAndNil(tmpProject);
  end;
  CheckNull(tmpProject);
end;

initialization
  TestFramework.RegisterTest(TProjectTests.Suite);

end.

