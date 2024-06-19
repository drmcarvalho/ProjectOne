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
  FMX.Edit;

type
  TFrmTaskShow = class(TForm)
    StringGrid: TStringGrid;
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
    Edit1: TEdit;
    procedure btnNewTaskClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmTaskShow: TFrmTaskShow;

implementation

{$R *.fmx}

procedure TFrmTaskShow.btnNewTaskClick(Sender: TObject);
begin
//
end;

end.
