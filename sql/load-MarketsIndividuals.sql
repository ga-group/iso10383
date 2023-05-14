log_enable(3,1);
SPARQL CREATE SILENT GRAPH <http://data.ga-group.nl/iso10383/MarketsIndividuals/>;
SPARQL CLEAR GRAPH <http://data.ga-group.nl/iso10383/MarketsIndividuals/>;
DELETE FROM DB.DBA.LOAD_LIST WHERE ll_file LIKE '/home/freundt/author/iso10383/MarketsIndividuals%.ttl';
ld_add('/home/freundt/author/iso10383/MarketsIndividuals.ttl', 'http://data.ga-group.nl/iso10383/MarketsIndividuals/');
ld_add('/home/freundt/author/iso10383/MarketsIndividuals-chronic.ttl', 'http://data.ga-group.nl/iso10383/MarketsIndividuals/');
ld_add('/home/freundt/author/iso10383/MarketsIndividuals-align.ttl', 'http://data.ga-group.nl/iso10383/MarketsIndividuals/');
rdf_loader_run();
CHECKPOINT;
