import 'package:flutter/material.dart';
import './product_create.dart';
import './product_list.dart';
// import './productsPage.dart';

class ProductsAdminPage extends StatelessWidget{
  
  final Function addProduct;
  final Function deleteProduct;

  ProductsAdminPage(this.addProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController(length: 2, child: Scaffold(
          drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              title: Text('All Products'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/products');
              },
            )
          ],
        ),
      ),
          appBar: AppBar(
            bottom: TabBar(tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Create Product'),
              Tab(icon: Icon(Icons.list),
              text: 'My Product')
            ],),
            title: Text('Manage product'),
          ),
          body: TabBarView(
            children: <Widget>[
              ProductCreatePage(addProduct),ProductListPage()
            ],
          ),
        ));
  }

}