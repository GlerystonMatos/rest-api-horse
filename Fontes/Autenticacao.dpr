program Autenticacao;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  System.JSON,
  Horse.Commons,
  Horse.Jhonson,
  JOSE.Core.JWT,
  Horse.Constants,
  System.SysUtils,
  JOSE.Core.Builder,
  Horse.Compression,
  Horse.HandleException;

begin
  try
    THorse
      .Use(Compression())
      .Use(Jhonson)
      .Use(HandleException);

    THorse
      .Group
      .Prefix('/Api')
        .Get('/Auth',
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

    THorse.Listen(9002,
      procedure(Horse: THorse)
      begin
        Writeln(Format(START_RUNNING, [Horse.Host, Horse.Port]));
      end);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
