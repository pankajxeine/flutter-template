import 'package:forui_template/app/screens/academic/students/student_details.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '/core/layouts/main_layout.dart';
import '/core/layouts/widgets/page_header.dart';

import './students/student_card.dart';
import './students/student_item_model.dart';

enum _StudentsViewMode { card, list }

class StudentsListScreen extends StatelessWidget {
  const StudentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StudentsListView();
  }
}

class _StudentsListView extends StatefulWidget {
  const _StudentsListView();

  @override
  State<_StudentsListView> createState() => _StudentsListViewState();
}

class _StudentsListViewState extends State<_StudentsListView> {
  _StudentsViewMode _viewMode = _StudentsViewMode.card;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  StudentItem? _selectedStudent;

  final List<StudentItem> _students = List.generate(24, (index) {
    final id = index + 1;
    return StudentItem(
      id: 'ST-$id',
      name: 'Student $id',
      className: 'Class ${(index % 12) + 1}',
      section: ['A', 'B', 'C'][index % 3],
      rollNo: '${1000 + id}',
      attendance: '${78 + (index % 20)}%',
      email: 'student$id@school.edu',
      status: index % 7 == 0 ? 'Inactive' : 'Active',
    );
  });

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<StudentItem> get _filteredStudents {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return _students;
    }
    return _students.where((student) {
      return student.name.toLowerCase().contains(query) ||
          student.className.toLowerCase().contains(query) ||
          student.section.toLowerCase().contains(query) ||
          student.rollNo.toLowerCase().contains(query) ||
          student.email.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Students',
      desktop: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: PageHeader(
                    title: 'Students List',
                    subTitle:
                        'View all students in card view or list view using quick toggle.',
                  ),
                ),
                const Gap(12),
                _viewToggle(),
              ],
            ),
            const Gap(12),
            _buildSearchField(),
            const Gap(12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final showDetailsPanel =
                      constraints.maxWidth >= 1100 && _selectedStudent != null;
                  if (!showDetailsPanel) {
                    return _viewMode == _StudentsViewMode.card
                        ? _cardView(_filteredStudents)
                        : _listView(_filteredStudents);
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _viewMode == _StudentsViewMode.card
                            ? _cardView(_filteredStudents)
                            : _listView(_filteredStudents),
                      ),
                      const Gap(12),
                      if (_selectedStudent != null)
                        Expanded(
                          flex: 2,
                          child: StudentDetails(student: _selectedStudent!),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            placeholder: const Text(
              'Quick search students by name, class, roll, email...',
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        if (_searchQuery.trim().isNotEmpty) ...[
          const Gap(8),
          OutlineButton(
            density: ButtonDensity.compact,
            onPressed: () {
              _searchController.clear();
              setState(() => _searchQuery = '');
            },
            child: const Text('Clear'),
          ),
        ],
      ],
    );
  }

  Widget _viewToggle() {
    final isCard = _viewMode == _StudentsViewMode.card;
    return OutlinedContainer(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isCard
              ? PrimaryButton(
                  density: ButtonDensity.compact,
                  onPressed: () {},
                  child: const Text('Card View'),
                )
              : OutlineButton(
                  density: ButtonDensity.compact,
                  onPressed: () {
                    setState(() => _viewMode = _StudentsViewMode.card);
                  },
                  child: const Text('Card View'),
                ),
          const Gap(6),
          !isCard
              ? PrimaryButton(
                  density: ButtonDensity.compact,
                  onPressed: () {},
                  child: const Text('List View'),
                )
              : OutlineButton(
                  density: ButtonDensity.compact,
                  onPressed: () {
                    setState(() => _viewMode = _StudentsViewMode.list);
                  },
                  child: const Text('List View'),
                ),
        ],
      ),
    );
  }

  Widget _cardView(List<StudentItem> students) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 1300
            ? 4
            : width >= 1000
            ? 3
            : width >= 700
            ? 3
            : 2;
        final itemWidth =
            (width - ((crossAxisCount - 1) * 10)) / crossAxisCount;

        return SingleChildScrollView(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: students
                .map(
                  (student) => SizedBox(
                    width: itemWidth,
                    child: StudentInfoCard(student: student),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  Widget _listView(List<StudentItem> students) {
    return ListView.separated(
      itemCount: students.length,
      separatorBuilder: (_, _) => const Gap(8),
      itemBuilder: (context, index) => _studentListTile(students[index]),
    );
  }

  Widget _studentListTile(StudentItem student) {
    final isActive = student.status == 'Active';
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Avatar(initials: _initials(student.name)),
            const Gap(10),
            Expanded(
              flex: 2,
              child: Text(
                student.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(child: Text('${student.className}-${student.section}')),
            Expanded(child: Text('Roll: ${student.rollNo}')),
            Expanded(child: Text('Attendance: ${student.attendance}')),
            OutlineButton(
              density: ButtonDensity.compact,
              onPressed: () {
                setState(() => _selectedStudent = student);
              },
              child: const Icon(LucideIcons.view, size: 14),
            ),
            const Gap(8),
            isActive
                ? const PrimaryBadge(child: Text('Active'))
                : const OutlineBadge(child: Text('Inactive')),
          ],
        ),
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
