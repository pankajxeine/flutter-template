import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../../core/widgets/inline_day_calender_widget.dart';
import '../../../core/layouts/main_layout.dart';
import '../../../core/layouts/responsive.dart';
import '../../../core/widgets/generic_table_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // final _destinations = const <AppNavDestination>[
  //   AppNavDestination(key: 'dashboard', label: 'Dashboard', icon: Icons.home),
  //   AppNavDestination(
  //     key: 'analytics',
  //     label: 'Analytics',
  //     icon: Icons.insights,
  //   ),
  //   AppNavDestination(key: 'projects', label: 'Projects', icon: Icons.work),
  //   AppNavDestination(key: 'settings', label: 'Settings', icon: Icons.settings),
  // ];

  @override
  Widget build(BuildContext context) {
    return MainLayout(title: 'Dashboard', desktop: const _HomeDashboardBody());
  }
}

class _HomeDashboardBody extends StatefulWidget {
  const _HomeDashboardBody();

  @override
  State<_HomeDashboardBody> createState() => _HomeDashboardBodyState();
}

class _HomeDashboardBodyState extends State<_HomeDashboardBody> {
  String _studentMonth = 'All Months';
  String _studentYear = 'All Years';
  String _studentSection = 'All Sections';
  String _studentCourse = 'All Courses';

  String _examYear = '2026';
  String _examSection = 'A';
  String _examCourse = 'Science';

  DateTime? _selectedDay;
  Set<String> _selectedStudentRows = <String>{};
  // Set<String> _selectedExamRows = <String>{};
  bool _showStudentCheckbox = true;
  // bool _showExamCheckbox = true;

  final List<Map<String, String>> _students = const [
    {
      'name': 'Aarav Sharma',
      'month': 'Jan',
      'year': '2026',
      'section': 'A',
      'course': 'Science',
    },
    {
      'name': 'Anaya Patel',
      'month': 'Feb',
      'year': '2026',
      'section': 'B',
      'course': 'Commerce',
    },
    {
      'name': 'Rohan Verma',
      'month': 'Jan',
      'year': '2025',
      'section': 'A',
      'course': 'Math',
    },
    {
      'name': 'Meera Singh',
      'month': 'Mar',
      'year': '2026',
      'section': 'C',
      'course': 'Science',
    },
    {
      'name': 'Kabir Khan',
      'month': 'Feb',
      'year': '2025',
      'section': 'B',
      'course': 'Math',
    },
  ];

