// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

import 'core/config/app_logger.dart';
import 'core/config/environment.dart';
import 'core/config/local_storage.dart';

import 'app.dart';

void main() async {
  AppLogger.configure(isProduction: false);
  final log = AppLogger.getLogger("main_local.dart");

  ProfileConstants.setEnvironment(Environment.dev);

  log.info("Starting App with env: {}", [Environment.dev.name]);

  WidgetsFlutterBinding.ensureInitialized();

  const defaultLanguage = "en";
  AppLocalStorage().setStorage(StorageType.sharedPreferences);
  await AppLocalStorage().save(StorageKeys.language.name, defaultLanguage);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    // runApp(const AdminApp());
    runApp(const App(language: defaultLanguage));
  });
}
// class ThemeOption {
//   const ThemeOption({
//     required this.name,
//     required this.light,
//     required this.dark,
//   });

//   final String name;
//   final FThemeData light;
//   final FThemeData dark;
// }

// class AdminApp extends StatefulWidget {
//   const AdminApp({super.key});

//   @override
//   State<AdminApp> createState() => _AdminAppState();
// }

// class _AdminAppState extends State<AdminApp> {
//   final _options = <ThemeOption>[
//     ThemeOption(
//       name: 'Zinc',
//       light: FThemes.zinc.light,
//       dark: FThemes.zinc.dark,
//     ),
//     ThemeOption(
//       name: 'Blue',
//       light: FThemes.blue.light,
//       dark: FThemes.blue.dark,
//     ),
//     ThemeOption(
//       name: 'Green',
//       light: FThemes.green.light,
//       dark: FThemes.green.dark,
//     ),
//   ];

//   var _themeIndex = 0;
//   var _darkMode = false;

//   FThemeData get _activeTheme =>
//       _darkMode ? _options[_themeIndex].dark : _options[_themeIndex].light;

//   void _toggleDark() => setState(() => _darkMode = !_darkMode);

//   void _cycleTheme() =>
//       setState(() => _themeIndex = (_themeIndex + 1) % _options.length);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       localizationsDelegates: FLocalizations.localizationsDelegates,
//       supportedLocales: FLocalizations.supportedLocales,
//       theme: ThemeData( colorScheme: ).toApproximateMaterialTheme(),
//       builder: (_, child) => FTheme(data: _activeTheme, child: child!),
//       home: AdminShell(
//         themeName: _options[_themeIndex].name,
//         darkMode: _darkMode,
//         onToggleDark: _toggleDark,
//         onCycleTheme: _cycleTheme,
//       ),
//     );
//   }
// }

// class AdminShell extends StatefulWidget {
//   const AdminShell({
//     super.key,
//     required this.themeName,
//     required this.darkMode,
//     required this.onToggleDark,
//     required this.onCycleTheme,
//   });

//   final String themeName;
//   final bool darkMode;
//   final VoidCallback onToggleDark;
//   final VoidCallback onCycleTheme;

//   @override
//   State<AdminShell> createState() => _AdminShellState();
// }

// class _AdminShellState extends State<AdminShell> {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   final _nav = const [
//     (label: 'Overview', icon: FIcons.layoutDashboard),
//     (label: 'Analytics', icon: FIcons.activity),
//     (label: 'Customers', icon: FIcons.users),
//     (label: 'Projects', icon: FIcons.briefcaseBusiness),
//     (label: 'Settings', icon: FIcons.settings),
//   ];

//   var _selected = 0;
//   var _sizeClass = 'desktop';
//   var _desktopCollapsed = false;
//   var _tabletCollapsed = true;

//   bool get _isDesktop => _sizeClass == 'desktop';
//   bool get _isTablet => _sizeClass == 'tablet';
//   bool get _isMobile => _sizeClass == 'mobile';
//   bool get _collapsed => _isDesktop ? _desktopCollapsed : _tabletCollapsed;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _syncSizeClass();
//   }

//   void _syncSizeClass() {
//     final width = MediaQuery.sizeOf(context).width;
//     final breakpoints = context.theme.breakpoints;
//     final next = width < breakpoints.sm
//         ? 'mobile'
//         : width < breakpoints.lg
//         ? 'tablet'
//         : 'desktop';

//     if (next != _sizeClass) {
//       setState(() {
//         _sizeClass = next;
//         if (next == 'desktop') {
//           _desktopCollapsed = false;
//         } else if (next == 'tablet') {
//           _tabletCollapsed = true;
//         }
//       });
//     }
//   }

//   void _toggleSidebar() {
//     setState(() {
//       if (_isDesktop) {
//         _desktopCollapsed = !_desktopCollapsed;
//       } else if (_isTablet) {
//         _tabletCollapsed = !_tabletCollapsed;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     _syncSizeClass();

//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: _isMobile
//           ? Drawer(
//               backgroundColor: context.theme.colors.background,
//               child: SafeArea(child: _buildSidebar(collapsed: false)),
//             )
//           : null,
//       body: FScaffold(
//         header: _buildHeader(),
//         sidebar: _isMobile ? null : _buildSidebar(collapsed: _collapsed),
//         footer: _buildFooter(),
//         child: _buildContent(),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     final typography = context.theme.typography;
//     final colors = context.theme.colors;

