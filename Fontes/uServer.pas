unit uServer;

interface

uses
  Winapi.Windows, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Imaging.jpeg, Horse,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, Horse.Jhonson, HorseRotas, System.SysUtils;

type
  TfrmServer = class(TForm)
    imgLogo: TImage;
    lbVersao: TLabel;
    lbStatus: TLabel;
    lbPorta: TLabel;
    btnStartStop: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnStartStopClick(Sender: TObject);
  private
    FActive: Boolean;
    procedure Initialize;
    procedure Finish;
  public
    { Public declarations }
  end;

var
  frmServer: TfrmServer;
  App: THorse;

implementation

{$R *.dfm}

procedure TfrmServer.btnStartStopClick(Sender: TObject);
begin
  FActive := (not FActive);

  if (FActive) then
  begin
    btnStartStop.Caption := 'Stop';
    lbStatus.Caption := 'Status: Online';
    lbPorta.Caption := 'Port: ' + IntToStr(8084);
    App.Start;
  end
  else
  begin
    btnStartStop.Caption := 'Start';
    lbStatus.Caption := 'Status: Offline';
    lbPorta.Caption := 'Port: ';
    Finish;
    Initialize;
  end;
end;

procedure TfrmServer.Finish;
begin
  try
    if (Assigned(App)) then
      FreeAndNil(App);
  except
  end;
end;

procedure TfrmServer.FormCreate(Sender: TObject);
begin
  Initialize;
  FActive := False;
end;

procedure TfrmServer.FormShow(Sender: TObject);
begin
  lbVersao.Caption := 'Version: 1.7.8';
end;

procedure TfrmServer.Initialize;
begin
  App := THorse.Create(8084);
  App.Use(Jhonson);
  ConfiguraRotas(App);
end;

end.
