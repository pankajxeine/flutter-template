import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'main_layout.dart';

class PageLayout extends StatelessWidget {
  const PageLayout({
    super.key,
    required this.title,
    this.useLayout,
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
  final bool? useLayout;

  @override
  Widget build(BuildContext context) {
    return _buildLayout(context);
  }

  Widget _buildLayout(BuildContext context) {
    return MainLayout(
      desktop: desktop,
      mobile: mobile,
      tablet: tablet,
      useLayout: useLayout ?? true,
      title: title,
      headerTrailing: headerTrailing,
    );
  }
}

// class _AppResponsiveLayoutState extends State<AppResponsiveLayout> {
//   bool _desktopExpanded = true;
//   bool _tabletExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final layoutSize = _sizeForWidth(constraints.maxWidth);
//         final showSideNav = layoutSize != _LayoutSize.mobile;
//         final expanded = _isExpanded(layoutSize);

//         return Scaffold(
//           headers: [
//             AppBar(
//               leading: [
//                 if (showSideNav)
//                   OutlineButton(
//                     density: ButtonDensity.icon,
//                     onPressed: () => _toggleExpanded(layoutSize),
//                     child: Icon(
//                       expanded ? Icons.menu_open : Icons.menu,
//                       size: 18,
//                     ),
//                   ),
//               ],
//               title: Text(widget.title),
//               trailing: widget.headerTrailing,
//             ),
//           ],
//           footers: [
//             if (ResponsiveBuilder.isMobile(context)) _buildMobileNavigation(),
//           ],
//           child: Row(
//             children: [
//               if (showSideNav)
//                 AppSidebar(
//                   destinations: widget.destinations,
//                   selectedKey: widget.selectedKey,
//                   expanded: expanded,
//                   brandName: widget.brandName,
//                   onToggleExpanded: () => _toggleExpanded(layoutSize),
//                   onDestinationSelected: (destination) {
//                     widget.onDestinationSelected?.call(destination);
//                   },
//                 ),
//               Expanded(child: widget.child),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   _LayoutSize _sizeForWidth(double width) {
//     if (width < 700) return _LayoutSize.mobile;
//     if (width < 1100) return _LayoutSize.tablet;
//     return _LayoutSize.desktop;
//   }

//   bool _isExpanded(_LayoutSize size) {
//     switch (size) {
//       case _LayoutSize.desktop:
//         return _desktopExpanded;
//       case _LayoutSize.tablet:
//         return _tabletExpanded;
//       case _LayoutSize.mobile:
//         return false;
//     }
//   }

//   void _toggleExpanded(_LayoutSize size) {
//     setState(() {
//       if (size == _LayoutSize.desktop) {
//         _desktopExpanded = !_desktopExpanded;
//       } else if (size == _LayoutSize.tablet) {
//         _tabletExpanded = !_tabletExpanded;
//       }
//     });
//   }

//   Widget _buildMobileNavigation() {
//     return NavigationBar(
//       selectedKey: _destinationKey(widget.selectedKey),
//       onSelected: _handleSelectedKey,
//       alignment: NavigationBarAlignment.spaceEvenly,
//       children: widget.destinations.map(_buildNavItem).toList(),
//     );
//   }

//   NavigationItem _buildNavItem(AppNavDestination destination) {
//     return NavigationItem(
//       key: _destinationKey(destination.key),
//       label: Text(destination.label),
//       child: Icon(destination.icon),
//     );
//   }

//   Key _destinationKey(String key) => ValueKey<String>('dest::$key');

//   void _handleSelectedKey(Key? key) {
//     if (key is! ValueKey<String>) return;
//     final id = key.value;
//     if (!id.startsWith('dest::')) return;
//     final destinationKey = id.replaceFirst('dest::', '');

//     for (final destination in widget.destinations) {
//       if (destination.key == destinationKey) {
//         widget.onDestinationSelected?.call(destination);
//         return;
//       }
//     }
//   }
// }
