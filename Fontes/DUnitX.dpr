program DUnitX;

{$APPTYPE CONSOLE}

uses
  Horse,
  Horse.JWT,
  Horse.Jhonson,
  System.Classes,
  System.SysUtils,
  Horse.Compression,
  Horse.HandleException,
  DUnitX.TestFramework,
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  Services.Login in 'Services\Services.Login.pas',
  Services.Usuario in 'Services\Services.Usuario.pas',
  Controllers.Login in 'Controllers\Controllers.Login.pas',
  Controllers.Usuario in 'Controllers\Controllers.Usuario.pas',
  Controllers.ApiMethods in 'Controllers\Controllers.ApiMethods.pas',
  Tests.Controllers.Usuario in 'Tests\Controllers\Tests.Controllers.Usuario.pas',
  Tests.Controllers.ApiMethods in 'Tests\Controllers\Tests.Controllers.ApiMethods.pas';

var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;

begin
  try
    TDUnitX.CheckCommandLine;

    runner := TDUnitX.CreateRunner;
    runner.UseRTTI := True;
    runner.FailsOnNoAsserts := False;

    logger := TDUnitXConsoleLogger.Create(False);
    runner.AddLogger(logger);

    TThread.CreateAnonymousThread(
      procedure
      begin
        THorse
          .Use(Compression())
          .Use(Jhonson)
          .Use(HandleException)
          .Use('/Api', HorseJWT('rest-api-horse'));

        Controllers.Login.Registry;
        Controllers.ApiMethods.Registry;
        Controllers.Usuario.Registry;

        THorse.Listen(9002);
      end).Start;

    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
