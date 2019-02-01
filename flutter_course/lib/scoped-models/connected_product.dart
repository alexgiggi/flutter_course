import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';
import '../models/auth.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:rxdart/subjects.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  String _selProductId;
  User _authenticatedUser;
  bool _isLoading = false;

  Future<bool> addProduct(String title, String description, String image, double price) async {
    
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':'https://schrammsflowers.com/wp-content/uploads/2017/12/chocolate.jpg',
      'price':price,
      'userEmail': _authenticatedUser.eMail,
      'userId': _authenticatedUser.id
    };

    try{
          final http.Response response = await http.post('https://flutter-products-ap.firebaseio.com/products.json?auth=${_authenticatedUser.token}', body: jsonEncode(productData));
          // .then((http.Response response){

            if (response.statusCode != 200 && response.statusCode != 201){
              print('errore, codice ' + response.statusCode.toString());
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
              userEmail: _authenticatedUser.eMail, 
              userId: _authenticatedUser.id);

            _products.add(newProduct);

            //_selProductIndex = null;
            print('Prodotti:' + newProduct.toString());

            _isLoading = false;

            notifyListeners();

            return true; 
    }
    catch (error){
        print('errore catturato: ' + error.toString());
        _isLoading = false;
        notifyListeners();
        // Errore http/servizio
        return false;
    }
      // })
      // .catchError((error){
      //   print('errore: ' + error.toString());
      //   _isLoading = false;
      //   notifyListeners();
      //   // Errore http/servizio
      //   return false;
      // });    
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

    return http.put('https://flutter-products-ap.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}', body: json.encode(updateData)).then((http.Response response){
    
      
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

    return http.delete('https://flutter-products-ap.firebaseio.com/products/${deletedProductId}.json?auth=${_authenticatedUser.token}').then((http.Response response){

        
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

    return http.get('https://flutter-products-ap.firebaseio.com/products.json?auth=${_authenticatedUser.token}').then<Null>((http.Response response){
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
  
  Timer _authTimer;
  
  PublishSubject<bool> _userSubject = PublishSubject();

  PublishSubject<bool> get userSubject{
    return _userSubject;
  }

  User get user{
      if (_authenticatedUser==null)
        print('***** _authenticatedUser==null');
      return _authenticatedUser;
  }

  Future<Map<String, dynamic>> authenticate(String eMail, String password, [AuthMode mode = AuthMode.Login]) async{

    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> authData = {
      'email': eMail,
      'password': password,
      'returnSecureToken': true
    };
    
    http.Response response;

    if (mode==AuthMode.Login){
      response = await http.post('https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyBhOVWvtXXQP_f8oKf2djVU8sPv-RYdAaQ',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    }else{
      response = await http.post('https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyBhOVWvtXXQP_f8oKf2djVU8sPv-RYdAaQ', 
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    }
    
    Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode==200 && responseData.containsKey('idToken'))
    {
      print('ritorno authenticate' + response.body);
      
      _isLoading = false;
      notifyListeners();
      _authenticatedUser = User(id: responseData['localId'], eMail: eMail, token: responseData['idToken']);

      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      final DateTime now = DateTime.now();
      final DateTime expiryTime = now.add(Duration(seconds: int.parse(responseData['expiresIn'])));

      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', eMail);
      prefs.setString('userId', responseData['localId']);

      prefs.setString('expiryTime', expiryTime.toIso8601String());

      return {'success': true, 'message': 'Authentication succeded'};       
    }
    else{
          String messaggioErrore = responseData['error']['message'];

          print('ERRORE signup! ' + messaggioErrore + ' ' + response.statusCode.toString());

          if (messaggioErrore == 'EMAIL_NOT_FOUND'){
            _isLoading = false;
            notifyListeners();
            return {'success': false, 'message': 'This email was not found'};
          }
          else if (messaggioErrore == 'INVALID_EMAIL'){
            _isLoading = false;
            notifyListeners();
            return {'success': false, 'message': 'Invalid email'};
          }
          else if (messaggioErrore == 'INVALID_PASSWORD'){
            _isLoading = false;
            notifyListeners();
            return {'success': false, 'message': 'Invalid password'};
          }
          else if (messaggioErrore == 'EMAIL_EXISTS'){
            _isLoading = false;
            notifyListeners();
            return {'success': false, 'message': 'Invalid password'};
          }
          else{
            _isLoading = false;
            notifyListeners();
            return {'success': false, 'message': 'Something went wrong'};
          }

    }
    // authenticatedUser = User(id: 'dssdff', eMail: eMail, password: password);
  }

  void autoAuthenticate() async{
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');

    final String expiryTimeString = prefs.getString('expiryTime');

    if (token!= null){
      
      final DateTime now = DateTime.now();
      final DateTime parsedExpiryTime = DateTime.parse(expiryTimeString);

      if (parsedExpiryTime.isBefore(now)){
        // token expired
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');

      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds; // quanti secondi mancano allo scadere della sessione del token

      if (prefs.getString('userEmail')==null)
        print('ok recupero cache');
      else
        print('Cache non trovata');

      _authenticatedUser = User(id: userId, eMail: userEmail, token: token);

      _userSubject.add(true);

      setAuthTimeout(tokenLifespan);

      notifyListeners();     
    }
  }

  void logout() async{
      _authenticatedUser = null;
      _authTimer.cancel(); //reset timer
      _userSubject.add(false);
      
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      print('logout!');
      prefs.remove('userEmail');
      prefs.remove('userId');
      prefs.remove('token');
      
      // _userSubject.add(false);

      if (prefs.getString('userEmail')==null)
        print('ok reset');
      else
        print('Reset non riuscito');

     
  }

  void setAuthTimeout(int time){

    _authTimer = Timer(Duration(seconds: time), (){
      print('timer scaduto!');
      logout();      
    });

    print('Settato timer di ' + time.toString() + ' secondi.');
  }

  // ristrutturazione codice, la parte signup finisce nel metodo authenticate
  // Future<Map<String, dynamic>> signup(String email, String password) async{
    
  //   _isLoading = true;
  //   notifyListeners();

  //   final Map<String, dynamic> authData = {
  //     'email': email,
  //     'password': password,
  //     'returnSecureToken': true
  //   };

  //   // la API_KEY si trova su FireBase nella sezione Authentication cliccando sul pulsante 'Configurazione web'
  //   http.Response response = await http.post('https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyBhOVWvtXXQP_f8oKf2djVU8sPv-RYdAaQ', 
  //   body: json.encode(authData),
  //   headers: {'Content-Type': 'application/json'});
    
  //   Map<String, dynamic> responseData = json.decode(response.body);

  //   if (response.statusCode==200 || responseData.containsKey('idToken'))
  //   {
  //     print('ritorno login' + response.body);
      
  //     _isLoading = false;
  //     notifyListeners();
      
  //     return {'success': true, 'message': 'Authentication succeded'};       
  //   }
  //   else{
  //         String messaggioErrore = responseData['error']['message'];

  //         print('ERRORE signup! ' + messaggioErrore + ' ' + response.statusCode.toString());

  //         if (messaggioErrore == 'EMAIL_EXISTS'){
  //           _isLoading = false;
  //           notifyListeners();
  //           return {'success': false, 'message': 'This email alredy exist'};
  //         }
  //         else{
  //           _isLoading = false;
  //           notifyListeners();
  //           return {'success': false, 'message': 'Something went wrong'};
  //         }
  //   }    
  // }
}

mixin UtilityModel on ConnectedProductsModel{
  
  bool get isLoading{return _isLoading;}


}