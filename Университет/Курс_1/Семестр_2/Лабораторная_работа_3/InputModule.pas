unit InputModule;

interface

uses MultiSet;

procedure InputSet(var S: TMultiSet);

implementation

procedure InputSet(var S: TMultiSet);
var
  N, I, X, Y: Integer;
begin
  Write('Количество точек: ');
  Readln(N);

  for I := 1 to N do
  begin
    Write('Введите X и Y: ');
    Readln(X, Y);
    AddElement(S, X, Y);
  end;
end;

end.