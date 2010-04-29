unit ScreenSaverConfigTests;

interface

uses
  Windows, SysUtils, Classes, TestFramework, TestExtensions,
  ScreenSaverConfig, RegistryDAO;

type
  TScreenSaverConfigTests = class(TTestCase)
  private
    FScreenSaverConfig, backupConfig: TScreenSaverConfig;
    FSettingsDAO : TRegistryDAO;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure ZeroUpdateFrequencyShouldBeValid;
    procedure UpdateFrequencyOfOneShouldBeValid;
    procedure UpdateFrequencyOfTenShouldBeValid;
    procedure UpdateFrequencyGreaterThanTenShouldBeInvalid;
    procedure ZeroAnimationFrequencyShouldBeInvalid;
    procedure AnimationFrequencyOfOneShouldBeValid;
    procedure AnimationFrequencyOfTenShouldBeValid;
    procedure AnimationFrequencyGreaterThanTenShouldBeInvalid;

    procedure DoubleSlashFileUrlShouldBeValid;
    procedure TrippleSlashFileUrlShouldBeValid;
    procedure HttpUrlShouldBeValid;
    procedure UrlNotStartingWithHttpOrFileShouldBeInvalid;

    procedure LoadConfigShouldNotRaiseAnException;
    procedure SaveConfigWithValidValuesShouldNotThrowException;
    procedure SaveConfigWithInvalidUrlShouldThrowException;
    procedure SaveConfigWithInvalidUpdateFrequencyShouldThrowException;
    procedure SaveConfigWithInvalidAnimationFrequencyShouldThrowException;

    procedure SleepingShouldBeAStandardActivity;
    procedure BuildingShouldBeAStandardActivity;
    procedure CheckingModificationsShouldBeAStandardActivity;
    procedure TestingShouldBeACustomActivity;

    procedure ExceptionShouldBeAStandardStatus;
    procedure SuccessShouldBeAStandardStatus;
    procedure FailureShouldBeAStandardStatus;
    procedure UnknownShouldBeAStandardStatus;
    procedure UnitTestsFailedShouldBeACustomStatus;

    procedure SaveConfigShouldChangeRegistryValues;
  end;

implementation

uses
  Graphics;

procedure TScreenSaverConfigTests.SetUp;
begin
  inherited;
  //TODO: Replace with a mock
  FSettingsDAO := TRegistryDAO.Create;
  FScreenSaverConfig := TScreenSaverConfig.Create(FSettingsDAO);
  backupConfig := TScreenSaverConfig.Create(FSettingsDAO);
end;

procedure TScreenSaverConfigTests.SleepingShouldBeAStandardActivity;
var
  sActivity : String;
  ReturnValue : TValueType;
begin
  //arrange
  sActivity := 'Sleeping';

  //act
  ReturnValue := FScreenSaverConfig.ActivityType(sActivity);

  //assert
  Check(vtStandard = ReturnValue);
end;

procedure TScreenSaverConfigTests.SuccessShouldBeAStandardStatus;
var
  sStatus : String;
  ReturnValue : TValueType;
begin
  //arrange
  sStatus := 'Success';

  //act
  ReturnValue := FScreenSaverConfig.StatusType(sStatus);

  //assert
  Check(vtStandard = ReturnValue);
end;

procedure TScreenSaverConfigTests.TearDown;
begin
  FSettingsDAO := nil;
  FreeAndNil(FScreenSaverConfig);
  FreeAndNil(backupConfig);
  inherited;
end;

procedure TScreenSaverConfigTests.TestingShouldBeACustomActivity;
var
  sActivity : String;
  ReturnValue : TValueType;
begin
  //arrange
  sActivity := 'Testing';

  //act
  ReturnValue := FScreenSaverConfig.ActivityType(sActivity);

  //assert
  Check(vtCustom = ReturnValue);
end;

procedure TScreenSaverConfigTests.TrippleSlashFileUrlShouldBeValid;
var
  ReturnValue: Boolean;
  value: string;
begin
  //arrange
  value := 'file:///C:/junk.txt';

  //act
  ReturnValue := FScreenSaverConfig.ValidateXmlFileURL(value);

  //assert
  CheckTrue(ReturnValue);
end;

procedure TScreenSaverConfigTests.UnitTestsFailedShouldBeACustomStatus;
var
  sStatus : String;
  ReturnValue : TValueType;
begin
  //arrange
  sStatus := 'UnitTestsFailed';

  //act
  ReturnValue := FScreenSaverConfig.StatusType(sStatus);

  //assert
  Check(vtCustom = ReturnValue);
end;

