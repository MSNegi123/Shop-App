import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String _title;
  final String _imageUrl;

  const UserProductItem(this._title, this._imageUrl);

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () {}),
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
