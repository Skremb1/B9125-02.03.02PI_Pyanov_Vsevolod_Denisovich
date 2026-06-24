unit MultiSet;

interface

type
  PNode = ^TNode;

  TNode = record
    KoordX, KoordY: Integer;
    Koll: Integer;
    Prev, Next: PNode;
  end;

  TMultiSet = record
    Head, Tail: PNode;
  end;

procedure Init(var S: TMultiSet);
procedure AddElement(var S: TMultiSet; X, Y: Integer);
procedure DeleteElement(var S: TMultiSet; X, Y, K: Integer);
function SearchElement(S: TMultiSet; X, Y: Integer): Integer;
function Mochnost(S: TMultiSet): Integer;
procedure Clear(var S: TMultiSet);
procedure PrintForward(S: TMultiSet);
procedure PrintBackward(S: TMultiSet);
procedure Peresechenie(S1, S2: TMultiSet; var S3: TMultiSet);

implementation

function FindNode(S: TMultiSet; X, Y: Integer): PNode;
var
  Cur: PNode;
  ResultNode: PNode;
begin
  Cur := S.Head;
  ResultNode := nil;

  while Cur <> nil do
  begin
    if (Cur^.KoordX = X) and (Cur^.KoordY = Y) then
      ResultNode := Cur;

    Cur := Cur^.Next;
  end;

  FindNode := ResultNode;
end;

procedure Init(var S: TMultiSet);
begin
  S.Head := nil;
  S.Tail := nil;
end;

procedure AddElement(var S: TMultiSet; X, Y: Integer);
var
  Cur, NewNode: PNode;
begin
  Cur := FindNode(S, X, Y);

  if Cur <> nil then
    Cur^.Koll := Cur^.Koll + 1
  else
  begin
    New(NewNode);

    NewNode^.KoordX := X;
    NewNode^.KoordY := Y;
    NewNode^.Koll := 1;

    NewNode^.Prev := S.Tail;
    NewNode^.Next := nil;

    if S.Head = nil then
      S.Head := NewNode
    else
      S.Tail^.Next := NewNode;

    S.Tail := NewNode;
  end;
end;

procedure DeleteElement(var S: TMultiSet; X, Y, K: Integer);
var
  Cur: PNode;
begin
  Cur := FindNode(S, X, Y);

  if Cur <> nil then
  begin
    if Cur^.Koll > K then
      Cur^.Koll := Cur^.Koll - K
    else
    begin
      if Cur^.Prev <> nil then
        Cur^.Prev^.Next := Cur^.Next
      else
        S.Head := Cur^.Next;

      if Cur^.Next <> nil then
        Cur^.Next^.Prev := Cur^.Prev
      else
        S.Tail := Cur^.Prev;

      Dispose(Cur);
    end;
  end;
end;

function SearchElement(S: TMultiSet; X, Y: Integer): Integer;
var
  Cur: PNode;
begin
  Cur := FindNode(S, X, Y);

  if Cur <> nil then
    SearchElement := Cur^.Koll
  else
    SearchElement := 0;
end;

function Mochnost(S: TMultiSet): Integer;
var
  Cur: PNode;
  Sum: Integer;
begin
  Sum := 0;
  Cur := S.Head;

  while Cur <> nil do
  begin
    Sum := Sum + Cur^.Koll;
    Cur := Cur^.Next;
  end;

  Mochnost := Sum;
end;

procedure Clear(var S: TMultiSet);
var
  Cur, Temp: PNode;
begin
  Cur := S.Head;

  while Cur <> nil do
  begin
    Temp := Cur;
    Cur := Cur^.Next;
    Dispose(Temp);
  end;

  S.Head := nil;
  S.Tail := nil;
end;

procedure PrintForward(S: TMultiSet);
var
  Cur: PNode;
begin
  Cur := S.Head;

  while Cur <> nil do
  begin
    Write('(',
          Cur^.KoordX, ',',
          Cur^.KoordY, ',',
          Cur^.Koll, ') ');
    Cur := Cur^.Next;
  end;

  Writeln;
end;

procedure PrintBackward(S: TMultiSet);
var
  Cur: PNode;
begin
  Cur := S.Tail;

  while Cur <> nil do
  begin
    Write('(',
          Cur^.KoordX, ',',
          Cur^.KoordY, ',',
          Cur^.Koll, ') ');
    Cur := Cur^.Prev;
  end;

  Writeln;
end;

procedure Peresechenie(S1, S2: TMultiSet; var S3: TMultiSet);
var
  Cur: PNode;
  I, MinCount, Count2: Integer;
begin
  Init(S3);

  Cur := S1.Head;

  while Cur <> nil do
  begin
    Count2 := SearchElement(S2, Cur^.KoordX, Cur^.KoordY);

    if Cur^.Koll < Count2 then
      MinCount := Cur^.Koll
    else
      MinCount := Count2;

    for I := 1 to MinCount do
      AddElement(S3, Cur^.KoordX, Cur^.KoordY);

    Cur := Cur^.Next;
  end;
end;

end.