import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product_provider.dart';
import 'product_cart.dart';
import 'sort_option.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  final ScrollController _controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  bool _showSortButton = false;
  bool _showItemsCount = false;

  @override
  void initState() {
    super.initState();
    ref.read(productProvider.notifier).fetchInitialProducts();


    _focusNode.addListener(() {
      setState(() {
        _showSortButton = _focusNode.hasFocus;
      });
    });

    _controller.addListener(() {
      if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200) {
        ref.read(productProvider.notifier).fetchMoreProducts();
      }
    });
  }

  void _onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(productProvider.notifier).searchProducts(text);
      setState(() {
        _showItemsCount = text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

   void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Price: Low to High'),
            onTap: () {
              ref.read(productProvider.notifier).sortProducts(SortOption.priceLowToHigh);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Price: High to Low'),
            onTap: () {
              ref.read(productProvider.notifier).sortProducts(SortOption.priceHighToLow);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Rating'),
            onTap: () {
              ref.read(productProvider.notifier).sortProducts(SortOption.rating);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);

     return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100, 
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search Anything...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                if (_showSortButton)
                  const SizedBox(width: 8),
                if (_showSortButton)
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: _showSortOptions,
                  ),
              ],
            ),
            const SizedBox(height: 15),
            if (_showItemsCount)
              Center(
                child: products.when(
                  data: (list) => Text(
                    '${list.length} items',
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  loading: () => const SizedBox(),
                  error: (e, _) => const SizedBox(),
                ),
              ),
          ],
        ),
      ),
      body: products.when(
        data: (list) => GridView.builder(
          controller: _controller,
          padding: const EdgeInsets.all(10),
          itemCount: list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.62,
          ),
          itemBuilder: (context, index) => ProductCard(product: list[index], index: index,),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
