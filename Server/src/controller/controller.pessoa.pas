{*******************************************************************************}
{ Projeto: Gerador de API                                                       }
{                                                                               }
{ O objetivo da aplica��o � facilitar a cria��o de Interface, model e controller}
{ para Insert, Update, Delete e Select a partir de tabelas do banco de dados    }
{ (Postgres ou Firebird), respeitando a tipagem, PK e FK                        }
{*******************************************************************************}
{                                                                               }
{ Desenvolvido por JANDERSON APARECIDO DA SILVA                                 }
{ Email: janderson_rm@hotmail.com                                               }
{                                                                               }
{*******************************************************************************}



unit controller.pessoa;

interface

uses
  Horse,
  Data.DB,
  DataSet.Serialize,
  FireDAC.Comp.Client,
  System.JSON,
  System.SysUtils,
  interfaces.pessoa,
  model.pessoa;

procedure Registry;

implementation

procedure SelectPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FPessoa : iPessoa;
  qry : TFDQuery;
  erro : string;
  ArrayPessoa : TJSONArray;
begin
  // Conexao com o banco...
  try
    FPessoa := TPessoa.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    try
      qry := FPessoa
                .select('',erro);

      if erro <> '' then
        raise Exception.Create(erro)
      else
      begin
        if qry.RecordCount > 0 then
        begin
          ArrayPessoa := qry.ToJSONArray();
          res.Send<TJSONArray>(ArrayPessoa).Status(200);
        end
        else
        begin
          res.Send('{ "Erro": "Nenhum cadastro de pessoa encontrado" }').Status(404);
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

procedure SelectPessoaID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FPessoa : iPessoa;
  qry : TFDQuery;
  erro : string;
  ObjPessoa : TJSONObject;
begin
  // Conexao com o banco...
  try
    FPessoa := TPessoa.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    try
      qry := FPessoa
                  .id(StrToIntDef(Req.Params['id'],0))
                .select('',erro);

      if erro <> '' then
        raise Exception.Create(erro)
      else
      begin
        if qry.RecordCount > 0 then
        begin
          ObjPessoa := qry.ToJSONObject;
          res.Send<TJSONObject>(ObjPessoa).Status(200);
        end
        else
        begin
          res.Send('{ "Erro": "Nenhum cadastro de pessoa encontrado" }').Status(404);
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

procedure InsertPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FPessoa : iPessoa;
  erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    FPessoa := TPessoa.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
    FPessoa
        .ativo(body.GetValue<Integer>('ativo',0))
        .nome(body.GetValue<string>('nome',''))
        .documento(body.GetValue<string>('documento',''))
      .Insert(erro);

    body.Free;
    if erro <> '' then
      raise Exception.Create(erro)
    else
      res.Send('{ "Resposta":"salvo com sucesso","id":"'+FPessoa.id.ToString+'" }').Status(200);
  except on E : Exception do
    begin
      res.Send('{ "erro": "'+E.Message+'" }').Status(400);
      Exit;
    end;
  end;
end;

procedure UpdatePessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FPessoa : iPessoa;
  erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    FPessoa := TPessoa.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
    FPessoa
        .id(body.GetValue<Integer>('id',0))
        .ativo(body.GetValue<Integer>('ativo',0))
        .nome(body.GetValue<string>('nome',''))
        .documento(body.GetValue<string>('documento',''))
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

procedure DeletePessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FPessoa : iPessoa;
  erro : string;
begin
  // Conexao com o banco...
  try
    FPessoa := TPessoa.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    FPessoa
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
      .Get('/pessoa', SelectPessoa)
      .Get('/pessoa/:id', SelectPessoaID)
      .Post('/pessoa', InsertPessoa)
      .Put('/pessoa', UpdatePessoa)
      .Delete('/pessoa/:id', DeletePessoa);
end;

end.
