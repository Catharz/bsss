unit RegistryRepository;

interface

uses
  SettingsRepositoryInterface;

type
  TRegistryDAO=class(TInterfacedObject, ISettingsRepository)
  public
    procedure SaveStringValue(key, value, default : string);
    procedure SaveIntegerValue(key : string; value, default : integer);
    procedure LoadStringValue(key : string; var value : string; default : string; shouldCreate : boolean);
    procedure LoadIntegerValue(key : string; var value : integer; default : integer; shouldCreate : boolean);
  end;

implementation

{ TRegistryRepository }

procedure TRegistryDAO.LoadIntegerValue(key: string; var value: integer;
  default: integer; shouldCreate: boolean);
begin

end;

procedure TRegistryDAO.LoadStringValue(key: string; var value: string;
  default: string; shouldCreate: boolean);
begin

end;

procedure TRegistryDAO.SaveIntegerValue(key: string; value,
  default: integer);
begin

end;

procedure TRegistryDAO.SaveStringValue(key, value, default: string);
begin

end;

end.
