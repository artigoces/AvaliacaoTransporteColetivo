unit FPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.SearchBox, FMX.Layouts, FMX.ListBox, FMX.Controls.Presentation,
  FMX.Platform, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.UI, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope, FMX.MultiView, FMX.Objects, uThreadFirebase, UFirebaseObj,
  FMX.Effects, dmDados, U_MsgD, UOcorrenciaObj;

type
  TfrmPrincipal = class(TForm)
    fdqryOcorrencia: TFDQuery;
    fdqryOcorrenciaODATA: TDateTimeField;
    fdqryOcorrenciaOTITULO: TWideStringField;
    fdqryOcorrenciaTDESCRICAO: TWideStringField;
    fdqryOcorrenciaLNUMERO: TIntegerField;
    fdqryLinha: TFDQuery;
    fdqryLinhaLID: TFDAutoIncField;
    fdqryLinhaLNOME: TWideStringField;
    fdqryLinhaLNUMERO: TIntegerField;
    lytPrincipal: TLayout;
    tlbTopo: TToolBar;
    btnAdicionar: TButton;
    btnFiltro: TButton;
    lblTitulo: TLabel;
    lstbxOcorrencias: TListBox;
    srchbxOcorencias: TSearchBox;
    rctnglFiltro: TRectangle;
    lytFiltroData: TLayout;
    lytFiltroDataOpcoes: TLayout;
    rctnglFiltroDataTodas: TRectangle;
    rdbtnFiltroDataTodas: TRadioButton;
    rctnglFiltroDataHoje: TRectangle;
    rdbtnFiltroDataHoje: TRadioButton;
    rctnglFiltroDataUlt30Dias: TRectangle;
    rdbtnFiltroDataUlt30Dias: TRadioButton;
    rctnglFiltroDataUlt7Dias: TRectangle;
    rdbtnFiltroDataUlt7Dias: TRadioButton;
    lytFiltro: TLayout;
    lstbxFiltro: TListBox;
    lstbxgrphdrAtualizar: TListBoxGroupHeader;
    lstbxitmAtualizar: TListBoxItem;
    lstbxgrphdrFiltro: TListBoxGroupHeader;
    lstbxitmFiltroLinha: TListBoxItem;
    lstbxitmFiltroData: TListBoxItem;
    lstbxitmFiltroTipo: TListBoxItem;
    lstbxitmFiltroAplicar: TListBoxItem;
    imgFiltro: TImage;
    lytFiltroLinha: TLayout;
    lstbxLinhas: TListBox;
    srchbxLinha: TSearchBox;
    lytFiltroTipo: TLayout;
    lytFiltroTipoOpcoes: TLayout;
    rctnglFiltroTipoTodos: TRectangle;
    rdbtnFiltroTipoTodos: TRadioButton;
    rctnglFiltroTipoDenuncia: TRectangle;
    rdbtnFiltroTipoDenuncia: TRadioButton;
    rctnglFiltroTipoReclamacao: TRectangle;
    rdbtnFiltroTipoReclamacao: TRadioButton;
    rctnglFiltroTipoElogio: TRectangle;
    rdbtnFiltroTipoElogio: TRadioButton;
    rctnglFiltroTipoSolicitacao: TRectangle;
    rdbtnFiltroTipoSolicitacao: TRadioButton;
    fdqryOcorrenciaOID: TWideStringField;
    procedure btnAdicionarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstbxitmFiltroLinhaClick(Sender: TObject);
    procedure lstbxitmFiltroDataClick(Sender: TObject);
    procedure btnFiltroClick(Sender: TObject);
    procedure lstbxitmFiltroAplicarClick(Sender: TObject);
    procedure lstbxitmFiltroTipoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lstbxitmAtualizarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FFiltroLinha: Integer;
    FThreadFirebase: TThreadFirebaseObj;
    FIMEI: String;
    FFS: TFormatSettings;
    FMsgD: TMsgD;
    FOcorrenciaObj: TOcorrenciaObj;

    procedure AbrirTelaOcorrencia(const pOID: String);
    function GetIMEI: String;

    {$IFDEF ANDROID}
      function HandleAppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
    {$ENDIF}
    procedure ConfigMonitorarEventosApp(const pMonitorar: Boolean);
    procedure ValidarPermissao;
    procedure PopularListaOcorrencias;
    procedure PopularListaLinhas;
    procedure ListaLinhaOnItemTap(Sender: TObject; const Point: TPointF);

    procedure ListaOcorrenciaOnItemTap(Sender: TObject; const Point: TPointF);
    procedure ListaOcorrenciaOnItemClick(Sender: TObject);

    procedure FirebaseLerDados;
    procedure FirebaseOnFimProcessamento(const pItemObj: TFirebaseObj);

    procedure ConfigTelaAguarde(const pExibir: Boolean; const pTitulo: String);
    function Base64ToStream(const pBase64: String): TMemoryStream;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  FOcorrencia,
  {$IFDEF ANDROID}
    Androidapi.JNI.Os,
    Androidapi.JNI.JavaTypes,
    Androidapi.Helpers,
    Androidapi.JNI.Telephony,
    Androidapi.JNI.GraphicsContentViewText,
    Androidapi.JNI.Provider,
    Androidapi.JNIBridge,
  {$ENDIF}
  System.IOUtils,
  System.JSON,
  System.DateUtils,
  System.NetEncoding,
  System.Permissions;

