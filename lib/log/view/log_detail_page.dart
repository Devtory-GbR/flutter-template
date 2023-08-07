import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:myapp/log/cubit/log_detail_cubit.dart';
import 'package:myapp/log/view/log_ui_widgets.dart';
import 'package:repositories/repositories.dart';

class LogDetailPage extends StatelessWidget {
  const LogDetailPage({super.key, this.logId});

  final int? logId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LogDetailCubit>(
      create: (context) =>
          LogDetailCubit(repository: context.read<LoggerRepository>())
            ..fetchItem(logId),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<LogDetailCubit, LogDetailState>(
            builder: (context, state) {
              return Text(
                  '${AppLocalizations.of(context)!.log}: ${state.item.id}');
            },
          ),
        ),
        body: const _LogDetailView(),
      ),
    );
  }
}

class _LogDetailView extends StatelessWidget {
  const _LogDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogDetailCubit, LogDetailState>(
      builder: (context, state) {
        if (state.status == LogDetailStatus.failure) {
          return Center(child: Text(AppLocalizations.of(context)!.error));
        }
        if (state.status == LogDetailStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == LogDetailStatus.notFound) {
          return Center(child: Text(AppLocalizations.of(context)!.noContent));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                //'[${item.time}] - ${Level.LEVELS.firstWhere((element) => element.value == item.level).name}',
                '[${DateFormat('yyyy-MM-dd HH:mm').format(state.item.time)}] - ${state.item.name}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Padding(padding: EdgeInsets.only(top: 12)),
              LogLevelBadge(level: state.item.level),
              const Padding(padding: EdgeInsets.only(top: 12)),
              SelectableText(state.item.message),
              if (state.item.stackTrace != null)
                const Padding(padding: EdgeInsets.only(top: 12.0)),
              if (state.item.stackTrace != null)
                SelectableText(
                  state.item.stackTrace!,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
            ],
          ),
        );
      },
    );
  }
}
