unit dmDados;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FireDAC.Comp.UI, Data.DB, FireDAC.Comp.Client;

type
  TdtmdlDados = class(TDataModule)
    fdconConexao: TFDConnection;
    fdgxwtcrsrConexao: TFDGUIxWaitCursor;
    fdphysqltdrvrlnkConexao: TFDPhysSQLiteDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmdlDados: TdtmdlDados;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.IOUtils;

procedure TdtmdlDados.DataModuleCreate(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
    fdconConexao.Params.Database := 'C:\Users\VM Windows\Downloads\AppDelphi\info\BaseApp.db';
  {$ELSE}
    fdconConexao.Params.Database := TPath.Combine(TPath.GetDocumentsPath, 'BaseApp.db');
  {$ENDIF}
  fdconConexao.Connected := True;
end;

end.
