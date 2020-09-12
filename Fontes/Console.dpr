program Console;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.JWT,
  Horse.Jhonson,
  Horse.Constants,
  System.SysUtils,
  Horse.Compression,
  Horse.HandleException,
  Services.Login in 'Services\Services.Login.pas',
  Services.Usuario in 'Services\Services.Usuario.pas',
  Controllers.Login in 'Controllers\Controllers.Login.pas',
  Controllers.Usuario in 'Controllers\Controllers.Usuario.pas',
  Controllers.ApiMethods in 'Controllers\Controllers.ApiMethods.pas';

begin
  try
    ReportMemoryLeaksOnShutdown := True;

    THorse
      .Use(Compression())
      .Use(Jhonson)
      .Use(HandleException)
      .Use('/Api',HorseJWT('rest-api-horse'));

    Controllers.Login.Registry;
    Controllers.ApiMethods.Registry;
    Controllers.Usuario.Registry;

    THorse.Listen(9000,
      procedure(Horse: THorse)
      begin
        Writeln('Server is runing on port ' + THorse.Port.ToString);
        Write('Press return to stop...');
        ReadLn;
        THorse.StopListen;
      end);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
