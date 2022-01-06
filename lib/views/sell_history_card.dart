import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/pages/add_review.dart';
import 'package:gameaway/services/order.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';

class SellHistoryCard extends StatefulWidget {
  const SellHistoryCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  State<SellHistoryCard> createState() => _SellHistoryCardState();
}

class _SellHistoryCardState extends State<SellHistoryCard> {
  ExpandableController panelController =
      ExpandableController(initialExpanded: false);

  @override
  Widget build(BuildContext context) {
    var purchaseDate = widget.order.purchaseDate.toDate();
    return Padding(
      padding: Dimen.listPadding,
      child: Card(
        color: AppColors.captionColor,
        child: ExpandablePanel(
          builder: (_, collapsed, expanded) => Expandable(
            collapsed: collapsed,
            expanded: expanded,
          ),
          controller: panelController,
          expanded: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text("Sold at: ",
                              style: TextStyle(
                                color: AppColors.LightTextColor,
                                fontSize: 16,
                              )),
                          Text(
                            "${purchaseDate.year.toString()}-${purchaseDate.month.toString().padLeft(2, '0')}-${purchaseDate.day.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              color: AppColors.LightTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(widget.order.buyer,
                      maxLines: 3,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.LightTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                ),
              ],
            ),
          ),
          collapsed: Container(),
          header: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ListTile(
              onTap: () {
                setState(() {
                  panelController.toggle();
                });
              },
              title: Column(
                children: [
                  Text(
                    widget.order.productName,
                    maxLines: 2,
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              leading: Image.network(widget.order.url),
              trailing: Text(
                '\$ ${widget.order.price}',
                style: kButtonLightTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
