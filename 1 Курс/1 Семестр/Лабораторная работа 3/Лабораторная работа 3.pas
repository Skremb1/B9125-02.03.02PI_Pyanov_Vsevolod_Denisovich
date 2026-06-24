program SpiralArctanSin;

const
  PI  = 3.14159265358979323846;
  MAX = 100;
  EPS = 0.0001;

function CalcArctanSinAtPoint(x: real): real;
var
  xn, term, sinT, arctT: real;
  k: integer;
begin

  xn := x - trunc(x / (2*PI)) * (2*PI);
  if xn < 0 then
    xn := xn + 2*PI;

  term := xn;
  sinT := term;
  k := 1;
  while abs(term) > EPS do
  begin
    term := -term * xn * xn / ((2*k)*(2*k+1));
    sinT := sinT + term;
    k := k + 1;
  end;


  arctT := sinT;
  term := sinT;
  k := 1;
  while abs(term) > EPS do
  begin
    term := -term * sinT * sinT * (2*k-1) / (2*k+1);
    arctT := arctT + term;
    k := k + 1;
  end;

  CalcArctanSinAtPoint := arctT;
end;

var
  a, b, h: real;
  n, i, j, idx: integer;

  mat: array[1..MAX,1..MAX] of integer;
  topB, bottomB, leftB, rightB: integer;

  colSum: array[1..MAX] of real;
  minCol, maxCol: integer;
  minSum, maxSum: real;

  x: real;
  ok: boolean;
  tmp: integer;

begin
  writeln('Введите a, b, n:');
  readln(a, b, n);

  ok := true;

  if (n < 1) or (n > MAX) then
  begin
    writeln('Ошибка: n должно быть в диапазоне 1..', MAX);
    ok := false;
  end;

  if a > b then
  begin
    writeln('Ошибка: b должно быть больше или равно a');
    ok := false;
  end;

  if ok then
  begin
    { шаг сетки }
    if n*n = 1 then
      h := 0
    else
      h := (b - a) / (n*n - 1);


    topB := 1; bottomB := n;
    leftB := 1; rightB := n;
    idx := 1;

    while (topB <= bottomB) and (leftB <= rightB) do
    begin
      i := bottomB;
      for j := leftB to rightB do
      begin
        mat[i,j] := idx;
        idx := idx + 1;
      end;
      bottomB := bottomB - 1;

      j := rightB;
      for i := bottomB downto topB do
      begin
        mat[i,j] := idx;
        idx := idx + 1;
      end;
      rightB := rightB - 1;

      if topB <= bottomB then
      begin
        i := topB;
        for j := rightB downto leftB do
        begin
          mat[i,j] := idx;
          idx := idx + 1;
        end;
        topB := topB + 1;
      end;

      if leftB <= rightB then
      begin
        j := leftB;
        for i := topB to bottomB do
        begin
          mat[i,j] := idx;
          idx := idx + 1;
        end;
        leftB := leftB + 1;
      end;
    end;


    writeln;
    writeln('Матрица до модификации:');
    for i := 1 to n do
    begin
      for j := 1 to n do
      begin
        idx := mat[i,j];
        x := a + (idx - 1) * h;
        write(CalcArctanSinAtPoint(x):0:4, '   ');
      end;
      writeln;
    end;


    for j := 1 to n do
    begin
      colSum[j] := 0.0;
      for i := 1 to n do
      begin
        idx := mat[i,j];
        x := a + (idx - 1) * h;
        colSum[j] := colSum[j] + CalcArctanSinAtPoint(x);
      end;
    end;


    minCol := 1; maxCol := 1;
    minSum := colSum[1]; maxSum := colSum[1];

    for j := 2 to n do
    begin
      if colSum[j] < minSum then
      begin
        minSum := colSum[j];
        minCol := j;
      end;
      if colSum[j] > maxSum then
      begin
        maxSum := colSum[j];
        maxCol := j;
      end;
    end;

    writeln;
   

    if minCol <> maxCol then
      for i := 1 to n do
      begin
        tmp := mat[i, minCol];
        mat[i, minCol] := mat[i, maxCol];
        mat[i, maxCol] := tmp;
      end;


      writeln('Суммы столбцов:');
  for j := 1 to n do
    writeln('Столбец ', j:2, ': ', colSum[j]:0:4);
  writeln('min сумма в столбце ', minCol, ' (', minSum:0:4, ')');
  writeln('max сумма в столбце ', maxCol, ' (', maxSum:0:4, ')');
    writeln;
    writeln('Матрица после модификации:');
    for i := 1 to n do
    begin
      for j := 1 to n do
      begin
        idx := mat[i,j];
        x := a + (idx - 1) * h;
        write(CalcArctanSinAtPoint(x):0:4, '   ');
      end;
      writeln;
    end;
  end;
end.
