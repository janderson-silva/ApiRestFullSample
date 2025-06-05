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



unit interfaces.pessoa_foto_base64;

interface

uses
  Data.DB,
  System.JSON;

type
  iPessoa_foto_base64 = interface
    function id(Value: LargeInt): iPessoa_foto_base64; overload;
    function id: LargeInt; overload;

    function id_pessoa(Value: LargeInt): iPessoa_foto_base64; overload;
    function id_pessoa: LargeInt; overload;

    function foto_base64(Value: String): iPessoa_foto_base64; overload;
    function foto_base64: String; overload;

    function Select(out Erro: string; const Filtros, Include: TJSONObject): TJSONObject; overload;
    function Insert(out Erro: String): iPessoa_foto_base64; overload;
    function Update(out Erro: String): iPessoa_foto_base64; overload;
    function Delete(out Erro: String): iPessoa_foto_base64; overload;
    function &End : iPessoa_foto_base64;
  end;

implementation

end.
