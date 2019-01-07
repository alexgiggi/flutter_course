import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  int _selectedProductIndex;


  List<Product> get products{
    return List.from(_products); // non restituisco il puntatore alla lista originale ma una copia della lista
  }

  void addProduct(Product product) {
    // funzione da passare al widget ProductControl per l'aggiunta di prodotti
    _products.add(product);
    _selectedProductIndex = null;
    print('Prodotti:' + _products.toString());
  }

  void updateProduct(Product product) {
    _products[_selectedProductIndex] = product;
    _selectedProductIndex = null;
    print(_products);
  }

  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
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
