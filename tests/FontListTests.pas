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
    procedure ValidateFontShouldHandleErrorsGracefully;
    procedure ValidateFontShouldReturnFalseWhenGivenInvalidFont;
    procedure ValidateFontSHouldReturnTrueWhenGivenValidFont;
    procedure FontToStringShouldHandleAllStyles;
    procedure StringToFontShouldHandleErrorsGracefully;
    procedure StringToFontShouldHandleAllStyles;
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

procedure TFontListTests.ValidateFontShouldHandleErrorsGracefully;
var
  ReturnValue: Boolean;
  value: string;
begin
  //arrange
  value := '';

  //act
  ReturnValue := FFontList.ValidateFont(value);

  //assert
  CheckFalse(ReturnValue);
end;

procedure TFontListTests.ValidateFontShouldReturnFalseWhenGivenInvalidFont;
var
  ReturnValue : Boolean;
  value : string;
begin
  //act
  value := '"Ariel", 36, [Big], [clSky]';

  //act
  ReturnValue := FFontList.ValidateFont(value);

  //assert
  CheckFalse(ReturnValue);
end;

procedure TFontListTests.ValidateFontSHouldReturnTrueWhenGivenValidFont;
var
  ReturnValue : Boolean;
  value : string;
begin
  //arrange
  value := '"Arial", 36, [Italic], [clRed]';

  //act
  ReturnValue := FFontList.ValidateFont(value);

  //assert
  CheckTrue(ReturnValue);
end;

procedure TFontListTests.DefaultNonSleepingStyleShouldBeItalic;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Whatever';
  sStatus := 'Whatever';
  font := TFont.Create;

  try
    //act
    ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
    FFontList.StringToFont(ReturnValue, font);

    //assert
    Check([fsItalic] = font.Style, 'Font style should be Italic');
  finally
    FreeAndNil(font);
  end;
end;

procedure TFontListTests.DefaultNonSuccessFontShouldBeRed;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Whatever';
  sStatus := 'Whatever';
  font := TFont.Create;

  try
    //act
    ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
    FFontList.StringToFont(ReturnValue, font);

    //assert
    CheckEquals(clRed, font.Color, 'Font colour should be red');
  finally
    FreeAndNil(font);
  end;
end;

procedure TFontListTests.DefaultSleepingStyleShouldBeNormal;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Sleeping';
  sStatus := 'Whatever';
  font := TFont.Create;
  font.style := [fsBold];

  try
    //act
    ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
    FFontList.StringToFont(ReturnValue, font);

    //assert
    Check([] = font.Style, 'Font style should be Normal');
  finally
    FreeAndNil(font);
  end;
end;

procedure TFontListTests.DefaultSuccessFontShouldBeGreen;
var
  ReturnValue, sActivity, sStatus : string;
  font : TFont;
begin
  //arrange
  sActivity := 'Whatever';
  sStatus := 'Success';
  font := TFont.Create;

  try
    //act
    ReturnValue := FFontList.DefaultFontString[sActivity, sStatus];
    FFontList.StringToFont(ReturnValue, font);

    //assert
    CheckEquals(clGreen, font.Color, 'Font colour should be Green');
  finally
    FreeAndNil(font);
  end;
end;

procedure TFontListTests.FontToStringShouldHandleAllStyles;
var
  ReturnValue: string;
  font: TFont;
begin
  //arrange
  font := TFont.Create;
  font.Name := 'Arial';
  font.Size := 36;
  font.Style := [fsBold, fsItalic, fsUnderline, fsStrikeOut];
  font.Color := clRed;

  try
    //act
    ReturnValue := FFontList.FontToString(font);

    //assert
    CheckEquals('"Arial", 36, [Bold|Italic|Underline|Strikeout], [clRed]', ReturnValue);
  finally
    FreeAndNil(font);
  end;
end;

procedure TFontListTests.StringToFontShouldHandleAllStyles;
var
  font: TFont;
  value: string;
begin
  //arrange
  font := TFont.Create;
  value := '"Arial", 36, [Bold|Italic|Underline|Strikeout], [clRed]';

  try
    //act
    FFontList.StringToFont(value, font);

    //assert
    CheckEquals('Arial', font.Name);
    CheckEquals(36, font.Size);
    CheckTrue(fsBold in font.Style);
    CheckTrue(fsItalic in font.Style);
    CheckTrue(fsUnderline in font.Style);
    CheckTrue(fsStrikeOut in font.Style);
    CheckEquals(clRed, font.Color);
  finally
    FreeAndNil(font);
  end;
end;

procedure TFontListTests.StringToFontShouldHandleErrorsGracefully;
var
  font: TFont;
  value: string;
begin
  //arrange
  font := TFont.Create;
  value := '"Ariel", 36, [Big|Fancy|Highlighted|Struckeout], [clSky]';

  try
    //act

    //assert
    try
      FFontList.StringToFont(value, font);
      Check(False, 'EFontConversionError should have been raised!');
    except
      on e: EFontConversionError do
        Check(True, 'EFontConversionError raised correctly!');
    end;
  finally
    FreeAndNil(font);
  end;
end;

initialization
  // Register any test cases with the test runner
  TestFramework.RegisterTest(TFontListTests.Suite);
end.
