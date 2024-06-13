unit UFrmProjRegister;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite, FireDAC.DApt, FireDAC.Stan.Param,
  Data.DB, FireDAC.Comp.Client, FMX.Edit, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  UFunctions, FMX.ListBox;

type
  TFrmProjRegister = class(TForm)
    btnSave: TButton;
    btnCancel: TButton;
    FDConnection: TFDConnection;
    FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
    Label1: TLabel;
    Label2: TLabel;
    edtTitle: TEdit;
    memoBodyDescription: TMemo;
    ComboBox1: TComboBox;
    Label3: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function IsFieldsValid: Boolean;
  public
    { Public declarations }
      ProjectIdSelected: integer;
  end;

var
  FrmProjRegister: TFrmProjRegister;

implementation

{$R *.fmx}

procedure TFrmProjRegister.btnCancelClick(Sender: TObject);
begin
  if ProjectIdSelected > 0 then
    ShowMessage('Update')
  else
    ShowMessage('Insert');
  Close;
end;

procedure TFrmProjRegister.btnSaveClick(Sender: TObject);
var
  query: TFDQuery;
  title: string;
  status: string;
  body: string;
begin
  edtTitle.Text            := DeleteRepeatedSpaces(edtTitle.Text);
  memoBodyDescription.Text := DeleteRepeatedSpaces(memoBodyDescription.Text);


  if not IsFieldsValid then
     Exit;


  status := 'EA';
  title  := edtTitle.Text;
  body   := memoBodyDescription.Text;


  /// ADD NEW PROJECT

  query := TFDQuery.Create(nil);
  try
    with query do
    begin
      Connection := FDConnection;
      SQL.Text   := 'INSERT INTO Projetos (Titulo, Corpo, Status) VALUES (:Titulo, :Corpo, :Status)';
      Params.ParamByName('Titulo').AsString := title;
      Params.ParamByName('Corpo').AsString  := body;
      Params.ParamByName('Status').AsString := status;
      ExecSQL;
    end;
  finally
    query.Free;
  end;
  
  
  ShowMessage('Projeto cadastrado com sucesso!');

  
  Close;
end;

procedure TFrmProjRegister.FormCreate(Sender: TObject);
begin
  /// CONNECTION DATABASE SQLITE

  FDConnection.DriverName                := 'SQLITE';
  FDConnection.Params.Values['Database'] := 'D:\projetos\delphi\ProjectOne\Database\projectone.db';
  try
    FDConnection.Open;
  except on E: EDatabaseError do
    ShowMessage('Error: ' + E.Message)
  end;
end;

function TFrmProjRegister.IsFieldsValid: Boolean;
begin
  Result := True;  

  
  if edtTitle.Text = '' then
  begin
    ShowMessage('O campo titulo do projeto é obrigatorio!');
    Result := False;
  end;  
  if memoBodyDescription.Text = '' then
  begin
    ShowMessage('O Campo corpo ou descrição do projeto é obrigatório!');
    Result := False;
  end;  

  
  if not ((Length(edtTitle.Text) >= 3) and (Length(edtTitle.Text) <= 100)) then
  begin
    ShowMessage('Informe um valor entre 3 a 100 caracteres para o campo título!');
    Result := False;
  end;
  if not ((Length(memoBodyDescription.Text) >= 15) and (Length(memoBodyDescription.Text) <= 5000)) then
  begin
    ShowMessage('Informe um valor entre 15 a 5000 caracteres para campo corpo ou descrição do projeto!');
    Result := False;
  end;
end;

end.
