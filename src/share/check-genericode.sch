<?xml version="1.0" encoding="US-ASCII"?>
<schema
   queryBinding="xslt2"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://purl.oclc.org/dsdl/schematron">

  <title>Rules for Genericode documents</title>

  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
  <ns prefix="gc" uri="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"/>

  <!--
      checks to make:

      [ ] code list document has at least one key constraint
      [ ] code list document has at least one row
      [ ] key constraint is maintained
      [ ] a row does not define a single column twice
      [ ] every IDREF in the document references the right kind of thing
          [ ] every column ref (e.g., a code value) references a column
      [ ] every code value is assigned to a column (you can't fall of the right hand side)

      checks to make elsewhere:

      [ ] every code value has the right type. This is an XSD check and has to 
          be done SOMEWHERE ELSE.  You'd likely have to output the code list 
          as SOME OTHER CUSTOM FORMAT with rows and column, and strongly type 
          each cell. Not hard, but PITA.

      -->
  
  <pattern>
    <rule context="/gc:ColumnSet">
      <report test="true()">Document is a column set document.</report>
    </rule>
    <rule context="/gc:CodeList">
      <report test="true()">Document is a code list document.</report>
    </rule>
    <rule context="/gc:CodeListSet">
      <report test="true()">Document is a code list set document.</report>
    </rule>
    <rule context="/*">
      <assert test="false()"
              >Document element MUST be gc:ColumnSet, gc:CodeList, or cd:CodeListSet. (from Sec 3.2)</assert>
    </rule>
  </pattern>
</schema>
<!--
Local Variables:
mode: sgml
indent-tabs-mode: nil
fill-column: 9999
End:
-->
