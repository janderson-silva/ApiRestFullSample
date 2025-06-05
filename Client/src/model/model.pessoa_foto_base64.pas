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



unit model.pessoa_foto_base64;

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
  interfaces.pessoa_foto_base64,
  route.api;

type
  TPessoa_foto_base64 = class(TInterfacedObject, iPessoa_foto_base64)
  private
    Fid: LargeInt;
    Fid_pessoa: LargeInt;
    Ffoto_base64: String;
  public
    constructor Create; overload;
    destructor Destroy; override;
    class function New : iPessoa_foto_base64;

    function id(Value: LargeInt): iPessoa_foto_base64; overload;
    function id: LargeInt; overload;

    function id_pessoa(Value: LargeInt): iPessoa_foto_base64; overload;
    function id_pessoa: LargeInt; overload;

    function foto_base64(Value: String): iPessoa_foto_base64; overload;
    function foto_base64: String; overload;

    function Select: TJSONObject; overload;
    function Insert(OnMessage: Boolean): String; overload;
    function Update(OnMessage: Boolean): String; overload;
    function Delete(OnMessage: Boolean): String; overload;
    function &End : iPessoa_foto_base64;
  end;

implementation

constructor TPessoa_foto_base64.Create;
begin

end;

destructor TPessoa_foto_base64.Destroy;
begin

end;

class function TPessoa_foto_base64.New: iPessoa_foto_base64;
begin
  Result := Self.Create;
end;

function TPessoa_foto_base64.&End: iPessoa_foto_base64;
begin
  Result := Self;
end;

function TPessoa_foto_base64.Select: TJSONObject;
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

  if Fid_pessoa > 0 then
    JSONFiltro.AddPair('id_pessoa', TJSONNumber.Create(id_pessoa));

  if Ffoto_base64 <> '' then
    JSONFiltro.AddPair('foto_base64', TJSONString.Create(foto_base64));

  // Incluíndo os detalhes conforme solicitado
  JSONBody.AddPair('filtros', JSONFiltro);
  JSONBody.AddPair('include', JSONInclude);

  Resp := TRequest.New
                  .BaseURL(TRoute.GetPessoa_foto_base64Route(TRoute.ACTION_SEARCH))
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

function TPessoa_foto_base64.Insert(OnMessage: Boolean) : String;
var
  Resp : IResponse;
  Token: string;
  JSONObject, JSONBody: TJSONObject;
begin
  Token := TToken.New
                 .GetToken;

  JSONBody := TJSONObject.Create;
  JSONBody.AddPair('id_pessoa', TJSONNumber.Create(id_pessoa));
  JSONBody.AddPair('foto_base64', TJSONString.Create(foto_base64));

  Resp := TRequest.New
                  .BaseURL(TRoute.GetPessoa_foto_base64Route(TRoute.ACTION_INSERT))
                  .TokenBearer(Token)
                  .AddBody(JSONBody)
                  .Post;

  if Resp.StatusCode <> 200 then
  begin
    Result := '';
    raise Exception.Create('Erro ao cadastrar pessoa_foto_base64' +
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

function TPessoa_foto_base64.Update(OnMessage: Boolean) : String;
var
  Resp : IResponse;
  Token: string;
  JSONObject, JSONBody: TJSONObject;
begin
  Token := TToken.New
                 .GetToken;

  JSONBody := TJSONObject.Create;
  JSONBody.AddPair('id', TJSONNumber.Create(id));
  JSONBody.AddPair('id_pessoa', TJSONNumber.Create(id_pessoa));
  JSONBody.AddPair('foto_base64', TJSONString.Create(foto_base64));

  Resp := TRequest.New
                  .BaseURL(TRoute.GetPessoa_foto_base64Route(TRoute.ACTION_UPDATE))
                  .TokenBearer(Token)
                  .AddBody(JSONBody)
                  .Put;

  if Resp.StatusCode <> 200 then
  begin
    Result := '';
    raise Exception.Create('Erro ao atualizar pessoa_foto_base64' +
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

function TPessoa_foto_base64.Delete(OnMessage: Boolean) : String;
var
  Resp : IResponse;
  Token: string;
  JSONObject: TJSONObject;
begin
  Token := TToken.New
                 .GetToken;

  Resp := TRequest.New
                  .BaseURL(TRoute.GetPessoa_foto_base64Route(TRoute.ACTION_DELETE))
                  .TokenBearer(Token)
                  .Delete;

  if Resp.StatusCode <> 200 then
  begin
    Result := '';
    raise Exception.Create('Erro ao deletar pessoa_foto_base64' +
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

function TPessoa_foto_base64.id(Value: LargeInt): iPessoa_foto_base64;
begin
  Fid := Value;
  Result := Self;
end;

function TPessoa_foto_base64.id: LargeInt;
begin
  Result := Fid;
end;

function TPessoa_foto_base64.id_pessoa(Value: LargeInt): iPessoa_foto_base64;
begin
  Fid_pessoa := Value;
  Result := Self;
end;

function TPessoa_foto_base64.id_pessoa: LargeInt;
begin
  Result := Fid_pessoa;
end;

function TPessoa_foto_base64.foto_base64(Value: String): iPessoa_foto_base64;
begin
  Ffoto_base64 := Value;
  Result := Self;
end;

function TPessoa_foto_base64.foto_base64: String;
begin
  Result := Ffoto_base64;
end;

end.
