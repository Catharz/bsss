unit ScreenSaverConfig;

interface

uses
  Registry, SysUtils, Classes,
  Project, FontManager;

const
  DefaultXmlFileURL          = 'file://../test.xml';
  DefaultUpdateFrequency     = 1; //Once a minute
  DefaultAnimationFrequency  = 5; //Once every 5 seconds

type
  EInvalidUrl = class(Exception);
  EInvalidUpdateFrequency = class(Exception);
  EInvalidAnimationFrequency = class(Exception);

  TValueType = (vtStandard, vtCustom);

  //TODO: Split out the Registry code into a repository and interface
  TScreenSaverConfig = class
  private
    FAnimationFrequency : Integer;
    FUpdateFrequency : Integer;
    FXmlFileURL : String;
    reg : TRegistry;
    FFontManager : TFontManager;
    FActivityList : TStringList;
    FStatusList : TStringList;
    function OpenRegistryKey(path: string) : Boolean;
    function ReadRegistryIntValue(path, key : String; default : Integer) : Integer;
    function WriteRegistryIntValue(path, key : String; value : Integer) : Boolean;
    function ReadRegistryStringValue(path, key, default : String) : String;
    function WriteRegistryStringValue(path, key, value : String) : Boolean;
    function GetCustomActivityList: String;
    function GetCustomStatusList: String;
    procedure LoadActivities;
    procedure LoadBuildStatuses;
    procedure LoadFonts;
    procedure LoadXmlFileUrl;
    procedure LoadUpdateFrequency;
    procedure LoadAnimationFrequency;
    procedure SaveFonts;
    procedure SaveXmlFileUrl;
    procedure SaveUpdateFrequency;
    procedure SaveAnimationFrequency;
    procedure SaveCustomActivities;
    procedure SaveCustomBuildStatuses;
  public
    constructor Create;
    destructor Destroy; reintroduce;

    function LoadConfig : Boolean;
    procedure SaveConfig;
    procedure Assign(config : TScreenSaverConfig);

    function ValidateActivity(value : String) : Boolean;
    function ActivityType(sActivity : string) : TValueType;
    procedure DeleteActivity(sActivity : string);
    procedure RenameActivity(sActivity, sNewActivity : string);

    function ValidateStatus(value : String) : Boolean;
    function StatusType(sStatus : string) : TValueType;
    procedure DeleteStatus(sStatus : string);
    procedure RenameStatus(sStatus, sNewStatus : string);

    function ValidateUpdateFrequency(value : Integer) : Boolean;
    function ValidateAnimationFrequency(value : Integer) : Boolean;
    function ValidateXmlFileURL(value: string) : Boolean;

    property CustomActivityList : String read GetCustomActivityList;
    property CustomStatusList : String read GetCustomStatusList;
    property ActivityList : TStringList read FActivityList write FActivityList;
    property StatusList : TStringList read FStatusList write FStatusList;
    property FontMgr : TFontManager read FFontManager write FFontManager;
    property AnimationFrequency : Integer read FAnimationFrequency write FAnimationFrequency;
    property UpdateFrequency : Integer read FUpdateFrequency write FUpdateFrequency;
    property XmlFileURL : String read FXmlFileURL write FXmlFileURL;
  end;

implementation

{ TScreenSaverConfig }

const
  RegistryPath         = '\Control Panel\Screen Saver.BuildStatus';
  DefaultActivities    = 'Sleeping,Building,CheckingModifications';
  DefaultBuildStatuses = 'Exception,Success,Failure,Unknown';

function TScreenSaverConfig.ActivityType(sActivity: string): TValueType;
var
  sl : TStringList;
begin
  Result := vtCustom;
  sl := TStringList.Create;
  try
    sl.CommaText := DefaultActivities;
    if (sl.IndexOf(sActivity) >= 0) then
      Result := vtStandard;
  finally
    FreeAndNil(sl);
  end;
end;

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
  FActivityList := TStringList.Create;
  FStatusList := TStringList.Create;
  FFontManager := TFontManager.Create;
end;

procedure TScreenSaverConfig.DeleteActivity(sActivity: string);
var
  i : Integer;
begin
  i := FActivityList.IndexOf(sActivity);
  if i >= 0 then
    FActivityList.Delete(i);
end;

procedure TScreenSaverConfig.DeleteStatus(sStatus: string);
var
  i : Integer;
begin
  i := FStatusList.IndexOf(sStatus);
  if i >= 0 then
    FStatusList.Delete(i);
end;

