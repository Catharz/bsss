unit FontManagerTests;

interface

uses
  Windows, SysUtils, TestFramework, TestExtensions, Classes, FontManager, Graphics;

type
  // Test methods for class TFontManager

  TestTFontManager = class(TTestCase)
  strict private
    FFontManager: TFontManager;
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

procedure TestTFontManager.SetUp;
begin
  FFontManager := TFontManager.Create;
end;

procedure TestTFontManager.TearDown;
begin
  FFontManager.Free;
  FFontManager := nil;
end;

procedure TestTFontManager.ValidateFontShouldHandleErrorsGracefully;
var
  ReturnValue: Boolean;
  value: string;
begin
  //arrange
  value := '';

  //act
  ReturnValue := FFontManager.ValidateFont(value);

  //assert
  CheckFalse(ReturnValue);
end;

procedure TestTFontManager.ValidateFontShouldReturnFalseWhenGivenInvalidFont;
var
  ReturnValue : Boolean;
  value : string;
begin
  //act
  value := '"Ariel", 36, [Big], [clSky]';

  //act
  ReturnValue := FFontManager.ValidateFont(value);

  //assert
  CheckFalse(ReturnValue);
end;

procedure TestTFontManager.ValidateFontSHouldReturnTrueWhenGivenValidFont;
var
  ReturnValue : Boolean;
  value : string;
begin
  //arrange
  value := '"Arial", 36, [Italic], [clRed]';

  //act
  ReturnValue := FFontManager.ValidateFont(value);

  //assert
  CheckTrue(ReturnValue);
end;

procedure TestTFontManager.DefaultNonSleepingStyleShouldBeItalic;
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
    ReturnValue := FFontManager.DefaultFontString[sActivity, sStatus];
    FFontManager.StringToFont(ReturnValue, font);

    //assert
    Check([fsItalic] = font.Style, 'Font style should be Italic');
  finally
    FreeAndNil(font);
  end;
end;

procedure TestTFontManager.DefaultNonSuccessFontShouldBeRed;
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
    ReturnValue := FFontManager.DefaultFontString[sActivity, sStatus];
    FFontManager.StringToFont(ReturnValue, font);

    //assert
    CheckEquals(clRed, font.Color, 'Font colour should be red');
  finally
    FreeAndNil(font);
  end;
end;

procedure TestTFontManager.DefaultSleepingStyleShouldBeNormal;
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
    ReturnValue := FFontManager.DefaultFontString[sActivity, sStatus];
    FFontManager.StringToFont(ReturnValue, font);

    //assert
    Check([] = font.Style, 'Font style should be Normal');
  finally
    FreeAndNil(font);
  end;
end;

procedure TestTFontManager.DefaultSuccessFontShouldBeGreen;
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
    ReturnValue := FFontManager.DefaultFontString[sActivity, sStatus];
    FFontManager.StringToFont(ReturnValue, font);

    //assert
    CheckEquals(clGreen, font.Color, 'Font colour should be Green');
  finally
    FreeAndNil(font);
  end;
end;

procedure TestTFontManager.FontToStringShouldHandleAllStyles;
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
    ReturnValue := FFontManager.FontToString(font);

    //assert
    CheckEquals('"Arial", 36, [Bold|Italic|Underline|Strikeout], [clRed]', ReturnValue);
  finally
    FreeAndNil(font);
  end;
end;

procedure TestTFontManager.StringToFontShouldHandleAllStyles;
var
  font: TFont;
  value: string;
begin
  //arrange
  font := TFont.Create;
  value := '"Arial", 36, [Bold|Italic|Underline|Strikeout], [clRed]';

  try
    //act
    FFontManager.StringToFont(value, font);

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

procedure TestTFontManager.StringToFontShouldHandleErrorsGracefully;
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
      FFontManager.StringToFont(value, font);
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
  TestFramework.RegisterTest(TestTFontManager.Suite);
end.
