unit model.token;

interface

uses
  RESTRequest4D,
  System.JSON,
  System.SysUtils,
  interfaces.token;

type
  TToken = class(TInterfacedObject, iToken)
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iToken;

      function GetToken: string; overload;

      function &End : iToken;
  end;

implementation

{ TTOken }

constructor TToken.Create;
begin

end;

destructor TToken.Destroy;
begin

end;

class function TToken.New: iToken;
begin
  Result := Self.Create;
end;

function TToken.&End: iToken;
begin
  Result := Self;
end;

function TToken.GetToken: string;
var
  Resp : IResponse;
  JSONObject: TJSONObject;
begin
  //Vamos solicitar o TOKEN
  Resp := TRequest.New
                  .BaseURL('http://localhost:5000/create-token')
                  .Post;

  if Resp.StatusCode <> 200 then
  begin
    Result := '';
    raise Exception.Create('Erro ao obter token' +
                            sLineBreak + 'Status Code: ' + Resp.StatusCode.ToString +
                            sLineBreak + Resp.Content );
  end;

  JSONObject := TJSONValue.ParseJSONValue(Resp.Content) as TJSONObject;
  try
    if not Assigned(JSONObject) then
      raise Exception.Create('Erro: resposta inválida ao obter token.');

    Result := JSONObject.GetValue<string>('token');
  finally
    JSONObject.Free;
  end;
end;

end.
