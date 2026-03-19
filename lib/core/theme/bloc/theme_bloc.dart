import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/config/local_storage.dart';
import '/core/theme/app_theme_palette.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<LoadTheme>(_onLoadTheme);
    on<ChangeThemePalette>(_onChangeThemePalette);
    on<ToggleBrightness>(_onToggleBrightness);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    try {
      // Load brightness preference from storage
      final brightnessPref = await AppLocalStorage().read(
        StorageKeys.brightness.name,
      );
      final isDarkMode = brightnessPref == 'dark';

      // Load palette preference from storage
      final palettePref = await AppLocalStorage().read(StorageKeys.theme.name);
      AppThemePaletteEnum palette = AppThemePaletteEnum.neutral;

      if (palettePref != null) {
        switch (palettePref) {
          case 'nature':
            palette = AppThemePaletteEnum.neutral;
            break;
          case 'stone':
            palette = AppThemePaletteEnum.stone;
            break;
          case 'blue':
            palette = AppThemePaletteEnum.blue;
            break;
          case 'violet':
            palette = AppThemePaletteEnum.violet;
            break;
          case 'zinc':
            palette = AppThemePaletteEnum.zinc;
            break;
          case 'rose':
            palette = AppThemePaletteEnum.rose;
            break;
          case 'green':
            palette = AppThemePaletteEnum.green;
            break;
          case 'red':
            palette = AppThemePaletteEnum.red;
            break;
          case 'yellow':
            palette = AppThemePaletteEnum.yellow;
            break;
          case 'slate':
            palette = AppThemePaletteEnum.slate;
            break;
          default:
            palette = AppThemePaletteEnum.neutral;
        }
      }

      emit(state.copyWith(palette: palette, isDarkMode: isDarkMode));
    } catch (e) {
      // Default to classic palette and light mode if loading fails
      emit(
        state.copyWith(palette: AppThemePaletteEnum.neutral, isDarkMode: false),
      );
    }
  }

  Future<void> _onChangeThemePalette(
    ChangeThemePalette event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      // Save palette preference to storage
      String paletteName;
      switch (event.palette) {
        case AppThemePaletteEnum.neutral:
          paletteName = 'neutral';
          break;
        case AppThemePaletteEnum.stone:
          paletteName = 'stone';
          break;
        case AppThemePaletteEnum.blue:
          paletteName = 'blue';
          break;
        case AppThemePaletteEnum.violet:
          paletteName = 'violet';
          break;
        case AppThemePaletteEnum.zinc:
          paletteName = 'zinc';
          break;
        case AppThemePaletteEnum.rose:
          paletteName = 'rose';
          break;
        case AppThemePaletteEnum.green:
          paletteName = 'green';
          break;
        case AppThemePaletteEnum.red:
          paletteName = 'red';
          break;
        case AppThemePaletteEnum.yellow:
          paletteName = 'yellow';
          break;
        case AppThemePaletteEnum.slate:
          paletteName = 'slate';
          break;
        case AppThemePaletteEnum.orange:
          paletteName = 'orange';
          break;
      }
      await AppLocalStorage().save(StorageKeys.theme.name, paletteName);
      emit(state.copyWith(palette: event.palette));
    } catch (e) {
      // Still update the state even if saving fails
      emit(state.copyWith(palette: event.palette));
    }
  }

  Future<void> _onToggleBrightness(
    ToggleBrightness event,
    Emitter<ThemeState> emit,
  ) async {
    debugPrint(
      "ThemeBloc: _onToggleBrightness called. Current isDarkMode: ${state.isDarkMode}",
    );
    try {
      final newIsDarkMode = !state.isDarkMode;
      debugPrint("ThemeBloc: Setting new isDarkMode to: $newIsDarkMode");
      // Save brightness preference to storage
      await AppLocalStorage().save(
        StorageKeys.brightness.name,
        newIsDarkMode ? 'dark' : 'light',
      );
      emit(state.copyWith(isDarkMode: newIsDarkMode));
      debugPrint("ThemeBloc: State updated successfully");
    } catch (e) {
      debugPrint("ThemeBloc: Error in _onToggleBrightness: $e");
      // Still update the state even if saving fails
      emit(state.copyWith(isDarkMode: !state.isDarkMode));
    }
  }
}
