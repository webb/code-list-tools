
.PHONY: all
all: share/code-list-tools/check-genericode.sch.xsl

share/code-list-tools/check-genericode.sch.xsl: share/code-list-tools/check-genericode.sch
	schematron-compile --output-file=$@ $<



