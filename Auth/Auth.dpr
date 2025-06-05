program Auth;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  controller.auth in 'src\controller\controller.auth.pas',
  interfaces.auth in 'src\interface\interfaces.auth.pas',
  model.auth in 'src\model\model.auth.pas';

begin
  ReportMemoryLeaksOnShutdown := True;

  THorse
    .Use(Jhonson());

  controller.auth.Registry;

  THorse.Listen(5000,
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
