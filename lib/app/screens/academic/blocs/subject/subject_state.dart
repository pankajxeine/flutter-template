import 'package:equatable/equatable.dart';

class SubjectState extends Equatable {
  final String selectedNav;
  final String language;
  final bool isLoading;
  final String? error;

  const SubjectState({
    required this.selectedNav,
    required this.language,
    this.isLoading = false,
    this.error,
  });

  SubjectState copyWith({
    String? selectedNav,
    String? language,
    bool? isLoading,
    String? error,
  }) {
    return SubjectState(
      selectedNav: selectedNav ?? this.selectedNav,
      language: language ?? this.language,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [selectedNav, language, isLoading, error];

  static const initial = SubjectState(
    selectedNav: 'Subject',
    language: 'EN',
    isLoading: false,
    error: null,
  );
}
