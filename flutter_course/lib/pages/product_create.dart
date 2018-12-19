import 'package:flutter/material.dart';

class ProductCreatePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
    // return Center(child: Text('Create a product'),);
    return Center(child: RaisedButton(child: RaisedButton(
      child: Text('Save'),
      onPressed: (){
        showModalBottomSheet(context: context, builder: (BuildContext context){
          return Center(child: Text('This is a modal!'),);
        });
      },
    ),),);
  }


}