unit BuildResultsFileTests;

interface

uses
  Windows, SysUtils, Classes, TestFramework, TestExtensions,
  ProjectList, ScreenSaverConfig, BuildResultsFile, RegistryDAO;

type
  TBuildResultsFileTests = class(TTestCase)
  private
    FSettingsDAO : TRegistryDAO;
    FProjectList : TProjectList;
    FBuildResultsFile : TBuildResultsFile;
    FConfig : TScreenSaverConfig;
  protected
    procedure SetUp; override;
    procedure TearDown; override;

  published
    procedure TestLoadFromFile;
    procedure TestTrippleSlashFileURLToPath;
    procedure TestDoubleSlashFileURLToPath;
  end;

implementation

{ TBuildResultsFileTests }

const
  TrippleSlash_XML_URL = 'file:///C:/dev/Projects/bsss/test.xml';
  DoubleSlash_XML_URL  = 'file://C:/dev/Projects/bsss/test.xml';

procedure TBuildResultsFileTests.SetUp;
begin
  inherited;
  //TODO: Replace this with an interface and mock so we're not actually loading a file
  FSettingsDAO := TRegistryDAO.Create;
  FConfig := TScreenSaverConfig.Create(FSettingsDAO);;
  FBuildResultsFile := TBuildResultsFile.Create(FConfig);
  FProjectList := TProjectList.Create(FConfig);
end;

procedure TBuildResultsFileTests.TearDown;
begin
  FreeAndNil(FBuildResultsFile);
  FreeAndNil(FProjectList);
  FSettingsDAO := nil;
  FreeAndNil(FConfig);
  inherited;
end;

procedure TBuildResultsFileTests.TestDoubleSlashFileURLToPath;
var
  sConvertedFileName, sFileName : String;
begin
  //arrange
  sFileName := DoubleSlash_XML_URL;

  //act
  sConvertedFileName := fBuildResultsFile.FileUrlToPath(sFileName);

  //assert
  CheckEquals('C:\dev\Projects\bsss\test.xml', sConvertedFileName);
end;

procedure TBuildResultsFileTests.TestLoadFromFile;
begin
  //arrange

  //act
  fBuildResultsFile.Load(TrippleSlash_XML_URL, fProjectList);

  //assert
  CheckEquals(1, fProjectList.Count);
end;

procedure TBuildResultsFileTests.TestTrippleSlashFileURLToPath;
var
  sConvertedFileName, sFileName : String;
begin
  //arrange
  sFileName := TrippleSlash_XML_URL;

  //act
  sConvertedFileName := FBuildResultsFile.FileURLToPath(sFileName);

  //assert
  CheckEquals('C:\dev\Projects\bsss\test.xml', sConvertedFileName);
end;

initialization
  TestFramework.RegisterTest(TBuildResultsFileTests.Suite);

end.
