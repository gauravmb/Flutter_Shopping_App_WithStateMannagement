import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import '../widgets/cart_item_view.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart-screen";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        "\$${cart.totalAmount}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                        onPressed: () {
                          Provider.of<Orders>(context, listen: false).addOrder(
                              cart.cartItems.values.toList(), cart.totalAmount);
                          cart.clear();
                        },
                        child: Text(
                          "Order Now",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
                  ],
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cart.totalItems(),
            itemBuilder: (context, index) => CartItemView(
              id: cart.cartItems.values.toList()[index].id,
              price: cart.cartItems.values.toList()[index].price,
              quantity: cart.cartItems.values.toList()[index].quantity,
              title: cart.cartItems.values.toList()[index].title,
              productID: cart.cartItems.keys.toList()[index],
            ),
          )),
        ],
      ),
    );
  }
}
