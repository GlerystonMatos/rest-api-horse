program VCL;

uses
  Vcl.Forms,
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Services.Login in 'Services\Services.Login.pas',
  Services.Usuario in 'Services\Services.Usuario.pas',
  Controllers.Login in 'Controllers\Controllers.Login.pas',
  Controllers.Usuario in 'Controllers\Controllers.Usuario.pas',
  Controllers.ApiMethods in 'Controllers\Controllers.ApiMethods.pas',
  uServer in 'uServer.pas' {frmServer};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmServer, frmServer);
  Application.Run;
end.
