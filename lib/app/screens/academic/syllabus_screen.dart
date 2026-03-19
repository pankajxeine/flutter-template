import 'package:flutter/material.dart';

import '/app/presentation/widgets/common/app_layout.dart';

class SyllabusScreen extends StatelessWidget {
  const SyllabusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SyllabusView();
  }
}

class _SyllabusView extends StatefulWidget {
  @override
  State<_SyllabusView> createState() => _SyllabusViewState();
}

class _SyllabusViewState extends State<_SyllabusView> {

  @override
  Widget build(BuildContext context) {

    return AppPage(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Syllabus',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Manage course syllabi and curriculum content.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text(
                  'Syllabus Management',
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
