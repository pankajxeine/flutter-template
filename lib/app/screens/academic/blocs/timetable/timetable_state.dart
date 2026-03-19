import 'package:equatable/equatable.dart';

class TimetableState extends Equatable {
  final String selectedNav;
  final String language;
  final bool isLoading;
  final String? error;

  const TimetableState({
    required this.selectedNav,
    required this.language,
    this.isLoading = false,
    this.error,
  });

  TimetableState copyWith({
    String? selectedNav,
    String? language,
    bool? isLoading,
    String? error,
  }) {
    return TimetableState(
      selectedNav: selectedNav ?? this.selectedNav,
      language: language ?? this.language,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [selectedNav, language, isLoading, error];

  static const initial = TimetableState(
    selectedNav: 'Timetable',
    language: 'EN',
    isLoading: false,
    error: null,
  );
}
