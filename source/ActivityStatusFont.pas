unit ActivityStatusFont;

interface

uses
  Graphics, SysUtils;

type
  EFontConversionError = class(Exception);
  TActivityStatusFont=class
  private
    FActivity : String;
    FStatus : String;
    FFont : TFont;
    procedure SetFont(const Value: TFont);
    function GetFontAsString: String;
    procedure SetFontAsString(const sFont: String);
  public
    constructor Create(sActivity, sStatus, sFont : String); overload;
    constructor Create(sActivity, sStatus : String; AFont : TFont); overload;
    destructor Destroy; override;

    function IsEqualTo(const Value : TActivityStatusFont) : Boolean;

    property Activity : String read FActivity write FActivity;
    property Status : String read FStatus write FStatus;
    property Font : TFont read FFont write SetFont;
    property FontAsString : String read GetFontAsString write SetFontAsString;
  end;

implementation

{ TActivityStatusFont }

uses
  FontList;

const
  csfsBold      = '|Bold';
  csfsItalic    = '|Italic';
  csfsUnderline = '|Underline';
  csfsStrikeout = '|Strikeout';

constructor TActivityStatusFont.Create(sActivity, sStatus, sFont: String);
begin
  inherited Create;
  FActivity := sActivity;
  FStatus := sStatus;
  FFont := TFont.Create;
  self.FontAsString := sFont;
end;

constructor TActivityStatusFont.Create(sActivity, sStatus: String;
  AFont: TFont);
begin
  inherited Create;
  FActivity := sActivity;
  FStatus := sStatus;
  FFont := AFont;
end;

destructor TActivityStatusFont.Destroy;
begin
  FreeAndNil(FFont);
  inherited;
end;

function TActivityStatusFont.IsEqualTo(const Value: TActivityStatusFont): Boolean;
begin
  Result := (Value.Activity = self.Activity) and
            (Value.Status = self.Status) and
            (Value.GetFontAsString = self.GetFontAsString);
end;

function TActivityStatusFont.GetFontAsString: String;
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
    [FFont.Name, FFont.Size, sStyle, ColorToString(FFont.Color )]);
end;

procedure TActivityStatusFont.SetFont(const Value: TFont);
begin
  FFont.Name := Value.Name;
  FFont.Size := Value.Size;
  FFont.Style := Value.Style;
  FFont.Color := Value.Color;
end;

procedure TActivityStatusFont.SetFontAsString(const sFont: String);
var
  p      : integer;
  sStyle : string;
  sTempFont : string;
begin
  try
    // get font name
    sTempFont := sFont;
    p := Pos(',', sTempFont);
    FFont.Name := Copy(sTempFont, 2, p - 3);
    Delete(sTempFont, 1, p);

    // get font size
    p := Pos(',', sTempFont);
    FFont.Size := StrToInt(Copy(sTempFont, 2, p - 2));
    Delete(sTempFont, 1, p);

    // get font style
    p := Pos(',', sTempFont);
    sStyle := '|' + Copy(sTempFont, 3, p - 4);
    Delete(sTempFont, 1, p);

    // get font color
    FFont.Color := StringToColor(Copy(sTempFont, 3, Length(sTempFont) - 3));

    // convert str font style to font style
    FFont.Style := [];

    if (Pos(csfsBold, sStyle) > 0) then
      FFont.Style := FFont.Style + [fsBold];

    if (Pos(csfsItalic, sStyle ) > 0) then
      FFont.Style := FFont.Style + [fsItalic];

    if (Pos(csfsUnderline, sStyle) > 0) then
      FFont.Style := FFont.Style + [fsUnderline];

    if (Pos(csfsStrikeout, sStyle) > 0) then
      FFont.Style := FFont.Style + [fsStrikeout];
  except
    on e: Exception do
      raise EFontConversionError.Create(e.Message);
  end;
end;

end.