procedure TScreenSaverConfigTests.UnknownShouldBeAStandardStatus;
var
  sStatus : String;
  ReturnValue : TValueType;
begin
  //arrange
  sStatus := 'Unknown';

  //act
  ReturnValue := FScreenSaverConfig.StatusType(sStatus);

  //assert
  Check(vtStandard = ReturnValue);
end;

procedure TScreenSaverConfigTests.UpdateFrequencyGreaterThanTenShouldBeInvalid;
var
  value : Integer;
  ReturnValue : Boolean;
begin
  //arrange
  value := 11;

  //act
  ReturnValue := FScreenSaverConfig.ValidateUpdateFrequency(value);

  //assert
  CheckFalse(ReturnValue);
end;

procedure TScreenSaverConfigTests.UpdateFrequencyOfOneShouldBeValid;
var
  value : Integer;
  ReturnValue : Boolean;
begin
  //arrange
  value := 1;

  //act
  ReturnValue := FScreenSaverConfig.ValidateUpdateFrequency(value);

  //assert
  CheckTrue(ReturnValue);
end;

procedure TScreenSaverConfigTests.UpdateFrequencyOfTenShouldBeValid;
var
  value : Integer;
  ReturnValue : Boolean;
begin
  //arrange
  value := 10;

  //act
  ReturnValue := FScreenSaverConfig.ValidateUpdateFrequency(value);

  //assert
  CheckTrue(ReturnValue);
end;

procedure TScreenSaverConfigTests.UrlNotStartingWithHttpOrFileShouldBeInvalid;
var
  ReturnValue: Boolean;
  value: string;
begin
  //arrange
  value := 'junk://junk.txt';

  //act
  ReturnValue := FScreenSaverConfig.ValidateXmlFileURL(value);

  //assert
  CheckFalse(ReturnValue);
end;

procedure TScreenSaverConfigTests.ZeroUpdateFrequencyShouldBeValid;
var
  ReturnValue: Boolean;
  value: Integer;
begin
  //arrange
  value := 0;

  //act
  ReturnValue := FScreenSaverConfig.ValidateUpdateFrequency(value);

  //assert
  CheckTrue(ReturnValue);
end;

procedure TScreenSaverConfigTests.ZeroAnimationFrequencyShouldBeInvalid;
var
  ReturnValue: Boolean;
  value: Integer;
begin
  //arrange
  value := 0;

  //act
  ReturnValue := FScreenSaverConfig.ValidateAnimationFrequency(value);

  //assert
  CheckFalse(ReturnValue);
end;

procedure TScreenSaverConfigTests.AnimationFrequencyGreaterThanTenShouldBeInvalid;
var
  ReturnValue: Boolean;
  value: Integer;
begin
  //arrange
  value := 11;

  //act
  ReturnValue := FScreenSaverConfig.ValidateAnimationFrequency(value);

  //assert
  CheckFalse(ReturnValue);
end;

procedure TScreenSaverConfigTests.AnimationFrequencyOfOneShouldBeValid;
var
  ReturnValue: Boolean;
  value: Integer;
begin
  //arrange
  value := 1;

  //act
  ReturnValue := FScreenSaverConfig.ValidateAnimationFrequency(value);

  //assert
  CheckTrue(ReturnValue);
end;

procedure TScreenSaverConfigTests.AnimationFrequencyOfTenShouldBeValid;
var
  ReturnValue: Boolean;
  value: Integer;
begin
  //arrange
  value := 10;

  //act
  ReturnValue := FScreenSaverConfig.ValidateAnimationFrequency(value);

  //assert
  CheckTrue(ReturnValue);
end;

procedure TScreenSaverConfigTests.BuildingShouldBeAStandardActivity;
var
  sActivity : String;
  ReturnValue : TValueType;
begin
  //arrange
  sActivity := 'Building';

  //act
  ReturnValue := FScreenSaverConfig.ActivityType(sActivity);

  //assert
  Check(vtStandard = ReturnValue);
end;

procedure TScreenSaverConfigTests.CheckingModificationsShouldBeAStandardActivity;
var
  sActivity : String;
  ReturnValue : TValueType;
begin
  //arrange
  sActivity := 'CheckingModifications';

  //act
  ReturnValue := FScreenSaverConfig.ActivityType(sActivity);

  //assert
  Check(vtStandard = ReturnValue);
end;

procedure TScreenSaverConfigTests.DoubleSlashFileUrlShouldBeValid;
var
  ReturnValue: Boolean;
  value: string;
begin
  //arrange
  value := 'file://C:/junk.txt';

  //act
  ReturnValue := FScreenSaverConfig.ValidateXmlFileURL(value);

  //assert
  CheckTrue(ReturnValue);
