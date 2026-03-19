import 'package:equatable/equatable.dart';

class ClassRoomState extends Equatable {
  final String selectedNav;
  final String language;
  final bool isLoading;
  final String? error;

  const ClassRoomState({
    required this.selectedNav,
    required this.language,
    this.isLoading = false,
    this.error,
  });

  ClassRoomState copyWith({
    String? selectedNav,
    String? language,
    bool? isLoading,
    String? error,
  }) {
    return ClassRoomState(
      selectedNav: selectedNav ?? this.selectedNav,
      language: language ?? this.language,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [selectedNav, language, isLoading, error];

  static const initial = ClassRoomState(
    selectedNav: 'Class Room',
    language: 'EN',
    isLoading: false,
    error: null,
  );
}
