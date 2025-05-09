import 'package:ecommerce_product_listing_app/presentation/home/product_cache_service.dart';
import 'package:ecommerce_product_listing_app/presentation/home/sort_option.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/product_service.dart';

final productProvider = AsyncNotifierProvider<ProductNotifier, List<dynamic>>(() {
  return ProductNotifier();
});

class ProductNotifier extends AsyncNotifier<List<dynamic>> {

  final _productService = ProductService();
  final _cacheService = ProductCacheService();

  final List<dynamic> _allProducts = [];
  int _page = 0;

  final int _limit = 10;
  bool _isFetching = false;

  String _searchText = '';
  SortOption? _sortOption;

  @override
  Future<List<dynamic>> build() async {

    await _cacheService.init();

    try {
      final products = await _productService.fetchProducts(limit: _limit, skip: _page * _limit);
      _allProducts.addAll(products);
      await _cacheService.saveProducts(_allProducts);
      return _applyFilters();
    } catch (e) {
      
      final cachedProducts = _cacheService.getCachedProducts();
      _allProducts.addAll(cachedProducts);
      return _applyFilters();
    }
   
  }

  Future<List<dynamic>> _fetchAndCache() async {
      try {
        final products = await _productService.fetchProducts(limit: _limit, skip: _page * _limit);
        _allProducts.addAll(products);
        await _cacheService.saveProducts(_allProducts);
        return _applyFilters();
      } catch (e) {
        return _applyFilters();
      }
  }

  Future<void> fetchInitialProducts() async {
    _page = 0;
    _allProducts.clear();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchAndCache());
  }

  Future<void> fetchMoreProducts() async {
    if (_isFetching) return;
    _isFetching = true;
    _page++;
    await _fetchAndCache();
    _isFetching = false;
  }

  Future<void> searchProducts(String text) async {
    _searchText = text.toLowerCase();
    state = AsyncValue.data(_applyFilters());
  }

  Future<void> sortProducts(SortOption option) async {
    _sortOption = option;
    state = AsyncValue.data(_applyFilters());
  }

  List<dynamic> _applyFilters() {
    var filtered = _allProducts;

    if (_searchText.isNotEmpty) {
      filtered = filtered.where((p) => p['title'].toLowerCase().contains(_searchText)).toList();
    }

    if (_sortOption != null) {
      if (_sortOption == SortOption.priceLowToHigh) {
        filtered.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (_sortOption == SortOption.priceHighToLow) {
        filtered.sort((a, b) => b['price'].compareTo(a['price']));
      } else if (_sortOption == SortOption.rating) {
        filtered.sort((b, a) => a['rating'].compareTo(b['rating'])); 
      }
    }

    return filtered;
  }
}
