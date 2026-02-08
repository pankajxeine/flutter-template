// import 'package:flutter_bloc_advance/presentation/screen/home/home_screen.dart';

import 'package:go_router/go_router.dart';

import '../../app_routes_constants.dart';
import '/app/presentation/screens/home/home_screen.dart';

class HomeRoutes {
  static final List<GoRoute> routes = [
    GoRoute(
      name: 'home',
      path: ApplicationRoutesConstants.home,
      builder: (context, state) => HomeScreen(),
    ),
  ];
}
