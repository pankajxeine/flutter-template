import 'package:equatable/equatable.dart';

class ClassRoutineState extends Equatable {
  final String selectedNav;
  final String language;
  final bool isLoading;
  final String? error;

  const ClassRoutineState({
    required this.selectedNav,
    required this.language,
    this.isLoading = false,
    this.error,
  });

  ClassRoutineState copyWith({
    String? selectedNav,
    String? language,
    bool? isLoading,
    String? error,
  }) {
    return ClassRoutineState(
      selectedNav: selectedNav ?? this.selectedNav,
      language: language ?? this.language,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [selectedNav, language, isLoading, error];

  static const initial = ClassRoutineState(
    selectedNav: 'Class Routine',
    language: 'EN',
    isLoading: false,
    error: null,
  );
}
