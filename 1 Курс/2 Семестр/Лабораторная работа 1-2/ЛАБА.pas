program Project1;

uses m_type, m_func, m_sort, m_process;

var
  f: text;
  A: abiturienty;
  n: integer;

begin
  clear_files;

  assign(f,'НОРМЫ.txt');
  reset(f);

  read_a(A,n,f);
  close(f);

  remove_duplicates(A,n);
  remove_conflicts(A,n);

  sort_abiturients(A,n);
  print_a(A,n,'OUTPUT.txt');
end.