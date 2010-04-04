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
  ScreenSaverConfigTests in 'ScreenSaverConfigTests.pas';

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
