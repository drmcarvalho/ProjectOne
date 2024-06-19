unit UFrmReqRegister;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.DialogService,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.ListBox,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.Client,
  UFunctions, UConstants;

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
    chkbActive: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FillComboboxProjects;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function IsFieldsValid: Boolean;
    procedure FindRequerimentAndFillFields;
  public
    { Public declarations }
    RequerimentIdSelected: Integer;
  end;

var
  FrmReqRegister: TFrmReqRegister;

implementation

{$R *.fmx}

procedure TFrmReqRegister.FormCreate(Sender: TObject);
begin
  /// CONNECTION TO DATABASE SQLITE

  FDConnection.DriverName                := cDBDriver;
  FDConnection.Params.Values['Database'] := PathOfExecutable + cSQLiteFile;
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

procedure TFrmReqRegister.FormShow(Sender: TObject);
begin
  if RequerimentIdSelected > 0 then
  begin
    FindRequerimentAndFillFields;
  end;
end;

procedure TFrmReqRegister.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmReqRegister.btnSaveClick(Sender: TObject);
var
  query: TFDQuery;
  title: string;
  description: string;
  typeRequeriment: string;
  projectId: integer;
  status: string;
  vActive: integer;
  procedure CancelTasksOfRequeriment(const requerimentId: Integer);
  var query: TFDQuery;
  begin
    query := TFDQuery.Create(nil);
    try
      with query do begin
        Connection := FDConnection;
        SQL.Clear;
        SQL.Text := 'UPDATE Tarefas SET Status = "C" WHERE RequisitoId = :RequisitoId';
        Params.ParamByName('RequisitoId').AsInteger := requerimentId;
        ExecSQL;
      end;
    finally
      query.Close;
      query.DisposeOf;
    end;
  end;
  function HasTask(const requerimentId: integer): boolean;
  var query: TFDQuery;
  begin
    query := TFDQuery.Create(nil);
    try
      with query do
      begin
        Connection := FDConnection;
        SQL.Clear;
        SQL.Text := 'SELECT COUNT(*) AS "Count" FROM Tarefas WHERE RequisitoId = :RequisitoId';
        Params.ParamByName('RequisitoId').AsInteger := RequerimentIdSelected;
        Prepare;
        Open;
        First;
        Result := FieldByName('Count').AsInteger > 0;
      end;
    finally
      query.Close;
      query.DisposeOf;
    end;
  end;
begin
  edtTitle.Text        := DeleteRepeatedSpaces(edtTitle.Text);
  memoDescription.Text := DeleteRepeatedSpaces(memoDescription.Text);


  if not IsFieldsValid then
    Exit;


  if (not chkbActive.IsChecked) and (RequerimentIdSelected > 0) then
  begin
    if HasTask(RequerimentIdSelected) then
    begin
        TDialogService.MessageDialog('Existe tarefas para este requisito. Tem certeza que quer inativar? Caso seja inativado o requisito todas as tarefas serão canceladas.',
          TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
          TMsgDlgBtn.mbOK, 0, procedure(const AResult: TModalResult)
        begin
          if AResult = mrNo then
          begin
            Abort;
          end
        end);
        CancelTasksOfRequeriment(RequerimentIdSelected);
    end;
  end;


  title           := edtTitle.Text;
  description     := memoDescription.Text;
  typeRequeriment := cbTypeReq.Items.KeyNames[cbTypeReq.ItemIndex];
  projectId       := StrToInt(cbProject.Items.KeyNames[cbProject.ItemIndex]);
  status          := cbStatus.Items.KeyNames[cbStatus.ItemIndex];
  if chkbActive.IsChecked then vActive := 1 else vActive := 0;


  query := TFDQuery.Create(nil);
  try
    with query do
    begin
      Connection := FDConnection;
      if RequerimentIdSelected > 0 then
      begin
        SQL.Text := 'UPDATE Requisitos SET Titulo = :Titulo, Descricao = :Descricao, '
                    + 'Ativo = :Ativo, ProjetoId = :ProjetoId, Tipo = :Tipo, Status = :Status WHERE Id = :RequerimentId';
        Params.ParamByName('RequerimentId').AsInteger := RequerimentIdSelected;
      end
      else
      begin
        SQL.Text := 'INSERT INTO Requisitos (Titulo, Descricao, Ativo, ProjetoId, Tipo, Status) '
                    + 'VALUES (:Titulo, :Descricao, :Ativo, :ProjetoId, :Tipo, :Status)';
      end;
      Params.ParamByName('Titulo').AsString     := title;
      Params.ParamByName('Descricao').AsString  := description;
      Params.ParamByName('Ativo').AsInteger     := vActive;
      Params.ParamByName('ProjetoId').AsInteger := projectId;
      Params.ParamByName('Tipo').AsString       := typeRequeriment;
      Params.ParamByName('Status').AsString     := status;
      ExecSQL;
    end;
  finally
    query.Close;
    query.DisposeOf;
  end;


  ShowMessage('Requisito foi salvo com sucesso!');


  Close;
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

function TFrmReqRegister.IsFieldsValid: Boolean;
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


  if not ((Length(edtTitle.Text) >= 3) and (Length(edtTitle.Text) <= 100)) then
  begin
    ShowMessage('Informe um valor entre 3 a 100 caracteres para o campo título!');
    Result := False;
  end;
end;

procedure TFrmReqRegister.FindRequerimentAndFillFields;
var query: TFDQuery;
begin
  query := TFDQuery.Create(nil);
  try
    with query do
    begin
      Connection := FDConnection;
      SQL.Clear;
      SQL.Text := 'SELECT ProjetoId, Titulo, Descricao, Status, ProjetoId, Tipo, Ativo FROM Requisitos WHERE Id = :RequisitoId';
      Params.ParamByName('RequisitoId').AsInteger := RequerimentIdSelected;
      Prepare;
      Open;
      First;


      edtTitle.Text        := FieldByName('Titulo').AsString;
      cbStatus.ItemIndex   := cbStatus.Items.IndexOfName(FieldByName('Status').AsString);
      cbTypeReq.ItemIndex  := cbTypeReq.Items.IndexOfName(FieldByName('Tipo').AsString);
      cbProject.ItemIndex  := cbProject.Items.IndexOfName(FieldByName('ProjetoId').AsString);
      chkbActive.IsChecked := FieldByName('Ativo').AsInteger = 1;
      memoDescription.Text := FieldByName('Descricao').AsString;
    end;
  finally
    query.Close;
    query.DisposeOf;
  end;
end;

end.
