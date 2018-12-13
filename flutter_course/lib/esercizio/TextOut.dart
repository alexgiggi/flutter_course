import 'package:flutter/material.dart';

class TextOut extends StatelessWidget{

final String TextOuts;

TextOut(this.TextOuts){ 
    // nota bene ciò che viene passato come parametro del costruttore va ad inizializzare direttamente "this.TextOut"!!
    print('[TextOut widget] constructor');
}
  @override
  Widget build(BuildContext context) // chiamato dopo il costruttore ma anche ogni volta
  { 
    print('[TextOut widget] build');
    return Column(children: <Widget>[Text('Testo: ' + this.TextOuts)]);
  }
}