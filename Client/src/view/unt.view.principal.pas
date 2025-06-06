unit unt.view.principal;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Variants,
  Vcl.ComCtrls,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Imaging.pngimage,
  Vcl.StdCtrls,
  Winapi.Messages,
  Winapi.Windows;

type
  TfrmPrincipal = class(TForm)
    pnlLateral: TPanel;
    pnlLogin: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    pnlPessoa: TPanel;
    Image2: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Image4: TImage;
    RichEdit1: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure pnlLoginClick(Sender: TObject);
    procedure pnlPessoaClick(Sender: TObject);
  private
    { Private declarations }
    procedure EscreverMemo;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  unt.view.login,
  unt.view.login.lista,
  unt.view.pessoa.lista;

{$R *.dfm}

procedure TfrmPrincipal.EscreverMemo;
begin
  RichEdit1.Lines.Clear;
  RichEdit1.Lines.Add('Descrição do Projeto');
  RichEdit1.Lines.Add('');
  RichEdit1.Lines.Add('Este projeto é composto por uma API e um cliente Delphi que realizam o gerenciamento de autenticação, usuários e pessoas.');
  RichEdit1.Lines.Add('');
  RichEdit1.Lines.Add('1. API de Autenticação:');
  RichEdit1.Lines.Add('- Implementada com o framework Horse.');
  RichEdit1.Lines.Add('- Utiliza as bibliotecas JOSE.Core.JWT e JOSE.Core.Builder para geração de tokens JWT.');
  RichEdit1.Lines.Add('');
  RichEdit1.Lines.Add('2. API de Login:');
  RichEdit1.Lines.Add('- Permite cadastrar logins com e-mail e senha.');
  RichEdit1.Lines.Add('- As senhas são armazenadas utilizando hash com o algoritmo BCrypt.');
  RichEdit1.Lines.Add('- É possível editar, listar e excluir cadastros de login.');
  RichEdit1.Lines.Add('');
  RichEdit1.Lines.Add('3. API de Pessoa:');
  RichEdit1.Lines.Add('- Permite cadastrar, editar, excluir e listar pessoas.');
  RichEdit1.Lines.Add('- Suporte ao envio de fotos:');
  RichEdit1.Lines.Add('  - Via base64;');
  RichEdit1.Lines.Add('  - Via binário (multipart/form-data).');
  RichEdit1.Lines.Add('');
  RichEdit1.Lines.Add('4. Cliente Delphi:');
  RichEdit1.Lines.Add('- Tela de login onde o usuário informa e-mail e senha.');
  RichEdit1.Lines.Add('- A senha informada é validada comparando o hash salvo no servidor.');
  RichEdit1.Lines.Add('- Após o login, é exibida a tela principal com menu de navegação.');
  RichEdit1.Lines.Add('- Acesso às telas:');
  RichEdit1.Lines.Add('  - Lista de logins, com opções de cadastrar, editar e excluir.');
  RichEdit1.Lines.Add('  - Lista de pessoas, com opções de cadastrar, editar, excluir e enviar fotos.');
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  frmLogin := TfrmLogin.Create(Self);
  try
    frmLogin.ShowModal;
  finally
    FreeAndNil(frmLogin);
  end;

  EscreverMemo;
end;

procedure TfrmPrincipal.pnlLoginClick(Sender: TObject);
begin
  frmLoginLista := TfrmLoginLista.Create(Self);
  try
    frmLoginLista.ShowModal;
  finally
    FreeAndNil(frmLoginLista);
  end;
end;

procedure TfrmPrincipal.pnlPessoaClick(Sender: TObject);
begin
  frmPessoaLista := TfrmPessoaLista.Create(Self);
  try
    frmPessoaLista.ShowModal;
  finally
    FreeAndNil(frmPessoaLista);
  end;
end;

end.
