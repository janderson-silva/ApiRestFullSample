program Client;

uses
  Vcl.Forms,
  unt.view.principal in 'src\view\unt.view.principal.pas' {Form1},
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
  model.token in 'src\model\model.token.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
