; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Build Status Screen Saver"
#define MyAppOriginPath "C:\dev\Projects\bsss\source"
#define MyAppExeName "BuildStatus.exe"
#define MyAppDestName "BuildStatus.scr"
#define MyAppVersion GetFileVersion("C:\dev\Projects\bsss\source\BuildStatus.exe")
#define MyAppVerName "Build Status Screen Saver v" + GetFileVersion("C:\dev\Projects\bsss\source\BuildStatus.exe")
#define MyAppPublisher "Craig Read"
#define MyAppURL "http://code.google.com/p/bssss/"
#define MySetupFileName "BuildStatus_v" + GetFileVersion("C:\dev\Projects\bsss\source\BuildStatus.exe")

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{67FEAC3B-BFC4-4ED9-859C-F752E6C5898D}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppVerName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={win}\system32
DisableDirPage=true
DefaultGroupName={#MyAppName}
AllowNoIcons=true
OutputBaseFilename={#MySetupFilename}
Compression=lzma
SolidCompression=true
AppCopyright=Craig Read
CreateAppDir=false
ShowLanguageDialog=auto

[Languages]
Name: english; MessagesFile: compiler:Default.isl

[Registry]
Root: HKCU; Subkey: Control Panel\Screen Saver.BuildStatus; Flags: uninsdeletekey
Root: HKCU; Subkey: Control Panel\Screen Saver.BuildStatus; ValueType: string; ValueName: XMLSource; ValueData: "http://bsss.googlecode.com/hg/test.xml"
Root: HKCU; Subkey: Control Panel\Screen Saver.BuildStatus; ValueType: dword; ValueName: AnimationFrequency; ValueData: 3
Root: HKCU; Subkey: Control Panel\Screen Saver.BuildStatus; ValueType: dword; ValueName: UpdateFrequency; ValueData: 1

[Files]
Source: {#MyAppOriginPath}\BuildStatus.exe; DestDir: {sys}; DestName: {#MyAppDestName}; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\Configure Screensaver"; Filename: "{win}\system32\{#MyAppDestName}"; Parameters: "/c"
Name: "{group}\Start Screensaver"; Filename: "{win}\system32\{#MyAppDestName}"; Parameters: "/s"
Name: {group}\{cm:ProgramOnTheWeb,{#MyAppName}}; Filename: {#MyAppURL}
Name: {group}\{cm:UninstallProgram,{#MyAppName}}; Filename: {uninstallexe}

[Run]
Filename: {win}\system32\{#MyAppDestName}; Description: Configure the screen saver; Flags: postinstall; Parameters: /c; StatusMsg: Configuring Screen Saver