import 'package:shadcn_flutter/shadcn_flutter.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    this.mobileBuilder,
    this.tabletBuilder,
    required this.desktopBuilder,
  });

  final Widget? mobileBuilder;

  final Widget? tabletBuilder;

  final Widget desktopBuilder;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 600;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile(context)) {
          return mobileBuilder ?? desktopBuilder;
        } else if (isTablet(context)) {
          return tabletBuilder ?? desktopBuilder;
        } else {
          return desktopBuilder;
        }
      },
    );
  }
}