  // final List<Map<String, String>> _examResults = const [
  //   {
  //     'name': 'Aarav Sharma',
  //     'score': '92%',
  //     'year': '2026',
  //     'section': 'A',
  //     'course': 'Science',
  //   },
  //   {
  //     'name': 'Anaya Patel',
  //     'score': '88%',
  //     'year': '2026',
  //     'section': 'B',
  //     'course': 'Commerce',
  //   },
  //   {
  //     'name': 'Rohan Verma',
  //     'score': '85%',
  //     'year': '2025',
  //     'section': 'A',
  //     'course': 'Math',
  //   },
  //   {
  //     'name': 'Meera Singh',
  //     'score': '94%',
  //     'year': '2026',
  //     'section': 'C',
  //     'course': 'Science',
  //   },
  //   {
  //     'name': 'Kabir Khan',
  //     'score': '81%',
  //     'year': '2025',
  //     'section': 'B',
  //     'course': 'Math',
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 900;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (compact) ...[
                  _heroCard(context),
                  const Gap(16),
                  SimpleUseExample(),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _heroCard(context)),
                      const Gap(16),
                      Expanded(child: SimpleUseExample()),
                    ],
                  ),
                const Gap(16),
                _statsGrid(context),
                const Gap(16),
                _responsiveSections(context),
                const Gap(16),
                if (compact) ...[
                  _todayTasksCard(context),
                  const Gap(16),
                  _activityCard(context),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _todayTasksCard(context)),
                      const Gap(16),
                      Expanded(child: _activityCard(context)),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Map<String, String>> get _filteredStudents {
    return _students.where((student) {
      final monthMatch =
          _studentMonth == 'All Months' || student['month'] == _studentMonth;
      final yearMatch =
          _studentYear == 'All Years' || student['year'] == _studentYear;
      final sectionMatch =
          _studentSection == 'All Sections' ||
          student['section'] == _studentSection;
      final courseMatch =
          _studentCourse == 'All Courses' ||
          student['course'] == _studentCourse;
      return monthMatch && yearMatch && sectionMatch && courseMatch;
    }).toList();
  }

  // List<Map<String, String>> get _filteredExamResults {
  //   return _examResults.where((result) {
  //     final yearMatch = result['year'] == _examYear;
  //     final sectionMatch = result['section'] == _examSection;
  //     final courseMatch = result['course'] == _examCourse;
  //     return yearMatch && sectionMatch && courseMatch;
  //   }).toList();
  // }

  Widget _inlineCalender(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [SimpleUseExample()],
      ),
    );
  }

  Widget _heroCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.secondary, colors.background],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back, Priyanshu',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const Gap(8),
            Text(
              'Track team activity, monitor KPIs, and keep your delivery pipeline healthy.',
              style: TextStyle(color: colors.foreground),
            ),
            const Gap(16),
            Row(
              children: [
                PrimaryButton(
                  onPressed: () {},
                  child: const Text('Create Project'),
                ),
                const Gap(10),
                OutlineButton(
                  onPressed: () {},
                  child: const Text('View Reports'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _responsiveSections(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = ResponsiveBuilder.isDesktop(context);
        final isTablet = ResponsiveBuilder.isTablet(context);
        final crossAxisCount = (isDesktop || isTablet) ? 2 : 1;
        final ratio = crossAxisCount == 2 ? 1.35 : 1.1;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: ratio,
          children: [
            _studentsListCard(context),
            // _examResultsCard(context),
            _noticeBoardCard(context),
          ],
        );
      },
    );
  }

  Widget _studentsListCard(BuildContext context) {
    final students = [..._filteredStudents];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Student List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Gap(10),
            Row(
              children: [
                Text(
                  'Selected: ${_selectedStudentRows.length}',
                  style: TextStyle(fontSize: 12, color: Colors.gray),
                ),
                const Spacer(),
                OutlineButton(
                  density: ButtonDensity.compact,
                  onPressed: () {
                    setState(
                      () => _showStudentCheckbox = !_showStudentCheckbox,
                    );
                  },
                  child: Text(
                    _showStudentCheckbox ? 'Hide Checkbox' : 'Show Checkbox',
                  ),
                ),
              ],
            ),
            const Gap(10),
            Expanded(
              child: students.isEmpty
                  ? const Center(
                      child: Text('No students for selected filters.'),
                    )
                  : GenericTableWidget<Map<String, String>>(
                      rows: students,
                      // height: 250,
                      selectionMode: GenericTableSelectionMode.multiple,
                      showCheckboxColumn: _showStudentCheckbox,
                      selectedRowIds: _selectedStudentRows,
                      onSelectedRowIdsChanged: (selected) {
                        debugPrint("selected row: $selected");
                        debugPrint(
                          "_selectedStudentRows: $_selectedStudentRows",
                        );
                        setState(
                          () =>
                              _selectedStudentRows = Set<String>.from(selected),
                        );
                      },
                      rowIdBuilder: (row) => row['name'] ?? '',
                      pinnedColumnIds: const {'name', 'section'},
                      pinnedRowIds: const {'Aarav Sharma'},
                      defaultColumnWidth: const FixedTableSize(150),
                      columns: [
                        GenericTableColumn<Map<String, String>>(
                          id: 'name',
                          title: 'Name',
                          width: const FixedTableSize(170),
                          cellDataBuilder: (row) =>
                              GenericTableCellData.text(row['name'] ?? '-'),
                        ),
                        GenericTableColumn<Map<String, String>>(
                          id: 'section',
                          title: 'Section',
                          width: const FixedTableSize(110),
                          cellDataBuilder: (row) =>
                              GenericTableCellData.chip(row['section'] ?? '-'),
                        ),
                        GenericTableColumn<Map<String, String>>(
                          id: 'course',
                          title: 'Course',
                          width: const FixedTableSize(140),
                          cellDataBuilder: (row) => GenericTableCellData.status(
                            row['course'] ?? '-',
                            tone: GenericTableStatusTone.neutral,
                          ),
                        ),
                        GenericTableColumn<Map<String, String>>(
                          id: 'session',
                          title: 'Session',
                          width: const FixedTableSize(130),
                          cellDataBuilder: (row) => GenericTableCellData.text(
                            '${row['month'] ?? ''} ${row['year'] ?? ''}',
                          ),
                        ),
                        GenericTableColumn<Map<String, String>>(
                          id: 'profile',
                          title: 'Profile',
                          width: const FixedTableSize(110),
                          alignment: Alignment.center,
                          cellDataBuilder: (row) => GenericTableCellData.link(
                            'View',
                            onPressed: () {},
                          ),
                        ),
                        GenericTableColumn<Map<String, String>>(
                          id: 'action',
                          title: 'Action',
                          width: const FixedTableSize(130),
                          alignment: Alignment.center,
                          cellDataBuilder: (row) => GenericTableCellData.action(
                            'Message',
                            icon: Icons.send,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _examResultsCard(BuildContext context) {
  //   final results = _filteredExamResults;
  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               const Expanded(
  //                 child: Text(
  //                   'All Exam Results',
  //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
  //                 ),
  //               ),
  //               OutlineButton(
  //                 density: ButtonDensity.compact,
  //                 onPressed: () {
  //                   showDropdown(
  //                     context: context,
  //                     builder: (context) {
  //                       return DropdownMenu(
  //                         children: [
  //                           ...['2026', '2025'].map(
  //                             (value) => MenuButton(
  //                               child: Text('Year: $value'),
  //                               onPressed: (_) =>
  //                                   setState(() => _examYear = value),
  //                             ),
  //                           ),
  //                           const MenuDivider(),
  //                           ...['A', 'B', 'C'].map(
  //                             (value) => MenuButton(
  //                               child: Text('Section: $value'),
  //                               onPressed: (_) =>
  //                                   setState(() => _examSection = value),
  //                             ),
  //                           ),
  //                           const MenuDivider(),
  //                           ...['Science', 'Commerce', 'Math'].map(
  //                             (value) => MenuButton(
  //                               child: Text('Course: $value'),
  //                               onPressed: (_) =>
  //                                   setState(() => _examCourse = value),
  //                             ),
  //                           ),
  //                         ],
  //                       );
  //                     },
  //                   );
  //                 },
  //                 child: const Row(
  //                   children: [
  //                     Icon(Icons.tune, size: 16),
  //                     Gap(6),
  //                     Text('Filters'),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const Gap(8),
  //           Text(
  //             '$_examYear • Section $_examSection • $_examCourse',
  //             style: TextStyle(fontSize: 12, color: Colors.gray),
  //           ),
  //           const Gap(10),
  //           Row(
  //             children: [
  //               Text(
  //                 'Selected: ${_selectedExamRows.length}',
  //                 style: TextStyle(fontSize: 12, color: Colors.gray),
  //               ),
  //               const Spacer(),
  //               OutlineButton(
  //                 density: ButtonDensity.compact,
  //                 onPressed: () {
  //                   setState(() => _showExamCheckbox = !_showExamCheckbox);
  //                 },
  //                 child: Text(
  //                   _showExamCheckbox ? 'Hide Checkbox' : 'Show Checkbox',
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const Gap(10),
  //           Expanded(
  //             child: results.isEmpty
  //                 ? const Center(
  //                     child: Text('No results for selected filters.'),
  //                   )
  //                 : GenericTableWidget<Map<String, String>>(
  //                     rows: results,
  //                     height: 240,
  //                     selectionMode: GenericTableSelectionMode.single,
  //                     showCheckboxColumn: _showExamCheckbox,
  //                     selectedRowIds: _selectedExamRows,
  //                     onSelectedRowIdsChanged: (selected) {
  //                       setState(
  //                         () => _selectedExamRows = Set<String>.from(selected),
  //                       );
  //                     },
  //                     rowIdBuilder: (row) => row['name'] ?? '',
  //                     pinnedColumnIds: const {'name'},
  //                     pinnedRowIds: const {'Meera Singh'},
  //                     defaultColumnWidth: const FixedTableSize(140),
  //                     columns: [
  //                       GenericTableColumn<Map<String, String>>(
  //                         id: 'name',
  //                         title: 'Student',
  //                         width: const FixedTableSize(170),
  //                         cellDataBuilder: (row) =>
  //                             GenericTableCellData.text(row['name'] ?? '-'),
  //                       ),
  //                       GenericTableColumn<Map<String, String>>(
  //                         id: 'score',
  //                         title: 'Score',
  //                         width: const FixedTableSize(120),
  //                         cellDataBuilder: (row) => GenericTableCellData.status(
  //                           row['score'] ?? '-',
  //                           tone: _scoreTone(row['score'] ?? ''),
  //                         ),
  //                       ),
  //                       GenericTableColumn<Map<String, String>>(
  //                         id: 'section',
  //                         title: 'Section',
  //                         width: const FixedTableSize(100),
  //                         cellDataBuilder: (row) =>
  //                             GenericTableCellData.chip(row['section'] ?? '-'),
  //                       ),
  //                       GenericTableColumn<Map<String, String>>(
  //                         id: 'course',
  //                         title: 'Course',
  //                         width: const FixedTableSize(130),
  //                         cellDataBuilder: (row) =>
  //                             GenericTableCellData.text(row['course'] ?? '-'),
  //                       ),
  //                       GenericTableColumn<Map<String, String>>(
  //                         id: 'report',
  //                         title: 'Report',
  //                         width: const FixedTableSize(110),
  //                         alignment: Alignment.center,
  //                         cellDataBuilder: (row) => GenericTableCellData.link(
  //                           'Open',
  //                           onPressed: () {},
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  GenericTableStatusTone _scoreTone(String score) {
    final value = int.tryParse(score.replaceAll('%', '')) ?? 0;
    if (value >= 90) {
      return GenericTableStatusTone.success;
    }
    if (value >= 80) {
      return GenericTableStatusTone.warning;
    }
    return GenericTableStatusTone.danger;
  }

  Widget _noticeBoardCard(BuildContext context) {
    final notices = <(String, String)>[
      ('Parent-teacher meeting on Saturday', '08:00 AM'),
      ('Mid-term exam schedule released', 'Yesterday'),
      ('Science fair registrations open', '2 days ago'),
      ('Library will close early on Friday', '3 days ago'),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notice Board',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Gap(10),
            Expanded(
              child: ListView.separated(
                itemCount: notices.length,
                separatorBuilder: (_, _) => const Divider(),
                itemBuilder: (context, index) {
                  final item = notices[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.push_pin, size: 16),
                      const Gap(8),
                      Expanded(child: Text(item.$1)),
                      Text(
                        item.$2,
                        style: TextStyle(fontSize: 12, color: Colors.gray),
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

  Widget _filterDropdownButton({
    required BuildContext context,
    required String label,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    return OutlineButton(
      density: ButtonDensity.compact,
      onPressed: () {
        showDropdown(
          context: context,
          builder: (context) {
            return DropdownMenu(
              children: options
                  .map(
                    (option) => MenuButton(
                      child: Text(option),
                      onPressed: (_) => onSelected(option),
                    ),
                  )
                  .toList(),
            );
          },
        );
      },
      child: Row(
        children: [
          Text(label),
          const Gap(4),
          const Icon(Icons.keyboard_arrow_down, size: 16),
        ],
      ),
    );
  }

  Widget _statsGrid(BuildContext context) {
    final cards = <Widget>[
      _statCard(
        title: 'Students',
        value: '1,284',
        change: '+8.1%',
        icon: Icons.school,
      ),
      _statCard(
        title: 'Teachers',
        value: '86',
        change: '+2.4%',
        icon: Icons.cast_for_education,
      ),
      _statCard(
        title: 'Parents',
        value: '2,430',
        change: '+4.2%',
        icon: Icons.groups,
      ),
      _statCard(
        title: 'Staff',
        value: '54',
        change: '-1.1%',
        icon: Icons.badge,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isDesktop = ResponsiveBuilder.isDesktop(context);
        final isTablet = ResponsiveBuilder.isTablet(context);

        final crossAxisCount = isDesktop
            ? 4
            : isTablet
            ? (width < 900 ? 2 : 4)
            : 2;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.8,
          children: cards,
        );
      },
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PrimaryBadge(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(icon, size: 16),
                  ),
                ),
                const Spacer(),
                Text(
                  change,
                  style: TextStyle(
                    color: change.startsWith('-')
                        ? Colors.red
                        : Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Gap(10),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const Gap(4),
            Text(title, style: TextStyle(fontSize: 13, color: Colors.gray)),
          ],
        ),
      ),
    );
  }

  Widget _todayTasksCard(BuildContext context) {
    final tasks = <String>[
      'Finalize onboarding flow copy',
      'Review sprint backlog with dev team',
      'Approve Q1 campaign budget',
      'Refine analytics dashboard filters',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today Tasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Gap(12),
            ...tasks.map(
              (task) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 18),
                    const Gap(8),
                    Expanded(child: Text(task)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityCard(BuildContext context) {
    final activity = <(String, String)>[
      ('Aman pushed 4 commits', '10m ago'),
      ('New invoice paid by Acme Inc', '42m ago'),
      ('Design review moved to 3:00 PM', '1h ago'),
      ('Support ticket #248 closed', '2h ago'),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Gap(12),
            ...activity.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, size: 16),
                    const Gap(8),
                    Expanded(child: Text(item.$1)),
                    Text(
                      item.$2,
                      style: TextStyle(fontSize: 12, color: Colors.gray),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
