unit ApiMethodsTest;

interface

uses
  DUnitX.TestFramework, Winapi.Windows, IdHTTP, System.JSON, System.SysUtils,
  Vcl.Forms, System.Classes;

type
  [TestFixture]
  TApiMethodsTest = class(TObject)
  private
    FToken: string;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestAuth;
    [Test]
    procedure TestDefault;
    [Test]
    procedure TestUnauthorized;
    [Test]
    [TestCase('Test01', 'Gleryston')]
    [TestCase('Test02', 'Tobias')]
    [TestCase('Test03', 'Lola')]
    [TestCase('Test04', 'Snoopy')]
    procedure TestEco(const aValue: string);
    [Test]
    [TestCase('Test01', '10,20,30')]
    [TestCase('Test02', '30,40,70')]
    procedure TestSoma(const aValue01: string; const aValue02: string; const aResult: string);
    [Test]
    procedure TestUsuarioGet;
    [Test]
    [TestCase('Test01', 'Gleryston,123')]
    [TestCase('Test02', 'Tobias,456')]
    procedure TestUsuarioPost(const aNome: string; const aSenha: string);
    [Test]
    [TestCase('Test01', 'Gleryston,123')]
    [TestCase('Test02', 'Tobias,456')]
    procedure TestUsuarioPut(const aNome: string; const aSenha: string);
    [Test]
    [TestCase('Test01', 'Gleryston')]
    [TestCase('Test02', 'Tobias')]
    procedure TestUsuarioDelete(const aNome: string);
  end;

implementation

procedure TApiMethodsTest.Setup;
begin
end;

procedure TApiMethodsTest.TearDown;
begin
end;

procedure TApiMethodsTest.TestAuth;
var
  idHTTP: TIdHTTP;
  responseBody: string;
  response: TJSONObject;
begin
  idHTTP := TIdHTTP.Create(nil);
  try
    responseBody := idHTTP.Get('http://localhost:9002/Api/Auth');

    Assert.AreEqual(idHTTP.ResponseCode, 200);
    response := TJSONObject.ParseJSONValue(responseBody) as TJSONObject;

    FToken := '';
    if (not response.GetValue('token').Null) then
      FToken := response.GetValue('token').value;
    Assert.IsNotEmpty(FToken);
  finally
    FreeAndNil(idHTTP);
  end;
end;

procedure TApiMethodsTest.TestUnauthorized;
var
  idHTTP: TIdHTTP;
  responseBody: string;
begin
  idHTTP := TIdHTTP.Create(nil);
  try
    try
      responseBody := idHTTP.Get('http://localhost:9000/Api/');
    except
      on E: Exception do
        Assert.AreEqual(idHTTP.ResponseCode, 401);
    end;
  finally
    FreeAndNil(idHTTP);
  end;
end;

procedure TApiMethodsTest.TestDefault;
var
  idHTTP: TIdHTTP;
  responseBody: string;
begin
  idHTTP := TIdHTTP.Create(nil);
  try
    idHTTP.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + FToken;
    responseBody := idHTTP.Get('http://localhost:9000/Api/');
    Assert.AreEqual(idHTTP.ResponseCode, 200);
    Assert.AreEqual(responseBody,
      '<!DOCTYPE html>' +
      '<html>' +
        '<head>' +
          '<meta charset="UTF-8" />' +
          '<title>Horse</title>' +
        '</head>' +
        '<body>' +
          '<h1>Horse</h1>' +
          '<h2>Server Status - Online</h2>' +
        '</body>' +
      '</html>');
  finally
    FreeAndNil(idHTTP);
  end;
end;

procedure TApiMethodsTest.TestEco(const aValue: string);
var
  idHTTP: TIdHTTP;
  responseBody: string;
  response: TJSONObject;
begin
  idHTTP := TIdHTTP.Create(nil);
  try
    idHTTP.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + FToken;
    responseBody := idHTTP.Get('http://localhost:9000/Api/Eco?value=' + aValue + '');
    response := TJSONObject.ParseJSONValue(responseBody) as TJSONObject;

    Assert.AreEqual(idHTTP.ResponseCode, 200);

    if (not response.GetValue('result').Null) then
      Assert.AreEqual(aValue, response.GetValue('result').value)
    else
      Assert.Fail('O retorno não está no formato correto.');
  finally
    FreeAndNil(idHTTP);
  end;
end;

procedure TApiMethodsTest.TestSoma(const aValue01: string; const aValue02: string; const aResult: string);
var
  idHTTP: TIdHTTP;
  responseBody: string;
  response: TJSONObject;
