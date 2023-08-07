import 'package:flutter/material.dart';
import 'package:myapp/log/utils/log_level_helper.dart';

class LogLevelBadge extends StatelessWidget {
  const LogLevelBadge({
    super.key,
    required this.level,
    this.showIcon = false,
  });

  final int level;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
          color: getLevelColor(level, context),
          borderRadius: const BorderRadius.all(Radius.circular(8.0))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) Icon(getLevelIcon(level)),
          if (showIcon) const Padding(padding: EdgeInsets.only(right: 6.0)),
          Text(
            getLevelText(level),
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: getLevelColor(level, context).textColor),
          ),
        ],
      ),
    );
  }
}
