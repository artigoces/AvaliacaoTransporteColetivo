program AppDelphi;

uses
  System.StartUpCopy,
  FMX.Forms,
  FPrincipal in 'FPrincipal.pas' {frmPrincipal},
  FOcorrencia in 'FOcorrencia.pas' {frmOcorrencia},
  uThreadFirebase in 'uThreadFirebase.pas',
  UFirebaseObj in 'UFirebaseObj.pas',
  UOcorrenciaObj in 'UOcorrenciaObj.pas',
  dmDados in 'dmDados.pas' {dtmdlDados: TDataModule},
  U_MsgD in 'U_MsgD.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdtmdlDados, dtmdlDados);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmOcorrencia, frmOcorrencia);
  Application.Run;
end.
