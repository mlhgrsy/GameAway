import 'package:flutter/material.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/add_product.dart';
import 'package:gameaway/views/my_products.dart';
import 'package:gameaway/views/my_stocks.dart';

class SellProduct extends StatefulWidget {
  const SellProduct({Key? key}) : super(key: key);

  @override
  State<SellProduct> createState() => _SellProductState();
}

class _SellProductState extends State<SellProduct>
    with TickerProviderStateMixin {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            titleTextStyle: kAppBarTitleTextStyle,
            toolbarHeight: 55,
            centerTitle: true,
            title: const Text("Add/Increase Products"),
            backgroundColor: AppColors.primaryBackground,
            elevation: 0.0,
            bottom: TabBar(
              onTap: (value) {
                setState(() {
                  _currentTab = value;
                });
              },
              tabs: const [
                Tab(text: "My Products"),
                Tab(text: "Check Stocks"),
              ],
            ),
          ),
          body: const TabBarView(
            children: [MyProducts(), MyStocks()],
          ),
          floatingActionButton: Visibility(
            visible: _currentTab == 0,
            child: FloatingActionButton.extended(
                backgroundColor: AppColors.primaryBackground,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const AddProduct()));
                },
                label: const Text("New"),
                icon: const Icon(Icons.add)),
          )),
    );
  }
}
