import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/selection_card.dart';
import '../provider/exercise_provider.dart';
import '../utils/app_constants.dart';

class SelectGradeScreen extends StatefulWidget {
  const SelectGradeScreen({super.key});

  @override
  State<SelectGradeScreen> createState() => _SelectGradeScreenState();
}

class _SelectGradeScreenState extends State<SelectGradeScreen> {
  // Use the grades list from your constants
  final List<String> grades = AppConstants.grades;

  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Choose the difficulty level for the exercise.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            // List of Grades
            Expanded(
              child: ListView.builder(
                itemCount: grades.length,
                itemBuilder: (context, index) {
                  return SelectionCard(
                    title: grades[index],
                    isSelected: _selectedIndex == index,
                    showCheckmark: false, // Keep it simple centered
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      // Save to Provider
                      context.read<ExerciseProvider>().setGrade(grades[index]);
                    },
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedIndex == -1
                    ? null
                    : () {
                        // Navigate to Select Topic
                        context.push('/select-topic');
                      },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Next'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, size: 16),
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