import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/products.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = "/edit-product-screen";

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _desFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageURLFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _didInitCalled = false;
  var _initValues = {
    'title': "1",
    'description': "1",
    'price': "1",
    'imageUrl': "1",
  };
  var _existingProduct = Product(
      id: '',
      title: "",
      description: "",
      imageUrl: "",
      isFavorite: false,
      price: 0);

  @override
  void initState() {
    _imageUrlController.addListener(_updateImageURL);
  }

  void _updateImageURL() {
    // if (!_imageURLFocusNode.hasFocus) {}
  }

  @override
  void didChangeDependencies() {
    if (!_didInitCalled) {
      final productID = ModalRoute.of(context)?.settings.arguments as String?;
      if (productID != null) {
        _existingProduct = Provider.of<Products>(context).findByID(productID);
        _initValues = {
          'title': _existingProduct.title,
          'description': _existingProduct.description,
          'price': _existingProduct.price.toString(),
          'imageUrl': _existingProduct.imageUrl,
        };
        _imageUrlController.text = _existingProduct.imageUrl;
      }
    }
    print(_initValues);
    _didInitCalled = true;
    super.didChangeDependencies();
  }

  void _saveForm() {
    bool isValid = false;
    isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState?.save();
    print(_existingProduct.id);
    print(_existingProduct.description);
    print(_existingProduct.title);
    print(_existingProduct.imageUrl);
    print(_existingProduct.isFavorite);
    if (_existingProduct.id == "") {
      Provider.of<Products>(context, listen: false)
          .addProduct(_existingProduct);
    } else {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_existingProduct.id, _existingProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _imageUrlController.removeListener(_updateImageURL);
    _priceFocusNode.dispose();
    _desFocusNode.dispose();
    _imageURLFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _initValues["title"],
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please provide value';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _existingProduct = Product(
                        id: _existingProduct.id,
                        price: _existingProduct.price,
                        title: value!,
                        imageUrl: _existingProduct.imageUrl,
                        isFavorite: _existingProduct.isFavorite,
                        description: _existingProduct.description);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  initialValue: _initValues["price"],
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_desFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please provide value';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _existingProduct = Product(
                        id: _existingProduct.id,
                        price: double.parse(value!),
                        title: _existingProduct.title,
                        imageUrl: _existingProduct.imageUrl,
                        isFavorite: _existingProduct.isFavorite,
                        description: _existingProduct.description);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  initialValue: _initValues["description"],
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _desFocusNode,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please provide value';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _existingProduct = Product(
                        id: _existingProduct.id,
                        price: _existingProduct.price,
                        title: _existingProduct.title,
                        imageUrl: _existingProduct.imageUrl,
                        isFavorite: _existingProduct.isFavorite,
                        description: value!);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 8),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: _imageUrlController.text.isEmpty
                          ? Text("Enter a URL")
                          : Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                        child: TextFormField(
                      decoration: InputDecoration(labelText: "Image URL"),
                      // initialValue: _initValues["imageUrl"],
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageURLFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please provide value';
                        }
                        return null;
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        setState(() {});
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _existingProduct = Product(
                            id: _existingProduct.id,
                            price: _existingProduct.price,
                            title: _existingProduct.title,
                            imageUrl: value!,
                            isFavorite: _existingProduct.isFavorite,
                            description: _existingProduct.description);
                      },
                    )),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
