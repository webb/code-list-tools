<?xml version="1.0" encoding="UTF-8"?>
<stylesheet 
    xmlns="http://www.w3.org/1999/XSL/Transform" 
   version="1.0">

  <output method="text"/>

  <template match="/*">
    <text>{</text>
    <value-of select="namespace-uri(.)"/>
    <text>}</text>
    <value-of select="local-name(.)"/>
    <text>&#10;</text>
  </template>

</stylesheet>
