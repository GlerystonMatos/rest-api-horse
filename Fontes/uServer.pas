unit uServer;

interface

uses
  Winapi.Windows, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Imaging.jpeg, Horse,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, Horse.Jhonson, System.SysUtils, Horse.JWT,
  Controllers.Login, Horse.HandleException, Horse.Compression,
  Controllers.ApiMethods, Controllers.Usuario;

type
  TfrmServer = class(TForm)
    imgLogo: TImage;
    lbVersao: TLabel;
    lbStatus: TLabel;
    lbPorta: TLabel;
    btnStartStop: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnStartStopClick(Sender: TObject);
  private
    FActive: Boolean;
    procedure Start;
    procedure Stop;
  public
    { Public declarations }
  end;

var
  frmServer: TfrmServer;

implementation

{$R *.dfm}

procedure TfrmServer.Start;
begin
  THorse
    .Use(Compression())
    .Use(Jhonson)
    .Use(HandleException)
    .Use('/Api',HorseJWT('rest-api-horse'));

  Controllers.Login.Registry;
  Controllers.ApiMethods.Registry;
  Controllers.Usuario.Registry;

  THorse.Listen(9001);
  FActive := True;
end;

procedure TfrmServer.Stop;
begin
  THorse.StopListen;
  FActive := False;
end;

procedure TfrmServer.btnStartStopClick(Sender: TObject);
begin
  if (FActive) then
  begin
    Stop;
    btnStartStop.Caption := 'Start';
    lbStatus.Caption := 'Status: Offline';
    lbPorta.Caption := 'Port: ';
  end
  else
  begin
    Start;
    btnStartStop.Caption := 'Stop';
    lbStatus.Caption := 'Status: Online';
    lbPorta.Caption := 'Port: ' + IntToStr(THorse.Port);
  end;
end;

procedure TfrmServer.FormShow(Sender: TObject);
begin
  lbVersao.Caption := 'Version: 2.0.1';
  btnStartStop.Click;
end;

end.
