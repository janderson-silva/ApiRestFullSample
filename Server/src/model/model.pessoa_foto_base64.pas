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
  Data.DB,
  DataSet.Serialize,
  FireDAC.Comp.Client,
  System.JSON,
  System.SysUtils,
  interfaces.pessoa_foto_base64,
  model.connection;

type
  TPessoa_foto_base64 = class(TInterfacedObject, iPessoa_foto_base64)
  private
    Fid: LargeInt;
    Fid_pessoa: LargeInt;
    Ffoto_base64: String;

    function GetPessoa_foto_base64(const Filtros: TJSONObject): TFDQuery;
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

    function Select(out Erro: string; const Filtros, Include: TJSONObject): TJSONObject; overload;
    function Insert(out Erro: String): iPessoa_foto_base64; overload;
    function Update(out Erro: String): iPessoa_foto_base64; overload;
    function Delete(out Erro: String): iPessoa_foto_base64; overload;
    function &End : iPessoa_foto_base64;
  end;

implementation

constructor TPessoa_foto_base64.Create;
begin
  model.connection.Connect;
end;

destructor TPessoa_foto_base64.Destroy;
begin
  model.connection.Disconect;
end;

class function TPessoa_foto_base64.New: iPessoa_foto_base64;
begin
  Result := Self.Create;
end;

function TPessoa_foto_base64.&End: iPessoa_foto_base64;
begin
  Result := Self;
end;

function TPessoa_foto_base64.Select(out Erro: string; const Filtros, Include: TJSONObject): TJSONObject;
var
  qry: TFDQuery;
  obj: TJSONObject;
  arr: TJSONArray;
begin
  Erro := '';
  Result := TJSONObject.Create;
  arr := TJSONArray.Create;
  try
    qry := Getpessoa_foto_base64(Filtros);
    while not qry.Eof do
    begin
      obj := qry.ToJSONObject;
      arr.AddElement(obj);
      qry.Next;
    end;
    Result.AddPair('total', TJSONNumber.Create(arr.Count));
    Result.AddPair('pessoa_foto_base64', arr);
  except
    on E: Exception do
    begin
      Erro := E.Message;
      Result.Free;
      Result := nil;
    end;
  end;
end;

function TPessoa_foto_base64.Getpessoa_foto_base64(const Filtros: TJSONObject): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := model.connection.FConnection;
  Result.SQL.Add('SELECT');
  Result.SQL.Add('    id,');
  Result.SQL.Add('    id_pessoa,');
  Result.SQL.Add('    foto_base64');
  Result.SQL.Add('FROM public.pessoa_foto_base64');
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

  if Filtros.TryGetValue<String>('foto_base64', Ffoto_base64) then
  begin
    Result.SQL.Add('AND foto_base64 = :foto_base64');
    Result.ParamByName('foto_base64').AsString := Ffoto_base64;
  end;

  Result.Open;
end;

function TPessoa_foto_base64.Insert(out Erro: String): iPessoa_foto_base64;
var
  qry: TFDQuery;
begin
  Erro := '';
  qry := TFDQuery.Create(nil);
  try
    try
      qry.Connection := model.connection.FConnection;
      qry.SQL.Add('INSERT INTO public.pessoa_foto_base64 (');
      qry.SQL.Add('    id_pessoa,');
      qry.SQL.Add('    foto_base64');
      qry.SQL.Add(') VALUES (');
      qry.SQL.Add('    :id_pessoa,');
      qry.SQL.Add('    :foto_base64');
      qry.SQL.Add(')');
      qry.SQL.Add('returning id;');
      qry.ParamByName('id_pessoa').AsLargeInt:= Fid_pessoa;
      qry.ParamByName('foto_base64').AsString:= Ffoto_base64;

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

function TPessoa_foto_base64.Update(out Erro: String): iPessoa_foto_base64;
var
  qry: TFDQuery;
begin
  Erro := '';
  qry := TFDQuery.Create(nil);
  try
    try
      qry.Connection := model.connection.FConnection;
      qry.SQL.Add('UPDATE public.pessoa_foto_base64 SET');
      qry.SQL.Add('    id = :id,');
      qry.SQL.Add('    id_pessoa = :id_pessoa,');
      qry.SQL.Add('    foto_base64 = :foto_base64');
      qry.SQL.Add('WHERE id = :id');
      qry.ParamByName('id').AsLargeInt:= Fid;
      qry.ParamByName('id_pessoa').AsLargeInt:= Fid_pessoa;
      qry.ParamByName('foto_base64').AsString:= Ffoto_base64;
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

function TPessoa_foto_base64.Delete(out Erro: String): iPessoa_foto_base64;
var
  qry: TFDQuery;
begin
  Erro := '';
  qry := TFDQuery.Create(nil);
  try
    try
      qry.Connection := model.connection.FConnection;
      qry.SQL.Add('DELETE FROM pessoa_foto_base64 WHERE id = :id');
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
