import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<int> {
  HomeCubit({required int initialIndex}) : super(initialIndex);

  changeScreen(int index) {
    emit(index);
  }
}
