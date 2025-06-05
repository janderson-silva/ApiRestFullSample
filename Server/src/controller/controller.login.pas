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
  System.JSON,
  System.SysUtils,
  interfaces.login,
  model.login;

procedure Registry;

implementation

procedure SelectLogin(Req: THorseRequest; Res: THorseResponse);
var
  FLogin : iLogin;
  JSONLogin, BodyJSON, FiltrosJSON, IncludeJSON: TJSONObject;
  Erro : string;
begin
  // Conexao com o banco...
  try
    FLogin := TLogin.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  try
    BodyJSON := Req.Body<TJSONObject>;

    FiltrosJSON := BodyJSON.GetValue<TJSONObject>('filtros', TJSONObject.Create);
    IncludeJSON := BodyJSON.GetValue<TJSONObject>('include', TJSONObject.Create);

    JSONLogin := FLogin.Select(Erro, FiltrosJSON, IncludeJSON);

    if Erro <> '' then
      Res.Send(TJSONObject.Create.AddPair('Erro', Erro)).Status(500)
    else
      Res.Send<TJSONObject>(JSONLogin).Status(200);
  except
    on E: Exception do
      Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
  end;
end;

procedure InsertLogin(Req: THorseRequest; Res: THorseResponse);
var
  FLogin : iLogin;
  Erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    FLogin := TLogin.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
    FLogin
        .ativo(body.GetValue<Boolean>('ativo',False))
        .email(body.GetValue<String>('email',''))
        .senha(body.GetValue<String>('senha',''))
      .Insert(Erro);

    body.Free;
    if Erro <> '' then
      raise Exception.Create(Erro)
    else
      Res.Send(TJSONObject.Create.AddPair('Sucesso', 'Salvo com sucesso').AddPair('id', FLogin.id.ToString)).Status(200);
  except on E : Exception do
    begin
      Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
      Exit;
    end;
  end;
end;

procedure UpdateLogin(Req: THorseRequest; Res: THorseResponse);
var
  FLogin : iLogin;
  Erro : string;
  body  : TJsonValue;
begin
  // Conexao com o banco...
  try
    FLogin := TLogin.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
    FLogin
        .id(body.GetValue<LargeInt>('id',0))
        .ativo(body.GetValue<Boolean>('ativo',False))
        .email(body.GetValue<String>('email',''))
        .senha(body.GetValue<String>('senha',''))
      .Update(Erro);

    body.Free;
    if Erro <> '' then
      raise Exception.Create(Erro)
    else
      Res.Send(TJSONObject.Create.AddPair('Sucesso', 'Atualizado com sucesso').AddPair('id', FLogin.id.ToString)).Status(200);
  except on E : Exception do
    begin
      Res.Send(TJSONObject.Create.AddPair('Erro', E.Message)).Status(500);
      Exit;
    end;
  end;
end;

procedure DeleteLogin(Req: THorseRequest; Res: THorseResponse);
var
  FLogin : iLogin;
  Erro : string;
begin
  // Conexao com o banco...
  try
    FLogin := TLogin.New;
  except
    Res.Send(TJSONObject.Create.AddPair('Erro', 'Erro ao conectar com o banco')).Status(500);
    Exit;
  end;

  try
    FLogin
        .id(Req.Params['id'].ToInteger)
      .Delete(Erro);

    if Erro <> '' then
      raise Exception.Create(Erro)
    else
      Res.Send(TJSONObject.Create.AddPair('Sucesso', 'Deletado com sucesso').AddPair('id', FLogin.id.ToString)).Status(200);
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
        .Prefix('v1/login')
          .Post('/search',SelectLogin)
          .Post('/insert',InsertLogin)
          .Put('/update',UpdateLogin)
          .Delete('/delete/:id',DeleteLogin);
end;

end.
