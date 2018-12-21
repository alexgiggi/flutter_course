import 'package:flutter/material.dart';
import './pages/miaClasse.dart';

class Products extends StatelessWidget { // questa classe contiene la lista dei prodotti aggiunti
  final List<Map<String, dynamic>> products;
  
  Products(this.products) {
    // nota bene ciò che viene passato come parametro del costruttore va ad inizializzare direttamente "this.products"!!
    print('[Products widget] constructor');
  }

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
                            Image.asset(products[index]['image']), // commentare questa riga per vedere le print inserite senza eccezioni di mezzo..
                            Text(products[index]['title']),
                            ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  child: Text('Details'),
                                  onPressed: () => Navigator.pushNamed<MiaClasse>(context,'/product/' + index.toString()).then((MiaClasse value) 
                                              { // questo verrà poi utilizzato dalla funzione 'onGenerateRoute' di main.dart
                                                print('funzione che cattura il back (Navigator.pop)');
                                                /*
                                                if (value!=null && value.cancellabile){
                                                  print('Ritorno: ' + value.nome);
                                                  deleteProduct(index);
                                                }
                                                else{
                                                  if (value==null)
                                                    print('*** value==null');
                                                  else
                                                    print('*** value!=null ma value.cancellabile=false');
                                                }
                                                */
                                              }),
                                )
                              ],
                            )
        ],
      ),
    );
  }

  Widget _buildProductList() {
    Widget productCard;

    if (products.length > 0) {
      productCard = ListView.builder( // il metodo statico builder viene utilizzato se si vuole creare una lista che si carica dinamicamente
        itemBuilder: _buildProductItem, // questa funzione restituisce un widget
        itemCount: products.length,
      );
    } else {
      productCard = Center(
        child: Text('No products found, please add some'),
      );
      // Se volessi restituire un widget senza nulla allora dovrei restituire: productCard = Container();
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) // chiamato dopo il costruttore ma anche ogni volta che c'è un cambiamento di stato 
  {
    return _buildProductList();

    // return products.length>0 ? ListView.builder(
    //   itemBuilder: _buildProductItem,
    //   itemCount: products.length,
    // ) : Center(child: Text('No products found, please add some'),);
  }
}
