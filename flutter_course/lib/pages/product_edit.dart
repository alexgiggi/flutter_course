import 'package:flutter/material.dart';
import '../widgets/helpers/ensure-visible.dart';
import '../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ProductEditPage extends StatefulWidget{
  
  // final List<Map<String, String>> _products;
  // ProductCreatePage(this._products);

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

final Map<String, dynamic> _formData = {
    'title': '',
    'description': null,
    'price': null,
    'image': 'assets/food.jpg'
  };


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  Widget _buildTitleTextField(Product product) {
        return EnsureVisibleWhenFocused(
          focusNode: _titleFocusNode,
          child: TextFormField(
            focusNode: _titleFocusNode,
        initialValue: product==null ? '' : product.title,
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
            _formData['title'] = value;
                    // });
        },
      )
      );
  } 

  Widget _buildDescriptionTextField(Product product){
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
              focusNode: _descriptionFocusNode,
              initialValue: product==null ? '' : product.description,
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
                          _formData['description'] = value;
                          
                          // });
              }

            )
            );
  }

  Widget _buildPriceTextField(Product product){
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
              focusNode: _priceFocusNode,
              initialValue: product==null ? '' : product.price.toString(),
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
                  _formData['price'] = value;
                  
                  // });
              }

            )
            );
  }

  _submitForm(Function addProduct, Function updateProduct, Function setSelectedProduct, [int selectedProductIndex]){
    
    if (!_formKey.currentState.validate())
    {  
      print('Errore validazione?');
      return;
    }
    
    _formKey.currentState.save();

    if (selectedProductIndex==null){
      // modalità aggiunta nuovo elemento da zero (ADD)
      addProduct(
            _formData['title'],
            _formData['description'],
            _formData['image'],
            double.parse(_formData['price'])
            ).then((_){
              Navigator.pushReplacementNamed(context, '/products').then((_)=>setSelectedProduct(null));
            });
    }
    else{
      // modalità aggiunta nuovo elemento da copia altro elemento (UPDATE)
      updateProduct(
            _formData['title'],
            _formData['description'],
            _formData['image'],
            double.parse(_formData['price']));
    }

    // final Map<String, dynamic> product = {'title': _formData['title'], 'description': _formData['description'], 'price': _formData['price'], 'image': 'assets/food.jpg'};
    // final Map<String, dynamic> product = _formData;
    
    
  }

  Widget _buildSubmitButton(){
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
      return model.isLoading? Center(child: CircularProgressIndicator(),) : RaisedButton(
        child: Text('Save'), 
        color: Theme.of(context).accentColor,
        textColor: Colors.white,
        // onPressed: _submitForm(model.addProduct, model.updateProduct));
        onPressed: () => _submitForm(model.addProduct, model.updateProduct,model.selectProduct, model.selectedProductIndex),);
    },); 
  }

  Widget _buildPageContent(BuildContext context, Product product){
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
      _buildTitleTextField(product),
      _buildDescriptionTextField(product),
      _buildPriceTextField(product),
      SizedBox(height: 10.0,),
      Text(_formData['title']),
      SizedBox(height: 10.0,),
      _buildSubmitButton(),
      
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
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
      final Widget pageContent = _buildPageContent(context, model.selectedProduct);      
      return model.selectedProductIndex == null ? pageContent : Scaffold(appBar: AppBar(title: Text('Edit Product'),),body: pageContent,);
    },); 


    
  }
      
  @override
  State<StatefulWidget> createState() {
    return null;
  }
}
      
      