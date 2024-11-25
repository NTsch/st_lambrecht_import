xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare default element namespace "http://www.tei-c.org/ns/1.0";

<new_entries xmlns="my_data">{
let $new_entries :=
  for $newdata in doc('MOMExcelImport_StiAL_TA_bearb_korrig_niklas.xml')//row
  let $newdata_id := $newdata/cell[@n='1']/text()
  let $charter_ids := doc('corpus.xml')//cei:text[@type='charter']//cei:idno/@id/data()
  (:where not(contains($newdata/cell[@n='17']/text(), 'Inhalt?')):)
  where not($newdata_id = $charter_ids)
  return $newdata_id

for $entry in $new_entries
return <id>{$entry}</id>
}</new_entries>