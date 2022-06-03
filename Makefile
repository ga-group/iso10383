
all:

download: download/ISO10383_MIC_latest.xlsx

download/ISO10383_MIC_latest.xlsx:
	curl -L -o $@ 'https://www.iso20022.org/sites/default/files/ISO10383_MIC/ISO10383_MIC_NewFormat.xlsx'

%.ttl.canon: %.ttl
	ttl2ttl --sortable $< \
	| tr '@' '\001' \
	| sort -u \
	| tr '\001' '@' \
	| ttl2ttl \
	> $@ && mv $@ $<

