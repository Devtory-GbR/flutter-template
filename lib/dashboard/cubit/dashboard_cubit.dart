import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({required TestRepository testRepository})
      : _testRepository = testRepository,
        super(DashboardInitial());

  final TestRepository _testRepository;

  void simulateError401() async {
    try {
      await _testRepository.simulateError401();
    } catch (e, strackTrace) {
      addError(e, strackTrace);
    }
  }

  void simulateClientError() async {
    try {
      await _testRepository.simulateClientError();
    } catch (e, strackTrace) {
      addError(e, strackTrace);
    }
  }

  void simulateHttpError() async {
    try {
      await _testRepository.simulateHttpError();
    } catch (e, strackTrace) {
      addError(e, strackTrace);
    }
  }

  void simulateHardError() {
    try {
      int.parse("noint");
    } catch (e, strackTrace) {
      addError(e, strackTrace);
    }
  }
}
