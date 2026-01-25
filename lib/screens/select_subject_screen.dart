import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../widgets/selectionCard.dart';
import '../provider/exercise_provider.dart'; // Import your Provider
import '../utils/app_constants.dart'; // Import your Constants

class SelectSubjectScreen extends StatefulWidget {
  const SelectSubjectScreen({super.key});

  @override
  State<SelectSubjectScreen> createState() => _SelectSubjectScreenState();
}

class _SelectSubjectScreenState extends State<SelectSubjectScreen> {
  final List<String> subjects = AppConstants.topicData.keys.toList();

  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Subject'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return SelectionCard(
                    title: subjects[index],
                    isSelected: _selectedIndex == index,
                    showCheckmark: false,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                                            context.read<ExerciseProvider>().setSubject(subjects[index]);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedIndex == -1
                    ? null
                    : () {
                        // Navigate to Select Grade
                        context.push('/select-grade');
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