xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare default element namespace "http://www.tei-c.org/ns/1.0";

(: insert image urls from Daniel's file
part of the St. Lambrecht pipeline :)

let $newdata_url_cells := doc('MOMExcelImport_StiAL_TA_bearb_korrig_niklas.xml')//row[cell[@n='2' and text() != '']]
for $charter in doc('corpus.xml')//cei:text[@type='charter']
let $id := $charter//cei:idno/@id/data()
let $match := $newdata_url_cells[cell[@n=1 and text()=$id]]
let $img-urls := tokenize($match/cell[@n='2']/text(), '\$')
for $url in $img-urls
let $figure := <cei:figure><cei:graphic url="{$url}"/></cei:figure>
return insert node $figure into $charter//cei:witnessOrig