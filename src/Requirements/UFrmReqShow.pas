unit UFrmReqShow;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.Client,
  System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, UFrmReqRegister, UFunctions,
  UConstants;

type
  TFrmReqShow = class(TForm)
    btnSearch: TButton;
    edtSearch: TEdit;
    btnUpdate: TButton;
    btnNewRequeriment: TButton;
    FDConnection: TFDConnection;
    FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
    sgRequeriments: TStringGrid;
    icRequerimentId: TIntegerColumn;
    scTitle: TStringColumn;
    scDescription: TStringColumn;
    scProject: TStringColumn;
    scType: TStringColumn;
    scActive: TStringColumn;
    scStatus: TStringColumn;
    procedure FormCreate(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnNewRequerimentClick(Sender: TObject);
    procedure sgRequerimentsSelectCell(Sender: TObject; const ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure btnUpdateClick(Sender: TObject);
  private
    { Private declarations }
    procedure SearchInRequerimentsAndFillGrid(const term: string);
    procedure ShowModalFormNewReq;
  public
    { Public declarations }
  end;

var
  FrmReqShow: TFrmReqShow;
  RequerimentIdSelected: integer;

implementation

{$R *.fmx}

procedure TFrmReqShow.btnNewRequerimentClick(Sender: TObject);
begin
  RequerimentIdSelected := 0;


  ShowModalFormNewReq;


  SearchInRequerimentsAndFillGrid('');
end;

procedure TFrmReqShow.ShowModalFormNewReq;
var frmNewReq: TFrmReqRegister;
begin
  frmNewReq := TFrmReqRegister.Create(self);
  frmNewReq.RequerimentIdSelected := RequerimentIdSelected;
  frmNewReq.ShowModal;
  FreeAndNil(frmNewReq);
end;

procedure TFrmReqShow.btnSearchClick(Sender: TObject);
begin
  SearchInRequerimentsAndFillGrid(edtSearch.Text);
end;

procedure TFrmReqShow.btnUpdateClick(Sender: TObject);
begin
  if RequerimentIdSelected = 0 then
  begin
    ShowMessage('Por favor selecione um registro para alterar.');
  end
  else
  begin
    ShowModalFormNewReq;


    SearchInRequerimentsAndFillGrid('');
  end;
end;

procedure TFrmReqShow.FormCreate(Sender: TObject);
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

  SearchInRequerimentsAndFillGrid('');


  RequerimentIdSelected := 0;
end;

procedure TFrmReqShow.SearchInRequerimentsAndFillGrid(const term: string);
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
      SQL.Add('SELECT R.Id, R.Titulo, R.Descricao, P.Titulo AS Projeto, R.Ativo, R.Tipo, R."Status"');
      SQL.Add('FROM Requisitos R INNER JOIN Projetos P ON P.Id = R.ProjetoId');
      if Length(term) > 0 then
      begin
        SQL.Add('WHERE (R.Titulo LIKE :WhereLike OR R.Descricao LIKE :WhereLike OR P.Titulo LIKE :WhereLike)');
        Params.ParamByName('WhereLike').AsString := '%' + term + '%' ;
      end;
      Prepare;
      Open;


      sgRequeriments.RowCount := RecordCount;
      I := 0;
      while not Eof do
      begin
        sgRequeriments.Cells[0, I] := FieldByName('Id').AsString;
        sgRequeriments.Cells[1, I] := FieldByName('Titulo').AsString;
        sgRequeriments.Cells[2, I] := FieldByName('Descricao').AsString;
        sgRequeriments.Cells[3, I] := FieldByName('Projeto').AsString;
        sgRequeriments.Cells[4, I] := RequerimentTypeToSpellOut(FieldByName('Tipo').AsString);
        sgRequeriments.Cells[5, I] := FieldByName('Ativo').AsString;
        sgRequeriments.Cells[6, I] := RequerimentStatusToSpellOut(FieldByName('Status').AsString);
        Inc(I);
        Next;
      end;
    end;
  finally
    query.Close;
    query.DisposeOf;
  end;
end;

procedure TFrmReqShow.sgRequerimentsSelectCell(Sender: TObject; const ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if (ARow > -1) and (sgRequeriments.Cells[0, ARow] <> '') then
  begin
    RequerimentIdSelected := StrToInt(sgRequeriments.Cells[0, ARow]);
  end;
end;

end.
