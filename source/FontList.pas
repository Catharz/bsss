unit FontList;

interface

uses
  Classes, Graphics, SysUtils, Contnrs;

type
  TFontList = class
  strict private
    FInternalFontList : TObjectList;
    function FontExists(sActivity, sStatus : String; var Index : Integer) : Boolean;
    procedure AddFont(sActivity, sStatus, sFont : String); overload;
    procedure AddFont(sActivity, sStatus : String; fFont : TFont); overload;
    function GetFont(sActivity, sStatus: String): TFont;
    procedure SetFont(sActivity, sStatus: String; const Value: TFont);
    function GetFontString(sActivity, sStatus: String): String;
    procedure SetFontString(sActivity, sStatus: String; const Value: String);
    function GetDefaultFontString(sActivity : String = 'Sleeping'; sStatus: String = 'Failed'): String;
  public
    constructor Create;
    destructor Destroy; override;

    procedure RenameFont(sOldActivity, sNewActivity, sOldStatus, sNewStatus: string);
    function IndexOf(sActivity, sStatus : string) : Integer;
    procedure Assign(AFontList : TFontList);

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
  iPos : Integer;
begin
  if FontExists(sActivity, sStatus, iPos) then
    TActivityStatusFont(FInternalFontList[iPos]).Font.Assign(Value)
  else
    AddFont(sActivity, sStatus, Value);
end;

procedure TFontList.SetFontString(sActivity, sStatus: String;
  const Value: String);
var
  iPos : Integer;
begin
  if FontExists(sActivity, sStatus, iPos) then
    TActivityStatusFont(FInternalFontList[iPos]).FontAsString := Value
  else
    AddFont(sActivity, sStatus, Value);
end;

procedure TFontList.AddFont(sActivity, sStatus, sFont: String);
var
  asf : TActivityStatusFont;
begin
  asf := TActivityStatusFont.Create(sActivity, sStatus, sFont);
  FInternalFontList.Add(asf);
end;

procedure TFontList.AddFont(sActivity, sStatus: String; fFont: TFont);
var
  asf : TActivityStatusFont;
begin
  asf := TActivityStatusFont.Create(sActivity, sStatus, fFont);
  FInternalFontList.Add(asf);
end;

procedure TFontList.Assign(AFontList: TFontList);
begin
  FreeAndNil(FInternalFontList);
  FInternalFontList := TObjectList.Create(True);
  FInternalFontList.Assign(AFontList.FontList);
end;

constructor TFontList.Create;
begin
  inherited;
  FInternalFontList := TObjectList.Create(True);
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

function TFontList.FontExists(sActivity, sStatus : String; var Index : Integer): Boolean;
begin
  Index := IndexOf(sActivity, sStatus);
  Result := Index >= 0;
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
  iPos : Integer;
begin
  if FontExists(sActivity, sStatus, iPos) then
    Result := TActivityStatusFont(FInternalFontList[iPos]).Font
  else
  begin
    AddFont(sActivity, sStatus, DefaultFontString[sActivity, sStatus]);
    iPos := IndexOf(sActivity, sStatus);
    Result := TActivityStatusFont(FInternalFontList[iPos]).Font;
  end;
end;

function TFontList.GetFontString(sActivity, sStatus: String): String;
var
  iPos : Integer;
begin
  if FontExists(sActivity, sStatus, iPos) then
    Result := TActivityStatusFont(FInternalFontList[iPos]).FontAsString
  else
    Result := GetDefaultFontString(sActivity, sStatus);
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
