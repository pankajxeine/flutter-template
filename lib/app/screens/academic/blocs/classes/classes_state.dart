import 'package:equatable/equatable.dart';

class ClassesState extends Equatable {
  final String selectedNav;
  final String language;
  final bool isLoading;
  final String? error;

  const ClassesState({
    required this.selectedNav,
    required this.language,
    this.isLoading = false,
    this.error,
  });

  ClassesState copyWith({
    String? selectedNav,
    String? language,
    bool? isLoading,
    String? error,
  }) {
    return ClassesState(
      selectedNav: selectedNav ?? this.selectedNav,
      language: language ?? this.language,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [selectedNav, language, isLoading, error];

  static const initial = ClassesState(
    selectedNav: 'Classes',
    language: 'EN',
    isLoading: false,
    error: null,
  );
}
