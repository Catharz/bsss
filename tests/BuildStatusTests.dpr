//{$DEFINE DUNIT_CONSOLE_MODE}

program BuildStatusTests;

uses
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
  FontManager in '..\source\FontManager.pas',
  ScreenSaverController in '..\source\ScreenSaverController.pas' {dmScreenSaverController: TDataModule},
  ScreenSaverForm in '..\source\ScreenSaverForm.pas' {frmScreenSaver},
  FontManagerTests in 'FontManagerTests.pas',
  BuildResultsFile in '..\source\BuildResultsFile.pas',
  BuildResultsFileTests in 'BuildResultsFileTests.pas';

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
