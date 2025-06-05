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



unit model.pessoa_foto_binary;

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
  interfaces.pessoa_foto_binary,
  route.api;

type
  TPessoa_foto_binary = class(TInterfacedObject, iPessoa_foto_binary)
  private
    Fid: LargeInt;
    Fid_pessoa: LargeInt;
    Ffoto_binary: String;
    Fnome_arquivo: String;
    Fextensao: String;
  public
    constructor Create; overload;
    destructor Destroy; override;
    class function New : iPessoa_foto_binary;

    function id(Value: LargeInt): iPessoa_foto_binary; overload;
    function id: LargeInt; overload;

    function id_pessoa(Value: LargeInt): iPessoa_foto_binary; overload;
    function id_pessoa: LargeInt; overload;

    function foto_binary(Value: String): iPessoa_foto_binary; overload;
    function foto_binary: String; overload;

    function nome_arquivo(Value: String): iPessoa_foto_binary; overload;
    function nome_arquivo: String; overload;

    function extensao(Value: String): iPessoa_foto_binary; overload;
    function extensao: String; overload;

    function Select: TJSONObject; overload;
    function Insert(OnMessage: Boolean): String; overload;
    function Update(OnMessage: Boolean): String; overload;
    function Delete(OnMessage: Boolean): String; overload;
    function &End : iPessoa_foto_binary;
  end;

implementation

constructor TPessoa_foto_binary.Create;
begin

end;

destructor TPessoa_foto_binary.Destroy;
begin

end;

class function TPessoa_foto_binary.New: iPessoa_foto_binary;
begin
  Result := Self.Create;
end;

function TPessoa_foto_binary.&End: iPessoa_foto_binary;
begin
  Result := Self;
end;

function TPessoa_foto_binary.Select: TJSONObject;
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

  if Ffoto_binary <> Null then
    JSONFiltro.AddPair('foto_binary', TJSONString.Create(foto_binary));

  if Fnome_arquivo <> '' then
    JSONFiltro.AddPair('nome_arquivo', TJSONString.Create(nome_arquivo));

  if Fextensao <> '' then
    JSONFiltro.AddPair('extensao', TJSONString.Create(extensao));

  // Incluíndo os detalhes conforme solicitado
  JSONBody.AddPair('filtros', JSONFiltro);
  JSONBody.AddPair('include', JSONInclude);

  Resp := TRequest.New
                  .BaseURL(TRoute.GetPessoa_foto_binaryRoute(TRoute.ACTION_SEARCH))
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

function TPessoa_foto_binary.Insert(OnMessage: Boolean) : String;
var
  Resp : IResponse;
  Token: string;
  JSONObject, JSONBody: TJSONObject;
begin
  Token := TToken.New
                 .GetToken;

  JSONBody := TJSONObject.Create;
  JSONBody.AddPair('id_pessoa', TJSONNumber.Create(id_pessoa));
  JSONBody.AddPair('foto_binary', TJSONString.Create(foto_binary));
  JSONBody.AddPair('nome_arquivo', TJSONString.Create(nome_arquivo));
  JSONBody.AddPair('extensao', TJSONString.Create(extensao));

  Resp := TRequest.New
                  .BaseURL(TRoute.GetPessoa_foto_binaryRoute(TRoute.ACTION_INSERT))
                  .TokenBearer(Token)
                  .AddBody(JSONBody)
                  .Post;

  if Resp.StatusCode <> 200 then
  begin
    Result := '';
    raise Exception.Create('Erro ao cadastrar pessoa_foto_binary' +
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

function TPessoa_foto_binary.Update(OnMessage: Boolean) : String;
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
  JSONBody.AddPair('foto_binary', TJSONString.Create(foto_binary));
  JSONBody.AddPair('nome_arquivo', TJSONString.Create(nome_arquivo));
  JSONBody.AddPair('extensao', TJSONString.Create(extensao));

  Resp := TRequest.New
                  .BaseURL(TRoute.GetPessoa_foto_binaryRoute(TRoute.ACTION_UPDATE))
                  .TokenBearer(Token)
                  .AddBody(JSONBody)
                  .Put;

  if Resp.StatusCode <> 200 then
  begin
    Result := '';
    raise Exception.Create('Erro ao atualizar pessoa_foto_binary' +
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

function TPessoa_foto_binary.Delete(OnMessage: Boolean) : String;
var
  Resp : IResponse;
  Token: string;
  JSONObject: TJSONObject;
begin
  Token := TToken.New
                 .GetToken;

  Resp := TRequest.New
                  .BaseURL(TRoute.GetPessoa_foto_binaryRoute(TRoute.ACTION_DELETE))
                  .TokenBearer(Token)
                  .Delete;

  if Resp.StatusCode <> 200 then
  begin
    Result := '';
    raise Exception.Create('Erro ao deletar pessoa_foto_binary' +
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

function TPessoa_foto_binary.id(Value: LargeInt): iPessoa_foto_binary;
begin
  Fid := Value;
  Result := Self;
end;

function TPessoa_foto_binary.id: LargeInt;
begin
  Result := Fid;
end;

function TPessoa_foto_binary.id_pessoa(Value: LargeInt): iPessoa_foto_binary;
begin
  Fid_pessoa := Value;
  Result := Self;
end;

function TPessoa_foto_binary.id_pessoa: LargeInt;
begin
  Result := Fid_pessoa;
end;

function TPessoa_foto_binary.foto_binary(Value: String): iPessoa_foto_binary;
begin
  Ffoto_binary := Value;
  Result := Self;
end;

function TPessoa_foto_binary.foto_binary: String;
begin
  Result := Ffoto_binary;
end;

function TPessoa_foto_binary.nome_arquivo(Value: String): iPessoa_foto_binary;
begin
  Fnome_arquivo := Value;
  Result := Self;
end;

function TPessoa_foto_binary.nome_arquivo: String;
begin
  Result := Fnome_arquivo;
end;

function TPessoa_foto_binary.extensao(Value: String): iPessoa_foto_binary;
begin
  Fextensao := Value;
  Result := Self;
end;

function TPessoa_foto_binary.extensao: String;
begin
  Result := Fextensao;
end;

end.
