unit UTranslate;

interface

uses
  System.Generics.Collections;

var
  DictLangPtToEn: TDictionary<string, string>;

const
  /// Langs

  PtBr                 = 'pt-br';
  EnUs                 = 'en-us';


  /// Portugues

  PtSelectRecord       = 'Por favor selecione um registro para alterar.';
  PtFieldTitleRequerid = 'O campo titulo do projeto � obrigatorio!';


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
      if DictLangPtToEn.ContainsKey(cPhrase) then
      begin
         Result := DictLangPtToEn[cPhrase];
      end;
  end;
end;

procedure InitTranslate;
begin
  DictLangPtToEn := TDictionary<string, string>.Create;
  with DictLangPtToEn do
  begin
    Add(PtSelectRecord, EnSelectRecord);
    Add(PtFieldTitleRequerid, EnFieldTitleRequerid);
  end;
end;

end.
