unit RegistryDAO;

interface

uses
  Registry,
  I_SettingsRepository;

type
  TRegistryDAO=class(TInterfacedObject, ISettingsRepository)
  private
    reg : TRegistry;
    function OpenRegistryKey(path: string) : Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteStringValue(path, key, value: string);
    procedure WriteIntegerValue(path, key: string; value: Integer);
    procedure ReadStringValue(path, key : string; var value : string; default : string);
    procedure ReadIntegerValue(path, key : string; var value : integer; default : integer);
  end;

implementation

uses
  SysUtils;

{ TRegistryDAO }

constructor TRegistryDAO.Create;
begin
  inherited;
  reg := TRegistry.Create;
end;

destructor TRegistryDAO.Destroy;
begin
  FreeAndNil(reg);
  inherited;
end;

function TRegistryDAO.OpenRegistryKey(path: string): Boolean;
begin
  //If the key doesn't exist, then create it
  if not reg.KeyExists(path) then
  begin
    if not reg.CreateKey(path) then
    begin
      Result := False;
      Exit;
    end;
  end;

  //Open the key
  if not reg.OpenKey(path, False) then
  begin
    Result := False;
    Exit;
  end;
  Result := True;
end;

procedure TRegistryDAO.ReadIntegerValue(path, key: string; var value: integer;
  default: integer);
begin
  if not OpenRegistryKey(path) then
  begin
    value := 0;
    Exit;
  end;
  if not reg.ValueExists(key) then
    reg.WriteInteger(key, default);
  value := reg.ReadInteger(key);
end;

procedure TRegistryDAO.ReadStringValue(path, key: string; var value: string;
  default: string);
begin
  if not OpenRegistryKey(path) then
  begin
    value := '';
    Exit;
  end;
  if not reg.ValueExists(key) then
    reg.WriteString(key, default);
  value := reg.ReadString(key);
end;

procedure TRegistryDAO.WriteIntegerValue(path, key: string; value: Integer);
begin
  if OpenRegistryKey(path) then
    reg.WriteInteger(key, value);
end;

procedure TRegistryDAO.WriteStringValue(path, key, value: string);
begin
  if OpenRegistryKey(path) then
    reg.WriteString(key, value);
end;

end.
