unit PatData;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, Vcl.Graphics;

type
  TDataModule3 = class(TDataModule)
    conDatabase: TADOConnection;
    tbl_products: TADOTable;
    tbl_suppliers: TADOTable;
    ds_suppliers: TDataSource;
    ds_products: TDataSource;
  public
    function CheckIfRecordExists(tbl: TADOTable; field:String; name:String) : boolean;
    function LoadProductImage(tbl: TADOTABLE) : TPicture;
  end;

var
  DataModule3: TDataModule3;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


function TDataModule3.CheckIfRecordExists(tbl: TADOTABLE; field:String; name:String) : boolean;
begin
  Result := false;
  tbl.First;
  while NOT tbl.Eof do
  begin
     if (tbl[field] = name) then
     begin
      Result := true;
      exit;
     end;
     tbl.Next;
   end;
end;

function TDataModule3.LoadProductImage(tbl: TADOTABLE) : TPicture;
var
  stream: TStream  ;
begin
  stream := ds_products.DataSet.CreateBlobStream(ds_Products.DataSet.FieldByName('Image'),bmRead)     ;
  Result := TPicture.Create();
  try
    Result.LoadFromStream(stream);
  finally
    stream.Free;
  end;
end;

end.
