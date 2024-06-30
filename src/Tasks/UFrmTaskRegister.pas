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
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmNewTask: TFrmNewTask;

implementation

{$R *.fmx}

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
end;

end.
