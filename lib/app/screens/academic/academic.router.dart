import 'package:go_router/go_router.dart';

import 'academic_screen.dart';
import 'classes_screen.dart';
import 'class_room_screen.dart';
import 'students_list_screen.dart';
// import 'class_room_view_screen.dart';
// import 'class_routine_screen.dart';
// import 'subject_screen.dart';
// import 'syllabus_screen.dart';
// import 'timetable_screen.dart';
// import 'homework_screen.dart';

class AcademicRouter {
  static final List<GoRoute> routes = [
    GoRoute(
      path: '/academic',
      builder: (context, state) => const AcademicScreen(),
    ),
    GoRoute(
      path: '/academic/classes',
      builder: (context, state) => const ClassesScreen(),
    ),
    GoRoute(
      path: '/academic/class-room',
      builder: (context, state) => const ClassRoomScreen(),
    ),
    GoRoute(
      path: '/academic/students',
      builder: (context, state) => const StudentsListScreen(),
    ),
    // GoRoute(
    //   path: '/academic/class-room/:id/view',
    //   builder: (context, state) =>
    //       ClassRoomViewScreen(roomId: state.pathParameters['id'] ?? ''),
    // ),
    // GoRoute(
    //   path: '/classrooms/:id/view',
    //   builder: (context, state) =>
    //       ClassRoomViewScreen(roomId: state.pathParameters['id'] ?? ''),
    // ),
    // GoRoute(
    //   path: '/academic/class-routine',
    //   builder: (context, state) => const ClassRoutineScreen(),
    // ),
    // GoRoute(
    //   path: '/academic/subject',
    //   builder: (context, state) => const SubjectScreen(),
    // ),
    // GoRoute(
    //   path: '/academic/syllabus',
    //   builder: (context, state) => const SyllabusScreen(),
    // ),
    // GoRoute(
    //   path: '/academic/timetable',
    //   builder: (context, state) => const TimetableScreen(),
    // ),
    // GoRoute(
    //   path: '/academic/homework',
    //   builder: (context, state) => const HomeworkScreen(),
    // ),
  ];
}
