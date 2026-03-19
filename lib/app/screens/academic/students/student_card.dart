import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'student_item_model.dart';

class StudentInfoCard extends StatelessWidget {
  const StudentInfoCard({super.key, required this.student});
  final StudentItem student;

  @override
  Widget build(BuildContext context) {
    final isActive = student.status == 'Active';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Avatar(initials: _initials(student.name)),
                const Gap(8),
                Expanded(
                  child: Text(
                    student.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                isActive
                    ? const PrimaryBadge(child: Text('Active'))
                    : const OutlineBadge(child: Text('Inactive')),
              ],
            ),
            const Gap(10),
            _metaRow('Class', '${student.className} - ${student.section}'),
            _metaRow('Roll No', student.rollNo),
            _metaRow('Attendance', student.attendance),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlineButton(
                  density: ButtonDensity.normal,
                  shape: ButtonShape.circle,
                  onPressed: () {},
                  child: const Icon(Icons.edit, size: 14),
                ),
                OutlineButton(
                  density: ButtonDensity.normal,
                  shape: ButtonShape.circle,
                  onPressed: () {
                    //setState(() => _selectedStudent = student);
                  },
                  child: const Icon(LucideIcons.view, size: 14),
                ),
                OutlineButton(
                  density: ButtonDensity.normal,
                  shape: ButtonShape.circle,
                  onPressed: () {},
                  child: const Icon(Icons.delete, size: 14),
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
