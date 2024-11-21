xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare default element namespace "http://www.tei-c.org/ns/1.0";

(:declare namespace functx = "http://www.functx.com";
declare function functx:non-distinct-values
  ( $seq as xs:anyAtomicType* )  as xs:anyAtomicType* {

   for $val in distinct-values($seq)
   return $val[count($seq[. = $val]) > 1]
 } ;:)

let $daniel_ids := distinct-values(doc('combination/MOMExcelImport_StiAL_TA_bearb_korrig_niklas.xml')//cell[@n='1']/text())
let $new_regest_ids := distinct-values(doc('combination/MOMExcelImport_StiAL_TA_bearb_korrig_niklas.xml')//cell[@n='1' and following-sibling::cell[@n='17' and text() != '' and not(contains(text(), 'Inhalt?'))]]/text())
let $my_ids := distinct-values(doc('corpus.xml')//cei:text[@type='charter']//cei:idno/@id/data())
for $id in $new_regest_ids
where not($id = $my_ids)
order by $id
return <result>{$id}</result>