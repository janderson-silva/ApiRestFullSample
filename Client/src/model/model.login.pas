{*******************************************************************************}
{ Projeto: Gerador de API                                                       }
{                                                                               }
{ O objetivo da aplicação é facilitar a criação de Interface, model e controller}
{ para Insert, Update, Delete e Select a partir de tabelas do banco de dados    }
{ (Postgres ou Firebird), respeitando a tipagem, PK e FK                        }
{*******************************************************************************}
{                                                                               }
{ Desenvolvido por JANDERSON APARECIDO DA SILVA                                 }
{ Email: janderson_rm@hotmail.com                                               }
{                                                                               }
{*******************************************************************************}



unit model.login;

interface

uses
  RESTRequest4D,
  Data.DB,
  System.JSON,
  System.SysUtils,
  Vcl.Dialogs,
  Vcl.Forms,
  Winapi.Windows,
  interfaces.token,
  model.token,
  interfaces.login,
  route.api;

type
  TLogin = class(TInterfacedObject, iLogin)
  private
    Fid: LargeInt;
    Fativo: Boolean;
    Femail: String;
    Fsenha: String;
  public
    constructor Create; overload;
    destructor Destroy; override;
    class function New : iLogin;

    function id(Value: LargeInt): iLogin; overload;
    function id: LargeInt; overload;

    function ativo(Value: Boolean): iLogin; overload;
    function ativo: Boolean; overload;

    function email(Value: String): iLogin; overload;
    function email: String; overload;

    function senha(Value: String): iLogin; overload;
    function senha: String; overload;

    function Select: TJSONObject; overload;
    function Insert(OnMessage: Boolean): String; overload;
    function Update(OnMessage: Boolean): String; overload;
    function Delete(OnMessage: Boolean): String; overload;
    function &End : iLogin;
  end;

implementation

constructor TLogin.Create;
begin

end;

destructor TLogin.Destroy;
begin

end;

class function TLogin.New: iLogin;
begin
  Result := Self.Create;
end;

function TLogin.&End: iLogin;
begin
  Result := Self;
end;

function TLogin.Select: TJSONObject;
var
  Resp : IResponse;
  Token: string;
  JSONFiltro, JSONInclude, JSONBody: TJSONObject;
begin
  Token := TToken.New
                 .GetToken;
  // Montar o Filtro e o Inlcude
  JSONFiltro := TJSONObject.Create;
  JSONInclude := TJSONObject.Create;
  JSONBody := TJSONObject.Create;

  // Filtros - só adiciona se for informado
  if Fid > 0 then
    JSONFiltro.AddPair('id', TJSONNumber.Create(id));

  if Fativo = True then
    JSONFiltro.AddPair('ativo', TJSONBool.Create(ativo));

  if Femail <> '' then
    JSONFiltro.AddPair('email', TJSONString.Create(email));

  if Fsenha <> '' then
    JSONFiltro.AddPair('senha', TJSONString.Create(senha));

  // Incluíndo os detalhes conforme solicitado
  JSONBody.AddPair('filtros', JSONFiltro);
  JSONBody.AddPair('include', JSONInclude);

  Resp := TRequest.New
                  .BaseURL(TRoute.GetLoginRoute(TRoute.ACTION_SEARCH))
                  .TokenBearer(Token)
                  .AddBody(JSONBody)
                  .Post;

  if Resp.StatusCode = 200 then
    Result := TJSONValue.ParseJSONValue(Resp.Content) as TJSONObject
  else
  if Resp.StatusCode = 404 then
    Result := TJSONObject.Create  // <- cria JSON vazio
  else
    raise Exception.Create('Erro ao consultar pessoa' +
                            sLineBreak + 'Status Code: ' + Resp.StatusCode.ToString +
                            sLineBreak + Resp.Content );

end;

function TLogin.Insert(OnMessage: Boolean) : String;
var
  Resp : IResponse;
  Token: string;
  JSONObject, JSONBody: TJSONObject;
