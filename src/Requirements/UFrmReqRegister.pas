unit UFrmReqRegister;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.ListBox,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmReqRegister: TFrmReqRegister;

implementation

{$R *.fmx}

end.
