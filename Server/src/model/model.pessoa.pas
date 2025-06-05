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
  Horse,
  Data.DB,
  FireDAC.Comp.Client,
  System.SysUtils,
  interfaces.pessoa,
  model.connection;

type
  TPessoa = class(TInterfacedObject, iPessoa)
    private
      Fid : Integer;
      Fativo : Integer;
      Fnome : string;
      Fdocumento : string;
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iPessoa;

      function id (Value : Integer) : iPessoa; overload;
      function id : Integer; overload;

      function ativo (Value : Integer) : iPessoa; overload;
      function ativo : Integer; overload;

      function nome (Value : string) : iPessoa; overload;
      function nome : string; overload;

      function documento (Value : string) : iPessoa; overload;
      function documento : string; overload;

      function Select(order_by: string; out erro : string) : TFDquery; overload;
      function Insert(out erro : String) : iPessoa; overload;
      function Update(out erro : String) : iPessoa; overload;
      function Delete(out erro : String) : iPessoa; overload;

      function &End : iPessoa;

  end;

implementation

{ TPessoa }

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

function TPessoa.Select(order_by: string; out erro: string): TFDquery;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.sql.Clear;
    qry.sql.Add('select *');
    qry.sql.Add('from pessoa');
    qry.sql.Add('where 1 = 1');

    if Trim(Fid) <> '' then
    begin
      qry.SQL.Add('and id = :id');
      qry.ParamByName('id').Value := Fid;
    end;
    if Trim(Fativo) <> '' then
    begin
      qry.SQL.Add('and ativo = :ativo');
      qry.ParamByName('ativo').Value := Fativo;
    end;
    if Trim(Fnome) <> '' then
    begin
      qry.SQL.Add('and nome = :nome');
      qry.ParamByName('nome').Value := Fnome;
    end;
    if Trim(Fdocumento) <> '' then
    begin
      qry.SQL.Add('and documento = :documento');
      qry.ParamByName('documento').Value := Fdocumento;
    end;

    if Trim(order_by) <> '' then
      qry.sql.Add('order by ' + order_by);

    qry.Active := True;
    erro := '';
    Result := qry;
  except on ex:exception do
    begin
      erro := 'Erro ao consultar pessoa: ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TPessoa.Insert(out erro: String): iPessoa;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.sql.Clear;
    qry.sql.Add('insert into pessoa(');
    qry.SQL.Add('    ativo,');
    qry.SQL.Add('    nome,');
    qry.SQL.Add('    documento');
    qry.SQL.Add(') values (');
    qry.SQL.Add('    :ativo,');
    qry.SQL.Add('    :nome,');
    qry.SQL.Add('    :documento');
    qry.SQL.Add(')');
    qry.SQL.Add('returning id;');
    qry.ParamByName('ativo').Value := Fativo;
    qry.ParamByName('nome').Value := Fnome;
    qry.ParamByName('documento').Value := Fdocumento;

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
      erro := 'Erro ao inserir pessoa: ' + ex.Message;
    end;
  end;
end;

function TPessoa.Update(out erro: String): iPessoa;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.sql.Clear;
    qry.sql.Add('update pessoa set');
    qry.SQL.Add('    ativo = :ativo,');
    qry.SQL.Add('    nome = :nome,');
    qry.SQL.Add('    documento = :documento');
    qry.sql.Add('where 1 = 1');
    qry.SQL.Add('and id = :id');
    qry.ParamByName('id').Value := Fid;
    qry.ParamByName('ativo').Value := Fativo;
    qry.ParamByName('nome').Value := Fnome;
    qry.ParamByName('documento').Value := Fdocumento;
    qry.ExecSQL;
    qry.Free;
    erro := '';
  except on ex:exception do
    begin
      erro := 'Erro ao atualizar pessoa: ' + ex.Message;
    end;
  end;
end;

function TPessoa.Delete(out erro: String): iPessoa;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.SQL.Clear;
    qry.SQL.Add('delete from pessoa');
    qry.sql.Add('where 1 = 1');
    qry.SQL.Add('and id = :id');
    qry.ParamByName('id').Value := Fid;
    qry.ExecSQL;
    qry.Free;
    erro := '';
  except on ex:exception do
    begin
      erro := 'Erro ao deletar pessoa: ' + ex.Message;
    end;
  end;
end;

function TPessoa.id (Value : Integer) : iPessoa;
begin
  Result := Self;
  Fid := Value;
end;

function TPessoa.id : Integer;
begin
  Result := Fid;
end;

function TPessoa.ativo (Value : Integer) : iPessoa;
begin
  Result := Self;
  Fativo := Value;
end;

function TPessoa.ativo : Integer;
begin
  Result := Fativo;
end;

function TPessoa.nome (Value : string) : iPessoa;
begin
  Result := Self;
  Fnome := Value;
end;

function TPessoa.nome : string;
begin
  Result := Fnome;
end;

function TPessoa.documento (Value : string) : iPessoa;
begin
  Result := Self;
  Fdocumento := Value;
end;

function TPessoa.documento : string;
begin
  Result := Fdocumento;
end;

end.
