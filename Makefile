
all:

download: download/ISO10383_MIC_latest.xlsx

download/ISO10383_MIC_latest.xlsx:
	curl -L -o $@ 'https://www.iso20022.org/sites/default/files/ISO10383_MIC/ISO10383_MIC_NewFormat.xlsx'

%.ttl.canon: %.ttl
	ttl2ttl --sortable $< \
	| tr '@' '\001' \
	| sort -u \
	| tr '\001' '@' \
	| ttl2ttl -B \
	> $@ && mv $@ $<

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
	| tr -d '\200-\377' \
	>> $@.t && mv $@.t $@
	$(MAKE) $@.canon
