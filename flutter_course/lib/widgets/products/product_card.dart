import 'package:flutter/material.dart';
import '../../pages/miaClasse.dart';
import './price_tag.dart';
import '../../ui_elements/title_default.dart';
import './address_tag.dart'; 
import '../../models/product.dart';

import '../../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductCard extends StatelessWidget{
  final Product product;
  //final int productIndex;
  ProductCard(this.product);//, this.productIndex);

  Widget _buildTitlePriceRow(){
    return Container(color: Colors.blue,
      //height: 60.0, 
      // margin: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(top: 10.0, left: 00.0,), // il margin è lo spazio allesterno del contenitore
      padding: EdgeInsets.only(top: 0.0), // il padding è lo spazio all'interno del contenitore
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        // Text(product['title'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Oswald'),),
        Flexible(child: TitleDefault(product.title),),
        SizedBox(width: 8.0,),
        Flexible(child: Text(' (' + (product.price.toString()) + ' €.)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Oswald'),),),
        SizedBox(width: 8.0,),
        PriceTag(product.price.toString())
        // Container(padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
        //           decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(5.0)), 
        //           child: Text('\$ ${product['price'].toString()}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Oswald'),),)        
      ],));
  }

  Widget _buildActionButton(BuildContext context){
    return  ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
      return ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  child: Text('Details'),
                                  //onPressed: () => Navigator.pushNamed<MiaClasse>(context,'/product/' + model.allProducts[productIndex].id).then((MiaClasse value) 
                                  onPressed: () {
                                      //model.selectProduct(model.allProducts[productIndex].id);
                                      model.selectProduct(product.id);
                                      Navigator.pushNamed<MiaClasse>(context,'/product/' + product.id).then((MiaClasse value){
                                        model.selectProduct(null);
                                      });
                                      }
                                              // { // questo verrà poi utilizzato dalla funzione 'onGenerateRoute' di main.dart
                                              //   print('funzione che cattura il back (Navigator.pop)');
                                              //   /*
                                              //   if (value!=null && value.cancellabile){
                                              //     print('Ritorno: ' + value.nome);
                                              //     deleteProduct(index);
                                              //   }
                                              //   else{
                                              //     if (value==null)
                                              //       print('*** value==null');
                                              //     else
                                              //       print('*** value!=null ma value.cancellabile=false');
                                              //   }
                                              //   */
                                              // }
                                              ),                                
                                IconButton(
                                  icon: Icon(Icons.info),
                                  iconSize: 40.0,
                                  color: Theme.of(context).accentColor,
                                  onPressed: () {
                                      model.selectProduct(product.id);
                                      Navigator.pushNamed<MiaClasse>(context,'/product/' + product.id).then((MiaClasse value){
                                        model.selectProduct(null);
                                      });
                                      }
                                  
                                ),
                                IconButton(
                                  icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
                                  color: Colors.redAccent,
                                  iconSize: 40.0,
                                  
                                  onPressed: (){
                                    model.selectProduct(product.id);
                                    model.toggleProductFavoriteStatus();
                                  }
                                              /*
                                              Navigator.pushNamed<MiaClasse>(context,'/product/' + productIndex.toString()).then((MiaClasse value) 
                                              { // questo verrà poi utilizzato dalla funzione 'onGenerateRoute' di main.dart
                                                print('funzione che cattura il back (Navigator.pop)');                                                
                                              }),
                                              */
                                  
                                )
                              ],
                            );
    },);
  }
  @override
  Widget build(BuildContext context) {
    
    return Card(
      child: Column(
        children: <Widget>[
                            //Image.asset(product.image), // commentare questa riga per vedere le print inserite senza eccezioni di mezzo..
                            Hero(
                              tag: product.id,
                              child: FadeInImage(image: NetworkImage(product.image), 
                            height: 300.0, 
                            fit: BoxFit.cover,
                            placeholder: AssetImage('assets/food.jpg'),) , ),
                            // SizedBox(height: 5.0,),
                            _buildTitlePriceRow(),
                            SizedBox(height: 20.0,),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Colors.grey, width: 2.0, )
                              ),
                              child: AddressTag(product.location.address)
                                
                              ),
                            // sText(product['title']),
                            // Text(product.userEmail),
                            _buildActionButton(context)
        ],
      ),
    );
  }




}