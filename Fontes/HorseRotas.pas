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
      .Get('/', Default)
      .Get('/Eco', Eco)
      .Get('/Soma', Soma)
      .Route('/Usuario')
        .Get(UsuarioGet)
        .Post(UsuarioPost)
        .Put(UsuarioPut)
        .Delete(UsuarioDelete);
end;

end.
