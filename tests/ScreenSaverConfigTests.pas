unit ScreenSaverConfigTests;

interface

uses
  Windows, SysUtils, Classes, TestFramework, TestExtensions, ScreenSaverConfig;

type
  TScreenSaverConfigTests = class(TTestCase)
  private
    FScreenSaverConfig, backupConfig: TScreenSaverConfig;
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

    procedure SaveConfigShouldChangeRegistryValues;
  end;

implementation

procedure TScreenSaverConfigTests.SetUp;
begin
  inherited;
  FScreenSaverConfig := TScreenSaverConfig.Create;
  //I know it will slow these tests down
  //but I want do want to test the settings are actually saved
  if FScreenSaverConfig.LoadConfig then
  begin
    backupConfig := TScreenSaverConfig.Create;
    backupConfig.Assign(FScreenSaverConfig);
  end
  else
    backupConfig := nil;
end;

procedure TScreenSaverConfigTests.TearDown;
begin
  if assigned(backupConfig) then
  begin
    backupConfig.SaveConfig;
    FreeAndNil(backupConfig);
  end;
  FreeAndNil(FScreenSaverConfig);
  inherited;
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

