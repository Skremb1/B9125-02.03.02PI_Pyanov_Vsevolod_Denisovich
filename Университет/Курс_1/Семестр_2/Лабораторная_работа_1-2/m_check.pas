unit m_check;

interface
procedure check_snils_number(ss1: string; var a: string; var error: byte);
procedure check_number(ss1: string; var a: word; var error: byte);
procedure check_prikaz(ss1: string; var a: string; var error: byte);
procedure check_kod_post(ss1: string; var a: string; var error: byte);
procedure check_mm(ss1: string; var a: word; var error: byte);
procedure check_all_date(dd, mm, yy: word; var error: byte);



implementation
procedure check_snils_number(ss1: string; var a: string; var error: byte);
var
  i: integer;
begin
  error := 0;
  a := '';

  if length(ss1) <> 11 then
    error := 1
  else
  begin
    for i := 1 to length(ss1) do
    begin
      if (i mod 4 = 0) and (ss1[i] <> '-') then
        error := 1;

      if (i mod 4 <> 0) and ((ss1[i] < '0') or (ss1[i] > '9')) then
        error := 1;
    end;

    if error = 0 then
      a := ss1;
  end;
end;


procedure check_number(ss1: string; var a: word; var error: byte);
var
  i: integer;
begin
  error := 0;
  a := 0;

  if length(ss1) = 0 then
    error := 1
  else
  begin
    for i := 1 to length(ss1) do
      if (ss1[i] < '0') or (ss1[i] > '9') then
        error := 1;

    if error = 0 then
      a := strtoint(ss1);
  end;
end;


procedure check_prikaz(ss1: string; var a: string; var error: byte);
var
  i: integer;
begin
  error := 0;
  a := '';
  if length(ss1) <> 4 then
    error := 1
  else begin

  for i := 1 to 3 do
     if ((ss1[i] < '0') or (ss1[i] > '9')) then
      error := 1;

    if ((ss1[4] < 'a') or (ss1[4] > 'z')) then
      error := 1;
  end;
  
  if error = 0 then
    a := ss1;
 
end;

procedure check_kod_post(ss1: string; var a: string; var error: byte);
var
  i: integer;
begin
  error := 0;
  a := '';

  if length(ss1) <> 8 then
    error := 1
  else
  begin
    for i := 1 to length(ss1) do
    begin
      if (i mod 3 = 0) and (ss1[i] <> '.') then
        error := 1;

      if (i mod 3 <> 0) and ((ss1[i] < '0') or (ss1[i] > '9')) then
        error := 1;
    end;

    if error = 0 then
      a := ss1;
  end;
end;

procedure check_mm(ss1: string; var a: word; var error: byte);
const
  Months: array[1..24] of string = (
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  );
var
  i: integer;
begin
  error := 0;
  a := 0;

  for i := 1 to 24 do
    if Months[i] = ss1 then
    begin
      if i <= 12 then
        a := i
      else
        a := i - 12;
    end;

  if a = 0 then
    error := 1;
end;

procedure check_all_date(dd, mm, yy: word; var error: byte);
var
  max_day: word;
  leap: boolean;
begin
  if error = 0 then
  begin
    if (mm < 1) or (mm > 12) then
      error := 2
    else
    begin
      leap := ((yy mod 4 = 0) and (yy mod 100 <> 0)) or (yy mod 400 = 0);

      case mm of
        1, 3, 5, 7, 8, 10, 12: max_day := 31;
        4, 6, 9, 11: max_day := 30;
        2:
          if leap then
            max_day := 29
          else
            max_day := 28;
      end;

      if (dd < 1) or (dd > max_day) then
        error := 2;
    end;
  end;
end;

begin
 
end.