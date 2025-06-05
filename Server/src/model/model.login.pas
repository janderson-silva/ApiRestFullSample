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
  Horse,
  Data.DB,
  FireDAC.Comp.Client,
  System.SysUtils,
  interfaces.login,
  model.connection;

type
  TLogin = class(TInterfacedObject, iLogin)
    private
      Fid : Integer;
      Fativo : Integer;
      Femail : string;
      Fsenha : string;
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iLogin;

      function id (Value : Integer) : iLogin; overload;
      function id : Integer; overload;

      function ativo (Value : Integer) : iLogin; overload;
      function ativo : Integer; overload;

      function email (Value : string) : iLogin; overload;
      function email : string; overload;

      function senha (Value : string) : iLogin; overload;
      function senha : string; overload;

      function Select(order_by: string; out erro : string) : TFDquery; overload;
      function Insert(out erro : String) : iLogin; overload;
      function Update(out erro : String) : iLogin; overload;
      function Delete(out erro : String) : iLogin; overload;

      function &End : iLogin;

  end;

implementation

{ TLogin }

constructor TLogin.Create;
begin
  model.connection.Connect;
end;

destructor TLogin.Destroy;
begin
  model.connection.Disconect;
end;

class function TLogin.New: iLogin;
begin
  Result := Self.Create;
end;

function TLogin.&End: iLogin;
begin
  Result := Self;
end;

function TLogin.Select(order_by: string; out erro: string): TFDquery;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.sql.Clear;
    qry.sql.Add('select *');
    qry.sql.Add('from login');
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
    if Trim(Femail) <> '' then
    begin
      qry.SQL.Add('and email = :email');
      qry.ParamByName('email').Value := Femail;
    end;
    if Trim(Fsenha) <> '' then
    begin
      qry.SQL.Add('and senha = :senha');
      qry.ParamByName('senha').Value := Fsenha;
    end;

    if Trim(order_by) <> '' then
      qry.sql.Add('order by ' + order_by);

    qry.Active := True;
    erro := '';
    Result := qry;
  except on ex:exception do
    begin
      erro := 'Erro ao consultar login: ' + ex.Message;
      Result := nil;
    end;
  end;
end;

function TLogin.Insert(out erro: String): iLogin;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.sql.Clear;
    qry.sql.Add('insert into login(');
    qry.SQL.Add('    ativo,');
    qry.SQL.Add('    email,');
    qry.SQL.Add('    senha');
    qry.SQL.Add(') values (');
    qry.SQL.Add('    :ativo,');
    qry.SQL.Add('    :email,');
    qry.SQL.Add('    :senha');
    qry.SQL.Add(')');
    qry.SQL.Add('returning id;');
    qry.ParamByName('ativo').Value := Fativo;
    qry.ParamByName('email').Value := Femail;
    qry.ParamByName('senha').Value := Fsenha;

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
      erro := 'Erro ao inserir login: ' + ex.Message;
    end;
  end;
end;

function TLogin.Update(out erro: String): iLogin;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.sql.Clear;
    qry.sql.Add('update login set');
    qry.SQL.Add('    ativo = :ativo,');
    qry.SQL.Add('    email = :email,');
    qry.SQL.Add('    senha = :senha');
    qry.sql.Add('where 1 = 1');
    qry.SQL.Add('and id = :id');
    qry.ParamByName('id').Value := Fid;
    qry.ParamByName('ativo').Value := Fativo;
    qry.ParamByName('email').Value := Femail;
    qry.ParamByName('senha').Value := Fsenha;
    qry.ExecSQL;
    qry.Free;
    erro := '';
  except on ex:exception do
    begin
      erro := 'Erro ao atualizar login: ' + ex.Message;
    end;
  end;
end;

function TLogin.Delete(out erro: String): iLogin;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;
    qry.Active := False;
    qry.SQL.Clear;
    qry.SQL.Add('delete from login');
    qry.sql.Add('where 1 = 1');
    qry.SQL.Add('and id = :id');
    qry.ParamByName('id').Value := Fid;
    qry.ExecSQL;
    qry.Free;
    erro := '';
  except on ex:exception do
    begin
      erro := 'Erro ao deletar login: ' + ex.Message;
    end;
  end;
end;

function TLogin.id (Value : Integer) : iLogin;
begin
  Result := Self;
  Fid := Value;
end;

function TLogin.id : Integer;
begin
  Result := Fid;
end;

function TLogin.ativo (Value : Integer) : iLogin;
begin
  Result := Self;
  Fativo := Value;
end;

function TLogin.ativo : Integer;
begin
  Result := Fativo;
end;

function TLogin.email (Value : string) : iLogin;
begin
  Result := Self;
  Femail := Value;
end;

function TLogin.email : string;
begin
  Result := Femail;
end;

function TLogin.senha (Value : string) : iLogin;
begin
  Result := Self;
  Fsenha := Value;
end;

function TLogin.senha : string;
begin
  Result := Fsenha;
end;

end.
