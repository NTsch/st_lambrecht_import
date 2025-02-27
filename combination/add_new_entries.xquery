xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare default element namespace "http://www.tei-c.org/ns/1.0";

let $current_chars := doc('corpus.xml')//cei:text[@type='charter']
let $current_ids := $current_chars//cei:body/cei:idno/@id/data()
for $entry in doc('new_entries_cei.xml')//cei:text[@type='charter']
where $entry//cei:graphic/@url/data() != ''
let $id := $entry//cei:body/cei:idno/@id/data()
where not($id = $current_ids)
return insert node $entry after $current_chars[last()]

