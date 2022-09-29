import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<void> toggleFavoriteState(String token, String userId) async {
    var oldFavoriteStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final urlString =
          'https://fluttershopapp-94add-default-rtdb.firebaseio.com/userFavorites/$userId/${this.id}.json?auth=$token';
      final url = Uri.parse(urlString);
      var response = await http.put(
        url,
        body: json.encode(
          this.isFavorite,
        ),
      );

      if (response.statusCode >= 400) {
        isFavorite = oldFavoriteStatus;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }
}