{$R *.fmx}

{ TfrmPrincipal }

procedure TfrmPrincipal.AbrirTelaOcorrencia(const pOID: String);
var
  vThread: TThread;
begin
  ConfigTelaAguarde(True, 'Carregando dados');

  vThread := TThread.CreateAnonymousThread(
                 procedure ()
                 begin
                   TThread.Synchronize(TThread.CurrentThread,
                     procedure
                     begin
                       frmOcorrencia.OID  := pOID;
                       frmOcorrencia.IMEI := FIMEI;
                       frmOcorrencia.ConfigTela;
                       ConfigTelaAguarde(False, '');

                       frmOcorrencia.ShowModal(
                         procedure(ModalResult: TModalResult)
                         begin
                           PopularListaOcorrencias;
                         end
                       );
                     end
                   );
                 end
               );
  vThread.FreeOnTerminate := True;
  vThread.Start;
end;

function TfrmPrincipal.Base64ToStream(const pBase64: String): TMemoryStream;
var
  vBase: TBase64Encoding;
  vArrayBytes: TBytes;
  vBytesStream: TBytesStream;
begin
  Result := nil;

  if pBase64 <> '' then begin
    vBase := TBase64Encoding.Create;
    try
      try
        vArrayBytes  := vBase.DecodeStringToBytes(pBase64);
        vBytesStream := TBytesStream.Create(vArrayBytes);
        vBytesStream.Seek(0, 0);
        Result := TMemoryStream.Create;
        Result.LoadFromStream(vBytesStream);
      except
      end;
    finally
      FreeAndNil(vBytesStream);
      FreeAndNil(vBase);
    end;
  end;
end;

procedure TfrmPrincipal.btnAdicionarClick(Sender: TObject);
begin
  AbrirTelaOcorrencia('');
end;

procedure TfrmPrincipal.btnFiltroClick(Sender: TObject);
begin
  rctnglFiltro.Visible   := not rctnglFiltro.Visible;
  lytFiltroData.Visible  := False;
  lytFiltroLinha.Visible := False;
  lytFiltroTipo.Visible  := False;

  lstbxFiltro.ClearSelection;
end;

procedure TfrmPrincipal.ConfigMonitorarEventosApp(const pMonitorar: Boolean);
var
  vFMXApplicationEventService: IFMXApplicationEventService;
begin
  {$IFDEF ANDROID}
    if TPlatformServices.Current.SupportsPlatformService(IFMXApplicationEventService, IInterface(vFMXApplicationEventService)) then begin
      if pMonitorar then
        vFMXApplicationEventService.SetApplicationEventHandler(HandleAppEvent)
      else
        vFMXApplicationEventService.SetApplicationEventHandler(nil);
    end;
  {$ENDIF}
end;

