unit FontList;

interface

uses
  Classes, Graphics, SysUtils, Contnrs;

type
  EFontConversionError = class(Exception);
  TFontList = class
  private
    FInternalFontList : TObjectList;
    procedure DeleteFont(sActivity, sStatus : string);
    function GetFont(sActivity, sStatus: String): TFont;
    procedure SetFont(sActivity, sStatus: String; const Value: TFont);
    function GetFontString(sActivity, sStatus: String): String;
    procedure SetFontString(sActivity, sStatus: String; const Value: String);
    function GetDefaultFontString(sActivity : String = 'Sleeping'; sStatus: String = 'Failed'): String;
  public
    constructor Create;
    destructor Destroy; override;
    function ValidateFont(value : string) : Boolean;
    function FontToString(font : TFont): String;
    procedure StringToFont(sFont : String; var font : TFont);
    procedure RenameFont(sOldActivity, sNewActivity, sOldStatus, sNewStatus: string);
    function IndexOf(sActivity, sStatus : string) : Integer;

    property FontList : TObjectList read FInternalFontList;
    property Font[sActivity, sStatus : String] : TFont read GetFont write SetFont;
    property FontAsString[sActivity, sStatus : String] : String read GetFontString write SetFontString;
    property DefaultFontString[sActivity, sStatus : String] : String read GetDefaultFontString;
  end;

implementation

{ TFontManager }

uses
  ActivityStatusFont;

const
  csfsBold      = '|Bold';
  csfsItalic    = '|Italic';
  csfsUnderline = '|Underline';
  csfsStrikeout = '|Strikeout';

procedure TFontList.SetFont(sActivity, sStatus: String; const Value: TFont);
var
  asf : TActivityStatusFont;
  iPos : Integer;
begin
  iPos := IndexOf(sActivity, sStatus);
  if iPos >= 0 then
  begin
    asf := TActivityStatusFont(FInternalFontList[iPos]);
    asf.Font := Value;
  end
  else
  begin
    asf := TActivityStatusFont.Create(sActivity, sStatus, FontToString(Value));
    FInternalFontList.Add(asf);
  end;
end;

procedure TFontList.SetFontString(sActivity, sStatus: String;
  const Value: String);
var
  tmpFont : TFont;
begin
  //TODO: Create a cleaner way of setting this
  tmpFont := TFont.Create;
  DeleteFont(sActivity, sStatus);
  StringToFont(Value, tmpFont);
  SetFont(sActivity, sStatus, tmpFont);
  FreeAndNil(tmpFont);
end;

procedure TFontList.StringToFont(sFont: String; var font: TFont);
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

function TFontList.ValidateFont(value: string): Boolean;
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

constructor TFontList.Create;
begin
  inherited;
  FInternalFontList := TObjectList.Create(True);
end;

procedure TFontList.DeleteFont(sActivity, sStatus: string);
var
  iPos : Integer;
begin
  iPos := IndexOf(sActivity, sStatus);
  if iPos >= 0 then
    FInternalFontList.Delete(iPos);
end;

destructor TFontList.Destroy;
var
  i : Integer;
begin
  for i := FInternalFontList.Count - 1 downto 0 do
    FInternalFontList.Delete(i);

  FreeAndNil(FInternalFontList);
  inherited;
end;

function TFontList.FontToString(font: TFont): String;
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

function TFontList.GetDefaultFontString(sActivity, sStatus: String): String;
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

function TFontList.GetFont(sActivity, sStatus: String): TFont;
var
  tmpFont : TFont;
  iPos : Integer;
begin
  iPos := IndexOf(sActivity, sStatus);
  if iPos < 0 then
  begin
    tmpFont := TFont.Create;
    StringToFont(DefaultFontString[sActivity, sStatus], tmpFont);
    SetFont(sActivity, sStatus, tmpFont);
  end;
  iPos := IndexOf(sActivity, sStatus);
  Result := TActivityStatusFont(FInternalFontList[iPos]).Font;
end;

function TFontList.GetFontString(sActivity, sStatus: String): String;
begin
  Result := FontToString(GetFont(sActivity, sStatus));
end;

function TFontList.IndexOf(sActivity, sStatus: string): Integer;
var
  iPos : Integer;
  asf : TActivityStatusFont;
  bFound : Boolean;
begin
  bFound := False;
  for iPos := 0 to FInternalFontList.Count - 1 do
  begin
    asf := TActivityStatusFont(FInternalFontList[iPos]);
    if (asf.Activity = sActivity) and (asf.Status = sStatus) then
    begin
      bFound := True;
      Break;
    end;
  end;
  if bFound then
    Result := iPos
  else
    Result := -1;
end;

procedure TFontList.RenameFont(sOldActivity, sNewActivity, sOldStatus, sNewStatus: string);
var
  iPos : Integer;
  asf : TActivityStatusFont;
begin
  iPos := IndexOf(sOldActivity, sOldStatus);
  if iPos >= 0 then
  begin
    asf := TActivityStatusFont(FInternalFontList[iPos]);
    asf.Activity := sNewActivity;
    asf.Status := sNewStatus;
  end;
end;

end.
