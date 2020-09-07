program VCL;

uses
  Vcl.Forms,
  HorseRotas in 'HorseRotas.pas',
  ApiMethods in 'ApiMethods.pas',
  uServer in 'uServer.pas' {frmServer};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmServer, frmServer);
  Application.Run;
end.
