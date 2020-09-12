unit Controllers.Usuario;

interface

uses
  Horse, System.SysUtils, System.JSON, Horse.Commons, Services.Usuario;

procedure Registry;
procedure GetUsuarios(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure PostUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure PutUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DeleteUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse
    .Group
      .Prefix('/Api')
        .Delete('/Usuario/:nome', DeleteUsuario)
        .Route('/Usuario')
          .Get(GetUsuarios)
          .Post(PostUsuario)
          .Put(PutUsuario)
end;

procedure GetUsuarios(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  usuario: IServiceUsuario;
begin
  try
    usuario := TServiceUsuario.Create;
    Res.Send<TJSONArray>(usuario.Get);
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure PostUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  usuario: IServiceUsuario;
begin
  try
    usuario := TServiceUsuario.Create;
    Res.Send<TJSONObject>(usuario.Post(Req.Body<TJSONObject>)).Status(THTTPStatus.Created);
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure PutUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  usuario: IServiceUsuario;
begin
  try
    usuario := TServiceUsuario.Create;
    Res.Send<TJSONObject>(usuario.Put(Req.Body<TJSONObject>));
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure DeleteUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  usuario: IServiceUsuario;
begin
  try
    usuario := TServiceUsuario.Create;
    Res.Send<TJSONObject>(usuario.Delete(Req.Params['nome']));
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

end.

