unit FOcorrencia;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.TabControl, FMX.Maps, System.Sensors,
  System.Sensors.Components, FMX.Layouts, FMX.ListBox, FMX.Objects, FMX.Edit,
  FMX.Media, FMX.MultiView, FMX.MediaLibrary.Actions, FMX.StdActns,
  System.Actions, FMX.ActnList, FMX.SearchBox, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, dmDados,
  FMX.DateTimeCtrls, System.Generics.Collections, UFirebaseObj, FMX.Effects,
  U_MsgD, UOcorrenciaObj;

type
  TMensagemObj = class
  private
    FMensagem: string;
    FData: TDateTime;
    FBitmap: TBitmap;
    FLadoDireito: Boolean;
    procedure SetData(const Value: TDateTime);
    procedure SetMensagem(const Value: string);
    procedure SetBitmap(const Value: TBitmap);
    procedure SetLadoDireito(const Value: Boolean);
  published
    property Data: TDateTime read FData write SetData;
    property Mensagem: string read FMensagem write SetMensagem;
    property LadoDireito: Boolean read FLadoDireito write SetLadoDireito;
    property Bitmap: TBitmap read FBitmap write SetBitmap;
  end;

  TfrmOcorrencia = class(TForm)
    tlbTopo: TToolBar;
    btnVoltar: TButton;
    lblTitulo: TLabel;
    tbcCadastro: TTabControl;
    tbtmCadDados: TTabItem;
    tbtmCadMapa: TTabItem;
    tbtmCadMensagens: TTabItem;
    tbcPrincipal: TTabControl;
    tbtmPrincTipo: TTabItem;
    tbtmPrincCadastro: TTabItem;
    grdpnlytTipos: TGridPanelLayout;
    actlstAcoes: TActionList;
    Action1: TAction;
    actFotoBiblioteca: TTakePhotoFromLibraryAction;
    actFotoCamera: TTakePhotoFromCameraAction;
    mpvwMapa: TMapView;
    rctnglMensagem: TRectangle;
    rndrctMensagem: TRoundRect;
    edtMensagem: TEdit;
    imgMensagemEnviar: TImage;
    lytMensagem: TLayout;
    lstbxDados: TListBox;
    lstbxitmDadosLinha: TListBoxItem;
    tbtmPrincLinha: TTabItem;
    lstbxLinhas: TListBox;
    srchbxLinha: TSearchBox;
    fdqryLinha: TFDQuery;
    fdqryLinhaLID: TFDAutoIncField;
    fdqryLinhaLNOME: TWideStringField;
    fdqryLinhaLNUMERO: TIntegerField;
    lstbxitmDadosData: TListBoxItem;
    lytDadosData: TLayout;
    dtedtDadosData: TDateEdit;
    tmedtDadosHora: TTimeEdit;
    lstbxitmDadosTitulo: TListBoxItem;
    edtDadosTitulo: TEdit;
    fdqryInsert: TFDQuery;
    rctnglTipoDenuncia: TRectangle;
    imgTipoDenuncia: TImage;
    rctnglTipoReclamacao: TRectangle;
    imgTipoReclamacao: TImage;
    rctnglTipoSolicitacao: TRectangle;
    imgTipoSolicitacao: TImage;
    rctnglTipoElogio: TRectangle;
    imgTipoElogio: TImage;
    btnMensagemFoto: TButton;
    lytMensagemEnviar: TLayout;
    lstbxMensagemFotoMenu: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    lstbxMensagem: TListBox;
    imgMensagem: TImage;
    rctnglMensagemFoto: TRectangle;
    lytConfirmar: TLayout;
    imgConfirmar: TImage;
    lstbxgrphdrData: TListBoxGroupHeader;
    lstbxgrphdrTitulo: TListBoxGroupHeader;
    lstbxgrphdrLinha: TListBoxGroupHeader;
    lctnsnsrSensorGPS: TLocationSensor;
    procedure btnVoltarClick(Sender: TObject);
    procedure imgTipoDenunciaClick(Sender: TObject);
    procedure actFotoCameraDidFinishTaking(Image: TBitmap);
    procedure actFotoBibliotecaDidFinishTaking(Image: TBitmap);
    procedure imgFoto1Click(Sender: TObject);
    procedure lstbxitmFotoCameraClick(Sender: TObject);
    procedure lstbxitmFotoAlbumClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mpvwMapaMapClick(const Position: TMapCoordinate);
    procedure edtMensagemKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure lstbxitmDadosLinhaTap(Sender: TObject; const Point: TPointF);
    procedure FormDestroy(Sender: TObject);
    procedure lstbxitmDadosLinhaClick(Sender: TObject);
    procedure lstbxitmDadosTituloTap(Sender: TObject; const Point: TPointF);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure lytMensagemEnviarClick(Sender: TObject);
    procedure btnMensagemFotoClick(Sender: TObject);
    procedure imgMensagemClick(Sender: TObject);
    procedure lytConfirmarClick(Sender: TObject);
    procedure tbcCadastroChange(Sender: TObject);
    procedure lctnsnsrSensorGPSLocationChanged(Sender: TObject;
      const OldLocation, NewLocation: TLocationCoord2D);
  private
    { Private declarations }
    FListaMsg: TObjectList<TMensagemObj>;
    FMarker: TMapMarker;
    FTipoID: Integer;
    FOID: String;
    FMensagemAbrirMenuFoto: Boolean;
    FProcAddItemFilaEnvio: TProcAddObjFilaEnvio;
    FIMEI: String;
    FEdicao: Boolean;
    FMsgD: TMsgD;
    FOcorrenciaObj: TOcorrenciaObj;

    procedure SalvarDados;
    procedure LerDados;
    procedure LimparTela;
    procedure ConfigTitulo;
    //configura aba de dados
    procedure ConfirmarTipo(const pTipoID: Integer);
    //
    procedure MensagemAddLista(const pMsg: String; const pData: TDateTime; const pLadoDireito: Boolean; const pBitmap: TBitmap = nil);
    procedure MensagemItemOnTap(Sender: TObject; const Point: TPointF);
    //
    procedure FotoCamera;
    procedure FotoAlbum;
    procedure FotoAdd(const pBitmap: TBitmap; const pData: TDateTime = 0);
    procedure FotoAbrirMenuSelecao(const pAbrir: Boolean);
    //
    procedure MapaAddMarker(const pLatitude, pLongitude: Double);
    procedure MapaRemoverMarker;
    //
    procedure PopularListaLinhas;
    procedure ListaLinhaOnItemTap(Sender: TObject; const Point: TPointF);
    procedure SetOID(const Value: String);

    //teclado
    function TecladoVisivel(const pOcultar: Boolean = False): Boolean;
    procedure SetProcAddItemFilaEnvio(const Value: TProcAddObjFilaEnvio);
    procedure SetIMEI(const Value: String);

    function StreamToBase64(const pMemStream: TMemoryStream): String;
     procedure ConfigTelaAguarde(const pExibir: Boolean);
  public
    { Public declarations }
    procedure ConfigTela;
  published
    property OID: String read FOID write SetOID;
    property ProcAddItemFilaEnvio: TProcAddObjFilaEnvio read FProcAddItemFilaEnvio write SetProcAddItemFilaEnvio;
    property IMEI: String read FIMEI write SetIMEI;
  end;

