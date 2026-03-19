import 'package:flutter/material.dart';

import '/app/presentation/widgets/common/app_layout.dart';

class HomeworkScreen extends StatelessWidget {
  const HomeworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeworkView();
  }
}

class _HomeworkView extends StatefulWidget {
  @override
  State<_HomeworkView> createState() => _HomeworkViewState();
}

class _HomeworkViewState extends State<_HomeworkView> {

  @override
  Widget build(BuildContext context) {

    return AppPage(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Homework',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Assign and track homework assignments.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text(
                  'Homework Management',
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
