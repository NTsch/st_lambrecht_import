xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare default element namespace "http://www.tei-c.org/ns/1.0";

(: replace all instances of cei:date with Daniel's dates
part of the St. Lambrecht pipeline:)

let $newdata_has_date := doc('MOMExcelImport_StiAL_TA_bearb_korrig_niklas.xml')//row[cell[@n="3" and not(normalize-space() = '')] and cell[@n="4" and not(normalize-space() = '')]]
for $charter in doc('corpus.xml')//cei:text[@type='charter']
let $id := $charter//cei:idno/@id/data()
let $match := $newdata_has_date[cell[@n=1 and text()=$id]]
let $new_date := <cei:date value="{$match/cell[@n='4']/normalize-space()}">{$match/cell[@n='3']/normalize-space()}</cei:date>
where $new_date[not(normalize-space() = '')]
where not($match/cell[@n='17' and contains(text(), 'Inhalt')])
return replace node $charter//cei:issued/cei:date with $new_date