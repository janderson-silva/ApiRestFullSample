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
  FireDAC.Comp.Client;

type
  iPessoa = interface
    function id (Value : Integer) : iPessoa; overload;
    function id : Integer; overload;

    function ativo (Value : Integer) : iPessoa; overload;
    function ativo : Integer; overload;

    function nome (Value : string) : iPessoa; overload;
    function nome : string; overload;

    function documento (Value : string) : iPessoa; overload;
    function documento : string; overload;

    function Select(out erro : string) : TFDquery; overload;
    function Insert(out erro : String) : iPessoa; overload;
    function Update(out erro : String) : iPessoa; overload;
    function Delete(out erro : String) : iPessoa; overload;

    function &End : iPessoa;

  end;

implementation

end.
