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



unit route.api;

interface

type
  TRoute = class
  public
    const ACTION_SEARCH = 'search';
    const ACTION_INSERT = 'insert';
    const ACTION_UPDATE = 'update';
    const ACTION_DELETE = 'delete';

    const API_HOST_SERVER_HOMOLOGACAO = 'localhost';
    const API_HOST_SERVER_PRODUCAO = 'SEU SERVIDOR DE PRODUCAO';
    const API_HOST_SERVER = API_HOST_SERVER_HOMOLOGACAO;

    class function GetLoginRoute(const AAction: string = ''): string;
    class function GetPessoaRoute(const AAction: string = ''): string;
    class function GetPessoa_foto_base64Route(const AAction: string = ''): string;
    class function GetPessoa_foto_binaryRoute(const AAction: string = ''): string;
  end;

implementation

class function TRoute.GetLoginRoute(const AAction: string = ''): string;
begin
  Result := 'http://' + API_HOST_SERVER + ':9000/v1/login/';
  if AAction <> '' then
    Result := Result + AAction;
  Result := Result;
end;

class function TRoute.GetPessoaRoute(const AAction: string = ''): string;
begin
  Result := 'http://' + API_HOST_SERVER + ':9000/v1/pessoa/';
  if AAction <> '' then
    Result := Result + AAction;
  Result := Result;
end;

class function TRoute.GetPessoa_foto_base64Route(const AAction: string = ''): string;
begin
  Result := 'http://' + API_HOST_SERVER + ':9000/v1/pessoa_foto_base64/';
  if AAction <> '' then
    Result := Result + AAction;
  Result := Result;
end;

class function TRoute.GetPessoa_foto_binaryRoute(const AAction: string = ''): string;
begin
  Result := 'http://' + API_HOST_SERVER + ':9000/v1/pessoa_foto_binary/';
  if AAction <> '' then
    Result := Result + AAction;
  Result := Result;
end;

end.
