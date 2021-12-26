import 'package:flutter/material.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';

Widget productPreview(Product product) {
  return SizedBox(
      width: Dimen.productWidth,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: .5,
            child: Container(
              padding: Dimen.smallPadding,
              decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    iconSize: 150,
                    splashRadius: 70,
                    icon: Image.network(
                      product.url,
                      height: 150,
                      width: 75,
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(
                    height: 30,
                    child: TextButton(
                      child: Text(
                        product.productName,
                        style: kSmallTitle,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: TextButton(
                      child: Text(
                        product.seller,
                        style: kSmallText,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.star,color: Colors.yellow), Text("${product.rating}",style: kImportantText)],
                  ),
                  Text("\$ ${product.price}")
                ],
              ),
            ),
          )
        ],
      ));
}

class Product {
  String url;
  String productName;
  String seller;
  num rating;
  num price;

  Product(
      {required this.url,
      required this.productName,
      required this.rating,
      required this.price,
      this.seller = "Anonymous"});
}
