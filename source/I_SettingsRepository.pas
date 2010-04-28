unit I_SettingsRepository;

interface

type
  ISettingsRepository=Interface
    procedure WriteStringValue(path, key, value: string);
    procedure WriteIntegerValue(path, key: string; value: Integer);
    procedure ReadStringValue(path, key : string; var value : string; default : string);
    procedure ReadIntegerValue(path, key : string; var value : integer; default : integer);
  end;

implementation

end.
