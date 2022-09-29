import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  late String _authToken;
  late String _userId;

  Products(String authTokenL, List<Product> itemsL, String userId) {
    _authToken = authTokenL;
    _items = itemsL;
    _userId = userId;
  }

  String get authToken {
    return _authToken;
  }

  Future<void> fetchAndSetProducts() async {
    final urlString =
        'https://fluttershopapp-94add-default-rtdb.firebaseio.com/products.json?auth=$_authToken';
    final url = Uri.parse(urlString);
    final urlStringFavorites =
        'https://fluttershopapp-94add-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken';
    final urlFavorites = Uri.parse(urlStringFavorites);
    try {
      //Fetch favorites
      final responseFavorites = await http.get(urlFavorites);
      final favoriteData = json.decode(responseFavorites.body);

      //Fetch produts
      final response = await http.get(url);
      if (json.decode(response.body) != null) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        final List<Product> loadedProducts = [];
        extractedData.forEach((key, value) {
          loadedProducts.add(Product(
              id: key,
              title: value['title'],
              description: value['description'],
              imageUrl: value['imageUrl'],
              isFavorite: (favoriteData == null || favoriteData[key] == null)
                  ? false
                  : favoriteData[key],
              price: value['price']));
        });
        _items = loadedProducts;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  List<Product> get favoritesItems {
    return [..._items].where((element) => element.isFavorite == true).toList();
  }

  Future<void> addProduct(Product value) async {
    final urlString =
        'https://fluttershopapp-94add-default-rtdb.firebaseio.com/products.json?auth=$_authToken';
    final url = Uri.parse(urlString);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': value.title,
          'description': value.description,
          'imageUrl': value.imageUrl,
          'price': value.price,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: value.title,
        description: value.description,
        price: value.price,
        isFavorite: false,
        imageUrl: value.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product value) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      try {
        final urlString =
            'https://fluttershopapp-94add-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken';
        final url = Uri.parse(urlString);
        await http.patch(
          url,
          body: json.encode({
            'title': value.title,
            'description': value.description,
            'imageUrl': value.imageUrl,
            'price': value.price,
          }),
        );
        _items[prodIndex] = value;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  void deleteProduct(String productID) {
    final urlString =
        'https://fluttershopapp-94add-default-rtdb.firebaseio.com/products/$productID.json?auth=$_authToken';
    final url = Uri.parse(urlString);
    var existingProductIndex =
        _items.indexWhere((element) => element.id == productID);
    var existingProduct = _items[existingProductIndex];
    http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        throw HttpException("Unable to delete product");
      }
    }).catchError((error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      print(error);
    });
    _items.removeAt(existingProductIndex);
    notifyListeners();
  }

  Product findByID(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
