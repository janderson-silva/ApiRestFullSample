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



unit interfaces.pessoa_foto_binary;

interface

uses
  Data.DB,
  FireDAC.Comp.Client;

type
  iPessoa_foto_binary = interface
    function id (Value : Integer) : iPessoa_foto_binary; overload;
    function id : Integer; overload;

    function id_pessoa (Value : Integer) : iPessoa_foto_binary; overload;
    function id_pessoa : Integer; overload;

    function foto_binary (Value : string   {261}) : iPessoa_foto_binary; overload;
    function foto_binary : string   {261}; overload;

    function nome_arquivo (Value : string) : iPessoa_foto_binary; overload;
    function nome_arquivo : string; overload;

    function extensao (Value : string) : iPessoa_foto_binary; overload;
    function extensao : string; overload;

    function Select(out erro : string) : TFDquery; overload;
    function Insert(out erro : String) : iPessoa_foto_binary; overload;
    function Update(out erro : String) : iPessoa_foto_binary; overload;
    function Delete(out erro : String) : iPessoa_foto_binary; overload;

    function &End : iPessoa_foto_binary;

  end;

implementation

end.
