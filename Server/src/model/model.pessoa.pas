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
  Data.DB,
  DataSet.Serialize,
  FireDAC.Comp.Client,
  System.JSON,
  System.SysUtils,
  interfaces.pessoa,
  model.connection;

type
  TPessoa = class(TInterfacedObject, iPessoa)
  private
    Fid: LargeInt;
    Fativo: Boolean;
    Fnome: String;
    Fdocumento: String;

    function GetPessoa(const Filtros: TJSONObject): TFDQuery;
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

    function Select(out Erro: string; const Filtros, Include: TJSONObject): TJSONObject; overload;
    function Insert(out Erro: String): iPessoa; overload;
    function Update(out Erro: String): iPessoa; overload;
    function Delete(out Erro: String): iPessoa; overload;
    function &End : iPessoa;
  end;

implementation

constructor TPessoa.Create;
begin
  model.connection.Connect;
end;

destructor TPessoa.Destroy;
begin
  model.connection.Disconect;
end;

class function TPessoa.New: iPessoa;
begin
  Result := Self.Create;
end;

function TPessoa.&End: iPessoa;
begin
  Result := Self;
end;

function TPessoa.Select(out Erro: string; const Filtros, Include: TJSONObject): TJSONObject;
var
  qry: TFDQuery;
  obj: TJSONObject;
  arr: TJSONArray;
begin
  Erro := '';
  Result := TJSONObject.Create;
  arr := TJSONArray.Create;
  try
    qry := Getpessoa(Filtros);
    while not qry.Eof do
    begin
      obj := qry.ToJSONObject;
      arr.AddElement(obj);
      qry.Next;
    end;
    Result.AddPair('total', TJSONNumber.Create(arr.Count));
    Result.AddPair('pessoa', arr);
  except
    on E: Exception do
    begin
      Erro := E.Message;
      Result.Free;
      Result := nil;
    end;
  end;
end;

function TPessoa.Getpessoa(const Filtros: TJSONObject): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := model.connection.FConnection;
  Result.SQL.Add('SELECT');
  Result.SQL.Add('    id,');
  Result.SQL.Add('    ativo,');
  Result.SQL.Add('    nome,');
  Result.SQL.Add('    documento');
  Result.SQL.Add('FROM public.pessoa');
  Result.SQL.Add('WHERE 1=1');

  if Filtros.TryGetValue<LargeInt>('id', Fid) then
  begin
    Result.SQL.Add('AND id = :id');
    Result.ParamByName('id').AsLargeInt := Fid;
  end;

  if Filtros.TryGetValue<Boolean>('ativo', Fativo) then
  begin
    Result.SQL.Add('AND ativo = :ativo');
    Result.ParamByName('ativo').AsBoolean := Fativo;
  end;

  if Filtros.TryGetValue<String>('nome', Fnome) then
  begin
    Result.SQL.Add('AND nome = :nome');
    Result.ParamByName('nome').AsString := Fnome;
  end;

  if Filtros.TryGetValue<String>('documento', Fdocumento) then
  begin
    Result.SQL.Add('AND documento = :documento');
    Result.ParamByName('documento').AsString := Fdocumento;
  end;

  Result.Open;
end;

function TPessoa.Insert(out Erro: String): iPessoa;
var
  qry: TFDQuery;
begin
  Erro := '';
  qry := TFDQuery.Create(nil);
  try
    try
      qry.Connection := model.connection.FConnection;
      qry.SQL.Add('INSERT INTO public.pessoa (');
      qry.SQL.Add('    ativo,');
      qry.SQL.Add('    nome,');
      qry.SQL.Add('    documento');
      qry.SQL.Add(') VALUES (');
      qry.SQL.Add('    :ativo,');
      qry.SQL.Add('    :nome,');
      qry.SQL.Add('    :documento');
      qry.SQL.Add(')');
      qry.SQL.Add('returning id;');
      qry.ParamByName('ativo').AsBoolean:= Fativo;
      qry.ParamByName('nome').AsString:= Fnome;
      qry.ParamByName('documento').AsString:= Fdocumento;

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

function TPessoa.Update(out Erro: String): iPessoa;
var
  qry: TFDQuery;
begin
  Erro := '';
  qry := TFDQuery.Create(nil);
  try
    try
      qry.Connection := model.connection.FConnection;
      qry.SQL.Add('UPDATE public.pessoa SET');
      qry.SQL.Add('    id = :id,');
      qry.SQL.Add('    ativo = :ativo,');
      qry.SQL.Add('    nome = :nome,');
      qry.SQL.Add('    documento = :documento');
      qry.SQL.Add('WHERE id = :id');
      qry.ParamByName('id').AsLargeInt:= Fid;
      qry.ParamByName('ativo').AsBoolean:= Fativo;
      qry.ParamByName('nome').AsString:= Fnome;
      qry.ParamByName('documento').AsString:= Fdocumento;
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

function TPessoa.Delete(out Erro: String): iPessoa;
var
  qry: TFDQuery;
begin
  Erro := '';
  qry := TFDQuery.Create(nil);
  try
    try
      qry.Connection := model.connection.FConnection;
      qry.SQL.Add('DELETE FROM pessoa WHERE id = :id');
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
