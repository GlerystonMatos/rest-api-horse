unit HorseRotas;

interface

uses
  Horse.Core, ApiMethods;

procedure ConfiguraRotas(Horse: THorseCore);

implementation

procedure ConfiguraRotas(Horse: THorseCore);
begin
  Horse.Get('/', RotaDefault);
  Horse.Get('/Eco', RotaEco);
  Horse.Get('/Soma', RotaSoma);
  Horse.Get('/Usuario', RotaUsuarioGet);
  Horse.Post('/Usuario', RotaUsuarioPost);
  Horse.Put('/Usuario', RotaUsuarioPut);
  Horse.Delete('/Usuario', RotaUsuarioDelete);
end;

end.
