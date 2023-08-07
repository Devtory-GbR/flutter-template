import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';

part 'log_list_state.dart';

class LogListCubit extends Cubit<LogListState> {
  LogListCubit({required this.repository})
      : super(const LogListState.loading()) {
    _onRecrodSubscription = repository.onRecord.listen((log) {
      if (state.status != LogListStatus.loading) {
        emit(LogListState.success(List.of(state.items)..insert(0, log)));
      }
    });
  }

  final LoggerRepository repository;
  late StreamSubscription<Log> _onRecrodSubscription;

  Future<void> fetchList() async {
    emit(const LogListState.loading());
    try {
      final items = (await repository.getLogs());
      emit(LogListState.success(List.unmodifiable(items)));
    } catch (e, stackTrace) {
      emit(const LogListState.failure());
      addError(e, stackTrace);
    }
  }

  @override
  Future<void> close() {
    _onRecrodSubscription.cancel();
    return super.close();
  }
}
