program Client;

uses
  Vcl.Forms,
  unt.view.principal in 'src\view\unt.view.principal.pas' {frmPrincipal},
  interfaces.login in 'src\interface\interfaces.login.pas',
  interfaces.pessoa in 'src\interface\interfaces.pessoa.pas',
  interfaces.pessoa_foto_base64 in 'src\interface\interfaces.pessoa_foto_base64.pas',
  interfaces.pessoa_foto_binary in 'src\interface\interfaces.pessoa_foto_binary.pas',
  model.login in 'src\model\model.login.pas',
  model.pessoa in 'src\model\model.pessoa.pas',
  model.pessoa_foto_base64 in 'src\model\model.pessoa_foto_base64.pas',
  model.pessoa_foto_binary in 'src\model\model.pessoa_foto_binary.pas',
  route.api in 'src\route\route.api.pas',
  interfaces.token in 'src\interface\interfaces.token.pas',
  model.token in 'src\model\model.token.pas',
  unt.view.login in 'src\view\unt.view.login.pas' {frmLogin},
  unt.view.pessoa.cadastro in 'src\view\unt.view.pessoa.cadastro.pas' {frmPessoaCadastro},
  unt.view.pessoa.lista in 'src\view\unt.view.pessoa.lista.pas' {frmPessoaLista},
  Base64.util in 'src\util\Base64.util.pas',
  unt.view.login.cadastro in 'src\view\unt.view.login.cadastro.pas' {frmLoginCadastro},
  unt.view.login.lista in 'src\view\unt.view.login.lista.pas' {frmLoginLista},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Onyx Blue');
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
