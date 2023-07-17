import 'package:flutter/material.dart';

class LongList extends StatelessWidget {
  const LongList({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
