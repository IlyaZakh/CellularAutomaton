unit InitializationUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

procedure Initialize;

implementation

uses
  Main;

procedure Initialize;
var
  Current: PRow;
  I: Integer;
begin
  with MainForm do
    begin
      DoubleBuffered:=True;
      MainPanel.DoubleBuffered:=True;
      Rule:=SpinEdit1.Value;
      DrawRule;
    end;
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

end.

