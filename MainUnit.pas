{ By GozimSoft }
unit MainUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Ani,
  System.ImageList, FMX.ImgList;

type

  Txo = class(TRoundRect)
  private
    FlabelSize: TLabel;
    FEffect: TInnerGlowEffect;
    FSize: Integer;
    FCanMove: Boolean;
    FNumperPlayer: Integer;
    procedure SetColor(const Value: TAlphaColor);
    procedure OnClickHandler(Sender: TObject);
    procedure SetSize(const Value: Integer);
    procedure SetFEffect(const Value: Boolean);

  public
    constructor Create(AOwner: TComponent); Override;
    property Size: Integer read FSize write SetSize;
    property NumperPlayer: Integer read FNumperPlayer write FNumperPlayer;
    property CanMove: Boolean read FCanMove write FCanMove;
    property Color: TAlphaColor write SetColor;
    property ShowEffect: Boolean write SetFEffect;

    procedure CancelSelect;
    procedure ResizeMarginXO;

  end;

  TFrmMain = class(TForm)
    RecPlayer1: TRectangle;
    RecPlayer2: TRectangle;
    GridPanelLayout1: TGridPanelLayout;
    Rec1: TRectangle;
    Rec2: TRectangle;
    Rec3: TRectangle;
    Rec4: TRectangle;
    Rec5: TRectangle;
    Rec6: TRectangle;
    Rec7: TRectangle;
    Rec8: TRectangle;
    Rec9: TRectangle;
    RecTop: TRectangle;
    Timer1: TTimer;
    Effect2: TShadowEffect;
    FloatAnimation2: TFloatAnimation;
    Effect3: TShadowEffect;
    FloatAnimation3: TFloatAnimation;
    Effect4: TShadowEffect;
    FloatAnimation4: TFloatAnimation;
    Effect5: TShadowEffect;
    FloatAnimation5: TFloatAnimation;
    Effect6: TShadowEffect;
    FloatAnimation6: TFloatAnimation;
    Effect7: TShadowEffect;
    FloatAnimation7: TFloatAnimation;
    Effect8: TShadowEffect;
    FloatAnimation8: TFloatAnimation;
    Effect9: TShadowEffect;
    FloatAnimation9: TFloatAnimation;
    Effect1: TShadowEffect;
    FloatAnimation1: TFloatAnimation;
    Rectangle2: TRectangle;
    LbResult1: TLabel;
    Rectangle3: TRectangle;
    LbResult2: TLabel;
    ImageList1: TImageList;
    RecPlaying2: TRoundRect;
    RecPlaying1: TRoundRect;
    RecStart: TRectangle;
    LbTimePlyer1: TLabel;
    LbTimePlyer2: TLabel;
    Timer2: TTimer;
    LbWinner: TLabel;
    ShadowEffect1: TShadowEffect;
    FloatAnimation10: TFloatAnimation;
    procedure Rec1Click(Sender: TObject);
    procedure Rec2Click(Sender: TObject);
    procedure Rec3Click(Sender: TObject);
    procedure Rec4Click(Sender: TObject);
    procedure Rec5Click(Sender: TObject);
    procedure Rec6Click(Sender: TObject);
    procedure Rec7Click(Sender: TObject);
    procedure Rec8Click(Sender: TObject);
    procedure Rec9Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RecStartClick(Sender: TObject);
    procedure Rectangle4Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    procedure PreparePlatForm;
    procedure PlatFormToZero;
    { Private declarations }
  public
    procedure CreateXOPlayer(aNumberPlayer: Integer);
    procedure StartGame;
    procedure EndGame;
    function MoveXO(aRec: TRectangle): Boolean;
    procedure HighlightAvailableArea(aSize: Integer);
    procedure UnhighlightAvailableArea;

    function PlyerIsWiner(aNumberPlyer: Integer): Boolean;

  var
    ListObjectXO: array of Txo;
    xoSelect: Txo;
    ListXO: array [1 .. 9] of Integer;
    TimePlay: Integer;

    CountWinnerPlyer1, CountWinnerPlyer2, playing: Integer;

  const
    ColorPaltForm = $FFFDD8B7;
    ColoBackground = $FFF1F1F1;
    ColoBtn = $FFD8D0ED;
    ColorRecTop = $FFF1F1F1;

  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.fmx}
{$R *.XLgXhdpiTb.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TFrmMain.CreateXOPlayer(aNumberPlayer: Integer);
var
  xo: Txo;
  h, I: Integer;

begin

  h := 40;
  for I := 1 to 6 do
  begin
    xo := Txo.Create(Self);
    xo.Size := I;
    xo.NumperPlayer := aNumberPlayer;
    xo.Fill.Kind := TBrushKind.Bitmap;
    xo.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
    xo.Margins.Left := 10;
    xo.Margins.Right := 10;
    xo.Height := h;
    xo.Align := TAlignLayout.Top;

    if aNumberPlayer = 1 then
    begin
      xo.Parent := RecPlayer1;
      // xo.Color := TAlphaColors.Blueviolet;
      xo.Fill.Bitmap.Bitmap.Assign(ImageList1.Source.Items[0].MultiResBitmap
        [0].Bitmap);
    end
    else
    begin
      xo.Parent := RecPlayer2;
      // xo.Color := TAlphaColors.Cadetblue;
      xo.Fill.Bitmap.Bitmap.Assign(ImageList1.Source.Items[1].MultiResBitmap
        [0].Bitmap);
    end;

    h := h + 5;
    ListObjectXO := ListObjectXO + [xo];
  end;

end;

procedure TFrmMain.EndGame;
var
  I: Integer;
begin
  for I := low(ListObjectXO) to High(ListObjectXO) do
    Txo(ListObjectXO[I]).CanMove := False;
  PlatFormToZero;
  playing := 0;
  RecStart.Enabled := True;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  PreparePlatForm;
end;

procedure TFrmMain.HighlightAvailableArea(aSize: Integer);
begin

  if Rec1.Tag < aSize then
    Effect1.Enabled := True;

  if Rec2.Tag < aSize then
    Effect2.Enabled := True;

  if Rec3.Tag < aSize then
    Effect3.Enabled := True;

  if Rec4.Tag < aSize then
    Effect4.Enabled := True;

  if Rec5.Tag < aSize then
    Effect5.Enabled := True;

  if Rec6.Tag < aSize then
    Effect6.Enabled := True;

  if Rec7.Tag < aSize then
    Effect7.Enabled := True;

  if Rec8.Tag < aSize then
    Effect8.Enabled := True;

  if Rec9.Tag < aSize then
    Effect9.Enabled := True;

end;

function TFrmMain.MoveXO(aRec: TRectangle): Boolean;
var
  Num: Integer;
begin
  Result := False;
  if Assigned(xoSelect) then
  begin
    if aRec.Tag < xoSelect.Size then
    begin
      xoSelect.Parent := aRec;
      xoSelect.CancelSelect;
      aRec.Tag := xoSelect.Size;
      xoSelect.CanMove := False;
      Num := StrToInt(copy(aRec.Name, length(aRec.Name), 1));
      ListXO[Num] := xoSelect.NumperPlayer;
      UnhighlightAvailableArea;
      xoSelect.Align := TAlignLayout.Client;
      xoSelect.ResizeMarginXO;
      xoSelect := nil;
      TimePlay := 59;
      if playing = 1 then
        playing := 2
      else
        playing := 1;
      Result := True;
    end;
  end;
end;

procedure TFrmMain.PlatFormToZero;
begin
  Rec1.Tag := 0;
  Rec2.Tag := 0;
  Rec3.Tag := 0;
  Rec4.Tag := 0;
  Rec5.Tag := 0;
  Rec6.Tag := 0;
  Rec7.Tag := 0;
  Rec8.Tag := 0;
  Rec9.Tag := 0;
end;

function TFrmMain.PlyerIsWiner(aNumberPlyer: Integer): Boolean;
begin
  Result := False;

  if (ListXO[1] = aNumberPlyer) and (ListXO[2] = aNumberPlyer) and
    (ListXO[3] = aNumberPlyer) then
  begin
    Result := True;
    Effect1.Enabled := True;
    Effect2.Enabled := True;
    Effect2.Enabled := True;
  end
  else if (ListXO[4] = aNumberPlyer) and (ListXO[5] = aNumberPlyer) and
    (ListXO[6] = aNumberPlyer) then
  begin
    Result := True;
    Effect4.Enabled := True;
    Effect5.Enabled := True;
    Effect6.Enabled := True;
  end
  else if (ListXO[7] = aNumberPlyer) and (ListXO[8] = aNumberPlyer) and
    (ListXO[9] = aNumberPlyer) then
  begin
    Result := True;
    Effect7.Enabled := True;
    Effect8.Enabled := True;
    Effect9.Enabled := True;
  end
  else if (ListXO[1] = aNumberPlyer) and (ListXO[4] = aNumberPlyer) and
    (ListXO[7] = aNumberPlyer) then
  begin
    Result := True;
    Effect1.Enabled := True;
    Effect4.Enabled := True;
    Effect7.Enabled := True;
  end
  else if (ListXO[2] = aNumberPlyer) and (ListXO[5] = aNumberPlyer) and
    (ListXO[8] = aNumberPlyer) then
  begin
    Result := True;
    Effect2.Enabled := True;
    Effect5.Enabled := True;
    Effect8.Enabled := True;
  end
  else if (ListXO[3] = aNumberPlyer) and (ListXO[6] = aNumberPlyer) and
    (ListXO[9] = aNumberPlyer) then
  begin
    Result := True;
    Effect3.Enabled := True;
    Effect6.Enabled := True;
    Effect9.Enabled := True;
  end
  else if (ListXO[1] = aNumberPlyer) and (ListXO[5] = aNumberPlyer) and
    (ListXO[9] = aNumberPlyer) then
  begin
    Result := True;
    Effect1.Enabled := True;
    Effect5.Enabled := True;
    Effect9.Enabled := True;
  end
  else if (ListXO[3] = aNumberPlyer) and (ListXO[5] = aNumberPlyer) and
    (ListXO[7] = aNumberPlyer) then
  begin
    Result := True;
    Effect3.Enabled := True;
    Effect5.Enabled := True;
    Effect7.Enabled := True;
  end;

end;

procedure TFrmMain.PreparePlatForm;
begin
  RecTop.Fill.Color := ColorRecTop;
  Self.Fill.Color := ColoBackground;
  RecPlayer1.Fill.Color := ColoBackground;
  RecPlayer2.Fill.Color := ColoBackground;
  RecStart.Fill.Color := ColoBtn;
  RecStart.Fill.Color := ColoBtn;
  Rectangle2.Fill.Color := ColoBtn;
  Rectangle3.Fill.Color := ColoBtn;

  Rec1.Fill.Color := ColorPaltForm;
  Rec2.Fill.Color := ColorPaltForm;
  Rec3.Fill.Color := ColorPaltForm;
  Rec4.Fill.Color := ColorPaltForm;
  Rec5.Fill.Color := ColorPaltForm;
  Rec6.Fill.Color := ColorPaltForm;
  Rec7.Fill.Color := ColorPaltForm;
  Rec8.Fill.Color := ColorPaltForm;
  Rec9.Fill.Color := ColorPaltForm;
  CountWinnerPlyer1 := 0;
  CountWinnerPlyer2 := 0;
end;

procedure TFrmMain.Rec8Click(Sender: TObject);
begin
  MoveXO(TRectangle(Sender));
end;

procedure TFrmMain.Rec9Click(Sender: TObject);
begin
  MoveXO(TRectangle(Sender));
end;

procedure TFrmMain.RecStartClick(Sender: TObject);
begin
  StartGame;
end;

procedure TFrmMain.Rectangle4Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.Rec1Click(Sender: TObject);
begin
  MoveXO(TRectangle(Sender));
end;

procedure TFrmMain.Rec2Click(Sender: TObject);
begin
  MoveXO(TRectangle(Sender));
end;

procedure TFrmMain.Rec3Click(Sender: TObject);
begin
  MoveXO(TRectangle(Sender));
end;

procedure TFrmMain.Rec4Click(Sender: TObject);
begin
  MoveXO(TRectangle(Sender));
end;

procedure TFrmMain.Rec5Click(Sender: TObject);
begin
  MoveXO(TRectangle(Sender));
end;

procedure TFrmMain.Rec6Click(Sender: TObject);
begin
  MoveXO(TRectangle(Sender));
end;

procedure TFrmMain.Rec7Click(Sender: TObject);
begin
  MoveXO(TRectangle(Sender));
end;

procedure TFrmMain.StartGame;
var
  I: Integer;
begin

  for I := low(ListObjectXO) to High(ListObjectXO) do
    ListObjectXO[I].Free;
  SetLength(ListObjectXO, 0);

  for I := 1 to 9 do
    ListXO[I] := 0;
  CreateXOPlayer(1);
  CreateXOPlayer(2);

  TimePlay := 59;
  playing := 1;
  LbWinner.Text := '';
  RecStart.Enabled := False;
  UnhighlightAvailableArea;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
begin

  RecPlaying1.Fill.Color := TAlphaColors.White;
  RecPlaying2.Fill.Color := TAlphaColors.White;

  if playing = 2 then
  begin
    RecPlaying2.Fill.Color := $FFB5F1B5;
    if PlyerIsWiner(1) then
    begin
      EndGame;
      Inc(CountWinnerPlyer1);
      LbResult1.Text := CountWinnerPlyer1.ToString;
      LbWinner.Text := 'Player One Is Winner ';
    end
  end
  else if playing = 1 then
  begin
    RecPlaying1.Fill.Color := $FFB5F1B5;
    if PlyerIsWiner(2) then
    begin
      EndGame;
      Inc(CountWinnerPlyer2);
      LbResult2.Text := CountWinnerPlyer2.ToString;
      LbWinner.Text := 'Player Tow Is Winner ';
    end;
  end;

end;

procedure TFrmMain.Timer2Timer(Sender: TObject);
begin
  if playing > 0 then
  begin
    if TimePlay = 0 then
    begin
      TimePlay := 59;
      if playing = 1 then
        playing := 2
      else
        playing := 1;
    end
    else
      Dec(TimePlay);

    if playing = 1 then
    begin
      LbTimePlyer1.Text := TimePlay.ToString;
      LbTimePlyer2.Text := '0';
    end
    else
    begin
      LbTimePlyer2.Text := TimePlay.ToString;
      LbTimePlyer1.Text := '0';
    end;
  end;
end;

procedure TFrmMain.UnhighlightAvailableArea;
begin
  Effect1.Enabled := False;
  Effect2.Enabled := False;
  Effect3.Enabled := False;
  Effect4.Enabled := False;
  Effect5.Enabled := False;
  Effect6.Enabled := False;
  Effect7.Enabled := False;
  Effect8.Enabled := False;
  Effect9.Enabled := False;
end;

{ Txo }

procedure Txo.CancelSelect;
begin
  Self.Margins.Top := Self.Margins.Top - 2;
  Self.Margins.Bottom := Self.Margins.Bottom - 2;
  Self.SetFEffect(False);
end;

constructor Txo.Create(AOwner: TComponent);
begin
  inherited;
  Self.OnClick := OnClickHandler;
  Self.Stroke.Kind := TBrushKind.None;
  FCanMove := True;
  Margins.Top := 5;
  Margins.Left := 5;
  Margins.Right := 5;
  Margins.Bottom := 5;

  FlabelSize := TLabel.Create(Self);
  with FlabelSize do
  begin
    TextSettings.HorzAlign := TTextAlign.Center;
    TextSettings.VertAlign := TTextAlign.Center;
    Align := TAlignLayout.Bottom;
    Parent := Self;
    TextSettings.FontColor := TAlphaColors.White;
    StyledSettings := [TStyledSetting.Family, TStyledSetting.Size,
      TStyledSetting.Style];
  end;

  FEffect := TInnerGlowEffect.Create(Self);
  With FEffect do
  begin
    Parent := Self;
    GlowColor := TAlphaColors.Lawngreen;
    Enabled := False;
  end;

end;

procedure Txo.OnClickHandler(Sender: TObject);
begin

  if not CanMove then
  begin

    if FrmMain.MoveXO(TRectangle(Self.Parent)) then
      Self.Visible := False;

    Exit;
  end;

  if NumperPlayer = FrmMain.playing then
  begin

    if Assigned(FrmMain.xoSelect) then
    begin
      Txo(FrmMain.xoSelect).CancelSelect;
      FrmMain.UnhighlightAvailableArea;
      if Txo(FrmMain.xoSelect).Name = Self.Name then
      begin
        FrmMain.xoSelect := nil;
        Exit;
      end;
    end;

    Self.Margins.Top := Self.Margins.Top + 2;
    Self.Margins.Bottom := Self.Margins.Bottom + 2;
    Self.SetFEffect(True);
    FrmMain.xoSelect := Self;
    FrmMain.HighlightAvailableArea(Size);
  end;

end;

procedure Txo.ResizeMarginXO;
var
  _Size: Integer;
begin
  _Size := (6 - FSize) * 4;
  Margins.Top := Margins.Top + _Size;
  Margins.Bottom := Margins.Bottom + _Size;
  Margins.Right := Margins.Right + _Size -4 ;
  Margins.Left := Margins.Left + _Size-4;
end;

procedure Txo.SetColor(const Value: TAlphaColor);
begin
  Self.Fill.Color := Value;
end;

procedure Txo.SetFEffect(const Value: Boolean);
begin
  FEffect.Enabled := Value;
end;

procedure Txo.SetSize(const Value: Integer);
begin
  FSize := Value;
  FlabelSize.Text := Value.ToString;
end;

end.
