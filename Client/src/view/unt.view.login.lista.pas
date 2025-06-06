unit unt.view.login.lista;

interface

uses
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  FireDAC.DApt.Intf,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Error,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  System.Classes,
  System.JSON,
  System.SysUtils,
  System.Variants,
  Vcl.Controls,
  Vcl.DBGrids,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Grids,
  Winapi.Messages,
  Winapi.Windows,
  interfaces.login,
  model.login;

type
  TfrmLoginLista = class(TForm)
    pnlButton: TPanel;
    pnlNovo: TPanel;
    pnlEditar: TPanel;
    pnlExcluir: TPanel;
    pnlFiltro: TPanel;
    pnlFiltrar: TPanel;
    DBGridLogin: TDBGrid;
    FDMemTableLogin: TFDMemTable;
    FDMemTableLoginid: TLargeintField;
    FDMemTableLoginativo: TBooleanField;
    dsLogin: TDataSource;
    FDMemTableLoginemail: TStringField;
    FDMemTableLoginsenha: TStringField;
    procedure pnlNovoClick(Sender: TObject);
    procedure pnlEditarClick(Sender: TObject);
    procedure pnlFiltrarClick(Sender: TObject);
    procedure pnlExcluirClick(Sender: TObject);
  private
    { Private declarations }
    procedure CarregarLogin;
    procedure ThreadLoginTerminate(Sender: TObject);
    procedure ExcluirLogin;
  public
    { Public declarations }
  end;

var
  frmLoginLista: TfrmLoginLista;

implementation

uses
  unt.view.login.cadastro;

{$R *.dfm}

procedure TfrmLoginLista.CarregarLogin;
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
                        .Select;

        JSONArrayPessoa := JSONObject.GetValue<TJSONArray>('login');
        try
          var i: Integer;

          FDMemTableLogin.Open;
          FDMemTableLogin.EmptyDataSet;
          for i := 0 to JSONArrayPessoa.Count - 1 do
          begin
            FDMemTableLogin.Append;
            FDMemTableLogin.FieldByName('id').AsInteger := JSONArrayPessoa[i].GetValue<Integer>('id', 0);
            FDMemTableLogin.FieldByName('ativo').AsBoolean := JSONArrayPessoa[i].GetValue<Boolean>('ativo', False);
            FDMemTableLogin.FieldByName('email').AsString := JSONArrayPessoa[i].GetValue<string>('email', '');
            FDMemTableLogin.FieldByName('senha').AsString := JSONArrayPessoa[i].GetValue<string>('senha', '');
            FDMemTableLogin.Post;
          end;
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

procedure TfrmLoginLista.ExcluirLogin;
var
  FLogin: iLogin;
begin
  FLogin := TLogin.New;
  try
    FLogin
        .id(FDMemTableLogin.FieldByName('id').AsInteger)
      .Delete(True);
  except on E : Exception do
    begin
      raise Exception.Create(E.Message);
      Exit;
    end;
  end;
end;

procedure TfrmLoginLista.pnlEditarClick(Sender: TObject);
begin
  if FDMemTableLogin.IsEmpty then
    raise Exception.Create('Nenhum login na lista.');

  frmLoginCadastro := TfrmLoginCadastro.Create(Self);
  try
    frmLoginCadastro.IniciarTela(FDMemTableLogin.FieldByName('id').AsInteger);
    frmLoginCadastro.ShowModal;
  finally
    FreeAndNil(frmLoginCadastro);
  end;
end;

procedure TfrmLoginLista.pnlExcluirClick(Sender: TObject);
begin
  if FDMemTableLogin.IsEmpty then
    raise Exception.Create('Nenhum login na lista.');

  ExcluirLogin;
end;

procedure TfrmLoginLista.pnlFiltrarClick(Sender: TObject);
begin
  CarregarLogin;
end;

procedure TfrmLoginLista.pnlNovoClick(Sender: TObject);
begin
  frmLoginCadastro := TfrmLoginCadastro.Create(Self);
  try
    frmLoginCadastro.IniciarTela(0);
    frmLoginCadastro.ShowModal;
  finally
    FreeAndNil(frmLoginCadastro);
  end;
end;

procedure TfrmLoginLista.ThreadLoginTerminate(Sender: TObject);
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
