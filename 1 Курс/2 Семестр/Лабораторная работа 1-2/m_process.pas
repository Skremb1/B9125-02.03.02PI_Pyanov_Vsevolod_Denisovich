unit m_process;

interface

uses m_type, m_func;

procedure remove_duplicates(var ab: abiturienty; var n: integer);
procedure remove_conflicts(var ab: abiturienty; var n: integer);
function month_to_string(m: integer): string;

implementation

function same_ab(a, b: abiturient): boolean;
begin
  same_ab :=
    (a.snils.number = b.snils.number) and
    (a.snils.ks = b.snils.ks) and
    (a.date_bir.dd = b.date_bir.dd) and
    (a.date_bir.mm = b.date_bir.mm) and
    (a.date_bir.yy = b.date_bir.yy) and
    (a.prikaz = b.prikaz) and
    (a.date_prikaz.dd = b.date_prikaz.dd) and
    (a.date_prikaz.mm = b.date_prikaz.mm) and
    (a.date_prikaz.yy = b.date_prikaz.yy) and
    (a.kod_post = b.kod_post) and
    (a.sum_ege = b.sum_ege);
end;

procedure remove_index(var ab: abiturienty; var n: integer; idx: integer);
var i: integer;
begin
  for i := idx to n - 1 do
    ab[i] := ab[i + 1];
  n := n - 1;
end;

function date_to_int(d,m,y: word): longint;
begin
  date_to_int := y*10000 + m*100 + d;
end;

function conflict(a: abiturient): boolean;
begin
  conflict :=
    date_to_int(a.date_bir.dd,a.date_bir.mm,a.date_bir.yy) >
    date_to_int(a.date_prikaz.dd,a.date_prikaz.mm,a.date_prikaz.yy);
end;

procedure remove_duplicates(var ab: abiturienty; var n: integer);
var i, j: integer;
    s, temp: string;
begin
  i := 1;
  while i <= n do
  begin
    j := i + 1;
    while j <= n do
    begin
      if same_ab(ab[i], ab[j]) then
      begin
        s := '';
        
        { СНИЛС }
        s := ab[j].snils.number + ' ' + ab[j].snils.ks;
        
        { Дата рождения }
        Str(ab[j].date_bir.dd, temp);
        s := s + ' ' + temp;
        s := s + ' ' + month_to_string(ab[j].date_bir.mm);
        Str(ab[j].date_bir.yy, temp);
        s := s + ' ' + temp;
        
        { Номер приказа }
        s := s + ' ' + ab[j].prikaz;
        
        { Дата поступления }
        Str(ab[j].date_prikaz.dd, temp);
        s := s + ' ' + temp;
        s := s + ' ' + month_to_string(ab[j].date_prikaz.mm);
        Str(ab[j].date_prikaz.yy, temp);
        s := s + ' ' + temp;
        
        { Код направления }
        s := s + ' ' + ab[j].kod_post;
        
        { Сумма ЕГЭ }
        Str(ab[j].sum_ege, temp);
        s := s + ' ' + temp;
        
        write_error(s, 3);
        remove_index(ab, n, j);
      end
      else 
        j := j + 1;
    end;
    i := i + 1;
  end;
end;
function month_to_string(m: integer): string;
begin
  case m of
    1: month_to_string := 'January';
    2: month_to_string := 'February';
    3: month_to_string := 'March';
    4: month_to_string := 'April';
    5: month_to_string := 'May';
    6: month_to_string := 'June';
    7: month_to_string := 'July';
    8: month_to_string := 'August';
    9: month_to_string := 'September';
    10: month_to_string := 'October';
    11: month_to_string := 'November';
    12: month_to_string := 'December';
  else month_to_string := '';
  end;
end;

procedure remove_conflicts(var ab: abiturienty; var n: integer);
var
  i, j: integer;
  conflict_found: boolean;
  s, temp: string;
  target_snils_number: string;
  target_snils_ks: word;
  target_prikaz: string;
begin
  i := 1;
  while i <= n do
  begin
    conflict_found := false;
    j := i + 1;
    
    { Ищем конфликт для текущей записи i }
    while (j <= n) and not conflict_found do
    begin
      { Тип 1 }
      if (ab[i].prikaz = ab[j].prikaz) and
         (ab[i].snils.number = ab[j].snils.number) and
         (ab[i].snils.ks = ab[j].snils.ks) and
         ((ab[i].date_bir.dd <> ab[j].date_bir.dd) or
          (ab[i].date_bir.mm <> ab[j].date_bir.mm) or
          (ab[i].date_bir.yy <> ab[j].date_bir.yy)) then
        conflict_found := true;
      
      { Тип 2 }
      if not conflict_found and
         (ab[i].prikaz = ab[j].prikaz) and
         (ab[i].snils.number = ab[j].snils.number) and
         (ab[i].snils.ks = ab[j].snils.ks) and
         (ab[i].date_bir.dd = ab[j].date_bir.dd) and
         (ab[i].date_bir.mm = ab[j].date_bir.mm) and
         (ab[i].date_bir.yy = ab[j].date_bir.yy) and
         (ab[i].kod_post <> ab[j].kod_post) then
        conflict_found := true;
      
      { Тип 3 }
      if not conflict_found and
         (ab[i].prikaz = ab[j].prikaz) and
         (ab[i].snils.number = ab[j].snils.number) and
         (ab[i].snils.ks = ab[j].snils.ks) and
         (ab[i].date_bir.dd = ab[j].date_bir.dd) and
         (ab[i].date_bir.mm = ab[j].date_bir.mm) and
         (ab[i].date_bir.yy = ab[j].date_bir.yy) and
         (ab[i].sum_ege <> ab[j].sum_ege) then
        conflict_found := true;
      
      j := j + 1;
    end;
    
    if conflict_found then
    begin
      { СОХРАНЯЕМ ЦЕЛЕВЫЕ ЗНАЧЕНИЯ }
      target_snils_number := ab[i].snils.number;
      target_snils_ks := ab[i].snils.ks;    { теперь это word, всё правильно }
      target_prikaz := ab[i].prikaz;
      
      j := 1;
      while j <= n do
      begin
        if (ab[j].snils.number = target_snils_number) and
           (ab[j].snils.ks = target_snils_ks) and
           (ab[j].prikaz = target_prikaz) then
        begin
          { Формируем строку для записи в файл }
          s := ab[j].snils.number + ' ' + ab[j].snils.ks;
          
          Str(ab[j].date_bir.dd, temp);
          s := s + ' ' + temp + ' ' + month_to_string(ab[j].date_bir.mm);
          Str(ab[j].date_bir.yy, temp);
          s := s + ' ' + temp;
          
          s := s + ' ' + ab[j].prikaz;
          
          Str(ab[j].date_prikaz.dd, temp);
          s := s + ' ' + temp + ' ' + month_to_string(ab[j].date_prikaz.mm);
          Str(ab[j].date_prikaz.yy, temp);
          s := s + ' ' + temp;
          
          s := s + ' ' + ab[j].kod_post;
          
          Str(ab[j].sum_ege, temp);
          s := s + ' ' + temp;
          
          write_error(s, 5);
          remove_index(ab, n, j);
        end
        else
          j := j + 1;
      end;
      i := 1;
    end
    else
      i := i + 1;
  end;
end;
end.