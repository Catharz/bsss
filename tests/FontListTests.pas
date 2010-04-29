unit FontListTests;

interface

uses
  Windows, SysUtils, TestFramework, TestExtensions, Classes, FontList, Graphics;

type
  // Test methods for class TFontManager

  TFontListTests = class(TTestCase)
  strict private
    FFontList: TFontList;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure DefaultBuildingExceptionFontShouldBeRedItalic;
    procedure DefaultBuildingFailureFontShouldBeRedItalic;
    procedure DefaultBuildingSuccessFontShouldBeGreenItalic;
    procedure DefaultBuildingUnknownFontShouldBeRedItalic;

    procedure DefaultCheckingModificationsExceptionFontShouldBeRedItalic;
    procedure DefaultCheckingModificationsFailureFontShouldBeRedItalic;
    procedure DefaultCheckingModificationsSuccessFontShouldBeGreenItalic;
    procedure DefaultCheckingModificationsUnknownFontShouldBeRedItalic;

    procedure DefaultSleepingExceptionFontShouldBeRedNormal;
    procedure DefaultSleepingFailureFontShouldBeRedNormal;
    procedure DefaultSleepingSuccessFontShouldBeGreenNormal;
    procedure DefaultSleepingUnknownFontShouldBeRedNormal;

    procedure DefaultFontNameShouldBeArial;

    procedure DefaultSuccessFontShouldBeGreen;
    procedure DefaultNonSuccessFontShouldBeRed;
    procedure DefaultSleepingStyleShouldBeNormal;
    procedure DefaultNonSleepingStyleShouldBeItalic;
  end;

implementation

procedure TFontListTests.SetUp;
begin
  FFontList := TFontList.Create;
end;

procedure TFontListTests.TearDown;
begin
  FFontList.Free;
  FFontList := nil;
end;

procedure TFontListTests.DefaultBuildingExceptionFontShouldBeRedItalic;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Building';
  sStatus := 'Exception';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  CheckEquals(clRed, font.Color, sActivity + ' ' + sStatus + ' Font colour should be Red');
  Check([fsItalic] = font.Style, sActivity + ' ' + sStatus + ' Font style should be Italic');
end;

procedure TFontListTests.DefaultBuildingFailureFontShouldBeRedItalic;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Building';
  sStatus := 'Failure';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  CheckEquals(clRed, font.Color, sActivity + ' ' + sStatus + ' Font colour should be Red');
  Check([fsItalic] = font.Style, sActivity + ' ' + sStatus + ' Font style should be Italic');
end;

procedure TFontListTests.DefaultBuildingSuccessFontShouldBeGreenItalic;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Building';
  sStatus := 'Success';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  CheckEquals(clGreen, font.Color, sActivity + ' ' + sStatus + ' Font colour should be Green');
  Check([fsItalic] = font.Style, sActivity + ' ' + sStatus + ' Font style should be Italic');
end;

procedure TFontListTests.DefaultBuildingUnknownFontShouldBeRedItalic;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Building';
  sStatus := 'Unknown';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  CheckEquals(clRed, font.Color, sActivity + ' ' + sStatus + ' Font colour should be Red');
  Check([fsItalic] = font.Style, sActivity + ' ' + sStatus + ' Font style should be Italic');
end;

procedure TFontListTests.DefaultCheckingModificationsExceptionFontShouldBeRedItalic;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'CheckingModifications';
  sStatus := 'Exception';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  CheckEquals(clRed, font.Color, sActivity + ' ' + sStatus + ' Font colour should be Red');
  Check([fsItalic] = font.Style, sActivity + ' ' + sStatus + ' Font style should be Italic');
end;

procedure TFontListTests.DefaultCheckingModificationsFailureFontShouldBeRedItalic;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'ChecingModifications';
  sStatus := 'Failure';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  CheckEquals(clRed, font.Color, sActivity + ' ' + sStatus + ' Font colour should be Red');
  Check([fsItalic] = font.Style, sActivity + ' ' + sStatus + ' Font style should be Italic');
end;

procedure TFontListTests.DefaultCheckingModificationsSuccessFontShouldBeGreenItalic;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'CheckingModifications';
  sStatus := 'Success';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  CheckEquals(clGreen, font.Color, sActivity + ' ' + sStatus + ' Font colour should be Green');
  Check([fsItalic] = font.Style, sActivity + ' ' + sStatus + ' Font style should be Italic');
end;

procedure TFontListTests.DefaultCheckingModificationsUnknownFontShouldBeRedItalic;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'CheckingModifications';
  sStatus := 'Unknown';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  CheckEquals(clRed, font.Color, sActivity + ' ' + sStatus + ' Font colour should be Red');
  Check([fsItalic] = font.Style, sActivity + ' ' + sStatus + ' Font style should be Italic');
end;

procedure TFontListTests.DefaultFontNameShouldBeArial;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Whatever';
  sStatus := 'Whatever';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  CheckEquals('Arial', font.Name, 'Font name should be Arial');
end;

procedure TFontListTests.DefaultNonSleepingStyleShouldBeItalic;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Whatever';
  sStatus := 'Whatever';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  Check([fsItalic] = font.Style, 'Font style should be Italic');
end;

procedure TFontListTests.DefaultNonSuccessFontShouldBeRed;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Whatever';
  sStatus := 'Whatever';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  CheckEquals(clRed, font.Color, 'Font colour should be red');
end;

procedure TFontListTests.DefaultSleepingExceptionFontShouldBeRedNormal;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Sleeping';
  sStatus := 'Exception';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  CheckEquals(clRed, font.Color, sActivity + ' ' + sStatus + ' Font colour should be Red');
  Check([] = font.Style, sActivity + ' ' + sStatus + ' Font style should be Normal');
end;

procedure TFontListTests.DefaultSleepingFailureFontShouldBeRedNormal;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Sleeping';
  sStatus := 'Failure';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  CheckEquals(clRed, font.Color, sActivity + ' ' + sStatus + ' Font colour should be Red');
  Check([] = font.Style, sActivity + ' ' + sStatus + ' Font style should be Normal');
end;

procedure TFontListTests.DefaultSleepingStyleShouldBeNormal;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Sleeping';
  sStatus := 'Whatever';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  Check([] = font.Style, 'Font style should be Normal');
end;

procedure TFontListTests.DefaultSleepingSuccessFontShouldBeGreenNormal;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Sleeping';
  sStatus := 'Success';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  CheckEquals(clGreen, font.Color, sActivity + ' ' + sStatus + ' Font colour should be Green');
  Check([] = font.Style, sActivity + ' ' + sStatus + ' Font style should be Normal');
end;

procedure TFontListTests.DefaultSleepingUnknownFontShouldBeRedNormal;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Sleeping';
  sStatus := 'Unknown';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  CheckEquals(clRed, font.Color, sActivity + ' ' + sStatus + ' Font colour should be Red');
  Check([] = font.Style, sActivity + ' ' + sStatus + ' Font style should be Normal');
end;

procedure TFontListTests.DefaultSuccessFontShouldBeGreen;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Whatever';
  sStatus := 'Success';

  //act
  ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
  FFontList.FontAsString[sActivity, sStatus] := ReturnValue;
  font := FFontList.Font[sActivity, sStatus];

  //assert
  CheckEquals(clGreen, font.Color, 'Font colour should be Green');
end;

initialization
  // Register any test cases with the test runner
  TestFramework.RegisterTest(TFontListTests.Suite);
end.
