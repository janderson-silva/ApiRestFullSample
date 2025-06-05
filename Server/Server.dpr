program Server;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Horse.JWT,
  controller.login in 'src\controller\controller.login.pas',
  controller.pessoa in 'src\controller\controller.pessoa.pas',
  controller.pessoa_foto_base64 in 'src\controller\controller.pessoa_foto_base64.pas',
  controller.pessoa_foto_binary in 'src\controller\controller.pessoa_foto_binary.pas',
  interfaces.login in 'src\interface\interfaces.login.pas',
  interfaces.pessoa in 'src\interface\interfaces.pessoa.pas',
  interfaces.pessoa_foto_base64 in 'src\interface\interfaces.pessoa_foto_base64.pas',
  interfaces.pessoa_foto_binary in 'src\interface\interfaces.pessoa_foto_binary.pas',
  model.connection in 'src\model\model.connection.pas',
  model.login in 'src\model\model.login.pas',
  model.pessoa in 'src\model\model.pessoa.pas',
  model.pessoa_foto_base64 in 'src\model\model.pessoa_foto_base64.pas',
  model.pessoa_foto_binary in 'src\model\model.pessoa_foto_binary.pas';

//Pegar variavel do sistema
function GetEnvVarValue: string;
const
  LVarName: string = 'ATRON_JWT_SECRET';
begin
  Result := GetEnvironmentVariable(LVarName);
  if Result = '' then
    raise Exception.CreateFmt('Variável de ambiente "%s" não encontrada.', [LVarName])
end;

begin
  ReportMemoryLeaksOnShutdown := True;

  THorse
    .Use(Jhonson())
    .Use(HorseJWT(GetEnvVarValue));

  controller.login.Registry;
  controller.pessoa.Registry;
  controller.pessoa_foto_base64.Registry;
  controller.pessoa_foto_binary.Registry;

  THorse.Listen(9000,
                procedure
                begin
                  Writeln('Servidor Executando na Porta -> ' + THorse.Port.ToString);
                  Writeln('');
                  Write('Pressione Enter para parar');
                  Writeln('');
                  Writeln('');
                  Readln;
                  THorse.StopListen;
                end);
end.
