import 'package:flutter/material.dart';
import './products.dart';

class ProductManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductManagerState();
  }
}

class _ProductManagerState extends State<ProductManager> {
  List<String> _products = ['Food terster'];

  @override
  Widget build(BuildContext context) 
  {
    return Column(children: [
                              Container(
                                margin: EdgeInsets.all(10.0),
                                child: RaisedButton(
                                  child: Text('Add product'),
                                  onPressed: () {
                                      setState(() {
                                      _products.add('Advanced food Tester');
                                      print(_products);
                                    });
                                  },
                                ),
                              )
                              ,
                              Products(_products)
                            ] //end children
          ,);    
  }
}