procedure TfrmPrincipal.ConfigTelaAguarde(const pExibir: Boolean; const pTitulo: String);
begin
  if pExibir then begin
    rctnglFiltro.Visible := False;

    FMsgD.FormMsg := frmPrincipal;
    FMsgD.Title   := pTitulo;
    FMsgD.Text    := 'Aguarde...';
    FMsgD.Height  := 140;
    FMsgD.ShowMsgD;
    Application.ProcessMessages;
  end
  else
    FMsgD.CloseMsgD;
end;

procedure TfrmPrincipal.FirebaseLerDados;
var
  vItemObj: TFirebaseObj;
begin
  vItemObj                    := TFirebaseObj.Create;
  vItemObj.Enviar             := False;
  vItemObj.URL                := 'ocorrencias.json';
  vItemObj.OnFimProcessamento := FirebaseOnFimProcessamento;
  FThreadFirebase.AddItemEnvio(vItemObj);
  ConfigTelaAguarde(True, 'Atualizando dados');
end;

procedure TfrmPrincipal.FirebaseOnFimProcessamento(const pItemObj: TFirebaseObj);
var
  vJSONArray: TJSONArray;
  vJSONValue: TJSONValue;
  vJSONObj: TJSONObject;
  vCount, vCountMsg, vLID, vTID, vMsgID: Integer;
  vData: TDateTime;
  vLatitude, vLongitude: Double;
  vTitulo, vFotoBase64, vIMEI, vOID: String;
  vStream: TMemoryStream;
begin
  try
    if pItemObj.SucessoProc then begin
      dtmdlDados.fdconConexao.StartTransaction;
      try
        try
          dtmdlDados.fdconConexao.ExecSQL('DELETE FROM OCORRENCIA');

          vJSONObj := TJSONObject.Create;
          try
            vJSONObj.Parse(TEncoding.UTF8.GetBytes(pItemObj.Retorno), 0);

            for vCount := 0 to Pred(vJSONObj.Count) do begin
              vJSONValue := vJSONObj.Pairs[vCount].JsonValue;

              vOID       := vJSONValue.GetValue(cteFirebase_Id, '');
              vIMEI      := vJSONValue.GetValue(cteFirebase_IMEI, '');
              vData      := StrToDateTime(vJSONValue.GetValue(cteFirebase_Data, ''), FFS);
              vTitulo    := vJSONValue.GetValue(cteFirebase_Titulo, '');
              vLID       := StrToIntDef(vJSONValue.GetValue(cteFirebase_Linha, ''), 0);
              vTID       := StrToIntDef(vJSONValue.GetValue(cteFirebase_Tipo, ''), 0);
              vLatitude  := StrToFloatDef(vJSONValue.GetValue(cteFirebase_Latitude, ''), 0);
              vLongitude := StrToFloatDef(vJSONValue.GetValue(cteFirebase_Longitude, ''), 0);

              FOcorrenciaObj.InserirOcorrencia(dtmdlDados.fdconConexao,
                                               vData,
                                               vTitulo,
                                               vIMEI,
                                               vLID,
                                               vTID,
                                               vLatitude,
                                               vLongitude,
                                               vOID);

              vJSONArray := vJSONValue.FindValue(cteFirebase_Mensagens) as TJSONArray;
              if Assigned(vJSONArray) then begin
                for vCountMsg := 0 to Pred(vJSONArray.Count) do begin
                  vJSONValue := vJSONArray.Items[vCountMsg];

                  vData       := StrToDateTime(vJSONValue.GetValue(cteFirebase_Mensagens_Data, ''), FFS);
                  vTitulo     := vJSONValue.GetValue(cteFirebase_Mensagens_Msg, '');
                  vMsgID      := StrToIntDef(vJSONValue.GetValue(cteFirebase_Mensagens_Id, ''), 0);
                  vFotoBase64 := vJSONValue.GetValue(cteFirebase_Mensagens_Foto, '');

                  vStream := Base64ToStream(vFotoBase64);

                  FOcorrenciaObj.InserirMensagem(dtmdlDados.fdconConexao,
                                                 vOID,
                                                 vTitulo,
                                                 vData,
                                                 vStream,
                                                 vMsgID);
                end;
              end;
            end;
          finally
            FreeAndNil(vJSONObj);
          end;
        except
          dtmdlDados.fdconConexao.Rollback;
        end;
      finally
        dtmdlDados.fdconConexao.Commit;
      end;
    end
    else
      ShowMessage('Não foi possível atualizar as ocorrências.');
  finally
    PopularListaOcorrencias;
    PopularListaLinhas;
    ConfigTelaAguarde(False, '');
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  FFiltroLinha           := 0;
  rctnglFiltro.Visible   := False;
  lytFiltro.Visible      := True;
  lytFiltroData.Visible  := False;
  lytFiltroData.Width    := 130;
  lytFiltroLinha.Visible := False;
  lytFiltroTipo.Visible  := False;
  lytFiltroTipo.Width    := 130;
  lytFiltroLinha.Width   := rctnglFiltro.Width - lytFiltro.Width - 5;

  rdbtnFiltroDataUlt30Dias.IsChecked := True;
  rdbtnFiltroTipoTodos.IsChecked     := True;

  FOcorrenciaObj := TOcorrenciaObj.Create;

  FThreadFirebase         := TThreadFirebaseObj.Create;
  FThreadFirebase.URLBase := '';

  FIMEI := 'PC';

  FFS.DateSeparator   := '-';
  FFS.ShortDateFormat := 'YYYY-MM-DD';
  FFS.TimeSeparator   := ':';
  FFS.ShortTimeFormat := 'hh:mm:ss';

  FMsgD := TMsgD.Create;

  ConfigTelaAguarde(False, '');
  ConfigMonitorarEventosApp(True);

  {$IFDEF MSWINDOWS}
    FirebaseLerDados;
  {$ENDIF}
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  FThreadFirebase.Desativar;
  FThreadFirebase.Terminate;
  FThreadFirebase.WaitFor;
  FreeAndNil(FThreadFirebase);

  FreeAndNil(FOcorrenciaObj);
  FreeAndNil(FMsgD);
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  frmOcorrencia.ProcAddItemFilaEnvio := FThreadFirebase.AddItemEnvio;
  FThreadFirebase.Ativar;
