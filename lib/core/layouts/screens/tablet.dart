import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../navigation/app_sidebar_navigation.dart';
import '../navigation/bloc/navigation_cubit.dart';

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key, this.body, this.title, this.headerTrailing});

  final Widget? body;
  final String? title;
  final List<Widget>? headerTrailing;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(initialExpanded: false),
      child: _TabletView(
        body: body,
        title: title,
        headerTrailing: headerTrailing,
      ),
    );
  }
}

class _TabletView extends StatelessWidget {
  const _TabletView({this.body, this.title, this.headerTrailing});

  final Widget? body;
  final String? title;
  final List<Widget>? headerTrailing;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NavigationCubit>().state;

    return Scaffold(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSidebarNavigation(expanded: state.isExpanded),
          const VerticalDivider(),
          Expanded(
            child: Scaffold(
              headers: [
                AppBar(
                  leading: [
                    OutlineButton(
                      density: ButtonDensity.icon,
                      shape: ButtonShape.circle,
                      onPressed: () =>
                          context.read<NavigationCubit>().toggleExpanded(),
                      child: Icon(
                        state.isExpanded ? Icons.menu_open : Icons.menu,
                        size: 18,
                      ),
                    ),
                  ],
                  title: Text(title ?? ''),
                  trailing: [...?headerTrailing],
                ),
              ],
              child: body ?? const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}
