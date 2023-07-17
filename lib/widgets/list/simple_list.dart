import 'package:flutter/material.dart';

class SimpleList extends StatelessWidget {
  final bool isFullPage;

  const SimpleList({
    super.key,
    required this.sections,
    this.isFullPage = true,
  });

  final List<SimpleListSection> sections;

  @override
  Widget build(BuildContext context) {
    if (isFullPage) {
      return ListView(
        children: [
          const _ListSectionSpacer(),
          ...sections,
        ],
      );
    } else {
      return ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          const _ListSectionSpacer(),
          ...sections,
        ],
      );
    }
  }
}

class SimpleListSection extends StatelessWidget {
  const SimpleListSection(
      {super.key, required this.children, this.marginBottom = true});

  final List<Widget> children;
  final bool marginBottom;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
        if (marginBottom) const _ListSectionSpacer()
      ],
    );
  }
}

class _ListSectionSpacer extends StatelessWidget {
  const _ListSectionSpacer();

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.only(top: 12.0));
  }
}
