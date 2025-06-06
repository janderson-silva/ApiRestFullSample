unit unt.view.login;

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
  TfrmLogin = class(TForm)
    pnlDados: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edtSenha: TEdit;
    edtEmail: TEdit;
    pnlButton: TPanel;
    pnlLogin: TPanel;
    procedure pnlLoginClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    procedure CarregarLogin;
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

{ TfrmLogin }

procedure TfrmLogin.CarregarLogin;
var
  FLogin: iLogin;
  JSONObject: TJSONObject;
  JSONArrayPessoa: TJSONArray;
begin
  FLogin := TLogin.New;
  try
    JSONObject := FLogin
                      .email(edtEmail.Text)
                    .Select;

    JSONArrayPessoa := JSONObject.GetValue<TJSONArray>('login');
    if JSONArrayPessoa.Count > 0 then
    begin
      try
        if TBCrypt.CompareHash(edtSenha.Text, JSONArrayPessoa[0].GetValue<string>('senha', '')) then
          Close
        else
          raise Exception.Create('Senha incorreta!');
      finally
        JSONObject.Free;
      end;
    end
    else
      raise Exception.Create('Usuário não encontrado!');
  except on E : Exception do
    begin
      raise Exception.Create(E.Message);
      Exit;
    end;
  end;
end;

procedure TfrmLogin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Verifica se a tecla F4 foi pressionada com a tecla Alt
  if (Key = VK_F4) and (ssAlt in Shift) then
  begin
    // Encerra totalmente o sistema
    Application.Terminate;
  end;
end;

procedure TfrmLogin.pnlLoginClick(Sender: TObject);
begin
  CarregarLogin;
end;

end.
