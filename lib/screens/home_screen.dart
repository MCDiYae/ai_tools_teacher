import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/exercise_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle:
            true, 
        title: const Text('AI Teacher Helper'),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          20.0,
        ), // Increased padding for cleaner look
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),

            Text(
              'Create & Manage \n Exams and Exercises',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Slight override if needed
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 50),

            // Button 1: Create Exams
            ElevatedButton(
              onPressed: () {
                // 1. Set Mode to TRUE (Exam)
                context.read<ExerciseProvider>().setExamMode(true);
                context.read<ExerciseProvider>().clearData(); // Clean old data
                // 2. Go to flow
                context.push('/select-subject');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
              ),
              child: const Text('Create Exams'),
            ),

            const SizedBox(height: 20),

            // Button 2: Create Exercises
            ElevatedButton(
              onPressed: () {
                // 1. Set Mode to FALSE (Exercise)
                context.read<ExerciseProvider>().setExamMode(false);
                context.read<ExerciseProvider>().clearData();
                // 2. Go to flow
                context.push('/select-subject');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
              ),
              child: const Text('Create Exercises'),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
