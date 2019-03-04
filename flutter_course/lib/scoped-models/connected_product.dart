import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';
import '../models/auth.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:rxdart/subjects.dart';
import '../models/location_data.dart';

import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  String _selProductId;
  User _authenticatedUser;
  bool _isLoading = false;

  Future<Map<String, dynamic>> uploadImage(File image, {String imagePath}) async{

    final mimeTypeData = lookupMimeType(image.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse('https://us-central1-flutter-products-ap.cloudfunctions.net/storeImage'));

    final file = await http.MultipartFile.fromPath('image', image.path, contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

    imageUploadRequest.files.add(file);

    if(imagePath!=null){
        imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }

    imageUploadRequest.headers['Authorization'] = 'Bearer ${_authenticatedUser.token}';

    try{
      print('token: ' + _authenticatedUser.token);

      final streamedResponse = await imageUploadRequest.send();
      
      final response = await http.Response.fromStream(streamedResponse);

      if(response.statusCode != 200 && response.statusCode != 201){
        print('Something went wrong');
        print('BODY: ' + response.body.toString());
        print(json.decode(response.body));
        return null;
      }
      else{
        
        final responseData = json.decode(response.body);

        return responseData;
      }

    }
    catch(error){
      print(error);
      return null;
    }
  } 

  Future<bool> addProduct(String title, String description, File image, double price, LocationData locData) async {
    
    _isLoading = true;
    notifyListeners();

    final uploadData = await uploadImage(image);

    if(uploadData==null){
      print('Upload failed');
      return false;
    }

    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      //'image':'https://schrammsflowers.com/wp-content/uploads/2017/12/chocolate.jpg',
      'price':price,
      'userEmail': _authenticatedUser.eMail,
      'userId': _authenticatedUser.id,
      'imagePath':uploadData['imagePath'],
      'imageUrl':uploadData['imageUrl'],
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address
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
              image: uploadData['imageUrl'], 
              imagePath: uploadData['imagePath'], 
              price: price, 
              location: locData,
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

  Future<bool> updateProduct(String title, String description, File image, double price, LocationData locData) async{

    _isLoading = true;
    notifyListeners();

    String imageUrl = selectedProduct.image;
    String imagePath = selectedProduct.imagePath;
    if (image != null){
    
      final uploadData = await uploadImage(image);

      if(uploadData==null){
        print('Upload failed');
        return false;
      }

      imageUrl = uploadData['imageUrl'];
      imagePath = uploadData['imagePath'];

    }

    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'price': price,
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address,
      'userEmail': selectedProduct.userEmail, 
      'userId': selectedProduct.userId      
    };

    try{

        //final http.Response response = 
        await http.put('https://flutter-products-ap.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}', body: json.encode(updateData));
        _isLoading = false;   

        final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: title, 
        description: description, 
        image: imageUrl, 
        imagePath: imagePath,
        price: price, 
        location: locData,
        userEmail: selectedProduct.userEmail, 
        userId: selectedProduct.userId);

        _products[selectedProductIndex] = updatedProduct;

        //_selProductIndex = null;
        // print(_products);
   
        notifyListeners();
        return true;      
    }
    catch (error){
        print('errore: ' + error.toString());
        _isLoading = false;
        notifyListeners();
        // Errore http/servizio
        return false;
      }
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;

    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();

    return http.delete('https://flutter-products-ap.firebaseio.com/products/$deletedProductId.json?auth=${_authenticatedUser.token}').then((http.Response response){

        
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

  Future<Null> fetchProducts({bool onlyForUser = false, clearExisting = false}){

    _isLoading =true;
    if (clearExisting){
      _products = [];
    }

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
          image: productData['imageUrl'],
          imagePath: productData['imagePath'],
          price: productData['price'].toDouble(),
          location: LocationData(address: productData['loc_address'], latitude: productData['loc_lat'], longitude: productData['loc_lng']),
          userEmail: productData['userEmail'],
          userId: productData['userId'],
          isFavorite: productData['wishlistUsers'] == null ? false : (productData['wishlistUsers'] as Map<String, dynamic>).containsKey(_authenticatedUser.id)  
        );

        fetchedProductList.add(product);
        
      });
    
    // _products = fetchedProductList;

    _products = onlyForUser ? List.from(fetchedProductList.where(
      (Product product){
        return product.userId == _authenticatedUser.id;
      })) : fetchedProductList;

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

  void toggleProductFavoriteStatus() async{
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;

    // faccio comunque l'aggiornamento locale, in caso di errore della chiamata http, faccio nuovamente l'aggiornamento
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        location: selectedProduct.location,
        image: selectedProduct.image,
        imagePath: selectedProduct.imagePath,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);

    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
    
    http.Response response;
    final String urlBase = 'https://flutter-products-ap.firebaseio.com/products/';
    if (newFavoriteStatus){
        response = await http.put(urlBase + '${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}', body: json.encode(true));
      }

    else{
      
        response = await http.delete(urlBase + '${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
  }

  if (response.statusCode != 200 && response.statusCode != 201){
        print('Errore aggiornamento favoriti. Richiesta ${'https://console.firebase.google.com/u/0/project/flutter-products-ap/database/flutter-products-ap/data/products/' + selectedProduct.id + '/'} - code ${response.statusCode} ${response.body.toString()} selectedProduct.id:' + selectedProduct.id + ' _authenticatedUser.id: ' + _authenticatedUser.id + ' _authenticatedUser.token: ' + _authenticatedUser.token);
        final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        location: selectedProduct.location,
        image: selectedProduct.image,
        imagePath: selectedProduct.imagePath,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: !newFavoriteStatus);

        _products[selectedProductIndex] = updatedProduct;
        notifyListeners();
      }
      else{
        print('ok aggiornamento favoriti');
      }
      _selProductId = null;

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
    
    if (productId != null) {
      notifyListeners();
    }

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

      print('token: ' + responseData['idToken']);

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
      _selProductId =null;

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