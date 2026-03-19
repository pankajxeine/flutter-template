import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '/core/layouts/main_layout.dart';
import '/core/layouts/widgets/page_header.dart';
import 'blocs/academic/academic_cubit.dart';

class AcademicScreen extends StatelessWidget {
  const AcademicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AcademicCubit()..loadData(),
      child: const _AcademicView(),
    );
  }
}

class _AcademicView extends StatefulWidget {
  const _AcademicView();

  @override
  State<_AcademicView> createState() => _AcademicViewState();
}

class _AcademicViewState extends State<_AcademicView> {
  late final List<_AcademicClassRow> _rows;
  late final List<_AcademicStat> _stats;
  late final List<_AcademicQuickUpdate> _updates;

  @override
  void initState() {
    super.initState();
    _rows = List.generate(18, (index) {
      final id = index + 1;
      return _AcademicClassRow(
        id: 'AC-$id',
        className: 'Class $id',
        section: ['A', 'B', 'C'][index % 3],
        course: ['Science', 'Math', 'English', 'History'][index % 4],
        teacher: 'Teacher $id',
        students: 20 + (index % 12),
        status: index % 5 == 0 ? 'Inactive' : 'Active',
      );
    });

    _stats = const [
      _AcademicStat(
        title: 'Academic Classes',
        value: '42',
        delta: '+4 this month',
        icon: Icons.class_,
      ),
      _AcademicStat(
        title: 'Classrooms',
        value: '58',
        delta: '6 available now',
        icon: Icons.meeting_room,
      ),
      _AcademicStat(
        title: 'Subjects',
        value: '124',
        delta: '+9 updated',
        icon: Icons.menu_book,
      ),
      _AcademicStat(
        title: 'Sessions',
        value: '2026-27',
        delta: 'Term 2 active',
        icon: Icons.calendar_month,
      ),
      _AcademicStat(
        title: 'Syllabus Modules',
        value: '318',
        delta: '86% completed',
        icon: Icons.library_books,
      ),
      _AcademicStat(
        title: 'Timetable Slots',
        value: '910',
        delta: '12 conflicts',
        icon: Icons.schedule,
      ),
      _AcademicStat(
        title: 'Students',
        value: '2,684',
        delta: '+132 enrolled',
        icon: Icons.school,
      ),
      _AcademicStat(
        title: 'Teachers',
        value: '164',
        delta: '94% attendance',
        icon: Icons.cast_for_education,
      ),
      _AcademicStat(
        title: 'Staffs',
        value: '73',
        delta: 'All shifts staffed',
        icon: Icons.badge,
      ),
    ];

    _updates = const [
      _AcademicQuickUpdate(
        title: 'Class 10-B timetable revised',
        subtitle: 'Physics and Lab periods swapped for Friday.',
        time: '10 min ago',
        level: _UpdateLevel.info,
      ),
      _AcademicQuickUpdate(
        title: 'New syllabus uploaded',
        subtitle: 'Mathematics Unit-5 material published.',
        time: '35 min ago',
        level: _UpdateLevel.success,
      ),
      _AcademicQuickUpdate(
        title: 'Teacher substitution required',
        subtitle: 'English faculty leave request approved for today.',
        time: '1 hr ago',
        level: _UpdateLevel.warning,
      ),
      _AcademicQuickUpdate(
        title: 'Session registration closes soon',
        subtitle: 'Close remaining registration by 5:00 PM.',
        time: '2 hrs ago',
        level: _UpdateLevel.danger,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Academic',
      desktop: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Academic Command Center',
              subTitle:
                  'Monitor classes, classroom readiness, syllabus progress, timetable and resources in one place.',
            ),
            const Gap(12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _statsSection(context),
                    const Gap(14),
                    _contentSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statsSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1100
            ? 4
            : width >= 700
            ? 3
            : 2;
        final cardHeight = columns == 4
            ? 128.0
            : columns == 3
            ? 136.0
            : 148.0;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _stats.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: cardHeight,
          ),
          itemBuilder: (context, index) {
            return _statTile(_stats[index], compact: columns <= 2);
          },
        );
      },
    );
  }

  Widget _statTile(_AcademicStat stat, {required bool compact}) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 10 : 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    stat.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: compact ? 14 : 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  stat.value,
                  style: TextStyle(
                    fontSize: compact ? 20 : 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(4),
                Text(
                  stat.delta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.gray),
                ),
                // const VerticalDivider(),
              ],
            ),
            VerticalDivider(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlineButton(
                  density: ButtonDensity.normal,
                  shape: ButtonShape.circle,
                  onPressed: () {},
                  child: const Icon(Icons.add, size: 14),
                ),
                const Gap(6),
                OutlineButton(
                  density: ButtonDensity.normal,
                  shape: ButtonShape.circle,
                  onPressed: () {},
                  child: const Icon(LucideIcons.externalLink, size: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 1100;
        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(12),
              Expanded(flex: 2, child: _quickUpdatesCard()),
            ],
          );
        }
        return Column(children: [_quickUpdatesCard()]);
      },
    );
  }

  Widget _quickUpdatesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Academic Quick Updates',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                LinkButton(
                  density: ButtonDensity.compact,
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            const Gap(10),
            ..._updates.map((update) => _updateTile(update)),
            const Gap(10),
            const Divider(),
            const Gap(10),
            const Text(
              'Today at a Glance',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const Gap(8),
            _glanceRow('Syllabus review meeting', '11:30 AM'),
            _glanceRow('Timetable conflict resolution', '01:00 PM'),
            _glanceRow('Staff allocation sync', '03:15 PM'),
          ],
        ),
      ),
    );
  }

  Widget _updateTile(_AcademicQuickUpdate update) {
    final badge = switch (update.level) {
      _UpdateLevel.info => SecondaryBadge(child: const Text('Info')),
      _UpdateLevel.success => PrimaryBadge(child: const Text('Done')),
      _UpdateLevel.warning => OutlineBadge(child: const Text('Attention')),
      _UpdateLevel.danger => DestructiveBadge(child: const Text('Urgent')),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.gray.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    update.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                badge,
              ],
            ),
            const Gap(4),
            Text(
              update.subtitle,
              style: TextStyle(fontSize: 12, color: Colors.gray),
            ),
            const Gap(4),
            Text(
              update.time,
              style: TextStyle(fontSize: 11, color: Colors.gray),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glanceRow(String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.fiber_manual_record, size: 8),
          const Gap(8),
          Expanded(child: Text(title)),
          Text(time, style: TextStyle(fontSize: 12, color: Colors.gray)),
        ],
      ),
    );
  }
}

class _AcademicClassRow {
  const _AcademicClassRow({
    required this.id,
    required this.className,
    required this.section,
    required this.course,
    required this.teacher,
    required this.students,
    required this.status,
  });

  final String id;
  final String className;
  final String section;
  final String course;
  final String teacher;
  final int students;
  final String status;
}

class _AcademicStat {
  const _AcademicStat({
    required this.title,
    required this.value,
    required this.delta,
    required this.icon,
  });

  final String title;
  final String value;
  final String delta;
  final IconData icon;
}

class _AcademicQuickUpdate {
  const _AcademicQuickUpdate({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.level,
  });

  final String title;
  final String subtitle;
  final String time;
  final _UpdateLevel level;
}

enum _UpdateLevel { info, success, warning, danger }
