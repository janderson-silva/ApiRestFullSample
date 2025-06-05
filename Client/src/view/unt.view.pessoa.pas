unit unt.view.pessoa;

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
  TfrmPessoa = class(TForm)
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
  private
    { Private declarations }
    procedure CarregarPessoa;
  public
    { Public declarations }
  end;

var
  frmPessoa: TfrmPessoa;

implementation

uses
  unt.view.pessoa.cadastro;

{$R *.dfm}

{ TfrmPessoa }

procedure TfrmPessoa.CarregarPessoa;
var
  FPessoa: iPessoa;
  JSONObject: TJSONObject;
  JSONArrayPessoa: TJSONArray;
  i: Integer;
begin
  FPessoa := TPessoa.New;
  try
    JSONObject := FPessoa
                      //.nome('JANDERSON APARECIDO DA SILVA')
                      //.id(1)
                    .Select;

    JSONArrayPessoa := JSONObject.GetValue<TJSONArray>('pessoa');
    try
      FDMemTablePessoa.Open;
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

  except on E : Exception do
    begin
      raise Exception.Create(E.Message);
      Exit;
    end;
  end;
end;

procedure TfrmPessoa.pnlEditarClick(Sender: TObject);
begin
  frmPessoaCadastro := TfrmPessoaCadastro.Create(Self);
  try
    frmPessoaCadastro.IniciarTela(FDMemTablePessoa.FieldByName('id').AsInteger);
    frmPessoaCadastro.ShowModal;
  finally
    FreeAndNil(frmPessoaCadastro);
  end;
end;

procedure TfrmPessoa.pnlFiltrarClick(Sender: TObject);
begin
  CarregarPessoa;
end;

procedure TfrmPessoa.pnlNovoClick(Sender: TObject);
begin
  frmPessoaCadastro := TfrmPessoaCadastro.Create(Self);
  try
    frmPessoaCadastro.IniciarTela(0);
    frmPessoaCadastro.ShowModal;
  finally
    FreeAndNil(frmPessoaCadastro);
  end;
end;

end.
