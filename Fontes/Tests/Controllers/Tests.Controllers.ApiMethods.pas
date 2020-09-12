unit Tests.Controllers.ApiMethods;

interface

uses
  DUnitX.TestFramework, System.JSON, System.SysUtils, System.Classes,
  RESTRequest4D.Request;

type
  [TestFixture]
  TApiMethodsTest = class(TObject)
  private
    FToken: string;
  public
    [Test]
    procedure TestAuth;
    [Test]
    procedure TestDefault;
    [Test]
    procedure TestUnauthorized;
    [Test]
    [TestCase('Test01', 'Gleryston')]
    procedure TestEco(const Value: string);
    [Test]
    [TestCase('Test01', '10,20,30')]
    procedure TestSoma(const Value01: string; const Value02: string; const Result: string);
    [Test]
    [TestCase('Test01', '20,10,10')]
    procedure TestSubtrai(const Value01: string; const Value02: string; const Result: string);
  end;

implementation

procedure TApiMethodsTest.TestAuth;
var
  response: IResponse;
  content: TJSONObject;
begin
  FToken := '';
  response := TRequest.New.BaseURL('http://localhost:9000/Auth/Token')
    .Accept('application/json')
    .Get;

  content := TJSONObject.ParseJSONValue(response.Content) as TJSONObject;

  if (not content.GetValue('token').Null) then
    FToken := content.GetValue('token').Value;

  Assert.AreEqual(response.StatusCode, 200);
  Assert.IsNotEmpty(FToken);
end;

procedure TApiMethodsTest.TestUnauthorized;
var
  response: IResponse;
begin
  try
    response := TRequest.New.BaseURL('http://localhost:9000/Api/')
      .Accept('application/json')
      .Get;
  except
    on E: Exception do
      Assert.AreEqual(response.StatusCode, 401);
  end;
end;

procedure TApiMethodsTest.TestDefault;
var
  response: IResponse;
begin
  response := TRequest.New.BaseURL('http://localhost:9000/Api/')
    .Accept('application/json')
    .Token('Bearer ' + FToken)
    .Get;

  Assert.AreEqual(response.StatusCode, 200);
  Assert.AreEqual(response.Content, 'Server Status - Online');
end;

procedure TApiMethodsTest.TestEco(const Value: string);
var
  response: IResponse;
  content: TJSONObject;
begin
  response := TRequest.New.BaseURL('http://localhost:9000/Api/Eco/' + Value)
    .Accept('application/json')
    .Token('Bearer ' + FToken)
    .Get;

  content := TJSONObject.ParseJSONValue(response.Content) as TJSONObject;
  Assert.AreEqual(response.StatusCode, 200);

  if (not content.GetValue('result').Null) then
    Assert.AreEqual(Value, content.GetValue('result').Value)
  else
    Assert.Fail('O retorno não está no formato correto.');
end;

procedure TApiMethodsTest.TestSoma(const Value01: string; const Value02: string; const Result: string);
var
  response: IResponse;
  content: TJSONObject;
begin
  response := TRequest.New.BaseURL('http://localhost:9000/Api/Soma/' + Value01 + '/' + Value02)
    .Accept('application/json')
    .Token('Bearer ' + FToken)
    .Get;

  content := TJSONObject.ParseJSONValue(response.Content) as TJSONObject;
  Assert.AreEqual(response.StatusCode, 200);

  if (not content.GetValue('result').Null) then
    Assert.AreEqual(Result, content.GetValue('result').Value)
  else
    Assert.Fail('O retorno não está no formato correto.');
end;

procedure TApiMethodsTest.TestSubtrai(const Value01: string; const Value02: string; const Result: string);
var
  response: IResponse;
  content: TJSONObject;
begin
  response := TRequest.New.BaseURL('http://localhost:9000/Api/Subtrai?value01=' + Value01 + '&value02=' + Value02)
    .Accept('application/json')
    .Token('Bearer ' + FToken)
    .Get;

  content := TJSONObject.ParseJSONValue(response.Content) as TJSONObject;
  Assert.AreEqual(response.StatusCode, 200);

  if (not content.GetValue('result').Null) then
    Assert.AreEqual(Result, content.GetValue('result').Value)
  else
    Assert.Fail('O retorno não está no formato correto.');
end;

initialization
  TDUnitX.RegisterTestFixture(TApiMethodsTest);

end.

