unit UFunctions;

interface

uses
  System.AnsiStrings;

function DeleteRepeatedSpaces(const OldText: string): string;
function ProjectStatusToSpellOut(const status: string): string;
function RequerimentTypeToSpellOut(const vType: string): string;
function RequerimentStatusToSpellOut(const status: string): string;
function PathOfExecutable: string;

implementation

function RequerimentStatusToSpellOut(const status: string): string;
begin
  case IndexStr(AnsiString(status), [AnsiString('EA'), AnsiString('C'),
      AnsiString('I'), AnsiString('EAA'), AnsiString('B')]) of
    0: Result := 'Em andamento';
    1: Result := 'Cancelado';
    2: Result := 'Implementado';
    3: Result := 'Em analise';
    4: Result := 'Bloqueado';
  else
    Result := 'Status inderteminado';
  end
end;

function RequerimentTypeToSpellOut(const vType: string): string;
begin
  case IndexStr(AnsiString(vType), [AnsiString('RF'), AnsiString('RNF')]) of
    0: Result := 'Requisito funcional';
    1: Result := 'Requisito não funcional';
  else
    Result := 'Tipo inderteminado';
  end
end;


function PathOfExecutable: string;
begin
  Result := String(ExtractFilePath(AnsiString(ParamStr(0))));
end;

function DeleteRepeatedSpaces(const OldText: string): string;
var
  i,j,hi: Integer;
begin
  SetLength(Result,Length(OldText));
  i := Low(OldText);
  j := i;
  hi := High(OldText);
  while (i <= hi) do
  begin
    Result[j] := OldText[i];
    Inc(j);
    if (OldText[i] = ' ') then
    begin
      repeat  //Skip additional spaces
        Inc(i);
      until (i > hi) or (OldText[i] <> ' ');
    end
    else
      Inc(i);
  end;
  SetLength(Result,j-Low(Result));  // Set correct length
end;

function ProjectStatusToSpellOut(const status: string): string;
begin
  case IndexStr(AnsiString(status), [AnsiString('EA'), AnsiString('C'), AnsiString('PC')]) of
    0: Result := 'Em andamento';
    1: Result := 'Cancelado';
    2: Result := 'Projeto concluído';
  else
    Result := 'Status inderteminado';
  end
end;

end.
