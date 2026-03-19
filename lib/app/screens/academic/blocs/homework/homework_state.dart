import 'package:equatable/equatable.dart';

class HomeworkState extends Equatable {
  final String selectedNav;
  final String language;
  final bool isLoading;
  final String? error;

  const HomeworkState({
    required this.selectedNav,
    required this.language,
    this.isLoading = false,
    this.error,
  });

  HomeworkState copyWith({
    String? selectedNav,
    String? language,
    bool? isLoading,
    String? error,
  }) {
    return HomeworkState(
      selectedNav: selectedNav ?? this.selectedNav,
      language: language ?? this.language,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [selectedNav, language, isLoading, error];

  static const initial = HomeworkState(
    selectedNav: 'Homework',
    language: 'EN',
    isLoading: false,
    error: null,
  );
}
