unit model.auth;

interface

uses
  JOSE.Core.JWT,
  JOSE.Core.Builder,
  System.DateUtils,
  System.JSON,
  System.SysUtils,
  interfaces.auth;

type
  TAuth = class(TInterfacedObject, iAuth)
  public
    constructor Create; overload;
    destructor Destroy; override;
    class function New : iAuth;

    function CreateToken(out Erro : String) : TJSONObject; overload;

    function GetEnvVarValue: string;

    function &End : iAuth;
  end;

implementation

constructor TAuth.Create;
begin

end;

destructor TAuth.Destroy;
begin

end;

class function TAuth.New: iAuth;
begin
  Result := Self.Create;
end;

function TAuth.&End: iAuth;
begin
  Result := Self;
end;

function TAuth.CreateToken(out Erro : String) : TJSONObject;
var
  LToken: TJWT;
begin
  Erro := '';
  Result := TJSONObject.Create;

  LToken := TJWT.Create;
  try
    try
      LToken.Claims.Issuer := 'Atron Sistemas';
      LToken.Claims.Expiration := IncHour(Now, 1);

      Result.AddPair('token', TJOSE.SHA256CompactToken(GetEnvVarValue, LToken) );
    except
      on E: Exception do
      begin
        Erro := E.Message;
        Result.Free;
        Result := nil;
      end;
    end;
  finally
    LToken.Free;
  end;
end;

function TAuth.GetEnvVarValue: string;
const
  LVarName: string = 'ATRON_JWT_SECRET';
begin
  Result := GetEnvironmentVariable(LVarName);
  if Result = '' then
    raise Exception.CreateFmt('Variável de ambiente "%s" não encontrada.', [LVarName])
end;

end.