//     return FHeader.nested(
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Aurora Admin',
//             style: typography.xl2.copyWith(
//               color: colors.foreground,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           Text(
//             'Responsive template built with Forui',
//             style: typography.sm.copyWith(color: colors.mutedForeground),
//           ),
//         ],
//       ),
//       prefixes: [
//         _isMobile
//             ? FHeaderAction(
//                 icon: const Icon(FIcons.menu),
//                 onPress: () => _scaffoldKey.currentState?.openDrawer(),
//               )
//             : FHeaderAction(
//                 icon: Icon(
//                   _collapsed ? FIcons.panelLeftOpen : FIcons.panelLeftClose,
//                 ),
//                 onPress: _toggleSidebar,
//               ),
//       ],
//       suffixes: [
//         FHeaderAction(icon: const Icon(FIcons.languages), onPress: () {}),
//         FHeaderAction(
//           icon: Stack(
//             clipBehavior: Clip.none,
//             children: [
//               const Icon(FIcons.bell),
//               Positioned(
//                 right: -4,
//                 top: -6,
//                 child: FBadge(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 6,
//                       vertical: 2,
//                     ),
//                     child: Text(
//                       '3',
//                       style: typography.xs.copyWith(
//                         color: colors.primaryForeground,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           onPress: () {},
//         ),
//         FHeaderAction(
//           icon: Icon(widget.darkMode ? FIcons.sunMedium : FIcons.moonStar),
//           onPress: widget.onToggleDark,
//         ),
//         FHeaderAction(
//           icon: const Icon(FIcons.palette),
//           onPress: widget.onCycleTheme,
//         ),
//         FHeaderAction(icon: const Icon(FIcons.settings2), onPress: () {}),
//         FHeaderAction(
//           icon: FAvatar.raw(
//             size: 32,
//             child: Center(
//               child: Text(
//                 'AB',
//                 style: typography.sm.copyWith(
//                   color: colors.primaryForeground,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ),
//           onPress: () {},
//         ),
//       ],
//     );
//   }

//   Widget _buildSidebar({required bool collapsed}) {
//     final typography = context.theme.typography;
//     final colors = context.theme.colors;
//     final width = collapsed ? 96.0 : 280.0;

