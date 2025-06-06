unit unt.view.login.cadastro;

interface

uses
  BCrypt,
  System.Classes,
  System.JSON,
  System.SysUtils,
  System.Variants,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.StdCtrls,
  Winapi.Messages,
  Winapi.Windows,
  interfaces.login,
  model.login;

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
    procedure pnlSalvarClick(Sender: TObject);
    procedure pnlCancelarClick(Sender: TObject);
  private
    { Private declarations }
    var FID_LOGIN: Integer;
    var FSenhaOld: string;
    procedure CarregarLogin;
    procedure ThreadLoginTerminate(Sender: TObject);
    procedure CadastrarLogin;
    procedure AtualizarLogin;
  public
    { Public declarations }
    procedure IniciarTela(AID_LOGIN: Integer);
  end;

var
  frmLoginCadastro: TfrmLoginCadastro;

implementation

{$R *.dfm}

procedure TfrmLoginCadastro.AtualizarLogin;
var
  FLogin: iLogin;
  LSenha: string;
begin
  if FSenhaOld <> edtSenha.Text then
    LSenha := TBCrypt.GenerateHash(edtSenha.Text)
  else
    LSenha := FSenhaOld;

  FLogin := TLogin.New;
  try
    FLogin
        .id(FID_LOGIN)
        .ativo(chkAtivo.Checked)
        .email(edtEmail.Text)
        .senha(LSenha)
      .Update(True)
  except on E : Exception do
    begin
      raise Exception.Create(E.Message);
      Exit;
    end;
  end;
end;

procedure TfrmLoginCadastro.CadastrarLogin;
var
  FLogin: iLogin;
begin
  FLogin := TLogin.New;
  try
    FLogin
        .ativo(chkAtivo.Checked)
        .email(edtEmail.Text)
        .senha(TBCrypt.GenerateHash(edtSenha.Text))
      .Insert(True)
  except on E : Exception do
    begin
      raise Exception.Create(E.Message);
      Exit;
    end;
  end;
end;

procedure TfrmLoginCadastro.CarregarLogin;
var
  FLogin: iLogin;
  JSONObject: TJSONObject;
  JSONArrayPessoa: TJSONArray;
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(procedure
  begin

    FLogin := TLogin.New;
    try

      TThread.Synchronize(nil, procedure
      begin

        JSONObject := FLogin
                          .id(FID_LOGIN)
                        .Select;

        JSONArrayPessoa := JSONObject.GetValue<TJSONArray>('login');
        try
          chkAtivo.Checked := JSONArrayPessoa[0].GetValue<Boolean>('ativo', False);
          edtEmail.Text := JSONArrayPessoa[0].GetValue<string>('email', '');
          edtSenha.Text := JSONArrayPessoa[0].GetValue<string>('senha', '');
          FSenhaOld := JSONArrayPessoa[0].GetValue<string>('senha', '');
        finally
          JSONObject.Free;
        end;

      end);

    except on E : Exception do
      begin
        raise Exception.Create(E.Message);
        Exit;
      end;
    end;

  end);

  t.OnTerminate := ThreadLoginTerminate;
  t.Start;
end;

procedure TfrmLoginCadastro.IniciarTela(AID_LOGIN: Integer);
begin
  FID_LOGIN := AID_LOGIN;
  if FID_LOGIN > 0 then
    CarregarLogin;
end;

procedure TfrmLoginCadastro.pnlCancelarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja mesmo cancelar?','Confirmação',MB_YESNO+MB_ICONQUESTION) = ID_YES then
    Close;
end;

procedure TfrmLoginCadastro.pnlSalvarClick(Sender: TObject);
begin
  if FID_LOGIN > 0 then
    AtualizarLogin
  else
    CadastrarLogin;

  Close;
end;

procedure TfrmLoginCadastro.ThreadLoginTerminate(Sender: TObject);
begin
  if Sender is TThread then
  begin
      if Assigned(TThread(Sender).FatalException) then
      begin
          showmessage(Exception(TThread(sender).FatalException).Message);
          exit;
      end;
  end;
end;

end.
