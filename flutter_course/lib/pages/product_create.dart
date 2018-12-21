import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget{
  
  // final List<Map<String, String>> _products;
  // ProductCreatePage(this._products);

  final Function addProduct;
  ProductCreatePage(this.addProduct);

  @override
  State<StatefulWidget> createState() {
    
    return _ProductCreatePageState();
  }

}

class _ProductCreatePageState extends State<ProductCreatePage>{

  String _titleValue = '';
  String _descriptionValue = '';
  double _priceValue = 0.0;

  @override
  Widget build(BuildContext context) {
    
    return Container(margin: EdgeInsets.all(10.0),
     child: ListView(children: <Widget>[
      TextField(
        decoration: InputDecoration(labelText: 'Product Title'),
        // autofocus: true,
        onChanged: (String value){
          setState(() {
                    _titleValue = value;  
                    });
        },
      ),
      TextField(
        decoration: InputDecoration(labelText: 'Product Description'),
        autofocus: true,
        maxLines: 3,
        onChanged: (String value){
          setState(() {
                    _descriptionValue = value;  
                    });
        }
      ),
      TextField(
        decoration: InputDecoration(labelText: 'Product price'),
        autofocus: true,
        keyboardType: TextInputType.number,
        onChanged: (String value){
          setState(() {
                    _priceValue = double.parse(value);  
                    });
        }
      ),
      SizedBox(height: 10.0,),
      Text(_titleValue),
      SizedBox(height: 10.0,),
      RaisedButton(
        child: Text('Save'), 
        color: Theme.of(context).accentColor,
        textColor: Colors.white,
        onPressed: (){
          final Map<String, dynamic> product = {'title': _titleValue, 'description': _descriptionValue, 'price': _priceValue, 'image': 'assets/food.jpg'};
          widget.addProduct(product);
          Navigator.pushReplacementNamed(context, '/products');
      },)


    ],));
    // return Center(child: Text('Create a product'),);
    // return Center(child: RaisedButton(child: RaisedButton(
    //   child: Text('Save'),
    //   onPressed: (){
    //     showModalBottomSheet(context: context, builder: (BuildContext context){
    //       return Center(child: Text('This is a modal!'),);
    //     });
    //   },
    // ),),);
  }

  @override
  State<StatefulWidget> createState() {
    return null;
  }
} 