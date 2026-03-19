import 'package:equatable/equatable.dart';

class AcademicState extends Equatable {
  final String selectedNav;
  final String language;
  final bool isLoading;
  final String? error;

  const AcademicState({
    required this.selectedNav,
    required this.language,
    this.isLoading = false,
    this.error,
  });

  AcademicState copyWith({
    String? selectedNav,
    String? language,
    bool? isLoading,
    String? error,
  }) {
    return AcademicState(
      selectedNav: selectedNav ?? this.selectedNav,
      language: language ?? this.language,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [selectedNav, language, isLoading, error];

  static const initial = AcademicState(
    selectedNav: 'Academic',
    language: 'EN',
    isLoading: false,
    error: null,
  );
}
