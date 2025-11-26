object DataModule3: TDataModule3
  Height = 750
  Width = 1000
  PixelsPerInch = 120
  object conDatabase: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=C:\Us' +
      'ers\chris\Documents\Embarcadero\Studio\Projects\Database2.mdb;Mo' +
      'de=ReadWrite;Persist Security Info=False;Jet OLEDB:System databa' +
      'se="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Password="";' +
      'Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;Jet OL' +
      'EDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transactions' +
      '=1;Jet OLEDB:New Database Password="";Jet OLEDB:Create System Da' +
      'tabase=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Don'#39't Co' +
      'py Locale on Compact=False;Jet OLEDB:Compact Without Replica Rep' +
      'air=False;Jet OLEDB:SFP=False'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 40
    Top = 344
  end
  object tbl_products: TADOTable
    Active = True
    Connection = conDatabase
    CursorType = ctStatic
    TableName = 'tbl_products'
    Left = 160
    Top = 376
  end
  object tbl_suppliers: TADOTable
    Active = True
    Connection = conDatabase
    CursorType = ctStatic
    TableName = 'tbl_suppliers'
    Left = 160
    Top = 272
  end
  object ds_suppliers: TDataSource
    DataSet = tbl_suppliers
    Left = 280
    Top = 280
  end
  object ds_products: TDataSource
    DataSet = tbl_products
    Left = 280
    Top = 376
  end
end
