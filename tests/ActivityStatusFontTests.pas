unit ActivityStatusFontTests;

interface

uses
  Windows, SysUtils, TestFramework, TestExtensions, Classes, Graphics,
  ActivityStatusFont;

type
  TActivityStatusFontTests = class(TTestCase)
  strict private
    FTestASF1, FTestASF2: TActivityStatusFont;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published

    procedure IsEqualToShouldReturnFalseWhenActivityChanged;
    procedure IsEqualToShouldReturnFalseWhenStatusChanged;
    procedure IsEqualToShouldReturnFalseWhenFontColorChanged;
    procedure IsEqualToShouldReturnFalseWhenFontNameChanged;
    procedure IsEqualToShouldReturnFalseWhenFontSizeChanged;
    procedure IsEqualToShouldReturnFalseWhenFontStyleChanged;
    procedure IsEqualToShouldReturnTrueWhenEqual;
  end;

implementation

{ TestActivityStatusFontTests }

procedure TActivityStatusFontTests.IsEqualToShouldReturnFalseWhenActivityChanged;
var
  ReturnValue : Boolean;
begin
  //arrange
  FTestASF2.Activity := 'Building';

  //act
  ReturnValue := FTestASF1.IsEqualTo(FTestASF2);

  //assert
  CheckFalse(ReturnValue, 'IsEqualTo should have returned false!');
end;

procedure TActivityStatusFontTests.IsEqualToShouldReturnFalseWhenFontColorChanged;
var
  ReturnValue : Boolean;
begin
  //arrange
  FTestASF2.Font.Color := clRed;

  //act
  ReturnValue := FTestASF1.IsEqualTo(FTestASF2);

  //assert
  CheckFalse(ReturnValue, 'IsEqualTo should have returned false!');
end;

procedure TActivityStatusFontTests.IsEqualToShouldReturnFalseWhenFontNameChanged;
var
  ReturnValue : Boolean;
begin
  //arrange
  FTestASF2.Font.Name := 'Courier New';

  //act
  ReturnValue := FTestASF1.IsEqualTo(FTestASF2);

  //assert
  CheckFalse(ReturnValue, 'IsEqualTo should have returned false!');
end;

procedure TActivityStatusFontTests.IsEqualToShouldReturnFalseWhenFontSizeChanged;
var
  ReturnValue : Boolean;
begin
  //arrange
  FTestASF2.Font.Size := 10;

  //act
  ReturnValue := FTestASF1.IsEqualTo(FTestASF2);

  //assert
  CheckFalse(ReturnValue, 'IsEqualTo should have returned false!');
end;

procedure TActivityStatusFontTests.IsEqualToShouldReturnFalseWhenFontStyleChanged;
var
  ReturnValue : Boolean;
begin
  //arrange
  FTestASF2.Font.Style := [fsBold];

  //act
  ReturnValue := FTestASF1.IsEqualTo(FTestASF2);

  //assert
  CheckFalse(ReturnValue, 'IsEqualTo should have returned false!');
end;

procedure TActivityStatusFontTests.IsEqualToShouldReturnFalseWhenStatusChanged;
var
  ReturnValue : Boolean;
begin
  //arrange
  FTestASF2.Status := 'Exception';

  //act
  ReturnValue := FTestASF1.IsEqualTo(FTestASF2);

  //assert
  CheckFalse(ReturnValue, 'IsEqualTo should have returned false!');
end;

procedure TActivityStatusFontTests.IsEqualToShouldReturnTrueWhenEqual;
var
  ReturnValue : Boolean;
begin
  //arrange

  //act
  ReturnValue := FTestASF1.IsEqualTo(FTestASF2);

  //assert
  CheckTrue(ReturnValue, 'IsEqualTo should have returned true!');
end;

procedure TActivityStatusFontTests.SetUp;
begin
  inherited;
  FTestASF1 := TActivityStatusFont.Create('Sleeping', 'Successful', '"Arial", 36, [], [clGreen]');
  FTestASF2 := TActivityStatusFont.Create('Sleeping', 'Successful', '"Arial", 36, [], [clGreen]');
end;

procedure TActivityStatusFontTests.TearDown;
begin
  FreeAndNil(FTestASF1);
  FreeAndNil(FTestASF2);
  inherited;
end;

initialization
  // Register any test cases with the test runner
  TestFramework.RegisterTest(TActivityStatusFontTests.Suite);
end.
