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



unit controller.pessoa_foto_binary;

interface

uses
  Horse,
  Data.DB,
  DataSet.Serialize,
  FireDAC.Comp.Client,
  System.JSON,
  System.SysUtils,
  interfaces.pessoa_foto_binary,
  model.pessoa_foto_binary;

procedure Registry;

implementation

procedure SelectPessoa_foto_binary(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FPessoa_foto_binary : iPessoa_foto_binary;
  qry : TFDQuery;
  erro : string;
  ArrayPessoa_foto_binary : TJSONArray;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_binary := TPessoa_foto_binary.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;

  try
    try
      qry := FPessoa_foto_binary
                .select(erro);

      if erro <> '' then
        raise Exception.Create(erro)
      else
      begin
        if qry.RecordCount > 0 then
        begin
          ArrayPessoa_foto_binary := qry.ToJSONArray();
          Res.Send<TJSONArray>(ArrayPessoa_foto_binary).Status(200);
        end
        else
        begin
          Res.Send(TJSONObject.Create.AddPair('Erro', 'Nenhum cadastro de pessoa_foto_binary encontrado')).Status(404);
        end;
      end;
    except on E : Exception do
      begin
        Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
        Exit;
      end;
    end;
  finally
    qry.Free;
  end;
end;

procedure SelectPessoa_foto_binaryID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FPessoa_foto_binary : iPessoa_foto_binary;
  qry : TFDQuery;
  erro : string;
  ObjPessoa_foto_binary : TJSONObject;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_binary := TPessoa_foto_binary.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    exit;
  end;

  try
    try
      qry := FPessoa_foto_binary
                  .id(StrToIntDef(Req.Params['id'],0))
                .select(erro);

      if erro <> '' then
        raise Exception.Create(erro)
      else
      begin
        if qry.RecordCount > 0 then
        begin
          ObjPessoa_foto_binary := qry.ToJSONObject;
          Res.Send<TJSONObject>(ObjPessoa_foto_binary).Status(200);
        end
        else
        begin
          Res.Send(TJSONObject.Create.AddPair('Erro', 'Nenhum cadastro de pessoa_foto_binary encontrado')).Status(404);
        end;
      end;
    except on E : Exception do
      begin
        Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
        Exit;
      end;
    end;
  finally
    qry.Free;
  end;
end;

procedure InsertPessoa_foto_binary(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FPessoa_foto_binary : iPessoa_foto_binary;
  erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_binary := TPessoa_foto_binary.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
    FPessoa_foto_binary
        .id_pessoa(body.GetValue<Integer>('id_pessoa',0))
        .foto_binary(body.GetValue<string   {261}>('foto_binary',''))
        .nome_arquivo(body.GetValue<string>('nome_arquivo',''))
        .extensao(body.GetValue<string>('extensao',''))
      .Insert(erro);

    body.Free;
    if erro <> '' then
      raise Exception.Create(erro)
    else
      res.Send('{ "Resposta":"salvo com sucesso","id":"'+FPessoa_foto_binary.id.ToString+'" }').Status(200);
  except on E : Exception do
    begin
      Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
      Exit;
    end;
  end;
end;

procedure UpdatePessoa_foto_binary(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FPessoa_foto_binary : iPessoa_foto_binary;
  erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_binary := TPessoa_foto_binary.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
    FPessoa_foto_binary
        .id(body.GetValue<Integer>('id',0))
        .id_pessoa(body.GetValue<Integer>('id_pessoa',0))
        .foto_binary(body.GetValue<string   {261}>('foto_binary',''))
        .nome_arquivo(body.GetValue<string>('nome_arquivo',''))
        .extensao(body.GetValue<string>('extensao',''))
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

procedure DeletePessoa_foto_binary(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FPessoa_foto_binary : iPessoa_foto_binary;
  erro : string;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_binary := TPessoa_foto_binary.New;
  except
    res.Send('{ "Erro": "Erro ao conectar com o banco" }').Status(500);
    exit;
  end;

  try
    FPessoa_foto_binary
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
      .Get('/pessoa_foto_binary', SelectPessoa_foto_binary)
      .Get('/pessoa_foto_binary/:id', SelectPessoa_foto_binaryID)
      .Post('/pessoa_foto_binary', InsertPessoa_foto_binary)
      .Put('/pessoa_foto_binary', UpdatePessoa_foto_binary)
      .Delete('/pessoa_foto_binary/:id', DeletePessoa_foto_binary);
end;

end.
