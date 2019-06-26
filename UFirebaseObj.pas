unit UFirebaseObj;

interface

const
  cteFirebase_IMEI      = 'IMEI';
  cteFirebase_Id        = 'id';
  cteFirebase_Data      = 'data';
  cteFirebase_Latitude  = 'latitude';
  cteFirebase_Longitude = 'longitude';
  cteFirebase_Linha     = 'linha';
  cteFirebase_Tipo      = 'tipo';
  cteFirebase_Titulo    = 'titulo';

  cteFirebase_Mensagens      = 'mensagens';
  cteFirebase_Mensagens_Data = 'data';
  cteFirebase_Mensagens_Foto = 'foto';
  cteFirebase_Mensagens_Id   = 'id';
  cteFirebase_Mensagens_Msg  = 'msg';

type
  TFirebaseObj            = class;
  TProcOnFimProcessamento = procedure(const pItemObj: TFirebaseObj) of object;
  TProcAddObjFilaEnvio    = procedure(const pItemObj: TFirebaseObj) of object;

  TFirebaseObj = class(TObject)
  private
    FAuth: String;
    FUID: String;
    FURL: String;
    FJSON: String;
    FEnviar: Boolean;
    FRetorno: String;
    FSucessoProc: Boolean;
    FOnFimProcessamento: TProcOnFimProcessamento;
    procedure SetAuth(const Value: String);
    procedure SetJSON(const Value: String);
    procedure SetUID(const Value: String);
    procedure SetURL(const Value: String);
    procedure SetEnviar(const Value: Boolean);
    procedure SetRetorno(const Value: String);
    procedure SetSucessoProc(const Value: Boolean);
    procedure SetOnFimProcessamento(const Value: TProcOnFimProcessamento);
  public
    constructor Create;
    procedure DoOnFimProcessamento;

    property URL: String read FURL write SetURL;
    property Auth: String read FAuth write SetAuth;
    property UID: String read FUID write SetUID;
    property JSON: String read FJSON write SetJSON;
    property Enviar: Boolean read FEnviar write SetEnviar;
    property Retorno: String read FRetorno write SetRetorno;
    property SucessoProc: Boolean read FSucessoProc write SetSucessoProc;
    property OnFimProcessamento: TProcOnFimProcessamento read FOnFimProcessamento write SetOnFimProcessamento;
  end;

implementation

uses
  System.Classes;

{ TFirebaseObj }

constructor TFirebaseObj.Create;
begin
  inherited;
  FEnviar      := True;
  FURL         := '';
  FAuth        := '';
  FUID         := '';
  FJSON        := '';
  FRetorno     := '';
  FSucessoProc := True;
end;

procedure TFirebaseObj.DoOnFimProcessamento;
begin
  if Assigned(FOnFimProcessamento) then begin
    TThread.Synchronize(TThread.CurrentThread, procedure begin
                                                           try
                                                             FOnFimProcessamento(Self);
                                                           except
                                                           end;
                                                         end);
  end;
end;

procedure TFirebaseObj.SetAuth(const Value: String);
begin
  FAuth := Value;
end;

procedure TFirebaseObj.SetEnviar(const Value: Boolean);
begin
  FEnviar := Value;
end;

procedure TFirebaseObj.SetJSON(const Value: String);
begin
  FJSON := Value;
end;

procedure TFirebaseObj.SetOnFimProcessamento(const Value: TProcOnFimProcessamento);
begin
  FOnFimProcessamento := Value;
end;

procedure TFirebaseObj.SetRetorno(const Value: String);
begin
  FRetorno := Value;
end;

procedure TFirebaseObj.SetSucessoProc(const Value: Boolean);
begin
  FSucessoProc := Value;
end;

procedure TFirebaseObj.SetUID(const Value: String);
begin
  FUID := Value;
end;

procedure TFirebaseObj.SetURL(const Value: String);
begin
  FURL := Value;
end;

end.
