{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
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
  FireDAC.DApt, UConstants, FMX.Layouts, FMX.DialogService;

type
  TFormProjectOne = class(TForm)
    FDConnection: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    Expander: TExpander;
    sbProjects: TSpeedButton;
    sbTasks: TSpeedButton;
    sbAttachs: TSpeedButton;
    sbReqs: TSpeedButton;
    StyleBook: TStyleBook;
    Layout: TLayout;
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
