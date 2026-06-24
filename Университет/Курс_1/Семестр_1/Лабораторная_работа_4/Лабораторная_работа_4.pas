program PickProgramWithMaxArrayDim;

var
  s, s0, cur, best, w: string;
  i: integer;
  inp, outp: text;

  beforeBegin: boolean;
  inSq: boolean;
  commaCount: integer;

  curMaxCommas, bestMaxCommas: integer;
  hasCur: boolean;

procedure FinalizeCurrent;
begin
  if hasCur then
    if curMaxCommas > bestMaxCommas then
    begin
      bestMaxCommas := curMaxCommas;
      best := cur;
    end;
end;

procedure StartNewProgram;
begin
  FinalizeCurrent;

  cur := '';
  w := '';

  beforeBegin := true;
  inSq := false;
  commaCount := 0;

  curMaxCommas := -1;
  hasCur := true;
end;

begin
  assign(inp, 'input.txt');
  reset(inp);

  cur := '';
  best := '';
  w := '';

  beforeBegin := true;
  inSq := false;
  commaCount := 0;

  curMaxCommas := -1;
  bestMaxCommas := -1;
  hasCur := false;

  while not eof(inp) do
  begin
    readln(inp, s0);
    s := lowercase(s0);
    s := s + ' ';
    for i := 1 to length(s) do
    begin
      if s[i] in ['a'..'z', '0'..'9', '_'] then
        w := w + s[i]
      else
      begin
        if w <> '' then
        begin
          if w = 'program' then
            StartNewProgram
          else if w = 'begin' then
            beforeBegin := false;

          w := '';
        end;
      end;

      if beforeBegin then
      begin
        if not inSq then
        begin
          if s[i] = '[' then
          begin
            inSq := true;
            commaCount := 0;
          end;
        end
        else
        begin
          if s[i] = ',' then
            commaCount := commaCount + 1
          else if s[i] = ']' then
          begin
            if commaCount > curMaxCommas then
              curMaxCommas := commaCount;
            inSq := false;
            commaCount := 0;
          end;
        end;
      end;
    end;

    cur := cur + s0 + #13#10;
  end;

  close(inp);

  FinalizeCurrent;

  assign(outp, 'output.txt');
  rewrite(outp);
  write(outp, best);
  close(outp);
end.
