unit FrmProjectOne;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, UFrmTaskShow, UFrmProjShow,
  UFrmReqShow, UFunctions;

type
  TFormProjectOne = class(TForm)
    btnProjetos: TButton;
    btnTarefas: TButton;
    btnRequisitos: TButton;
    btnAttachments: TButton;
    procedure btnTarefasClick(Sender: TObject);
    procedure btnProjetosClick(Sender: TObject);
    procedure btnRequisitosClick(Sender: TObject);
    procedure btnAttachmentsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormProjectOne: TFormProjectOne;

implementation

{$R *.fmx}

procedure TFormProjectOne.btnAttachmentsClick(Sender: TObject);
begin
  ShowMessage(PathOfExecutable);
end;

procedure TFormProjectOne.btnProjetosClick(Sender: TObject);
var frmProjectShow: TFrmProjectShow;
begin
  frmProjectShow := TFrmProjectShow.Create(self);
  frmProjectShow.ShowModal;
  FreeAndNil(frmProjectShow);
end;

procedure TFormProjectOne.btnRequisitosClick(Sender: TObject);
var frmReqShow: TFrmReqShow;
begin
  frmReqShow := TFrmReqShow.Create(self);
  frmReqShow.ShowModal;
  FreeAndNil(frmReqShow);
end;

procedure TFormProjectOne.btnTarefasClick(Sender: TObject);
var frmTaskShow: TFrmTaskShow;
begin
  frmTaskShow := TFrmTaskShow.Create(self);
  frmTaskShow.ShowModal;
  FreeAndNil(frmTaskShow);
end;

end.
