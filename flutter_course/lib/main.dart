import 'package:flutter/material.dart';
import 'package:flutter_course/scoped-models/products.dart';
import './pages/product_admin.dart';
import './pages/product_page.dart';
import './pages/productsPage.dart';
import './pages/miaClasse.dart';
import './pages/auth.dart';
import './models/product.dart';
import 'package:scoped_model/scoped_model.dart';


// import './pages/productsPage.dart';

// import './product_manager.dart';
// import 'package:flutter/rendering.dart';

// void miaFunzione(@required int primo, int secondo){
//   try {
//     print((primo+secondo).toString());    
//   } catch (e) {
//     print('errore: ' + e.toString());
//   }
  
// }

//void main() => runApp(MyApp());
void main() {
  // serie di parametri utili per il debuggin dell'applicazione
  //debugPaintSizeEnabled = true; //--> visualizza occupazione spazi widget
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;

  // miaFunzione(1,3);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}


class _MyAppState extends State<MyApp> {
  // List<Product> _products = [];

  // void _addProduct(Product product) {
  //   // funzione da passare al widget ProductControl per l'aggiunta di prodotti
  //   setState(() //--> il setState forza la chiamata a build
  //       {
  //     _products.add(product);
  //     print(_products);
  //   });
  // }

  // void _updateProduct(int index, Product product) {
  //   setState(
  //     () //--> il setState forza la chiamata a build
  //       {
  //     _products[index] = product;
  //     print(_products);
  //   });
  // }

  // void _deleteProduct(int index) {
  //   // funzione da passare al widget per l'eliminazione del prodotto (index)-esimo.
  //   setState(() {
  //     _products.removeAt(index);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ProductsModel>(
      model: ProductsModel(),
      child: MaterialApp(
        // debugShowMaterialGrid: true,
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
            buttonColor: Colors.yellow
            ),
        // home: AuthPage(), // vedi commento sotto relativo alla route '/'
        routes: {
          '/': (BuildContext context) => AuthPage(),    // se specifico questo route allora devo commentare la riga in cui vado a definire la home
          '/products': (BuildContext context) => ProductsPage(),   
          '/admin': (BuildContext context) => ProductsAdminPage(),  // questa route viene utilizzata nella pagina 'productsPage.dart' con l'istruzione
                                                                    // Navigator.pushReplacementNamed(context, '/admin');
          /*                                                                   
           // la route sottostante non si può usare perchè è parametrizzata rispetto al valore di index, per cui si usa la onGenerateRoute

          '/product' : (BuildContext context) => ProductPage(
                                                                                                          products[index]['title'],
                                                                                                          products[index]['image']
                                                                                                        )
          */
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split(
              '/'); // es. product/1 --> avrò una lista in pathElements con 'product' e '1'
          // mentre /product/1 avrà tre elementi con '', product' e '1'
          if (pathElements[0] != '') return null;

          if (pathElements[1] == 'product') {
            final int index = int.parse(pathElements[2]);
            return MaterialPageRoute<MiaClasse>(
                builder: (BuildContext context) => ProductPage(index));
          }

          return null;
        },
        onUnknownRoute: (RouteSettings settings){ // richiamata quando viene cercato un path route non registrato oppure quando la funzione 'onGenerateRoute' restituisce null
                                                  // al posto di un valido 'MaterialPageRoute'
          return MaterialPageRoute(builder: (BuildContext context) => ProductsPage());
        },
        )); 
  }
}
