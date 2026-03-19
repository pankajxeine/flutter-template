import 'package:shadcn_flutter/shadcn_flutter.dart';

class ThemeOption {
  const ThemeOption({
    required this.name,
    required this.light,
    required this.dark,
  });
  final String name;
  final ColorScheme light;
  final ColorScheme dark;
}

class AppThemePalette {
  static final options = <ThemeOption>[
    ThemeOption(
      name: 'Zinc',
      light: LegacyColorSchemes.lightZinc(),
      dark: LegacyColorSchemes.darkZinc(),
    ),
    ThemeOption(
      name: 'Blue',
      light: LegacyColorSchemes.lightBlue(),
      dark: LegacyColorSchemes.darkBlue(),
    ),
    ThemeOption(
      name: 'Green',
      light: LegacyColorSchemes.lightGreen(),
      dark: LegacyColorSchemes.darkGreen(),
    ),
    ThemeOption(
      name: 'Red',
      light: LegacyColorSchemes.lightRed(),
      dark: LegacyColorSchemes.darkRed(),
    ),
    ThemeOption(
      name: 'Neutral',
      light: LegacyColorSchemes.lightNeutral(),
      dark: LegacyColorSchemes.darkNeutral(),
    ),
    ThemeOption(
      name: 'orange',
      light: LegacyColorSchemes.lightOrange(),
      dark: LegacyColorSchemes.darkOrange(),
    ),
    ThemeOption(
      name: 'stone',
      light: LegacyColorSchemes.lightStone(),
      dark: LegacyColorSchemes.darkStone(),
    ),
    ThemeOption(
      name: 'yellow',
      light: LegacyColorSchemes.lightYellow(),
      dark: LegacyColorSchemes.darkYellow(),
    ),
    ThemeOption(
      name: 'violet',
      light: LegacyColorSchemes.lightViolet(),
      dark: LegacyColorSchemes.darkViolet(),
    ),
    ThemeOption(
      name: 'rose',
      light: LegacyColorSchemes.lightViolet(),
      dark: LegacyColorSchemes.darkViolet(),
    ),
    ThemeOption(
      name: 'slate',
      light: LegacyColorSchemes.lightSlate(),
      dark: LegacyColorSchemes.darkSlate(),
    ),
  ];
}

enum AppThemePaletteEnum {
  zinc('Zinc', 'Neutral grey tones with subtle warmth'),
  blue('Blue', 'Clean blue with bold secondary accents'),
  green('Green', 'Fresh green with vibrant highlights'),
  red('Red', 'Bold red with deep contrast'),
  neutral('Neutral', 'Soft neutral tones for a calm look'),
  orange('Orange', 'Warm orange with rich undertones'),
  stone('Stone', 'Warm stone tones with muted contrast'),
  yellow('Yellow', 'Bright yellow with subtle warmth'),
  violet('Violet', 'Deep violet with rich undertones'),
  rose('Rose', 'Soft rose tones with gentle contrast'),
  slate('Slate', 'Cool slate tones with muted contrast');

  const AppThemePaletteEnum(this.title, this.description);
  final String title;
  final String description;
}
