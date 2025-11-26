unit cristian;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, PatData, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, System.UITypes, Vcl.Samples.Spin, Vcl.NumberBox,
  Vcl.ComCtrls, Vcl.Imaging.jpeg;

type
  TForm1 = class(TForm)
    edtproductname: TEdit;
    lblproductname: TLabel;
    lblTitle: TLabel;
    btnSearch: TButton;
    pnlProduct: TPanel;
    btnDelete: TButton;
    lblproducttitle: TLabel;
    btnSell: TButton;
    btnBuy: TButton;
    seAmount: TSpinEdit;
    lblamount: TLabel;
    shpLine: TShape;
    seNewPrice: TSpinEdit;
    lblprice: TLabel;
    btnSetprice: TButton;
    lblExpire: TLabel;
    Shape1: TShape;
    nbVat: TNumberBox;
    lblVAT: TLabel;
    lblVATpercent: TLabel;
    lblAquired: TLabel;
    Shape2: TShape;
    lblStock: TLabel;
    lblMarketPrice: TLabel;
    lblsellprice: TLabel;
    pnlNotFound: TPanel;
    lblNotFoundTitle: TLabel;
    lbladdsupplier: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btnInsertProduct: TButton;
    edtNewSupplier: TEdit;
    edtNewProduct: TEdit;
    edtNewMarketPrice: TEdit;
    edtNewSellPrice: TEdit;
    nbVat2: TNumberBox;
    Label6: TLabel;
    Label7: TLabel;
    edtNewQuantity: TEdit;
    dtpNewExpire: TDateTimePicker;
    btnStockReport: TButton;
    imgNotfound: TImage;
    imgProduct: TImage;
    btnNewImage: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnSellClick(Sender: TObject);
    procedure DisplaySelectedProductInfo;
    procedure btnBuyClick(Sender: TObject);
    procedure btnSetpriceClick(Sender: TObject);
    procedure btnInsertProductClick(Sender: TObject);
    function IsStringOnlyNumber(str: String) : boolean;
    procedure btnDeleteClick(Sender: TObject);
    procedure btnNewImageClick(Sender: TObject);
    procedure btnStockReportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function SelectproductImg(Path: string): TPicture;
function PictureToVariant(pic: TPicture) : variant;
procedure SaveStringToTextFile(path:String; str:String);

const
  sPasskey:string = '123';
var
  Form1: TForm1;
  lblfound: TLabel;
  lblfound_exists: bool;
  arrCustomerNames: array of String;
  arrCustomerCredit: array of real;

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
var
  sPlace : String;
