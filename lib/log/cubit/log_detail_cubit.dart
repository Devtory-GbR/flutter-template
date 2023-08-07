import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';

part 'log_detail_state.dart';

class LogDetailCubit extends Cubit<LogDetailState> {
  LogDetailCubit({required this.repository}) : super(LogDetailState.loading());

  final LoggerRepository repository;

  Future<void> fetchItem(int? logId) async {
    if (logId == null) {
      emit(LogDetailState.notFound());
      return;
    }

    emit(LogDetailState.loading());
    try {
      final log = await repository.getLog(logId);
      if (log != null) {
        emit(LogDetailState.success(log));
      } else {
        emit(LogDetailState.notFound());
      }
    } catch (e, stackTrace) {
      emit(LogDetailState.failure());
      addError(e, stackTrace);
    }
  }
}
