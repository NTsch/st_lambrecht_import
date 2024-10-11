xquery version "3.1";
declare namespace cei = "http://www.monasterium.net/NS/cei";

(:fix duplicate IDs with Basex:)

let $corpus := doc('corpus.xml')
for $id in $corpus//cei:idno
let $prev_same_ids := count($id/ancestor::cei:text[@type='charter']/preceding-sibling::cei:text[@type='charter']//cei:idno[text() = $id/text()])
where $prev_same_ids gt 0
return replace node $id with <cei:idno id="{concat($id/@id, '_', $prev_same_ids + 1)}">{concat($id/text(), '_', $prev_same_ids + 1)}</cei:idno>