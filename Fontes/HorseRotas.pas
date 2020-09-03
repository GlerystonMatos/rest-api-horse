unit HorseRotas;

interface

uses
  Horse, ApiMethods;

procedure ConfiguraRotas;

implementation

procedure ConfiguraRotas;
begin
  THorse
    .Group
      .Prefix('/Api')
      .Get('/', RotaDefault)
      .Get('/Eco', RotaEco)
      .Get('/Soma', RotaSoma)
      .Route('/Usuario')
        .Get(RotaUsuarioGet)
        .Post(RotaUsuarioPost)
        .Put(RotaUsuarioPut)
        .Delete(RotaUsuarioDelete);
end;

end.
