program ProjectOne;

uses
  System.StartUpCopy,
  FMX.Forms,
  FrmProjectOne in 'FrmProjectOne.pas' {FormProjectOne},
  UFrmReqShow in 'Requirements\UFrmReqShow.pas' {FrmReqShow},
  UFrmReqRegister in 'Requirements\UFrmReqRegister.pas' {FrmReqRegister},
  UFrmTaskShow in 'Tasks\UFrmTaskShow.pas' {FrmTaskShow},
  UFrmProjRegister in 'Projects\UFrmProjRegister.pas' {FrmProjRegister},
  UAttachments in 'Attachments\UAttachments.pas',
  UFrmTaskRegister in 'Tasks\UFrmTaskRegister.pas' {FrmNewTask},
  UFrmProjShow in 'Projects\UFrmProjShow.pas' {FrmProjectShow},
  UFunctions in 'UFunctions.pas',
  UTranslate in 'UTranslate.pas',
  UConstants in 'UConstants.pas',
  UFrmAttachmentShow in 'Attachments\UFrmAttachmentShow.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormProjectOne, FormProjectOne);
  Application.CreateForm(TFrmReqShow, FrmReqShow);
  Application.CreateForm(TFrmReqRegister, FrmReqRegister);
  Application.CreateForm(TFrmTaskShow, FrmTaskShow);
  Application.CreateForm(TFrmProjRegister, FrmProjRegister);
  Application.CreateForm(TFrmNewTask, FrmNewTask);
  Application.CreateForm(TFrmProjectShow, FrmProjectShow);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
