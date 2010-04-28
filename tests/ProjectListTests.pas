unit ProjectListTests;

interface

uses
  Windows, SysUtils, Classes, TestFramework, TestExtensions,
  ProjectList, ScreenSaverConfig, BuildResultsFile, RegistryDAO;

type
  TProjectListTests = class(TTestCase)
  private
    FSettingsDAO : TRegistryDAO;
    FProjectList : TProjectList;
    FBuildResultsFile : TBuildResultsFile;
    FConfig : TScreenSaverConfig;
  protected
    procedure SetUp; override;
    procedure TearDown; override;

  published
    procedure TestAdd;
    procedure TestRemove;
    procedure TestIndexOf;
    procedure TestClear;
  end;

implementation

uses
  Project;

var
  tmpProject : TProject;

const
  TrippleSlash_XML_URL = 'file:///C:/dev/Projects/bsss/test.xml';
  DoubleSlash_XML_URL  = 'file://C:/dev/Projects/bsss/test.xml';
  PROJECT_NAME         = 'DEV';
  PROJECT_ACTIVITY     = 'Sleeping';
  PROJECT_BUILD_STATUS = 'Success';
  PROJECT_BUILD_LABEL  = '0';
  PROJECT_BUILD_TIME   = '2010-03-24T12:30:52.4960000+10:00';
  PROJECT_URL          = 'http://buildserver/results/';

procedure TProjectListTests.Setup;
begin
  inherited;
  //TODO: Replace this with an interface and mock so we're not actually loading a file
  FSettingsDAO := TRegistryDAO.Create;
  fConfig := TScreenSaverConfig.Create(FSettingsDAO);
  FBuildResultsFile := TBuildResultsFile.Create(FConfig);
  FProjectList := TProjectList.Create(FConfig);
end;

procedure TProjectListTests.TearDown;
begin
  FreeAndNil(FBuildResultsFile);
  FreeAndNil(FProjectList);
  FSettingsDAO := nil;
  FreeAndNil(FConfig);
  inherited;
end;

procedure TProjectListTests.TestAdd;
var
  iTemp : Integer;
begin
  //arrange
  tmpProject := TProject.Create(
    PROJECT_NAME,
    PROJECT_ACTIVITY,
    PROJECT_BUILD_STATUS,
    PROJECT_BUILD_LABEL,
    PROJECT_BUILD_TIME,
    PROJECT_URL);

  //act
  iTemp := fProjectList.Add(tmpProject);

  //assert
  CheckEquals(1, fProjectList.Count);
  CheckEquals(tmpProject.Name,        fProjectList[iTemp].Name);
  CheckEquals(tmpProject.Activity,    fProjectList[iTemp].Activity);
  CheckEquals(tmpProject.BuildStatus, fProjectList[iTemp].BuildStatus);
  CheckEquals(tmpProject.BuildLabel,  fProjectList[iTemp].BuildLabel);
  CheckEquals(tmpProject.BuildTime,   fProjectList[iTemp].BuildTime);
  CheckEquals(tmpProject.URL,         fProjectList[iTemp].URL);

  fProjectList.Remove(tmpProject);
end;

procedure TProjectListTests.TestClear;
begin
  //arrange
  fBuildResultsFile.Load(TrippleSlash_XML_URL, fProjectList);

  //act
  fProjectList.Clear;

  //assert
  CheckEquals(0, fProjectList.Count);
end;

procedure TProjectListTests.TestIndexOf;
var
  iTemp : Integer;
begin
  //arrange
  tmpProject := TProject.Create(
    PROJECT_NAME,
    PROJECT_ACTIVITY,
    PROJECT_BUILD_STATUS,
    PROJECT_BUILD_LABEL,
    PROJECT_BUILD_TIME,
    PROJECT_URL);

  //act
  iTemp := fProjectList.Add(tmpProject);

  //assert
  CheckEquals(iTemp, fProjectList.IndexOf(tmpProject));

  fProjectList.Remove(tmpProject);
end;

procedure TProjectListTests.TestRemove;
begin
  //arrange
  tmpProject := TProject.Create(
    PROJECT_NAME,
    PROJECT_ACTIVITY,
    PROJECT_BUILD_STATUS,
    PROJECT_BUILD_LABEL,
    PROJECT_BUILD_TIME,
    PROJECT_URL);

  //act
  fProjectList.Add(tmpProject);

  //assert
  CheckEquals(1, fProjectList.Count);

  //act
  fProjectList.Remove(tmpProject);

  //assert
  CheckEquals(0, fProjectList.Count);

  fProjectList.Remove(tmpProject);
end;

initialization
  TestFramework.RegisterTest(TProjectListTests.Suite);

end.

