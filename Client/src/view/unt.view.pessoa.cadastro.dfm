object frmPessoaCadastro: TfrmPessoaCadastro
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'frmPessoaCadastro'
  ClientHeight = 315
  ClientWidth = 826
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object pnlButton: TPanel
    Left = 0
    Top = 275
    Width = 826
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    ExplicitLeft = -345
    ExplicitTop = 401
    ExplicitWidth = 969
    object pnlSalvar: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 120
      Height = 34
      Cursor = crHandPoint
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Salvar (F2)'
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
      OnClick = pnlSalvarClick
    end
    object pnlCancelar: TPanel
      AlignWithMargins = True
      Left = 129
      Top = 3
      Width = 120
      Height = 34
      Cursor = crHandPoint
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Cancelar (Esc)'
      Color = 923248
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      StyleElements = []
    end
  end
  object pnlDados: TPanel
    Left = 420
    Top = 0
    Width = 406
    Height = 275
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    ExplicitLeft = 213
    ExplicitTop = -3
    ExplicitWidth = 414
    ExplicitHeight = 516
    object Label1: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 74
      Width = 400
      Height = 15
      Margins.Top = 15
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Documento'
      ExplicitLeft = 0
      ExplicitTop = 38
      ExplicitWidth = 63
    end
    object Label2: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 15
      Width = 400
      Height = 15
      Margins.Top = 15
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Nome'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 33
    end
    object edtDocumento: TEdit
      AlignWithMargins = True
      Left = 3
      Top = 92
      Width = 400
      Height = 23
      Align = alTop
      TabOrder = 1
      ExplicitLeft = 80
      ExplicitTop = 56
      ExplicitWidth = 121
    end
    object edtNome: TEdit
      AlignWithMargins = True
      Left = 3
      Top = 33
      Width = 400
      Height = 23
      Align = alTop
      TabOrder = 0
      ExplicitLeft = 80
      ExplicitTop = 56
      ExplicitWidth = 121
    end
    object chkAtivo: TCheckBox
      AlignWithMargins = True
      Left = 3
      Top = 133
      Width = 400
      Height = 17
      Margins.Top = 15
      Align = alTop
      Caption = 'Ativo'
      TabOrder = 2
      ExplicitLeft = 40
      ExplicitTop = 96
      ExplicitWidth = 97
    end
  end
  object pnlLeftFoto: TPanel
    AlignWithMargins = True
    Left = 10
    Top = 3
    Width = 185
    Height = 269
    Margins.Left = 10
    Margins.Right = 15
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    ExplicitHeight = 515
    object pnlFotoBase64: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 179
      Height = 250
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object pnlFotoBase64TImage: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 1
        Width = 179
        Height = 184
        Margins.Left = 0
        Margins.Top = 1
        Margins.Right = 0
        Margins.Bottom = 1
        Align = alClient
        BevelInner = bvLowered
        ParentColor = True
        TabOrder = 0
        ExplicitHeight = 171
        object imgFotoBase64: TImage
          Left = 2
          Top = 2
          Width = 175
          Height = 180
          Align = alClient
          Center = True
          IncrementalDisplay = True
          Proportional = True
          ExplicitLeft = 4
          ExplicitTop = 4
          ExplicitHeight = 167
        end
      end
      object pnlAddFotoBase64: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 187
        Width = 179
        Height = 30
        Cursor = crHandPoint
        Margins.Left = 0
        Margins.Top = 1
        Margins.Right = 0
        Margins.Bottom = 1
        Align = alBottom
        BevelInner = bvLowered
        ParentColor = True
        TabOrder = 1
        ExplicitTop = 9
        object imgAddFotoBase64: TImage
          AlignWithMargins = True
          Left = 12
          Top = 3
          Width = 22
          Height = 24
          Cursor = crHandPoint
          Margins.Left = 10
          Margins.Top = 1
          Margins.Right = 1
          Margins.Bottom = 1
          Align = alLeft
          Center = True
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000160000
            00160806000000C4B46C3B000000097048597300000B1300000B1301009A9C18
            000001464944415478DADDD52F4803511CC0F137FF1485A1491071C9C1308AA8
            28FE63C121B3981616149351ABE01FC4A406B3413438AB329C884510D1663059
            340816051111C4E0F7B8DF83C7F1DE8437AEF8834F79DBBEF77677BB25544C93
            8833DC8253347A362A58B2855338C4A447348D15E45CE1030C1BEBF568C28725
            D68B01EC20836D6C601CABD5C241F0483E3484974878133368439784E770830E
            57B815271894D7EF308277235C8766F9367AC7C1A978420FF2D837C3059CA13B
            B2C34B4CE0CB586BC08F25DC876B8CEAF0850AEF8A4EC7453AC6B4C4B6645763
            4846C229D94851871FFFB8FA9FE89773BB206B0F98C7A26F38D86516534654CF
            1B6E6B099F2BCBBD2A53A9E554549B7F140EEEC9A2F27F08DDE3CA1636A7845D
            CF03ECA9F0276D0D2FA3DD33FC8C355758CFACBCE1D5E30065145CE175153E1F
            7CE61BB958FF9A62995F085C569D890BC5420000000049454E44AE426082}
          ExplicitLeft = 5
          ExplicitTop = 5
          ExplicitHeight = 22
        end
        object lblAddFotoBase64: TLabel
          AlignWithMargins = True
          Left = 40
          Top = 3
          Width = 127
          Height = 24
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 1
          Margins.Right = 10
          Margins.Bottom = 1
          Align = alClient
          Caption = 'Enviar Arquivo Base64'
          Layout = tlCenter
          ExplicitWidth = 116
          ExplicitHeight = 15
        end
      end
      object pnlDelFotoBase64: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 219
        Width = 179
        Height = 30
        Cursor = crHandPoint
        Margins.Left = 0
        Margins.Top = 1
        Margins.Right = 0
        Margins.Bottom = 1
        Align = alBottom
        BevelInner = bvLowered
        ParentColor = True
        TabOrder = 2
        ExplicitTop = 65
        object imgDelFotoBase64: TImage
          AlignWithMargins = True
          Left = 12
          Top = 3
          Width = 20
          Height = 24
          Cursor = crHandPoint
          Margins.Left = 10
          Margins.Top = 1
          Margins.Right = 1
          Margins.Bottom = 1
          Align = alLeft
          Center = True
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000160000
            00160806000000C4B46C3B000000097048597300000B1300000B1301009A9C18
            000001684944415478DAD5D54D2804611CC7F167CBCB8503E2E260C981A29094
            94D2E6E0C04188943850EEC485525B0E8A72DEA21407E2E24029251CA41C10F2
            12961C44282289EFD333DB4E9A19CDB343F9D7A7A9679ADFEE33CFFF79C6277E
            A97CFF36D88F348F32EF701E099E40BB47C193E8F8D3E05734A31C7D5E065F23
            1B6558770838438EDB577122D462A6D884AEA10EDBC87513EC540F28C2054AB1
            89F858823FD08A453C9BC68730E826F8125DC8C7188218B0F8C124DC9BFEB56D
            F02742E8C113FA518F0ABCDBCCA6050508E0C02E780E8DA68764E83E8EBE85C5
            A11B6DC842183358C0A9557013667F78DF32741EB516F7565163151C7698B2AC
            29A1CE83713CE2067942F57532D2E55AE8B45B2546856AB543A176688331CB15
            63FC582738037BC65556A7508B1D0997F5A6736CEE08B5E38A8DE997A01ACBD8
            40A11CD73DE8652B8EE0564477E02E529189A06E7002965065716F4B8EC7F269
            4A44AF88F6F115A6318C972FDC9E5CD62F0F9FDD0000000049454E44AE426082}
          ExplicitLeft = 2
          ExplicitTop = 2
          ExplicitHeight = 20
        end
        object lblDelFotoBase64: TLabel
          AlignWithMargins = True
          Left = 38
          Top = 3
          Width = 129
          Height = 24
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 1
          Margins.Right = 10
          Margins.Bottom = 1
          Align = alClient
          Caption = 'Remover Foto'
          Layout = tlCenter
          ExplicitWidth = 74
          ExplicitHeight = 15
        end
      end
    end
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 220
    Top = 3
    Width = 185
    Height = 269
    Margins.Left = 10
    Margins.Right = 15
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 3
    ExplicitLeft = 18
    ExplicitTop = 11
    ExplicitHeight = 510
    object pnlFotoBinary: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 179
      Height = 250
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      Visible = False
      ExplicitLeft = 6
      ExplicitTop = 11
      object pnlFotoBinaryTImage: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 1
        Width = 179
        Height = 184
        Margins.Left = 0
        Margins.Top = 1
        Margins.Right = 0
        Margins.Bottom = 1
        Align = alClient
        BevelInner = bvLowered
        ParentColor = True
        TabOrder = 0
        object imgFotoBinary: TImage
          Left = 2
          Top = 2
          Width = 175
          Height = 180
          Align = alClient
          Center = True
          IncrementalDisplay = True
          Proportional = True
          ExplicitLeft = 4
          ExplicitTop = 4
          ExplicitHeight = 196
        end
      end
      object pnlAddFotoBinary: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 187
        Width = 179
        Height = 30
        Cursor = crHandPoint
        Margins.Left = 0
        Margins.Top = 1
        Margins.Right = 0
        Margins.Bottom = 1
        Align = alBottom
        BevelInner = bvLowered
        ParentColor = True
        TabOrder = 1
        object imgAddFotoBinary: TImage
          AlignWithMargins = True
          Left = 12
          Top = 3
          Width = 22
          Height = 24
          Cursor = crHandPoint
          Margins.Left = 10
          Margins.Top = 1
          Margins.Right = 1
          Margins.Bottom = 1
          Align = alLeft
          Center = True
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000160000
            00160806000000C4B46C3B000000097048597300000B1300000B1301009A9C18
            000001464944415478DADDD52F4803511CC0F137FF1485A1491071C9C1308AA8
            28FE63C121B3981616149351ABE01FC4A406B3413438AB329C884510D1663059
            340816051111C4E0F7B8DF83C7F1DE8437AEF8834F79DBBEF77677BB25544C93
            8833DC8253347A362A58B2855338C4A447348D15E45CE1030C1BEBF568C28725
            D68B01EC20836D6C601CABD5C241F0483E3484974878133368439784E770830E
            57B815271894D7EF308277235C8766F9367AC7C1A978420FF2D837C3059CA13B
            B2C34B4CE0CB586BC08F25DC876B8CEAF0850AEF8A4EC7453AC6B4C4B6645763
            4846C229D94851871FFFB8FA9FE89773BB206B0F98C7A26F38D86516534654CF
            1B6E6B099F2BCBBD2A53A9E554549B7F140EEEC9A2F27F08DDE3CA1636A7845D
            CF03ECA9F0276D0D2FA3DD33FC8C355758CFACBCE1D5E30065145CE175153E1F
            7CE61BB958FF9A62995F085C569D890BC5420000000049454E44AE426082}
          ExplicitLeft = 5
          ExplicitTop = 5
          ExplicitHeight = 22
        end
        object lblAddFotoBinary: TLabel
          AlignWithMargins = True
          Left = 40
          Top = 3
          Width = 127
          Height = 24
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 1
          Margins.Right = 10
          Margins.Bottom = 1
          Align = alClient
          Caption = 'Enviar Arquivo Binary'
          Layout = tlCenter
          ExplicitWidth = 113
          ExplicitHeight = 15
        end
      end
      object pnlDelFotoBinary: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 219
        Width = 179
        Height = 30
        Cursor = crHandPoint
        Margins.Left = 0
        Margins.Top = 1
        Margins.Right = 0
        Margins.Bottom = 1
        Align = alBottom
        BevelInner = bvLowered
        ParentColor = True
        TabOrder = 2
        object imgDelFotoBinary: TImage
          AlignWithMargins = True
          Left = 12
          Top = 3
          Width = 20
          Height = 24
          Cursor = crHandPoint
          Margins.Left = 10
          Margins.Top = 1
          Margins.Right = 1
          Margins.Bottom = 1
          Align = alLeft
          Center = True
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000160000
            00160806000000C4B46C3B000000097048597300000B1300000B1301009A9C18
            000001684944415478DAD5D54D2804611CC7F167CBCB8503E2E260C981A29094
            94D2E6E0C04188943850EEC485525B0E8A72DEA21407E2E24029251CA41C10F2
            12961C44282289EFD333DB4E9A19CDB343F9D7A7A9679ADFEE33CFFF79C6277E
            A97CFF36D88F348F32EF701E099E40BB47C193E8F8D3E05734A31C7D5E065F23
            1B6558770838438EDB577122D462A6D884AEA10EDBC87513EC540F28C2054AB1
            89F858823FD08A453C9BC68730E826F8125DC8C7188218B0F8C124DC9BFEB56D
            F02742E8C113FA518F0ABCDBCCA6050508E0C02E780E8DA68764E83E8EBE85C5
            A11B6DC842183358C0A9557013667F78DF32741EB516F7565163151C7698B2AC
            29A1CE83713CE2067942F57532D2E55AE8B45B2546856AB543A176688331CB15
            63FC582738037BC65556A7508B1D0997F5A6736CEE08B5E38A8DE997A01ACBD8
            40A11CD73DE8652B8EE0564477E02E529189A06E7002965065716F4B8EC7F269
            4A44AF88F6F115A6318C972FDC9E5CD62F0F9FDD0000000049454E44AE426082}
          ExplicitLeft = 2
          ExplicitTop = 2
          ExplicitHeight = 20
        end
        object lblDelFotoBinary: TLabel
          AlignWithMargins = True
          Left = 38
          Top = 3
          Width = 129
          Height = 24
          Cursor = crHandPoint
          Margins.Left = 5
          Margins.Top = 1
          Margins.Right = 10
          Margins.Bottom = 1
          Align = alClient
          Caption = 'Remover Foto'
          Layout = tlCenter
          ExplicitWidth = 74
          ExplicitHeight = 15
        end
      end
    end
  end
  object FDMemTablePessoa: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 464
    Top = 176
    object FDMemTablePessoaid: TLargeintField
      FieldName = 'id'
    end
    object FDMemTablePessoaativo: TBooleanField
      FieldName = 'ativo'
    end
    object FDMemTablePessoanome: TStringField
      FieldName = 'nome'
      Size = 60
    end
    object FDMemTablePessoadocumento: TStringField
      FieldName = 'documento'
      Size = 60
    end
  end
end
