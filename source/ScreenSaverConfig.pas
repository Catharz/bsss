unit ScreenSaverConfig;

interface

uses
  SysUtils, Classes,
  Project, FontList, I_SettingsRepository;

const
  DefaultXmlFileURL          = 'file://../test.xml';
  DefaultUpdateFrequency     = 1; //Once a minute
  DefaultAnimationFrequency  = 5; //Once every 5 seconds

type
  EInvalidUrl = class(Exception);
  EInvalidUpdateFrequency = class(Exception);
  EInvalidAnimationFrequency = class(Exception);

  TValueType = (vtStandard, vtCustom);

  TScreenSaverConfig = class
  private
    FAnimationFrequency : Integer;
    FUpdateFrequency : Integer;
    FXmlFileURL : String;
    FFontList : TFontList;
    FActivityList : TStringList;
    FStatusList : TStringList;
    FSettings : ISettingsRepository;
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
    constructor Create(settingsDAO : ISettingsRepository);
    destructor Destroy; override;

    function LoadConfig : Boolean;
    procedure SaveConfig;
    procedure Assign(config : TScreenSaverConfig);

    //TODO: Create activity and status collection classes
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
    property FontList : TFontList read FFontList write FFontList;
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
  FActivityList.Assign(config.ActivityList);
  FStatusList.Assign(config.StatusList);
  FFontList.Assign(config.FontList);
end;

constructor TScreenSaverConfig.Create(settingsDAO : ISettingsRepository);
begin
  inherited Create;
  FSettings := settingsDAO;
  FActivityList := TStringList.Create;
  FStatusList := TStringList.Create;
  FFontList := TFontList.Create;
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
  FreeAndNil(FFontList);
  FreeAndNil(FActivityList);
  FreeAndNil(FStatusList);
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

procedure TScreenSaverConfig.RenameActivity(sActivity, sNewActivity: string);
var
  iStatus : Integer;
begin
  //replace the fonts
  for iStatus := 0 to FStatusList.Count - 1 do
    FFontList.RenameFont(sActivity, sNewActivity, FStatusList[iStatus], FStatusList[iStatus]);
  DeleteActivity(sActivity);
  FActivityList.Add(sNewActivity);
end;

procedure TScreenSaverConfig.RenameStatus(sStatus, sNewStatus: string);
var
  iActivity : Integer;
begin
  //replace the fonts
  for iActivity := 0 to FActivityList.Count - 1 do
    FFontList.RenameFont(FActivityList[iActivity], FActivityList[iActivity], sStatus, sNewStatus);
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
  FSettings.WriteStringValue(RegistryPath, 'CustomBuildStatuses', CustomStatusList);
end;

procedure TScreenSaverConfig.SaveCustomActivities;
begin
  FSettings.WriteStringValue(RegistryPath, 'CustomActivities', CustomActivityList);
end;

procedure TScreenSaverConfig.SaveAnimationFrequency;
begin
  if not ValidateAnimationFrequency(FAnimationFrequency) then
    raise EInvalidAnimationFrequency.Create(IntToStr(FAnimationFrequency) + ' is not a valid Animation Frequency!');
  FSettings.WriteIntegerValue(RegistryPath, 'AnimationFrequency', FAnimationFrequency);
end;

procedure TScreenSaverConfig.SaveUpdateFrequency;
begin
  if not ValidateUpdateFrequency(FUpdateFrequency) then
    raise EInvalidUpdateFrequency.Create(IntToStr(FUpdateFrequency) + ' is not a valid Update Frequency!');
  FSettings.WriteIntegerValue(RegistryPath, 'UpdateFrequency', FUpdateFrequency);
end;

procedure TScreenSaverConfig.SaveXmlFileUrl;
begin
  if not ValidateXmlFileUrl(FXmlFileUrl) then
    raise EInvalidUrl.Create(FXmlFileUrl + ' is not a valid Url!');
  FSettings.WriteStringValue(RegistryPath, 'XMLSource', FXmlFileUrl);
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
      sFont := FFontList.FontAsString[FActivityList[iActivity], FStatusList[iStatus]];
      FSettings.WriteStringValue(RegistryPath + '\Fonts', sFontKey, sFont);
    end;
  end;
end;

procedure TScreenSaverConfig.LoadAnimationFrequency;
begin
  FSettings.ReadIntegerValue(RegistryPath, 'AnimationFrequency', FAnimationFrequency, DefaultAnimationFrequency);
  if not ValidateAnimationFrequency(FAnimationFrequency) then
  begin
    FAnimationFrequency := DefaultAnimationFrequency;
    FSettings.WriteIntegerValue(RegistryPath, 'AnimationFrequency', DefaultAnimationFrequency);
  end;
end;

procedure TScreenSaverConfig.LoadUpdateFrequency;
begin
  FSettings.ReadIntegerValue(RegistryPath, 'UpdateFrequency', FUpdateFrequency, DefaultUpdateFrequency);
  if not ValidateUpdateFrequency(FUpdateFrequency) then
  begin
    FUpdateFrequency := DefaultUpdateFrequency;
    FSettings.WriteIntegerValue(RegistryPath, 'UpdateFrequency', DefaultUpdateFrequency);
  end;
end;

procedure TScreenSaverConfig.LoadXmlFileUrl;
begin
  FSettings.ReadStringValue(RegistryPath, 'XMLSource', FXmlFileUrl, DefaultXmlFileUrl);
  if not ValidateXmlFileUrl(FXmlFileUrl) then
  begin
    FXmlFileUrl := DefaultXmlFileUrl;
    FSettings.WriteStringValue(RegistryPath, 'XMLSource', DefaultXmlFileUrl);
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
      sDefaultFont := FFontList.DefaultFontString[FActivityList[iActivity], FStatusList[iStatus]];
      FSettings.ReadStringValue(RegistryPath + '\Fonts', sFontKey, sFont, sDefaultFont);
      FFontList.FontAsString[FActivityList[iActivity], FStatusList[iStatus]] := sFont;
    end;
  end;
end;

procedure TScreenSaverConfig.LoadBuildStatuses;
var
  sStatusList: string;
begin
  //Load the list of statuses
  FStatusList.Clear;
  FSettings.ReadStringValue(RegistryPath, 'CustomBuildStatuses', sStatusList, '');
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
  FSettings.ReadStringValue(RegistryPath, 'CustomActivities', sActivityList, '');
  if sActivityList = '' then
    FActivityList.CommaText := DefaultActivities
  else
    FActivityList.CommaText := DefaultActivities + ',' + sActivityList;
end;

end.
