xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare default element namespace "http://www.tei-c.org/ns/1.0";

(: part of the Lambrecht pipeline :)

let $newdata := doc('/db/niklas/imports/lambrecht/combination/MOMExcelImport_StiAL_TA_bearb_korrig_niklas.xml')//row
for $charter in doc('/db/niklas/imports/lambrecht/combination/corpus.xml')//cei:text[@type='charter']
let $id := $charter//cei:idno/@id/data()
let $match := $newdata/cell[@n=1 and text()=$id]/following-sibling::cell[@n='2']/text()
let $img-urls := tokenize($match, '\$')
for $url in $img-urls
where $url
let $figure := <cei:figure><cei:graphic url="{$url}"/></cei:figure>
(:return update insert $figure into $charter//cei:witnessOrig:)
return $figure
