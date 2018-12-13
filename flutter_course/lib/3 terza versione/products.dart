import 'package:flutter/material.dart';

class Products extends StatelessWidget{

final List<String> products;

Products(this.products){ 
    // nota bene ciò che viene passato come parametro del costruttore va ad inizializzare direttamente "this.products"!!
    print('[Products widget] constructor');
}

  @override
  Widget build(BuildContext context) // chiamato dopo il costruttore ma anche ogni volta
  { 
    print('[Products widget] build');
    return Column(
              children: products.map((element) => Card(
                                        child: Column(children: <Widget>[
                                      Image.asset('assets/food.jpg'), // commentare questa riga per vedere le print inserite senza eccezioni di mezzo..
                                      Text(element)
                                      //Text('caption image under primo')
                                    ])))
                                .toList());
  }

}