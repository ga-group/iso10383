log_enable(3,1);
SPARQL CREATE SILENT GRAPH <http://data.ga-group.nl/iso10383/BusinessCentersIndividuals/>;
SPARQL CLEAR GRAPH <http://data.ga-group.nl/iso10383/BusinessCentersIndividuals/>;
DELETE FROM DB.DBA.LOAD_LIST WHERE ll_file LIKE '/home/freundt/author/iso10383/BusinessCentersIndividuals%.ttl';
ld_add('/home/freundt/author/iso10383/BusinessCentersIndividuals.ttl', 'http://data.ga-group.nl/iso10383/BusinessCentersIndividuals/');
ld_add('/home/freundt/author/iso10383/BusinessCentersIndividuals-tz.ttl', 'http://data.ga-group.nl/iso10383/BusinessCentersIndividuals/');
ld_add('/home/freundt/author/iso10383/BusinessCentersIndividuals-align.ttl', 'http://data.ga-group.nl/iso10383/BusinessCentersIndividuals/');
rdf_loader_run();
CHECKPOINT;
