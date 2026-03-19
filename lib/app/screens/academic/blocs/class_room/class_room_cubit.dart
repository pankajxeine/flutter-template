import 'package:flutter_bloc/flutter_bloc.dart';

import 'class_room_state.dart';

class ClassRoomCubit extends Cubit<ClassRoomState> {
  ClassRoomCubit() : super(ClassRoomState.initial);

  void selectNav(String label) {
    emit(state.copyWith(selectedNav: label));
  }

  void setLanguage(String value) {
    emit(state.copyWith(language: value));
  }

  void loadData() {
    emit(state.copyWith(isLoading: true, error: null));
    // TODO: Implement data loading logic
    Future.delayed(const Duration(milliseconds: 500), () {
      emit(state.copyWith(isLoading: false));
    });
  }
}
