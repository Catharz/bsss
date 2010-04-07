program BuildStatus;

uses
  Forms,
  Dialogs,
  Controls,
  SysUtils,
  ScreenSaverForm in 'ScreenSaverForm.pas' {frmScreenSaver},
  Project in 'Project.pas',
  ProjectList in 'ProjectList.pas',
  ScreenSaverSetup in 'ScreenSaverSetup.pas' {frmScreenSaverSetup},
  ScreenSaverConfig in 'ScreenSaverConfig.pas',
  ScreenSaverController in 'ScreenSaverController.pas' {dmScreenSaverController: TDataModule};

{$E scr}

{$R *.res}

var
  iParam : Integer;
  config : TScreenSaverConfig;

begin
  Application.Initialize;
  Application.Title := 'Build Status Screen Saver';
  Application.CreateForm(TdmScreenSaverController, dmScreenSaverController);
  config := TScreenSaverConfig.Create;
  try
    for iParam := 1 to ParamCount do
    begin
      if Copy(ParamStr(iParam), 0, 2) = '/c' then
      begin
        if not config.LoadConfig then
        begin
          MessageDlg('Could not load registry settings for screen saver!', mtError, [mbOk], 0);
          Application.Terminate;
        end;
        frmScreenSaverSetup := TfrmScreenSaverSetup.Create(Application);
        frmScreenSaverSetup.edtFileName.Text := config.XmlFileUrl;
        frmScreenSaverSetup.tbUpdateFrequency.Position := config.UpdateFrequency;
        frmScreenSaverSetup.tbAnimationFrequency.Position := config.AnimationFrequency;
        while frmScreenSaverSetup.ShowModal = mrOk do
        begin
          config.XmlFileUrl := frmScreenSaverSetup.edtFileName.Text;
          config.UpdateFrequency := frmScreenSaverSetup.tbUpdateFrequency.Position;
          config.AnimationFrequency := frmScreenSaverSetup.tbAnimationFrequency.Position;
          try
            config.SaveConfig;
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
          if not config.loadConfig then
          begin
            MessageDlg('Could not load registry settings for screen saver!', mtError, [mbOk], 0);
            Application.Terminate;
          end;
          dmScreenSaverController.FileName := config.XmlFileUrl;
          dmScreenSaverController.UpdateFrequency := config.UpdateFrequency;
          dmScreenSaverController.AnimationFrequency := config.AnimationFrequency;
          dmScreenSaverController.StartScreenSaver;
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
    Application.Run;
  finally
    FreeAndNil(config);
  end;
end.
