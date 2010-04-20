unit ScreenSaverSetup;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Dialogs, ComCtrls, ScreenSaverConfig;

type
  TfrmScreenSaverSetup = class(TForm)
    Bevel1: TBevel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    lblFileName: TLabel;
    lblAnimationFrequency: TLabel;
    edtFileName: TEdit;
    tbAnimationFrequency: TTrackBar;
    lblUpdateFrequency: TLabel;
    tbUpdateFrequency: TTrackBar;
    fd: TFontDialog;
    Fonts: TGroupBox;
    lbActivity: TListBox;
    lbStatus: TListBox;
    lbCurrentlActivity: TLabel;
    lblLastBuildStatus: TLabel;
    lblFontExample: TLabel;
    edtActivity: TEdit;
    edtStatus: TEdit;
    sbAddActivity: TSpeedButton;
    sbDeleteActivity: TSpeedButton;
    sbRenameActivity: TSpeedButton;
    sbAddStatus: TSpeedButton;
    sbDeleteStatus: TSpeedButton;
    sbRenameStatus: TSpeedButton;
    procedure ChangeFont(Sender: TObject);
    procedure ChangeFontContext(Sender: TObject);
    procedure tbAnimationFrequencyChange(Sender: TObject);
    procedure tbUpdateFrequencyChange(Sender: TObject);
    procedure edtFileNameChange(Sender: TObject);
    procedure edtActivityChange(Sender: TObject);
    procedure edtStatusChange(Sender: TObject);
    procedure sbAddActivityClick(Sender: TObject);
    procedure sbAddStatusClick(Sender: TObject);
    procedure sbRenameActivityClick(Sender: TObject);
    procedure sbRenameStatusClick(Sender: TObject);
    procedure sbDeleteActivityClick(Sender: TObject);
    procedure sbDeleteStatusClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FConfig : TScreenSaverConfig;
  public
    { Public declarations }
  end;

var
  frmScreenSaverSetup: TfrmScreenSaverSetup;

implementation

{$R *.dfm}

uses
  ScreenSaverController, Project;

{ TfrmScreenSaverSetup }

procedure TfrmScreenSaverSetup.ChangeFontContext(Sender: TObject);
var
  sActivity, sStatus : String;
  bCustomActivity, bCustomStatus : Boolean;
begin
  sActivity := lbActivity.Items[lbActivity.ItemIndex];
  sStatus := lbStatus.Items[lbStatus.ItemIndex];

  //Display the correct font
  lblFontExample.Font := FConfig.FontMgr.Font[sActivity, sStatus];
  lblFontExample.Caption := sActivity + ' ' + sStatus;

  //Set the edit field value
  edtActivity.Text := sActivity;
  edtStatus.Text := sStatus;

  //Enable or Disable the buttons
  bCustomActivity := (FConfig.ActivityType(sActivity) = vtCustom);
  bCustomStatus := (FConfig.StatusType(sStatus) = vtCustom);
  sbDeleteActivity.Enabled := bCustomActivity;
  sbRenameActivity.Enabled := bCustomActivity and (FConfig.ActivityList.IndexOf(sActivity) < 0);
  sbDeleteStatus.Enabled := bCustomStatus;
  sbRenameStatus.Enabled := bCustomStatus and (FConfig.StatusList.IndexOf(sStatus) < 0);
end;

procedure TfrmScreenSaverSetup.edtActivityChange(Sender: TObject);
var
  i : Integer;
  sOldActivity, sNewActivity : String;
begin
  sNewActivity := edtActivity.Text;
  sOldActivity := lbActivity.Items[lbActivity.ItemIndex];
  i := lbActivity.Items.IndexOf(sNewActivity);
  sbAddActivity.Enabled := (i < 0);
  sbRenameActivity.Enabled := (FConfig.ActivityType(sOldActivity) = vtCustom) and
    (FConfig.ActivityList.IndexOf(sNewActivity) < 0);
end;

procedure TfrmScreenSaverSetup.edtFileNameChange(Sender: TObject);
begin
  if FConfig.ValidateXmlFileURL(edtFileName.Text) then
    FConfig.XmlFileURL := edtFileName.Text;
end;

procedure TfrmScreenSaverSetup.edtStatusChange(Sender: TObject);
var
  i : Integer;
  sOldStatus, sNewStatus : String;
begin
  sNewStatus := edtStatus.Text;
  sOldStatus := lbStatus.Items[lbStatus.ItemIndex];
  i := lbStatus.Items.IndexOf(sNewStatus);
  sbAddStatus.Enabled := (i < 0);
  sbRenameStatus.Enabled := (FConfig.StatusType(sOldStatus) = vtCustom) and
    (FConfig.StatusList.IndexOf(sNewStatus) < 0);