end;

procedure TScreenSaverConfigTests.ExceptionShouldBeAStandardStatus;
var
  sStatus : String;
  ReturnValue : TValueType;
begin
  //arrange
  sStatus := 'Exception';

  //act
  ReturnValue := FScreenSaverConfig.StatusType(sStatus);

  //assert
  Check(vtStandard = ReturnValue);
end;

procedure TScreenSaverConfigTests.FailureShouldBeAStandardStatus;
var
  sStatus : String;
  ReturnValue : TValueType;
begin
  //arrange
  sStatus := 'Failure';

  //act
  ReturnValue := FScreenSaverConfig.StatusType(sStatus);

  //assert
  Check(vtStandard = ReturnValue);
end;

procedure TScreenSaverConfigTests.HttpUrlShouldBeValid;
var
  ReturnValue: Boolean;
  value: string;
begin
  //arrange
  value := 'http://www.junk.com';

  //act
  ReturnValue := FScreenSaverConfig.ValidateXmlFileURL(value);

  //assert
  CheckTrue(ReturnValue);
end;

procedure TScreenSaverConfigTests.LoadConfigShouldNotRaiseAnException;
var
  ReturnValue: Boolean;
begin
  //arrange

  //act
  ReturnValue := FScreenSaverConfig.LoadConfig;

  //assert
  CheckTrue(ReturnValue);
end;

procedure TScreenSaverConfigTests.SaveConfigShouldChangeRegistryValues;
begin
  //arrange
  FScreenSaverConfig.XmlFileURL := 'file://junk.xml';
  FScreenSaverConfig.AnimationFrequency := 10;
  FScreenSaverConfig.UpdateFrequency := 10;

  //act
  FScreenSaverConfig.SaveConfig;
  FScreenSaverConfig.XmlFileURL := '';
  FScreenSaverConfig.AnimationFrequency := 0;
  FScreenSaverConfig.UpdateFrequency := 0;
  if not FScreenSaverConfig.LoadConfig then
    Fail('Config failed to reload!');

  //assert
  CheckEquals(FScreenSaverConfig.XmlFileURL, 'file://junk.xml');
  CheckEquals(FScreenSaverConfig.AnimationFrequency, 10);
  CheckEquals(FScreenSaverConfig.UpdateFrequency, 10);
end;

procedure TScreenSaverConfigTests.SaveConfigWithInvalidAnimationFrequencyShouldThrowException;
begin
  //arrange
  FScreenSaverConfig.XmlFileURL := DefaultXmlFileUrl;
  FScreenSaverConfig.UpdateFrequency := DefaultUpdateFrequency;
  FScreenSaverConfig.AnimationFrequency := DefaultAnimationFrequency;

  //act
  FScreenSaverConfig.AnimationFrequency := 20;

  //assert
  CheckException(FScreenSaverConfig.SaveConfig, EInvalidAnimationFrequency);
end;

procedure TScreenSaverConfigTests.SaveConfigWithInvalidUpdateFrequencyShouldThrowException;
begin
  //arrange
  FScreenSaverConfig.XmlFileURL := DefaultXmlFileUrl;
  FScreenSaverConfig.UpdateFrequency := DefaultUpdateFrequency;
  FScreenSaverConfig.AnimationFrequency := DefaultAnimationFrequency;

  //act
  FScreenSaverConfig.UpdateFrequency := 20;

  //assert
  CheckException(FScreenSaverConfig.SaveConfig, EInvalidUpdateFrequency);
end;

procedure TScreenSaverConfigTests.SaveConfigWithInvalidUrlShouldThrowException;
begin
  //arrange
  FScreenSaverConfig.XmlFileURL := DefaultXmlFileUrl;
  FScreenSaverConfig.UpdateFrequency := DefaultUpdateFrequency;
  FScreenSaverConfig.AnimationFrequency := DefaultAnimationFrequency;

  //act
  FScreenSaverConfig.XmlFileURL := 'junk://www.junk.com';

  //assert
  CheckException(FScreenSaverConfig.SaveConfig, EInvalidUrl);
end;

procedure TScreenSaverConfigTests.SaveConfigWithValidValuesShouldNotThrowException;
begin
  //arrange
  FScreenSaverConfig.AnimationFrequency := DefaultAnimationFrequency;
  FScreenSaverConfig.UpdateFrequency := DefaultUpdateFrequency;
  FScreenSaverConfig.XmlFileURL := DefaultXmlFileUrl;

  //act
  FScreenSaverConfig.SaveConfig;

  //assert
  CheckTrue(True); //If there wasn't an exception raised, all is good
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TScreenSaverConfigTests.Suite);
end.

