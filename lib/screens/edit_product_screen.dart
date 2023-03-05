import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/productModel.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = ProductModel(
      id: null, title: "", description: "", imageUrl: "", price: 0);
  var _initValues = {
    'title': '',
    'description': '',
    'price': '0',
    'imageUrl': '',
  };
  var _isLoading = false;

  @override
  void initState() {
    _imageFocusNode.addListener(_previewImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var _productId = ModalRoute.of(context).settings.arguments as String;
    if (_productId != null) {
      _editedProduct = Provider.of<Products>(context, listen: false)
          .findProductById(_productId);
      _initValues = {
        'title': _editedProduct.title,
        'description': _editedProduct.description,
        'price': _editedProduct.price.toString(),
        'imageUrl': _editedProduct.imageUrl,
      };
      _imageUrlController.text = _editedProduct.imageUrl;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_previewImage);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _previewImage() {
    if (!_imageFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith("http://") &&
              !_imageUrlController.text.startsWith("https://"))) return;
      setState(() {});
    }
  }

  void _saveFormData() async {
    var _isFormValid = _formKey.currentState.validate();
    if (!_isFormValid) return;
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((error) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("An error occurred"),
                  content: Text("!!Something went wrong!!"),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text("Okay"))
                  ],
                ));
      }).then(
        (_) => Navigator.of(context).pop(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveFormData),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  TextFormField(
                    initialValue: _initValues['title'],
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: Theme.of(context).textTheme.headline6),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter a valid title';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_priceFocusNode),
                    onSaved: (value) => _editedProduct = ProductModel(
                      id: _editedProduct.id,
                      title: value,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                      isFavourite: _editedProduct.isFavourite,
                    ),
                  ),
                  TextFormField(
                    initialValue: _initValues['price'],
                    focusNode: _priceFocusNode,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        labelText: 'Price',
                        labelStyle: Theme.of(context).textTheme.headline6),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter a price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Enter a valid price';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_descFocusNode),
                    onSaved: (value) => _editedProduct = ProductModel(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      price: double.parse(value),
                      isFavourite: _editedProduct.isFavourite,
                    ),
                  ),
                  TextFormField(
                    initialValue: _initValues['description'],
                    focusNode: _descFocusNode,
                    maxLines: 3,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: Theme.of(context).textTheme.headline6),
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter a description';
                      }
                      return null;
                    },
                    onSaved: (value) => _editedProduct = ProductModel(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: value,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                      isFavourite: _editedProduct.isFavourite,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 8.0, right: 6.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2.0)),
                        child: _imageUrlController.text.isEmpty
                            ? Text(
                                'Enter a Url to view its preview',
                                textAlign: TextAlign.center,
                                softWrap: true,
                              )
                            : Image.network(
                                _imageUrlController.text,
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                          focusNode: _imageFocusNode,
                          controller: _imageUrlController,
                          decoration: InputDecoration(
                              labelText: 'Image Url',
                              labelStyle:
                                  Theme.of(context).textTheme.headline6),
                          keyboardType: TextInputType.url,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter a image url';
                            }
                            if (!value.startsWith("http://") &&
                                !value.startsWith("https://")) {
                              return 'Enter a valid url';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _saveFormData(),
                          onSaved: (value) => _editedProduct = ProductModel(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: value,
                            price: _editedProduct.price,
                            isFavourite: _editedProduct.isFavourite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
