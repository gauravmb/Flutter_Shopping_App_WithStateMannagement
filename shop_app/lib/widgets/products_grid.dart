import 'package:flutter/material.dart';
import 'package:shop_app/providers/products.dart';
import './product_item.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class ProductsGrid extends StatelessWidget {
  bool showOnlyFavorites;
  ProductsGrid(this.showOnlyFavorites);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    List<Product> products;
    if (showOnlyFavorites)
      products = productsData.favoritesItems;
    else
      products = productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(25.0),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: products[index], child: ProductItem()),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
