import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For copy to clipboard
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../provider/exercise_provider.dart';
import '../utils/app_theme.dart';

class ExerciseResultScreen extends StatelessWidget {
  final Map<String, String> data;

  const ExerciseResultScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isExam = context.read<ExerciseProvider>().isExamMode;
    final String contentLabel = isExam ? "Exam" : "Exercise";
    final String titleLabel = isExam ? "Generated Exam" : "Generated Exercise";
    return DefaultTabController(
      length: 2, // Two tabs: Exercise and Correction
      child: Scaffold(
        appBar: AppBar(
          title:  Text(titleLabel),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: const Icon(Icons.assignment), text: contentLabel),
              const Tab(icon: Icon(Icons.check_circle), text: "Solution"),
            ],
          ),
          actions: [
            // Home Button
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                context.read<ExerciseProvider>().clearData();
                context.go('/home'); // Navigate to home
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Tab 1: The Question
            _buildContentCard(context, contentLabel, data['exercise']!),

            // Tab 2: The Correction
            _buildContentCard(context, "Correction", data['correction']!),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(BuildContext context, String title, String content) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row with Copy Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.grey),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: content));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard!')),
                  );
                },
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
          
          // The Main AI Text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                height: 1.6, // Good line height for reading
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // "Regenerate" button helper (only visible on Exercise tab)
          if (title == "Correction")
            Center(
              child: TextButton.icon(
                onPressed: () => context.pop(), // Go back to regenerate
                icon: const Icon(Icons.refresh),
                label: const Text("Not satisfied? Go back to regenerate"),
              ),
            ),
        ],
      ),
    );
  }
}