begin
  Token := TToken.New
                 .GetToken;

  JSONBody := TJSONObject.Create;
  JSONBody.AddPair('ativo', TJSONBool.Create(ativo));
  JSONBody.AddPair('email', TJSONString.Create(email));
  JSONBody.AddPair('senha', TJSONString.Create(senha));

  Resp := TRequest.New
                  .BaseURL(TRoute.GetLoginRoute(TRoute.ACTION_INSERT))
                  .TokenBearer(Token)
                  .AddBody(JSONBody)
                  .Post;

  if Resp.StatusCode <> 200 then
  begin
    Result := '';
    raise Exception.Create('Erro ao cadastrar login' +
                            sLineBreak + 'Status Code: ' + Resp.StatusCode.ToString +
                            sLineBreak + Resp.Content );
  end;

  JSONObject := TJSONValue.ParseJSONValue(Resp.Content) as TJSONObject;
  try
    Fid := JSONObject.GetValue<LargeInt>('id');
    if OnMessage then
      Application.MessageBox(PChar(JSONObject.GetValue<string>('Sucesso') +
                                   sLineBreak + 'id: ' + Fid.ToString),'Atenção',MB_OK+MB_ICONINFORMATION);
  finally
    JSONObject.Free;
  end;
end;

function TLogin.Update(OnMessage: Boolean) : String;
var
  Resp : IResponse;
  Token: string;
  JSONObject, JSONBody: TJSONObject;
begin
  Token := TToken.New
                 .GetToken;

  JSONBody := TJSONObject.Create;
  JSONBody.AddPair('id', TJSONNumber.Create(id));
  JSONBody.AddPair('ativo', TJSONBool.Create(ativo));
  JSONBody.AddPair('email', TJSONString.Create(email));
  JSONBody.AddPair('senha', TJSONString.Create(senha));

  Resp := TRequest.New
                  .BaseURL(TRoute.GetLoginRoute(TRoute.ACTION_UPDATE))
                  .TokenBearer(Token)
                  .AddBody(JSONBody)
                  .Put;

  if Resp.StatusCode <> 200 then
  begin
    Result := '';
    raise Exception.Create('Erro ao atualizar login' +
                            sLineBreak + 'Status Code: ' + Resp.StatusCode.ToString +
                            sLineBreak + Resp.Content );
  end;

  JSONObject := TJSONValue.ParseJSONValue(Resp.Content) as TJSONObject;
  try
    Fid := JSONObject.GetValue<LargeInt>('id');
    if OnMessage then
      Application.MessageBox(PChar(JSONObject.GetValue<string>('Sucesso') +
                                   sLineBreak + 'id: ' + Fid.ToString),'Atenção',MB_OK+MB_ICONINFORMATION);
  finally
    JSONObject.Free;
  end;
end;

function TLogin.Delete(OnMessage: Boolean) : String;
var
  Resp : IResponse;
  Token: string;
  JSONObject: TJSONObject;
begin
  Token := TToken.New
                 .GetToken;

  Resp := TRequest.New
                  .BaseURL(TRoute.GetLoginRoute(TRoute.ACTION_DELETE))
                  .TokenBearer(Token)
                  .Delete;

  if Resp.StatusCode <> 200 then
  begin
    Result := '';
    raise Exception.Create('Erro ao deletar login' +
                            sLineBreak + 'Status Code: ' + Resp.StatusCode.ToString +
                            sLineBreak + Resp.Content );
  end;

  JSONObject := TJSONValue.ParseJSONValue(Resp.Content) as TJSONObject;
  try
    Fid := JSONObject.GetValue<LargeInt>('id');
    if OnMessage then
      Application.MessageBox(PChar(JSONObject.GetValue<string>('Sucesso') +
                                   sLineBreak + 'id: ' + Fid.ToString),'Atenção',MB_OK+MB_ICONINFORMATION);
  finally
    JSONObject.Free;
  end;
end;

function TLogin.id(Value: LargeInt): iLogin;
begin
  Fid := Value;
  Result := Self;
end;

function TLogin.id: LargeInt;
begin
  Result := Fid;
end;

function TLogin.ativo(Value: Boolean): iLogin;
begin
  Fativo := Value;
  Result := Self;
end;

function TLogin.ativo: Boolean;
begin
  Result := Fativo;
end;

function TLogin.email(Value: String): iLogin;
begin
  Femail := Value;
  Result := Self;
end;

function TLogin.email: String;
begin
  Result := Femail;
end;

function TLogin.senha(Value: String): iLogin;
begin
  Fsenha := Value;
  Result := Self;
end;

function TLogin.senha: String;
begin
  Result := Fsenha;
end;

end.
