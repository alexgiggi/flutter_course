import 'package:flutter/material.dart';
import '../widgets/helpers/ensure-visible.dart';
import '../models/product.dart';
class ProductEditPage extends StatefulWidget{
  
  // final List<Map<String, String>> _products;
  // ProductCreatePage(this._products);

  final Function addProduct;
  final Function updateProduct;
  final Product product;
  final int productIndex;

  ProductEditPage({this.addProduct,this.updateProduct, this.product, this.productIndex});
  
  @override
  State<StatefulWidget> createState() {
    
    return _ProductEditPageState();
  }

}

class _ProductEditPageState extends State<ProductEditPage>{

  // String _titleValue = '';
  // String _descriptionValue = '';
  // double _priceValue = 0.0;

  // final Map<String, dynamic> _formData = {
  //   'title':'',
  //   'description':null,
  //   'price':null,
  //   'image': 'assets/food.jpg'
  // };

 Product _formData = Product(
    title: '',
    description: '',
    price: 0,
    image: 'assets/food.jpg'
  );


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  Widget _buildTitleTextField() {
        return EnsureVisibleWhenFocused(
          focusNode: _titleFocusNode,
          child: TextFormField(
            focusNode: _titleFocusNode,
        initialValue: widget.product==null ? '' : widget.product.title,
        validator: (String value){
          if (value.isEmpty || value.trim().length<=0){
            return 'Title is required';
          }
        },

        //autovalidate: true, //--> la validazione la faccio dalla submit..
        decoration: InputDecoration(labelText: 'Product Title'),
        // autofocus: true,
        // onChanged: (String value){
        //   setState(() {
        //             _titleValue = value;  
        //             });
        // },

        onSaved: (String value){
          // setState(() {
                    // _titleValue = value;  
            Product newp = Product(title: value, description: _formData.description, price: _formData.price, image: _formData.image);
            _formData = newp;

            //_formData.title = value;
                    // });
        },
      )
      );
  } 

  Widget _buildDescriptionTextField(){
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
              focusNode: _descriptionFocusNode,
              initialValue: widget.product==null ? '' : widget.product.description,
              decoration: InputDecoration(labelText: 'Product Description'),
              autofocus: true,
              maxLines: 3,
              // onChanged: (String value){
              //   setState(() {
              //             _descriptionValue = value;  
              //             });
              // }

            onSaved: (String value){
                // setState(() {
                          //_formData['description'] = value;
                          Product newp = Product(title: _formData.description, description: value, price: _formData.price, image: _formData.image);
                          _formData = newp;
                          // });
              }

            )
            );
  }

  Widget _buildPriceTextField(){
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
              focusNode: _priceFocusNode,
              initialValue: widget.product==null ? '' : widget.product.price,
              decoration: InputDecoration(labelText: 'Product price'),
              validator: (String value){
                if (value.isEmpty || !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)){
                  return 'Prezzo non corretto, verificare';
                }
                  
              },
              autofocus: true,
              keyboardType: TextInputType.number,
              // onChanged: (String value){
              //   setState(() {
              //             _priceValue = double.parse(value);  
              //             });
              // }

              onSaved: (String value){
                // setState(() {
                  //_formData['price'] = value;
                  Product newp = Product(title: _formData.description, description: _formData.description, price: double.parse(value), image: _formData.image);
                  _formData = newp;
                  // });
              }

            )
            );
  }

  _submit(){
    
    if (!_formKey.currentState.validate())
    {  
      print('Errore validazione?');
      return;
    }
    
    _formKey.currentState.save();

    if (widget.product==null){
      // modalità aggiunta nuovo elemento da zero (ADD)
      widget.addProduct(_formData);
    }
    else{
      // modalità aggiunta nuovo elemento da copia altro elemento (UPDATE)
      widget.updateProduct(widget.productIndex,_formData);
    }

    // final Map<String, dynamic> product = {'title': _formData['title'], 'description': _formData['description'], 'price': _formData['price'], 'image': 'assets/food.jpg'};
    // final Map<String, dynamic> product = _formData;
    
    Navigator.pushReplacementNamed(context, '/products');
  }

  Widget _buildPageContent(BuildContext context){
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
      width: targetWidth,
      margin: EdgeInsets.all(10.0),
     child: Form(
       key: _formKey,
       child: ListView(
       padding: EdgeInsets.symmetric(horizontal: targetPadding/2),
       children: <Widget>[
      _buildTitleTextField(),
      _buildDescriptionTextField(),
      _buildPriceTextField(),
      SizedBox(height: 10.0,),
      Text(_formData.title),
      SizedBox(height: 10.0,),
      RaisedButton(
        child: Text('Save'), 
        color: Theme.of(context).accentColor,
        textColor: Colors.white,
        onPressed: _submit
        ,)
      // GestureDetector(
      //   onLongPress: _submit,
      //   child: Container(
      //                     color: Colors.green,
      //                     padding: EdgeInsets.all(5.0),
      //                     child: Text('My button'),
      // ),)
      
      
          ],))
     ),);
  }

  @override
  Widget build(BuildContext context){
    final Widget pageContent = _buildPageContent(context);
    return widget.product == null ? pageContent : Scaffold(appBar: AppBar(title: Text('Edit Product'),),body: pageContent,);
  }
      
  @override
  State<StatefulWidget> createState() {
    return null;
  }
}
      
      