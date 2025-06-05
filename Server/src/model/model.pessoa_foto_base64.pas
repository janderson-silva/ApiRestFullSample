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
  Horse,
  Data.DB,
  FireDAC.Comp.Client,
  System.SysUtils,
  interfaces.pessoa_foto_base64,
  model.connection;

type
  TPessoa_foto_base64 = class(TInterfacedObject, iPessoa_foto_base64)
    private
      Fid : Integer;
      Fid_pessoa : Integer;
      Ffoto_base64 : string   {261};
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iPessoa_foto_base64;

      function id (Value : Integer) : iPessoa_foto_base64; overload;
      function id : Integer; overload;

      function id_pessoa (Value : Integer) : iPessoa_foto_base64; overload;
      function id_pessoa : Integer; overload;

      function foto_base64 (Value : string   {261}) : iPessoa_foto_base64; overload;
      function foto_base64 : string   {261}; overload;

      function Select(order_by: string; out erro : string) : TFDquery; overload;
      function Insert(out erro : String) : iPessoa_foto_base64; overload;
      function Update(out erro : String) : iPessoa_foto_base64; overload;
      function Delete(out erro : String) : iPessoa_foto_base64; overload;

      function &End : iPessoa_foto_base64;

  end;

implementation

{ TPessoa_foto_base64 }

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

function TPessoa_foto_base64.Select(order_by: string; out erro: string): TFDquery;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.sql.Clear;
    qry.sql.Add('select *');
    qry.sql.Add('from pessoa_foto_base64');
    qry.sql.Add('where 1 = 1');

    if Trim(Fid) <> '' then
    begin
      qry.SQL.Add('and id = :id');
      qry.ParamByName('id').Value := Fid;
    end;
    if Trim(Fid_pessoa) <> '' then
    begin
      qry.SQL.Add('and id_pessoa = :id_pessoa');
      qry.ParamByName('id_pessoa').Value := Fid_pessoa;
    end;
    if Trim(Ffoto_base64) <> '' then
    begin
      qry.SQL.Add('and foto_base64 = :foto_base64');
      qry.ParamByName('foto_base64').Value := Ffoto_base64;
    end;

    if Trim(order_by) <> '' then
      qry.sql.Add('order by ' + order_by);

    qry.Active := True;
    erro := '';
    Result := qry;
  except on ex:exception do
    begin
      erro := 'Erro ao consultar pessoa_foto_base64: ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TPessoa_foto_base64.Insert(out erro: String): iPessoa_foto_base64;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.sql.Clear;
    qry.sql.Add('insert into pessoa_foto_base64(');
    qry.SQL.Add('    id_pessoa,');
    qry.SQL.Add('    foto_base64');
    qry.SQL.Add(') values (');
    qry.SQL.Add('    :id_pessoa,');
    qry.SQL.Add('    :foto_base64');
    qry.SQL.Add(')');
    qry.SQL.Add('returning id;');
    qry.ParamByName('id_pessoa').Value := Fid_pessoa;
    qry.ParamByName('foto_base64').Value := Ffoto_base64;

    {Aqui, a parte RETURNING id é uma característica de alguns bancos de dados,
    como PostgreSQL, que permite retornar o valor de uma coluna após a inserção.
    Essa funcionalidade faz com que o INSERT se comporte de maneira semelhante a um SELECT,
    retornando um conjunto de resultados com a coluna id.

    Então, ao usar Open, você está abrindo um DataSet que contém a linha retornada pelo RETURNING,
    e você pode acessar o valor da coluna id diretamente a partir do FDQuery1.Fields[0].AsInteger.}

    qry.Open;

    // Obter o ID retornado
    id(qry.Fields[0].AsInteger);

    qry.Free;
    erro := '';
  except on ex:exception do
    begin
      erro := 'Erro ao inserir pessoa_foto_base64: ' + ex.Message;
    end;
  end;
end;

function TPessoa_foto_base64.Update(out erro: String): iPessoa_foto_base64;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.sql.Clear;
    qry.sql.Add('update pessoa_foto_base64 set');
    qry.SQL.Add('    id_pessoa = :id_pessoa,');
    qry.SQL.Add('    foto_base64 = :foto_base64');
    qry.sql.Add('where 1 = 1');
    qry.SQL.Add('and id = :id');
    qry.ParamByName('id').Value := Fid;
    qry.ParamByName('id_pessoa').Value := Fid_pessoa;
    qry.ParamByName('foto_base64').Value := Ffoto_base64;
    qry.ExecSQL;
    qry.Free;
    erro := '';
  except on ex:exception do
    begin
      erro := 'Erro ao atualizar pessoa_foto_base64: ' + ex.Message;
    end;
  end;
end;

function TPessoa_foto_base64.Delete(out erro: String): iPessoa_foto_base64;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.SQL.Clear;
    qry.SQL.Add('delete from pessoa_foto_base64');
    qry.sql.Add('where 1 = 1');
    qry.SQL.Add('and id = :id');
    qry.ParamByName('id').Value := Fid;
    qry.ExecSQL;
    qry.Free;
    erro := '';
  except on ex:exception do
    begin
      erro := 'Erro ao deletar pessoa_foto_base64: ' + ex.Message;
    end;
  end;
end;

function TPessoa_foto_base64.id (Value : Integer) : iPessoa_foto_base64;
begin
  Result := Self;
  Fid := Value;
end;

function TPessoa_foto_base64.id : Integer;
begin
  Result := Fid;
end;

function TPessoa_foto_base64.id_pessoa (Value : Integer) : iPessoa_foto_base64;
begin
  Result := Self;
  Fid_pessoa := Value;
end;

function TPessoa_foto_base64.id_pessoa : Integer;
begin
  Result := Fid_pessoa;
end;

function TPessoa_foto_base64.foto_base64 (Value : string   {261}) : iPessoa_foto_base64;
begin
  Result := Self;
  Ffoto_base64 := Value;
end;

function TPessoa_foto_base64.foto_base64 : string   {261};
begin
  Result := Ffoto_base64;
end;

end.
