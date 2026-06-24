program LanguageCheck;
var
  R, a, b, temp, condition1, condition2,condition3, minCondition: real;

begin
  write('Введите радиус блюда R (см): ');
  readln(R);
  
  write('Введите длину язычка a (см): ');
  readln(a);
  
  write('Введите ширину язычка b (см): ');
  readln(b);
if (R <= 0) or (a <= 0) or (b <= 0) then 
  writeln('Введенны некоректные значения, они должны быть положительными!')
else 
  begin
  if a < b then
  begin
    temp := a;
    a := b;
    b := temp;
    writeln('Размеры изменены: a = ', a:0:2, ', b = ', b:0:2);
  end;
condition1 := a*a + 9*b*b;
condition2 := 2*a*a + 2*a*b + b*b;
condition3 := a*a + 2*a*b + 5*b*b;

minCondition := condition1;
if condition2 < minCondition then
  minCondition := condition2;
if condition3 < minCondition then
  minCondition := condition3;

writeln;
if Sqrt(minCondition)
 <= 2*R then
  writeln('Результат: ПОМЕСТЯТСЯ')
else
  writeln('Результат: НЕ ПОМЕСТЯТСЯ');
readln;
end;
end.