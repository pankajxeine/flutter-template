// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '/core/config/allowed_paths.dart';
import '/core/config/app_logger.dart';
import '/core/config/environment.dart';
// import 'package:flutter_bloc_advance/presentation/common_blocs/account/account.dart';

// import 'routes/account_routes.dart';
// import 'routes/auth_routes.dart';
import '/app/screens/home/home_routes.dart';
import '/app/screens/academic/academic.router.dart';
// import 'routes/settings_routes.dart';
// import 'routes/emails_routes.dart';
// import 'routes/academic.router.dart';
// import 'routes/library.router.dart';
// import 'routes/hostel.router.dart';
// import 'routes/transport.router.dart';
// import 'routes/examination.router.dart';
// import 'routes/hrm.router.dart';
// import 'routes/announcement.router.dart';
// import 'routes/reports.router.dart';
// import 'routes/fees.router.dart';
// import 'routes/accounts.router.dart';
// import 'routes/user_management.router.dart';
// import 'routes/user_routes.dart';
import '../i10n/i10n.dart';
import 'app_routes_constants.dart';
import '/core/utils/security_utils.dart';
import '/auth/login/login_screen.dart';

class ErrorScreen extends StatelessWidget {
  final GoException? error;

  const ErrorScreen(this.error, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [AppBar(title: const Text('Error'))],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${error?.message}'),
            PrimaryButton(
              onPressed: () => context.pop(),
              child: const Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }
}

class AppGoRouterConfig {
  static final _log = AppLogger.getLogger("AppGoRouterConfig");
  static final GoRouter router = GoRouter(
    initialLocation: ApplicationRoutesConstants.home,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => ErrorScreen(state.error),
    routes: [
      GoRoute(
        name: 'login',
        path: ApplicationRoutesConstants.login,
        builder: (context, state) => LoginScreen(),
      ),
      ...HomeRoutes.routes,
      ...AcademicRouter.routes,
    ],
    redirect: (context, state) async {
      _log.debug("BEGIN: redirect");
      _log.debug("redirect - uri: ${state.uri}");
      _log.debug("authPaths: $authPaths");
      // Skip redirect for login page
      if (authPaths.any((p) => state.uri.path.startsWith(p))) {
        _log.debug("END: redirect null - with authPaths");
        return null;
      }

      // check : when redirect the new page then load the account data
      // if (state.uri.toString() == ApplicationRoutesConstants.home) {
      //   var accountBloc = context.read<AccountBloc>();
      //   await Future.delayed(const Duration(microseconds: 500));
      //   accountBloc.add(const AccountFetchEvent());
      //   _log.debug("redirect - load event : accountBloc.add(AccountLoad())");
      // }
      // check : when jwtToken is null then redirect to login page
      _log.debug("isUserLoggedIn: ${SecurityUtils.isUserLoggedIn()}");
      if (!SecurityUtils.isUserLoggedIn() &&
          !SecurityUtils.isAllowedPath(state.uri.toString())) {
        _log.debug("END: isUserLoggedIn is false and isAllowedPath is false");
        if (state.uri.toString() != ApplicationRoutesConstants.login) {
          return ApplicationRoutesConstants.login;
        } else {
          return null;
        }
      }
      // check : when running in production mode and jwtToken is expired then redirect to login page
      if (ProfileConstants.isProduction &&
          SecurityUtils.isTokenExpired() &&
          state.uri.toString() != ApplicationRoutesConstants.login) {
        _log.debug("END: redirect - jwtToken is expired");
        return ApplicationRoutesConstants.login;
      }

      _log.debug("END: redirect return null");
      return null;
    },
  );

  static ShadcnApp routeBuilder(
    ThemeData activeTheme,
    ThemeData darkTheme,
    String language,
  ) {
    // final td = themeData ?? TDThemeData.defaultData();
    _log.debug("----Language----: $language");
    _log.debug("----supportedLocales----: ${S.supportedLocales}");
    return ShadcnApp.router(
      debugShowCheckedModeBanner: false,
      // localizationsDelegates: LocalizationsDelegate.localizationsDelegates,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale(language),
      supportedLocales: S.supportedLocales,
      theme: activeTheme,
      builder: (_, child) => Theme(data: activeTheme, child: child!),
      routerConfig: AppGoRouterConfig.router,
      // home: AdminShell(
      //   themeName: _options[_themeIndex].name,
      //   darkMode: darkTheme,
      //   onToggleDark: _toggleDark,
      //   onCycleTheme: _cycleTheme,
      // ),
    );
  }
}
