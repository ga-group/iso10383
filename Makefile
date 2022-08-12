SHELL := /bin/zsh

sparql := /home/freundt/usr/apache-jena/bin/sparql
stardog := STARDOG_JAVA_ARGS='-Dstardog.default.cli.server=http://plutos:5820' /home/freundt/usr/stardog/bin/stardog

all: MarketsIndividuals.ttl BusinessCentersIndividuals.ttl
canon: MarketsIndividuals.ttl.canon BusinessCentersIndividuals.ttl.canon
check: check.MarketsIndividuals check.BusinessCentersIndividuals

download: download/ISO10383_MIC_latest.xlsx

download/ISO10383_MIC_latest.xlsx:
	curl -L -o $@ 'https://www.iso20022.org/sites/default/files/ISO10383_MIC/ISO10383_MIC_NewFormat.xlsx'

%.ttl.canon: %.ttl
	rapper -i turtle $< >/dev/null
	ttl2ttl --sortable $< \
	| tr '@' '\001' \
	| sort -u \
	| tr '\001' '@' \
	| ttl2ttl -B \
	> $@ && mv $@ $<

check.MarketsIndividuals: ADDITIONAL = BusinessCentersIndividuals.ttl onto/fibo-fnd-plc-loc.ttl

check.%: %.ttl shacl/%.shacl.ttl
	truncate -s 0 /tmp/$@.ttl
	$(stardog) data add --remove-all -g "http://data.ga-group.nl/iso10383/" iso $< $(ADDITIONAL)
	$(stardog) icv report --output-format PRETTY_TURTLE -g "http://data.ga-group.nl/iso10383/" -r -l -1 iso shacl/$*.shacl.ttl \
        >> /tmp/$@.ttl || true
	$(MAKE) $*.rpt

check.%: %.ttl shacl/%.shacl.sql
	$(RM) tmp/shacl-*.qry
	mawk 'BEGIN{f=0}/\f/{f++;next}{print>"tmp/shacl-"f".qry"}' $(filter %.sql, $^)
	truncate -s 0 /tmp/$@.ttl
	$(stardog) data add --remove-all -g "http://data.ga-group.nl/iso10383/" iso $< $(ADDITIONAL)
	for i in tmp/shacl-*.qry; do \
		$(stardog) query execute --format PRETTY_TURTLE -g "http://data.ga-group.nl/iso10383/" -r -l -1 iso $${i}; \
	done \
        >> /tmp/$@.ttl || true
	$(MAKE) $*.rpt

%.rpt: /tmp/check.%.ttl
	$(sparql) --results text --data $< --query sql/valrpt.sql

tmp/MarketsIndividuals-tempo.ttl: download/ISO10383_MIC_latest.xlsx
	# rescue validity, efficacy, and modification dates of active nodes
	-ttl2ttl --sortable MarketsIndividuals.ttl \
	| grep -F $$'tempo:valid\ntempo:efficacious\ndct:modified' \
	> $@

tmp/MarketsIndividuals-type.ttl: download/ISO10383_MIC_latest.xlsx
	# rescue types of active nodes
	-ttl2ttl --sortable MarketsIndividuals.ttl \
	| grep -F $$'\ta\t' \
	> $@

tmp/MarketsIndividuals-label.ttl: download/ISO10383_MIC_latest.xlsx
	# rescue labels and names of active nodes
	-ttl2ttl --sortable MarketsIndividuals.ttl \
	| grep -F $$'rdfs:label\ndbp:formerLabel' \
	| mawk -F'\t' '$$2="dbp:formerLabel"' \
	> $@

tmp/MarketsIndividuals-name.ttl: download/ISO10383_MIC_latest.xlsx
	# rescue labels and names of active nodes
	-ttl2ttl --sortable MarketsIndividuals.ttl \
	| grep -F $$'fibo-fbc-fct-mkt:hasExchangeName\ndbp:formerName' \
	| mawk -F'\t' '$$2="dbp:formerName"' \
	> $@

tmp/MarketsIndividuals.ttl: download/ISO10383_MIC_latest.xlsx
	scripts/rdISO10383.R $< \
	| tarql -t --stdin sql/ISO10383.tarql \
	| grep -vF 'lcc-3166-1:' \
	| sed 's@rdf:type@a@; s@  *@ @g' \
	> $@.t && mv $@.t $@

MarketsIndividuals.ttl: tmp/MarketsIndividuals.ttl MarketsIndividuals-aux.ttl MarketsIndividuals-align.ttl MarketsIndividuals-hist.ttl tmp/MarketsIndividuals-tempo.ttl tmp/MarketsIndividuals-type.ttl tmp/MarketsIndividuals-label.ttl tmp/MarketsIndividuals-name.ttl
	cat $^ \
	> $@.t && mv $@.t $@
	$(MAKE) $@.canon

BusinessCentersIndividuals.ttl: download/business-center-latest.xml BusinessCentersIndividuals-aux.ttl BusinessCentersIndividuals-align.ttl BusinessCentersIndividuals-tz.ttl
	ttl2ttl --sortable $(filter %.ttl, $^) \
	> $@.t
	-cat $@ >> $@.t
	xsltproc scripts/rdfpml.xsl $< \
	| tarql -t --stdin sql/FpML.tarql \
	| grep -vF 'lcc-3166-1:' \
	| sed 's@rdf:type@a@; s@  *@ @g' \
	>> $@.t && mv $@.t $@
	$(MAKE) $@.canon

setup-stardog:                                                                                                                                                                                          
	$(stardog)-admin db create -o reasoning.sameas=OFF -n iso
	$(stardog) namespace add --prefix fibo-fbc-fct-mkt --uri https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/Markets/ iso
	$(stardog) namespace add --prefix fibo-fbc-fct-mkti --uri https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/MarketsIndividuals/ iso
	$(stardog) namespace add --prefix fibo-fbc-fct-bc --uri https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/BusinessCenters/ iso
	$(stardog) namespace add --prefix fibo-fbc-fct-bci --uri https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/BusinessCentersIndividuals/ iso

unsetup-stardog:
	$(stardog)-admin db drop iso
