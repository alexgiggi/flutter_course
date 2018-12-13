
prima versione: 
- tutto sta in un solo file: main.dart

seconda versione: 
- viene diminuita la complessità dell'interfaccia attraverso la costruzione di widget combinati assieme nel file main.dart
  i widget creati sono product_manager.dart che è di tipo statefull che contiene la lista dei prodotti ed il pulsante che 
  agisce sullo stato aumentando la lista dei prodotti, poi c'è un widget stateless che semplicemente si occupa di mostrare 
  la lista dei prodotti ed è products.dart

terza versione:
- scopo: il main.dart si occupa di reperire i dati (per es. dal server) e di passarli al widget statefull 
  product_manager.dart.