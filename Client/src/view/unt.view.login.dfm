object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'frmLogin'
  ClientHeight = 171
  ClientWidth = 484
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object pnlDados: TPanel
    AlignWithMargins = True
    Left = 15
    Top = 3
    Width = 454
    Height = 125
    Margins.Left = 15
    Margins.Right = 15
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    ExplicitLeft = 0
    ExplicitWidth = 469
    object Label1: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 74
      Width = 448
      Height = 15
      Margins.Top = 15
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Senha'
      ExplicitWidth = 32
    end
    object Label2: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 15
      Width = 448
      Height = 15
      Margins.Top = 15
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Email'
      ExplicitWidth = 29
    end
    object edtSenha: TEdit
      AlignWithMargins = True
      Left = 3
      Top = 92
      Width = 448
      Height = 23
      Align = alTop
      PasswordChar = '*'
      TabOrder = 1
    end
    object edtEmail: TEdit
      AlignWithMargins = True
      Left = 3
      Top = 33
      Width = 448
      Height = 23
      Align = alTop
      TabOrder = 0
      ExplicitWidth = 463
    end
  end
  object pnlButton: TPanel
    Left = 0
    Top = 131
    Width = 484
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object pnlLogin: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 120
      Height = 34
      Cursor = crHandPoint
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Login (F2)'
      Color = 5540912
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      StyleElements = []
      OnClick = pnlLoginClick
    end
    object pnlNovoCadastro: TPanel
      AlignWithMargins = True
      Left = 361
      Top = 3
      Width = 120
      Height = 34
      Cursor = crHandPoint
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Novo Cadastro (F3)'
      Color = 5540912
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      StyleElements = []
      OnClick = pnlNovoCadastroClick
      ExplicitLeft = 3
    end
  end
end
