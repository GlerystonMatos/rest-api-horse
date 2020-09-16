unit Tests.Controllers.Usuario;

interface

uses
  DUnitX.TestFramework, System.JSON, System.SysUtils, System.Classes,
  RESTRequest4D.Request;

type
  [TestFixture]
  TControllerUsuarioTest = class(TObject)
  private
    FToken: string;
  public
    [Test]
    procedure TestAuth;
    [Test]
    procedure TestUsuarioGet;
    [Test]
    [TestCase('Test01', 'Gleryston,123')]
    procedure TestUsuarioPost(const Nome: string; const Senha: string);
    [Test]
    [TestCase('Test01', 'Gleryston,123')]
    procedure TestUsuarioPut(const Nome: string; const Senha: string);
    [Test]
    [TestCase('Test01', 'Gleryston')]
    procedure TestUsuarioDelete(const Nome: string);
  end;

implementation

procedure TControllerUsuarioTest.TestAuth;
var
  response: IResponse;
  content: TJSONObject;
begin
  FToken := '';
  response := TRequest.New.BaseURL('http://localhost:9002/Auth/Token')
    .Accept('application/json')
    .Get;

  content := TJSONObject.ParseJSONValue(response.Content) as TJSONObject;

  if (not content.GetValue('token').Null) then
    FToken := content.GetValue('token').Value;

  Assert.AreEqual(response.StatusCode, 200);
  Assert.IsNotEmpty(FToken);
end;

procedure TControllerUsuarioTest.TestUsuarioGet;
var
  response: IResponse;
  content: TJSONArray;
begin
  response := TRequest.New.BaseURL('http://localhost:9002/Api/Usuario')
    .Accept('application/json')
    .Token('Bearer ' + FToken)
    .Get;

  content := TJSONObject.ParseJSONValue(response.Content) as TJSONArray;

  Assert.AreEqual(response.StatusCode, 200);
  Assert.AreEqual(content.Count, 3);
end;

procedure TControllerUsuarioTest.TestUsuarioPost(const Nome: string; const Senha: string);
var
  response: IResponse;
  content: TJSONObject;
begin
  response := TRequest.New.BaseURL('http://localhost:9002/Api/Usuario')
    .Accept('application/json')
    .Token('Bearer ' + FToken)
    .AddBody('{"nome": "Gleryston","senha": "123"}')
    .Post;

  content := TJSONObject.ParseJSONValue(response.Content) as TJSONObject;
  Assert.AreEqual(response.StatusCode, 201);

  if (not content.GetValue('mensagem').Null) then
  begin
    Assert.AreEqual('Usuário ' + Nome + ' com a senha ' + Senha +
      ', foi criado com sucesso', content.GetValue('mensagem').Value)
  end
  else
    Assert.Fail('O retorno não está no formato correto.');
end;

procedure TControllerUsuarioTest.TestUsuarioPut(const Nome: string; const Senha: string);
var
  response: IResponse;
  content: TJSONObject;
begin
  response := TRequest.New.BaseURL('http://localhost:9002/Api/Usuario')
    .Accept('application/json')
    .Token('Bearer ' + FToken)
    .AddBody('{"nome": "Gleryston","senha": "123"}')
    .Put;

  content := TJSONObject.ParseJSONValue(response.Content) as TJSONObject;
  Assert.AreEqual(response.StatusCode, 200);

  if (not content.GetValue('mensagem').Null) then
  begin
    Assert.AreEqual('Usuário ' + Nome + ' com a senha ' + Senha +
      ', foi atualizado com sucesso', content.GetValue('mensagem').Value)
  end
  else
    Assert.Fail('O retorno não está no formato correto.');
end;

procedure TControllerUsuarioTest.TestUsuarioDelete(const Nome: string);
var
  response: IResponse;
  content: TJSONObject;
begin
  response := TRequest.New.BaseURL('http://localhost:9002/Api/Usuario/' + Nome)
    .Accept('application/json')
    .Token('Bearer ' + FToken)
    .Delete;

  content := TJSONObject.ParseJSONValue(response.Content) as TJSONObject;
  Assert.AreEqual(response.StatusCode, 200);

  if (not content.GetValue('mensagem').Null) then
    Assert.AreEqual('Usuário ' + Nome + ' excluído com sucesso',
      content.GetValue('mensagem').Value)
  else
    Assert.Fail('O retorno não está no formato correto.');
end;

initialization
  TDUnitX.RegisterTestFixture(TControllerUsuarioTest);

end.
