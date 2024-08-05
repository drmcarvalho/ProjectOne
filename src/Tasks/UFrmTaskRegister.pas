unit UFrmTaskRegister;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.ListBox,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, UFunctions, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, UConstants;

type
  TFrmNewTask = class(TForm)
    Label1: TLabel;
    edtTitle: TEdit;
    Label2: TLabel;
    cbRequirement: TComboBox;
    Label3: TLabel;
    cbProject: TComboBox;
    Label4: TLabel;
    memoDescription: TMemo;
    Label5: TLabel;
    cbStatus: TComboBox;
    FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
    FDConnection: TFDConnection;
    btnSave: TButton;
    btnCancel: TButton;
    procedure FillComboboxProject;
    procedure FillComboboxRequirement(const projectId: Integer);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cbProjectChange(Sender: TObject);
  private
    { Private declarations }
    function IsFieldsValid: Boolean;
  public
    { Public declarations }
  end;

var
  FrmNewTask: TFrmNewTask;

implementation

{$R *.fmx}

procedure TFrmNewTask.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmNewTask.btnSaveClick(Sender: TObject);
var
  query: TFDQuery;
  title: string;
  projectId: Integer;
  requerimentId: Integer;
  status: string;
  description: string;

begin
  edtTitle.Text         := DeleteRepeatedSpaces(edtTitle.Text);
  memoDescription.Text  := DeleteRepeatedSpaces(memoDescription.Text);


  if not IsFieldsValid then
    Exit;


  title         := edtTitle.Text;
  projectId     := StrToInt(cbProject.Items.KeyNames[cbProject.ItemIndex]);
  requerimentId := StrToInt(cbRequirement.Items.KeyNames[cbRequirement.ItemIndex]);
  status        := cbStatus.Items.KeyNames[cbStatus.ItemIndex];
  description   := memoDescription.Text;


  query := TFDQuery.Create(nil);
  try
    with query do
    begin
      Connection := FDConnection;
      SQL.Text := 'INSERT INTO Tarefas (ProjetoId, RequisitoId, Titulo, Descricao, Status) VALUES (:ProjetoId, :RequisitoId, :Titulo, :Descricao, :Status)';
      Params.ParamByName('ProjetoId').AsInteger   := projectId;
      Params.ParamByName('RequisitoId').AsInteger := requerimentId;
      Params.ParamByName('Titulo').AsString       := title;
      Params.ParamByName('Descricao').AsString    := description;
      Params.ParamByName('Status').AsString       := status;
      ExecSQL;
    end;
  finally
    query.Close;
    query.DisposeOf;
  end;


  ShowMessage('Tarefa foi salva com sucesso!');


  Close;
end;

procedure TFrmNewTask.cbProjectChange(Sender: TObject);
begin
  FillComboboxRequirement(StrToInt(cbProject.Items.KeyNames[cbProject.ItemIndex]));
end;

procedure TFrmNewTask.FormCreate(Sender: TObject);
begin
  /// CONNECTION TO DATABASE SQLITE

  FDConnection.DriverName                := cDBDriver;
  FDConnection.Params.Values['Database'] := PathOfExecutable + cSQLiteFile;
  try
    FDConnection.Open;
  except on E: EDatabaseError do
    ShowMessage('Error: ' + E.Message)
  end;


  cbStatus.Items.AddPair('AF', TaskStatusToSpellOut('AF'));
  cbStatus.Items.AddPair('F', TaskStatusToSpellOut('F'));
  cbStatus.Items.AddPair('FT', TaskStatusToSpellOut('FT'));
  cbStatus.Items.AddPair('T', TaskStatusToSpellOut('T'));
  cbStatus.Items.AddPair('C', TaskStatusToSpellOut('C'));
  cbStatus.ItemIndex := 0;


  FillComboboxProject;
end;

function TFrmNewTask.IsFieldsValid: Boolean;
begin
  Result := True;


  if edtTitle.Text = '' then
  begin
    ShowMessage('O campo titulo do requisito é obrigatorio!');
    Result := False;
  end;
  if cbProject.ItemIndex < 0 then
  begin
    ShowMessage('Selecione um projeto!');
    Result := False;
  end;
  if cbRequirement.ItemIndex < 0 then
  begin
    ShowMessage('Selecione um Requisito!');
    Result := False;
  end;
  if cbStatus.ItemIndex < 0 then
  begin
    ShowMessage('Selecione um Status!');
    Result := False;
  end;
  if not ((Length(edtTitle.Text) >= 3) and (Length(edtTitle.Text) <= 100)) then
  begin
    ShowMessage('Informe um valor entre 3 a 100 caracteres para o campo título!');
    Result := False;
  end;
end;

procedure TFrmNewTask.FillComboboxProject;
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

procedure TFrmNewTask.FillComboboxRequirement(const projectId: Integer);
var query: TFDQuery;
begin
  cbRequirement.Clear;
  

  query := TFDQuery.Create(nil);
  try
    with query do
    begin
      Connection := FDConnection;
      SQL.Clear;
      SQL.Text := 'SELECT Id, Titulo FROM Requisitos WHERE ProjetoId = :ProjetoId';
      Params.ParamByName('ProjetoId').AsInteger := projectId;
      Prepare;
      Open;
      

      if IsEmpty then
      begin
        cbRequirement.ItemIndex := -1;
      end
      else
      begin
        cbRequirement.ItemIndex := 0;      
      end;
      

      while not Eof do
      begin
        cbRequirement.Items.AddPair(FieldByName('Id').AsString, FieldByName('Titulo').AsString);
        Next;
      end;
    end;
  finally
    query.Close;
    query.DisposeOf;
  end;
end;

end.
