unit m_func;

interface

uses m_type, m_check;

procedure clear_files;
procedure write_error(s: string; err: byte);

procedure read_a(var ab: abiturienty; var n: integer; ff: text);
procedure print_a(ab: abiturienty; n: integer; fname: string);

implementation

const
  MonthName: array[1..12] of string =
  ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

function date_to_str(dd, mm, yy: word): string;
var d, y: string;
begin
  Str(dd, d);
  Str(yy, y);
  date_to_str := d + '.' + MonthName[mm] + '.' + y;
end;

procedure clear_files;
var f: text;
begin
  assign(f,'НЕКОРРЕКТНЫЕ.txt'); rewrite(f); close(f);
  assign(f,'АНОМАЛИИ.txt'); rewrite(f); close(f);
  assign(f,'ДУБЛИКАТЫ.txt'); rewrite(f); close(f);
  assign(f,'ПРОПУСКИ.txt'); rewrite(f); close(f);
  assign(f,'КОНФЛИКТЫ.txt'); rewrite(f); close(f);
end;

procedure write_error(s: string; err: byte);
var f: text; name: string;
begin
  case err of
    1: name := 'НЕКОРРЕКТНЫЕ.txt';
    2: name := 'АНОМАЛИИ.txt';
    3: name := 'ДУБЛИКАТЫ.txt';
    4: name := 'ПРОПУСКИ.txt';
    5: name := 'КОНФЛИКТЫ.txt';
  else name := 'АНОМАЛИИ.txt';
  end;

  assign(f, name);
  append(f);
  writeln(f, s);
  close(f);
end;

procedure read_a(var ab: abiturienty; var n: integer; ff: text);
var
  s, ss1: string;
  words: array[1..20] of string;
  cnt, i, idx, pole, remaining: integer;
  a: abiturient;
  error, line_error: byte;
  miss_date_prikaz, miss_kod_post: boolean;
