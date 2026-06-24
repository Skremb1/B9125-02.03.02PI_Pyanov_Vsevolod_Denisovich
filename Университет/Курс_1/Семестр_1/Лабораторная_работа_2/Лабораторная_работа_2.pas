program ArctanSin;
const PI = 3.14159265358979323846;
var a,b,h,x,xn,term,sinT,arctT,eps: real;
    m,i,k: integer;
begin
  writeln('Введите a, b, m, eps:');
  readln(a,b,m,eps);
  h:=(b-a)/m;

  for i:=0 to m do
  begin
    x:=a+i*h;
    xn:=x - floor(x/(2*PI))*(2*PI);
    if xn < 0 then xn:=xn + 2*PI;

    term:=xn; sinT:=term; k:=1;
    while abs(term)>eps do
    begin
      term:=-term*xn*xn/((2*k)*(2*k+1));
      sinT:=sinT+term;
      k:=k+1;
    end;

    arctT:=sinT; term:=sinT; k:=1;
    while abs(term)>eps do
    begin
      term:=-term*sinT*sinT*(2*k-1)/(2*k+1);
      arctT:=arctT+term;
      k:=k+1;
    end;

    writeln('X = ',x:0:6);
    writeln('Стандартные Паскаль: ',arctan(sin(x)):0:12);
    writeln('По Тейлору: ',arctT:0:12);
    writeln;
  end;
end.