var
  frmOcorrencia: TfrmOcorrencia;

implementation

{$R *.fmx}

uses
  FMX.VirtualKeyboard,
  FMX.Platform,
  System.JSON,
  System.NetEncoding,
  System.DateUtils;

procedure TfrmOcorrencia.actFotoBibliotecaDidFinishTaking(Image: TBitmap);
begin
  FotoAdd(Image);
end;

procedure TfrmOcorrencia.actFotoCameraDidFinishTaking(Image: TBitmap);
begin
  FotoAdd(Image);
end;

procedure TfrmOcorrencia.FormCreate(Sender: TObject);
begin
  FOID           := '';
  FMarker        := nil;
  FListaMsg      := TObjectList<TMensagemObj>.Create(True);
  FMsgD          := TMsgD.Create;
  FOcorrenciaObj := TOcorrenciaObj.Create;
end;

procedure TfrmOcorrencia.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FListaMsg);
  FreeAndNil(FMsgD);
  FreeAndNil(FOcorrenciaObj);
end;

procedure TfrmOcorrencia.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkHardwareBack then begin
    if tbcPrincipal.ActiveTab = tbtmPrincLinha then begin
      tbcPrincipal.ActiveTab := tbtmPrincCadastro;
      Key := 0;
    end
    else if (tbcCadastro.ActiveTab = tbtmCadMensagens) and lstbxMensagemFotoMenu.Visible then begin
      FotoAbrirMenuSelecao(False);
      Key := 0;
    end
    else if TecladoVisivel(True) then
      Key := 0;
  end
  else if Key = vkReturn then begin
    if (Sender is TEdit) and ((Sender as TEdit) <> edtMensagem) then begin
      TecladoVisivel(True);
      tbcCadastro.ActiveTab.SetFocus;
    end;
  end;
