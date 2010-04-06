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
  ScreenSaverConfig in 'ScreenSaverConfig.pas';

{$R *.res}

var
  iParam : Integer;
  config : TScreenSaverConfig;

begin
  Application.Initialize;
  config := TScreenSaverConfig.Create;
  try
    for iParam := 1 to ParamCount do
    begin
      if Copy(ParamStr(iParam), 0, 2) = '/c' then
      begin
        //Show the config screen
        frmScreenSaverSetup := TfrmScreenSaverSetup.Create(Application);
        if not config.LoadConfig then
        begin
          MessageDlg('Could not load registry settings for screen saver!', mtError, [mbOk], 0);
          Application.Terminate;
        end;
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
        //TODO: Make the form object oriented and instantiate one for each screen.
        if Copy(ParamStr(iParam), 0, 2) = '/s' then
        begin
          Application.CreateForm(TfrmScreenSaver, frmScreenSaver);
          if not config.loadConfig then
          begin
            MessageDlg('Could not load registry settings for screen saver!', mtError, [mbOk], 0);
            Application.Terminate;
          end;
          //TODO: Create an update controller that will read the XML for the screens
          frmScreenSaver.FileName := config.XmlFileUrl;
          frmScreenSaver.UpdateFrequency := config.UpdateFrequency;
          frmScreenSaver.AnimationFrequency := config.AnimationFrequency;
          frmScreenSaver.UpdateProjectStatus;
          frmScreenSaver.Animate;
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
