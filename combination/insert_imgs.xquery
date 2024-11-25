xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";
declare default element namespace "http://www.tei-c.org/ns/1.0";

(: insert image urls from Daniel's file
part of the St. Lambrecht pipeline :)

(:let $insert_imgs :=
    let $newdata_url_cells := doc('MOMExcelImport_StiAL_TA_bearb_korrig_niklas.xml')//row[cell[@n='2' and text() != '']]
    for $charter in doc('corpus.xml')//cei:text[@type='charter']
    let $id := $charter//cei:idno/@id/data()
    let $match := $newdata_url_cells[cell[@n=1 and text()=$id]]
    let $img-urls := tokenize($match/cell[@n='2']/text(), '\$')
    for $url in $img-urls
    let $figure := <cei:figure><cei:graphic url="{$url}"/></cei:figure>
    return insert node $figure into $charter//cei:witnessOrig:)
    
(:let $replace_dates :=
    let $newdata_has_date := doc('MOMExcelImport_StiAL_TA_bearb_korrig_niklas.xml')//row[cell[@n="3" and not(normalize-space() = '')] and cell[@n="4" and not(normalize-space() = '')]]
    for $charter in doc('corpus.xml')//cei:text[@type='charter']
    let $id := $charter//cei:idno/@id/data()
    let $match := $newdata_has_date[cell[@n=1 and text()=$id]]
    let $new_date := <cei:date value="{$match/cell[@n='4']/normalize-space()}">{$match/cell[@n='3']/normalize-space()}</cei:date>
    where $new_date[not(normalize-space() = '')]
    where not($match/cell[@n='17' and contains(text(), 'Inhalt')])
    return replace node $charter//cei:issued/cei:date with $new_date:)
    
(:let $replace_dateranges :=
    let $newdata_has_date := doc('MOMExcelImport_StiAL_TA_bearb_korrig_niklas.xml')//row[cell[@n="8" and not(normalize-space() = '')] and cell[@n="9" and not(normalize-space() = '')]]
    for $charter in doc('corpus.xml')//cei:text[@type='charter']
    let $id := $charter//cei:idno/@id/data()
    let $match := $newdata_has_date[cell[@n=1 and text()=$id]]
    let $from := 
      if (matches($match/cell[@n='8']/normalize-space(), '9999$'))
      then (replace($match/cell[@n='8']/normalize-space(), '9999$', '0101'))
      else if (matches($match/cell[@n='8']/normalize-space(), '99$'))
      then (replace($match/cell[@n='8']/normalize-space(), '99$', '01'))
      else $match/cell[@n='8']/normalize-space()
    let $to := 
      if (matches($match/cell[@n='9']/normalize-space(), '9999$'))
      then (replace($match/cell[@n='9']/normalize-space(), '9999$', '1231'))
      else if (matches($match/cell[@n='9']/normalize-space(), '99$'))
      then (replace($match/cell[@n='9']/normalize-space(), '99$', '31'))
      else $match/cell[@n='9']/normalize-space()
    let $new_date := <cei:dateRange from="{$from}" to="{$to}">{$match/cell[@n='3']/normalize-space()}</cei:dateRange>
    where $new_date[not(normalize-space() = '')]
    where not($match/cell[@n='17' and contains(text(), 'Inhalt')])
    return replace node $charter//cei:issued/cei:dateRange with $new_date:)
    
let $insert_archIdentifier :=
    let $new_identifier := <cei:archIdentifier><cei:arch>Stiftsarchiv St. Lambrecht</cei:arch><cei:settlement>St. Lambrecht</cei:settlement><cei:region>Styria</cei:region><cei:country>Austria</cei:country></cei:archIdentifier>
    return replace node $charter//cei:archIdentifier with $new_identifier
    
return 'done'