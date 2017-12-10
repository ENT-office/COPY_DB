object Form1: TForm1
  Left = 351
  Top = 310
  BorderStyle = bsDialog
  Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 347
  ClientWidth = 768
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object ps: TcxProgressBar
    Left = 0
    Top = 323
    Align = alBottom
    TabOrder = 0
    Width = 768
  end
  object cxLabel1: TcxLabel
    Left = 0
    Top = 303
    Align = alBottom
  end
  object cxButton1: TcxButton
    Left = 136
    Top = 80
    Width = 249
    Height = 57
    Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077
    TabOrder = 2
    OnClick = cxButton1Click
  end
  object cxLabel2: TcxLabel
    Left = 24
    Top = 16
    Caption = #1057#1090#1072#1088#1072#1103' '#1073#1072#1079#1072
  end
  object dbPath_old: TcxButtonEdit
    Left = 136
    Top = 16
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Properties.OnButtonClick = dbPath_oldPropertiesButtonClick
    TabOrder = 4
    Text = 'C:\project\'#1050#1054#1055#1048#1056#1054#1042#1040#1053#1048#1045' '#1041#1040#1047#1067'\DB\CBASE.FDB'
    Width = 609
  end
  object cxLabel3: TcxLabel
    Left = 24
    Top = 48
    Caption = #1053#1086#1074#1072#1103' '#1073#1072#1079#1072
  end
  object dbPath_NEW: TcxButtonEdit
    Left = 136
    Top = 48
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Properties.OnButtonClick = dbPath_NEWPropertiesButtonClick
    TabOrder = 6
    Text = 'C:\Program Files (x86)\ENT\Server\DB\CBASE.FDB'
    Width = 609
  end
  object FDB_data_old: TIBDatabase
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    Left = 616
    Top = 160
  end
  object TB_data_old: TIBTransaction
    Active = False
    DefaultDatabase = FDB_data_old
    AutoStopAction = saNone
    Left = 648
    Top = 160
  end
  object q_data_Old: TIBQuery
    Database = FDB_data_old
    Transaction = TB_data_old
    BufferChunks = 1000
    CachedUpdates = False
    Left = 680
    Top = 160
  end
  object FDB_photo_old: TIBDatabase
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    Left = 616
    Top = 192
  end
  object TB_photo_old: TIBTransaction
    Active = False
    DefaultDatabase = FDB_photo_old
    AutoStopAction = saNone
    Left = 648
    Top = 192
  end
  object q_photo_Old: TIBQuery
    Database = FDB_photo_old
    Transaction = TB_photo_old
    BufferChunks = 1000
    CachedUpdates = False
    Left = 680
    Top = 192
  end
  object FDB_data_NEW: TIBDatabase
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    Left = 616
    Top = 240
  end
  object TB_data_NEW: TIBTransaction
    Active = False
    DefaultDatabase = FDB_data_NEW
    AutoStopAction = saNone
    Left = 648
    Top = 240
  end
  object q_data_NEW: TIBQuery
    Database = FDB_data_NEW
    Transaction = TB_data_NEW
    BufferChunks = 1000
    CachedUpdates = False
    Left = 680
    Top = 240
  end
  object FDB_photo_NEW: TIBDatabase
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    Left = 616
    Top = 272
  end
  object TB_photo_NEW: TIBTransaction
    Active = False
    DefaultDatabase = FDB_photo_NEW
    AutoStopAction = saNone
    Left = 648
    Top = 272
  end
  object IBTblImage: TIBTable
    Database = FDB_photo_NEW
    Transaction = TB_photo_NEW
    BufferChunks = 1000
    CachedUpdates = False
    TableName = 'UPH'
    Left = 680
    Top = 272
  end
  object q_photo_NEW: TIBQuery
    Database = FDB_photo_NEW
    Transaction = TB_photo_NEW
    BufferChunks = 1000
    CachedUpdates = False
    Left = 712
    Top = 272
  end
  object OpenDialog1: TOpenDialog
    Left = 584
    Top = 160
  end
end
