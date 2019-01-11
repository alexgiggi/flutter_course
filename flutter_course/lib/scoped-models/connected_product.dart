import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  String _selProductId;
  User authenticatedUser;
  bool _isLoading = false;

  Future<bool> addProduct(String title, String description, String image, double price) {
    
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':'https://schrammsflowers.com/wp-content/uploads/2017/12/chocolate.jpg',
      'price':price,
      'userEmail': authenticatedUser.eMail,
      'userId': authenticatedUser.id
    };

    return http.post('https://flutter-products-ap.firebaseio.com/products.jsonX', body: jsonEncode(productData)).then((http.Response response){

      if (response.statusCode != 200 && response.statusCode != 201){
        _isLoading = false;
        notifyListeners();
        // Errore http/servizio
        return false;
      }  

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);

      // funzione da passare al widget ProductControl per l'aggiunta di prodotti
      final Product newProduct = Product(
        id: responseData['name'],
        title: title, 
        description: description, 
        image: image, 
        price: price, 
        userEmail: authenticatedUser.eMail, 
        userId: authenticatedUser.id);

      _products.add(newProduct);

      //_selProductIndex = null;
      print('Prodotti:' + newProduct.toString());

      _isLoading = false;

      notifyListeners();

      return true; 
      }).catchError((error){
        print('errore: ' + error.toString());
        _isLoading = false;
        notifyListeners();
        // Errore http/servizio
        return false;
      });    
  }
}

// ------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products); // non restituisco il puntatore alla lista originale ma una copia della lista
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return List.from(_products.where((Product product) => product.isFavorite));
    } else {
      return List.from(
          _products); // non restituisco il puntatore alla lista originale ma una copia della lista
    }
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  int get selectedProductIndex{
    return _products.indexWhere((Product product){
        return product.id == _selProductId;
      });
  }

  Future<bool> updateProduct(String title, String description, String image, double price) {

    _isLoading = true;

    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image': 'https://schrammsflowers.com/wp-content/uploads/2017/12/chocolate.jpg',
      'price': price,
      'userEmail': selectedProduct.userEmail, 
      'userId': selectedProduct.userId
    };

    return http.put('https://flutter-products-ap.firebaseio.com/products/${selectedProduct.id}.json', body: json.encode(updateData)).then((http.Response response){
    
      
        notifyListeners();      
        
        final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title, 
          description: description, 
          image: image, 
          price: price, 
          userEmail: selectedProduct.userEmail, 
          userId: selectedProduct.userId);

      _products[selectedProductIndex] = updatedProduct;

      //_selProductIndex = null;
      // print(_products);

      _isLoading = false;
      
      notifyListeners();
      return true;

    }).catchError((error){
        print('errore: ' + error.toString());
        _isLoading = false;
        notifyListeners();
        // Errore http/servizio
        return false;
      });


  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;

    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();

    return http.delete('https://flutter-products-ap.firebaseio.com/products/${deletedProductId}.json').then((http.Response response){

        
      _isLoading = false;
      notifyListeners();
      return true;

    }).catchError((error){
        print('errore: ' + error.toString());
        _isLoading = false;
        notifyListeners();
        // Errore http/servizio
        return false;
      });
    
  }

  Future<Null> fetchProducts(){

    _isLoading =true;
    notifyListeners();

    return http.get('https://flutter-products-ap.firebaseio.com/products.json').then<Null>((http.Response response){
      print('body response http: ' + response.body.toString());
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);

      if (productListData == null){
        _isLoading = false;
        notifyListeners();
        return;    
      }

      productListData.forEach((String productId, dynamic productData){
        final Product product = Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          image: productData['image'],
          price: productData['price'].toDouble(),
          userEmail: productData['userEmail'],
          userId: productData['userId']
        );

        fetchedProductList.add(product);
        
      });
    
    _products = fetchedProductList;

    _isLoading = false;
    
    notifyListeners();
    _selProductId = null;
    return;
    
    }).catchError((error){
        print('errore: ' + error.toString());
        _isLoading = false;
        notifyListeners();
        // Errore http/servizio
        return false;
      });

  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;

    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);

    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
    //_selProductIndex = null;
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  String get selectedProductId {
    if (_selProductId == null) {
      return null;
    } else
      return _selProductId;
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    notifyListeners();
    // if (productId != null) {
    //   notifyListeners();
    // }
  }

  Product get selectedProduct {
    if (_selProductId == null) {
      return null;
    } else
      return _products.firstWhere((Product product){
        return product.id == _selProductId;
      });
  }
}

// ------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------

mixin UserModel on ConnectedProductsModel{
  
  void login(String eMail, String password){

    authenticatedUser = User(id: 'dssdff', eMail: eMail, password: password);

  }

}

mixin UtilityModel on ConnectedProductsModel{
  
  bool get isLoading{return _isLoading;}


}