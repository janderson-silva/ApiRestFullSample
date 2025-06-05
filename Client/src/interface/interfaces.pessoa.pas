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



unit interfaces.pessoa;

interface

uses
  Data.DB,
  System.JSON;

type
  iPessoa = interface
    function id(Value: LargeInt): iPessoa; overload;
    function id: LargeInt; overload;

    function ativo(Value: Boolean): iPessoa; overload;
    function ativo: Boolean; overload;

    function nome(Value: String): iPessoa; overload;
    function nome: String; overload;

    function documento(Value: String): iPessoa; overload;
    function documento: String; overload;

    function Select: TJSONObject; overload;
    function Insert(OnMessage: Boolean): String; overload;
    function Update(OnMessage: Boolean): String; overload;
    function Delete(OnMessage: Boolean): String; overload;
    function &End : iPessoa;
  end;

implementation

end.
