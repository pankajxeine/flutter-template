import 'package:shadcn_flutter/shadcn_flutter.dart';

import '/core/layouts/main_layout.dart';
import 'package:go_router/go_router.dart';

class ClassRoomScreen extends StatelessWidget {
  const ClassRoomScreen({super.key});

  @override
  Widget build(BuildContext context) => const _ClassRoomView();
}

class _ClassRoomView extends StatefulWidget {
  const _ClassRoomView();

  @override
  State<_ClassRoomView> createState() => _ClassRoomViewState();
}

class _ClassRoomViewState extends State<_ClassRoomView> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _gradeFilter = 'All';
  int _sortColumn = 0;
  bool _sortAsc = true;

  final List<ClassRoom> _rooms = [
    ClassRoom(
      code: 'CR-101',
      grade: 'Grade 1',
      section: 'A',
      teacher: 'Anita Bose',
      capacity: 30,
      schedule: '08:00-09:30',
    ),
    ClassRoom(
      code: 'CR-102',
      grade: 'Grade 1',
      section: 'B',
      teacher: 'Tim Keller',
      capacity: 28,
      schedule: '09:40-11:10',
    ),
    ClassRoom(
      code: 'CR-201',
      grade: 'Grade 2',
      section: 'A',
      teacher: 'Lena Park',
      capacity: 32,
      schedule: '11:20-12:50',
    ),
    ClassRoom(
      code: 'CR-301',
      grade: 'Grade 3',
      section: 'A',
      teacher: 'Ravi Singh',
      capacity: 26,
      schedule: '13:30-15:00',
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Class room',
      desktop: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Class Room', style: Theme.of(context).typography.h3),
            const SizedBox(height: 6),
            Text(
              'Manage classroom assignments and room allocations.',
              style: Theme.of(context).typography.medium,
            ),
            const SizedBox(height: 12),
            const Breadcrumb(
              // Use a built-in arrow separator for a conventional look.
              separator: Breadcrumb.arrowSeparator,
              children: [
                TextButton(density: ButtonDensity.compact, child: Text('Home')),
                MoreDots(),
                TextButton(
                  density: ButtonDensity.compact,
                  child: Text('Components'),
                ),
                // Final segment as a non-interactive label.
                Text('Breadcrumb'),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _quickStat(
                  context,
                  'Active Rooms',
                  '18',
                  Icons.meeting_room_outlined,
                ),
                _quickStat(
                  context,
                  'Avg. Capacity',
                  '29',
                  Icons.groups_3_outlined,
                ),
                _quickStat(
                  context,
                  'Vacant Today',
                  '3',
                  Icons.event_available_outlined,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Expanded(
            //   child: AppTableCard<ClassRoom>(
            //     title: 'Class Rooms',
            //     description:
            //         'Quick search, sort, and manage classroom details.',
            //     searchController: _searchCtrl,
            //     filterLabel: 'Grade',
            //     filterValue: _gradeFilter,
            //     filterOptions: const ['All', 'Grade 1', 'Grade 2', 'Grade 3'],
            //     onFilterChanged: (v) => setState(() => _gradeFilter = v),
            //     columns: [
            //       AppTableColumn<ClassRoom>(
            //         label: 'Room',
            //         sortable: true,
            //         valueForSort: (r) => r.code,
            //         cellBuilder: (r) => Text(r.code),
            //       ),
            //       AppTableColumn<ClassRoom>(
            //         label: 'Grade',
            //         sortable: true,
            //         valueForSort: (r) => r.grade,
            //         cellBuilder: (r) => Text('${r.grade} - ${r.section}'),
            //       ),
            //       AppTableColumn<ClassRoom>(
            //         label: 'Teacher',
            //         sortable: true,
            //         valueForSort: (r) => r.teacher,
            //         cellBuilder: (r) => Text(r.teacher),
            //       ),
            //       AppTableColumn<ClassRoom>(
            //         label: 'Capacity',
            //         numeric: true,
            //         sortable: true,
            //         valueForSort: (r) => r.capacity,
            //         cellBuilder: (r) => Text('${r.capacity}'),
            //       ),
            //       AppTableColumn<ClassRoom>(
            //         label: 'Schedule',
            //         valueForSort: (r) => r.schedule,
            //         cellBuilder: (r) => Text(r.schedule),
            //       ),
            //     ],
            //     sortColumnIndex: _sortColumn,
            //     sortAscending: _sortAsc,
            //     onSortChanged: (index, asc) => setState(() {
            //       _sortColumn = index;
            //       _sortAsc = asc;
            //     }),
            //     rows: _filteredAndSortedRooms(),
            //     onAdd: _handleAdd,
            //     onView: _handleView,
            //     onEdit: _handleEdit,
            //     onDelete: _handleDelete,
            //     onSearchChanged: () => setState(() {}),
            //     fillWidth: true,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // List<ClassRoom> _filteredAndSortedRooms() {
  //   final term = _searchCtrl.text.trim().toLowerCase();
  //   final filtered = _rooms.where((r) {
  //     final matchesSearch =
  //         term.isEmpty ||
  //         r.code.toLowerCase().contains(term) ||
  //         r.teacher.toLowerCase().contains(term) ||
  //         r.grade.toLowerCase().contains(term) ||
  //         r.section.toLowerCase().contains(term);
  //     final matchesFilter = _gradeFilter == 'All' || r.grade == _gradeFilter;
  //     return matchesSearch && matchesFilter;
  //   }).toList();

  //   final columnGetter = <int, Comparable Function(ClassRoom)>{
  //     0: (r) => r.code,
  //     1: (r) => '${r.grade}-${r.section}',
  //     2: (r) => r.teacher,
  //     3: (r) => r.capacity,
  //     4: (r) => r.schedule,
  //   }[_sortColumn];

  //   if (columnGetter != null) {
  //     filtered.sort((a, b) {
  //       final cmp = columnGetter(a).compareTo(columnGetter(b));
  //       return _sortAsc ? cmp : -cmp;
  //     });
  //   }
  //   return filtered;
  // }

  // void _handleAdd() async {
  //   final created = await showDialog<ClassRoom>(
  //     context: context,
  //     builder: (ctx) => const _ClassRoomFormDialog(title: 'Add Class Room'),
  //   );
  //   if (!mounted) return;
  //   if (created != null) {
  //     setState(() => _rooms.add(created));
  //     // ScaffoldMessenger.of(
  //     //   context,
  //     // ).showSnackBar(const SnackBar(content: Text('Class room added')));
  //   }
  // }

  // void _handleEdit(ClassRoom room) async {
  //   final updated = await showDialog<ClassRoom>(
  //     context: context,
  //     builder: (ctx) =>
  //         _ClassRoomFormDialog(title: 'Edit Class Room', existing: room),
  //   );
  //   if (!mounted) return;
  //   if (updated != null) {
  //     setState(() {
  //       final idx = _rooms.indexWhere((r) => r.code == room.code);
  //       if (idx != -1) _rooms[idx] = updated;
  //     });
  //     // ScaffoldMessenger.of(
  //     //   context,
  //     // ).showSnackBar(const SnackBar(content: Text('Class room updated')));
  //   }
  // }

  // void _handleView(ClassRoom room) {
  //   context.push('/academic/class-room/${room.code}/view');
  // }

  // void _handleDelete(ClassRoom room) async {
  //   final confirm = await showDialog<bool>(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text('Delete classroom?'),
  //       content: Text(
  //         'Remove ${room.code} (${room.grade} ${room.section}) from the list?',
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(ctx, false),
  //           child: const Text('Cancel'),
  //         ),
  //         OutlineButton(
  //           onPressed: () => Navigator.pop(ctx, true),
  //           density: ButtonDensity.icon,
  //           child: Icon(Icons.delete_outline),
  //         ),
  //       ],
  //     ),
  //   );
  //   if (!mounted) return;
  //   if (confirm == true) {
  //     setState(() => _rooms.removeWhere((r) => r.code == room.code));
  //     // ScaffoldMessenger.of(
  //     //   context,
  //     // ).showSnackBar(const SnackBar(content: Text('Deleted classroom')));
  //   }
  // }

  Widget _quickStat(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.accentForeground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: Theme.of(context).typography.bold),
              Text(title, style: Theme.of(context).typography.medium),
            ],
          ),
        ],
      ),
    );
  }
}

class AppTableColumn<T> {
  final String label;
  final Widget Function(T row) cellBuilder;
  final bool numeric;
  final bool sortable;
  final Comparable Function(T row)? valueForSort;

  const AppTableColumn({
    required this.label,
    required this.cellBuilder,
    this.numeric = false,
    this.sortable = true,
    this.valueForSort,
  });
}

class ClassRoom {
  final String code;
  final String grade;
  final String section;
  final String teacher;
  final int capacity;
  final String schedule;

  ClassRoom({
    required this.code,
    required this.grade,
    required this.section,
    required this.teacher,
    required this.capacity,
    required this.schedule,
  });

  ClassRoom copyWith({
    String? code,
    String? grade,
    String? section,
    String? teacher,
    int? capacity,
    String? schedule,
  }) {
    return ClassRoom(
      code: code ?? this.code,
      grade: grade ?? this.grade,
      section: section ?? this.section,
      teacher: teacher ?? this.teacher,
      capacity: capacity ?? this.capacity,
      schedule: schedule ?? this.schedule,
    );
  }
}
