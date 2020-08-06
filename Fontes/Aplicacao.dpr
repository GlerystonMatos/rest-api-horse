program Aplicacao;

uses
  Vcl.Forms,
  uServer in 'uServer.pas' {frmServer},
  HorseRotas in 'HorseRotas.pas',
  ApiMethods in 'ApiMethods.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmServer, frmServer);
  Application.Run;
end.
