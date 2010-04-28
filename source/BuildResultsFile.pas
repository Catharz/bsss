unit BuildResultsFile;

interface

uses
  ScreenSaverConfig, ProjectList;

type
  TBuildResultsFile = class
    FTempFileName : String;
    FConfig : TScreenSaverConfig;
  private
    procedure GetXMLFile(const xmlFileURL, localFileName: String);
    procedure CreateDummyFile(const localFileName: string; const message: string);
    function Download(const localFileName: string; hURL: Pointer) : Boolean;
    function DidFileExist(const localFileName: string) : Boolean;
  public
    constructor Create(config : TScreenSaverConfig); overload;
    procedure Load(sFileName: string; var projectList: TProjectList);
    function FileUrlToPath(sFileName: string) : String;
    procedure ParseXML(var projectList: TProjectList);
  end;

implementation

uses
  SysUtils,
  Classes,
  OmniXML,
  WinInet,
  Windows,
  Types,
  Forms,
  Dialogs,
  Project;

{ TBuildResultsFile }

constructor TBuildResultsFile.Create(config: TScreenSaverConfig);
begin
  inherited Create;
  FConfig := config;
  FTempFileName := GetEnvironmentVariable('TEMP') + '\projects.xml';
end;

procedure TBuildResultsFile.CreateDummyFile(const localFileName: string; const message: string);
var
  sl: TStringList;
  sActivity, sStatus : String;
  iActivity, iStatus : Integer;
begin
  //Write a dummy XML file showing the provided message and demonstrate the possible values
  sl := TStringList.Create;
  sl.SaveToFile(localFileName);
  try
    sl.Add('<Projects>');
    sl.Add('<Project activity="Sleeping" lastBuildStatus="Failure" lastBuildTime="2010-01-01T12:30:00.0000000+10:00" webUrl="http://loclahost/" name="' + message + '"/>');
    for iActivity := 0 to FConfig.ActivityList.Count - 1 do
    begin
      for iStatus := 0 to FConfig.StatusList.Count - 1 do
      begin
        sActivity := FConfig.ActivityList[iActivity];
        sStatus := FConfig.StatusList[iStatus];
        sl.Add('<Project activity="' + sActivity + '" lastBuildStatus = "' + sStatus + '"' +
          ' lastBuildTime="2010-01-01T12:30:00.0000000+10:00" webUrl="http://loclahost/" name="' + sActivity + ' ' + sStatus + '"/>');
      end;
    end;

    sl.Add('</Projects>');
    sl.SaveToFile(localFileName);
  finally
    FreeAndNil(sl);
  end;
end;

function TBuildResultsFile.Download(const localFileName: string;
  hURL: Pointer): Boolean;
const
  BufferSize = 1024;
var
  Buffer: array[1..1024] of Byte;
  f: file;
  BufferLen: Cardinal;
begin
  //This should not have been called with a nil URL
  if hURL = nil then
  begin
    Result := False;
    Exit;
  end;
  try
    AssignFile(f, localFileName);
    try
      Rewrite(f, 1);
      repeat
        InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
        BlockWrite(f, Buffer, BufferLen);
      until BufferLen = 0;
    finally
      CloseFile(f);
    end;
    Result := DidFileExist(localFileName);
  finally
    InternetCloseHandle(hURL);
  end;
end;

procedure TBuildResultsFile.GetXMLFile(const xmlFileURL,
  localFileName: String);
var
  hSession, hURL: HInternet;
  sAppName: string;
begin
  sAppName := ExtractFileName(Application.ExeName) ;
  hSession := InternetOpen(PChar(sAppName), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0) ;
  try
    hURL := InternetOpenURL(hSession, PChar(xmlFileURL), nil, 0, 0, 0) ;
    if hURL <> nil then
    begin
      if not Download(localFileName, hURL) then
        CreateDummyFile(localFileName, 'ERROR: 404 File Not Found!');
    end
    else
      CreateDummyFile(localFileName, 'ERROR: No Network Connection!');
  finally
    InternetCloseHandle(hSession);
  end
end;

procedure TBuildResultsFile.Load(sFileName: string; var projectList: TProjectList);
var
  sTempFileName : String;
begin
  if (LowerCase(Copy(sFileName, 0, 7)) = 'file://') then
    sTempFileName := FileUrlToPath(sFileName)
  else
    sTempFileName := sFileName;

  GetXMLFile(sFileName, FTempFileName);
  ParseXML(projectList);
end;

procedure TBuildResultsFile.ParseXML(var projectList: TProjectList);
var
  FXMLDocument : IXMLDocument;
  queryNode    : IXMLNode;
  nodeList     : IXMLNodeList;
  nodeMap : IXMLNamedNodeMap;
  i : Integer;
  tmpProject : TProject;
  stream : TFileStream;
begin
  projectList.Clear;
  FXMLDocument := CreateXMLDoc;
  stream := TFileStream.Create(FTempFileName, fmOpenRead);
  try
    if not FXMLDocument.LoadFromStream(stream) then
      raise Exception.Create('Source document is not valid');
    queryNode := FXMLDocument.DocumentElement;
    queryNode.SelectNodes('/Projects/Project', nodeList); //Select all the projects
    for i := 0 to nodeList.Length - 1do
    begin
      nodeMap := nodeList.Item[i].Attributes;
      tmpProject := TProject.Create;
      tmpProject.Name := nodeMap.GetNamedItem('name').NodeValue;
      tmpProject.Activity := nodeMap.GetNamedItem('activity').NodeValue;
      tmpProject.BuildStatus := nodeMap.GetNamedItem('lastBuildStatus').NodeValue;
      tmpProject.BuildTime := nodeMap.GetNamedItem('lastBuildTime').NodeValue;
      tmpProject.URL := nodeMap.GetNamedItem('webUrl').NodeValue;
      projectList.Add(tmpProject);
    end;
  finally
    FreeAndNil(stream);
  end;
end;

function TBuildResultsFile.DidFileExist(const localFileName: string) : Boolean;
var
  iPos: Integer;
  sl: TStringList;
  b404: Boolean;
begin
  //Check for a 404
  sl := TStringList.Create;
  b404 := False;
  try
    sl.LoadFromFile(localFileName);
    for iPos := 0 to sl.Count - 1 do
      if Pos('404 Not Found', sl[iPos]) > 0 then
      begin
        b404 := True;
        Break;
      end;
  finally
    FreeAndNil(sl);
  end;
  Result := (not b404);
end;

function TBuildResultsFile.FileUrlToPath(sFileName: string): String;
var
  ReturnValue : String;
  iStart : Integer;
begin
  if (Copy(sFileName, 0, 8) = 'file:///') then
    iStart := 9
  else
    if (Copy(sFileName, 0, 7) = 'file://') then
      iStart := 8
    else
      Raise EInvalidUrl.Create(sFileName + ' is not a valid file Url');
  ReturnValue := Copy(sFileName, iStart, length(sFileName) - iStart + 1);
  ReturnValue := StringReplace(ReturnValue, '/', '\', [rfReplaceAll]);
  ReturnValue := StringReplace(ReturnValue, '%20', ' ', [rfReplaceAll]);

  Result := ReturnValue;
end;

end.