end;

function TfrmPrincipal.GetIMEI: String;
{$IFDEF ANDROID}
  var
    vObj: JObject;
    vJTelephonyManager: JTelephonyManager;
    vIMEI: String;
{$ENDIF}
begin
  Result := 'PC';

{$IFDEF ANDROID}
  Result := '';
  try
    vObj := TAndroidHelper.Context.getSystemService(TJContext.JavaClass.TELEPHONY_SERVICE);

    if Assigned(vObj) then begin
      vJTelephonyManager := TJTelephonyManager.Wrap((vObj as ILocalObject).GetObjectID);
      if Assigned(vJTelephonyManager) then
        vIMEI := JStringToString(vJTelephonyManager.getDeviceId);
    end;

    if vIMEI = '' then
      vIMEI := JStringToString(TJSettings_Secure.JavaClass.getString(TAndroidHelper.Activity.getContentResolver, TJSettings_Secure.JavaClass.ANDROID_ID));

    Result := vIMEI;
  except
    Result := '';
  end;
  {$ENDIF}
end;

procedure TfrmPrincipal.ListaLinhaOnItemTap(Sender: TObject; const Point: TPointF);
var
  vItem: TListBoxItem;
begin
  lstbxLinhas.ClearSelection;

  vItem            := Sender as TListBoxItem;
  vItem.IsSelected := True;
  FFiltroLinha     := vItem.Tag;
end;

procedure TfrmPrincipal.ListaOcorrenciaOnItemClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
    if Assigned((Sender as TListBoxItem).OnTap) then
      (Sender as TListBoxItem).OnTap(Sender, TPointF.Zero);
  {$ENDIF}
end;

procedure TfrmPrincipal.ListaOcorrenciaOnItemTap(Sender: TObject; const Point: TPointF);
var
  vItem: TListBoxItem;
begin
  vItem := Sender as TListBoxItem;
  AbrirTelaOcorrencia(vItem.TagString);
end;

procedure TfrmPrincipal.lstbxitmAtualizarClick(Sender: TObject);
begin
  FirebaseLerDados;
end;

procedure TfrmPrincipal.lstbxitmFiltroAplicarClick(Sender: TObject);
begin
  PopularListaOcorrencias;
  btnFiltro.OnClick(nil);
end;

