part of 'theme_bloc.dart';

class ThemeState {
  const ThemeState({
    this.palette = AppThemePaletteEnum.neutral,
    this.isDarkMode = false,
    this.radious = "default",
    this.density = "default",
    this.scaling = "default",
    this.surfaceOpacity = "solid",
    this.sufaceBlur = "none",
  });

  final AppThemePaletteEnum palette;
  final bool isDarkMode;
  final String radious;
  final String density;
  final String scaling;
  final String surfaceOpacity;
  final String sufaceBlur;

  ThemeState copyWith({
    AppThemePaletteEnum? palette,
    bool? isDarkMode,
    String? radious,
    String? density,
    String? scaling,
    String? surfaceOpacity,
    String? sufaceBlur,
  }) {
    return ThemeState(
      palette: palette ?? this.palette,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      radious: radious ?? this.radious,
      density: density ?? this.density,
      scaling: scaling ?? this.scaling,
      surfaceOpacity: surfaceOpacity ?? this.surfaceOpacity,
      sufaceBlur: sufaceBlur ?? this.sufaceBlur,
    );
  }
}
