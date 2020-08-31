unit HorseRotas;

interface

uses
  Horse, ApiMethods;

procedure ConfiguraRotas;

implementation

procedure ConfiguraRotas;
begin
  THorse.Get('/', RotaDefault);
  THorse.Get('/Eco', RotaEco);
  THorse.Get('/Soma', RotaSoma);
  THorse.Get('/Usuario', RotaUsuarioGet);
  THorse.Post('/Usuario', RotaUsuarioPost);
  THorse.Put('/Usuario', RotaUsuarioPut);
  THorse.Delete('/Usuario', RotaUsuarioDelete);
end;

end.
