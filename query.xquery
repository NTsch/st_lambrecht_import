xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";

declare namespace functx = "http://www.functx.com";
declare function functx:non-distinct-values
  ( $seq as xs:anyAtomicType* )  as xs:anyAtomicType* {

   for $val in distinct-values($seq)
   return $val[count($seq[. = $val]) > 1]
 } ;

(:<results>{
let $output := collection('data/output')
for $data in $output//cei:idno
(\:where not($data/text()):\)
return <result file="{(substring-after($data/base-uri(), 'output/'), $data/ancestor::cei:text[@type="charter"]//cei:idno/text())}">{$data}</result>
}</results>:)

(:<results>{
let $input := collection('data/regesten_xml')
for $data in $input//p/text()[contains(., ' – ') and not(./following-sibling::text()[contains(., ' – ')])]
(\:where not($data/text()):\)
return <result file="{substring-after($data/base-uri(), 'regesten_xml/')}">{$data}</result>
}</results>:)

let $output := collection('data/output')
let $ids := $output//cei:idno/text()
return functx:non-distinct-values($ids)