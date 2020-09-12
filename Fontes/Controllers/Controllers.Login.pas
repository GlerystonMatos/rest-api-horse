unit Controllers.Login;

interface

uses
  Horse, System.JSON, System.SysUtils, Services.Login;

procedure Registry;
procedure GetToken(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse
    .Group
      .Prefix('/Auth')
        .Get('/Token',GetToken)
end;

procedure GetToken(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  login: IServiceLogin;
begin
  try
    login := TServiceLogin.Create;
    Res.Send<TJSONObject>(login.Token);
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

end.
