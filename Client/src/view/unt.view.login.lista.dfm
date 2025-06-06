object frmLoginLista: TfrmLoginLista
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSingle
  Caption = 'frmLoginLista'
  ClientHeight = 441
  ClientWidth = 964
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object pnlButton: TPanel
    Left = 0
    Top = 401
    Width = 964
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object pnlNovo: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 120
      Height = 34
      Cursor = crHandPoint
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Novo (F2)'
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
      OnClick = pnlNovoClick
    end
    object pnlEditar: TPanel
      AlignWithMargins = True
      Left = 129
      Top = 3
      Width = 120
      Height = 34
      Cursor = crHandPoint
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Editar (F3)'
      Color = 2401504
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      StyleElements = []
      OnClick = pnlEditarClick
    end
    object pnlExcluir: TPanel
      AlignWithMargins = True
      Left = 255
      Top = 3
      Width = 120
      Height = 34
      Cursor = crHandPoint
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Excluir (Del)'
      Color = 923248
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      StyleElements = []
      OnClick = pnlExcluirClick
    end
  end
  object pnlFiltro: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 958
    Height = 75
    Align = alTop
    BevelInner = bvLowered
    ParentColor = True
    TabOrder = 1
    object pnlFiltrar: TPanel
      AlignWithMargins = True
      Left = 17
      Top = 17
      Width = 120
      Height = 41
      Cursor = crHandPoint
      Margins.Left = 15
      Margins.Top = 15
      Margins.Right = 10
      Margins.Bottom = 15
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Filtrar (F5)'
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
      OnClick = pnlFiltrarClick
    end
  end
  object DBGridLogin: TDBGrid
    AlignWithMargins = True
    Left = 3
    Top = 84
    Width = 958
    Height = 314
    Align = alClient
    DataSource = dsLogin
    DrawingStyle = gdsClassic
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object FDMemTableLogin: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 160
    Top = 128
    object FDMemTableLoginid: TLargeintField
      FieldName = 'id'
    end
    object FDMemTableLoginativo: TBooleanField
      FieldName = 'ativo'
    end
    object FDMemTableLoginemail: TStringField
      FieldName = 'email'
      Size = 250
    end
    object FDMemTableLoginsenha: TStringField
      FieldName = 'senha'
      Size = 250
    end
  end
  object dsLogin: TDataSource
    DataSet = FDMemTableLogin
    Left = 160
    Top = 184
  end
end
