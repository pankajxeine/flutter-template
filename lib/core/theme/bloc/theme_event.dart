part of 'theme_bloc.dart';

abstract class ThemeEvent {
  const ThemeEvent();
}

class LoadTheme extends ThemeEvent {
  const LoadTheme();
}

class ChangeThemePalette extends ThemeEvent {
  const ChangeThemePalette({required this.palette});

  final AppThemePaletteEnum palette;
}

class ToggleBrightness extends ThemeEvent {
  const ToggleBrightness();
}
