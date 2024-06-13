unit UFrmTaskShow;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid,
  FMX.StdCtrls;

type
  TFrmTaskShow = class(TForm)
    Button1: TButton;
    StringGrid: TStringGrid;
    scTask: TStringColumn;
    scDescription: TStringColumn;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmTaskShow: TFrmTaskShow;

implementation

{$R *.fmx}

procedure TFrmTaskShow.Button1Click(Sender: TObject);
begin
  StringGrid.RowCount    := 2;
  StringGrid.Cells[0, 0] := 'Terefa 1';
  StringGrid.Cells[1, 0] := 'Descricao 1';
  StringGrid.Cells[0, 1] := 'Terefa 2';
  StringGrid.Cells[1, 1] := 'Descricao 2';

end;

end.
