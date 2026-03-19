// import 'package:flutter_bloc_advance/presentation/screen/home/home_screen.dart';

import 'package:go_router/go_router.dart';

import 'home.dart';

class HomeRoutes {
  static final List<GoRoute> routes = [
    GoRoute(name: 'home', path: "/", builder: (context, state) => HomeScreen()),
    GoRoute(
      name: 'home_alias',
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
  ];
}
