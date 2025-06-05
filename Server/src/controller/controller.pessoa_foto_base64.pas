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



unit controller.pessoa_foto_base64;

interface

uses
  Horse,
  Data.DB,
  DataSet.Serialize,
  FireDAC.Comp.Client,
  System.JSON,
  System.SysUtils,
  interfaces.pessoa_foto_base64,
  model.pessoa_foto_base64;

procedure Registry;

implementation

procedure SelectPessoa_foto_base64(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FPessoa_foto_base64 : iPessoa_foto_base64;
  qry : TFDQuery;
  erro : string;
  ArrayPessoa_foto_base64 : TJSONArray;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_base64 := TPessoa_foto_base64.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    try
      qry := FPessoa_foto_base64
                .select('',erro);

      if erro <> '' then
        raise Exception.Create(erro)
      else
      begin
        if qry.RecordCount > 0 then
        begin
          ArrayPessoa_foto_base64 := qry.ToJSONArray();
          res.Send<TJSONArray>(ArrayPessoa_foto_base64).Status(200);
        end
        else
        begin
          res.Send('{ "Erro": "Nenhum cadastro de pessoa_foto_base64 encontrado" }').Status(404);
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

procedure SelectPessoa_foto_base64ID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FPessoa_foto_base64 : iPessoa_foto_base64;
  qry : TFDQuery;
  erro : string;
  ObjPessoa_foto_base64 : TJSONObject;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_base64 := TPessoa_foto_base64.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    try
      qry := FPessoa_foto_base64
                  .id(StrToIntDef(Req.Params['id'],0))
                .select('',erro);

      if erro <> '' then
        raise Exception.Create(erro)
      else
      begin
        if qry.RecordCount > 0 then
        begin
          ObjPessoa_foto_base64 := qry.ToJSONObject;
          res.Send<TJSONObject>(ObjPessoa_foto_base64).Status(200);
        end
        else
        begin
          res.Send('{ "Erro": "Nenhum cadastro de pessoa_foto_base64 encontrado" }').Status(404);
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

procedure InsertPessoa_foto_base64(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FPessoa_foto_base64 : iPessoa_foto_base64;
  erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_base64 := TPessoa_foto_base64.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
    FPessoa_foto_base64
        .id_pessoa(body.GetValue<Integer>('id_pessoa',0))
        .foto_base64(body.GetValue<string   {261}>('foto_base64',''))
      .Insert(erro);

    body.Free;
    if erro <> '' then
      raise Exception.Create(erro)
    else
      res.Send('{ "Resposta":"salvo com sucesso","id":"'+FPessoa_foto_base64.id.ToString+'" }').Status(200);
  except on E : Exception do
    begin
      res.Send('{ "erro": "'+E.Message+'" }').Status(400);
      Exit;
    end;
  end;
end;

procedure UpdatePessoa_foto_base64(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FPessoa_foto_base64 : iPessoa_foto_base64;
  erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_base64 := TPessoa_foto_base64.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
    FPessoa_foto_base64
        .id(body.GetValue<Integer>('id',0))
        .id_pessoa(body.GetValue<Integer>('id_pessoa',0))
        .foto_base64(body.GetValue<string   {261}>('foto_base64',''))
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

procedure DeletePessoa_foto_base64(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FPessoa_foto_base64 : iPessoa_foto_base64;
  erro : string;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_base64 := TPessoa_foto_base64.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    FPessoa_foto_base64
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
      .Get('/pessoa_foto_base64', SelectPessoa_foto_base64)
      .Get('/pessoa_foto_base64/:id', SelectPessoa_foto_base64ID)
      .Post('/pessoa_foto_base64', InsertPessoa_foto_base64)
      .Put('/pessoa_foto_base64', UpdatePessoa_foto_base64)
      .Delete('/pessoa_foto_base64/:id', DeletePessoa_foto_base64);
end;

end.
