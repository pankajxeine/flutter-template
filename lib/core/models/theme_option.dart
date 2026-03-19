import 'package:forui/forui.dart';

class ThemeOption {
  const ThemeOption({
    required this.name,
    required this.light,
    required this.dark,
  });

  final String name;
  final FThemeData light;
  final FThemeData dark;
}
