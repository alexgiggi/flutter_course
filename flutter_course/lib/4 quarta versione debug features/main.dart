import 'package:flutter/material.dart';
import './product_manager.dart';
import 'package:flutter/rendering.dart';

//void main() => runApp(MyApp());
void main() {
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
        home: Scaffold(
          appBar: AppBar(
            title: Text('EasyList'),
          ),
          body: ProductManager('food Tester'),
        ));
  }
}