begin
  n := 0;

  while not eof(ff) do
  begin
    readln(ff, s);

    if s <> '' then
    begin
      cnt := 0;
      i := 1;

      while i <= length(s) do
      begin
        ss1 := '';
        while (i <= length(s)) and (s[i] = ' ') do i := i + 1;
        while (i <= length(s)) and (s[i] <> ' ') do
        begin
          ss1 := ss1 + s[i];
          i := i + 1;
        end;
        if ss1 <> '' then
        begin
          cnt := cnt + 1;
          words[cnt] := ss1;
        end;
      end;

      idx := 1;
      pole := 1;
      line_error := 0;
      miss_date_prikaz := false;
      miss_kod_post := false;

      { ---- Поля 1-6: обязательные ---- }
      while (pole <= 6) and (line_error = 0) do
      begin
        if idx > cnt then
          line_error := 1
        else
        begin
          error := 0;
          case pole of
            1: check_snils_number(words[idx], a.snils.number, error);
            2: check_number(words[idx], a.snils.ks, error);
            3: check_number(words[idx], a.date_bir.dd, error);
            4: check_mm(words[idx], a.date_bir.mm, error);
            5: begin
                 check_number(words[idx], a.date_bir.yy, error);
                 if error = 0 then
                   check_all_date(a.date_bir.dd, a.date_bir.mm, a.date_bir.yy, error);
               end;
            6: check_prikaz(words[idx], a.prikaz, error);
          end;

          if error <> 0 then
            line_error := error
          else
          begin
            idx := idx + 1;
            pole := pole + 1;
          end;
        end;
      end;

      { ---- Поля 7-10: дата приказа и код направления ----
        remaining — сколько токенов осталось после поля 6
        >= 5: дата(3) + код(1) + ЕГЭ(1) — всё есть
        = 4:  дата(3) + ЕГЭ(1)           — пропущен код
        = 2:  код(1)  + ЕГЭ(1)           — пропущена дата
        = 1:  ЕГЭ(1)                     — пропущены дата и код
        = 3 или 0: некорректная строка ---- }
      if line_error = 0 then
      begin
        remaining := cnt - idx + 1;

        if (remaining = 0) or (remaining = 3) then
          line_error := 1
        else if remaining >= 5 then
        begin
          { читаем дату приказа и код }
          error := 0;
          check_number(words[idx], a.date_prikaz.dd, error);
          if error <> 0 then
            line_error := 1
          else
          begin
            idx := idx + 1;
            check_mm(words[idx], a.date_prikaz.mm, error);
            if error <> 0 then
              line_error := 1
            else
            begin
              idx := idx + 1;
              check_number(words[idx], a.date_prikaz.yy, error);
              if error = 0 then
                check_all_date(a.date_prikaz.dd, a.date_prikaz.mm, a.date_prikaz.yy, error);
              if error <> 0 then
                line_error := 2
              else
              begin
                idx := idx + 1;
                check_kod_post(words[idx], a.kod_post, error);
                if error <> 0 then
                  line_error := 2
                else
                  idx := idx + 1;
              end;
            end;
          end;
        end
        else if remaining = 4 then
        begin
          { есть дата приказа, пропущен код направления }
          miss_kod_post := true;
          a.kod_post := '';
          error := 0;
          check_number(words[idx], a.date_prikaz.dd, error);
          if error <> 0 then
            line_error := 1
          else
          begin
            idx := idx + 1;
            check_mm(words[idx], a.date_prikaz.mm, error);
            if error <> 0 then
              line_error := 1
            else
            begin
              idx := idx + 1;
              check_number(words[idx], a.date_prikaz.yy, error);
              if error = 0 then
                check_all_date(a.date_prikaz.dd, a.date_prikaz.mm, a.date_prikaz.yy, error);
              if error <> 0 then
                line_error := 2
              else
                idx := idx + 1;
            end;
          end;
        end
        else if remaining = 2 then
        begin
          { пропущена дата приказа, есть код и ЕГЭ }
          miss_date_prikaz := true;
          a.date_prikaz.dd := 0;
          a.date_prikaz.mm := 0;
          a.date_prikaz.yy := 0;
          error := 0;
          check_kod_post(words[idx], a.kod_post, error);
          if error <> 0 then
            line_error := 1
          else
            idx := idx + 1;
        end
        else if remaining = 1 then
        begin
          { пропущены и дата приказа и код направления }
          miss_date_prikaz := true;
          miss_kod_post := true;
          a.date_prikaz.dd := 0;
          a.date_prikaz.mm := 0;
          a.date_prikaz.yy := 0;
          a.kod_post := '';
        end;
      end;

      { ---- Пропуски ---- }
      if (line_error = 0) and (miss_date_prikaz or miss_kod_post) then
        line_error := 4;

      { ---- Поле 11: сумма ЕГЭ ---- }
      if line_error = 0 then
      begin
        if idx > cnt then
          line_error := 1
        else
        begin
          error := 0;
          check_number(words[idx], a.sum_ege, error);
          if error <> 0 then
            line_error := 1
          else if (a.sum_ege < 100) or (a.sum_ege > 310) then
            line_error := 2;
        end;
      end;

      { ---- Итог ---- }
      if line_error = 0 then
      begin
        n := n + 1;
        ab[n] := a;
      end
      else
        write_error(s, line_error);

    end;
  end;
end;

procedure print_a(ab: abiturienty; n: integer; fname: string);
var f: text;
    i: integer;
begin
  assign(f,fname);
  rewrite(f);

  writeln(f,'-----------------------------------------------------------------------------------------------');
  writeln(f,'| SNILS         | KS  | BIRTH DATE       | PRIK | ORDER DATE       | KOD POST   | EGE |');
  writeln(f,'-----------------------------------------------------------------------------------------------');

  for i := 1 to n do
    with ab[i] do
      writeln(f,
      '| ',snils.number:13,
      ' | ',snils.ks:3,
      ' | ',date_to_str(date_bir.dd,date_bir.mm,date_bir.yy):16,
      ' | ',prikaz:4,
      ' | ',date_to_str(date_prikaz.dd,date_prikaz.mm,date_prikaz.yy):16,
      ' | ',kod_post:10,
      ' | ',sum_ege:3,' |');

  writeln(f,'-----------------------------------------------------------------------------------------------');
  close(f);
end;

end.