import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/widgets/web_back_button_disabler.dart';
// import 'core/theme/app_theme.dart';
import 'core/theme/bloc/theme_bloc.dart';

import 'routes/app_go_router_config.dart';
import 'auth/login/bloc/login.dart';

class App extends StatelessWidget {
  final String language;

  const App({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    return buildHomeApp();
  }

  Widget buildHomeApp() {
    return _buildMultiBlocProvider();
  }

  MultiBlocProvider _buildMultiBlocProvider() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => LoginBloc()),
        // BlocProvider<AuthorityBloc>(
        //   create: (_) => AuthorityBloc(repository: AuthorityRepository()),
        // ),
        // BlocProvider<AccountBloc>(
        //   create: (_) => AccountBloc(repository: AccountRepository()),
        // ),
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc()..add(const LoadTheme()),
        ),
        // BlocProvider<DrawerBloc>(
        //   create: (_) => DrawerBloc(
        //     loginRepository: LoginRepository(),
        //     menuRepository: MenuRepository(),
        //   ),
        // ),
      ],
      child: _buildAdaptiveThemeWrapper(),
    );
  }

  Widget _buildAdaptiveThemeWrapper() {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        debugPrint(
          "Main App: ThemeBloc state - isDarkMode: ${themeState.isDarkMode}, palette: ${themeState.palette}",
        );
        ThemeData activeTheme = themeState.isDarkMode
            ? ThemeData.dark()
            : ThemeData();

        debugPrint("Main App: Building theme with brightness: $activeTheme");
        return WebBackButtonDisabler(
          child: AppGoRouterConfig.routeBuilder(
            activeTheme,
            ThemeData.dark(),
            language,
          ),
        );
      },
    );
  }
}
