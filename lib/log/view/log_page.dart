import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    return ListTile(
      // leading: Text('${item.id}'),
      title: Text(
          '[${item.time}] - ${Level.LEVELS.firstWhere((element) => element.value == item.level).name}'),
      subtitle: Text(
        item.message,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
