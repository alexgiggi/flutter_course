import 'package:flutter/material.dart';
import './product_edit.dart';
import '../models/product.dart';


class ProductListPage extends StatelessWidget {
  final List<Product> products;
  final Function updateProduct;
  final Function deleteProduct;

  ProductListPage(this.products, this.updateProduct, this.deleteProduct);

  Widget _buildEditButton(BuildContext context, int index){
    return IconButton(
              icon: Icon(
                Icons.edit,
                size: 30.0,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return ProductEditPage(
                    product: products[index],
                    updateProduct: updateProduct,
                    productIndex: index,
                  );
                }));
              },
            );
  }
  @override
  Widget build(BuildContext context) {
    // return Center(child: Text('All products'),);
    return ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(products[index].title),
            background: Container(color: Colors.red,child: Text('NO!! CAZZO!!',style: TextStyle(color: Colors.white ,fontSize: 80, fontWeight: FontWeight.bold, fontFamily: 'Oswald'),),),
            onDismissed: (DismissDirection direction){
              if(direction==DismissDirection.endToStart){
                deleteProduct(index);
              }
              else if (direction==DismissDirection.startToEnd) {
                print('start to end');
              } else{
                print('other swiping');
              }
            },
            child: Column(children: <Widget>[
            ListTile(contentPadding: EdgeInsets.symmetric(horizontal: 120.0),
            leading: CircleAvatar(
              backgroundImage: AssetImage(products[index].image
            ),),
            title: Text(
              products[index].title,
            ),
            subtitle: Text('\$ ${products[index].price.toString()}'),
            trailing: _buildEditButton(context, index),
          ),
          Divider(
            height: 40.0,
            color: Colors.orange,

          )
          ],),);
        });
  }
}
