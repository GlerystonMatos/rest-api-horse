program Console;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  Horse.Constants,
  System.SysUtils,
  HorseRotas in 'HorseRotas.pas',
  ApiMethods in 'ApiMethods.pas';

begin
  try
    THorse.Use(Jhonson);
    ConfiguraRotas;
    THorse.Listen(9000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
