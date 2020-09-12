unit Services.Usuario;

interface

uses
  System.JSON;

type
  TUsuario = record
    Nome: string;
    Senha: string;
  end;

  IServiceUsuario = interface
    ['{E82EFF2A-A6AF-4E1F-A6CC-0F892633FA4D}']
    function Get: TJSONArray;
    function Post(const Usuario: TJSONObject): TJSONObject;
    function Put(const Usuario: TJSONObject): TJSONObject;
    function Delete(const Nome: string): TJSONObject;
  end;

  TServiceUsuario = class(TInterfacedObject, IServiceUsuario)
  private
    function JsonToRecord(const UsuarioJson: TJSONObject): TUsuario;
  public
    function Get: TJSONArray;
    function Post(const UsuarioJson: TJSONObject): TJSONObject;
    function Put(const UsuarioJson: TJSONObject): TJSONObject;
    function Delete(const Nome: string): TJSONObject;
  end;

implementation

{ TServiceUsuario }

function TServiceUsuario.JsonToRecord(const UsuarioJson: TJSONObject): TUsuario;
begin
  Result.Nome := '';
  if (not UsuarioJson.GetValue('nome').Null) then
    Result.Nome := UsuarioJson.GetValue('nome').value;

  Result.Senha := '';
  if (not UsuarioJson.GetValue('senha').Null) then
    Result.Senha := UsuarioJson.GetValue('senha').value;
end;

function TServiceUsuario.Get: TJSONArray;
var
  lista: TJSONArray;
  objeto01: TJSONObject;
  objeto02: TJSONObject;
  objeto03: TJSONObject;
begin
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

  Result := lista;
end;

function TServiceUsuario.Post(const UsuarioJson: TJSONObject): TJSONObject;
var
  usuario: TUsuario;
begin
  usuario := JsonToRecord(UsuarioJson);
  result := TJSONObject.Create;
  result.AddPair(TJSONPair.Create('mensagem', 'Usuário ' + usuario.Nome +
    ' com a senha ' + usuario.Senha + ', foi criado com sucesso'));
end;

function TServiceUsuario.Put(const UsuarioJson: TJSONObject): TJSONObject;
var
  usuario: TUsuario;
begin
  usuario := JsonToRecord(UsuarioJson);
  result := TJSONObject.Create;
  result.AddPair(TJSONPair.Create('mensagem', 'Usuário ' + usuario.Nome +
    ' com a senha ' + usuario.Senha + ', foi atualizado com sucesso'));
end;

function TServiceUsuario.Delete(const Nome: string): TJSONObject;
var
  objeto: TJSONObject;
begin
  objeto := TJSONObject.Create;
  objeto.AddPair(TJSONPair.Create('mensagem', 'Usuário ' + Nome + ' excluído com sucesso'));
  Result := objeto;
end;

end.
