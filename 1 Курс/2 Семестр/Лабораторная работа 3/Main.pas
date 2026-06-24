program Main;

uses
  MultiSet,
  InputModule;

var
  S1, S2, S3: TMultiSet;

begin
  Init(S1);
  Init(S2);

  Writeln('Множество S1');
  InputSet(S1);

  Writeln;
  Writeln('Множество S2');
  InputSet(S2);

  Peresechenie(S1, S2, S3);

  Writeln;
  Writeln('S1:');
  PrintForward(S1);

  Writeln('S2:');
  PrintForward(S2);

  Writeln('Пересечение:');
  PrintForward(S3);

  Writeln('Печать справа налево:');
  PrintBackward(S3);

  Writeln('Мощность пересечения = ', Mochnost(S3));

  Clear(S1);
  Clear(S2);
  Clear(S3);
end.