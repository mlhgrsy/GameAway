import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/edit_product.dart';
import 'package:gameaway/views/product_preview.dart';
import 'delete_product.dart';

class StockEditor extends StatefulWidget {
  const StockEditor({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  State<StockEditor> createState() => _StockEditorState();
}

class _StockEditorState extends State<StockEditor> {
  num count = 0;

  @override
  void initState() {
    super.initState();
    count = widget.product.stocks;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primary.withOpacity(0.1)),
          padding: Dimen.smallPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Image.network(
                      widget.product.url,
                      height: 100,
                      width: 75,
                    ),
                    Text(widget.product.productName,
                        style: kSmallTitle, textAlign: TextAlign.center),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            count--;
                          });
                        },
                        icon: const Icon(Icons.remove)),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: TextEditingController(text: "$count"),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            count++;
                          });
                        },
                        icon: const Icon(Icons.add)),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Ink(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.primaryBackground, width: 4.0),
                    color: AppColors.primaryBackground,
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                      borderRadius: BorderRadius.circular(1000.0),
                      onTap: () async {
                        if (count <= 0) {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: const Text("Error"),
                                    content: const Text(
                                        "Please provide a positive value"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("OK"))
                                    ],
                                  ));
                        } else {
                          DBService db = DBService();
                          await db.productCollection
                              .doc(widget.product.pid)
                              .update({"stocks": count});
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: const Text("Success"),
                                    content: const Text(
                                        "Product stocks have been changed"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("OK"))
                                    ],
                                  ));
                        }
                      },
                      child: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Icon(Icons.save, color: Colors.white))),
                ),
              )
            ],
          ),
        ),
        Visibility(
            visible: count <= 0,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Out of Stock",
                style: TextStyle(color: AppColors.notification, fontSize: 20),
              ),
            ))
      ],
    );
  }
}

List<Widget> editableButtons(context, product, refreshFunc) {
  return <Widget>[
    Positioned(
      top: 0,
      left: 0,
      child: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EditProduct(
                        product: product, refreshFunc: refreshFunc)));
          },
          icon: const Icon(Icons.edit)),
    ),
    Positioned(
        top: 0,
        right: 0,
        child: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => DeleteProduct(
                      pid: product.pid, refreshFunc: refreshFunc));
            },
            icon: const Icon(Icons.delete))),
  ];
}
