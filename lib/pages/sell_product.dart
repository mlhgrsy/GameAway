import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/services/util.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SellProduct extends StatefulWidget {
  const SellProduct({Key? key}) : super(key: key);

  @override
  State<SellProduct> createState() => _SellProductState();
}

class _SellProductState extends State<SellProduct> {
  final _formProductKey = GlobalKey<FormState>();
  DBService db = DBService();
  String name = "";
  String picture = "";
  num price = 0;
  num stocks = 0;
  File? productPicture;
  int? _currentCategory;
  String _currentTag = "All";
  static final _categories = Util.categories;
  static final _tags = Util.tags;
  static final _categoryItems = _categories
      .asMap()
      .entries
      .map((e) => DropdownMenuItem<int>(
            value: e.key,
            child: Text(e.value),
          ))
      .toList();
  static final _tagItems = _tags
      .map((e) => e.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList())
      .toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 90,
            title: const Text("Add/Increase Products"),
            backgroundColor: AppColors.primaryBackground,
            elevation: 0.0,
            bottom: const TabBar(
              tabs: [
                Tab(text: "Add New"),
                Tab(text: "View Stocks"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: Dimen.regularPadding,
                  child: Form(
                    key: _formProductKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(hintText: "name"),
                          onSaved: (value) {
                            if (value != null) name = value;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () async {
                                final ImagePicker _picker = ImagePicker();
                                final XFile? image = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {
                                  productPicture =
                                      image == null ? null : File(image.path);
                                });
                              },
                              label: const Text("Set Picture"),
                              icon: const Icon(Icons.photo_camera),
                            ),
                            Visibility(
                              visible: productPicture != null,
                              child: const Text(
                                "Product Image Set!",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                            Container()
                          ],
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: "price"),
                          onSaved: (value) {
                            if (value != null) price = num.parse(value);
                          },
                        ),
                        // TextFormField(
                        //   keyboardType: TextInputType.number,
                        //   decoration: const InputDecoration(hintText: "stocks"),
                        //   onSaved: (value) {
                        //     if (value != null) stocks = num.parse(value);
                        //   },
                        // ),
                        DropdownButton(
                          hint: const Text("Choose Category"),
                          isExpanded: true,
                          items: _categoryItems,
                          value: _currentCategory,
                          onChanged: (int? newValue) {
                            setState(() {
                              _currentCategory = newValue!;
                              _currentTag = _tags[_currentCategory!][0];
                            });
                          },
                        ),
                        Visibility(
                          visible: _currentCategory != null,
                          child: DropdownButton(
                            hint: const Text("Choose Tag"),
                            isExpanded: true,
                            items: _currentCategory == null
                                ? _tagItems[0]
                                : _tagItems[_currentCategory!],
                            value: _currentTag,
                            onChanged: (String? newValue) {
                              setState(() {
                                _currentTag = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Text("dkwal")
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
              backgroundColor: AppColors.primaryBackground,
              onPressed: () async {
                var sellerRef = DBService.userCollection
                    .doc(Provider.of<User?>(context, listen: false)!.uid);
                _formProductKey.currentState!.save();
                db.addProduct(_categories[_currentCategory!], name, price,
                    sellerRef, _currentTag, productPicture!);
              },
              label: const Text("Add"),
              icon: const Icon(Icons.add))),
    );
  }
}
