unit ScreenSaverConfig;

interface

uses
  Registry, SysUtils;

const
  DefaultXmlFileURL         = 'file://../test.xml';
  DefaultUpdateFrequency    = 1; //Once a minute
  DefaultAnimationFrequency = 5; //Once every 5 seconds

type
  EInvalidUrl = class(Exception);
  EInvalidUpdateFrequency = class(Exception);
  EInvalidAnimationFrequency = class(Exception);

  TScreenSaverConfig=class
  private
    FAnimationFrequency : Integer;
    FUpdateFrequency : Integer;
    FXmlFileURL : String;
    reg : TRegistry;
    function OpenRegistryKey(path: string) : Boolean;
    function ReadRegistryIntValue(path, key : String; default : Integer) : Integer;
    function WriteRegistryIntValue(path, key : String; value : Integer) : Boolean;
    function ReadRegistryStringValue(path, key, default : String) : String;
    function WriteRegistryStringValue(path, key, value : String) : Boolean;
  public
    constructor Create;
    destructor Destroy; reintroduce;

    function LoadConfig : Boolean;
    procedure SaveConfig;
    procedure Assign(config : TScreenSaverConfig);

    function ValidateUpdateFrequency(value : Integer) : Boolean;
    function ValidateAnimationFrequency(value : Integer) : Boolean;
    function ValidateXmlFileURL(value: string) : Boolean;

    property AnimationFrequency : Integer read FAnimationFrequency write FAnimationFrequency;
    property UpdateFrequency : Integer read FUpdateFrequency write FUpdateFrequency;
    property XmlFileURL : String read FXmlFileURL write FXmlFileURL;
  end;

implementation

{ TScreenSaverConfig }

const
  RegistryPath              = '\Control Panel\Screen Saver.BuildStatus';

procedure TScreenSaverConfig.Assign(config: TScreenSaverConfig);
begin
  FXmlFileUrl := config.XmlFileURL;
  FUpdateFrequency := config.UpdateFrequency;
  FAnimationFrequency := config.AnimationFrequency;
end;

constructor TScreenSaverConfig.Create;
begin
  inherited;
  reg := TRegistry.Create;
end;

destructor TScreenSaverConfig.Destroy;
begin
  FreeAndNil(reg);
  inherited;
end;

function TScreenSaverConfig.LoadConfig : Boolean;
begin
  FXmlFileUrl := ReadRegistryStringValue(RegistryPath, 'XMLSource', DefaultXmlFileUrl);
  FUpdateFrequency := ReadRegistryIntValue(RegistryPath, 'UpdateFrequency', DefaultUpdateFrequency);
  FAnimationFrequency := ReadRegistryIntValue(RegistryPath, 'AnimationFrequency', DefaultAnimationFrequency);

  //Validate the values.
  //If a value isn't valid, set it to the default and save it
  if not ValidateXmlFileUrl(FXmlFileUrl) then
  begin
    FXmlFileUrl := DefaultXmlFileUrl;
    WriteRegistryStringValue(RegistryPath, 'XMLSource', DefaultXmlFileUrl);
  end;
  if not ValidateUpdateFrequency(FUpdateFrequency) then
  begin
    FUpdateFrequency := DefaultUpdateFrequency;
    WriteRegistryIntValue(RegistryPath, 'UpdateFrequency', DefaultUpdateFrequency);
  end;
  if not ValidateAnimationFrequency(FAnimationFrequency) then
  begin
    FAnimationFrequency := DefaultAnimationFrequency;
    WriteRegistryIntValue(RegistryPath, 'AnimationFrequency', DefaultAnimationFrequency);
  end;
  Result := True;
end;

function TScreenSaverConfig.OpenRegistryKey(path: string): Boolean;
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

function TScreenSaverConfig.ReadRegistryIntValue(path, key: String;
  default: Integer): Integer;
begin
  if not OpenRegistryKey(path) then
  begin
    Result := 0;
    Exit;
  end;
  if not reg.ValueExists(key) then
    reg.WriteInteger(key, default);
  Result := reg.ReadInteger(key);
end;

function TScreenSaverConfig.ReadRegistryStringValue(path, key,
  default: String): String;
begin
  if not OpenRegistryKey(path) then
  begin
    Result := '';
    Exit;
  end;
  if not reg.ValueExists(key) then
    reg.WriteString(key, default);
  Result := reg.ReadString(key);
end;

procedure TScreenSaverConfig.SaveConfig;
begin
  if not ValidateXmlFileUrl(FXmlFileUrl) then
    Raise EInvalidUrl.Create(FXmlFileUrl + ' is not a valid Url!');
  if not ValidateUpdateFrequency(FUpdateFrequency) then
    Raise EInvalidUpdateFrequency.Create(IntToStr(FUpdateFrequency) + ' is not a valid Update Frequency!');
  if not ValidateAnimationFrequency(FAnimationFrequency) then
    Raise EInvalidAnimationFrequency.Create(IntToStr(FAnimationFrequency) + ' is not a valid Animation Frequency!');

  WriteRegistryStringValue(RegistryPath, 'XMLSource', FXmlFileUrl);
  WriteRegistryIntValue(RegistryPath, 'UpdateFrequency', FUpdateFrequency);
  WriteRegistryIntValue(RegistryPath, 'AnimationFrequency', FAnimationFrequency);
end;

function TScreenSaverConfig.ValidateAnimationFrequency(value: Integer): Boolean;
begin
  Result := Value in [1..10];
end;

function TScreenSaverConfig.ValidateUpdateFrequency(value: Integer): Boolean;
begin
  Result := value in [0..10];
end;

function TScreenSaverConfig.ValidateXmlFileURL(value: string): Boolean;
begin
  Result := (Copy(value, 0, 7) = 'http://') or
    (Copy(value, 0, 7) = 'file://') or
    (Copy(value, 0, 8) = 'file:///'); //For some reason, some browsers put 3 slashes in
end;

function TScreenSaverConfig.WriteRegistryIntValue(path, key: String;
  value: Integer): Boolean;
begin
  if not OpenRegistryKey(path) then
  begin
    Result := False;
    Exit;
  end;
  reg.WriteInteger(key, value);
  Result := True;
end;

function TScreenSaverConfig.WriteRegistryStringValue(path, key,
  value: String): Boolean;
begin
  if not OpenRegistryKey(path) then
  begin
    Result := False;
    Exit;
  end;
  reg.WriteString(key, value);
  Result := True;
end;

end.
