xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare default element namespace "http://www.tei-c.org/ns/1.0";

<results>{
let $output := collection('data/output')
for $data in $output//cei:date
return <result file="{substring-after($data/base-uri(), 'output/')}">{$data}</result>
}</results>

