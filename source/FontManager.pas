unit FontManager;

interface

uses
  Classes, Graphics, SysUtils;

type
  EFontConversionError = class(Exception);
  TFontManager = class
  private
    FFontList : TStringList;
    function GetFont(sActivity, sStatus: String): TFont;
    procedure SetFont(sActivity, sStatus: String; const Value: TFont);
    function GetFontString(sActivity, sStatus: String): String;
    procedure SetFontString(sActivity, sStatus: String; const Value: String);
    function GetDefaultFontString(sActivity : String = 'Sleeping'; sStatus: String = 'Failed'): String;
  public
    constructor Create;
    destructor Destroy; reintroduce;
    function ValidateFont(value : string) : Boolean;
    function FontToString(font : TFont): String;
    procedure StringToFont(sFont : String; var font : TFont);
    procedure RenameFont(sOldFontName, sNewFontName : string);

    property FontList : TStringList read FFontList write FFontList;
    property Font[sActivity, sStatus : String] : TFont read GetFont write SetFont;
    property FontAsString[sActivity, sStatus : String] : String read GetFontString write SetFontString;
    property DefaultFontString[sActivity, sStatus : String] : String read GetDefaultFontString;
  end;

implementation

{ TFontManager }

const
  csfsBold      = '|Bold';
  csfsItalic    = '|Italic';
  csfsUnderline = '|Underline';
  csfsStrikeout = '|Strikeout';

procedure TFontManager.SetFont(sActivity, sStatus: String; const Value: TFont);
var
  iPos : Integer;
begin
  iPos := FFontList.IndexOf(sActivity + '_' + sStatus);
  if iPos >= 0 then
    FFontList.Delete(iPos);
  FFontList.AddObject(sActivity + '_' + sStatus, Value);
end;

procedure TFontManager.SetFontString(sActivity, sStatus: String;
  const Value: String);
var
  tmpFont : TFont;
begin
  tmpFont := TFont.Create;
  StringToFont(Value, tmpFont);
  SetFont(sActivity, sStatus, tmpFont);
end;

procedure TFontManager.StringToFont(sFont: String; var font: TFont);
var
  p      : integer;
  sStyle : string;
begin
  try
    // get font name
    p := Pos(',', sFont);
    font.Name := Copy(sFont, 2, p - 3);
    Delete(sFont, 1, p);

    // get font size
    p := Pos(',', sFont);
    font.Size := StrToInt(Copy(sFont, 2, p - 2));
    Delete(sFont, 1, p);

    // get font style
    p := Pos(',', sFont);
    sStyle := '|' + Copy(sFont, 3, p - 4);
    Delete(sFont, 1, p);

    // get font color
    font.Color := StringToColor(Copy(sFont, 3, Length(sFont) - 3));

    // convert str font style to font style
    font.Style := [];

    if (Pos(csfsBold, sStyle) > 0) then
      font.Style := font.Style + [fsBold];

    if (Pos(csfsItalic, sStyle ) > 0) then
      font.Style := font.Style + [fsItalic];

    if (Pos(csfsUnderline, sStyle) > 0) then
      font.Style := font.Style + [fsUnderline];

    if (Pos(csfsStrikeout, sStyle) > 0) then
      font.Style := font.Style + [fsStrikeout];
  except
    on e: Exception do
      raise EFontConversionError.Create(e.Message);
  end;
end;

function TFontManager.ValidateFont(value: string): Boolean;
var
  tmpFont : TFont;
begin
  tmpFont := TFont.Create;
  Result := False;
  try
    try
      StringToFont(value, tmpFont);
      Result := True;
    except
    end;
  finally
    FreeAndNil(tmpFont);
  end;
end;

constructor TFontManager.Create;
begin
  inherited;
  FFontList := TStringList.Create;
end;

destructor TFontManager.Destroy;
begin
  FreeAndNil(FFontList);
  inherited;
end;

function TFontManager.FontToString(font: TFont): String;
var
  sStyle : String;
begin
  // convert font style to string
  sStyle := '';
  if (fsBold in font.Style) then
    sStyle := sStyle + csfsBold;
  if (fsItalic in font.Style ) then
    sStyle := sStyle + csfsItalic;
  if (fsUnderline in font.Style) then
    sStyle := sStyle + csfsUnderline;
  if (fsStrikeout in font.Style) then
    sStyle := sStyle + csfsStrikeout;

  if ((Length(sStyle) > 0) and ('|' = sStyle[1])) then
    sStyle := Copy(sStyle, 2, Length(sStyle) - 1);

  Result := Format('"%s", %d, [%s], [%s]',
    [font.Name, font.Size, sStyle, ColorToString(font.Color )]);
end;

function TFontManager.GetDefaultFontString(sActivity, sStatus: String): String;
var
  sStyle, sColor : String;
begin
  if sActivity = 'Sleeping' then
    sStyle := '[]'
  else
    sStyle := '[Italic]';

  if sStatus = 'Success' then
    sColor := '[clGreen]'
  else
    sColor := '[clRed]';

  Result := '"Arial", 36, ' + sStyle + ', ' + sColor;
end;

function TFontManager.GetFont(sActivity, sStatus: String): TFont;
var
  tmpFont : TFont;
  iIndex : Integer;
begin
  iIndex := FFontList.IndexOf(sActivity + '_' + sStatus);
  if iIndex < 0 then
  begin
    tmpFont := TFont.Create;
    StringToFont(DefaultFontString[sActivity, sStatus], tmpFont);
    SetFont(sActivity, sStatus, tmpFont);
  end;
  Result := TFont(FFontList.Objects[FFontList.IndexOf(sActivity + '_' + sStatus)]);
end;

function TFontManager.GetFontString(sActivity, sStatus: String): String;
begin
  Result := FontToString(GetFont(sActivity, sStatus));
end;

procedure TFontManager.RenameFont(sOldFontName, sNewFontName : string);
var
  i : Integer;
begin
  i := FFontList.IndexOf(sOldFontName);
  if i >= 0 then
    FFontList.Strings[i] := sNewFontName;
end;

end.
