import 'package:flutter/material.dart';

import '/app/presentation/widgets/common/app_layout.dart';

class ClassRoutineScreen extends StatelessWidget {
  const ClassRoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ClassRoutineView();
  }
}

class _ClassRoutineView extends StatefulWidget {
  @override
  State<_ClassRoutineView> createState() => _ClassRoutineViewState();
}

class _ClassRoutineViewState extends State<_ClassRoutineView> {

  @override
  Widget build(BuildContext context) {

    return AppPage(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Class Routine',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'View and manage daily class schedules and routines.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text(
                  'Class Routine Management',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
