unit UFrmTaskShow;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid,
  FMX.StdCtrls, FMX.Header, FMX.Objects, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite,
  FMX.Edit, UFunctions, UConstants, UFrmTaskRegister;

type
  TFrmTaskShow = class(TForm)
    sgTasks: TStringGrid;
    scTaskId: TStringColumn;
    scTaskTitle: TStringColumn;
    scRequeriment: TStringColumn;
    scProject: TStringColumn;
    scStatus: TStringColumn;
    btnSearch: TButton;
    btnNewTask: TButton;
    btnUpdateTask: TButton;
    FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
    FDConnection: TFDConnection;
    edtSearch: TEdit;
    procedure btnNewTaskClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtSearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure SearchInTaskAndFillGrid(const term: string);
  public
    { Public declarations }
  end;

var
  FrmTaskShow: TFrmTaskShow;

implementation

{$R *.fmx}

procedure TFrmTaskShow.SearchInTaskAndFillGrid(const term: string);
var
  query: TFDQuery;
  I: Integer;
begin
  query := TFDQuery.Create(nil);
  try
    with query do
    begin
      Connection := FDConnection;
      SQL.Clear;
      SQL.Add('SELECT T.Id, T.Titulo, T."Status", P.Titulo AS "Projeto", R.Titulo AS "Requisito"');
      SQL.Add('FROM Tarefas T');
      SQL.Add('INNER JOIN Projetos P ON P.Id = T.ProjetoId');
      SQL.Add('INNER JOIN Requisitos R ON R.Id = T.RequisitoId');
      if Length(term) > 0 then
      begin
        SQL.Add('WHERE (R.Titulo LIKE :WhereLike OR P.Titulo LIKE :WhereLike OR T.Titulo LIKE :WhereLike OR T.Descricao LIKE :WhereLike)');
        Params.ParamByName('WhereLike').AsString := '%' + term + '%' ;
      end;
      Prepare;
      Open;


      sgTasks.RowCount := RecordCount;
      I := 0;
      while not Eof do begin
        sgTasks.Cells[0, I] := FieldByName('Id').AsString;
        sgTasks.Cells[1, I] := FieldByName('Titulo').AsString;
        sgTasks.Cells[2, I] := TaskStatusToSpellOut(FieldByName('Status').AsString);
        sgTasks.Cells[3, I] := FieldByName('Projeto').AsString;
        sgTasks.Cells[4, I] := FieldByName('Requisito').AsString;
        Inc(I);
        Next;
      end;
    end;
  finally
    query.Close;
    query.DisposeOf;
  end;
end;

procedure TFrmTaskShow.btnNewTaskClick(Sender: TObject);
var frmNewTask: TFrmNewTask;
begin
  frmNewTask := TFrmNewTask.Create(Self);
  frmNewTask.ShowModal;
  FreeAndNil(frmNewTask);
end;

procedure TFrmTaskShow.btnSearchClick(Sender: TObject);
begin
  SearchInTaskAndFillGrid(edtSearch.Text);
end;

procedure TFrmTaskShow.edtSearchKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    SearchInTaskAndFillGrid(edtSearch.Text);
  end;
end;

procedure TFrmTaskShow.FormCreate(Sender: TObject);
begin
  /// CONNECTION TO DATABASE SQLITE

  FDConnection.DriverName                := cDBDriver;
  FDConnection.Params.Values['Database'] := PathOfExecutable + cSQLiteFile;
  try
    FDConnection.Open;
  except on E: EDatabaseError do
    ShowMessage('Error: ' + E.Message)
  end;


  /// GET REQUERIMENTS AND FILL GRID

  SearchInTaskAndFillGrid('');
end;

procedure TFrmTaskShow.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkEscape then
  begin
    Close;
  end;
end;

end.
