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
                                      _updtProduct('Sweets');
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