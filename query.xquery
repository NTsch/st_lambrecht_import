xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare default element namespace "http://www.tei-c.org/ns/1.0";

(:<results>{
let $output := collection('data/output')
for $data in $output//cei:place
(\:where not($data/text()):\)
return <result file="{(substring-after($data/base-uri(), 'output/'), $data/ancestor::cei:text[@type="charter"]//cei:idno/text())}">{$data}</result>
}</results>:)

<results>{
let $input := collection('data/regesten_xml')
for $data in $input//p/text()[contains(., ' – ') and not(./following-sibling::text()[contains(., ' – ')])]
(:where not($data/text()):)
return <result file="{substring-after($data/base-uri(), 'regesten_xml/')}">{$data}</result>
}</results>

(:let $output := collection('data/output')
return $output//cei:text[@type="charter"]//cei:abstract/cei:p[not(normalize-space())]:)