xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare default element namespace "http://www.tei-c.org/ns/1.0";

for $abstract in doc('corpus.xml')//cei:abstract
let $id := $abstract/ancestor::cei:body/cei:idno/@id/data()
(:let $newreg := doc('MOMExcelImport_StiAL_TA_bearb_korrig_niklas.xml')//row[cell[@n='1' and text()=$id]]/cell[@n='17']/text():)
let $seal := $abstract/following-sibling::cei:witnessOrig//cei:sealDesc
let $str-a := string-join($abstract//text())
(:let $str-s := string-join($seal//text())
where $str-a != '' and $str-s != '' and contains($str-a, $str-s):)
(:where $abstract/text()[contains(., 'Or.')]:)
where contains($str-a, 'S:')
(:return replace node $abstract/text()[contains(., 'Or.')] with substring-before($abstract/text()[contains(., 'Or.')][last()], 'Or.'):)
return <result>{$id}</result>
