unit ApiMethods;

interface

uses
  Horse, System.SysUtils, JSON, Horse.Commons;

procedure RotaDefault(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure RotaHelloWorld(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

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
    begin
      Res.Send('<!DOCTYPE html>' +
               '<html>' +
                 '<head>' +
                   '<meta charset="UTF-8" />' +
                   '<title>Horse</title>' +
                 '</head>' +
                 '<body>' +
                   '<h1>Horse</h1>' +
                   '<h2>Server Status - Offline</h2>' +
                 '</body>' +
               '</html>').Status(THTTPStatus.InternalServerError);
    end;
  end;
end;

procedure RotaHelloWorld(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  objeto: TJSONObject;
begin
  try
    objeto := TJSONObject.Create;
    objeto.AddPair(TJSONPair.Create('result', 'Hello World'));
    Res.Send<TJSONObject>(objeto.ToString).Status(THTTPStatus.OK);
  except
    on E: Exception do
    begin
      Res.Send('{"mensagem":"' + E.Message + '"}').Status(THTTPStatus.InternalServerError);
    end;
  end;
end;

end.
