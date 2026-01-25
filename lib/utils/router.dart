
import 'package:go_router/go_router.dart';
import '../screens/exercice_result_screen.dart';
import '../screens/home_screen.dart';
import '../screens/select_grade_screen.dart';
import '../screens/select_subject_screen.dart';
import '../screens/select_topic_screen.dart';

import '../screens/splash_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/select-subject',
      builder: (context, state) => const SelectSubjectScreen(),
    ),
    GoRoute(
      path: '/select-grade',
      builder: (context, state) => const SelectGradeScreen(),
    ),
    GoRoute(
      path: '/select-topic',
      builder: (context, state) => const SelectTopicScreen(),
    ),
    GoRoute(
  path: '/exercise-result',
  builder: (context, state) {
    // Retrieve the extra data passed from SelectTopicScreen
    final data = state.extra as Map<String, String>; 
    return ExerciseResultScreen(data: data);
  },
),
  ],
);