destructor TScreenSaverConfig.Destroy;
begin
  FreeAndNil(FFontManager);
  FreeAndNil(FActivityList);
  FreeAndNil(FStatusList);
  FreeAndNil(reg);
  inherited;
end;

function TScreenSaverConfig.GetCustomActivityList: String;
var
  i : Integer;
begin
  Result := '';
  for I := 0 to FActivityList.Count - 1 do
    if ActivityType(FActivityList[i]) = vtCustom then
      if Result = '' then
        Result := FActivityList[i]
      else
        Result := ',' + FActivityList[i];
end;

function TScreenSaverConfig.GetCustomStatusList: String;
var
  i : Integer;
begin
  Result := '';
  for I := 0 to FStatusList.Count - 1 do
    if StatusType(FStatusList[i]) = vtCustom then
      if Result = '' then
        Result := FStatusList[i]
      else
        Result := ',' + FStatusList[i];
end;

function TScreenSaverConfig.LoadConfig : Boolean;
begin
  Result := True;
  try
    LoadXmlFileUrl;
    LoadUpdateFrequency;
    LoadAnimationFrequency;
    LoadActivities;
    LoadBuildStatuses;
    LoadFonts;
  except
    Result := False;
  end;
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

procedure TScreenSaverConfig.RenameActivity(sActivity, sNewActivity: string);
var
  iActivity, iStatus : Integer;
  sOldFontKey, sNewFontKey : string;
begin
  //replace the fonts
  iActivity := FActivityList.IndexOf(sActivity);
  for iStatus := 0 to FStatusList.Count - 1 do
  begin
    sOldFontKey := FActivityList[iActivity] + '_' + FStatusList[iStatus];
    sNewFontKey := sNewActivity + '_' + FStatusList[iStatus];
    FFontManager.RenameFont(sOldFontKey, sNewFontKey);
  end;
  DeleteActivity(sActivity);
  FActivityList.Add(sNewActivity);
end;

procedure TScreenSaverConfig.RenameStatus(sStatus, sNewStatus: string);
var
  iActivity, iStatus : Integer;
  sOldFontKey, sNewFontKey : string;
begin
  //replace the fonts
  iStatus := FStatusList.IndexOf(sStatus);
  for iActivity := 0 to FActivityList.Count - 1 do
  begin
    sOldFontKey := FActivityList[iActivity] + '_' + FStatusList[iStatus];
    sNewFontKey := FActivityList[iActivity] + '_' + sNewStatus;
    FFontManager.RenameFont(sOldFontKey, sNewFontKey);
  end;
  DeleteStatus(sStatus);
  FStatusList.Add(sNewStatus);
end;

procedure TScreenSaverConfig.SaveConfig;
begin
  SaveXmlFileUrl;
  SaveUpdateFrequency;
  SaveAnimationFrequency;
  SaveCustomActivities;
  SaveCustomBuildStatuses;
  SaveFonts;
end;

function TScreenSaverConfig.StatusType(sStatus: string): TValueType;
var
  sl : TStringList;
begin
  Result := vtCustom;
  sl := TStringList.Create;
  try
    sl.CommaText := DefaultBuildStatuses;
    if (sl.IndexOf(sStatus) >= 0) then
      Result := vtStandard;
  finally
    FreeAndNil(sl);
  end;
end;

function TScreenSaverConfig.ValidateActivity(value: String): Boolean;
begin
  Result := FActivityList.IndexOf(value) >= 0;
end;

function TScreenSaverConfig.ValidateAnimationFrequency(value: Integer): Boolean;
begin
  Result := Value in [1..10];
end;

function TScreenSaverConfig.ValidateStatus(value: String): Boolean;
begin
  Result := FStatusList.IndexOf(value) >= 0;
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

procedure TScreenSaverConfig.SaveCustomBuildStatuses;
begin
  WriteRegistryStringValue(RegistryPath, 'CustomBuildStatuses', CustomStatusList);
end;

procedure TScreenSaverConfig.SaveCustomActivities;
begin
  WriteRegistryStringValue(RegistryPath, 'CustomActivities', CustomActivityList);
end;

procedure TScreenSaverConfig.SaveAnimationFrequency;
begin
  if not ValidateAnimationFrequency(FAnimationFrequency) then
    raise EInvalidAnimationFrequency.Create(IntToStr(FAnimationFrequency) + ' is not a valid Animation Frequency!');
  WriteRegistryIntValue(RegistryPath, 'AnimationFrequency', FAnimationFrequency);
end;