procedure TfrmPrincipal.lstbxitmFiltroDataClick(Sender: TObject);
begin
  lytFiltroLinha.Visible := False;
  lytFiltroTipo.Visible  := False;
  lytFiltroData.Visible  := True;
end;

procedure TfrmPrincipal.lstbxitmFiltroLinhaClick(Sender: TObject);
begin
  lytFiltroData.Visible  := False;
  lytFiltroTipo.Visible  := False;
  lytFiltroLinha.Visible := True;
end;

procedure TfrmPrincipal.lstbxitmFiltroTipoClick(Sender: TObject);
begin
  lytFiltroLinha.Visible := False;
  lytFiltroData.Visible  := False;
  lytFiltroTipo.Visible  := True;
end;

procedure TfrmPrincipal.PopularListaLinhas;
var
  vItem: TListBoxItem;
begin
  if lstbxLinhas.Count = 0 then begin
    fdqryLinha.Active := True;
    fdqryLinha.First;

    lstbxLinhas.BeginUpdate;
    try
      lstbxLinhas.Clear;

      vItem                    := TListBoxItem.Create(lstbxLinhas);
      vItem.ItemData.Text      := 'Todas';
      vItem.ItemData.Accessory := TListBoxItemData.TAccessory.aNone;
      vItem.Selectable         := True;
      vItem.IsSelected         := True;
      vItem.Height             := 54;
      vItem.Tag                := 0;
      vItem.OnTap              := ListaLinhaOnItemTap;
      vItem.OnClick            := ListaOcorrenciaOnItemClick;
      vItem.HitTest            := True;
      lstbxLinhas.AddObject(vItem);

      while not fdqryLinha.Eof do begin
        vItem                    := TListBoxItem.Create(lstbxLinhas);
        vItem.ItemData.Text      := Format('%s - %s',
                                           [fdqryLinhaLNUMERO.AsString,
                                            fdqryLinhaLNOME.AsString]);
        vItem.ItemData.Accessory := TListBoxItemData.TAccessory.aNone;
        vItem.Selectable         := True;
        vItem.Height             := 54;
        vItem.Tag                := fdqryLinhaLID.AsInteger;
        vItem.OnTap              := ListaLinhaOnItemTap;
        vItem.OnClick            := ListaOcorrenciaOnItemClick;
        vItem.HitTest            := True;

        lstbxLinhas.AddObject(vItem);

        fdqryLinha.Next;
      end;
    finally
      lstbxLinhas.EndUpdate;
      fdqryLinha.Close;
    end;
  end;
end;

procedure TfrmPrincipal.PopularListaOcorrencias;
var
  vItem: TListBoxItem;
  vHeader: TListBoxGroupHeader;
  vTipoDesc, vFiltroData, vFiltroLinha, vFiltroTipo, vFiltro: String;

  function GetDataStr(const pData: TDateTime): String;
  begin
    Result := QuotedStr(FormatDateTime('YYYY-MM-DD', pData));
  end;

  function GetFiltroTipo(const pRadioButton: TRadioButton): String;
  begin
    Result := 'TID = ' + pRadioButton.Tag.ToString;
  end;

