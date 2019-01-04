import 'package:flutter/material.dart';
import 'product_card.dart';
import '../../models/product.dart';

class Products extends StatelessWidget { // questa classe contiene la lista dei prodotti aggiunti
  final List<Product> products;
  
  Products(this.products) {
    // nota bene ciò che viene passato come parametro del costruttore va ad inizializzare direttamente "this.products"!!
    print('[Products widget] constructor');
  }

// ATTENZIONE!!! vedere i concetti di Flexible ed Expanded!!!

  Widget _buildProductItem(BuildContext context, int index) {
    return  ProductCard(products[index], index);
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
