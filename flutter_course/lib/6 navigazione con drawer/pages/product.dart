import 'package:flutter/material.dart';
import 'miaClasse.dart';
import 'dart:async';

class ProductPage extends StatelessWidget {

  final String title;
  final String imageUrl;

  ProductPage(this. title, this.imageUrl){

  }
  
  @override
  Widget build(BuildContext context) {
    MiaClasse mia = MiaClasse();
    mia.nome = 'Ale';
    mia.cancellabile = true;

    return WillPopScope(onWillPop: (){ 
      print('back button pressed');
      mia.cancellabile = false;
      
      // Navigator.pop(context, mia); // con questa istruzione decido cosa passare quando viene premuto il back

      return Future.value(false); //se chiamo solo questa funzione con parametro false è come se annullassi il back, il true fa passare il back
    },
    child: Scaffold(
      appBar: AppBar(
          title: Text(this.title),
          // automaticallyImplyLeading: false // --> disabilita il pulsante di back per questa pagina
          ),
      body: Center(child: Column(
        // mainAxisAlignment:MainAxisAlignment.center, // Allineamento verticale
        crossAxisAlignment: CrossAxisAlignment.center, // Allineamento orizzontale
        children: <Widget>[
          Image.asset(this.imageUrl),
          Container(padding: EdgeInsets.all(20.0),child: Text('On the product page'),),
          Container(padding: EdgeInsets.all(0.0),child: RaisedButton(
            color: Theme.of(context).accentColor, textColor: Colors.yellowAccent,
            child: Text('Back', textAlign: TextAlign.center,), onPressed: () {
              mia.cancellabile=true;
              Navigator.pop(context, mia);} ,
          ),),
          
        ],
      ),) 
    )); 
  }
}
