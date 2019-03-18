import 'package:flutter/material.dart';
import './product_edit.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ProductListPage extends StatefulWidget {

  final MainModel model;  

  ProductListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    
    return _ProductListPageState();
  }

}

class _ProductListPageState extends State<ProductListPage>{

  @override
  initState(){ // questa classe è diventata stateful solo per poter utilizzare questa funzione
    widget.model.fetchProducts(onlyForUser: true, clearExisting: true);
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel productsModel){
    
      return IconButton(
              icon: Icon(
                Icons.edit,
                size: 30.0,
              ),
              onPressed: () {
                productsModel.selectProduct(productsModel.allProducts[index].id);
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return ProductEditPage();
                })).then((_){
                   productsModel.selectProduct(null);
                });
              },
            );    
  }
  @override
  Widget build(BuildContext context) {
    // return Center(child: Text('All products'),);

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
          return ListView.builder(
        itemCount: model.allProducts.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(model.allProducts[index].title),
            background: Container(color: Colors.red,child: Text('NO!! CAZZO!!',style: TextStyle(color: Colors.white ,fontSize: 80, fontWeight: FontWeight.bold, fontFamily: 'Oswald'),),),
            onDismissed: (DismissDirection direction){
              
              model.selectProduct(model.allProducts[index].id);
              
              if(direction==DismissDirection.endToStart){
                model.deleteProduct();
              }
              else if (direction==DismissDirection.startToEnd) {
                print('start to end');
              } else{
                print('other swiping');
              }
            },
            child: Column(children: <Widget>[
                                              ListTile(contentPadding: EdgeInsets.symmetric(horizontal: 2.5),
                                                        leading: CircleAvatar(//backgroundImage: AssetImage(model.allProducts[index].image
                                                                                backgroundImage: NetworkImage(model.allProducts[index].image),
                                                                            ),
                                                        title: Text(model.allProducts[index].title),
                                                        subtitle: Text('\$ ${model.allProducts[index].price.toString()}'),
                                                        trailing: _buildEditButton(context, index, model),
                                                      ),
                                            Divider(
                                              height: 10.0,
                                              color: Colors.orange,            
                                            )
                                          ]
          ,           ),
          );
        });
      });
  }
}
