import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';

Widget productPreview(Product product) {
  return OutlinedButton(
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
            (states) => AppColors.primary.withOpacity(0.1)),
        shape: MaterialStateProperty.resolveWith((states) =>
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        padding:
            MaterialStateProperty.resolveWith((states) => EdgeInsets.zero)),
    onPressed: () {},
    child: Column(
      children: [
        Container(
          width: 150,
          padding: Dimen.smallPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                product.url,
                height: 150,
                width: 75,
              ),
              SizedBox(
                height: 30,
                child: Text(
                  product.productName,
                  style: kSmallTitle,
                ),
              ),
              Text(
                product.seller,
                style: kSmallText,
              ),
              const SizedBox(
                height: 20,
              ),
              RatingBarIndicator(
                rating: product.rating as double,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 18.0,
                unratedColor: Colors.amber.withAlpha(80),
                direction: Axis.horizontal,
              ),
              const SizedBox(
                height: 20,
              ),
              Text("\$ ${product.price}")
            ],
          ),
        )
      ],
    ),
  );
}

class Product {
  String url;
  String productName;
  String seller;
  num rating;
  num price;
  String category;
  String tag;

  Product(
      {required this.url,
      required this.productName,
      required this.rating,
      required this.price,
      this.category = "Games",
      this.tag = "All",
      this.seller = "Anonymous"});
}