procedure TScreenSaverConfig.SaveUpdateFrequency;
begin
  if not ValidateUpdateFrequency(FUpdateFrequency) then
    raise EInvalidUpdateFrequency.Create(IntToStr(FUpdateFrequency) + ' is not a valid Update Frequency!');
  WriteRegistryIntValue(RegistryPath, 'UpdateFrequency', FUpdateFrequency);
end;

procedure TScreenSaverConfig.SaveXmlFileUrl;
begin
  if not ValidateXmlFileUrl(FXmlFileUrl) then
    raise EInvalidUrl.Create(FXmlFileUrl + ' is not a valid Url!');
  WriteRegistryStringValue(RegistryPath, 'XMLSource', FXmlFileUrl);
end;

procedure TScreenSaverConfig.SaveFonts;
var
  sFontKey: string;
  sFont: string;
  iStatus: Integer;
  iActivity: Integer;
begin
  //save the fonts from the FontManager
  for iActivity := 0 to FActivityList.Count - 1 do
  begin
    for iStatus := 0 to FStatusList.Count - 1 do
    begin
      sFontKey := FActivityList[iActivity] + '_' + FStatusList[iStatus];
      sFont := FFontManager.FontAsString[FActivityList[iActivity], FStatusList[iStatus]];
      WriteRegistryStringValue(RegistryPath + '\Fonts', sFontKey, sFont);
    end;
  end;
end;

procedure TScreenSaverConfig.LoadAnimationFrequency;
begin
  FAnimationFrequency := ReadRegistryIntValue(RegistryPath, 'AnimationFrequency', DefaultAnimationFrequency);
  if not ValidateAnimationFrequency(FAnimationFrequency) then
  begin
    FAnimationFrequency := DefaultAnimationFrequency;
    WriteRegistryIntValue(RegistryPath, 'AnimationFrequency', DefaultAnimationFrequency);
  end;
end;

procedure TScreenSaverConfig.LoadUpdateFrequency;
begin
  FUpdateFrequency := ReadRegistryIntValue(RegistryPath, 'UpdateFrequency', DefaultUpdateFrequency);
  if not ValidateUpdateFrequency(FUpdateFrequency) then
  begin
    FUpdateFrequency := DefaultUpdateFrequency;
    WriteRegistryIntValue(RegistryPath, 'UpdateFrequency', DefaultUpdateFrequency);
  end;
end;

procedure TScreenSaverConfig.LoadXmlFileUrl;
begin
  FXmlFileUrl := ReadRegistryStringValue(RegistryPath, 'XMLSource', DefaultXmlFileUrl);
  if not ValidateXmlFileUrl(FXmlFileUrl) then
  begin
    FXmlFileUrl := DefaultXmlFileUrl;
    WriteRegistryStringValue(RegistryPath, 'XMLSource', DefaultXmlFileUrl);
  end;
end;

procedure TScreenSaverConfig.LoadFonts;
var
  sFontKey: string;
  iStatus: Integer;
  sDefaultFont: string;
  sFont: string;
  iActivity: Integer;
begin
  //set the fonts in the FontManager
  for iActivity := 0 to FActivityList.Count - 1 do
  begin
    for iStatus := 0 to FStatusList.Count - 1 do
    begin
      sFontKey := FActivityList[iActivity] + '_' + FStatusList[iStatus];
      sDefaultFont := FFontManager.DefaultFontString[FActivityList[iActivity], FStatusList[iStatus]];
      sFont := ReadRegistryStringValue(RegistryPath + '\Fonts', sFontKey, sDefaultFont);
      FFontManager.FontAsString[FActivityList[iActivity], FStatusList[iStatus]] := sFont;
    end;
  end;
end;

procedure TScreenSaverConfig.LoadBuildStatuses;
var
  sStatusList: string;
begin
  //Load the list of statuses
  FStatusList.Clear;
  sStatusList := ReadRegistryStringValue(RegistryPath, 'CustomBuildStatuses', '');
  if sStatusList = '' then
    FStatusList.CommaText := DefaultBuildStatuses
  else
    FStatusList.CommaText := DefaultBuildStatuses + ',' + sStatusList;
end;

procedure TScreenSaverConfig.LoadActivities;
var
  sActivityList: string;
begin
  //Load the list of activities
  FActivityList.Clear;
  sActivityList := ReadRegistryStringValue(RegistryPath, 'CustomActivities', '');
  if sActivityList = '' then
    FActivityList.CommaText := DefaultActivities
  else
    FActivityList.CommaText := DefaultActivities + ',' + sActivityList;
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