end;

procedure TfrmOcorrencia.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  if tbcCadastro.ActiveTab = tbtmCadMensagens then begin
    lytMensagem.Align := TAlignLayout.Client;
    if FMensagemAbrirMenuFoto then
      FotoAbrirMenuSelecao(True);
  end;
end;

procedure TfrmOcorrencia.FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  if tbcCadastro.ActiveTab = tbtmCadMensagens then begin
    lytMensagem.Align  := TAlignLayout.None;
    lytMensagem.Height := lytMensagem.Height - Bounds.Height;
  end;
end;

procedure TfrmOcorrencia.FotoAbrirMenuSelecao(const pAbrir: Boolean);
begin
  if TecladoVisivel(True) then
    FMensagemAbrirMenuFoto := True
  else begin
    FMensagemAbrirMenuFoto        := False;
    lstbxMensagemFotoMenu.Visible := pAbrir;
    rndrctMensagem.Enabled        := not pAbrir;
    lytMensagemEnviar.Enabled     := rndrctMensagem.Enabled;
  end;
end;

procedure TfrmOcorrencia.FotoAdd(const pBitmap: TBitmap; const pData: TDateTime = 0);
var
  vData: TDateTime;
begin
  if pData = 0 then
    vData := Now
  else
    vData := pData;

  MensagemAddLista('', vData, True, pBitmap);
  FotoAbrirMenuSelecao(False);
end;

procedure TfrmOcorrencia.FotoAlbum;
begin
  actFotoBiblioteca.Execute;
end;

procedure TfrmOcorrencia.FotoCamera;
var
  vBitmap: TBitmap;
begin
  {$IFDEF ANDROID}
    actFotoCamera.Execute;
  {$ENDIF}

  {$IFDEF MSWINDOWS}
    vBitmap := TBitmap.Create;
    vBitmap.LoadFromFile('..\imagens\onibus-vandalizados.jpg');
    MensagemAddLista('', Now, True, vBitmap);
  {$ENDIF}
end;

procedure TfrmOcorrencia.btnMensagemFotoClick(Sender: TObject);
begin
  FotoAbrirMenuSelecao(not lstbxMensagemFotoMenu.Visible);
end;

procedure TfrmOcorrencia.btnVoltarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmOcorrencia.ConfigTela;
begin
  lctnsnsrSensorGPS.Active := True;
  LimparTela;

  if FOID = '' then begin
    tbcPrincipal.ActiveTab := tbtmPrincTipo;
    mpvwMapa.OnMapClick    := mpvwMapaMapClick;
  end
  else begin
    LerDados;

    lytConfirmar.HitTest := FEdicao;
    imgConfirmar.Visible := FEdicao;

    ConfigTitulo;
    tbcPrincipal.ActiveTab := tbtmPrincCadastro;
    tbcCadastro.ActiveTab  := tbtmCadDados;
  end;
end;

procedure TfrmOcorrencia.ConfigTelaAguarde(const pExibir: Boolean);
begin
  if pExibir then begin
    FMsgD.FormMsg := frmOcorrencia;
    FMsgD.Title   := 'Salvando ocorrência';
    FMsgD.Text    := 'Aguarde...';
    FMsgD.Height  := 150;
    FMsgD.ShowMsgD;
    Application.ProcessMessages;
  end
  else
    FMsgD.CloseMsgD;
end;

procedure TfrmOcorrencia.ConfigTitulo;
begin
  case FTipoID of
    1: lblTitulo.Text := 'Denúncia';
    2: lblTitulo.Text := 'Elogio';
    3: lblTitulo.Text := 'Reclamação';
    4: lblTitulo.Text := 'Solicitação';
  end;
end;

