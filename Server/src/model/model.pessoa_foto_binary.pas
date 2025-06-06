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
  Data.DB,
  DataSet.Serialize,
  FireDAC.Comp.Client,
  System.Classes,
  System.JSON,
  System.SysUtils,
  interfaces.pessoa_foto_binary,
  model.connection;

type
  TPessoa_foto_binary = class(TInterfacedObject, iPessoa_foto_binary)
  private
    Fid: LargeInt;
    Fid_pessoa: LargeInt;
    Ffoto_binary: TMemoryStream;
    Fnome_arquivo: String;
    Fextensao: String;

    function GetPessoa_foto_binary(const Filtros: TJSONObject): TFDQuery;
  public
    constructor Create; overload;
    destructor Destroy; override;
    class function New : iPessoa_foto_binary;

    function id(Value: LargeInt): iPessoa_foto_binary; overload;
    function id: LargeInt; overload;

    function id_pessoa(Value: LargeInt): iPessoa_foto_binary; overload;
    function id_pessoa: LargeInt; overload;

    function foto_binary(Value: TMemoryStream): iPessoa_foto_binary; overload;
    function foto_binary: TMemoryStream; overload;

    function nome_arquivo(Value: String): iPessoa_foto_binary; overload;
    function nome_arquivo: String; overload;

    function extensao(Value: String): iPessoa_foto_binary; overload;
    function extensao: String; overload;

    function Select(out Erro: string; const Filtros, Include: TJSONObject): TJSONObject; overload;
    function Insert(out Erro: String): iPessoa_foto_binary; overload;
    function Update(out Erro: String): iPessoa_foto_binary; overload;
    function Delete(out Erro: String): iPessoa_foto_binary; overload;
    function &End : iPessoa_foto_binary;
  end;

implementation

constructor TPessoa_foto_binary.Create;
begin
  model.connection.Connect;
end;

destructor TPessoa_foto_binary.Destroy;
begin
  model.connection.Disconect;
end;

class function TPessoa_foto_binary.New: iPessoa_foto_binary;
begin
  Result := Self.Create;
end;

function TPessoa_foto_binary.&End: iPessoa_foto_binary;
begin
  Result := Self;
end;

function TPessoa_foto_binary.Select(out Erro: string; const Filtros, Include: TJSONObject): TJSONObject;
var
  qry: TFDQuery;
  obj: TJSONObject;
  arr: TJSONArray;
begin
  Erro := '';
  Result := TJSONObject.Create;
  arr := TJSONArray.Create;
  try
    qry := Getpessoa_foto_binary(Filtros);
    while not qry.Eof do
    begin
      obj := qry.ToJSONObject;
      arr.AddElement(obj);
      qry.Next;
    end;
    Result.AddPair('total', TJSONNumber.Create(arr.Count));
    Result.AddPair('pessoa_foto_binary', arr);
  except
    on E: Exception do
    begin
      Erro := E.Message;
      Result.Free;
      Result := nil;
    end;
  end;
end;

function TPessoa_foto_binary.Getpessoa_foto_binary(const Filtros: TJSONObject): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := model.connection.FConnection;
  Result.SQL.Add('SELECT');
  Result.SQL.Add('    id,');
  Result.SQL.Add('    id_pessoa,');
  Result.SQL.Add('    foto_binary,');
  Result.SQL.Add('    nome_arquivo,');
  Result.SQL.Add('    extensao');
  Result.SQL.Add('FROM public.pessoa_foto_binary');
  Result.SQL.Add('WHERE 1=1');

  if Filtros.TryGetValue<LargeInt>('id', Fid) then
  begin
    Result.SQL.Add('AND id = :id');
    Result.ParamByName('id').AsLargeInt := Fid;
  end;

  if Filtros.TryGetValue<LargeInt>('id_pessoa', Fid_pessoa) then
  begin
    Result.SQL.Add('AND id_pessoa = :id_pessoa');
    Result.ParamByName('id_pessoa').AsLargeInt := Fid_pessoa;
  end;

  if Filtros.TryGetValue<String>('nome_arquivo', Fnome_arquivo) then
  begin
    Result.SQL.Add('AND nome_arquivo = :nome_arquivo');
    Result.ParamByName('nome_arquivo').AsString := Fnome_arquivo;
  end;

  if Filtros.TryGetValue<String>('extensao', Fextensao) then
  begin
    Result.SQL.Add('AND extensao = :extensao');
    Result.ParamByName('extensao').AsString := Fextensao;
  end;

  Result.Open;
