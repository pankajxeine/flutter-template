import 'package:shadcn_flutter/shadcn_flutter.dart';

class AppNavDestination {
  const AppNavDestination({
    required this.key,
    required this.label,
    required this.icon,
  });

  final String key;
  final String label;
  final IconData icon;
}