procedure TfrmOcorrencia.ConfirmarTipo(const pTipoID: Integer);
begin
  tbcPrincipal.ActiveTab := tbtmPrincCadastro;
  tbcCadastro.ActiveTab  := tbtmCadDados;
  FTipoID                := pTipoID;
  ConfigTitulo;
end;

procedure TfrmOcorrencia.edtMensagemKeyUp(Sender: TObject; var Key: Word;  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    lytMensagemEnviarClick(nil);
end;

procedure TfrmOcorrencia.imgFoto1Click(Sender: TObject);
var
  vImage: TImage;
begin
  vImage := Sender as TImage;

  if not vImage.Bitmap.IsEmpty then begin
    MessageDlg('Deseja remover foto?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
      procedure(const AResult: System.UITypes.TModalResult)
      begin
        if AResult = mrYes then
          vImage.Bitmap := nil;
      end
    );
  end;
end;

procedure TfrmOcorrencia.imgMensagemClick(Sender: TObject);
begin
  rctnglMensagemFoto.Visible := False;
end;

procedure TfrmOcorrencia.imgTipoDenunciaClick(Sender: TObject);
var
  vImagem: TImage;
begin
  vImagem := Sender as TImage;
  ConfirmarTipo(vImagem.Tag);
end;

procedure TfrmOcorrencia.lctnsnsrSensorGPSLocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
var
  vLocalizacao: TMapCoordinate;
begin
  if (NewLocation.Latitude <> 0) and (NewLocation.Longitude <> 0) and
     (mpvwMapa.Location.Latitude = 0) and (mpvwMapa.Location.Longitude = 0) then begin
    vLocalizacao.Latitude  := NewLocation.Latitude;
    vLocalizacao.Longitude := NewLocation.Longitude;
    mpvwMapa.Location      := vLocalizacao;

    MapaAddMarker(mpvwMapa.Location.Latitude, mpvwMapa.Location.Longitude);

    mpvwMapa.Zoom := 15;
    lctnsnsrSensorGPS.Active := False;
  end;
end;

procedure TfrmOcorrencia.LerDados;
var
  vStream: TMemoryStream;
  vBitmap: TBitmap;
  vLadoDireito: Boolean;
begin
  try
    fdqryInsert.Close;
    fdqryInsert.SQL.Text           := 'SELECT O.ODATA, O.OTITULO, O.LID, L.LNUMERO, L.LNOME, O.OLATITUDE, O.OLONGITUDE, O.TID, O.OIMEI FROM OCORRENCIA O JOIN LINHA L ON O.LID = L.LID WHERE OID = :OID';
    fdqryInsert.Params[0].AsString := FOID;
    fdqryInsert.Open;

    FEdicao             := FIMEI = fdqryInsert.FieldByName('OIMEI').AsString;
    FTipoID             := fdqryInsert.FieldByName('TID').AsInteger;
    dtedtDadosData.Date := DateOf(fdqryInsert.FieldByName('ODATA').AsDateTime);
    tmedtDadosHora.Time := TimeOf(fdqryInsert.FieldByName('ODATA').AsDateTime);
    edtDadosTitulo.Text := fdqryInsert.FieldByName('OTITULO').AsString;

    lstbxitmDadosLinha.Text := Format('%s - %s',
                                           [fdqryInsert.FieldByName('LNUMERO').AsString,
                                            fdqryInsert.FieldByName('LNOME').AsString]);
    lstbxitmDadosLinha.Tag := fdqryInsert.FieldByName('LID').AsInteger;

    if not fdqryInsert.FieldByName('OLATITUDE').IsNull then
      MapaAddMarker(fdqryInsert.FieldByName('OLATITUDE').AsFloat, fdqryInsert.FieldByName('OLONGITUDE').AsFloat);

    //mensagens
    fdqryInsert.Close;
    fdqryInsert.SQL.Text           := 'SELECT MID, MDATA, MMSG, MIMAGEM, MUSUARIO FROM MENSAGEM WHERE OID = :OID';
    fdqryInsert.Params[0].AsString := FOID;
    fdqryInsert.Open;
    fdqryInsert.First;

     while not fdqryInsert.Eof do begin
       vBitmap := nil;

       if not fdqryInsert.FieldByName('MIMAGEM').IsNull then begin
         vStream := TMemoryStream.Create;
         try
           vStream.Position := 0;
           (fdqryInsert.FieldByName('MIMAGEM') as TBlobField).SaveToStream(vStream);
           vStream.Position := 0;
           vBitmap := TBitmap.CreateFromStream(vStream);
         finally
           FreeAndNil(vStream);
         end;
       end;

       vLadoDireito := fdqryInsert.FieldByName('MUSUARIO').AsString = 'S';
       MensagemAddLista(fdqryInsert.FieldByName('MMSG').AsString, fdqryInsert.FieldByName('MDATA').AsDateTime, vLadoDireito, vBitmap);

       fdqryInsert.Next;
     end;
  finally
    fdqryInsert.Close;
  end;
end;

procedure TfrmOcorrencia.LimparTela;
begin
  FEdicao              := False;
  lytConfirmar.HitTest := True;
  imgConfirmar.Visible := True;

  rctnglMensagemFoto.Visible := False;
  FMensagemAbrirMenuFoto     := False;

  FListaMsg.Clear;

  PopularListaLinhas;
  MapaRemoverMarker;

  lstbxitmDadosLinha.Text := 'Selecione';
  lstbxitmDadosLinha.Tag  := -1;
  edtDadosTitulo.Text     := '';

  dtedtDadosData.Date := Now;
  tmedtDadosHora.Time := Now;

  lstbxMensagem.BeginUpdate;
  try
    lstbxMensagem.Clear;
  finally
    lstbxMensagem.EndUpdate;
  end;

  lytMensagem.Align := TAlignLayout.Client;
  FotoAbrirMenuSelecao(False);

  ConfigTelaAguarde(False);
end;

procedure TfrmOcorrencia.ListaLinhaOnItemTap(Sender: TObject; const Point: TPointF);
var
  vItem: TListBoxItem;
begin
  vItem := Sender as TListBoxItem;
  lstbxitmDadosLinha.Text := vItem.Text;
  lstbxitmDadosLinha.Tag  := vItem.Tag;
  tbcPrincipal.ActiveTab  := tbtmPrincCadastro;
end;

procedure TfrmOcorrencia.lstbxitmDadosLinhaClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
    if Assigned((Sender as TListBoxItem).OnTap) then
      (Sender as TListBoxItem).OnTap(Sender, TPointF.Zero);
  {$ENDIF}
end;

procedure TfrmOcorrencia.lstbxitmDadosLinhaTap(Sender: TObject; const Point: TPointF);
begin
  tbcPrincipal.ActiveTab := tbtmPrincLinha;
end;

procedure TfrmOcorrencia.lstbxitmDadosTituloTap(Sender: TObject; const Point: TPointF);
begin
  edtDadosTitulo.SetFocus;
end;

procedure TfrmOcorrencia.lstbxitmFotoAlbumClick(Sender: TObject);
begin
  FotoAlbum;
end;

procedure TfrmOcorrencia.lstbxitmFotoCameraClick(Sender: TObject);
begin
  FotoCamera;
end;

procedure TfrmOcorrencia.lytConfirmarClick(Sender: TObject);
begin
  SalvarDados;
end;

procedure TfrmOcorrencia.lytMensagemEnviarClick(Sender: TObject);
begin
  if edtMensagem.Text <> '' then begin
    MensagemAddLista(edtMensagem.Text, Now, True);
    edtMensagem.Text := '';
  end;
end;

procedure TfrmOcorrencia.MapaAddMarker(const pLatitude, pLongitude: Double);
var
  vMarker: TMapMarkerDescriptor;
  vCoord: TMapCoordinate;
begin
  MapaRemoverMarker;

  vCoord := TMapCoordinate.Create(pLatitude, pLongitude);

  //adiciona marker no mapa
  vMarker            := TMapMarkerDescriptor.Create(vCoord);
  vMarker.Title      := 'Local da ocorrência';
  vMarker.Visible    := True;
  vMarker.Draggable  := False;
  vMarker.Appearance := TMarkerAppearance.Billboard;

  FMarker := mpvwMapa.AddMarker(vMarker)
end;

procedure TfrmOcorrencia.MapaRemoverMarker;
begin
  if Assigned(FMarker) then begin
    FMarker.Remove;
    FreeAndNil(FMarker);
  end;
end;

procedure TfrmOcorrencia.MensagemAddLista(const pMsg: String; const pData: TDateTime; const pLadoDireito: Boolean; const pBitmap: TBitmap = nil);
var
  vRetangulo: TCalloutRectangle;
  vLabel: TText;
  vImage: TImage;
  vMsgObj: TMensagemObj;
  vItem: TListBoxItem;
  vAlinhamento: TTextAlign;
  vAjuste: Integer;
begin
  lstbxMensagem.BeginUpdate;
  try
    vItem                := TListBoxItem.Create(lstbxMensagem);
    vItem.Selectable     := False;
    vItem.Margins.Top    := 2;
    vItem.Margins.Bottom := 5;
    vItem.HitTest        := True;
    vItem.OnTap          := MensagemItemOnTap;
    vItem.OnClick        := lstbxitmDadosLinhaClick;

    vRetangulo                := TCalloutRectangle.Create(vItem);
    vRetangulo.Parent         := vItem;
    vRetangulo.Align          := TAlignLayout.Top;
    vRetangulo.Margins.Top    := 10;
    vRetangulo.Margins.Bottom := 10;
    vRetangulo.Margins.Left   := 5;
    vRetangulo.Height         := 40;//70
    vRetangulo.Stroke.Kind    := TBrushKind.None;
    vRetangulo.HitTest        := False;

    vLabel               := TText.Create(vRetangulo);
    vLabel.Parent        := vRetangulo;
    vLabel.Align         := TAlignLayout.Top;
    vLabel.Text          := FormatDateTime('hh:mm', pData) + 'h ' + FormatDateTime('DD/MM/YYYY', pData);
    vLabel.Margins.Left  := 15;
    vLabel.Margins.Right := 15;
    vLabel.Height        := 20;

    if pLadoDireito then begin
      vRetangulo.CalloutPosition := TCalloutPosition.Right;
      vAlinhamento               := TTextAlign.Trailing;
    end
    else begin
      vRetangulo.CalloutPosition := TCalloutPosition.Left;
      vAlinhamento               := TTextAlign.Leading;
    end;

    vLabel.TextSettings.HorzAlign := vAlinhamento;

    if Assigned(pBitmap) then begin
      vRetangulo.Height := 150;

      vImage         := TImage.Create(vRetangulo);
      vImage.Parent  := vRetangulo;
      vImage.Align   := TAlignLayout.Client;
      vImage.Bitmap  := pBitmap;
      vImage.HitTest := False;
    end
    else begin
      vLabel                        := TText.Create(vRetangulo);
      vLabel.Parent                 := vRetangulo;
      vLabel.Align                  := TAlignLayout.Client;
      vLabel.Text                   := pMsg;
      vLabel.Margins.Right          := 15;
      vLabel.Margins.Left           := 5;
      vLabel.Width                  := vRetangulo.Width - 20;
      vLabel.WordWrap               := True;
      vLabel.AutoSize               := False;
      vLabel.TextSettings.HorzAlign := vAlinhamento;

      vAjuste := 0;
      if Length(pMsg) > 80 then
        vAjuste := 10;

      vRetangulo.Height := vRetangulo.Height + vLabel.Height + vAjuste;
    end;

    vMsgObj             := TMensagemObj.Create;
    vMsgObj.Data        := pData;
    vMsgObj.Mensagem    := pMsg;
    vMsgObj.LadoDireito := pLadoDireito;
    vMsgObj.Bitmap      := pBitmap;
    FListaMsg.Add(vMsgObj);

    vItem.Height := vRetangulo.Height;
    vItem.AddObject(vRetangulo);
    lstbxMensagem.AddObject(vItem);
  finally
    lstbxMensagem.EndUpdate;
    lstbxMensagem.ScrollToItem(vItem);
  end;
end;

procedure TfrmOcorrencia.MensagemItemOnTap(Sender: TObject; const Point: TPointF);
var
  vItem: TListBoxItem;
begin
  vItem := Sender as TListBoxItem;

  if Assigned(FListaMsg[vItem.Index].Bitmap) then begin
    imgMensagem.Bitmap         := FListaMsg[vItem.Index].Bitmap;
    rctnglMensagemFoto.Visible := True;
  end;
end;

procedure TfrmOcorrencia.mpvwMapaMapClick(const Position: TMapCoordinate);
begin
  MapaAddMarker(Position.Latitude, Position.Longitude);
end;

procedure TfrmOcorrencia.PopularListaLinhas;
var
  vItem: TListBoxItem;
begin
  if lstbxLinhas.Count = 0 then begin
    fdqryLinha.Active := True;
    fdqryLinha.First;

    lstbxLinhas.BeginUpdate;
    try
      lstbxLinhas.Clear;

      while not fdqryLinha.Eof do begin
        vItem                    := TListBoxItem.Create(lstbxLinhas);
        vItem.ItemData.Text      := Format('%s - %s',
                                           [fdqryLinhaLNUMERO.AsString,
                                            fdqryLinhaLNOME.AsString]);
        vItem.ItemData.Accessory := TListBoxItemData.TAccessory.aMore;
        vItem.Selectable         := False;
        vItem.Height             := 54;
        vItem.Tag                := fdqryLinhaLID.AsInteger;
        vItem.OnTap              := ListaLinhaOnItemTap;
        vItem.OnClick            := lstbxitmDadosLinhaClick;
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

procedure TfrmOcorrencia.SalvarDados;
var
  vMsgID: Integer;
  vStream: TMemoryStream;
  vMsg, vTitulo, vOcorrenciaID: String;
  vFirebaseObj: TFirebaseObj;
  vJSON, vJSONMsg: TJSONObject;
  vJSONArrayMsg: TJSONArray;
  vLatitude, vLongitude: Double;
  vThread: TThread;
  vConexao: TFDConnection;
begin
  vMsg := '';
  vTitulo := Trim(edtDadosTitulo.Text);

  if vTitulo = '' then begin
    vMsg := 'Informe o título';
  end
  else if lstbxitmDadosLinha.Tag = -1 then begin
    vMsg := 'Selecione a linha';
    lstbxitmDadosLinhaClick(lstbxitmDadosLinha);
  end;

  if vMsg <> '' then
    ShowMessage(vMsg)
  else begin
    ConfigTelaAguarde(True);

    vThread := TThread.CreateAnonymousThread(
                 procedure ()
                 var
                   vMsgObj: TMensagemObj;
                 begin
                   vConexao := TFDConnection.Create(nil);
                   try
                     vConexao.Assign(dtmdlDados.fdconConexao);

                     vConexao.StartTransaction;
                     try
                       vJSON         := TJSONObject.Create;
                       vJSONArrayMsg := TJSONArray.Create;

                       if Assigned(FMarker) then begin
                         vLatitude  := FMarker.Descriptor.Position.Latitude;
                         vLongitude := FMarker.Descriptor.Position.Longitude;
                       end
                       else begin
                         vLatitude  := 0;
                         vLongitude := 0;
                       end;

                       if FEdicao then begin
                         fdqryInsert.Close;
                         fdqryInsert.SQL.Text           := 'DELETE FROM OCORRENCIA WHERE OID = :OID';
                         fdqryInsert.Params[0].AsString := FOID;
                         fdqryInsert.ExecSQL;
                       end;

                       vOcorrenciaID := FOcorrenciaObj.InserirOcorrencia(vConexao,
                                                                         dtedtDadosData.Date + tmedtDadosHora.Time,
                                                                         edtDadosTitulo.Text,
                                                                         FIMEI,
                                                                         lstbxitmDadosLinha.Tag,
                                                                         FTipoID,
                                                                         vLatitude,
                                                                         vLongitude,
                                                                         FOID);

                       vJSON.AddPair(cteFirebase_IMEI,      FIMEI);
                       vJSON.AddPair(cteFirebase_Id,        vOcorrenciaID);
                       vJSON.AddPair(cteFirebase_Data,      FormatDateTime('YYYYY-MM-DD hh:mm:ss', dtedtDadosData.Date + tmedtDadosHora.Time));
                       vJSON.AddPair(cteFirebase_Latitude,  vLatitude.ToString);
                       vJSON.AddPair(cteFirebase_Longitude, vLongitude.ToString);
                       vJSON.AddPair(cteFirebase_Linha,     lstbxitmDadosLinha.Tag.ToString);
                       vJSON.AddPair(cteFirebase_Tipo,      FTipoID.ToString);
                       vJSON.AddPair(cteFirebase_Titulo,    edtDadosTitulo.Text);

                       //mensagens
                       if FListaMsg.Count > 0 then begin
                         for vMsgObj in FListaMsg do begin
                           vJSONMsg := TJSONObject.Create;
                           try
                             if Assigned(vMsgObj.Bitmap) then begin
                               vStream := TMemoryStream.Create;
                               vStream.Position := 0;
                               vMsgObj.Bitmap.SaveToStream(vStream);
                               vStream.Position := 0;

                               vJSONMsg.AddPair(cteFirebase_Mensagens_Foto, StreamToBase64(vStream));
                             end
                             else begin
                               vStream := nil;
                               vJSONMsg.AddPair(cteFirebase_Mensagens_Foto, '');
                             end;

                             vMsgID := FOcorrenciaObj.InserirMensagem(vConexao,
                                                                      vOcorrenciaID,
                                                                      vMsgObj.Mensagem,
                                                                      vMsgObj.Data,
                                                                      vStream);
                           finally
                             FreeAndNil(vStream);
                           end;

                           vJSONMsg.AddPair(cteFirebase_Mensagens_Data, FormatDateTime('YYYYY-MM-DD hh:mm:ss', vMsgObj.Data));
                           vJSONMsg.AddPair(cteFirebase_Mensagens_Id,   vMsgID.ToString);
                           vJSONMsg.AddPair(cteFirebase_Mensagens_Msg,  vMsgObj.Mensagem);
                           vJSONArrayMsg.Add(vJSONMsg);
                         end;
                       end;

                       vJSON.AddPair(TJSONPair.Create(cteFirebase_Mensagens, vJSONArrayMsg));

                       vFirebaseObj      := TFirebaseObj.Create;
                       vFirebaseObj.URL  := 'ocorrencias/' + vOcorrenciaID + '.json';
                       vFirebaseObj.JSON := vJSON.ToString;

                       vConexao.Commit;
                       FProcAddItemFilaEnvio(vFirebaseObj);
                     except
                       dtmdlDados.fdconConexao.Rollback;
                     end;
                   finally
                     FreeAndNil(vJSON);
                     FreeAndNil(vConexao);
                   end;

                   TThread.Synchronize(TThread.CurrentThread,
                     procedure
                     begin
                       ConfigTelaAguarde(False);
                       Self.Close;
                     end
                   );
                 end
               );
    vThread.FreeOnTerminate := True;
    vThread.Start;
  end;
end;

procedure TfrmOcorrencia.SetIMEI(const Value: String);
begin
  FIMEI := Value;
end;

procedure TfrmOcorrencia.SetOID(const Value: String);
begin
  FOID := Value;
end;

procedure TfrmOcorrencia.SetProcAddItemFilaEnvio(const Value: TProcAddObjFilaEnvio);
begin
  FProcAddItemFilaEnvio := Value;
end;

function TfrmOcorrencia.StreamToBase64(const pMemStream: TMemoryStream): String;
var
  vBase: TBase64Encoding;
begin
  vBase := TBase64Encoding.Create;
  try
    try
      pMemStream.Position := 0;
      Result := String(vBase.EncodeBytesToString(pMemStream.Memory, pMemStream.Size));
    except
      Result := '';
    end;
  finally
    FreeAndNil(vBase);
  end;
end;

procedure TfrmOcorrencia.tbcCadastroChange(Sender: TObject);
begin
  lytMensagem.Align := TAlignLayout.Client;
end;

function TfrmOcorrencia.TecladoVisivel(const pOcultar: Boolean): Boolean;
var
  vKeyboard: IFMXVirtualKeyboardService;
begin
  Result := False;

  TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, vKeyboard);
  if Assigned(vKeyboard) then begin
    Result := TVirtualKeyboardState.Visible in vKeyboard.VirtualKeyBoardState;

    if pOcultar then
      vKeyboard.HideVirtualKeyboard;
  end;
end;

{ TMensagemObj }

procedure TMensagemObj.SetBitmap(const Value: TBitmap);
begin
  FBitmap := Value;
end;

procedure TMensagemObj.SetData(const Value: TDateTime);
begin
  FData := Value;
end;

procedure TMensagemObj.SetLadoDireito(const Value: Boolean);
begin
  FLadoDireito := Value;
end;

procedure TMensagemObj.SetMensagem(const Value: string);
begin
  FMensagem := Value;
end;

end.
