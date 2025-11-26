program Project1;

uses
  Vcl.Forms,
  cristian in 'cristian.pas' {Form1},
  PatData in 'PatData.pas' {DataModule3: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModule3, DataModule3);
  Application.Run;
end.
