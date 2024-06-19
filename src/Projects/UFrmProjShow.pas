unit UFrmProjShow;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, UFrmProjRegister, System.Rtti,
  FMX.Grid.Style, FMX.Grid, FMX.ScrollBox, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.FMXUI.Wait, FireDAC.DApt, FireDAC.Stan.Param,
  Data.DB, FireDAC.Comp.Client, UFunctions, FMX.Edit, UConstants;

type
  TFrmProjectShow = class(TForm)
    btnNewProject: TButton;
    sgProjects: TStringGrid;
    icProjectId: TIntegerColumn;
    scTitle: TStringColumn;
    FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
    FDConnection: TFDConnection;
    scStatus: TStringColumn;
    btnSearch: TButton;
    edtSearch: TEdit;
    btnUpdate: TButton;
    procedure btnNewProjectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sgProjectsSelectCell(Sender: TObject; const ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnSearchClick(Sender: TObject);
    procedure edtSearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnUpdateClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure SearchInProjectsAndFillGrid(const term: string);
    procedure ShowModalFormNewProject;
  public
    { Public declarations }
  end;

var
  FrmProjectShow: TFrmProjectShow;
  ProjectIdSelected: Integer;

implementation

{$R *.fmx}

procedure TFrmProjectShow.btnNewProjectClick(Sender: TObject);
begin
  ProjectIdSelected := 0;


  ShowModalFormNewProject;


  SearchInProjectsAndFillGrid('');
end;

procedure TFrmProjectShow.btnSearchClick(Sender: TObject);
begin
  SearchInProjectsAndFillGrid(edtSearch.Text);
end;

procedure TFrmProjectShow.btnUpdateClick(Sender: TObject);
begin
  if ProjectIdSelected = 0 then
  begin
    ShowMessage('Por favor selecione um registro para alterar.');
  end
  else
  begin
    ShowModalFormNewProject;


    SearchInProjectsAndFillGrid('');
  end;
end;

procedure TFrmProjectShow.ShowModalFormNewProject;
var frmNewProject: TFrmProjRegister;
begin
  frmNewProject := TFrmProjRegister.Create(self);
  frmNewProject.ProjectIdSelected := ProjectIdSelected;
  frmNewProject.ShowModal;
  FreeAndNil(frmNewProject);
end;

procedure TFrmProjectShow.edtSearchKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    SearchInProjectsAndFillGrid(edtSearch.Text);
  end;
end;

procedure TFrmProjectShow.FormCreate(Sender: TObject);
begin
  /// CONNECTION TO DATABASE SQLITE

  FDConnection.DriverName                := cDBDriver;
  FDConnection.Params.Values['Database'] := PathOfExecutable + cSQLiteFile;
  try
    FDConnection.Open;
  except on E: EDatabaseError do
    ShowMessage('Error: ' + E.Message)
  end;


  /// GET AND POPULATE PROJECTS

  SearchInProjectsAndFillGrid('');


  ProjectIdSelected := 0;
end;

procedure TFrmProjectShow.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkEscape then
  begin
    Close;
  end;
end;

procedure TFrmProjectShow.SearchInProjectsAndFillGrid(const term: string);
var
  query: TFDQuery;
  I: integer;
begin
  query := TFDQuery.Create(nil);
  try
    with query do
    begin
      Connection := FDConnection;
      SQL.Clear;
      SQL.Add('SELECT Id, Titulo, Status FROM Projetos');
      if Length(term) > 0 then
      begin
        SQL.Add('WHERE (Titulo LIKE :WhereLike OR Corpo LIKE :WhereLike)');
        Params.ParamByName('WhereLike').AsString := '%' + term + '%' ;
      end;
      Prepare;
      Open;


      sgProjects.RowCount := RecordCount;
      I := 0;
      while not Eof do
      begin
        sgProjects.Cells[0, I] := FieldByName('Id').AsString;
        sgProjects.Cells[1, I] := FieldByName('Titulo').AsString;
        sgProjects.Cells[2, I] := ProjectStatusToSpellOut(FieldByName('Status').AsString);
        Inc(I);
        Next;
      end;
    end;
  finally
    query.Close;
    query.DisposeOf;
  end;
end;

procedure TFrmProjectShow.sgProjectsSelectCell(Sender: TObject; const ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if (ARow > -1) and (sgProjects.Cells[0, ARow] <> '') then
  begin
    ProjectIdSelected := StrToInt(sgProjects.Cells[0, ARow]);
  end;
end;

end.
