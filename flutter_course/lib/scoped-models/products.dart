import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  int _selectedProductIndex;
  bool _showFavorites = false;

  List<Product> get products{
    return List.from(_products); // non restituisco il puntatore alla lista originale ma una copia della lista
  }

  List<Product> get displayedProducts{
    if (_showFavorites){
      return List.from(_products.where((Product product)=> product.isFavorite));
    }
    else{
      return List.from(_products); // non restituisco il puntatore alla lista originale ma una copia della lista
    }
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void addProduct(Product product) {
    // funzione da passare al widget ProductControl per l'aggiunta di prodotti
    _products.add(product);
    _selectedProductIndex = null;
    print('Prodotti:' + _products.toString());
    notifyListeners();
  }

  void updateProduct(Product product) {
    _products[_selectedProductIndex] = product;
    _selectedProductIndex = null;
    print(_products);
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
    notifyListeners();
  }

  void toggleProductFavoriteStatus(){
    
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    
    final Product updatedProduct = Product(title: selectedProduct.title, description: selectedProduct.description, price: selectedProduct.price, image: selectedProduct.image, isFavorite: newFavoriteStatus);
    _products[_selectedProductIndex] = updatedProduct;    
    notifyListeners(); 
    _selectedProductIndex = null;   
  }

  void toggleDisplayMode(){
    _showFavorites = !_showFavorites;
    notifyListeners(); 
  }

  int get selectedProductIndex{
    if(_selectedProductIndex==null){
      return null;
    }
    else
      return _selectedProductIndex;
  }

  void selectProduct(int indx){
    _selectedProductIndex = indx;
  }

  Product get selectedProduct{
      if(_selectedProductIndex==null){
      return null;
    }
    else 
      return _products[_selectedProductIndex];
  }

}