//     return SizedBox(
//       width: width,
//       child: FSidebar(
//         style: (style) =>
//             style.copyWith(constraints: BoxConstraints.tightFor(width: width)),
//         header: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           child: Row(
//             children: [
//               FAvatar.raw(
//                 size: 36,
//                 child: Center(
//                   child: Text(
//                     'AU',
//                     style: typography.sm.copyWith(fontWeight: FontWeight.w700),
//                   ),
//                 ),
//               ),
//               if (!collapsed) ...[
//                 const SizedBox(width: 12),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Aurora',
//                       style: typography.lg.copyWith(
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     Text(
//                       'v1.0',
//                       style: typography.sm.copyWith(
//                         color: colors.mutedForeground,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ],
//           ),
//         ),
//         children: [
//           FSidebarGroup(
//             label: collapsed ? null : const Text('Main'),
//             children: _nav
//                 .asMap()
//                 .entries
//                 .map(
//                   (entry) => FSidebarItem(
//                     selected: entry.key == _selected,
//                     icon: Icon(entry.value.icon),
//                     label: collapsed ? null : Text(entry.value.label),
//                     onPress: () => setState(() => _selected = entry.key),
//                   ),
//                 )
//                 .toList(),
//           ),
//           FSidebarGroup(
//             label: collapsed ? null : const Text('Workspace'),
//             children: [
//               FSidebarItem(
//                 icon: const Icon(FIcons.calendarClock),
//                 label: collapsed ? null : const Text('Calendar'),
//                 onPress: () {},
//               ),
//               FSidebarItem(
//                 icon: const Icon(FIcons.messagesSquare),
//                 label: collapsed ? null : const Text('Messages'),
//                 onPress: () {},
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFooter() {
//     final colors = context.theme.colors;
//     final typography = context.theme.typography;

//     return Container(
//       height: 56,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         border: Border(
//           top: BorderSide(
//             color: colors.border,
//             width: context.theme.style.borderWidth,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           Text(
//             '© 2026 Aurora',
//             style: typography.sm.copyWith(color: colors.mutedForeground),
//           ),
//           const Spacer(),
//           Text(
//             '${widget.themeName} • ${widget.darkMode ? "Dark" : "Light"}',
//             style: typography.sm.copyWith(color: colors.mutedForeground),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContent() {
//     final colors = context.theme.colors;
//     final typography = context.theme.typography;

//     return SafeArea(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             WrapSuper(
//               spacing: 16,
//               lineSpacing: 16,
//               children: [
//                 _statCard('Revenue', '\$128k', '+12.4%', colors, typography),
//                 _statCard('Active Users', '8,241', '+3.2%', colors, typography),
//                 _statCard('Open Tickets', '32', '-6.1%', colors, typography),
//                 _statCard(
//                   'Server Uptime',
//                   '99.98%',
//                   '+0.02%',
//                   colors,
//                   typography,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: _panel(
//                     title: 'Performance',
//                     actionLabel: 'View all',
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Today',
//                           style: typography.lg.copyWith(
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         FDeterminateProgress(
//                           value: 0.68,
//                           style: (style) => style.copyWith(
//                             trackDecoration: BoxDecoration(color: colors.muted),
//                             fillDecoration: BoxDecoration(
//                               color: colors.primary,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Text(
//                           '68% of the daily goal reached. Keep the momentum going.',
//                           style: typography.base.copyWith(
//                             color: colors.mutedForeground,
//                           ),
//                         ),
//                         const SizedBox(height: 14),
//                         WrapSuper(
//                           spacing: 10,
//                           lineSpacing: 10,
//                           children:
//                               ['Product', 'Design', 'Marketing', 'Support']
//                                   .map(
//                                     (label) => Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 12,
//                                         vertical: 8,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: colors.secondary,
//                                         borderRadius:
//                                             context.theme.style.borderRadius,
//                                         border: Border.all(
//                                           color: colors.border,
//                                           width:
//                                               context.theme.style.borderWidth,
//                                         ),
//                                       ),
//                                       child: Text(label, style: typography.sm),
//                                     ),
//                                   )
//                                   .toList(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: _panel(
//                     title: 'Alerts',
//                     child: Column(
//                       children: [
//                         FAlert(
//                           title: Text(
//                             'All systems operational',
//                             style: typography.base,
//                           ),
//                           subtitle: Text(
//                             'No incidents in the last 24h',
//                             style: typography.sm,
//                           ),
//                           icon: const Icon(FIcons.shieldCheck),
//                         ),
//                         const SizedBox(height: 10),
//                         FAlert(
//                           title: Text('API latency', style: typography.base),
//                           subtitle: Text(
//                             'EU-West experiencing slight delays',
//                             style: typography.sm,
//                           ),
//                           icon: const Icon(FIcons.cloudRainWind),
//                         ),
//                         const SizedBox(height: 10),
//                         FAlert(
//                           title: Text(
//                             'Billing webhook retries',
//                             style: typography.base,
//                           ),
//                           subtitle: Text(
//                             '2 retries failed. Investigate logs.',
//                             style: typography.sm,
//                           ),
//                           icon: const Icon(FIcons.circleAlert),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             _panel(
//               title: 'Recent Activity',
//               child: Column(
//                 children: [
//                   _activityRow(
//                     icon: FIcons.sparkles,
//                     title: 'Launched “Aurora Pay” beta',
//                     time: '10:24 AM',
//                     colors: colors,
//                     typography: typography,
//                   ),
//                   _activityRow(
//                     icon: FIcons.userPlus,
//                     title: 'New team member added to Growth',
//                     time: '09:15 AM',
//                     colors: colors,
//                     typography: typography,
//                   ),
//                   _activityRow(
//                     icon: FIcons.gitPullRequest,
//                     title: 'PR #204 merged to main',
//                     time: 'Yesterday',
//                     colors: colors,
//                     typography: typography,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _statCard(
//     String label,
//     String value,
//     String trend,
//     FColors colors,
//     FTypography typography,
//   ) {
//     final isPositive = !trend.startsWith('-');

//     return SizedBox(
//       width: 250,
//       child: FCard(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   FBadge(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       child: Icon(
//                         isPositive ? FIcons.trendingUp : FIcons.trendingDown,
//                         size: 16,
//                         color: colors.primary,
//                       ),
//                     ),
//                   ),
//                   const Spacer(),
//                   Text(
//                     trend,
//                     style: typography.sm.copyWith(
//                       color: isPositive ? colors.primary : colors.destructive,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 value,
//                 style: typography.xl3.copyWith(fontWeight: FontWeight.w700),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 label,
//                 style: typography.base.copyWith(color: colors.mutedForeground),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _panel({
//     required String title,
//     required Widget child,
//     String? actionLabel,
//   }) {
//     final typography = context.theme.typography;

//     return FCard(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   title,
//                   style: typography.lg.copyWith(fontWeight: FontWeight.w700),
//                 ),
//                 const Spacer(),
//                 if (actionLabel != null)
//                   FButton(
//                     onPress: () {},
//                     style: FButtonStyle.outline(),
//                     child: Text(actionLabel),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             child,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _activityRow({
//     required IconData icon,
//     required String title,
//     required String time,
//     required FColors colors,
//     required FTypography typography,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           FBadge(
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: Icon(icon, color: colors.primary, size: 18),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: typography.base.copyWith(fontWeight: FontWeight.w600),
//                 ),
//                 Text(
//                   time,
//                   style: typography.sm.copyWith(color: colors.mutedForeground),
//                 ),
//               ],
//             ),
//           ),
//           FButton(
//             onPress: () {},
//             style: FButtonStyle.outline(),
//             child: const Text('Details'),
//           ),
//         ],
//       ),
//     );
//   }
// }
