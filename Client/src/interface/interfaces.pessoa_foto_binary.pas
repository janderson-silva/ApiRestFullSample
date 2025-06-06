﻿{*******************************************************************************}
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
  System.Classes,
  System.JSON;

type
  iPessoa_foto_binary = interface
    function id(Value: LargeInt): iPessoa_foto_binary; overload;
    function id: LargeInt; overload;

    function id_pessoa(Value: LargeInt): iPessoa_foto_binary; overload;
    function id_pessoa: LargeInt; overload;

    function foto_binary(Value: TMemoryStream): iPessoa_foto_binary; overload;
    function foto_binary: TMemoryStream; overload;

    function nome_arquivo(Value: String): iPessoa_foto_binary; overload;
    function nome_arquivo: String; overload;

    function extensao(Value: String): iPessoa_foto_binary; overload;
    function extensao: String; overload;

    function Select: TJSONObject; overload;
    function Insert(OnMessage: Boolean): String; overload;
    function Update(OnMessage: Boolean): String; overload;
    function Delete(OnMessage: Boolean): String; overload;
    function &End : iPessoa_foto_binary;
  end;

implementation

end.
