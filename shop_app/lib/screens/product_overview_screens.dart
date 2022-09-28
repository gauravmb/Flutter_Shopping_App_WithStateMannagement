import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverViewScreen extends StatefulWidget {
  var showOnlyFavorites = false;
  var _isInit = false;
  var _isLoading = false;
  @override
  State<ProductsOverViewScreen> createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!widget._isInit) {
      try {
        setState(() {
          widget._isLoading = true;
        });
        Provider.of<Products>(context).fetchAndSetProducts().then((_) {
          setState(() {
            widget._isLoading = false;
          });
        });
      } catch (error) {}
      widget._isInit = true;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

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
              itemBuilder: (context) => const [
                    PopupMenuItem(
                      child: Text("Only Favorites"),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text("All"),
                      value: FilterOptions.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (context, cart, ch) => Badge(
              value: cart.totalItems().toString(),
              color: Colors.red,
              child: ch as Widget,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: widget._isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(widget.showOnlyFavorites),
    );
  }
}
