
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../provider/exercise_provider.dart';
import '../utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/router.dart';

Future main() async{
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'AI Teacher Helper',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
