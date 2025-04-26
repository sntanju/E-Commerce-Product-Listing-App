import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product_service.dart';

final productProvider = AsyncNotifierProvider<ProductNotifier, List<dynamic>>(() {
  return ProductNotifier();
});

class ProductNotifier extends AsyncNotifier<List<dynamic>> {
  final _productService = ProductService();
  int _page = 0;
  final int _limit = 10;
  bool _isFetching = false;

  @override
  Future<List<dynamic>> build() async {
    return await _productService.fetchProducts(limit: _limit, skip: _page * _limit);
  }

  Future<void> fetchInitialProducts() async {
    _page = 0;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _productService.fetchProducts(limit: _limit, skip: _page * _limit));
  }

  Future<void> fetchMoreProducts() async {
    if (_isFetching) return;
    _isFetching = true;
    _page++;
    final more = await _productService.fetchProducts(limit: _limit, skip: _page * _limit);
    state = AsyncValue.data([...state.value ?? [], ...more]);
    _isFetching = false;
  }
}
