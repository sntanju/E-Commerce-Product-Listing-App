# Ecommerce_Product_Listing_App

This Flutter app fetches product data from an API (DummyJSON), implements infinite scrolling for pagination, and allows users to search and filter products by name, price, and rating and caches product data locally to show offline. The app uses Riverpod 2.0 for state management.

## 📸Screenshots
- Initial home page with products  
  <p align="center"> <img width="200" src="assets/images/Screenshot 1.png"> <img width="200" src="assets/images/Screenshot 2.png"> </p>

- Showing searched Products  
  <p align="center"> <img width="200" src="assets/images/Screenshot 3.png"> <img width="200" src="assets/images/Screenshot 4.png"> </p>

- Sorted by high price to low price  
  <p align="center"> <img width="200" src="assets/images/Screenshot 5.png"> <img width="200" src="assets/images/Screenshot 6.png"> <img width="200" src="assets/images/Screenshot 7.png"> </p>

## Core Features Implemented

### 1. Product List
- Fetch products: The app fetches product data from DummyJSON API.
- Pagination: Infinite scrolling functionality.

### 2. Search & Filters
- Search: Users can search products by name.
- Sorting: Products can be sorted by price (low-high) or rating.

### 3. State Management
- Riverpod 2.0: Used for efficient state management to minimize unnecessary rebuilds.

## 🗄️Offline-First Support
- Products data is cached locally using Hive.
- If there is no internet connection, previously cached products will still be shown( without image).

