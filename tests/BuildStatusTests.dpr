//{$DEFINE DUNIT_CONSOLE_MODE}

program BuildStatusTests;

uses
  FastMM4,
  SysUtils,
  TestFramework,
  TestExtensions,
  GUITestRunner,
  TextTestRunner,
  ProjectList in '..\source\ProjectList.pas',
  Project in '..\source\Project.pas',
  ProjectTests in 'ProjectTests.pas',
  ProjectListTests in 'ProjectListTests.pas',
  ScreenSaverConfig in '..\source\ScreenSaverConfig.pas',
  ScreenSaverConfigTests in 'ScreenSaverConfigTests.pas',
  FontList in '..\source\FontList.pas',
  ScreenSaverController in '..\source\ScreenSaverController.pas' {dmController: TDataModule},
  ScreenSaverForm in '..\source\ScreenSaverForm.pas' {frmScreenSaver},
  FontListTests in 'FontListTests.pas',
  BuildResultsFile in '..\source\BuildResultsFile.pas',
  BuildResultsFileTests in 'BuildResultsFileTests.pas',
  I_SettingsRepository in '..\source\I_SettingsRepository.pas',
  RegistryDAO in '..\source\RegistryDAO.pas',
  ActivityStatusFont in '..\source\ActivityStatusFont.pas',
  ActivityStatusFontTests in 'ActivityStatusFontTests.pas';

{$IFDEF DUNIT_CONSOLE_MODE}
  {$APPTYPE CONSOLE}
{$ELSE}
  {$R *.RES}
{$ENDIF}

begin
  {$IFDEF FastMM4}
  FastMM4.ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}
{$IFDEF DUNIT_CONSOLE_MODE}
  if not FindCmdLineSwitch('Graphic', ['-','/'], True) then
    TextTestRunner.RunRegisteredTests(rxbHaltOnFailures)
  else
{$ENDIF}
    GUITestRunner.RunRegisteredTests;
end.
