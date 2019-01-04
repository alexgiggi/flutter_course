import 'package:flutter/material.dart';
//import '../product_manager.dart';
import '../widgets/products/products.dart';
import '../models/product.dart';

class ProductsPage extends StatelessWidget {

final List<Product> products;
  
  ProductsPage(this.products);

  Widget _buildSideDrawer(BuildContext context){
    return Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage Product'),
              onTap: () {/*
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder
                                  leading: Icon(Icons.edit),: (BuildContext context) =>
                                      ProductsAdminPage()));
                                      */
                          Navigator.pushReplacementNamed(context, '/admin');
              },
            )
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('EasyList'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.favorite),
          onPressed: (){},
          )
        ],
      ),
      // body: ProductManager(/*startingProduct: 'food Tester'*/products),
      body: Products(products),
    );
  }
}
