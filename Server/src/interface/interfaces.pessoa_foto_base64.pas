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
  FireDAC.Comp.Client;

type
  iPessoa_foto_base64 = interface
    function id (Value : Integer) : iPessoa_foto_base64; overload;
    function id : Integer; overload;

    function id_pessoa (Value : Integer) : iPessoa_foto_base64; overload;
    function id_pessoa : Integer; overload;

    function foto_base64 (Value : string   {261}) : iPessoa_foto_base64; overload;
    function foto_base64 : string   {261}; overload;

    function Select(out erro : string) : TFDquery; overload;
    function Insert(out erro : String) : iPessoa_foto_base64; overload;
    function Update(out erro : String) : iPessoa_foto_base64; overload;
    function Delete(out erro : String) : iPessoa_foto_base64; overload;

    function &End : iPessoa_foto_base64;

  end;

implementation

end.
