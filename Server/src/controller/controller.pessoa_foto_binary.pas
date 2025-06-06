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
  System.Classes,
  System.JSON,
  System.SysUtils,
  interfaces.pessoa_foto_binary,
  model.pessoa_foto_binary;

procedure Registry;

implementation

procedure SelectPessoa_foto_binary(Req: THorseRequest; Res: THorseResponse);
var
  FPessoa_foto_binary : iPessoa_foto_binary;
  JSONPessoa_foto_binary, BodyJSON, FiltrosJSON, IncludeJSON: TJSONObject;
  Erro : string;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_binary := TPessoa_foto_binary.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  try
    BodyJSON := Req.Body<TJSONObject>;

    FiltrosJSON := BodyJSON.GetValue<TJSONObject>('filtros', TJSONObject.Create);
    IncludeJSON := BodyJSON.GetValue<TJSONObject>('include', TJSONObject.Create);

    JSONPessoa_foto_binary := FPessoa_foto_binary.Select(Erro, FiltrosJSON, IncludeJSON);

    if Erro <> '' then
      Res.Send(TJSONObject.Create.AddPair('Erro', Erro)).Status(500)
    else
      Res.Send<TJSONObject>(JSONPessoa_foto_binary).Status(200);
  except
    on E: Exception do
      Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
  end;
end;

procedure InsertPessoa_foto_binary(Req: THorseRequest; Res: THorseResponse);
var
  FPessoa_foto_binary : iPessoa_foto_binary;
  Erro : string;
  LID_PESSOA: Integer;
  LPath: string;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_binary := TPessoa_foto_binary.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  try
    LID_PESSOA := 0;
    LPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'temp';
    ForceDirectories(LPath); // Garante que a pasta exista;

    if Req.ContentFields.Field('id_pessoa').AsInteger > 0 then
      LID_PESSOA := Req.ContentFields.Field('id_pessoa').AsInteger;

    if (not Req.ContentFields.Field('file-name').AsString.IsEmpty) and (Req.ContentFields.Field('file').AsStream.Size > 0) then
    begin
      LPath := LPath + Req.ContentFields.Field('file-name').AsString;
      Req.ContentFields.Field('file').SaveToFile(LPath);
    end;

    FPessoa_foto_binary
        .id_pessoa(LID_PESSOA)
        .foto_binary(LPath)
        .nome_arquivo(ExtractFileName(LPath))
        .extensao(ExtractFileExt(LPath))
      .Insert(Erro);

    if Erro <> '' then
      raise Exception.Create(Erro)
    else
      Res.Send(TJSONObject.Create.AddPair('Sucesso', 'Salvo com sucesso').AddPair('id', FPessoa_foto_binary.id.ToString)).Status(200);
  except on E : Exception do
    begin
      Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
      Exit;
    end;
  end;
end;

procedure UpdatePessoa_foto_binary(Req: THorseRequest; Res: THorseResponse);
var
  FPessoa_foto_binary : iPessoa_foto_binary;
  Erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_binary := TPessoa_foto_binary.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
    FPessoa_foto_binary
        .id(body.GetValue<LargeInt>('id',0))
        .id_pessoa(body.GetValue<LargeInt>('id_pessoa',0))
        //.foto_binary(body.GetValue<String>('foto_binary',''))
        .nome_arquivo(body.GetValue<String>('nome_arquivo',''))
        .extensao(body.GetValue<String>('extensao',''))
      .Update(Erro);

    body.Free;
    if Erro <> '' then
      raise Exception.Create(Erro)
    else
      Res.Send(TJSONObject.Create.AddPair('Sucesso', 'Atualizado com sucesso').AddPair('id', FPessoa_foto_binary.id.ToString)).Status(200);
  except on E : Exception do
    begin
      Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
      Exit;
    end;
  end;
end;

procedure DeletePessoa_foto_binary(Req: THorseRequest; Res: THorseResponse);
var
  FPessoa_foto_binary : iPessoa_foto_binary;
  Erro : string;
begin
  // Conexao com o banco...
  try
    FPessoa_foto_binary := TPessoa_foto_binary.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  try
    FPessoa_foto_binary
        .id(Req.Params['id'].ToInteger)
      .Delete(Erro);

    if Erro <> '' then
      raise Exception.Create(Erro)
    else
      Res.Send(TJSONObject.Create.AddPair('Sucesso', 'Deletado com sucesso').AddPair('id', FPessoa_foto_binary.id.ToString)).Status(200);
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
        .Prefix('v1/pessoa_foto_binary')
          .Post('/search',SelectPessoa_foto_binary)
          .Post('/insert',InsertPessoa_foto_binary)
          .Put('/update',UpdatePessoa_foto_binary)
          .Delete('/delete/:id',DeletePessoa_foto_binary);
end;

end.
