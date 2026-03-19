import 'package:flutter/material.dart';

import '/app/presentation/widgets/common/app_layout.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubjectView();
  }
}

class _SubjectView extends StatefulWidget {
  @override
  State<_SubjectView> createState() => _SubjectViewState();
}

class _SubjectViewState extends State<_SubjectView> {

  @override
  Widget build(BuildContext context) {

    return AppPage(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subject',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Manage subjects and course offerings.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text(
                  'Subject Management',
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
