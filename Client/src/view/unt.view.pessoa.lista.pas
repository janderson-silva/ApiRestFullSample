unit unt.view.pessoa.lista;

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
  System.JSON,
  interfaces.pessoa,
  model.pessoa;

type
  TfrmPessoaLista = class(TForm)
    pnlButton: TPanel;
    pnlNovo: TPanel;
    pnlEditar: TPanel;
    pnlExcluir: TPanel;
    pnlFiltro: TPanel;
    pnlFiltrar: TPanel;
    DBGridPessoa: TDBGrid;
    FDMemTablePessoa: TFDMemTable;
    FDMemTablePessoaid: TLargeintField;
    FDMemTablePessoaativo: TBooleanField;
    FDMemTablePessoanome: TStringField;
    FDMemTablePessoadocumento: TStringField;
    dsPessoa: TDataSource;
    procedure pnlFiltrarClick(Sender: TObject);
    procedure pnlNovoClick(Sender: TObject);
    procedure pnlEditarClick(Sender: TObject);
    procedure pnlExcluirClick(Sender: TObject);
  private
    { Private declarations }
    procedure CarregarPessoa;
    procedure ThreadPessoaTerminate(Sender: TObject);
    procedure ExcluirPessoa;
  public
    { Public declarations }
  end;

var
  frmPessoaLista: TfrmPessoaLista;

implementation

uses
  unt.view.pessoa.cadastro;

{$R *.dfm}

{ TfrmPessoa }

procedure TfrmPessoaLista.CarregarPessoa;
var
  FPessoa: iPessoa;
  JSONObject: TJSONObject;
  JSONArrayPessoa: TJSONArray;
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(procedure
  begin

    FPessoa := TPessoa.New;
    try

      TThread.Synchronize(nil, procedure
      begin

        JSONObject := FPessoa
                        .Select;

        JSONArrayPessoa := JSONObject.GetValue<TJSONArray>('pessoa');
        try
          var i: Integer;

          FDMemTablePessoa.Open;
          FDMemTablePessoa.EmptyDataSet;
          for i := 0 to JSONArrayPessoa.Count - 1 do
          begin
            FDMemTablePessoa.Append;
            FDMemTablePessoa.FieldByName('id').AsInteger := JSONArrayPessoa[i].GetValue<Integer>('id', 0);
            FDMemTablePessoa.FieldByName('ativo').AsBoolean := JSONArrayPessoa[i].GetValue<Boolean>('ativo', False);
            FDMemTablePessoa.FieldByName('nome').AsString := JSONArrayPessoa[i].GetValue<string>('nome', '');
            FDMemTablePessoa.FieldByName('documento').AsString := JSONArrayPessoa[i].GetValue<string>('documento', '');
            FDMemTablePessoa.Post;
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

  t.OnTerminate := ThreadPessoaTerminate;
  t.Start;
end;

procedure TfrmPessoaLista.ExcluirPessoa;
var
  FPessoa: iPessoa;
begin
  FPessoa := TPessoa.New;
  try
    FPessoa
        .id(FDMemTablePessoa.FieldByName('id').AsInteger)
      .Delete(True);
  except on E : Exception do
    begin
      raise Exception.Create(E.Message);
      Exit;
    end;
  end;
end;

procedure TfrmPessoaLista.pnlEditarClick(Sender: TObject);
begin
  if FDMemTablePessoa.IsEmpty then
    raise Exception.Create('Nenhuma pessoa na lista.');

  frmPessoaCadastro := TfrmPessoaCadastro.Create(Self);
  try
    frmPessoaCadastro.IniciarTela(FDMemTablePessoa.FieldByName('id').AsInteger);
    frmPessoaCadastro.ShowModal;
  finally
    FreeAndNil(frmPessoaCadastro);
  end;
end;

procedure TfrmPessoaLista.pnlExcluirClick(Sender: TObject);
begin
  if FDMemTablePessoa.IsEmpty then
    raise Exception.Create('Nenhuma pessoa na lista.');

  ExcluirPessoa;
end;

procedure TfrmPessoaLista.pnlFiltrarClick(Sender: TObject);
begin
  CarregarPessoa;
end;

procedure TfrmPessoaLista.pnlNovoClick(Sender: TObject);
begin
  frmPessoaCadastro := TfrmPessoaCadastro.Create(Self);
  try
    frmPessoaCadastro.IniciarTela(0);
    frmPessoaCadastro.ShowModal;
  finally
    FreeAndNil(frmPessoaCadastro);
  end;
end;

procedure TfrmPessoaLista.ThreadPessoaTerminate(Sender: TObject);
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
