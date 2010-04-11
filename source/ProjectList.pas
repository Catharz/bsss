unit ProjectList;

interface

uses
  Contnrs, Classes, Project;

type
  TProjectList = class(TObject)
    FTempFileName : String;
    FObjectList : TObjectList;
  private
    function GetCount: Integer;
    function GetXMLFile(const xmlFileURL, localFileName: String): Boolean;
    procedure CreateDummyFile(const localFileName: string);
    function DownloadFile(const localFileName: string; hURL: Pointer) : Boolean;
  protected
    function GetItem(Index: Integer): TProject;
    procedure SetItem(Index: Integer; const Value: TProject);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(buildProject : TProject) : Integer;
    function Remove(proj: TProject): Integer;
    function IndexOf(proj: TProject): Integer;
    procedure loadFromFile(sFileName : String);
    function FileURLToPath(sFileName: string) : String;
    procedure ReadXML;
    procedure Clear;

    property Count : Integer read GetCount;
    property Items[Index: Integer]: TProject read GetItem write SetItem; default;
  end;

implementation

uses
  ScreenSaverConfig,
  SysUtils,
  OmniXML,
  WinInet,
  Types,
  Forms,
  Dialogs;

{ TProjectList }

function TProjectList.Add(buildProject: TProject): Integer;
begin
  Result := FObjectList.Add(buildProject);
end;

procedure TProjectList.Clear;
begin
  while FObjectList.Count > 0 do
    FObjectList.Remove(FObjectList.Items[0]);
end;

function TProjectList.DownloadFile(const localFileName: string; hURL: Pointer) : Boolean;
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
    Result := True;
  finally
    InternetCloseHandle(hURL);
  end;
end;

procedure TProjectList.CreateDummyFile(const localFileName: string);
var
  sl: TStringList;
begin
  //if hURL was nil the URL was invalid.  Write a dummy file to show this
  sl := TStringList.Create;
  try
    sl.Add('<Projects>');
    sl.Add('<Project activity="Sleeping" lastBuildStatus="Failure" lastBuildTime="2010-01-01T12:30:00.0000000+10:00" webUrl="http://loclahost/" name="Error: Cannot access XML URL!"/>');
    sl.Add('</Projects>');
    sl.SaveToFile(localFileName);
  finally
    FreeAndNil(sl);
  end;
end;

function TProjectList.FileURLToPath(sFileName: string) : String;
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

constructor TProjectList.Create;
begin
  inherited;
  FObjectList := TObjectList.Create(True);
  FTempFileName := GetEnvironmentVariable('TEMP') + '\projects.xml';
end;

destructor TProjectList.Destroy;
begin
  Clear;
  FreeAndNil(FObjectList);
  inherited;
end;

function TProjectList.GetXMLFile(const xmlFileURL, localFileName: String): Boolean;
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
      Result := DownloadFile(localFileName, hURL);
    end
    else
    begin
      CreateDummyFile(localFileName);
      Result := True;
    end;
  finally
    InternetCloseHandle(hSession);
  end
end;

function TProjectList.GetCount: Integer;
begin
  if (FObjectList = nil) then
    Result := 0
  else
    Result := FObjectList.Count;
end;

function TProjectList.GetItem(Index: Integer): TProject;
begin
  Result := TProject(FObjectList.Items[Index]);
end;

function TProjectList.IndexOf(proj: TProject): Integer;
var
  iTemp : Integer;
  bFound : Boolean;
begin
  bFound := False;
  for iTemp := 0 to FObjectList.Count - 1 do
    if (TProject(FObjectList[iTemp]).Name = proj.Name) then
    begin
      bFound := True;
      break;
    end;

  if bFound then
    Result := iTemp
  else
    Result := -1;
end;

procedure TProjectList.loadFromFile(sFileName: String);
var
  sTempFileName : String;
begin
  if (LowerCase(Copy(sFileName, 0, 7)) = 'file://') then
    sTempFileName := FileURLToPath(sFileName)
  else
    sTempFileName := sFileName;

  if GetXMLFile(sFileName, FTempFileName) then
    ReadXML
  else
  begin
    MessageDlg('Could not download ' + sFileName, mtError, [mbOk], 0);
    Application.Terminate;
  end;
end;

procedure TProjectList.ReadXML;
var
  FXMLDocument : IXMLDocument;
  queryNode    : IXMLNode;
  nodeList     : IXMLNodeList;
  nodeMap : IXMLNamedNodeMap;
  i : Integer;
  tmpProject : TProject;
  stream : TFileStream;
begin
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
      tmpProject.lastBuildStatus := nodeMap.GetNamedItem('lastBuildStatus').NodeValue;
      tmpProject.lastBuildTime := nodeMap.GetNamedItem('lastBuildTime').NodeValue;
      tmpProject.URL := nodeMap.GetNamedItem('webUrl').NodeValue;
      self.Add(tmpProject);
    end;
  finally
    FreeAndNil(stream);
  end;
end;

function TProjectList.Remove(proj: TProject): Integer;
begin
  Result := FObjectList.Remove(proj);
end;

procedure TProjectList.SetItem(Index: Integer; const Value: TProject);
begin
  FObjectList.Items[Index] := Value;
end;

end.
