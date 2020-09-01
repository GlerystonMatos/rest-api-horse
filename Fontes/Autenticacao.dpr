program Autenticacao;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  JOSE.Core.JWT,
  JOSE.Core.Builder,
  Horse.Compression,
  Horse.HandleException,
  System.JSON,
  System.SysUtils;

begin
  try
    THorse.Use(Compression());
    THorse.Use(Jhonson);
    THorse.Use(HandleException);

    THorse.Get('/Auth',
      procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
      var
        token: TJWT;
        objeto: TJSONObject;
      begin
        try
          token := TJWT.Create;
          try
            token.Claims.Issuer := 'Horse';
            token.Claims.Subject := 'Gleryston Matos';
            token.Claims.Expiration := Now + 1;

            objeto := TJSONObject.Create;
            objeto.AddPair(TJSONPair.Create('token', TJOSE.SHA256CompactToken('rest-api-horse', token)));
            Res.Send<TJSONObject>(objeto).Status(THTTPStatus.OK);
          finally
            token.Free;
          end;
        except
          on E: Exception do
            raise Exception.Create(E.Message);
        end;
      end);

    THorse.Listen(9002);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
