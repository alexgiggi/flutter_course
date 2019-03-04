import 'package:flutter/material.dart';
import 'miaClasse.dart';
import 'dart:async';
import '../ui_elements/title_default.dart';
// import 'package:scoped_model/scoped_model.dart';
// import '../scoped-models/main.dart';
import '../models/product.dart';
import '../pages/scrolling_map.dart';
import '../widgets/products/product_fab.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

  void _showMap(BuildContext context) {
    print(
        'class ProductPage latitudine: ${product.location.latitude}, longitudine: ${product.location.longitude}');

    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
            appBar: AppBar(title: Text(product.location.address)),
            body: ScrollingMapPage(
                product.location.latitude, product.location.longitude))));

    // final List<Marker> markers = <Marker>[Marker('position', 'Position', product.location.latitude,product.location.longitude)];

    // final cameraPosition = CameraPosition(Location(product.location.latitude, product.location.longitude), 14.0);

    // final mapView = MapView();

    // mapView.show(MapOptions(
    //         initialCameraPosition: cameraPosition,
    //         mapViewType: MapViewType.normal,
    //         title: 'Product Location'),
    //         toolbarActions: [ToolbarAction('Close', 1),]);

    // mapView.onToolbarAction.listen((int id) {
    //   if (id == 1) {
    //     mapView.dismiss();
    //   }
    // });
    // mapView.onMapReady.listen((_) {
    //   mapView.setMarkers(markers);
    // });
  }

  Widget _buildAddressPriceRow(
      String address, double price, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          child: Text(address,
              style: TextStyle(fontFamily: 'Oswald', color: Colors.grey)),
          onPressed: () {
            _showMap(context);
          },
        )
            // GestureDetector(child: Text(address, style: TextStyle(fontFamily: 'Oswald', color: Colors.grey)), onTap: (){
            //   _showMap(context);
            // }
            // ,)
            ,
        SizedBox(
          width: 10.0,
        ),
        Text('\$: ' + price.toString(),
            style: TextStyle(fontFamily: 'Oswald', color: Colors.grey)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    MiaClasse mia = MiaClasse();
    mia.nome = 'Ale';
    mia.cancellabile = true;

    // _showWarningDialog(BuildContext context){
    //       showDialog(context: context, builder: (BuildContext context) {
    //               return AlertDialog( title: Text('Are you sure?'),
    //                                   content: Text('This action cannot be undone!'),
    //                                   actions: <Widget>[FlatButton(child: Text('Continue'), onPressed: ()
    //                                                     {
    //                                                       mia.cancellabile=true;
    //                                                       Navigator.pop(context);
    //                                                       Navigator.pop(context, mia);
    //                                                     },),
    //                                                     FlatButton(child: Text('Discard'), onPressed: ()
    //                                                     {
    //                                                       Navigator.pop(context);
    //                                                     })
    //                                                    ],
    //                                 );
    //             });
    // }

    return WillPopScope(
        onWillPop: () {
          print('back button pressed');
          mia.cancellabile = false;

          // Navigator.pop(context, mia); // con questa istruzione decido cosa passare quando viene premuto il back

          //return Future.value(false); //se chiamo solo questa funzione con parametro false è come se annullassi il back, il true fa passare il back
          return Future.value(true);
        },
        child: Scaffold(
          // appBar: AppBar(
          // title: Text(product.title),
          // // automaticallyImplyLeading: false // --> disabilita il pulsante di back per questa pagina
          // ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 256.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(product.title),
                  background: Hero(
                    tag: product.id,
                    child: FadeInImage(
                      image: NetworkImage(product.image),
                      height: 300.0,
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/food.jpg'),
                    ),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                  padding: EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: TitleDefault(product.title),
                ),
                _buildAddressPriceRow(
                    product.location.address, product.price, context),
                Container(
                    padding: EdgeInsets.all(10.0),
                    //alignment: Alignment.center,
                    child: Text(product.description,
                        style:
                            TextStyle(fontFamily: 'Oswald', color: Colors.grey),
                        textAlign: TextAlign.justify)
                    // Container(padding: EdgeInsets.all(0.0),child: RaisedButton(
                    //   color: Theme.of(context).accentColor, textColor: Colors.yellowAccent,
                    //   child: Text('Delete and back', textAlign: TextAlign.center,), onPressed: () {
                    //       _showWarningDialog(context);
                    //     } ,
                    // ),),
                    )
              ]))
            ],
          ),
          floatingActionButton: ProductFAB(product),
        ));
  }
}
