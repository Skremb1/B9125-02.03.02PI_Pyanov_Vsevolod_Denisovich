unit m_sort;

interface

uses m_type;

function less(a, b: abiturient): boolean;
procedure sort_abiturients(var ab: abiturienty; n: integer);

implementation

function less(a, b: abiturient): boolean;
begin
  if a.kod_post <> b.kod_post then
    less := a.kod_post < b.kod_post
  else if a.prikaz <> b.prikaz then
    less := a.prikaz < b.prikaz
  else if a.date_prikaz.yy <> b.date_prikaz.yy then
    less := a.date_prikaz.yy < b.date_prikaz.yy
  else if a.date_prikaz.mm <> b.date_prikaz.mm then
    less := a.date_prikaz.mm < b.date_prikaz.mm
  else
    less := a.date_prikaz.dd < b.date_prikaz.dd;
end;

procedure sort_abiturients(var ab: abiturienty; n: integer);
var i, j: integer;
    t: abiturient;
begin
  for i := 1 to n - 1 do
    for j := 1 to n - i do
      if not less(ab[j], ab[j + 1]) then
      begin
        t := ab[j];
        ab[j] := ab[j + 1];
        ab[j + 1] := t;
      end;
end;

end.