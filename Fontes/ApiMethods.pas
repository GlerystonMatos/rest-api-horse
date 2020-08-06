unit ApiMethods;

interface

uses
  Horse, System.SysUtils, System.JSON, Horse.Commons;

procedure LancarErro(Res: THorseResponse; Msg: string);
procedure RotaDefault(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure RotaEco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure RotaSoma(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure RotaUsuarioGet(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure RotaUsuarioPost(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure RotaUsuarioPut(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure RotaUsuarioDelete(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure LancarErro(Res: THorseResponse; Msg: string);
var
  objeto: TJSONObject;
begin
  objeto := TJSONObject.Create;
  objeto.AddPair(TJSONPair.Create('mensagem', Msg));
  Res.Send<TJSONObject>(objeto).Status(THTTPStatus.InternalServerError);
end;

procedure RotaDefault(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  try
    Res.Send('<!DOCTYPE html>' +
             '<html>' +
               '<head>' +
                 '<meta charset="UTF-8" />' +
                 '<title>Horse</title>' +
               '</head>' +
               '<body>' +
                 '<h1>Horse</h1>' +
                 '<h2>Server Status - Online</h2>' +
               '</body>' +
             '</html>').Status(THTTPStatus.OK);
  except
    on E: Exception do
      LancarErro(Res, E.Message);
  end;
end;

procedure RotaEco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  value: string;
  objeto: TJSONObject;
begin
  try
    value := '';
    if (Req.Query.ContainsKey('value')) then
      value := Req.Query.Items['value'];

    objeto := TJSONObject.Create;
    objeto.AddPair(TJSONPair.Create('result', value));
    Res.Send<TJSONObject>(objeto).Status(THTTPStatus.OK);
  except
    on E: Exception do
      LancarErro(Res, E.Message);
  end;
end;

procedure RotaSoma(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  value01: Integer;
  value02: Integer;
  objeto: TJSONObject;
begin
  try
    value01 := 0;
    if (Req.Query.ContainsKey('value01')) then
      value01 := StrToInt(Req.Query.Items['value01']);

    value02 := 0;
    if (Req.Query.ContainsKey('value02')) then
      value02 := StrToInt(Req.Query.Items['value02']);

    objeto := TJSONObject.Create;
    objeto.AddPair(TJSONPair.Create('result', IntToStr((value01 + value02))));
    Res.Send<TJSONObject>(objeto).Status(THTTPStatus.OK);
  except
    on E: Exception do
      LancarErro(Res, E.Message);
  end;
end;

procedure RotaUsuarioGet(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  lista: TJSONArray;
  objeto01: TJSONObject;
  objeto02: TJSONObject;
  objeto03: TJSONObject;
begin
  try
    lista := TJSONArray.Create;

    objeto01 := TJSONObject.Create;
    objeto01.AddPair(TJSONPair.Create('nome', 'Snoopy'));
    objeto01.AddPair(TJSONPair.Create('senha', '123465'));
    lista.AddElement(objeto01);

    objeto02 := TJSONObject.Create;
    objeto02.AddPair(TJSONPair.Create('nome', 'Lola'));
    objeto02.AddPair(TJSONPair.Create('senha', '654321'));
    lista.AddElement(objeto02);

    objeto03 := TJSONObject.Create;
    objeto03.AddPair(TJSONPair.Create('nome', 'Tobias'));
    objeto03.AddPair(TJSONPair.Create('senha', '456123'));
    lista.AddElement(objeto03);

    Res.Send<TJSONArray>(lista).Status(THTTPStatus.OK);
  except
    on E: Exception do
      LancarErro(Res, E.Message);
  end;
end;

procedure RotaUsuarioPost(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  senha: string;
  usuario: string;
  dados: TJSONObject;
  objeto: TJSONObject;
begin
  try
    dados := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
    objeto := TJSONObject.Create;

    usuario := '';
    if (not dados.GetValue('nome').Null) then
      usuario := dados.GetValue('nome').value;

    senha := '';
    if (not dados.GetValue('senha').Null) then
      senha := dados.GetValue('senha').value;

    objeto.AddPair(TJSONPair.Create('mensagem', 'Usuário ' + usuario + ' com a senha ' + senha + ', foi criado com sucesso'));
    Res.Send<TJSONObject>(objeto).Status(THTTPStatus.OK);
  except
    on E: Exception do
      LancarErro(Res, E.Message);
  end;
end;

procedure RotaUsuarioPut(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  senha: string;
  usuario: string;
  dados: TJSONObject;
  objeto: TJSONObject;
begin
  try
    dados := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
    objeto := TJSONObject.Create;

    usuario := '';
    if (not dados.GetValue('nome').Null) then
      usuario := dados.GetValue('nome').value;

    senha := '';
    if (not dados.GetValue('senha').Null) then
      senha := dados.GetValue('senha').value;

    objeto.AddPair(TJSONPair.Create('mensagem', 'Usuário ' + usuario + ' com a senha ' + senha + ', foi atualizado com sucesso'));
    Res.Send<TJSONObject>(objeto).Status(THTTPStatus.OK);
  except
    on E: Exception do
      LancarErro(Res, E.Message);
  end;
end;

procedure RotaUsuarioDelete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  value: string;
  objeto: TJSONObject;
begin
  try
    value := '';
    if (Req.Query.ContainsKey('nome')) then
      value := Req.Query.Items['nome'];

    objeto := TJSONObject.Create;
    objeto.AddPair(TJSONPair.Create('mensagem', 'Usuário ' + value + ' excluído com sucesso'));
    Res.Send<TJSONObject>(objeto).Status(THTTPStatus.OK);
  except
    on E: Exception do
      LancarErro(Res, E.Message);
  end;
end;

end.
