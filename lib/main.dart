import 'package:ecommerce_product_listing_app/home/product_service.dart';
import 'package:flutter/material.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();

  final productService = ProductService();
  final products = await productService.fetchProducts();

  print(products); 

  runApp(MyApp());
}
 
 class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecommerce Product App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(child: Text("Checking product data in console")),
      ),
    );
  }
}