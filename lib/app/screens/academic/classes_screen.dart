import 'package:shadcn_flutter/shadcn_flutter.dart';

import '/core/layouts/main_layout.dart';
import '/core/layouts/widgets/page_header.dart';
import '/core/widgets/generic_table_widget.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ClassesView();
  }
}

class _ClassesView extends StatefulWidget {
  const _ClassesView();

  @override
  State<_ClassesView> createState() => _ClassesViewState();
}

class _ClassesViewState extends State<_ClassesView> {
  late final List<_ClassItem> _allClasses;
  late int _classSequence;
  Set<String> _selectedIds = <String>{};

  @override
  void initState() {
    super.initState();
    _allClasses = _seedClasses();
    _classSequence = _allClasses.length + 1;
  }

  List<_ClassItem> _seedClasses() {
    final sections = ['A', 'B', 'C', 'D'];
    final courses = ['Science', 'Math', 'English', 'History'];
    return List.generate(30, (index) {
      final id = index + 1;
      return _ClassItem(
        id: 'CLS-${id.toString().padLeft(3, '0')}',
        name: 'Class $id',
        section: sections[index % sections.length],
        teacher: 'Teacher ${index + 1}',
        course: courses[index % courses.length],
        students: 20 + (index % 16),
        status: index % 5 == 0 ? 'Inactive' : 'Active',
      );
    });
  }

  void _addClass() {
    final sections = ['A', 'B', 'C', 'D'];
    final courses = ['Science', 'Math', 'English', 'History'];
    final item = _ClassItem(
      id: 'CLS-${_classSequence.toString().padLeft(3, '0')}',
      name: 'Class $_classSequence',
      section: sections[_classSequence % sections.length],
      teacher: 'Teacher $_classSequence',
      course: courses[_classSequence % courses.length],
      students: 18 + (_classSequence % 20),
      status: _classSequence % 3 == 0 ? 'Inactive' : 'Active',
    );

    setState(() {
      _allClasses.insert(0, item);
      _classSequence += 1;
    });
  }

  List<GenericTableColumn<_ClassItem>> _columns() {
    return [
      GenericTableColumn<_ClassItem>(
        id: 'class',
        title: 'Class',
        size: GenericColumnSize.l,
        minWidth: 120,
        maxWidth: 260,
        sortValueBuilder: (row) => row.name,
        textValueBuilder: (row) => row.name,
        cellDataBuilder: (row) => GenericTableCellData.text(row.name),
      ),
      GenericTableColumn<_ClassItem>(
        id: 'section',
        title: 'Section',
        size: GenericColumnSize.s,
        minWidth: 90,
        maxWidth: 160,
        sortValueBuilder: (row) => row.section,
        textValueBuilder: (row) => row.section,
        cellDataBuilder: (row) => GenericTableCellData.chip(row.section),
      ),
      GenericTableColumn<_ClassItem>(
        id: 'course',
        title: 'Course',
        size: GenericColumnSize.m,
        minWidth: 110,
        maxWidth: 220,
        sortValueBuilder: (row) => row.course,
        textValueBuilder: (row) => row.course,
        cellDataBuilder: (row) => GenericTableCellData.text(row.course),
      ),
      GenericTableColumn<_ClassItem>(
        id: 'teacher',
        title: 'Teacher',
        size: GenericColumnSize.l,
        minWidth: 130,
        maxWidth: 300,
        sortValueBuilder: (row) => row.teacher,
        textValueBuilder: (row) => row.teacher,
        cellDataBuilder: (row) => GenericTableCellData.text(row.teacher),
      ),
      GenericTableColumn<_ClassItem>(
        id: 'students',
        title: 'Students',
        size: GenericColumnSize.s,
        minWidth: 90,
        maxWidth: 150,
        alignment: Alignment.center,
        sortValueBuilder: (row) => row.students,
        textValueBuilder: (row) => '${row.students}',
        cellDataBuilder: (row) => GenericTableCellData.text('${row.students}'),
      ),
      GenericTableColumn<_ClassItem>(
        id: 'status',
        title: 'Status',
        size: GenericColumnSize.s,
        minWidth: 100,
        maxWidth: 170,
        sortValueBuilder: (row) => row.status,
        textValueBuilder: (row) => row.status,
        cellDataBuilder: (row) => GenericTableCellData.status(
          row.status,
          tone: row.status == 'Active'
              ? GenericTableStatusTone.success
              : GenericTableStatusTone.warning,
        ),
      ),
      GenericTableColumn<_ClassItem>(
        id: 'action',
        title: 'Action',
        size: GenericColumnSize.s,
        minWidth: 120,
        maxWidth: 170,
        alignment: Alignment.center,
        sortable: false,
        cellBuilder: (context, row) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.visibility_outlined, size: 16),
              Gap(8),
              Icon(Icons.edit_outlined, size: 16),
              Gap(8),
              Icon(Icons.delete_outline, size: 16),
            ],
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Classes',
      desktop: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: PageHeader(
                    title: 'Classes',
                    subTitle:
                        'Manage classes, sections, teachers and enrollment with searchable, sortable table view.',
                  ),
                ),
                const Gap(12),
                PrimaryButton(
                  onPressed: _addClass,
                  child: const Row(
                    children: [
                      Icon(Icons.add, size: 16),
                      Gap(8),
                      Text('Add Class'),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Selected classes: ${_selectedIds.length}').small.medium,
                  const Gap(8),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return GenericTableWidget<_ClassItem>(
                          rows: _allClasses,
                          columns: _columns(),
                          rowIdBuilder: (row) => row.id,
                          selectionMode: GenericTableSelectionMode.multiple,
                          selectedRowIds: _selectedIds,
                          onSelectedRowIdsChanged: (ids) {
                            setState(() => _selectedIds = Set<String>.from(ids));
                          },
                          showCheckboxColumn: true,
                          enableSorting: true,
                          enableQuickSearch: true,
                          quickSearchHint: 'Search classes, section, teacher...',
                          enablePagination: true,
                          rowsPerPage: 10,
                          availableRowsPerPage: const [10, 15, 20, 30, 40, 50],
                          height: constraints.maxHeight,
                          minWidth: 0,
                          pinnedColumnIds: const {'class'},
                        );
                      },
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
}

class _ClassItem {
  const _ClassItem({
    required this.id,
    required this.name,
    required this.section,
    required this.teacher,
    required this.course,
    required this.students,
    required this.status,
  });

  final String id;
  final String name;
  final String section;
  final String teacher;
  final String course;
  final int students;
  final String status;
}
