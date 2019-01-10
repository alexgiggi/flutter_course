import 'package:scoped_model/scoped_model.dart';
import './connected_product.dart';

class MainModel extends Model with ConnectedProductsModel, UserModel, ProductsModel, UtilityModel{ //--> guarda il file analysis_options.yaml per evitare l'errore mixin ...


}