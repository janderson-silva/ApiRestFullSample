unit controller.auth;

interface

uses
  Horse,
  System.JSON,
  System.SysUtils,
  interfaces.auth,
  model.auth;

procedure Registry;

implementation

procedure CreateToken(Req: THorseRequest; Res: THorseResponse);
var
  FAuth: iAuth;
  Erro : string;
  JSONAuth: TJSONObject;
begin
  try
    FAuth := TAuth.New;

    JSONAuth := FAuth
                  .CreateToken(Erro);

    if Erro <> '' then
      Res.Send(TJSONObject.Create.AddPair('Erro', Erro)).Status(500)
    else
      Res.Send<TJSONObject>(JSONAuth).Status(200);
  except on E : Exception do
    begin
      Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
      Exit;
    end;
  end;
end;

procedure Registry;
begin
    THorse
      .Post('create-token',CreateToken);
end;

end.
