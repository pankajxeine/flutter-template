import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'student_item_model.dart';

class StudentDetails extends StatelessWidget {
  const StudentDetails({super.key, required this.student});
  final StudentItem student;

  @override
  Widget build(BuildContext context) {
    final isActive = student.status == 'Active';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Avatar(size: 44, initials: _initials(student.name)),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.name).semiBold,
                      Text('${student.className} - ${student.section}').small,
                    ],
                  ),
                ),
                isActive
                    ? const PrimaryBadge(child: Text('Active'))
                    : const OutlineBadge(child: Text('Inactive')),
              ],
            ),
            const Gap(14),
            _metaRow('Roll No', student.rollNo),
            _metaRow('Attendance', student.attendance),
            _metaRow('Email', student.email),
            const Gap(10),
            Row(
              children: [
                OutlineButton(
                  density: ButtonDensity.compact,
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Icon(Icons.email_outlined, size: 14),
                      Gap(6),
                      Text('Email'),
                    ],
                  ),
                ),
                const Gap(8),
                OutlineButton(
                  density: ButtonDensity.compact,
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Icon(LucideIcons.view, size: 14),
                      Gap(6),
                      Text('View'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(key, style: TextStyle(color: Colors.gray)).small,
          ),
          Expanded(child: Text(value).small.bold),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) {
      return 'ST';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
