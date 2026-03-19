import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/navigation_cubit.dart';

class AppSidebarNavigation extends StatelessWidget {
  const AppSidebarNavigation({super.key, this.expanded});

  final bool? expanded;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: _NavigationView(expanded: expanded ?? false),
    );
  }
}

class NavBuildButton extends StatelessWidget {
  final String text;
  final IconData icon;

  const NavBuildButton({super.key, required this.text, required this.icon});
  @override
  Widget build(BuildContext context) {
    String selectedNav = context.watch<NavigationCubit>().state.selectedNav;
    // Convenience factory for a selectable navigation item with left alignment
    // and a primary icon style when selected.
    return NavigationItem(
      label: Text(text),
      // alignment: Alignment.centerLeft,
      selectedStyle: const ButtonStyle.primaryIcon(),
      selected: selectedNav == text,
      onChanged: (selected) {
        if (selected) {
          context.read<NavigationCubit>().selectNav(text);
        }
      },
      child: Icon(icon),
    );
  }
}

class _NavigationView extends StatelessWidget {
  const _NavigationView({required this.expanded});

  final bool expanded;
  NavigationGroup buildLabel(String label, List<Widget> children) {
    // Section header used to group related navigation items.
    return NavigationGroup(
      labelAlignment: Alignment.centerLeft,
      label: Text(label).semiBold.muted.xSmall,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    debugPrint(
      "Sidebar is Expanded: $expanded ${context.watch<NavigationCubit>().state.selectedNav} ${context.watch<NavigationCubit>().state.isExpanded} ",
    );
    return NavigationRail(
      backgroundColor: theme.colorScheme.accent.withValues(alpha: 0.4),
      // Expand/collapse behavior is handled by the `expanded` boolean.
      // With labelType.expanded, labels are hidden when collapsed.
      labelType: NavigationLabelType.expanded,
      labelPosition: NavigationLabelPosition.end,
      alignment: NavigationRailAlignment.start,
      expandedSize: 250,
      expanded: expanded,
      header: [
        Builder(
          builder: (context) {
            return NavigationSlot(
              leading: IconContainer(
                backgroundColor: Colors.blue,
                icon: const Icon(LucideIcons.galleryVerticalEnd).iconMedium,
              ),
              title: const Text('Acme Inc').medium.small,
              subtitle: const Text('Enterprise').xSmall.normal,
              trailing: const Icon(LucideIcons.chevronsUpDown).iconSmall,
              onPressed: () {
                showDropdown(
                  context: context,
                  anchorAlignment: AlignmentDirectional.centerEnd,
                  alignment: AlignmentDirectional.centerStart,
                  offset: const Offset(16, 0),
                  builder: (context) {
                    return DropdownMenu(
                      children: [
                        MenuButton(
                          leading: const Icon(Icons.person),
                          child: const Text('Profile'),
                          onPressed: (ctx) {},
                        ),
                        MenuButton(
                          leading: const Icon(Icons.settings),
                          child: const Text('Settings'),
                          onPressed: (ctx) {},
                        ),
                        const MenuDivider(),
                        MenuButton(
                          leading: const Icon(Icons.logout),
                          child: const Text('Logout'),
                          onPressed: (ctx) {},
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ],
      footer: [
        NavigationSlot(
          leading: Avatar(size: 32, initials: 'SU'),
          title: const Text('sunarya-thito').medium.small,
          subtitle: const Text('m@gmail.com').xSmall.normal,
          trailing: const Icon(LucideIcons.chevronsUpDown).iconSmall,
          onPressed: () {},
        ),
      ],
      children: [
        buildLabel('You', [
          NavBuildButton(text: 'Home', icon: Icons.home_filled),
          NavBuildButton(text: 'Trending', icon: Icons.trending_up),
          NavBuildButton(text: 'Subscription', icon: Icons.subscriptions),
        ]),
        const NavigationDivider(),
        NavigationCollapsible(
          leading: const Icon(Icons.history),
          label: const Text('History'),
          children: [
            NavBuildButton(text: 'History', icon: Icons.history),
            NavBuildButton(
              text: 'Watch Later',
              icon: Icons.access_time_rounded,
            ),
          ],
        ),
        const NavigationDivider(),
        buildLabel('Movie', [
          NavBuildButton(text: 'Action', icon: Icons.movie_creation_outlined),
          NavBuildButton(text: 'Horror', icon: Icons.movie_creation_outlined),
          NavBuildButton(text: 'Thriller', icon: Icons.movie_creation_outlined),
        ]),
        const NavigationDivider(),
        NavigationCollapsible(
          leading: const Icon(Icons.movie_filter_outlined),
          label: const Text('Short Films'),
          children: [
            NavBuildButton(text: 'Action', icon: Icons.movie_creation_outlined),
            NavBuildButton(text: 'Horror', icon: Icons.movie_creation_outlined),
          ],
        ),
      ],
    );
  }
}

