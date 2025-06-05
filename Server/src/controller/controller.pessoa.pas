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



unit controller.pessoa;

interface

uses
  Horse,
  Data.DB,
  System.JSON,
  System.SysUtils,
  interfaces.pessoa,
  model.pessoa;

procedure Registry;

implementation

procedure SelectPessoa(Req: THorseRequest; Res: THorseResponse);
var
  FPessoa : iPessoa;
  JSONPessoa, BodyJSON, FiltrosJSON, IncludeJSON: TJSONObject;
  Erro : string;
begin
  // Conexao com o banco...
  try
    FPessoa := TPessoa.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  try
    BodyJSON := Req.Body<TJSONObject>;

    FiltrosJSON := BodyJSON.GetValue<TJSONObject>('filtros', TJSONObject.Create);
    IncludeJSON := BodyJSON.GetValue<TJSONObject>('include', TJSONObject.Create);

    JSONPessoa := FPessoa.Select(Erro, FiltrosJSON, IncludeJSON);

    if Erro <> '' then
      Res.Send(TJSONObject.Create.AddPair('Erro', Erro)).Status(500)
    else
      Res.Send<TJSONObject>(JSONPessoa).Status(200);
  except
    on E: Exception do
      Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
  end;
end;

procedure InsertPessoa(Req: THorseRequest; Res: THorseResponse);
var
  FPessoa : iPessoa;
  Erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    FPessoa := TPessoa.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
    FPessoa
        .ativo(body.GetValue<Boolean>('ativo',False))
        .nome(body.GetValue<String>('nome',''))
        .documento(body.GetValue<String>('documento',''))
      .Insert(Erro);

    body.Free;
    if Erro <> '' then
      raise Exception.Create(Erro)
    else
      Res.Send(TJSONObject.Create.AddPair('Sucesso', 'Salvo com sucesso').AddPair('id', FPessoa.id.ToString)).Status(200);
  except on E : Exception do
    begin
      Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
      Exit;
    end;
  end;
end;

procedure UpdatePessoa(Req: THorseRequest; Res: THorseResponse);
var
  FPessoa : iPessoa;
  Erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    FPessoa := TPessoa.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
    FPessoa
        .id(body.GetValue<LargeInt>('id',0))
        .ativo(body.GetValue<Boolean>('ativo',False))
        .nome(body.GetValue<String>('nome',''))
        .documento(body.GetValue<String>('documento',''))
      .Update(Erro);

    body.Free;
    if Erro <> '' then
      raise Exception.Create(Erro)
    else
      Res.Send(TJSONObject.Create.AddPair('Sucesso', 'Atualizado com sucesso').AddPair('id', FPessoa.id.ToString)).Status(200);
  except on E : Exception do
    begin
      Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
      Exit;
    end;
  end;
end;

procedure DeletePessoa(Req: THorseRequest; Res: THorseResponse);
var
  FPessoa : iPessoa;
  Erro : string;
begin
  // Conexao com o banco...
  try
    FPessoa := TPessoa.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  try
    FPessoa
        .id(Req.Params['id'].ToInteger)
      .Delete(Erro);

    if Erro <> '' then
      raise Exception.Create(Erro)
    else
      Res.Send(TJSONObject.Create.AddPair('Sucesso', 'Deletado com sucesso').AddPair('id', FPessoa.id.ToString)).Status(200);
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
        .Prefix('v1/pessoa')
          .Post('/search',SelectPessoa)
          .Post('/insert',InsertPessoa)
          .Put('/update',UpdatePessoa)
          .Delete('/delete/:id',DeletePessoa);
end;

end.
