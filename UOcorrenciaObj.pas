unit UOcorrenciaObj;

interface

uses
  System.Classes,
  FireDAC.Comp.Client;

type
  TOcorrenciaObj = class
  private
    FQuery: TFDQuery;
  public
    constructor Create;
    destructor Destroy; override;

    function InserirOcorrencia(const pConexao: TFDConnection;
                               const pData: TDateTime;
                               const pTitulo, pIMEI: String;
                               const pLID, pTID: Integer;
                               const pLatitude, pLongitude: Double;
                               const pOID: String = ''): String;

    function InserirMensagem(const pConexao: TFDConnection;
                             const pOID, pMsg: String;
                             const pData: TDateTime;
                             const pMemStreamImagem: TMemoryStream;
                             const pID: Integer = 0): Integer;
  end;

implementation

uses
  Data.DB,
  System.SysUtils;

{ TOcorrenciaObj }

constructor TOcorrenciaObj.Create;
begin
  FQuery := TFDQuery.Create(nil);
end;

destructor TOcorrenciaObj.Destroy;
begin
  FreeAndNil(FQuery);
  inherited;
end;

function TOcorrenciaObj.InserirMensagem(const pConexao: TFDConnection;
                                        const pOID, pMsg: String;
                                        const pData: TDateTime;
                                        const pMemStreamImagem: TMemoryStream;
                                        const pID: Integer = 0): Integer;
begin
  Result := -1;

  FQuery.Connection := pConexao;

  if pID <= 0 then begin
    FQuery.SQL.Text := 'INSERT INTO MENSAGEM (OID, MDATA, MMSG, MIMAGEM) VALUES(:OID, :MDATA, :MMSG, :MIMAGEM); ' +
                       'SELECT LAST_INSERT_ROWID() AS ID';
  end
  else begin
    FQuery.SQL.Text := 'INSERT INTO MENSAGEM (MID, OID, MDATA, MMSG, MIMAGEM) VALUES(:MID, :OID, :MDATA, :MMSG, :MIMAGEM); ' +
                       'SELECT LAST_INSERT_ROWID() AS ID';

    FQuery.ParamByName('MID').AsInteger := pID;
  end;

  FQuery.ParamByName('OID').AsString     := pOID;
  FQuery.ParamByName('MDATA').AsDateTime := pData;

  if pMsg = '' then begin
    FQuery.ParamByName('MMSG').DataType := TFieldType.ftString;
    FQuery.ParamByName('MMSG').Clear;
  end
  else
    FQuery.ParamByName('MMSG').AsString := pMsg;

  if Assigned(pMemStreamImagem) then begin
    pMemStreamImagem.Position := 0;
    FQuery.ParamByName('MIMAGEM').LoadFromStream(pMemStreamImagem, ftBlob);
  end
  else begin
    FQuery.ParamByName('MIMAGEM').DataType := TFieldType.ftString;
    FQuery.ParamByName('MIMAGEM').Clear;
  end;

  FQuery.Open;
  Result := FQuery.FieldByName('ID').AsInteger;
end;

function TOcorrenciaObj.InserirOcorrencia(const pConexao: TFDConnection;
                                          const pData: TDateTime;
                                          const pTitulo, pIMEI: String;
                                          const pLID, pTID: Integer;
                                          const pLatitude, pLongitude: Double;
                                          const pOID: String = ''): String;
var
  vOID: String;
  vCodigo: Integer;
begin
  Result := '';

  FQuery.Connection := pConexao;

  if pOID = '' then begin
    FQuery.SQL.Text := 'SELECT COALESCE(MAX(OCODIGO), 0) + 1 AS CODIGO FROM OCORRENCIA WHERE OIMEI = :OIMEI';
    FQuery.ParamByName('OIMEI').AsString := pIMEI;
    FQuery.Open;
    vCodigo := FQuery.FieldByName('CODIGO').AsInteger;
    vOID    := pIMEI + '_' + vCodigo.ToString;
    FQuery.Close;
  end
  else begin
    vOID    := pOID;
    vCodigo := StrToIntDef(vOID.Substring(vOID.IndexOf('_') + 1), 0);
  end;

  FQuery.SQL.Text := 'INSERT INTO OCORRENCIA (' +
                                       'OID, ' +
                                       'OIMEI, ' +
                                       'OCODIGO, ' +
                                       'ODATA, ' +
                                       'OTITULO, ' +
                                       'LID, ' +
                                       'TID, ' +
                                       'OLATITUDE, ' +
                                       'OLONGITUDE) ' +
                              'VALUES (' +
                                       ':OID, ' +
                                       ':OIMEI, ' +
                                       ':OCODIGO, ' +
                                       ':ODATA, ' +
                                       ':OTITULO, ' +
                                       ':LID, ' +
                                       ':TID, ' +
                                       ':OLATITUDE, ' +
                                       ':OLONGITUDE);';

  FQuery.ParamByName('OID').AsString      := vOID;
  FQuery.ParamByName('OIMEI').AsString    := pIMEI;
  FQuery.ParamByName('OCODIGO').AsInteger := vCodigo;
  FQuery.ParamByName('ODATA').AsDateTime  := pData;
  FQuery.ParamByName('OTITULO').AsString  := pTitulo;
  FQuery.ParamByName('LID').AsInteger     := pLID;
  FQuery.ParamByName('TID').AsInteger     := pTID;

  if (pLatitude <> 0) and (pLongitude <> 0) then begin
    FQuery.ParamByName('OLATITUDE').AsFloat  := pLatitude;
    FQuery.ParamByName('OLONGITUDE').AsFloat := pLongitude;
  end
  else begin
    FQuery.ParamByName('OLATITUDE').DataType := TFieldType.ftString;
    FQuery.ParamByName('OLATITUDE').Clear;

    FQuery.ParamByName('OLONGITUDE').DataType := TFieldType.ftString;
    FQuery.ParamByName('OLONGITUDE').Clear;
  end;

  FQuery.ExecSQL;
  Result := vOID;
end;

end.
