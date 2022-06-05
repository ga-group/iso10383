sparql := /home/freundt/usr/apache-jena/bin/sparql
stardog := STARDOG_CLIENT_JAVA_ARGS='-Dstardog.default.cli.server=http://plutos:5820' /home/freundt/usr/stardog/bin/stardog

all:

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

check.%: %.ttl shacl/%.shacl.ttl
	truncate -s 0 /tmp/$@.ttl
	$(stardog) data add --remove-all -g "http://data.ga-group.nl/iso10383/" iso $<
	$(stardog) icv report --output-format PRETTY_TURTLE -g "http://data.ga-group.nl/iso10383/" -r -l -1 iso shacl/$*.shacl.ttl \
        >> /tmp/$@.ttl || true
	$(MAKE) $*.rpt

%.rpt: /tmp/check.%.ttl
	$(sparql) --results text --data $< --query sql/valrpt.sql


MarketsIndividuals.ttl: download/ISO10383_MIC_latest.xlsx MarketsIndividuals.ttl.aux
	ttl2ttl --sortable $@.aux \
	> $@.t
	## make a black list
	cut -f1 $@.t \
	| sort | uniq \
	> $@.tt
	## we don't want to use lcc-3166-1 prefix
	echo "lcc-3166-1:" >> $@.tt
	-ttl2ttl --sortable $@ \
	| grep -vFf $@.tt \
	>> $@.t
	$(RM) $@.tt
	scripts/rdISO10383.R $< \
	| tarql -t --stdin sql/ISO10383.tarql \
	| sed 's@rdf:type@a@; s@  *@ @g' \
	>> $@.t && mv $@.t $@
	$(MAKE) $@.canon

setup-stardog:                                                                                                                                                                                          
	$(stardog) namespace add --prefix fibo-fbc-fct-mkt --uri https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/Markets/ iso
	$(stardog) namespace add --prefix fibo-fbc-fct-mkti --uri https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/MarketsIndividuals/ iso
