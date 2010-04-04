unit ScreenSaverSetup;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Dialogs, XPMan, ComCtrls;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmScreenSaverSetup: TfrmScreenSaverSetup;

implementation

{$R *.dfm}

end.
