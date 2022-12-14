import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  final String token;

  ProductItem({required this.token});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                    icon: product.isFavorite
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border),
                    onPressed: () {
                      product.toggleFavoriteState(token, auth.userId ?? "");
                    },
                    color: Theme.of(context).accentColor,
                  )),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_bag),
            onPressed: () {
              cart.addItemToCart(product.id, product.title, product.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Added Item to cart"),
                action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    }),
                duration: Duration(seconds: 1),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: product.id);
            },
            child: Image.network(
              product.imageUrl,
            )),
      ),
    );
  }
}
