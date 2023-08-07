import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:myapp/log/cubit/log_list_cubit.dart';
import 'package:myapp/log/view/log_ui_widgets.dart';
import 'package:repositories/repositories.dart';

class LogPage extends StatelessWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.log),
        actions: [
          IconButton(
              onPressed: () => Logger('test').shout('Error TEST'),
              icon: const Icon(Icons.safety_check))
        ],
      ),
      body: BlocProvider(
        create: (context) => LogListCubit(
          repository: context.read<LoggerRepository>(),
        )..fetchList(),
        child: const _LogList(),
      ),
    );
  }
}

class _LogList extends StatelessWidget {
  const _LogList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogListCubit, LogListState>(
      builder: (context, state) {
        if (state.status == LogListStatus.failure) {
          return Center(child: Text(AppLocalizations.of(context)!.error));
        }
        if (state.status == LogListStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == LogListStatus.success && state.items.isEmpty) {
          return Center(child: Text(AppLocalizations.of(context)!.noContent));
        }
        return ListView.builder(
          itemCount: state.items.length,
          prototypeItem: _LogItem(item: state.items.first),
          itemBuilder: (context, index) => _LogItem(item: state.items[index]),
        );
      },
    );
  }
}

class _LogItem extends StatelessWidget {
  const _LogItem({required this.item});
  final Log item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.go('/settings/help/logs/${item.id}'),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                //'[${item.time}] - ${Level.LEVELS.firstWhere((element) => element.value == item.level).name}',
                '[${DateFormat('yyyy-MM-dd HH:mm').format(item.time)}] - ${item.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Padding(padding: EdgeInsets.only(top: 6)),
              LogLevelBadge(level: item.level),
              const Padding(padding: EdgeInsets.only(top: 6)),
              Text(
                // we are forceing here minimum 3 lines, so that each card and item has
                // the same hight
                '${item.message}\n\n',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).textTheme.bodySmall!.color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
