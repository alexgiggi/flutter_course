import 'package:flutter/material.dart';
import 'miaClasse.dart';
import 'dart:async';
import '../ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget 
{
  final Product product;

  ProductPage(this.product);

  Widget _buildAddressPriceRow(double price)
  {    
    return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Text('Union Square, San Francisco', style: TextStyle(fontFamily: 'Oswald', color: Colors.grey)),
            SizedBox(width: 10.0,),
            Text('\$: ' + price.toString(), style: TextStyle(fontFamily: 'Oswald', color: Colors.grey)),            
          ],);
  }
  
  @override
  Widget build(BuildContext context) {

    MiaClasse mia = MiaClasse();
    mia.nome = 'Ale';
    mia.cancellabile = true;


    // _showWarningDialog(BuildContext context){
    //       showDialog(context: context, builder: (BuildContext context) {
    //               return AlertDialog( title: Text('Are you sure?'), 
    //                                   content: Text('This action cannot be undone!'),
    //                                   actions: <Widget>[FlatButton(child: Text('Continue'), onPressed: ()
    //                                                     {
    //                                                       mia.cancellabile=true;
    //                                                       Navigator.pop(context);
    //                                                       Navigator.pop(context, mia);                                        
    //                                                     },), 
    //                                                     FlatButton(child: Text('Discard'), onPressed: ()
    //                                                     {
    //                                                       Navigator.pop(context);
    //                                                     })
    //                                                    ],
    //                                 );
    //             });
    // }

    return WillPopScope(onWillPop: (){ 
      print('back button pressed');
      mia.cancellabile = false;
      
      // Navigator.pop(context, mia); // con questa istruzione decido cosa passare quando viene premuto il back

      //return Future.value(false); //se chiamo solo questa funzione con parametro false è come se annullassi il back, il true fa passare il back
      return Future.value(true);
    },
    child: Scaffold(
          appBar: AppBar(
          title: Text(product.title),
          // automaticallyImplyLeading: false // --> disabilita il pulsante di back per questa pagina
          ),
      body: Center(child: Column(
        // mainAxisAlignment:MainAxisAlignment.center, // Allineamento verticale
        crossAxisAlignment: CrossAxisAlignment.center, // Allineamento orizzontale
        children: <Widget>[
          //Image.asset(product.image),
          FadeInImage(image: NetworkImage(product.image), 
                            height: 300.0, 
                            fit: BoxFit.cover,
                            placeholder: AssetImage('assets/food.jpg'),),
          Container(padding: EdgeInsets.all(20.0),
          // child: Text(title, style: TextStyle(fontSize: 26.0, fontFamily: 'Oswald', fontWeight: FontWeight.bold),)
          child: TitleDefault(product.title)
          ,),
          _buildAddressPriceRow(product.price),
          Container(
            padding: EdgeInsets.all(10.0) ,
            //alignment: Alignment.center,
            child: Text(product.description, style: TextStyle(fontFamily: 'Oswald', color: Colors.grey), textAlign: TextAlign.justify)
          // Container(padding: EdgeInsets.all(0.0),child: RaisedButton(
          //   color: Theme.of(context).accentColor, textColor: Colors.yellowAccent,
          //   child: Text('Delete and back', textAlign: TextAlign.center,), onPressed: () {
          //       _showWarningDialog(context);                
          //     } ,
          // ),),
          )
        ],
      ),) 
    )       
    ); 
  }
}
