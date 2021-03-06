import 'package:flutter/material.dart';
import './product_edit.dart';
import './product_list.dart';
import '../scoped-models/main.dart';

import '../ui_elements/logout_list_tile.dart';
// import './productsPage.dart';

class ProductsAdminPage extends StatelessWidget{
  
  final MainModel model;  


  // final Function addProduct;
  // final Function deleteProduct;
  // final Function updateProduct;

  // final List<Product> products;

  // ProductsAdminPage(this.addProduct, this.updateProduct , this.deleteProduct, this.products);
  ProductsAdminPage(this.model);

  Widget _buildSideDrawer(BuildContext context){
    return Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              leading: Icon(Icons.shop_two),
              title: Text('All Products'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          Divider(),
          LogoutListTile()
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController(length: 2, child: Scaffold(
          drawer: _buildSideDrawer(context),
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
              // ProductEditPage(addProduct: addProduct),
              // ProductListPage(products, updateProduct, deleteProduct)
              ProductEditPage(),
              ProductListPage(model)
            ],
          ),
        ));
  }

}