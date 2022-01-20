import 'package:flutter/material.dart';
import 'package:gameaway/services/loading.dart';
import 'package:provider/provider.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key,this.main = false}) : super(key: key);
  final bool main;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !main || Provider.of<Loading>(context).isLoading,
      child: Container(
        color: Colors.black.withOpacity(.2),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
