unit unt.view.pessoa.cadastro;

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
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Imaging.pngimage,
  Vcl.StdCtrls,
  Winapi.Messages,
  Winapi.Windows,
  System.JSON,
  interfaces.pessoa,
  model.pessoa;

type
  TfrmPessoaCadastro = class(TForm)
    pnlButton: TPanel;
    pnlSalvar: TPanel;
    pnlCancelar: TPanel;
    pnlDados: TPanel;
    pnlLeftFoto: TPanel;
    pnlFotoBase64: TPanel;
    pnlFotoBase64TImage: TPanel;
    imgFotoBase64: TImage;
    pnlAddFotoBase64: TPanel;
    imgAddFotoBase64: TImage;
    lblAddFotoBase64: TLabel;
    pnlDelFotoBase64: TPanel;
    imgDelFotoBase64: TImage;
    lblDelFotoBase64: TLabel;
    Label1: TLabel;
    edtDocumento: TEdit;
    Label2: TLabel;
    edtNome: TEdit;
    chkAtivo: TCheckBox;
    Panel1: TPanel;
    pnlFotoBinary: TPanel;
    pnlFotoBinaryTImage: TPanel;
    imgFotoBinary: TImage;
    pnlAddFotoBinary: TPanel;
    imgAddFotoBinary: TImage;
    lblAddFotoBinary: TLabel;
    pnlDelFotoBinary: TPanel;
    imgDelFotoBinary: TImage;
    lblDelFotoBinary: TLabel;
    FDMemTablePessoa: TFDMemTable;
    FDMemTablePessoaid: TLargeintField;
    FDMemTablePessoaativo: TBooleanField;
    FDMemTablePessoanome: TStringField;
    FDMemTablePessoadocumento: TStringField;
    procedure pnlSalvarClick(Sender: TObject);
  private
    { Private declarations }
    var FID_PESSOA: Integer;

    procedure CarregarPessoa;
    procedure CadastrarPessoa;
    procedure AtualizarPessoa;
  public
    { Public declarations }
    procedure IniciarTela(AID_PESSOA: Integer);
  end;

var
  frmPessoaCadastro: TfrmPessoaCadastro;

implementation

{$R *.dfm}

{ TfrmPessoaCadastro }

procedure TfrmPessoaCadastro.AtualizarPessoa;
var
  FPessoa: iPessoa;
begin
  FPessoa := TPessoa.New;
  try
    FPessoa
        .id(FID_PESSOA)
        .ativo(chkAtivo.Checked)
        .nome(edtNome.Text)
        .documento(edtDocumento.Text)
      .Update(True);
  except on E : Exception do
    begin
      raise Exception.Create(E.Message);
      Exit;
    end;
  end;
end;

procedure TfrmPessoaCadastro.CadastrarPessoa;
var
  FPessoa: iPessoa;
begin
  FPessoa := TPessoa.New;
  try
    FPessoa
        .ativo(chkAtivo.Checked)
        .nome(edtNome.Text)
        .documento(edtDocumento.Text)
      .Insert(True);
  except on E : Exception do
    begin
      raise Exception.Create(E.Message);
      Exit;
    end;
  end;
end;

procedure TfrmPessoaCadastro.CarregarPessoa;
var
  FPessoa: iPessoa;
  JSONObject: TJSONObject;
  JSONArrayPessoa: TJSONArray;
begin
  FPessoa := TPessoa.New;
  try
    JSONObject := FPessoa
                      .id(FID_PESSOA)
                    .Select;

    JSONArrayPessoa := JSONObject.GetValue<TJSONArray>('pessoa');
    try
      chkAtivo.Checked := JSONArrayPessoa[0].GetValue<Boolean>('ativo', False);
      edtNome.Text := JSONArrayPessoa[0].GetValue<string>('nome', '');
      edtDocumento.Text := JSONArrayPessoa[0].GetValue<string>('documento', '');
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

procedure TfrmPessoaCadastro.IniciarTela(AID_PESSOA: Integer);
begin
  FID_PESSOA := AID_PESSOA;
  if FID_PESSOA > 0 then
    CarregarPessoa;
end;

procedure TfrmPessoaCadastro.pnlSalvarClick(Sender: TObject);
begin
  if FID_PESSOA > 0 then
    AtualizarPessoa
  else
    CadastrarPessoa;

  Close;
end;

end.
