unit FrmProjectOne;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, UFrmTaskShow, UFrmProjShow,
  UFrmReqShow, UFunctions, UTranslate, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.Client,
  FireDAC.DApt, UConstants;

type
  TFormProjectOne = class(TForm)
    FDConnection: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    Expander: TExpander;
    sbProjects: TSpeedButton;
    sbTasks: TSpeedButton;
    sbAttachs: TSpeedButton;
    sbReqs: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure sbProjectsClick(Sender: TObject);
    procedure sbReqsClick(Sender: TObject);
    procedure ExpanderDblClick(Sender: TObject);
    procedure sbTasksClick(Sender: TObject);
  private
    { Private declarations }
    procedure CreateDatabase;
  public
    { Public declarations }
  end;

var
  FormProjectOne: TFormProjectOne;

implementation

{$R *.fmx}

procedure TFormProjectOne.CreateDatabase;
var query: TFDQuery;
begin
  /// CONNECTION DATABASE SQLITE

  FDConnection.DriverName                := cDBDriver;
  FDConnection.Params.Values['Database'] := PathOfExecutable + cSQLiteFile;
  try
    FDConnection.Open;
  except on E: EDatabaseError do
    ShowMessage('Error: ' + E.Message)
  end;


  query := TFDQuery.Create(nil);
  try
    with query do
    begin
      Connection := FDConnection;
      SQL.Clear;
      SQL.Add('CREATE TABLE IF NOT EXISTS "Projetos" (');
      SQL.Add('	"Id" INTEGER NOT NULL,');
      SQL.Add('	"Titulo" TEXT NOT NULL,');
      SQL.Add('	"Corpo" TEXT NOT NULL,');
      SQL.Add('	"Status" TEXT NOT NULL,');
      SQL.Add('	PRIMARY KEY ("Id")');
      SQL.Add(');');
      SQL.Add('CREATE TABLE IF NOT EXISTS "Requisitos" (');
      SQL.Add('	"Id" INTEGER NOT NULL,');
      SQL.Add('	"ProjetoId" INTEGER NOT NULL,');
      SQL.Add('	"Titulo" TEXT NOT NULL,');
      SQL.Add('	"Descricao" TEXT NULL DEFAULT NULL,');
      SQL.Add('	"Ativo" TINYINT NOT NULL,');
      SQL.Add('	"Tipo" TEXT NOT NULL,');
      SQL.Add(' "Status" TEXT NOT NULL DEFAULT "EA",');
      SQL.Add('	PRIMARY KEY ("Id"),');
      SQL.Add('	CONSTRAINT "fk_projeto_requisito" FOREIGN KEY ("ProjetoId") REFERENCES "Projetos" ("Id") ON UPDATE CASCADE ON DELETE CASCADE');
      SQL.Add(');');
      SQL.Add('CREATE TABLE IF NOT EXISTS "Tarefas" (');
      SQL.Add('	"Id" INTEGER NOT NULL,');
      SQL.Add('	"ProjetoId" INTEGER NOT NULL,');
      SQL.Add('	"RequisitoId" INTEGER NOT NULL,');
      SQL.Add('	"Titulo" TEXT NOT NULL,');
      SQL.Add('	"Descricao" TEXT NULL,');
      SQL.Add('	"Status" TEXT NOT NULL,');
      SQL.Add('	PRIMARY KEY ("Id"),');
      SQL.Add('	CONSTRAINT "fk_projeto_tarefa" FOREIGN KEY ("ProjetoId") REFERENCES "Projetos" ("Id") ON UPDATE CASCADE ON DELETE CASCADE,');
      SQL.Add('	CONSTRAINT "fk_requisito_tarefa" FOREIGN KEY ("RequisitoId") REFERENCES "Requisitos" ("Id") ON UPDATE CASCADE ON DELETE CASCADE');
      SQL.Add(');');
      ExecSQL;
    end;
  finally
    query.Close;
    query.DisposeOf;
  end;
end;

procedure TFormProjectOne.ExpanderDblClick(Sender: TObject);
begin
  Expander.IsExpanded := not Expander.IsExpanded;
end;

procedure TFormProjectOne.FormCreate(Sender: TObject);
begin
  /// Translate experimental

  InitTranslate;


  /// CREATE FILE SQLITE DATABASE AND TABLES

  CreateDatabase;
end;

procedure TFormProjectOne.sbProjectsClick(Sender: TObject);
var frmProjectShow: TFrmProjectShow;
begin
  frmProjectShow := TFrmProjectShow.Create(Self);
  frmProjectShow.ShowModal;
  FreeAndNil(frmProjectShow);
end;

procedure TFormProjectOne.sbReqsClick(Sender: TObject);
var frmReqShow: TFrmReqShow;
begin
  frmReqShow := TFrmReqShow.Create(self);
  frmReqShow.ShowModal;
  FreeAndNil(frmReqShow);
end;

procedure TFormProjectOne.sbTasksClick(Sender: TObject);
var frmTaskShow: TFrmTaskShow;
begin
  frmTaskShow := TFrmTaskShow.Create(self);
  frmTaskShow.ShowModal;
  FreeAndNil(frmTaskShow);
end;

end.
