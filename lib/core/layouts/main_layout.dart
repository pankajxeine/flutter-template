import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'responsive.dart';
import 'screens/desktop.dart';
import 'screens/tablet.dart';
import 'screens/mobile.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
    required this.title,
    this.useLayout = true,
    this.mobile,
    this.tablet,
    this.headerTrailing,
    required this.desktop,
  });

  final String title;
  final Widget? mobile;
  final Widget? tablet;
  final Widget desktop;
  final List<Widget>? headerTrailing;
  final bool useLayout;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      desktopBuilder: _desktopBuilder(),

      mobileBuilder: _mobileBuilder(),

      tabletBuilder: _tabletBuilder(),
    );
  }

  Widget _desktopBuilder() {
    return useLayout
        ? DesktopLayout(
            title: title,
            body: desktop,
            headerTrailing: headerTrailing,
          )
        : desktop;
  }

  Widget? _mobileBuilder() {
    if (mobile != null) {
      useLayout
          ? MobileLayout(
              title: title,
              body: mobile,
              headerTrailing: headerTrailing,
            )
          : mobile;
    } else {
      return null;
    }
  }

  Widget? _tabletBuilder() {
    if (tablet != null) {
      useLayout
          ? TabletLayout(
              title: title,
              body: tablet,
              headerTrailing: headerTrailing,
            )
          : tablet;
    } else {
      return null;
    }
  }
}
