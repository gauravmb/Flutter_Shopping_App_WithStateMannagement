import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
    required this.title,
  });

  void toggleFavoriteState() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
