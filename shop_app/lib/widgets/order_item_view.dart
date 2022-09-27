import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItemView extends StatefulWidget {
  final OrderItem order;
  OrderItemView({required this.order});

  @override
  State<OrderItemView> createState() => _OrderItemViewState();
}

class _OrderItemViewState extends State<OrderItemView> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${widget.order.amount}'),
          subtitle: Text(
              DateFormat('dd mm yyyy hh:mm').format(widget.order.dateTime)),
          trailing: IconButton(
            icon: Icon(_isExpanded ? Icons.expand_more : Icons.expand_less),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
        ),
        if (_isExpanded)
          Container(
            height: min(widget.order.products.length * 20.0 + 10.0, 180),
            padding: EdgeInsets.all(5),
            child: ListView(
              children: widget.order.products
                  .map((product) => Row(
                        children: [
                          Text(product.title),
                          Spacer(),
                          Text('${product.quantity} x \$${product.price}')
                        ],
                      ))
                  .toList(),
            ),
          )
      ]),
    );
  }
}
