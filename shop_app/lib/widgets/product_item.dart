import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: product.id);
            },
            child: Image.network(
              product.imageUrl,
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                    icon: product.isFavorite
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    onPressed: () {
                      product.toggleFavoriteState();
                    },
                    color: Theme.of(context).accentColor,
                  )),
          trailing: IconButton(
            icon: Icon(Icons.shopping_bag),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
