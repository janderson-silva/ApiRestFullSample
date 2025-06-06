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

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  frmLogin := TfrmLogin.Create(Self);
  try
    frmLogin.ShowModal;
  finally
    FreeAndNil(frmLogin);
  end;
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
