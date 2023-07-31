import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:myapp/log/cubit/log_list_cubit.dart';
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
      child: ListTile(
        leading: Icon(_getIcon(item.level)),
        // leading: Text('${item.id}'),
        title: Text(
          //'[${item.time}] - ${Level.LEVELS.firstWhere((element) => element.value == item.level).name}',
          '[${DateFormat('yyyy-MM-dd hh:mm').format(item.time)}] - ${item.name}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          // we are forceing here minimum 3 lines, so that each card and item has
          // the same hight
          '${item.message}\n\n',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  IconData _getIcon(int level) {
    if (level <= Level.FINE.value) {
      return Icons.check;
    } else if (level <= Level.CONFIG.value) {
      return Icons.bug_report;
    } else if (level <= Level.INFO.value) {
      return Icons.info;
    } else if (level <= Level.WARNING.value) {
      return Icons.warning;
    } else if (level <= Level.SEVERE.value) {
      return Icons.error;
    } else if (level <= Level.SHOUT.value) {
      return Icons.emergency;
    } else {
      return Icons.summarize;
    }
  }
}
