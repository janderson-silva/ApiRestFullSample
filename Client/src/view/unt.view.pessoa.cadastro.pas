unit unt.view.pessoa.cadastro;

interface

uses
  Base64.util,
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
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Imaging.pngimage,
  Vcl.StdCtrls,
  Winapi.Messages,
  Winapi.Windows,
  interfaces.pessoa,
  model.pessoa,
  interfaces.pessoa_foto_base64,
  model.pessoa_foto_base64,
  interfaces.pessoa_foto_binary,
  model.pessoa_foto_binary;

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
    FDMemTablePessoa: TFDMemTable;
    FDMemTablePessoaid: TLargeintField;
    FDMemTablePessoaativo: TBooleanField;
    FDMemTablePessoanome: TStringField;
    FDMemTablePessoadocumento: TStringField;
    OpenImage: TOpenDialog;
    procedure pnlSalvarClick(Sender: TObject);
    procedure pnlAddFotoBase64Click(Sender: TObject);
    procedure pnlAddFotoBinaryClick(Sender: TObject);
    procedure imgFotoBase64DblClick(Sender: TObject);
    procedure imgFotoBinaryDblClick(Sender: TObject);
    procedure pnlCancelarClick(Sender: TObject);
  private
    { Private declarations }
    var FID_PESSOA: Integer;

    //pessoa
    procedure CarregarPessoa;
    procedure ThreadPessoaTerminate(Sender: TObject);
    procedure CadastrarPessoa;
    procedure AtualizarPessoa;

    //foto Base64
    procedure CadastrarFotoBase64;

    //foto Base64
    procedure CadastrarFotoBinary;
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

procedure TfrmPessoaCadastro.CadastrarFotoBase64;
var
  FPessoaFotoBase64: iPessoa_foto_base64;
begin
  if FID_PESSOA = 0 then
    raise Exception.Create('O cadastro de pessoa deve ser salvo antes de enviar a foto');

  FPessoaFotoBase64 := TPessoa_foto_base64.New;
  try
    FPessoaFotoBase64
        .id_pessoa(FID_PESSOA)
        .foto_base64(BitmapToBase64(imgFotoBase64.Picture))
      .Insert(True);
  except on E : Exception do
    begin
      raise Exception.Create(E.Message);
      Exit;
    end;
  end;
end;

procedure TfrmPessoaCadastro.CadastrarFotoBinary;
var
  LStream: TMemoryStream;
  FPessoaFotoBinary: iPessoa_foto_binary;
begin
  if FID_PESSOA = 0 then
    raise Exception.Create('O cadastro de pessoa deve ser salvo antes de enviar a foto');

  LStream := TMemoryStream.Create;
  try
    imgFotoBinary.Picture.SaveToStream(LStream);

    FPessoaFotoBinary := TPessoa_foto_binary.New;
    try
      FPessoaFotoBinary
          .id_pessoa(FID_PESSOA)
          .foto_binary(LStream)
          .nome_arquivo(ExtractFileName(imgFotoBinary.Hint))
          .extensao(ExtractFileExt(imgFotoBinary.Hint))
        .Insert(True);
    except on E : Exception do
      begin
        raise Exception.Create(E.Message);
        Exit;
      end;
    end;
  finally
    LStream.Free;
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
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(procedure
  begin

    FPessoa := TPessoa.New;
    try

      TThread.Synchronize(nil, procedure
      begin

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

procedure TfrmPessoaCadastro.imgFotoBase64DblClick(Sender: TObject);
begin
  if OpenImage.Execute then
  begin
    imgFotoBase64.Picture.LoadFromFile(OpenImage.FileName);
  end;
end;

procedure TfrmPessoaCadastro.imgFotoBinaryDblClick(Sender: TObject);
begin
  if OpenImage.Execute then
  begin
    imgFotoBinary.Picture.LoadFromFile(OpenImage.FileName);
    imgFotoBinary.Hint := OpenImage.FileName;
  end;
end;

procedure TfrmPessoaCadastro.IniciarTela(AID_PESSOA: Integer);
begin
  FID_PESSOA := AID_PESSOA;
  if FID_PESSOA > 0 then
    CarregarPessoa;
end;

procedure TfrmPessoaCadastro.pnlAddFotoBase64Click(Sender: TObject);
begin
  CadastrarFotoBase64;
end;

procedure TfrmPessoaCadastro.pnlAddFotoBinaryClick(Sender: TObject);
begin
  CadastrarFotoBinary;
end;

procedure TfrmPessoaCadastro.pnlCancelarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja mesmo cancelar?','Confirmação',MB_YESNO+MB_ICONQUESTION) = ID_YES then
    Close;
end;

procedure TfrmPessoaCadastro.pnlSalvarClick(Sender: TObject);
begin
  if FID_PESSOA > 0 then
    AtualizarPessoa
  else
    CadastrarPessoa;

  Close;
end;

procedure TfrmPessoaCadastro.ThreadPessoaTerminate(Sender: TObject);
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
