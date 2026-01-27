import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../provider/exercise_provider.dart';
import '../utils/app_constants.dart';
import '../widgets/selection_card.dart';
import '../services/api_service.dart';

class SelectTopicScreen extends StatefulWidget {
  const SelectTopicScreen({super.key});

  @override
  State<SelectTopicScreen> createState() => _SelectTopicScreenState();
}

class _SelectTopicScreenState extends State<SelectTopicScreen> {
  bool _isLoading = false; // To show loading spinner during API call

  @override
  Widget build(BuildContext context) {
    // 1. Get the subject selected in the previous screen
    final provider = context.watch<ExerciseProvider>();
    final currentSubject = provider.subject;

    // 2. Get the list of topics for this subject
    final List<String> availableTopics =
        AppConstants.topicData[currentSubject] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('$currentSubject Topics'), // Dynamic Title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Instruction Text
            const Text(
              "Select one or more topics to include in the exercise.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 10),

            // 3. The List of Topics
            Expanded(
              child: availableTopics.isEmpty
                  ? const Center(
                      child: Text("No topics found for this subject"),
                    )
                  : ListView.builder(
                      itemCount: availableTopics.length,
                      itemBuilder: (context, index) {
                        final topic = availableTopics[index];
                        final isSelected = provider.selectedTopics.contains(
                          topic,
                        );

                        return SelectionCard(
                          title: topic,
                          isSelected: isSelected,
                          showCheckmark:
                              true, // Shows the green checkmark style
                          onTap: () {
                            // Toggle selection in Provider
                            context.read<ExerciseProvider>().toggleTopic(topic);
                          },
                        );
                      },
                    ),
            ),

            const SizedBox(height: 16),

            // 4. Generate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (provider.selectedTopics.isEmpty || _isLoading)
                    ? null // Disable if no topic selected or currently loading
                    : () => _generateExercise(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isLoading
                      ? Colors.grey
                      : null, // Visual feedback
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Generate Exercise'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateExercise(BuildContext context) async {
    setState(() => _isLoading = true);

    final provider = context.read<ExerciseProvider>();
    final apiService = ApiService();

    try {
      Map<String, String> result;

      // ---------------------------------------------------------
      // THE LOGIC SWITCH
      // ---------------------------------------------------------
      if (provider.isExamMode) {
        // Case A: User clicked "Create Exam"
        print("Generating Exam...");
        result = await apiService.generateExam(
          subject: provider.subject!,
          grade: provider.grade ?? "Grade 1",
          topics: provider.selectedTopics,
        );
      } else {
        // Case B: User clicked "Create Exercise"
        print("Generating Exercise...");
        result = await apiService.generateExercise(
          subject: provider.subject!,
          grade: provider.grade ?? "Grade 1",
          topics: provider.selectedTopics,
        );
      }
      // ---------------------------------------------------------

      if (!mounted) return;

      // Send the result to the Result Screen
      context.push('/exercise-result', extra: result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
