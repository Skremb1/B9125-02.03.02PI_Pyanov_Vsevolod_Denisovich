unit m_type;

interface
type
  snils = record
    number: string;
    ks: word;
  end;

  date = record
    dd: word;
    mm: word;
    yy: word;
  end;

  abiturient = record
    snils: snils;
    date_bir: date;
    prikaz: string;
    date_prikaz: date;
    kod_post: string;
    sum_ege: word;
  end;

const
  MAX_N = 10;

type
  abiturienty = array[1..MAX_N] of abiturient;
implementation
begin
 
end.