unit ProjectListTests;

interface

uses
  Windows, SysUtils, Classes, TestFramework, TestExtensions, ProjectList;

type
  TProjectListTests = class(TTestCase)
  private
    FProjectList : TProjectList;
  protected
    procedure SetUp; override;
    procedure TearDown; override;

  published
    procedure TestAdd;
    procedure TestRemove;
    procedure TestIndexOf;
    procedure TestClear;
    procedure TestLoadFromFile;
    procedure TestTrippleSlashFileURLToPath;
    procedure TestDoubleSlashFileURLToPath;
  end;

implementation

uses
  Project;

var
  tmpProject : TProject;

const
  TrippleSlash_XML_URL = 'file:///C:/Users/craig/Documents/RAD%20Studio/Projects/play/ccTraySSTests/test.xml';
  DoubleSlash_XML_URL  = 'file://C:/Users/craig/Documents/RAD%20Studio/Projects/play/ccTraySSTests/test.xml';
  PROJECT_NAME         = 'SAMS';
  PROJECT_ACTIVITY     = 'Sleeping';
  PROJECT_BUILD_STATUS = 'Success';
  PROJECT_BUILD_TIME   = '2010-03-24T12:30:52.4960000+10:00';
  PROJECT_URL          = 'http://asiscontint1.awmltd.com.au/FBServer6/BuildLog.aspx?ProjectName=SAMS 5.8.20 (Test Coverage)&amp;BuildID=Latest&amp;Filter=Auto&amp;Tab=Log';

procedure TProjectListTests.Setup;
begin
  inherited;
  FProjectList := TProjectList.Create;
end;

procedure TProjectListTests.TearDown;
begin
  FreeAndNil(FProjectList);
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
    PROJECT_BUILD_TIME,
    PROJECT_URL);

  //act
  iTemp := fProjectList.Add(tmpProject);

  //assert
  CheckEquals(1, fProjectList.Count);
  CheckEquals(tmpProject.Name,            fProjectList[iTemp].Name);
  CheckEquals(tmpProject.Activity,        fProjectList[iTemp].Activity);
  CheckEquals(tmpProject.LastBuildStatus, fProjectList[iTemp].LastBuildStatus);
  CheckEquals(tmpProject.LastBuildTime,   fProjectList[iTemp].LastBuildTime);
  CheckEquals(tmpProject.URL,             fProjectList[iTemp].URL);

  fProjectList.Remove(tmpProject);
end;

procedure TProjectListTests.TestClear;
begin
  //arrange
  fProjectList.loadFromFile(TrippleSlash_XML_URL);

  //act
  fProjectList.Clear;

  //assert
  CheckEquals(0, fProjectList.Count);
end;

procedure TProjectListTests.TestDoubleSlashFileURLToPath;
var
  sConvertedFileName, sFileName : String;
begin
  //arrange
  sFileName := DoubleSlash_XML_URL;

  //act
  sConvertedFileName := FProjectList.FileURLToPath(sFileName);

  //assert
  CheckEquals('C:\Users\craig\Documents\RAD Studio\Projects\play\ccTraySSTests\test.xml', sConvertedFileName);
end;

procedure TProjectListTests.TestTrippleSlashFileURLToPath;
var
  sConvertedFileName, sFileName : String;
begin
  //arrange
  sFileName := TrippleSlash_XML_URL;

  //act
  sConvertedFileName := FProjectList.FileURLToPath(sFileName);

  //assert
  CheckEquals('C:\Users\craig\Documents\RAD Studio\Projects\play\ccTraySSTests\test.xml', sConvertedFileName);
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
    PROJECT_BUILD_TIME,
    PROJECT_URL);

  //act
  iTemp := fProjectList.Add(tmpProject);

  //assert
  CheckEquals(iTemp, fProjectList.IndexOf(tmpProject));

  fProjectList.Remove(tmpProject);
end;

procedure TProjectListTests.TestLoadFromFile;
begin
  //arrange

  //act
  fProjectList.loadFromFile(TrippleSlash_XML_URL);

  //assert
  CheckEquals(1, fProjectList.Count);
end;

procedure TProjectListTests.TestRemove;
begin
  //arrange
  tmpProject := TProject.Create(
    PROJECT_NAME,
    PROJECT_ACTIVITY,
    PROJECT_BUILD_STATUS,
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

