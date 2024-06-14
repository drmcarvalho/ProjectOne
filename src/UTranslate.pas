unit UTranslate;

interface

uses
  System.Generics.Collections;

var
  DictLanguage: TDictionary<string, string>;

const
  /// Langs

  PtBr                 = 'pt-br';
  EnUs                 = 'en-us';


  /// Portugues

  PtSelectRecord       = 'Por favor selecione um registro para alterar.';
  PtFieldTitleRequerid = 'O campo titulo do projeto é obrigatorio!';


  /// English

  EnSelectRecord       = 'Please select the record for update.';
  EnFieldTitleRequerid = 'The field title is requerid!';

function _t(const cLang, cPhrase: string): string;
procedure InitTranslate;

implementation

function _t(const cLang, cPhrase: string): string;
begin
  Result := cPhrase;


  if cLang = EnUs then
  begin
      if DictLanguage.ContainsKey(cPhrase) then
      begin
         Result := DictLanguage[cPhrase];
      end;
  end;
end;

procedure InitTranslate;
begin
  DictLanguage := TDictionary<string, string>.Create;
  with DictLanguage do
  begin
    Add(PtSelectRecord, EnSelectRecord);
    Add(PtFieldTitleRequerid, EnFieldTitleRequerid);
  end;
end;

end.
