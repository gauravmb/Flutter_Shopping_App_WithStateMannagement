import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text("hello"),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text("Shop"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text("Orders"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: Icon(Icons.shop),
          title: Text("Manager Products"),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: Icon(Icons.shop),
          title: Text("Logout "),
          onTap: () {
            Provider.of<Auth>(context, listen: false).logout();
          },
        )
      ]),
    );
  }
}
