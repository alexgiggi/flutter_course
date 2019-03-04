import 'package:flutter/material.dart';
import '../../models/product.dart';

import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main.dart';

import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;


class ProductFAB extends StatefulWidget{
  
  final Product product;
  
  ProductFAB(this.product);

  @override
  State<StatefulWidget> createState() {
    return _ProductFABState();
  }

}

class _ProductFABState extends State<ProductFAB> with TickerProviderStateMixin{
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainModel model){
          return Column(mainAxisSize: MainAxisSize.min, children: <Widget>
                      [
                        Container(alignment: FractionalOffset.topCenter, 
                                  child:  ScaleTransition(child: 
                                                                FloatingActionButton(backgroundColor: Theme.of(context).cardColor , 
                                                                                    heroTag: 'contact' , 
                                                                                    mini:true, 
                                                                                    onPressed: () async{
                                                                                      final url = 'mailto:${widget.product.userEmail}';
                                                                                      if (await canLaunch(url)){
                                                                                        await launch(url);
                                                                                      } else
                                                                                      {
                                                                                        throw 'Could not open email';
                                                                                      }

                                                                                    }, 
                                                                                    child: Icon(Icons.mail, 
                                                                                                color: Theme.of(context).primaryColor,
                                                                                                ),
                                                                                  ), 
                                                         scale: CurvedAnimation(
                                                                                  parent: _controller,
                                                                                  curve: Interval(0.0, 1.0, curve: Curves.easeOut)
                                                                                ),
                                                         ),
                                  height: 70, width: 50,
                                  ) ,
                        
                        Container(alignment: FractionalOffset.topCenter, 
                                  child: ScaleTransition(scale: CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.5, curve: Curves.easeOut)), 
                                        child: FloatingActionButton(backgroundColor: Theme.of(context).cardColor , heroTag: 'favorite', mini:true, onPressed: (){
                          model.toggleProductFavoriteStatus();
                        }, child: Icon(model.selectedProduct.isFavorite ? Icons.favorite: Icons.favorite_border, color: Colors.red),),),  
                                  height: 70, 
                                  width: 50,
                                  ) ,

                        Container(alignment: FractionalOffset.topCenter, child: FloatingActionButton(
                                                          heroTag: 'options', 
                                                          onPressed: (){
                                                              if(_controller.isDismissed){
                                                                _controller.forward();
                                                              } else{
                                                                _controller.reverse();
                                                              }
                                                            }, 
                                                          child: AnimatedBuilder(
                                                            animation: _controller, // ogni volta che il controlle va forward o reverse viene chiamato il builder..
                                                            builder: (BuildContext context, Widget child){
                                                                    //print('_controller.value: ' + _controller.value.toString());
                                                                    return Transform(
                                                                        alignment: FractionalOffset.center, // per mantenere sempre al centro la trasformazione
                                                                        transform: Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                                                                        child: Icon(_controller.isDismissed ? Icons.more_vert : Icons.close)
                                                                        );
                                                            
                                                                },) 
                                                        ),
                                    height: 70, 
                                    width: 50,
                                  ) 
                      ]
                  );
        }
      );
  }

}