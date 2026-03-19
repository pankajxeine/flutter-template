import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/presentation/screens/home/widgets/dashboard_widgets.dart';
import '/app/presentation/widgets/common/app_layout.dart';

class ClassRoomViewScreen extends StatefulWidget {
  final String roomId;

  const ClassRoomViewScreen({super.key, required this.roomId});

  @override
  State<ClassRoomViewScreen> createState() => _ClassRoomViewScreenState();
}

class _ClassRoomViewScreenState extends State<ClassRoomViewScreen> {

  @override
  Widget build(BuildContext context) {

    return AppPage(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  'Class Room Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'ID: ${widget.roomId}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            const BreadcrumbsBox(items: ['Academic', 'Class Room', 'Details']),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withAlpha(
                    (Theme.of(context).colorScheme.outline.a * 255 * 0.15)
                        .round(),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _detailRow(context, 'Room Code', widget.roomId),
                    _detailRow(context, 'Grade', 'Grade 1'),
                    _detailRow(context, 'Section', 'A'),
                    _detailRow(context, 'Teacher', 'Assign teacher here'),
                    _detailRow(context, 'Capacity', '30'),
                    _detailRow(context, 'Schedule', '08:00-09:30'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