end;

procedure TfrmScreenSaverSetup.FormCreate(Sender: TObject);
begin
  inherited;
  FConfig := dmController.Config;
  edtFileName.Text := FConfig.XmlFileUrl;
  tbUpdateFrequency.Position := FConfig.UpdateFrequency;
  tbAnimationFrequency.Position := FConfig.AnimationFrequency;
  lbActivity.Items.Clear;
  lbActivity.Items.AddStrings(FConfig.ActivityList);
  lbStatus.Items.Clear;
  lbStatus.Items.AddStrings(FConfig.StatusList);
  lbActivity.ItemIndex := 0;
  lbStatus.ItemIndex := 0;
  ChangeFontContext(nil);
end;

procedure TfrmScreenSaverSetup.sbAddActivityClick(Sender: TObject);
begin
  lbActivity.Items.Add(edtActivity.Text);
  FConfig.ActivityList.Add(edtActivity.Text);
end;

procedure TfrmScreenSaverSetup.sbAddStatusClick(Sender: TObject);
begin
  lbStatus.Items.Add(edtStatus.Text);
  FConfig.StatusList.Add(edtStatus.Text);
end;

procedure TfrmScreenSaverSetup.sbDeleteActivityClick(Sender: TObject);
var
  i : Integer;
  sActivity : String;
begin
  sActivity := edtActivity.Text;
  i := lbActivity.Items.IndexOf(sActivity);
  if i >= 0 then
  begin
    if MessageDlg('Are you sure you want to delete this Activity?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      lbActivity.Items.Delete(i);
      FConfig.DeleteActivity(sActivity);
      lbActivity.ItemIndex := 0;
      edtActivity.Text := lbActivity.Items[0];
      ChangeFontContext(nil);
    end;
  end;
end;

procedure TfrmScreenSaverSetup.sbDeleteStatusClick(Sender: TObject);
var
  i : Integer;
  sStatus : String;
begin
  sStatus := edtStatus.Text;
  i := lbStatus.Items.IndexOf(sStatus);
  if i >= 0 then
  begin
    if MessageDlg('Are you sure you want to delete this Status?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      lbStatus.Items.Delete(i);
      FConfig.DeleteStatus(sStatus);
      lbStatus.ItemIndex := 0;
      edtStatus.Text := lbStatus.Items[0];
      ChangeFontContext(nil);
    end;
  end;
end;

procedure TfrmScreenSaverSetup.sbRenameActivityClick(Sender: TObject);
var
  i : Integer;
  sOldActivity, sNewActivity : String;
begin
  sNewActivity := edtActivity.Text;
  i := lbActivity.ItemIndex;
  if i >= 0 then
  begin
    sOldActivity := lbActivity.Items[i];
    lbActivity.Items[i] := sNewActivity;
    FConfig.RenameActivity(sOldActivity, sNewActivity);
  end;
  ChangeFontContext(nil);
  edtActivityChange(nil);
end;

procedure TfrmScreenSaverSetup.sbRenameStatusClick(Sender: TObject);
var
  i : Integer;
  sOldStatus, sNewStatus : String;
begin
  sNewStatus := edtStatus.Text;
  i := lbStatus.ItemIndex;
  if i >= 0 then
  begin
    sOldStatus := lbStatus.Items[i];
    lbStatus.Items[i] := sNewStatus;
    FConfig.RenameStatus(sOldStatus, sNewStatus);
  end;
  ChangeFontContext(nil);
  edtStatusChange(nil);
end;

procedure TfrmScreenSaverSetup.tbAnimationFrequencyChange(Sender: TObject);
begin
  FConfig.AnimationFrequency := tbAnimationFrequency.Position;
end;

procedure TfrmScreenSaverSetup.tbUpdateFrequencyChange(Sender: TObject);
begin
  FConfig.UpdateFrequency := tbUpdateFrequency.Position;
end;

procedure TfrmScreenSaverSetup.ChangeFont(Sender: TObject);
var
  sActivity, sStatus : String;
begin
  if (Sender is TLabel) then
  begin
    fd.Font := (Sender as TLabel).Font;
    if fd.Execute then
    begin
      (Sender as TLabel).Font := fd.Font;
      sActivity := lbActivity.Items[lbActivity.ItemIndex];
      sStatus := lbStatus.Items[lbStatus.ItemIndex];
      FConfig.FontMgr.Font[sActivity, sStatus] := fd.Font;
    end;
  end;
end;

end.
