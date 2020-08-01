program HorseApiRest;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  System.SysUtils,
  HorseRotas in 'HorseRotas.pas',
  ApiMethods in 'ApiMethods.pas';

var
  App: THorse;

begin
  try
    App := THorse.Create(8084);
    ConfiguraRotas(App);
    App.Start;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
