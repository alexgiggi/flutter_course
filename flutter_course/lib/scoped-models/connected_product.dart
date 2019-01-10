import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  int _selProductIndex;
  User authenticatedUser;
  bool _isLoading = false;

  Future<Null> addProduct(String title, String description, String image, double price) {
    
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

    return http.post('https://flutter-products-ap.firebaseio.com/products.json', body: jsonEncode(productData)).then((http.Response response){

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

  void updateProduct(String title, String description, String image, double price) {
    
    final Product updatedProduct = Product(
      title: title, 
      description: description, 
      image: image, 
      price: price, 
      userEmail: selectedProduct.userEmail, 
      userId: selectedProduct.userId);

    _products[_selProductIndex] = updatedProduct;
    //_selProductIndex = null;
    print(_products);
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(_selProductIndex);
    //_selProductIndex = null;
    notifyListeners();
  }

  void fetchProducts(){

    _isLoading =true;
    notifyListeners();

    http.get('https://flutter-products-ap.firebaseio.com/products.json').then((http.Response response){
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
    });

  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;

    final Product updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[_selProductIndex] = updatedProduct;
    notifyListeners();
    //_selProductIndex = null;
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  int get selectedProductIndex {
    if (_selProductIndex == null) {
      return null;
    } else
      return _selProductIndex;
  }

  void selectProduct(int indx) {
    _selProductIndex = indx;

    if (indx != null) {
      notifyListeners();
    }

  }

  Product get selectedProduct {
    if (_selProductIndex == null) {
      return null;
    } else
      return _products[_selProductIndex];
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