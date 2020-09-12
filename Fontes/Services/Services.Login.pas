unit Services.Login;

interface

uses
  System.JSON, JOSE.Core.JWT, JOSE.Core.Builder, System.SysUtils;

type
  IServiceLogin = interface
    ['{1BDDEBC3-DF12-44A9-B80B-84912AFE21CA}']
    function Token: TJSONObject;
  end;

  TServiceLogin = class(TInterfacedObject, IServiceLogin)
  public
    function Token: TJSONObject;
  end;

implementation

{ TServiceLogin }

function TServiceLogin.Token: TJSONObject;
var
  token: TJWT;
begin
  token := TJWT.Create;
  try
    token.Claims.Issuer := 'Horse';
    token.Claims.Subject := 'Gleryston Matos';
    token.Claims.Expiration := Now + 1;

    result := TJSONObject.Create;
    result.AddPair(TJSONPair.Create('token', TJOSE.SHA256CompactToken('rest-api-horse', token)));
    result.AddPair(TJSONPair.Create('expiration', DateTimeToStr(token.Claims.Expiration)));
  finally
    FreeAndNil(token);
  end;
end;

end.
