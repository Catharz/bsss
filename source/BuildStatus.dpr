program BuildStatus;

uses
  {$IFDEF FastMM4}
  FastMM4,
  {$ENDIF}
  Forms,
  Dialogs,
  Controls,
  SysUtils,
  Contnrs,
  ScreenSaverForm in 'ScreenSaverForm.pas' {frmScreenSaver},
  Project in 'Project.pas',
  ProjectList in 'ProjectList.pas',
  ScreenSaverSetup in 'ScreenSaverSetup.pas' {frmScreenSaverSetup},
  ScreenSaverConfig in 'ScreenSaverConfig.pas',
  ScreenSaverController in 'ScreenSaverController.pas' {dmController: TDataModule},
  FontList in 'FontList.pas',
  BuildResultsFile in 'BuildResultsFile.pas',
  I_SettingsRepository in 'I_SettingsRepository.pas',
  RegistryDAO in 'RegistryDAO.pas',
  ActivityStatusFont in 'ActivityStatusFont.pas';

{$R *.res}

var
  iParam : Integer;
  fScreenList : TObjectList;

begin
  Application.Initialize;
  Application.Title := 'Build Status Screen Saver';
  Application.CreateForm(TdmController, dmController);
  for iParam := 1 to ParamCount do
  begin
    if Copy(ParamStr(iParam), 0, 2) = '/c' then
    begin
      frmScreenSaverSetup := TfrmScreenSaverSetup.Create(Application);
      while frmScreenSaverSetup.ShowModal = mrOk do
      begin
        try
          dmController.Config.SaveConfig;
          Break;
        except
          on e: EInvalidUrl do
            MessageDlg('Could not save invalid Url setting for screen saver!', mtError, [mbOk], 0);
          on e: EInvalidUpdateFrequency do
            MessageDlg('Could not save invalid Update Frequency setting for screen saver!', mtError, [mbOk], 0);
          on e: EInvalidAnimationFrequency do
            MessageDlg('Could not save invalid Animation Frequency setting for screen saver!', mtError, [mbOk], 0);
        end;
      end;
      Application.Terminate;
    end
    else
    begin
      if Copy(ParamStr(iParam), 0, 2) = '/s' then
      begin
        try
          fScreenList := TObjectList.Create(True);
          dmController.StartScreenSaver(fScreenList);
          Application.Run;
        finally
          FreeAndNil(fScreenList);
        end;
      end
      else
      begin
        //TODO: Work out how to create a preview screen
        if Copy(ParamStr(iParam), 0, 2) = '/p' then
          //Do nothing, we don't have a preview
        else
          Application.Terminate;
      end;
    end;
  end;
end.
