xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare default element namespace "http://www.tei-c.org/ns/1.0";

(: replace all instances of cei:dateRange with Daniel's dates
part of the St. Lambrecht pipeline:)

let $newdata_has_date := doc('MOMExcelImport_StiAL_TA_bearb_korrig_niklas.xml')//row[cell[@n="8" and not(normalize-space() = '')] and cell[@n="9" and not(normalize-space() = '')]]
for $charter in doc('corpus.xml')//cei:text[@type='charter']
let $id := $charter//cei:idno/@id/data()
let $match := $newdata_has_date[cell[@n=1 and text()=$id]]
let $from := 
  if (matches($match/cell[@n='8']/normalize-space(), '9999$'))
  then (replace($match/cell[@n='8']/normalize-space(), '9999$', '0101'))
  else if (matches($match/cell[@n='8']/normalize-space(), '99$'))
  then (replace($match/cell[@n='8']/normalize-space(), '99$', '01'))
  else $match/cell[@n='8']/normalize-space()
let $to := 
  if (matches($match/cell[@n='9']/normalize-space(), '9999$'))
  then (replace($match/cell[@n='9']/normalize-space(), '9999$', '1231'))
  else if (matches($match/cell[@n='9']/normalize-space(), '99$'))
  then (replace($match/cell[@n='9']/normalize-space(), '99$', '31'))
  else $match/cell[@n='9']/normalize-space()
let $new_date := <cei:dateRange from="{$from}" to="{$to}">{$match/cell[@n='3']/normalize-space()}</cei:dateRange>
where $new_date[not(normalize-space() = '')]
where not($match/cell[@n='17' and contains(text(), 'Inhalt')])
return replace node $charter//cei:issued/cei:dateRange with $new_date