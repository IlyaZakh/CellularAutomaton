unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Spin, InitializationUnit;

type

  PRow = ^Row;
  Row = record
    Value: String;
    next: PRow;
  end;

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Canva: TImage;
    RuleImage: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MainPanel: TPanel;
    SettingsPanel: TPanel;
    SpinEdit1: TSpinEdit;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private

  public
    procedure DrawRule;
  end;

var
  MainForm: TMainForm;
  Rule, Count: Integer;
  First, Last: PRow;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormResize(Sender: TObject);
begin
  Initialize;
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  Current: PRow;
  I: Integer;
begin
  Current:=First^.next;
  while Current <> nil do
    begin
      Dispose(First);
      First:=Current;
      Current:=Current^.next;
    end;
  Dispose(First);
  Count:=0;
  new(Current);
  Current^.Value:='';
  for I:=0 to 74 do
    if I <> 37 then
      Current^.Value:=Current^.Value + '0'
    else
      Current^.Value:=Current^.Value + '1';
  Current^.next:=nil;
  First:=Current;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  Timer1.Enabled:=not Timer1.Enabled;
  if Button2.Caption = 'Пауза' then
    Button2.Caption:='Пуск'
  else
    Button2.Caption:='Пауза';
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  Current: PRow;
begin
  Current:=First^.next;
  while Current <> nil do
    begin
      Dispose(First);
      First:=Current;
      Current:=First^.next;
    end;
  Dispose(First);
end;

procedure TMainForm.SpinEdit1Change(Sender: TObject);
begin
  Rule:=SpinEdit1.Value;
  DrawRule;
  Button1.Click;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
  Buffer: TBitmap;
  Current: PRow;
  I, N: Byte;
begin
  Buffer:=TBitmap.Create;
  Buffer.Width:=750;
  Buffer.Height:=490;
  Buffer.Canvas.Brush.Color:=clWhite;
  Buffer.Canvas.Pen.Color:=clWhite;
  Buffer.Canvas.Rectangle(Canva.DestRect);

  Buffer.Canvas.Brush.Color:=clBlack;
  Buffer.Canvas.Pen.Color:=clBlack;
  Current:=First;
  N:=0;
  while Current <> nil do
    begin
      for I:=1 to Current^.Value.Length do
        if Current^.Value[I] = '1' then
          Buffer.Canvas.Rectangle(0+(I-1)*10, 0+N*10, 10+(I-1)*10, 10+N*10);
      Current:=Current^.next;
      Inc(N);
    end;
  if Count = 49 then
    begin
      Current:=First^.next;
      Dispose(First);
      First:=Current;
    end
  else
    Inc(Count);
  if Count = 1 then
    Last:=First;
  new(Current);
  Current^.Value:='';
  for I:=1 to 75 do
    Current^.Value:=Current^.Value + '0';
  for I:=1 to 73 do
    if (Rule and (1 shl (StrToInt(Last^.Value[I])+
                        StrToInt(Last^.Value[I+1])*2+
                        StrToInt(Last^.Value[I+2])*4)) > 0) then
      Current^.Value[I+1]:='1';
  if (Rule and (1 shl (StrToInt(Last^.Value[Last^.Value.Length])+
                        StrToInt(Last^.Value[1])*2+
                        StrToInt(Last^.Value[2])*4)) > 0) then
      Current^.Value[1]:='1';
  if (Rule and (1 shl (StrToInt(Last^.Value[Last^.Value.Length - 1])+
                        StrToInt(Last^.Value[Last^.Value.Length])*2+
                        StrToInt(Last^.Value[1])*4)) > 0) then
      Current^.Value[Last^.Value.Length]:='1';
  Last^.next:=Current;
  Last:=Current;
  Canva.Picture.Bitmap:=Buffer;
  FreeAndNil(Buffer);
end;

procedure TMainForm.TrackBar1Change(Sender: TObject);
begin
  Label2.Caption:=IntToStr(TrackBar1.Position);
  Timer1.Interval:=TrackBar1.Position;
end;

procedure TMainForm.DrawRule;
var
  I, J, ClCell: Byte;
begin
  RuleImage.Canvas.Brush.Color:=clWhite;
  RuleImage.Canvas.Pen.Color:=clWhite;
  RuleImage.Canvas.Rectangle(RuleImage.DestRect);
  RuleImage.Canvas.Pen.Color:=clBlack;
  for I:=0 to 7 do
    begin
      for J:=0 to 2 do
        begin
          if (I and (1 shl J)) > 0 then
            ClCell:=127
          else
            ClCell:=255;
          RuleImage.Canvas.Brush.Color:=RGBToColor(ClCell, ClCell, ClCell);
          RuleImage.Canvas.Rectangle(34-J*11, 0+I*33, 23-J*11, 11+I*33);
        end;
      if (Rule and (1 shl I)) > 0 then
        ClCell:=127
      else
        ClCell:=255;
      RuleImage.Canvas.Brush.Color:=RGBToColor(ClCell, ClCell, ClCell);
      RuleImage.Canvas.Rectangle(11, 11+I*33, 22, 22+I*33);
    end;
end;

end.

