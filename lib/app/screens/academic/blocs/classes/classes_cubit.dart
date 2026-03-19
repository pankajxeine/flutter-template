import 'package:flutter_bloc/flutter_bloc.dart';

import 'classes_state.dart';

class ClassesCubit extends Cubit<ClassesState> {
  ClassesCubit() : super(ClassesState.initial);

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