begin
  fdqryOcorrencia.Active := True;
  fdqryOcorrencia.Refresh;

  vFiltro      := '';
  vFiltroData  := '';
  vFiltroLinha := '';
  vFiltroTipo  := '';

  if rdbtnFiltroDataHoje.IsChecked then
    vFiltroData := ' = ' + GetDataStr(Now)
  else if rdbtnFiltroDataUlt7Dias.IsChecked then
    vFiltroData := ' >= ' + GetDataStr(IncDay(Now, -7))
  else if rdbtnFiltroDataUlt30Dias.IsChecked then
    vFiltroData := ' >= ' + GetDataStr(IncDay(Now, -30));

  if vFiltroData <> '' then
    vFiltro := 'DATA_FILTRO ' + vFiltroData;

  if FFiltroLinha > 0 then
    vFiltroLinha := 'LID = ' + FFiltroLinha.ToString;

  if vFiltroLinha <> '' then begin
    if vFiltro <> '' then
      vFiltro := vFiltro + ' AND ';

    vFiltro := vFiltro + vFiltroLinha;
  end;

  if rdbtnFiltroTipoDenuncia.IsChecked then
    vFiltroTipo := GetFiltroTipo(rdbtnFiltroTipoDenuncia)
  else if rdbtnFiltroTipoReclamacao.IsChecked then
    vFiltroTipo := GetFiltroTipo(rdbtnFiltroTipoReclamacao)
  else if rdbtnFiltroTipoElogio.IsChecked then
    vFiltroTipo := GetFiltroTipo(rdbtnFiltroTipoElogio)
  else if rdbtnFiltroTipoSolicitacao.IsChecked then
    vFiltroTipo := GetFiltroTipo(rdbtnFiltroTipoSolicitacao);

  if vFiltroTipo <> '' then begin
    if vFiltro <> '' then
      vFiltro := vFiltro + ' AND ';

    vFiltro := vFiltro + vFiltroTipo;
  end;
  

  fdqryOcorrencia.Filtered := False;
  fdqryOcorrencia.Filter   := vFiltro;
  fdqryOcorrencia.Filtered := True;
  fdqryOcorrencia.First;

  vTipoDesc := '';

  lstbxOcorrencias.BeginUpdate;
  try
    lstbxOcorrencias.Clear;

    while not fdqryOcorrencia.Eof do begin
      if vTipoDesc <> fdqryOcorrenciaTDESCRICAO.AsString then begin
        vTipoDesc := fdqryOcorrenciaTDESCRICAO.AsString;

        vHeader      := TListBoxGroupHeader.Create(lstbxOcorrencias);
        vHeader.Text := vTipoDesc;
        lstbxOcorrencias.AddObject(vHeader);
      end;

      vItem                    := TListBoxItem.Create(lstbxOcorrencias);
      vItem.ItemData.Text      := Format('%s - Linha: %d',
                                         [FormatDateTime('DD/MM/YYYY hh:mm', fdqryOcorrenciaODATA.AsDateTime),
                                          fdqryOcorrenciaLNUMERO.AsInteger]);
      vItem.ItemData.Detail    := fdqryOcorrenciaOTITULO.AsString;
      vItem.ItemData.Accessory := TListBoxItemData.TAccessory.aMore;
      vItem.Selectable         := False;
      vItem.Height             := 54;
      vItem.TagString          := fdqryOcorrenciaOID.AsString;
      vItem.HitTest            := True;
      vItem.OnTap              := ListaOcorrenciaOnItemTap;
      vItem.OnClick            := ListaOcorrenciaOnItemClick;

      lstbxOcorrencias.AddObject(vItem);

      fdqryOcorrencia.Next;
    end;
  finally
    lstbxOcorrencias.EndUpdate;
  end;
end;

procedure TfrmPrincipal.ValidarPermissao;
var
  vArray: TArray<String>;
begin
  ConfigMonitorarEventosApp(False);

  {$IFDEF ANDROID}
    //valida as permissões em tempo de execução
    SetLength(vArray, 5);
    vArray[0] := JStringToString(TJManifest_permission.JavaClass.ACCESS_FINE_LOCATION);
    vArray[1] := JStringToString(TJManifest_permission.JavaClass.CAMERA);
    vArray[2] := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
    vArray[3] := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
    vArray[4] := JStringToString(TJManifest_permission.JavaClass.READ_PHONE_STATE);

    PermissionsService.RequestPermissions(vArray,
      procedure(const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>)
      var
        vConcedido: Boolean;
        vCount: Integer;
      begin
        vConcedido := True;
        for vCount := 0 to Length(AGrantResults) - 1 do
          vConcedido := vConcedido and (AGrantResults[vCount] = TPermissionStatus.Granted);

        if not ((Length(AGrantResults) = Length(vArray)) and vConcedido) then
          ShowMessage('Permissão não foi concedida')
        else begin
          FIMEI := GetIMEI;
          FirebaseLerDados;
        end;
      end);
  {$ENDIF}
end;

{$IFDEF ANDROID}
  function TfrmPrincipal.HandleAppEvent(AAppEvent: TApplicationEvent;  AContext: TObject): Boolean;
  begin
    if AAppEvent = TApplicationEvent.FinishedLaunching then
      ValidarPermissao;
  end;
{$ENDIF}

end.
