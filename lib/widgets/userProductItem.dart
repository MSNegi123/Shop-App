import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../constants/constants.dart';

class UserProductItem extends StatelessWidget {
  final String _id;
  final String _title;
  final String _imageUrl;

  const UserProductItem(this._id, this._title, this._imageUrl);

  @override
  Widget build(BuildContext context) {
    final _scaffold = ScaffoldMessenger.of(context);

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(_imageUrl),
          ),
          title: Text(
            _title,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => Navigator.of(context)
                      .pushNamed(Routes.addProductScreenRoute, arguments: _id)),
              IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () async {
                    try {
                      await Provider.of<Products>(context, listen: false)
                          .deleteProduct(_id);
                    } catch (error) {
                      _scaffold.showSnackBar(
                        SnackBar(
                          content: Text(
                            "Deleting Failed",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
        Divider(
          thickness: 1.2,
        ),
      ],
    );
  }
}
