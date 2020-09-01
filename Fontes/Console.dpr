program Console;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.JWT,
  Horse.Jhonson,
  Horse.Compression,
  Horse.HandleException,
  System.SysUtils,
  HorseRotas in 'HorseRotas.pas',
  ApiMethods in 'ApiMethods.pas';

begin
  try
    THorse.Use(Compression());
    THorse.Use(Jhonson);
    THorse.Use(HandleException);
    THorse.Use(HorseJWT('rest-api-horse'));
    ConfiguraRotas;
    THorse.Listen(9000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
