import 'package:flutter/material.dart';

class ProductControl extends StatelessWidget{
  final Function _updtProduct;
    
  ProductControl(this._updtProduct);

  @override
  Widget build(BuildContext context) {
    
    return RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  child: Text('Add product'),
                                  onPressed: () 
                                  {
                                      _updtProduct({'title':'chocolate', 'image':'assets/food.jpg'});

                                      /*
                                      setState(() 
                                      {
                                        _products.add('Advanced food Tester');
                                        print(_products);
                                      });
                                      */
                                  },
                                );
  }




}