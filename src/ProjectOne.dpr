program ProjectOne;

uses
  System.StartUpCopy,
  FMX.Forms,
  FrmProjectOne in 'FrmProjectOne.pas' {FormProjectOne},
  UFrmReqShow in 'Requirements\UFrmReqShow.pas' {FrmReqShow},
  UFrmReqRegister in 'Requirements\UFrmReqRegister.pas' {Form2},
  UFrmTaskShow in 'Tasks\UFrmTaskShow.pas' {FrmTaskShow},
  UFrmProjRegister in 'Projects\UFrmProjRegister.pas' {FrmProjRegister},
  UAttachments in 'Attachments\UAttachments.pas',
  UFrmTaskRegister in 'Tasks\UFrmTaskRegister.pas' {Form5},
  UFrmProjShow in 'Projects\UFrmProjShow.pas' {FrmProjectShow},
  UFunctions in 'UFunctions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormProjectOne, FormProjectOne);
  Application.CreateForm(TFrmReqShow, FrmReqShow);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TFrmTaskShow, FrmTaskShow);
  Application.CreateForm(TFrmProjRegister, FrmProjRegister);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TFrmProjectShow, FrmProjectShow);
  Application.Run;
end.
