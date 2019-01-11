import 'package:flutter/material.dart';
//import '../product_manager.dart';
import '../widgets/products/products.dart';
//import '../models/product.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ProductsPage extends StatefulWidget {

  final MainModel model;

  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    
    return _ProductsPageState();
  }

}

class _ProductsPageState extends State<ProductsPage>{

  @override
  initState(){ // questa classe è diventata stateful solo per poter utilizzare questa funzione, stessa cosa per la classe product_list
    widget.model.fetchProducts();
    super.initState();
  }

  Widget _buildSideDrawer(BuildContext context) {
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
            onTap: () {
              /*
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
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.displayFavoritesOnly ? Icons.favorite: Icons.favorite_border),
                onPressed: () {
                  model.toggleDisplayMode();
                },
              );
            },
          )
        ],
      ),
      // body: ProductManager(/*startingProduct: 'food Tester'*/products),
      body: _buildProductsList(),
    );
  }

  Widget _buildProductsList(){
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
      
      Widget content = Center(child: Text('No Products found'));

      if (model.displayedProducts.length>0 && !model.isLoading){

        content = Products();

      } else if(model.isLoading){

          content = Center(child: CircularProgressIndicator(),);

      }

      return RefreshIndicator(onRefresh: model.fetchProducts, child: content,);

    },);
  }

}
