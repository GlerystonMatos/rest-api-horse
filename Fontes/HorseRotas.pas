unit HorseRotas;

interface

uses
  Horse.Core, ApiMethods;

procedure ConfiguraRotas(Horse: THorseCore);

implementation

procedure ConfiguraRotas(Horse: THorseCore);
begin
  Horse.Get('/', RotaDefault);
  Horse.Get('/HelloWorld', RotaHelloWorld);
end;

end.
