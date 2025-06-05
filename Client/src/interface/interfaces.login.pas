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



unit interfaces.login;

interface

uses
  Data.DB,
  System.JSON;

type
  iLogin = interface
    function id(Value: LargeInt): iLogin; overload;
    function id: LargeInt; overload;

    function ativo(Value: Boolean): iLogin; overload;
    function ativo: Boolean; overload;

    function email(Value: String): iLogin; overload;
    function email: String; overload;

    function senha(Value: String): iLogin; overload;
    function senha: String; overload;

    function Select: TJSONObject; overload;
    function Insert(OnMessage: Boolean): String; overload;
    function Update(OnMessage: Boolean): String; overload;
    function Delete(OnMessage: Boolean): String; overload;
    function &End : iLogin;
  end;

implementation

end.
