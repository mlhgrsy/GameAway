import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/bottom_nav.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/services/loading.dart';
import 'package:gameaway/services/util.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key, this.refreshFunc}) : super(key: key);

  final Function? refreshFunc;

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  DBService db = DBService();
  String name = "";
  num price = 0;
  num stocks = 0;
  String desc = "";
  File? productPicture;
  int? _currentCategory;
  String _currentTag = "All";
  static final _categories = Util.categories;
  static final _tags = Util.tagsEditable;
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
    return Scaffold(
      appBar: ActionBar(
        title: "New Product",
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: Dimen.regularPadding,
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                    hintText: "name",
                    border: OutlineInputBorder(),
                    isDense: true),
                onChanged: (value) {
                  name = value;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
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
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: "price",
                    border: OutlineInputBorder(),
                    isDense: true),
                onChanged: (value) {
                  try {
                    price = num.parse(value);
                  } catch (e) {
                    price = 0;
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: "stocks",
                    border: OutlineInputBorder(),
                    isDense: true),
                onChanged: (value) {
                  try {
                    stocks = num.parse(value);
                  } catch (e) {
                    stocks = 0;
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                maxLines: null,
                minLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    hintText: "Description", border: OutlineInputBorder()),
                onChanged: (value) {
                  desc = value;
                },
              ),
              const SizedBox(height: 10),
              InputDecorator(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isDense: true,
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
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: _currentCategory != null,
                child: InputDecorator(
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isDense: true,
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
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => AppColors.primaryBackground)),
                onPressed: () async {
                  if (name == "" ||
                      desc == "" ||
                      productPicture == null ||
                      price == 0 ||
                      stocks == 0 ||
                      _currentCategory == null) {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text("Missing Information"),
                              content: const Text(
                                  "Please make sure to fill all the information about your product!"),
                              actions: [
                                TextButton(
                                  child: const Text("Ok"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ]);
                        });
                  } else {
                    Provider.of<Loading>(context, listen: false).increment();
                    var sellerRef = DBService.userCollection
                        .doc(Provider.of<User?>(context, listen: false)!.uid);
                    await db.addProduct(
                        _categories[_currentCategory!],
                        name,
                        price,
                        sellerRef,
                        _currentTag,
                        productPicture!,
                        stocks,
                        desc);
                    widget.refreshFunc!();
                    Provider.of<Loading>(context, listen: false).decrement();
                    await showDialog(
                        context: context,
                        builder: (BuildContext context2) {
                          return AlertDialog(
                              title: const Text("Success"),
                              content:
                                  const Text("Your product has been added!"),
                              actions: [
                                TextButton(
                                  child: const Text("Ok"),
                                  onPressed: () {
                                    Navigator.of(context2).pop();
                                  },
                                )
                              ]);
                        });
                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(
                  Icons.add,
                  color: AppColors.DarkTextColor,
                ),
                label: Text(
                  "Add Product",
                  style: kButtonDarkTextStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
