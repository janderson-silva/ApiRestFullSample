unit unt.view.login.cadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrmLoginCadastro = class(TForm)
    pnlButton: TPanel;
    pnlSalvar: TPanel;
    pnlCancelar: TPanel;
    pnlDados: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edtSenha: TEdit;
    edtEmail: TEdit;
    chkAtivo: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLoginCadastro: TfrmLoginCadastro;

implementation

{$R *.dfm}

end.
