unit Controllers.ApiMethods;

interface

uses
  Horse, System.SysUtils, System.JSON;

procedure Registry;
procedure GetDefault(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetEco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetSoma(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetSubtrai(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse
    .Group
      .Prefix('/Api')
        .Get('/', GetDefault)
        .Get('/Eco/:value', GetEco)
        .Get('/Soma/:value01/:value02', GetSoma)
        .Get('/Subtrai', GetSubtrai)
end;

procedure GetDefault(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('Server Status - Online');
end;

procedure GetEco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  result: TJSONObject;
begin
  try
    result := TJSONObject.Create;
    result.AddPair(TJSONPair.Create('result', Req.Params['value']));
    Res.Send<TJSONObject>(result);
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure GetSoma(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  value01: Integer;
  value02: Integer;
  result: TJSONObject;
begin
  try
    value01 := Req.Params['value01'].ToInteger;
    value02 := Req.Params['value02'].ToInteger;

    result := TJSONObject.Create;
    result.AddPair(TJSONPair.Create('result', IntToStr((value01 + value02))));
    Res.Send<TJSONObject>(result);
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure GetSubtrai(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  value01: Integer;
  value02: Integer;
  result: TJSONObject;
begin
  try
    value01 := 0;
    if (Req.Query.ContainsKey('value01')) then
      value01 := StrToInt(Req.Query.Items['value01']);

    value02 := 0;
    if (Req.Query.ContainsKey('value02')) then
      value02 := StrToInt(Req.Query.Items['value02']);

    result := TJSONObject.Create;
    result.AddPair(TJSONPair.Create('result', IntToStr((value01 - value02))));
    Res.Send<TJSONObject>(result);
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

end.
