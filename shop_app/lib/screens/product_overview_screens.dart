import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverViewScreen extends StatefulWidget {
  var showOnlyFavorites = false;
  @override
  State<ProductsOverViewScreen> createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (FilterOptions selected) {
                setState(() {
                  if (selected == FilterOptions.All) {
                    widget.showOnlyFavorites = false;
                  } else {
                    widget.showOnlyFavorites = true;
                  }
                });
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Only Favorites"),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text("All"),
                      value: FilterOptions.All,
                    ),
                  ])
        ],
      ),
      body: ProductsGrid(widget.showOnlyFavorites),
    );
  }
}
