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