end;

function TPessoa_foto_binary.Insert(out Erro: String): iPessoa_foto_binary;
var
  qry: TFDQuery;
  //Stream: TBytesStream;
begin
  Erro := '';
  qry := TFDQuery.Create(nil);
  try
    try
      qry.Connection := model.connection.FConnection;
      qry.SQL.Add('INSERT INTO public.pessoa_foto_binary (');
      qry.SQL.Add('    id_pessoa,');
      qry.SQL.Add('    foto_binary,');
      qry.SQL.Add('    nome_arquivo,');
      qry.SQL.Add('    extensao');
      qry.SQL.Add(') VALUES (');
      qry.SQL.Add('    :id_pessoa,');
      qry.SQL.Add('    :foto_binary,');
      qry.SQL.Add('    :nome_arquivo,');
      qry.SQL.Add('    :extensao');
      qry.SQL.Add(')');
      qry.SQL.Add('returning id;');
      qry.ParamByName('id_pessoa').AsLargeInt:= Fid_pessoa;
      qry.ParamByName('foto_binary').LoadFromStream(Ffoto_binary, ftBlob);
      qry.ParamByName('nome_arquivo').AsString:= Fnome_arquivo;
      qry.ParamByName('extensao').AsString:= Fextensao;

      {Aqui, a parte RETURNING id é uma característica de alguns bancos de dados,
      como PostgreSQL, que permite retornar o valor de uma coluna após a inserção.
      Essa funcionalidade faz com que o INSERT se comporte de maneira semelhante a um SELECT,
      retornando um conjunto de resultados com a coluna id.

      Então, ao usar Open, você está abrindo um DataSet que contém a linha retornada pelo RETURNING,
      e você pode acessar o valor da coluna id diretamente a partir do FDQuery1.Fields[0].AsInteger.}

      qry.Open;

      // Obter o retorno
      id(qry.Fields[0].AsInteger);
    except
      on E: Exception do
      begin
        Erro := E.Message;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TPessoa_foto_binary.Update(out Erro: String): iPessoa_foto_binary;
var
  qry: TFDQuery;
begin
  Erro := '';
  qry := TFDQuery.Create(nil);
  try
    try
      qry.Connection := model.connection.FConnection;
      qry.SQL.Add('UPDATE public.pessoa_foto_binary SET');
      qry.SQL.Add('    id = :id,');
      qry.SQL.Add('    id_pessoa = :id_pessoa,');
      qry.SQL.Add('    foto_binary = :foto_binary,');
      qry.SQL.Add('    nome_arquivo = :nome_arquivo,');
      qry.SQL.Add('    extensao = :extensao');
      qry.SQL.Add('WHERE id = :id');
      qry.ParamByName('id').AsLargeInt:= Fid;
      qry.ParamByName('id_pessoa').AsLargeInt:= Fid_pessoa;
      qry.ParamByName('foto_binary').LoadFromStream(Ffoto_binary, ftBlob);
      qry.ParamByName('nome_arquivo').AsString:= Fnome_arquivo;
      qry.ParamByName('extensao').AsString:= Fextensao;
      qry.ExecSQL;
    except
      on E: Exception do
      begin
        Erro := E.Message;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TPessoa_foto_binary.Delete(out Erro: String): iPessoa_foto_binary;
var
  qry: TFDQuery;
begin
  Erro := '';
  qry := TFDQuery.Create(nil);
  try
    try
      qry.Connection := model.connection.FConnection;
      qry.SQL.Add('DELETE FROM pessoa_foto_binary WHERE id = :id');
      qry.ParamByName('id').AsLargeInt := Fid;
      qry.ExecSQL;
    except
      on E: Exception do
      begin
        Erro := E.Message;
      end;
    end;
  finally
    qry.Free;
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

function TPessoa_foto_binary.foto_binary(Value: TMemoryStream): iPessoa_foto_binary;
begin
  Ffoto_binary := Value;
  Result := Self;
end;

function TPessoa_foto_binary.foto_binary: TMemoryStream;
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
