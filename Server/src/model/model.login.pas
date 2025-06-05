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
  Data.DB,
  DataSet.Serialize,
  FireDAC.Comp.Client,
  System.JSON,
  System.SysUtils,
  interfaces.login,
  model.connection;

type
  TLogin = class(TInterfacedObject, iLogin)
  private
    Fid: LargeInt;
    Fativo: Boolean;
    Femail: String;
    Fsenha: String;

    function GetLogin(const Filtros: TJSONObject): TFDQuery;
  public
    constructor Create; overload;
    destructor Destroy; override;
    class function New : iLogin;

    function id(Value: LargeInt): iLogin; overload;
    function id: LargeInt; overload;

    function ativo(Value: Boolean): iLogin; overload;
    function ativo: Boolean; overload;

    function email(Value: String): iLogin; overload;
    function email: String; overload;

    function senha(Value: String): iLogin; overload;
    function senha: String; overload;

    function Select(out Erro: string; const Filtros, Include: TJSONObject): TJSONObject; overload;
    function Insert(out Erro: String): iLogin; overload;
    function Update(out Erro: String): iLogin; overload;
    function Delete(out Erro: String): iLogin; overload;
    function &End : iLogin;
  end;

implementation

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

function TLogin.Select(out Erro: string; const Filtros, Include: TJSONObject): TJSONObject;
var
  qry: TFDQuery;
  obj: TJSONObject;
  arr: TJSONArray;
begin
  Erro := '';
  Result := TJSONObject.Create;
  arr := TJSONArray.Create;
  try
    qry := Getlogin(Filtros);
    while not qry.Eof do
    begin
      obj := qry.ToJSONObject;
      arr.AddElement(obj);
      qry.Next;
    end;
    Result.AddPair('total', TJSONNumber.Create(arr.Count));
    Result.AddPair('login', arr);
  except
    on E: Exception do
    begin
      Erro := E.Message;
      Result.Free;
      Result := nil;
    end;
  end;
end;

function TLogin.Getlogin(const Filtros: TJSONObject): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := model.connection.FConnection;
  Result.SQL.Add('SELECT');
  Result.SQL.Add('    id,');
  Result.SQL.Add('    ativo,');
  Result.SQL.Add('    email,');
  Result.SQL.Add('    senha');
  Result.SQL.Add('FROM public.login');
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

  if Filtros.TryGetValue<String>('email', Femail) then
  begin
    Result.SQL.Add('AND email = :email');
    Result.ParamByName('email').AsString := Femail;
  end;

  if Filtros.TryGetValue<String>('senha', Fsenha) then
  begin
    Result.SQL.Add('AND senha = :senha');
    Result.ParamByName('senha').AsString := Fsenha;
  end;

  Result.Open;
end;

function TLogin.Insert(out Erro: String): iLogin;
var
  qry: TFDQuery;
begin
  Erro := '';
  qry := TFDQuery.Create(nil);
  try
    try
      qry.Connection := model.connection.FConnection;
      qry.SQL.Add('INSERT INTO public.login (');
      qry.SQL.Add('    ativo,');
      qry.SQL.Add('    email,');
      qry.SQL.Add('    senha');
      qry.SQL.Add(') VALUES (');
      qry.SQL.Add('    :ativo,');
      qry.SQL.Add('    :email,');
      qry.SQL.Add('    :senha');
      qry.SQL.Add(')');
      qry.SQL.Add('returning id;');
      qry.ParamByName('ativo').AsBoolean:= Fativo;
      qry.ParamByName('email').AsString:= Femail;
      qry.ParamByName('senha').AsString:= Fsenha;

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

function TLogin.Update(out Erro: String): iLogin;
var
  qry: TFDQuery;
begin
  Erro := '';
  qry := TFDQuery.Create(nil);
  try
    try
      qry.Connection := model.connection.FConnection;
      qry.SQL.Add('UPDATE public.login SET');
      qry.SQL.Add('    id = :id,');
      qry.SQL.Add('    ativo = :ativo,');
      qry.SQL.Add('    email = :email,');
      qry.SQL.Add('    senha = :senha');
      qry.SQL.Add('WHERE id = :id');
      qry.ParamByName('id').AsLargeInt:= Fid;
      qry.ParamByName('ativo').AsBoolean:= Fativo;
      qry.ParamByName('email').AsString:= Femail;
      qry.ParamByName('senha').AsString:= Fsenha;
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

function TLogin.Delete(out Erro: String): iLogin;
var
  qry: TFDQuery;
begin
  Erro := '';
  qry := TFDQuery.Create(nil);
  try
    try
      qry.Connection := model.connection.FConnection;
      qry.SQL.Add('DELETE FROM login WHERE id = :id');
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

function TLogin.id(Value: LargeInt): iLogin;
begin
  Fid := Value;
  Result := Self;
end;

function TLogin.id: LargeInt;
begin
  Result := Fid;
end;

function TLogin.ativo(Value: Boolean): iLogin;
begin
  Fativo := Value;
  Result := Self;
end;

function TLogin.ativo: Boolean;
begin
  Result := Fativo;
end;

function TLogin.email(Value: String): iLogin;
begin
  Femail := Value;
  Result := Self;
end;

function TLogin.email: String;
begin
  Result := Femail;
end;

function TLogin.senha(Value: String): iLogin;
begin
  Fsenha := Value;
  Result := Self;
end;

function TLogin.senha: String;
begin
  Result := Fsenha;
end;

end.
