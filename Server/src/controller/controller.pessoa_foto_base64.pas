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
  System.JSON,
  System.SysUtils,
  interfaces.pessoa_foto_base64,
  model.pessoa_foto_base64;

procedure Registry;

implementation

procedure SelectPessoa_foto_base64(Req: THorseRequest; Res: THorseResponse);
var
  FPessoa_foto_base64 : iPessoa_foto_base64;
  JSONPessoa_foto_base64, BodyJSON, FiltrosJSON, IncludeJSON: TJSONObject;
  Erro : string;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_base64 := TPessoa_foto_base64.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  try
    BodyJSON := Req.Body<TJSONObject>;

    FiltrosJSON := BodyJSON.GetValue<TJSONObject>('filtros', TJSONObject.Create);
    IncludeJSON := BodyJSON.GetValue<TJSONObject>('include', TJSONObject.Create);

    JSONPessoa_foto_base64 := FPessoa_foto_base64.Select(Erro, FiltrosJSON, IncludeJSON);

    if Erro <> '' then
      Res.Send(TJSONObject.Create.AddPair('Erro', Erro)).Status(500)
    else
      Res.Send<TJSONObject>(JSONPessoa_foto_base64).Status(200);
  except
    on E: Exception do
      Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
  end;
end;

procedure InsertPessoa_foto_base64(Req: THorseRequest; Res: THorseResponse);
var
  FPessoa_foto_base64 : iPessoa_foto_base64;
  Erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_base64 := TPessoa_foto_base64.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
    FPessoa_foto_base64
        .id_pessoa(body.GetValue<LargeInt>('id_pessoa',0))
        .foto_base64(body.GetValue<String>('foto_base64',''))
      .Insert(Erro);

    body.Free;
    if Erro <> '' then
      raise Exception.Create(Erro)
    else
      Res.Send(TJSONObject.Create.AddPair('Sucesso', 'Salvo com sucesso').AddPair('id', FPessoa_foto_base64.id.ToString)).Status(200);
  except on E : Exception do
    begin
      Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
      Exit;
    end;
  end;
end;

procedure UpdatePessoa_foto_base64(Req: THorseRequest; Res: THorseResponse);
var
  FPessoa_foto_base64 : iPessoa_foto_base64;
  Erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_base64 := TPessoa_foto_base64.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
    FPessoa_foto_base64
        .id(body.GetValue<LargeInt>('id',0))
        .id_pessoa(body.GetValue<LargeInt>('id_pessoa',0))
        .foto_base64(body.GetValue<String>('foto_base64',''))
      .Update(Erro);

    body.Free;
    if Erro <> '' then
      raise Exception.Create(Erro)
    else
      Res.Send(TJSONObject.Create.AddPair('Sucesso', 'Atualizado com sucesso').AddPair('id', FPessoa_foto_base64.id.ToString)).Status(200);
  except on E : Exception do
    begin
      Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
      Exit;
    end;
  end;
end;

procedure DeletePessoa_foto_base64(Req: THorseRequest; Res: THorseResponse);
var
  FPessoa_foto_base64 : iPessoa_foto_base64;
  Erro : string;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_base64 := TPessoa_foto_base64.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  try
    FPessoa_foto_base64
        .id(Req.Params['id'].ToInteger)
      .Delete(Erro);

    if Erro <> '' then
      raise Exception.Create(Erro)
    else
      Res.Send(TJSONObject.Create.AddPair('Sucesso', 'Deletado com sucesso').AddPair('id', FPessoa_foto_base64.id.ToString)).Status(200);
  except on E : Exception do
    begin
      Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
      Exit;
    end;
  end;
end;

procedure Registry;
begin
    THorse
      .Group
        .Prefix('v1/pessoa_foto_base64')
          .Post('/search',SelectPessoa_foto_base64)
          .Post('/insert',InsertPessoa_foto_base64)
          .Put('/update',UpdatePessoa_foto_base64)
          .Delete('/delete/:id',DeletePessoa_foto_base64);
end;

end.
