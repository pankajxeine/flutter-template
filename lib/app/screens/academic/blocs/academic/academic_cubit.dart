import 'package:flutter_bloc/flutter_bloc.dart';

import 'academic_state.dart';

class AcademicCubit extends Cubit<AcademicState> {
  AcademicCubit() : super(AcademicState.initial);

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
