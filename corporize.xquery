xquery version "3.1";
declare namespace cei = "http://www.monasterium.net/NS/cei";

(: enter all charters into a CEI corpus file :)

let $charters := collection('data/output')//cei:text[@type='charter']

return
<cei:cei xmlns:cei="http://www.monasterium.net/NS/cei"
         xmlns:exslt="http://exslt.org/common">
   <cei:teiHeader>
      <cei:fileDesc>
         <cei:titleStmt>
            <cei:title>St. Lambrecht Regesten</cei:title>
            <cei:author/>
         </cei:titleStmt>
         <cei:publicationStmt>
            <cei:p/>
         </cei:publicationStmt>
         <cei:sourceDesc>
            <cei:p/>
         </cei:sourceDesc>
      </cei:fileDesc>
   </cei:teiHeader>
   <cei:text>
    <cei:group>{$charters}</cei:group>
   </cei:text>
</cei:cei>