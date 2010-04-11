unit ScreenSaverSetup;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Dialogs, XPMan, ComCtrls, ScreenSaverConfig;

type
  TfrmScreenSaverSetup = class(TForm)
    Bevel1: TBevel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    lblFileName: TLabel;
    lblAnimationFrequency: TLabel;
    edtFileName: TEdit;
    xpmnfst1: TXPManifest;
    tbAnimationFrequency: TTrackBar;
    lblUpdateFrequency: TLabel;
    tbUpdateFrequency: TTrackBar;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmScreenSaverSetup: TfrmScreenSaverSetup;

implementation

{$R *.dfm}

uses
  ScreenSaverController;

{ TfrmScreenSaverSetup }

procedure TfrmScreenSaverSetup.FormShow(Sender: TObject);
begin
  edtFileName.Text := dmScreenSaverController.Config.XmlFileUrl;
  tbUpdateFrequency.Position := dmScreenSaverController.Config.UpdateFrequency;
  tbAnimationFrequency.Position := dmScreenSaverController.Config.AnimationFrequency;
end;

end.
