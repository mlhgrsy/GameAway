import 'package:flutter/material.dart';

class ActionBar extends StatelessWidget with PreferredSizeWidget {
  const ActionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              color: Colors.red,
              size: 40,
            ))
      ],
      title: const Text(
        'GameAway',
      ),
      backgroundColor: Colors.green,
      centerTitle: true,
      elevation: 0.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
