import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../navigation/app_sidebar_navigation.dart';
import '../widgets/header_trailing_sheet.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key, this.body, this.title, this.headerTrailing});

  final Widget? body;
  final String? title;
  final List<Widget>? headerTrailing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          leading: [
            HeaderTrailingSheet(
              body: AppSidebarNavigation(expanded: true),
              icon: const Icon(Icons.menu, size: 18),
              position: OverlayPosition.start,
            ),
          ],
          title: Text(title ?? ''),
          trailing: [...?headerTrailing],
        ),
      ],
      child: body ?? const SizedBox(),
    );
  }
}

