import 'package:flutter/material.dart';
import 'package:gameaway/views/product_preview.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({Key? key, required this.list}) : super(key: key);

  final List<Product> list;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: List.generate(
                      list.length,
                      (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ProductPreview(product: list[index]),
                          )),
                ),
              ),
            ],
          )),
    );
  }
}
