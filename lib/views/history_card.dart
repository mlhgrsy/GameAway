import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/pages/add_review.dart';
import 'package:gameaway/services/order.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';

class HistoryCard extends StatefulWidget {
  const HistoryCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        const Text("Purchase Date: ",
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
                OutlinedButton.icon(
                    onPressed: widget.order.reviewed
                        ? null
                        : () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AddReview(
                                            order: widget.order,
                                          )))
                            },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.white70)),
                    icon: widget.order.reviewed
                        ? const Icon(Icons.done)
                        : const Icon(
                            Icons.add_comment,
                            color: AppColors.primaryBackground,
                          ),
                    label: widget.order.reviewed
                        ? const Text("Reviewed")
                        : const Text("Add Review",
                            style:
                                TextStyle(color: AppColors.primaryBackground)))
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
              title: Text(
                widget.order.productName,
                maxLines: 2,
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 20,
                ),
              ),
              leading:
                  SizedBox(width: 50, child: Image.network(widget.order.url)),
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