begin
  lblfound_exists := false;
  repeat
    if sPlace <> sPasskey then
    begin
      sPlace := inputbox('Password','Please enter your password',sPlace);
    end;

  until sPlace.Equals(sPassKey);

  if MessageDlg('Welcome back to the Snooopie ! Do you want to continue', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
  begin
    exit();
  end;


  //ReadCustomerCreditfile('Customer_Credit.txt');
end;

procedure TForm1.btnSellClick(Sender: TObject);
var
iamount: Integer;
begin
  if(seAmount.Value >  DataModule3.tbl_products['Quantity']) then
  begin
      MessageDlg('Cannot Sell more products than there is stock', mtError, [mbOk], 0);
      exit;
  end
  else if(seAmount.Value >= 0)  then
  begin
     DataModule3.tbl_products.Edit;
     DataModule3.tbl_products['Quantity'] := DataModule3.tbl_products['Quantity'] - seAmount.Value;
     DataModule3.tbl_products['Popularity'] := DataModule3.tbl_products['Popularity'] + seAmount.Value;
     DisplaySelectedProductInfo;
     DataModule3.tbl_products.Post;
  end
  else
  begin
    MessageDlg('Cannot Sell a negative amount of products', mtError, [mbOk], 0);
    exit;
  end;



end;

procedure TForm1.btnSetpriceClick(Sender: TObject);
begin
  if( SeNewPrice.Value <= (DataModule3.tbl_products['Market_price'] * (1+(nbVat.Value/100)))) then
  begin
    MessageDlg('Cannot sell a product for less than Market price + VAT', mtError, [mbOk], 0);
    exit;
  end
  else
  begin
    DataModule3.tbl_products.Edit;
    DataModule3.tbl_products['Sell_Price'] := SeNewPrice.Value;
    DisplaySelectedProductInfo;
    DataModule3.tbl_products.Post;
  end;
end;

procedure TForm1.btnStockReportClick(Sender: TObject);
var
  report: String;
  prevSupplier: String;
  iProductTotal : integer;
  rSoldTotal : real;
  rCostTotal : real;
begin
  report := 'Product Stock Report for : ' + DateToStr(Date()) + #13#10; //#13#10 creates line-break
  report := report + '__________________________________________________' + #13#10 +#13#10;
  DataModule3.tbl_products.First;
  DataModule3.tbl_products.Sort := 'Supplier ASC';    //Sort Function
  prevSupplier := 'THISISNOTAVALIDSUPPLIER1234567890)(*&^%$#@!';
  while (NOT(DataModule3.tbl_products.Eof)) do
  begin
    if (prevSupplier <> DataModule3.tbl_products['Supplier']) then
    begin
      //report := report + '--------------------------------------------------' + #13#10;
      report := report + 'Supplier : ' + DataModule3.tbl_products['Supplier'] + #13#10;
      prevSupplier := DataModule3.tbl_products['Supplier'];
    end;
    report := report + #9 + 'Product name :      ' + #9 + DataModule3.tbl_products['Product_name'] + #13#10;
    report := report + #9 + 'Quantity in stock : ' + #9 + IntToStr(DataModule3.tbl_products['Quantity']) + #13#10;
    report := report + #9 + 'Market Price :      ' + #9 + FloatToStrf(DataModule3.tbl_products['Market_price'],ffcurrency,10,2) + #13#10;
    report := report + #9 + 'Sell Price :        ' + #9 + FloatTostrf(DataModule3.tbl_products['Sell_Price'],ffcurrency,10,2) + #13#10;
    report := report + #9 + 'Aquisition Date :   ' + #9 + DatetoStr(DataModule3.tbl_products['Aquisition_Date']) + #13#10;
    report := report + #9 + 'Expiration Date :   ' + #9 + DateToStr(DataModule3.tbl_products['Expiration_Date']) + #13#10;
    report := report + #9 + 'Amount Sold :       ' + #9 + IntToStr(DataModule3.tbl_products['Popularity']) + #13#10 + #13#10;
    iProductTotal := iProductTotal + 1;
    rSoldTotal := rSoldTotal + (DataModule3.tbl_products['Popularity']*DataModule3.tbl_products['Sell_Price']);
    rCostTotal := rCostTotal + (DataModule3.tbl_products['Popularity']*DataModule3.tbl_products['Market_price']*1.15);

    DataModule3.tbl_products.Next;
  end;
  report := report + '__________________________________________________' + #13#10 +#13#10;
  report := report + 'Total Products on Menu : ' + inttostr(iProductTotal) + #13#10;
  report := report + 'Total gross income : ' + floattostrf(rSoldTotal,ffcurrency,10,2) + #13#10;
  report := report + 'Total Cost Incl. 15% VAT : ' + floattostrf(rCostTotal,ffcurrency,10,2) + #13#10;
  report := report + 'Total net income : ' + floattostrf(rSoldTotal-rCostTotal,ffcurrency,10,2) + #13#10;

  SaveStringToTextFile('report.txt',report);
  ShowMessage('Successfully Printed Stock Report');
end;

procedure TForm1.btnBuyClick(Sender: TObject);
var
  timedifference: TDateTime;
begin
  if(seAmount.Value < 0) then
  begin
    MessageDlg('Cannot buy a negative amount of products', mtError, [mbOk], 0);
    exit;
  end
  else
  begin
    DataModule3.tbl_products.Edit;
    DataModule3.tbl_products['Quantity'] := DataModule3.tbl_products['Quantity'] + seAmount.Value;
    timedifference := DataModule3.tbl_products['Expiration_Date']  - DataModule3.tbl_products['Aquisition_Date'];
    DataModule3.tbl_products['Aquisition_Date'] := Date();
    DataModule3.tbl_products['Expiration_Date'] := Date() + timedifference;
    DisplaySelectedProductInfo;
    DataModule3.tbl_products.Post;
  end;
end;

procedure TForm1.btnDeleteClick(Sender: TObject);
begin
  if MessageDlg('Are ypou sure you want to Delete ' + edtproductname.Text, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit()
  else
  begin
    DataModule3.ds_products.DataSet.Edit;
    DataModule3.ds_products.DataSet.Delete;
    pnlProduct.Visible := false;
    pnlProduct.Enabled := false;
    btnSearchClick(Sender);

  end;
end;

procedure TForm1.btnInsertProductClick(Sender: TObject);
var
fMarketPrice, fSellPrice: extended;
iQuantity: integer;
begin

  if DataModule3.CheckIfRecordExists(DataModule3.tbl_products,'Product_name',edtNewProduct.Text) then
  begin
    MessageDlg('This Product already exists', mtError, [mbOk], 0);
    exit;
  end;

  if dtpNewExpire.Date <= Date() then
  begin
    MessageDlg('Cannot buy expired products', mtError, [mbOk], 0);
    exit;
  end;

  try
    if Not IsStringOnlyNumber(edtNewQuantity.Text) then
    begin
      MessageDlg('Quantity contains illegal characters ( use \",\" not \".\")', mtError, [mbOk], 0);
      exit;
    end
    else
    begin
      iQuantity := strtoint(edtNewQuantity.Text);
    end;

    if Not IsStringOnlyNumber(edtNewMarketPrice.Text) then
    begin
      MessageDlg('Market Price contains illegal characters ( use \",\" not \".\")', mtError, [mbOk], 0);
      exit;
    end
    else
    begin
      TryStrToFloat(edtNewMarketPrice.Text,fMarketPrice);
    end;

    if Not IsStringOnlyNumber(edtNewMarketPrice.Text) then
    begin
      MessageDlg('Sell Price contains illegal characters ( use \",\" not \".\")', mtError, [mbOk], 0);
      exit;
    end
    else
    begin
      TryStrToFloat(edtNewSellPrice.Text,fSellPrice);
    end;

  except
    exit;
  end;

  if( fSellPrice <= (fMarketPrice * (1+(nbVat2.Value/100)))) then
  begin
    MessageDlg('Cannot sell a product for less than Market price + VAT', mtError, [mbOk], 0);   //displays info on corosponding panel
    exit;
  end ;

  DataModule3.tbl_products.Insert;
  DataModule3.tbl_products['Supplier'] := edtNewSupplier.Text;
  DataModule3.tbl_products['Product_name'] := edtNewProduct.Text;
  DataModule3.tbl_products['Quantity'] := strtoint(edtNewQuantity.Text);
  DataModule3.tbl_products['Market_price'] := strtofloat(edtNewMarketPrice.Text);
  DataModule3.tbl_products['Sell_Price'] := strtofloat(edtNewSellPrice.Text);
  DataModule3.tbl_products['Aquisition_Date'] := Date();
  DataModule3.tbl_products['Expiration_Date'] := dtpNewExpire.Date;
  DataModule3.tbl_products['Image'] := PictureToVariant(imgNotFound.Picture);
  DataModule3.tbl_products.Post;
  ShowMessage('Successfully added new product ! ' + edtNewProduct.Text);
  btnSearchClick(Sender);

end;

procedure TForm1.btnNewImageClick(Sender: TObject);
var
  ProductImage : TPicture;
begin
   ProductImage := SelectProductImg('.');
   imgNotFound.Picture := ProductImage;
end;

procedure TForm1.btnSearchClick(Sender: TObject);
var
 bfound: bool;
begin
  if(lblfound_exists = false) then
  begin
    lblfound := TLabel.Create(Form1);
    lblfound_exists := true;
    
    
  end
  else
  begin
    lblfound.Destroy;
    lblfound_exists := false;
    Form1.btnSearchClick(Form1);
  end;

  with lblfound do
    begin
      Parent := Form1;
      Name := 'lblfound';
      left := btnSearch.left + 110;
      top := btnSearch.Top + 5   ;
      width := 50;
      height := 15;
      Caption := 'undefined';
    end;

  if(edtproductname.Text = '') then
  begin
     lblfound.Caption := 'No product entered';
     lblfound.Font.Color := clblue;
  end;

  if DataModule3.CheckIfRecordExists(DataModule3.tbl_products, 'Product_name',edtproductname.Text) then  //says if Product exsists
  begin
    lblfound.Caption := 'Product Found !';
    lblfound.Font.Color := clgreen;
    pnlProduct.Visible := true;
    pnlProduct.Enabled := true;
    pnlNotFound.Visible := false;
    pnlNotFound.Enabled := false;
    lblproducttitle.Caption := 'Selected Product is ' + edtproductname.Text;
    seAmount.Value := 1;
    DisplaySelectedProductInfo();
    imgProduct.Visible := true;
    imgNotFound.Visible := false;
    
  end
  else
  begin
    lblfound.Caption := 'Product Not Found !';    //Says if product is there or not if Not you can add a new product
    lblfound.Font.Color := clred;
    pnlProduct.Visible := false;
    pnlProduct.Enabled := false;
    pnlNotFound.Visible := true;
    pnlNotFound.Enabled := true;
    lblNotFoundtitle.Caption := 'Do you want to add ' + edtproductname.Text + ' ?';
    edtNewProduct.Text := edtproductname.Text;
    imgProduct.Visible := false;
    imgNotFound.Visible := true;
    
  end;
end;


procedure TForm1.DisplaySelectedProductInfo;  //Display's selected product info by corosponding pannles
begin
    seNewPrice.Value := DataModule3.tbl_products['Sell_Price'];
    lblMarketPrice.Caption := 'Current Market Price is : ' + floattostrf(DataModule3.tbl_products['Market_price'],ffcurrency,10,2);
    lblsellprice.Caption := 'Current Sell Price is : ' + floattostrf(DataModule3.tbl_products['Sell_price'],ffcurrency,10,2);
    lblStock.Caption := 'Currenty have ' +  inttostr(DataModule3.tbl_products['Quantity']) + ' units in stock';
    lblExpire.Caption := 'Expire date : ' + DateTimetostr(DataModule3.tbl_products['Expiration_Date']);
    lblAquired.Caption := 'Aquired date : ' + DateTimetostr(DataModule3.tbl_products['Aquisition_Date']);
    imgProduct.Picture := DataModule3.LoadProductImage(DataModule3.tbl_products);
end;


function TForm1.IsStringOnlyNumber(str: String) : boolean;
var
icount:Integer;
begin
  Result := false;
  if(str = '') then
    exit
  else
  begin
     for Icount := 1 to Length(str) do
     begin
        if not (str[Icount] in ['0'..'9',',']) then
          exit;
     end;
  end;
  Result := True;
end;

function SelectproductImg(Path: string): TPicture;         //Display picture after clicking btn NewImage
  var
  opendialog: TopenDialog;
  begin
    opendialog := TopenDialog.Create(nil);
    opendialog.Title := 'Please Select an Image';
    openDialog.Filter := 'Text files (*.png)|*.jpeg|*.tiff|*.gif|*.bmp|*.WebP|*.PDF|*.pdf|*.ai|';
    opendialog.InitialDir :=  GetCurrentdir;
    opendialog.Options := [ofFileMustExist];
    if OpenDialog.Execute() then
    begin
      Result := TPicture.Create();
      Result.LoadFromFile(OpenDialog.FileName);
    end;
    opendialog.Free;
 end;

function PictureToVariant(pic: TPicture) : variant;  //Get Picture from file to display next to panel after clicking btnNewImage
var
  bytes: TBytes;
  stream : TMemoryStream;
begin
  if pic.Graphic = nil then
    Exit();

  stream := TMemoryStream.Create();
  try
    Pic.Graphic.SaveToStream(Stream);
    Stream.Position := 0;
    SetLength(Bytes, Stream.Size);
    Stream.Read(Bytes[0], Stream.Size);
    Result := Bytes;
  finally
    stream.Free;
  end;
end;


procedure SaveStringToTextFile(path:String; str:String);
var
  tf: TextFile;
begin
  AssignFile(tf,path);
  ReWrite(tf);
  Writeln(tf,str);
  closeFile(tf)
end;

end.

