<?xml version="1.0" encoding="US-ASCII"?>
<sch:schema
   queryBinding="xslt2"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:sch="http://purl.oclc.org/dsdl/schematron">

  <sch:title>Rules for Genericode documents</sch:title>

  <sch:ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
  <sch:ns prefix="gc" uri="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"/>

  <sch:pattern>
    <sch:rule context="/*">
      <sch:assert test="self::gc:ColumnSet
                    or self::gc:CodeList
                    or self::gc:CodeListSet"
          >Document element MUST be gc:ColumnSet, gc:CodeList, or cd:CodeListSet. (from Sec 3.2)</sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern>
    <sch:rule context="ShortName">
      <sch:assert test="not(matches(normalize-space(concat('X', string(.), 'X')), ' '))"
          >element ShortName MUST NOT have whitespace. (Rule 39)</sch:assert>
    </sch:rule>
  </sch:pattern>
  
</sch:schema>
