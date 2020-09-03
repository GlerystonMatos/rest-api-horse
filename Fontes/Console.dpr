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
  HorseRotas in 'HorseRotas.pas',
  ApiMethods in 'ApiMethods.pas';

begin
  try
    THorse
      .Use(Compression())
      .Use(Jhonson)
      .Use(HandleException)
      .Use(HorseJWT('rest-api-horse'));

    ConfiguraRotas;
    THorse.Listen(9000,
      procedure(Horse: THorse)
      begin
        Writeln(Format(START_RUNNING, [Horse.Host, Horse.Port]));
      end);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
