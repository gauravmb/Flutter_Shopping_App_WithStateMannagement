import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-detail";
  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context)?.settings.arguments as String;
    final product =
        Provider.of<Products>(context, listen: false).findByID(productID);
    //Get All Product ID
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 300,
            child: Image.network(product.imageUrl),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Price \$${product.price}',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              '${product.description}',
              style: TextStyle(
                fontSize: 20,
              ),
              softWrap: true,
            ),
          ),
        ],
      )),
    );
  }
}
