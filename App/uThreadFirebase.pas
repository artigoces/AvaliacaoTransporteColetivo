unit uThreadFirebase;

interface

uses
  System.Classes,
  UFirebaseObj,
  System.SyncObjs,
  System.Generics.Collections,
  System.SysUtils;

type
  TListaFirebaseObj = TObjectQueue<TFirebaseObj>;

  TThreadFirebaseObj = class(TThread)
  private
    FCriticalSection: TCriticalSection;
    FListaEnvio: TListaFirebaseObj;
    FAtiva: Boolean;
    FURLBase: String;
    FQtdMaxTentativaEnvio: Integer;

    procedure LogMsg(const pMsg: String; const pException: Exception);

    function GetItemEnvio: TFirebaseObj;
    procedure SetURLBase(const Value: String);
    procedure SetQtdMaxTentativaEnvio(const Value: Integer);
  protected
    procedure Execute; override;
  public
    procedure EnviarDados(const pItemObj: TFirebaseObj);
    procedure LerDados(const pItemObj: TFirebaseObj);

    procedure Ativar;
    procedure Desativar;

    constructor Create;
    destructor Destroy; override;
    procedure AddItemEnvio(const pObj: TFirebaseObj);

    property URLBase: String read FURLBase write SetURLBase;
    property QtdMaxTentativaEnvio: Integer read FQtdMaxTentativaEnvio write SetQtdMaxTentativaEnvio;
  end;


implementation

uses
  System.Net.HttpClient,
  REST.Types,
  System.IOUtils,
  IdURI,
  REST.Client;

{ TThreadFirebase }

procedure TThreadFirebaseObj.AddItemEnvio(const pObj: TFirebaseObj);
begin
  FCriticalSection.Enter;
  try
    pObj.URL  := TIdURI.URLEncode(TPath.Combine(FURLBase, pObj.URL));
    pObj.Auth := '';
    pObj.UID  := '';
    FListaEnvio.Enqueue(pObj);
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TThreadFirebaseObj.Ativar;
begin
  FCriticalSection.Enter;
  try
    FAtiva := True;
  finally
    FCriticalSection.Leave;
  end;
end;

constructor TThreadFirebaseObj.Create;
begin
  inherited Create(False);

  FAtiva                := False;
  FCriticalSection      := TCriticalSection.Create;
  FListaEnvio           := TListaFirebaseObj.Create(True);
  FQtdMaxTentativaEnvio := 10;
end;

procedure TThreadFirebaseObj.Desativar;
begin
  FCriticalSection.Enter;
  try
    FAtiva := False;
  finally
    FCriticalSection.Leave;
  end;
end;

destructor TThreadFirebaseObj.Destroy;
begin
  FreeAndNil(FListaEnvio);
  FreeAndNil(FCriticalSection);
  inherited;
end;

procedure TThreadFirebaseObj.EnviarDados(const pItemObj: TFirebaseObj);
var
  vJsonStream: TStringStream;
  vIdHTTP: THTTPClient;
  vTentiva: Integer;
begin
  pItemObj.SucessoProc := False;

  vIdHTTP     := nil;
  vJsonStream := nil;
  try
    //JSON com as informações da ocorrência a ser gravado no Firebase
    vJsonStream := TStringStream.Create(UTF8Encode(pItemObj.JSON));

    vIdHTTP             := THTTPClient.Create;
    vIdHTTP.ContentType := 'application/json';

    //dados de autentificação configurados no console do Firebase
    if pItemObj.Auth <> '' then begin
      vIdHTTP.CustomHeaders['auth'] := pItemObj.Auth;
      vIdHTTP.CustomHeaders['uid']  := pItemObj.UID;
    end;

    vTentiva := 0;
    while (not pItemObj.SucessoProc) and (vTentiva <= FQtdMaxTentativaEnvio) do begin
      try
        Inc(vTentiva);
        vIdHTTP.Put(pItemObj.URL, vJsonStream);
        pItemObj.SucessoProc := True;
      except
      end; 
    end;
  finally
    FreeAndNil(vJsonStream);
    FreeAndNil(vIdHTTP);
  end;
end;

procedure TThreadFirebaseObj.Execute;
var
  vItem: TFirebaseObj;
begin
  inherited;

  while not Terminated do begin
    if FAtiva then begin
      try
        vItem := GetItemEnvio;
        if Assigned(vItem) then begin
          try
            if vItem.Enviar then
              EnviarDados(vItem)
            else
              LerDados(vItem);

            vItem.DoOnFimProcessamento;
          finally
            FreeAndNil(vItem);
          end;
        end;

        Sleep(500);
      except
        on e: Exception do
          LogMsg('TThreadFirebaseObj.Execute', e);
      end;
    end
    else
      Sleep(2000);
  end;
end;

function TThreadFirebaseObj.GetItemEnvio: TFirebaseObj;
begin
  Result := nil;

  FCriticalSection.Enter;
  try
    if FListaEnvio.Count > 0 then
      Result := FListaEnvio.Extract;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TThreadFirebaseObj.LerDados(const pItemObj: TFirebaseObj);
var
  vIdHTTP: THTTPClient;
  vResposta: IHTTPResponse;
  vTentiva: Integer;
begin
  pItemObj.SucessoProc := False;

  vIdHTTP := nil;
  try
    vIdHTTP                       := THTTPClient.Create;
    //dados de autentificação configurados no console do Firebase
    if pItemObj.Auth <> '' then begin
      vIdHTTP.CustomHeaders['auth'] := pItemObj.Auth;
      vIdHTTP.CustomHeaders['uid']  := pItemObj.UID;
    end;

    vTentiva := 0;
    while (not pItemObj.SucessoProc) and (vTentiva <= FQtdMaxTentativaEnvio) do begin
      try
        Inc(vTentiva);
        vResposta            := vIdHTTP.Get(pItemObj.URL);
        pItemObj.Retorno     := vResposta.ContentAsString;
        pItemObj.SucessoProc := True;
      except
      end;
    end;
  finally
    FreeAndNil(vIdHTTP);
  end;
end;

procedure TThreadFirebaseObj.LogMsg(const pMsg: String; const pException: Exception);
begin

end;

procedure TThreadFirebaseObj.SetQtdMaxTentativaEnvio(const Value: Integer);
begin
  FQtdMaxTentativaEnvio := Value;
end;

procedure TThreadFirebaseObj.SetURLBase(const Value: String);
begin
  FURLBase := Value;
end;

end.
