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



unit controller.login;

interface

uses
  Horse,
  Data.DB,
  DataSet.Serialize,
  FireDAC.Comp.Client,
  System.JSON,
  System.SysUtils,
  interfaces.login,
  model.login;

procedure Registry;

implementation

procedure SelectLogin(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FLogin : iLogin;
  qry : TFDQuery;
  erro : string;
  ArrayLogin : TJSONArray;
begin
  // Conexao com o banco...
  try
    FLogin := TLogin.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    try
      qry := FLogin
                .select('',erro);

      if erro <> '' then
        raise Exception.Create(erro)
      else
      begin
        if qry.RecordCount > 0 then
        begin
          ArrayLogin := qry.ToJSONArray();
          res.Send<TJSONArray>(ArrayLogin).Status(200);
        end
        else
        begin
          res.Send('{ "Erro": "Nenhum cadastro de login encontrado" }').Status(404);
        end;
      end;
    except on E : Exception do
      begin
        res.Send('{ "erro": "'+E.Message+'" }').Status(400);
        Exit;
      end;
    end;
  finally
    qry.Free;
  end;
end;

procedure SelectLoginID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FLogin : iLogin;
  qry : TFDQuery;
  erro : string;
  ObjLogin : TJSONObject;
begin
  // Conexao com o banco...
  try
    FLogin := TLogin.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    try
      qry := FLogin
                  .id(StrToIntDef(Req.Params['id'],0))
                .select('',erro);

      if erro <> '' then
        raise Exception.Create(erro)
      else
      begin
        if qry.RecordCount > 0 then
        begin
          ObjLogin := qry.ToJSONObject;
          res.Send<TJSONObject>(ObjLogin).Status(200);
        end
        else
        begin
          res.Send('{ "Erro": "Nenhum cadastro de login encontrado" }').Status(404);
        end;
      end;
    except on E : Exception do
      begin
        res.Send('{ "erro": "'+E.Message+'" }').Status(400);
        Exit;
      end;
    end;
  finally
    qry.Free;
  end;
end;

procedure InsertLogin(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FLogin : iLogin;
  erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    FLogin := TLogin.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
    FLogin
        .ativo(body.GetValue<Integer>('ativo',0))
        .email(body.GetValue<string>('email',''))
        .senha(body.GetValue<string>('senha',''))
      .Insert(erro);

    body.Free;
    if erro <> '' then
      raise Exception.Create(erro)
    else
      res.Send('{ "Resposta":"salvo com sucesso","id":"'+FLogin.id.ToString+'" }').Status(200);
  except on E : Exception do
    begin
      res.Send('{ "erro": "'+E.Message+'" }').Status(400);
      Exit;
    end;
  end;
end;

procedure UpdateLogin(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FLogin : iLogin;
  erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    FLogin := TLogin.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
    FLogin
        .id(body.GetValue<Integer>('id',0))
        .ativo(body.GetValue<Integer>('ativo',0))
        .email(body.GetValue<string>('email',''))
        .senha(body.GetValue<string>('senha',''))
      .Update(erro);

    body.Free;
    if erro <> '' then
      raise Exception.Create(erro)
    else
      res.Send('{ atualizado com sucesso }').Status(200);
  except on E : Exception do
    begin
      res.Send('{ "erro": "'+E.Message+'" }').Status(400);
      Exit;
    end;
  end;
end;

procedure DeleteLogin(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FLogin : iLogin;
  erro : string;
begin
  // Conexao com o banco...
  try
    FLogin := TLogin.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    FLogin
        .id(Req.Params['id'].ToInteger)
      .Delete(erro);

    if erro <> '' then
      raise Exception.Create(erro)
    else
      res.Send('{ deletado com sucesso }').Status(200);
  except on E : Exception do
    begin
      res.Send('{ "erro": "'+E.Message+'" }').Status(400);
      Exit;
    end;
  end;
end;

procedure Registry;
begin
    THorse.Group.Prefix('v1')
      .Get('/login', SelectLogin)
      .Get('/login/:id', SelectLoginID)
      .Post('/login', InsertLogin)
      .Put('/login', UpdateLogin)
      .Delete('/login/:id', DeleteLogin);
end;

end.
