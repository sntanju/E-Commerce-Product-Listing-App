import 'package:hive/hive.dart';

class ProductCacheService {
  static const String boxName = 'productBox';

  Future<void> init() async {
    await Hive.openBox(boxName);
  }

  Future<void> saveProducts(List<dynamic> products) async {
    final box = Hive.box(boxName);
    await box.put('products', products);
  }

  List<dynamic> getCachedProducts() {
    final box = Hive.box(boxName);
    return box.get('products', defaultValue: []) as List<dynamic>;
  }

  Future<void> clearCache() async {
    final box = Hive.box(boxName);
    await box.clear();
  }
}