begin
  idHTTP := TIdHTTP.Create(nil);
  try
    idHTTP.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + FToken;
    responseBody := idHTTP.Get('http://localhost:9000/Api/Soma?value01=' + aValue01 + '&value02=' + aValue02 + '');
    response := TJSONObject.ParseJSONValue(responseBody) as TJSONObject;

    Assert.AreEqual(idHTTP.ResponseCode, 200);

    if (not response.GetValue('result').Null) then
      Assert.AreEqual(aResult, response.GetValue('result').value)
    else
      Assert.Fail('O retorno não está no formato correto.');
  finally
    FreeAndNil(idHTTP);
  end;
end;

procedure TApiMethodsTest.TestUsuarioGet;
var
  idHTTP: TIdHTTP;
  responseBody: string;
  response: TJSONArray;
begin
  idHTTP := TIdHTTP.Create(nil);
  try
    idHTTP.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + FToken;
    responseBody := idHTTP.Get('http://localhost:9000/Api/Usuario');
    response := TJSONObject.ParseJSONValue(responseBody) as TJSONArray;

    Assert.AreEqual(idHTTP.ResponseCode, 200);
    Assert.AreEqual(response.Count, 3);
  finally
    FreeAndNil(idHTTP);
  end;
end;

procedure TApiMethodsTest.TestUsuarioPost(const aNome: string; const aSenha: string);
var
  idHTTP: TIdHTTP;
  responseBody: string;
  response: TJSONObject;
  request: TJSONObject;
  requestBody: TStringStream;
begin
  idHTTP := TIdHTTP.Create(nil);
  try
    request := TJSONObject.Create;
    request.AddPair(TJSONPair.Create('nome', aNome));
    request.AddPair(TJSONPair.Create('senha', aSenha));

    requestBody := TStringStream.Create(request.ToString);
    try
      idHTTP.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + FToken;
      responseBody := idHTTP.Post('http://localhost:9000/Api/Usuario', requestBody);
      response := TJSONObject.ParseJSONValue(responseBody) as TJSONObject;

      Assert.AreEqual(idHTTP.ResponseCode, 200);

      if (not response.GetValue('mensagem').Null) then
      begin
        Assert.AreEqual('Usuário ' + aNome + ' com a senha ' + aSenha +
          ', foi criado com sucesso', response.GetValue('mensagem').value)
      end
      else
        Assert.Fail('O retorno não está no formato correto.');
    finally
      FreeAndNil(requestBody);
    end;
  finally
    FreeAndNil(idHTTP);
  end;
end;

procedure TApiMethodsTest.TestUsuarioPut(const aNome: string; const aSenha: string);
var
  idHTTP: TIdHTTP;
  responseBody: string;
  response: TJSONObject;
  request: TJSONObject;
  requestBody: TStringStream;
begin
  idHTTP := TIdHTTP.Create(nil);
  try
    request := TJSONObject.Create;
    request.AddPair(TJSONPair.Create('nome', aNome));
    request.AddPair(TJSONPair.Create('senha', aSenha));

    requestBody := TStringStream.Create(request.ToString);
    try
      idHTTP.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + FToken;
      responseBody := idHTTP.Put('http://localhost:9000/Api/Usuario', requestBody);
      response := TJSONObject.ParseJSONValue(responseBody) as TJSONObject;

      Assert.AreEqual(idHTTP.ResponseCode, 200);

      if (not response.GetValue('mensagem').Null) then
      begin
        Assert.AreEqual('Usuário ' + aNome + ' com a senha ' + aSenha +
          ', foi atualizado com sucesso', response.GetValue('mensagem').value)
      end
      else
        Assert.Fail('O retorno não está no formato correto.');
    finally
      FreeAndNil(requestBody);
    end;
  finally
    FreeAndNil(idHTTP);
  end;
end;

procedure TApiMethodsTest.TestUsuarioDelete(const aNome: string);
var
  idHTTP: TIdHTTP;
  responseBody: string;
  response: TJSONObject;
begin
  idHTTP := TIdHTTP.Create(nil);
  try
    idHTTP.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + FToken;
    responseBody := idHTTP.Delete('http://localhost:9000/Api/Usuario?nome=' + aNome + '');
    response := TJSONObject.ParseJSONValue(responseBody) as TJSONObject;

    Assert.AreEqual(idHTTP.ResponseCode, 200);

    if (not response.GetValue('mensagem').Null) then
      Assert.AreEqual('Usuário ' + aNome + ' excluído com sucesso', response.GetValue('mensagem').value)
    else
      Assert.Fail('O retorno não está no formato correto.');
  finally
    FreeAndNil(idHTTP);
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TApiMethodsTest);

end.
