xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare default element namespace "http://www.tei-c.org/ns/1.0";

for $abstract in doc('corpus.xml')//cei:abstract
let $text := string-join($abstract//text())
where matches($text, 'Inhalt\s*\?')
return $abstract/ancestor::cei:body/cei:idno/@id/data()
