import 'package:flutter/material.dart';
import './pages/product_admin.dart';
import './pages/productsPage.dart';
import './pages/auth.dart';

// import './product_manager.dart';
// import 'package:flutter/rendering.dart';

//void main() => runApp(MyApp());
void main() {
  // serie di parametri utili per il debuggin dell'applicazione
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // debugShowMaterialGrid: true,
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple),
        // home: AuthPage(), // vedi commento sotto relativo alla route '/'
        routes: {
          '/': (BuildContext context) => AuthPage() , // se specifico questo route allora devo commentare la riga in cui vado a definire la home
          '/admin': (BuildContext context) => ProductsAdminPage() //questa route viene utilizzata nella pagina 'productsPage.dart'          
        },);
        
  }
}
