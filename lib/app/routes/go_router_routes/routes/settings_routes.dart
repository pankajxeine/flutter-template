// import 'package:flutter_bloc_advance/presentation/screen/settings/settings_screen.dart';
import '../../app_routes_constants.dart';
import 'package:go_router/go_router.dart';

import '/app/presentation/screens/settings/settings_screen.dart';

class SettingsRoutes {
  static final List<GoRoute> routes = [
    GoRoute(
      name: 'settings',
      path: ApplicationRoutesConstants.settings,
      builder: (context, state) => SettingScreen(),
    ),
  ];
}
