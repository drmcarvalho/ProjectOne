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
  UFunctions, FMX.ListBox, UConstants, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

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
    cbStatus: TComboBox;
    Label3: TLabel;
    lvAttachments: TListView;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure lvAttachmentsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }
    function IsFieldsValid: Boolean;
    procedure FindProjectAndFillFields;
  public
    { Public declarations }
      ProjectIdSelected: integer;
  end;

var
  FrmProjRegister: TFrmProjRegister;

implementation

{$R *.fmx}

procedure TFrmProjRegister.btnCancelClick(Sender: TObject);
var
  I: Integer;
  LItem: TListViewItem;

begin
  Close;
  {
  lvAttachments.BeginUpdate;
  try
    for I := 1 to 10 do
    begin
      LItem := lvAttachments.Items.Add;
      LItem.Text := 'Nº ' + IntToStr(I);
    end;
  finally
    lvAttachments.EndUpdate;
  end;
  }

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


  if cbStatus.ItemIndex >= 0 then
  begin
    status := cbStatus.Items.KeyNames[cbStatus.ItemIndex]
  end
  else
  begin
    status := 'EA';
  end;
  title  := edtTitle.Text;
  body   := memoBodyDescription.Text;


  /// ADD NEW OR UPDATE PROJECT

  query := TFDQuery.Create(nil);
  try
    with query do
    begin
      Connection := FDConnection;
      if ProjectIdSelected > 0 then
      begin
        SQL.Text := 'UPDATE Projetos SET Titulo = :Titulo, Corpo = :Corpo, Status = :Status WHERE Id = :ProjectId';
        Params.ParamByName('ProjectId').AsInteger := ProjectIdSelected;
      end
      else
      begin
        SQL.Text := 'INSERT INTO Projetos (Titulo, Corpo, Status) VALUES (:Titulo, :Corpo, :Status)';
      end;
      Params.ParamByName('Titulo').AsString := title;
      Params.ParamByName('Corpo').AsString  := body;
      Params.ParamByName('Status').AsString := status;
      ExecSQL;
    end;
  finally
    query.Close;
    query.DisposeOf;
  end;


  ShowMessage('Projeto foi salvo com sucesso!');


  Close;
end;

procedure TFrmProjRegister.FindProjectAndFillFields;
var query: TFDQuery;
begin
  query := TFDQuery.Create(nil);
  try
    with query do
    begin
      Connection := FDConnection;
      SQL.Clear;
      SQL.Text := 'SELECT Titulo, Corpo, Status FROM Projetos WHERE Id = :ProjectId';
      Params.ParamByName('ProjectId').AsInteger := ProjectIdSelected;
      Prepare;
      Open;
      First;


      edtTitle.Text            := FieldByName('Titulo').AsString;
      memoBodyDescription.Text := FieldByName('Corpo').AsString;
      cbStatus.ItemIndex       := cbStatus.Items.IndexOfName(FieldByName('Status').AsString);
    end;
  finally
    query.Close;
    query.DisposeOf;
  end;

end;

procedure TFrmProjRegister.FormCreate(Sender: TObject);
begin
  /// CONNECTION DATABASE SQLITE

  FDConnection.DriverName                := cDBDriver;
  FDConnection.Params.Values['Database'] := PathOfExecutable + cSQLiteFile;
  try
    FDConnection.Open;
  except on E: EDatabaseError do
    ShowMessage('Error: ' + E.Message)
  end;


  cbStatus.Items.AddPair('EA', ProjectStatusToSpellOut('EA'));
  cbStatus.Items.AddPair('C', ProjectStatusToSpellOut('C'));
  cbStatus.Items.AddPair('PC', ProjectStatusToSpellOut('PC'));
  cbStatus.Items.AddPair('AD', ProjectStatusToSpellOut('AD'));
  cbStatus.ItemIndex := 0;
end;

procedure TFrmProjRegister.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if key = vkEscape then
  begin
    Close;
  end;
end;

procedure TFrmProjRegister.FormShow(Sender: TObject);
begin
  if ProjectIdSelected > 0 then
  begin
    FindProjectAndFillFields;
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

procedure TFrmProjRegister.lvAttachmentsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  ShowMessage(AItem.Text);
end;

end.
