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
  FireDAC.Comp.Client;

type
  iLogin = interface
    function id (Value : Integer) : iLogin; overload;
    function id : Integer; overload;

    function ativo (Value : Integer) : iLogin; overload;
    function ativo : Integer; overload;

    function email (Value : string) : iLogin; overload;
    function email : string; overload;

    function senha (Value : string) : iLogin; overload;
    function senha : string; overload;

    function Select(out erro : string) : TFDquery; overload;
    function Insert(out erro : String) : iLogin; overload;
    function Update(out erro : String) : iLogin; overload;
    function Delete(out erro : String) : iLogin; overload;

    function &End : iLogin;

  end;

implementation

end.
