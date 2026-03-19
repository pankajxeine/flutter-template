import 'package:forui/forui.dart';

import '../models/theme_option.dart';

/// Application theme builder that centralizes Material 3 configuration.
class AppTheme {
  AppTheme._();

  static List<ThemeOption> get options => [
    ThemeOption(
      name: 'Zinc',
      light: FThemes.zinc.light,
      dark: FThemes.zinc.dark,
    ),
    ThemeOption(
      name: 'Blue',
      light: FThemes.blue.light,
      dark: FThemes.blue.dark,
    ),
    ThemeOption(
      name: 'Green',
      light: FThemes.green.light,
      dark: FThemes.green.dark,
    ),
  ];
}
