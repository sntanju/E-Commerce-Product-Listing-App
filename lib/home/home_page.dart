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

  @override
  void initState() {
    super.initState();
    ref.read(productProvider.notifier).fetchInitialProducts();

    _controller.addListener(() {
      if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200) {
        ref.read(productProvider.notifier).fetchMoreProducts();
      }
    });
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
        toolbarHeight: 80, 
        title: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          
          
          children: [
            
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search Anything...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
              onChanged: (text) {
                ref.read(productProvider.notifier).searchProducts(text);
              },
            ),
            const SizedBox(height: 4),
            products.when(
              data: (list) => Text(
                '${list.length} items',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              loading: () => const SizedBox(),
              error: (e, _) => const SizedBox(),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showSortOptions,
          ),
        ],
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
