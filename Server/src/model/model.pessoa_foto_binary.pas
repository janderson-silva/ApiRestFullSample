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
  Horse,
  Data.DB,
  FireDAC.Comp.Client,
  System.SysUtils,
  interfaces.pessoa_foto_binary,
  model.connection;

type
  TPessoa_foto_binary = class(TInterfacedObject, iPessoa_foto_binary)
    private
      Fid : Integer;
      Fid_pessoa : Integer;
      Ffoto_binary : string   {261};
      Fnome_arquivo : string;
      Fextensao : string;
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iPessoa_foto_binary;

      function id (Value : Integer) : iPessoa_foto_binary; overload;
      function id : Integer; overload;

      function id_pessoa (Value : Integer) : iPessoa_foto_binary; overload;
      function id_pessoa : Integer; overload;

      function foto_binary (Value : string   {261}) : iPessoa_foto_binary; overload;
      function foto_binary : string   {261}; overload;

      function nome_arquivo (Value : string) : iPessoa_foto_binary; overload;
      function nome_arquivo : string; overload;

      function extensao (Value : string) : iPessoa_foto_binary; overload;
      function extensao : string; overload;

      function Select(order_by: string; out erro : string) : TFDquery; overload;
      function Insert(out erro : String) : iPessoa_foto_binary; overload;
      function Update(out erro : String) : iPessoa_foto_binary; overload;
      function Delete(out erro : String) : iPessoa_foto_binary; overload;

      function &End : iPessoa_foto_binary;

  end;

implementation

{ TPessoa_foto_binary }

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

function TPessoa_foto_binary.Select(order_by: string; out erro: string): TFDquery;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.sql.Clear;
    qry.sql.Add('select *');
    qry.sql.Add('from pessoa_foto_binary');
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
    if Trim(Ffoto_binary) <> '' then
    begin
      qry.SQL.Add('and foto_binary = :foto_binary');
      qry.ParamByName('foto_binary').Value := Ffoto_binary;
    end;
    if Trim(Fnome_arquivo) <> '' then
    begin
      qry.SQL.Add('and nome_arquivo = :nome_arquivo');
      qry.ParamByName('nome_arquivo').Value := Fnome_arquivo;
    end;
    if Trim(Fextensao) <> '' then
    begin
      qry.SQL.Add('and extensao = :extensao');
      qry.ParamByName('extensao').Value := Fextensao;
    end;

    if Trim(order_by) <> '' then
      qry.sql.Add('order by ' + order_by);

    qry.Active := True;
    erro := '';
    Result := qry;
  except on ex:exception do
    begin
      erro := 'Erro ao consultar pessoa_foto_binary: ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TPessoa_foto_binary.Insert(out erro: String): iPessoa_foto_binary;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.sql.Clear;
    qry.sql.Add('insert into pessoa_foto_binary(');
    qry.SQL.Add('    id_pessoa,');
    qry.SQL.Add('    foto_binary,');
    qry.SQL.Add('    nome_arquivo,');
    qry.SQL.Add('    extensao');
    qry.SQL.Add(') values (');
    qry.SQL.Add('    :id_pessoa,');
    qry.SQL.Add('    :foto_binary,');
    qry.SQL.Add('    :nome_arquivo,');
    qry.SQL.Add('    :extensao');
    qry.SQL.Add(')');
    qry.SQL.Add('returning id;');
    qry.ParamByName('id_pessoa').Value := Fid_pessoa;
    qry.ParamByName('foto_binary').Value := Ffoto_binary;
    qry.ParamByName('nome_arquivo').Value := Fnome_arquivo;
    qry.ParamByName('extensao').Value := Fextensao;

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
      erro := 'Erro ao inserir pessoa_foto_binary: ' + ex.Message;
    end;
  end;
end;

function TPessoa_foto_binary.Update(out erro: String): iPessoa_foto_binary;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.sql.Clear;
    qry.sql.Add('update pessoa_foto_binary set');
    qry.SQL.Add('    id_pessoa = :id_pessoa,');
    qry.SQL.Add('    foto_binary = :foto_binary,');
    qry.SQL.Add('    nome_arquivo = :nome_arquivo,');
    qry.SQL.Add('    extensao = :extensao');
    qry.sql.Add('where 1 = 1');
    qry.SQL.Add('and id = :id');
    qry.ParamByName('id').Value := Fid;
    qry.ParamByName('id_pessoa').Value := Fid_pessoa;
    qry.ParamByName('foto_binary').Value := Ffoto_binary;
    qry.ParamByName('nome_arquivo').Value := Fnome_arquivo;
    qry.ParamByName('extensao').Value := Fextensao;
    qry.ExecSQL;
    qry.Free;
    erro := '';
  except on ex:exception do
    begin
      erro := 'Erro ao atualizar pessoa_foto_binary: ' + ex.Message;
    end;
  end;
end;

function TPessoa_foto_binary.Delete(out erro: String): iPessoa_foto_binary;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.SQL.Clear;
    qry.SQL.Add('delete from pessoa_foto_binary');
    qry.sql.Add('where 1 = 1');
    qry.SQL.Add('and id = :id');
    qry.ParamByName('id').Value := Fid;
    qry.ExecSQL;
    qry.Free;
    erro := '';
  except on ex:exception do
    begin
      erro := 'Erro ao deletar pessoa_foto_binary: ' + ex.Message;
    end;
  end;
end;

function TPessoa_foto_binary.id (Value : Integer) : iPessoa_foto_binary;
begin
  Result := Self;
  Fid := Value;
end;

function TPessoa_foto_binary.id : Integer;
begin
  Result := Fid;
end;

function TPessoa_foto_binary.id_pessoa (Value : Integer) : iPessoa_foto_binary;
begin
  Result := Self;
  Fid_pessoa := Value;
end;

function TPessoa_foto_binary.id_pessoa : Integer;
begin
  Result := Fid_pessoa;
end;

function TPessoa_foto_binary.foto_binary (Value : string   {261}) : iPessoa_foto_binary;
begin
  Result := Self;
  Ffoto_binary := Value;
end;

function TPessoa_foto_binary.foto_binary : string   {261};
begin
  Result := Ffoto_binary;
end;

function TPessoa_foto_binary.nome_arquivo (Value : string) : iPessoa_foto_binary;
begin
  Result := Self;
  Fnome_arquivo := Value;
end;

function TPessoa_foto_binary.nome_arquivo : string;
begin
  Result := Fnome_arquivo;
end;

function TPessoa_foto_binary.extensao (Value : string) : iPessoa_foto_binary;
begin
  Result := Self;
  Fextensao := Value;
end;

function TPessoa_foto_binary.extensao : string;
begin
  Result := Fextensao;
end;

end.
