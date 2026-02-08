// import 'package:flutter_bloc_advance/presentation/screen/home/home_screen.dart';

import 'package:go_router/go_router.dart';

import '../../app_routes_constants.dart';
import '/app/presentation/screens/emails/emails_screen.dart';

class EmailsRoutes {
  static final List<GoRoute> routes = [
    GoRoute(
      name: 'emails',
      path: ApplicationRoutesConstants.emails,
      builder: (context, state) => EmailsScreen(),
    ),
  ];
}
