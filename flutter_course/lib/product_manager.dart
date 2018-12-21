import 'package:flutter/material.dart';
import './products.dart';

// import './product_control.dart';

class ProductManager extends StatelessWidget {
  
//   final Map<String, dynamic> startingProduct; // prodotto di partenza

//   ProductManager({this.startingProduct/* = 'prodotto di default'*/}) // la graffa per i parametri opzionali? 
//   {
//     print('[ProductManager widget] constructor');
//   }

//   @override
//   State<StatefulWidget> createState() {
//     print('[Product_manager widget] createState');
//     return _ProductManagerState();
//   }
// }

// class _ProductManagerState extends State<ProductManager> {
//   List<Map<String, dynamic>> _products = [];
//   _ProductManagerState(){
//     print('[ProductManagerState] constructor');
//   }

//   @override
//     void initState() 
//     { 
//       print('[ProductManagerState] initState()');
//                         //chiamato UNA SOLA VOLTA dal costruttore prima della chiamata a build
//                         // in generale: COSTRUTTORE() --> INITSTATE() --> BUILD()
      
//       if (widget.startingProduct!=null)
//       {
//         super.initState(); // può anche essere chiamato alla fine del metodo ma raccomandano di chiamarlo qui..

//                         //initState viene chiamato ogni volta che viene creata la classe _ProductManagerState o inizializzata
//                         // questa funzione viene chiamata una volta sola prima di build. La build può essere chiamata più volte
//                         // attraverso l'invocazione del costruttore del product manager oppure attraverso la chiamata a
//                         // setState(...).

//         _products.add(widget.startingProduct); // "widget." è fornito dalla classe 'State' per accedere alle proprieta dell'oggetto
//                                               // StatefulWidget ad esso collegato. Quindi:
//                                               // "widget." permette di accedere ad una proprietà dell'oggetto padre ProductManager
//                                               // avrei potuto anche fare un costruttore ProductManager(String startingProduct)
//                                               // con passaggio di parametro ma questo costruttore, ma il linguaggio ce lo 
//                                               // consente ed è meno arzigogolato. 
//                                               // Widget viene usato dentro un metodo perchè se lo mettessi fuori come assegnazione 
//                                               // diretta tipo List<String> _products = [widget.startingProduct] il compilatore si
//                                               // arrabbierebbe perchè "Only static members can be accessed in initializers" e
//                                               // _products è una variabile privata e di istanza quindi NON statica.
//         // super.initState();   
//       }
//     }
  
  final List<Map<String, dynamic>> products;
  
  ProductManager(this.products);

  @override
  Widget build(BuildContext context) // chiamato ogni volta che cambia qualcosa nell'albero dei widget di questa classe (almeno
                                     // una volta in fase di creazione dell'oggetto) ATTENZIONE: SETSTATE forza la richiamata di
                                     // BUILD
  {
    print('[ProductManagerState] build()');
    return Column(children: [
                              /*
                              Container(
                                margin: EdgeInsets.all(10.0),
                                child: ProductControl(addProduct), // ProductControl è il widget che contiene il pulsante che cambia lo stato di questo widget
                                                                       // aggiungendo nuovi prodotti alla lista
                              )
                              */
                              
                              // Container(height: 300.0,child: Products(_products))
                              Expanded(child: Products(products)) // --> widget che contiene la lista dei prodotti. Expanded è 
                                                                                                 // un tipo di widget che si espande all'aumentare degli oggetti
                                                                                                 // in esso contenuti.
                            ] //end children
          ,);    
  }

  // @override
  //   void didUpdateWidget(ProductManager oldWidget) {
  //     // funzione eseguita quando il widget collegato a questa classe stato (nel caso specifico ProductManager) 
  //     // riceve nuovi dati dall'esterno. Nota: viene passato il vecchio widget per fare eventualmente delle
  //     // comparazioni sui dati cambiati.
  //     // Nota: facendo restart (hot reload) dell'app non viene chiamato l'initState dal costruttore ma viene 
  //     // chiamato didUpdateWidget(). L'hot reload non fa altro che richiamare il setState() dell'intera app 
  //     print('[ProductManagerState] didUpdateWidget()');
  //     super.didUpdateWidget(oldWidget);
  //   }

    
}
