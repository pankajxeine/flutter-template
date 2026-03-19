import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../navigation/bloc/navigation_cubit.dart';
import '../navigation/app_sidebar_navigation.dart';
import '../widgets/header_trailing_sheet.dart';
import '../responsive.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({
    super.key,
    this.body,
    required this.title,
    this.headerTrailing,
  });

  final Widget? body;
  final String? title;
  final List<Widget>? headerTrailing;
  // final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(initialExpanded: true),
      child: DesktopView(
        body: body,
        title: title,
        headerTrailing: headerTrailing,
      ),
    );
  }
}

class DesktopView extends StatelessWidget {
  const DesktopView({super.key, this.body, this.title, this.headerTrailing});

  final Widget? body;
  final String? title;
  final List<Widget>? headerTrailing;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NavigationCubit>().state;
    debugPrint('*****isExpanded*********: ${state.isExpanded}');
    return Scaffold(
      showLoadingSparks: true,
      child: OutlinedContainer(
        padding: EdgeInsets.zero,
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!ResponsiveBuilder.isMobile(context))
              AppSidebarNavigation(expanded: state.isExpanded),
            const VerticalDivider(),
            Expanded(
              flex: 5,
              child: Scaffold(
                headers: [
                  AppBar(
                    leading: [
                      !ResponsiveBuilder.isMobile(context)
                          ? OutlineButton(
                              density: ButtonDensity.icon,
                              shape: ButtonShape.circle,
                              onPressed: () => context
                                  .read<NavigationCubit>()
                                  .toggleExpanded(),
                              child: Icon(
                                state.isExpanded ? Icons.menu_open : Icons.menu,
                                size: 18,
                              ),
                            )
                          : HeaderTrailingSheet(
                              body: AppSidebarNavigation(expanded: true),
                              icon: Icon(Icons.menu, size: 18),
                            ),
                    ],
                    title: Text(title ?? ''),
                    trailing: [
                      _buildHeaderTrailing(context),
                      ...?headerTrailing,
                    ],
                  ),
                ],
                child: body ?? const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTrailing(BuildContext context) {
    return Box(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeaderTrailingSheet(
            body: AppSidebarNavigation(expanded: true),
            icon: Icon(Icons.more_vert, size: 18),
            position: OverlayPosition.end,
          ),
          const Gap(16),
          HeaderTrailingSheet(
            body: AppSidebarNavigation(expanded: true),
            icon: Icon(Icons.settings, size: 18),
            position: OverlayPosition.end,
          ),
          const Gap(16),
          HeaderTrailingSheet(
            body: AppSidebarNavigation(expanded: true),
            icon: Icon(Icons.notifications, size: 18),
            position: OverlayPosition.end,
          ),
          const Gap(16),
          const VerticalDivider(),
          const Gap(16),
          Avatar(initials: 'SU'),
        ],
      ),
    );
  }
}
