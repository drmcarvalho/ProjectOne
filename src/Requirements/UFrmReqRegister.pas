unit UFrmReqRegister;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.ListBox,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.Client,
  UFunctions;

type
  TFrmReqRegister = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    cbStatus: TComboBox;
    edtTitle: TEdit;
    cbProject: TComboBox;
    cbTypeReq: TComboBox;
    memoDescription: TMemo;
    btnSave: TButton;
    btnCancel: TButton;
    FDConnection: TFDConnection;
    FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
    procedure FormCreate(Sender: TObject);
    procedure FillComboboxProjects;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmReqRegister: TFrmReqRegister;

implementation

{$R *.fmx}

procedure TFrmReqRegister.FormCreate(Sender: TObject);
begin
  /// CONNECTION TO DATABASE SQLITE

  FDConnection.DriverName                := 'SQLITE';
  FDConnection.Params.Values['Database'] := 'D:\projetos\delphi\ProjectOne\Database\projectone.db';
  try
    FDConnection.Open;
  except on E: EDatabaseError do
    ShowMessage('Error: ' + E.Message)
  end;


  cbTypeReq.Items.AddPair('RF', RequerimentTypeToSpellOut('RF'));
  cbTypeReq.Items.AddPair('RNF', RequerimentTypeToSpellOut('RNF'));
  cbTypeReq.ItemIndex := 0;


  cbStatus.Items.AddPair('EA', RequerimentStatusToSpellOut('EA'));
  cbStatus.Items.AddPair('C', RequerimentStatusToSpellOut('C'));
  cbStatus.Items.AddPair('I', RequerimentStatusToSpellOut('I'));
  cbStatus.Items.AddPair('EAA', RequerimentStatusToSpellOut('EAA'));
  cbStatus.Items.AddPair('B', RequerimentStatusToSpellOut('B'));
  cbStatus.ItemIndex := 0;


  FillComboboxProjects;
end;

procedure TFrmReqRegister.FillComboboxProjects;
var query: TFDQuery;
begin
  query := TFDQuery.Create(nil);
  try
    with query do
    begin
      Connection := FDConnection;
      SQL.Clear;
      SQL.Text := 'SELECT Id, Titulo FROM Projetos';
      Open;


      while not Eof do
      begin
        cbProject.Items.AddPair(FieldByName('Id').AsString, FieldByName('Titulo').AsString);
        Next;
      end;
    end;
  finally
    query.Close;
    query.DisposeOf;
  end;
end;

end.
