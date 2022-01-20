import 'package:flutter/material.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/services/loading.dart';
import 'package:gameaway/views/product_preview.dart';
import 'package:provider/provider.dart';

class DeleteProduct extends StatefulWidget {
  const DeleteProduct({Key? key, required this.pid, this.refreshFunc})
      : super(key: key);

  final String pid;
  final Function? refreshFunc;

  @override
  _DeleteProductState createState() => _DeleteProductState();
}

class _DeleteProductState extends State<DeleteProduct> {
  DBService db = DBService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm Deletion"),
      content: const Text("Are you sure you want to delete this product?"),
      actions: [
        TextButton(
          child: const Text("Confirm"),
          onPressed: () async {
            Provider.of<Loading>(context,listen: false).increment();
            await db.deleteProduct(widget.pid);
            widget.refreshFunc!();
            Navigator.of(context).pop();
            Provider.of<Loading>(context,listen: false).decrement();
          },
        ),
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
