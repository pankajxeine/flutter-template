import 'package:equatable/equatable.dart';

class SyllabusState extends Equatable {
  final String selectedNav;
  final String language;
  final bool isLoading;
  final String? error;

  const SyllabusState({
    required this.selectedNav,
    required this.language,
    this.isLoading = false,
    this.error,
  });

  SyllabusState copyWith({
    String? selectedNav,
    String? language,
    bool? isLoading,
    String? error,
  }) {
    return SyllabusState(
      selectedNav: selectedNav ?? this.selectedNav,
      language: language ?? this.language,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [selectedNav, language, isLoading, error];

  static const initial = SyllabusState(
    selectedNav: 'Syllabus',
    language: 'EN',
    isLoading: false,
    error: null,
  );
}
