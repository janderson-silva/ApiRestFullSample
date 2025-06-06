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



unit model.pessoa;

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
  interfaces.pessoa,
  route.api;

type
  TPessoa = class(TInterfacedObject, iPessoa)
  private
    Fid: LargeInt;
    Fativo: Boolean;
    Fnome: String;
    Fdocumento: String;
  public
    constructor Create; overload;
    destructor Destroy; override;
    class function New : iPessoa;

    function id(Value: LargeInt): iPessoa; overload;
    function id: LargeInt; overload;

    function ativo(Value: Boolean): iPessoa; overload;
    function ativo: Boolean; overload;

    function nome(Value: String): iPessoa; overload;
    function nome: String; overload;

    function documento(Value: String): iPessoa; overload;
    function documento: String; overload;

    function Select: TJSONObject; overload;
    function Insert(OnMessage: Boolean): String; overload;
    function Update(OnMessage: Boolean): String; overload;
    function Delete(OnMessage: Boolean): String; overload;
    function &End : iPessoa;
  end;

implementation

constructor TPessoa.Create;
begin

end;

destructor TPessoa.Destroy;
begin

end;

class function TPessoa.New: iPessoa;
begin
  Result := Self.Create;
end;

function TPessoa.&End: iPessoa;
begin
  Result := Self;
end;

function TPessoa.Select: TJSONObject;
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

  if Fnome <> '' then
    JSONFiltro.AddPair('nome', TJSONString.Create(nome));

  if Fdocumento <> '' then
    JSONFiltro.AddPair('documento', TJSONString.Create(documento));

  // Incluíndo os detalhes conforme solicitado
  JSONBody.AddPair('filtros', JSONFiltro);
  JSONBody.AddPair('include', JSONInclude);

  Resp := TRequest.New
                  .BaseURL(TRoute.GetPessoaRoute(TRoute.ACTION_SEARCH))
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

function TPessoa.Insert(OnMessage: Boolean) : String;
var
  Resp : IResponse;
  Token: string;
  JSONObject, JSONBody: TJSONObject;
begin
  Token := TToken.New
                 .GetToken;

  JSONBody := TJSONObject.Create;
  JSONBody.AddPair('ativo', TJSONBool.Create(ativo));
  JSONBody.AddPair('nome', TJSONString.Create(nome));
  JSONBody.AddPair('documento', TJSONString.Create(documento));

  Resp := TRequest.New
                  .BaseURL(TRoute.GetPessoaRoute(TRoute.ACTION_INSERT))
                  .TokenBearer(Token)
                  .AddBody(JSONBody)
                  .Post;

  if Resp.StatusCode <> 200 then
  begin
    Result := '';
    raise Exception.Create('Erro ao cadastrar pessoa' +
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

function TPessoa.Update(OnMessage: Boolean) : String;
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
  JSONBody.AddPair('nome', TJSONString.Create(nome));
  JSONBody.AddPair('documento', TJSONString.Create(documento));

  Resp := TRequest.New
                  .BaseURL(TRoute.GetPessoaRoute(TRoute.ACTION_UPDATE))
                  .TokenBearer(Token)
                  .AddBody(JSONBody)
                  .Put;

  if Resp.StatusCode <> 200 then
  begin
    Result := '';
    raise Exception.Create('Erro ao atualizar pessoa' +
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

function TPessoa.Delete(OnMessage: Boolean) : String;
var
  Resp : IResponse;
  Token: string;
  JSONObject: TJSONObject;
begin
  Token := TToken.New
                 .GetToken;

  Resp := TRequest.New
                  .BaseURL(TRoute.GetPessoaRoute(TRoute.ACTION_DELETE) + '/' + id.ToString)
                  .TokenBearer(Token)
                  .Delete;

  if Resp.StatusCode <> 200 then
  begin
    Result := '';
    raise Exception.Create('Erro ao deletar pessoa' +
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

function TPessoa.id(Value: LargeInt): iPessoa;
begin
  Fid := Value;
  Result := Self;
end;

function TPessoa.id: LargeInt;
begin
  Result := Fid;
end;

function TPessoa.ativo(Value: Boolean): iPessoa;
begin
  Fativo := Value;
  Result := Self;
end;

function TPessoa.ativo: Boolean;
begin
  Result := Fativo;
end;

function TPessoa.nome(Value: String): iPessoa;
begin
  Fnome := Value;
  Result := Self;
end;

function TPessoa.nome: String;
begin
  Result := Fnome;
end;

function TPessoa.documento(Value: String): iPessoa;
begin
  Fdocumento := Value;
  Result := Self;
end;

function TPessoa.documento: String;
begin
  Result := Fdocumento;
end;

end.
