xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare default element namespace "http://www.tei-c.org/ns/1.0";

let $file := doc('data/regesten/regesten_xml/Regesten(1000-1299).xml')

for $sample in $file//text/body//p[@rend='background-color(#ffff00)' or hi[@rend='background-color(#ffff00)']]
let $regest := $sample/following-sibling::p[not(contains(@rend, 'background-color') or hi[contains(@rend, 'background-color')]) and count(preceding-sibling::p[contains(@rend, 'background-color') or hi[@rend='background-color(#ffff00)']]) = position()]
let $ending := tokenize($regest[last()], '\s+[–-]\s+')[last()]
return <result sample="{$sample/text()}"><reg>{$regest[last()]}</reg><end>{$ending}</end></result>
