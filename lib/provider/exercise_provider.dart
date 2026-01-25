import 'package:flutter/material.dart';

class ExerciseProvider extends ChangeNotifier {
  // 1. The Data we are collecting
  String? _subject;
  String? _grade;
  List<String> _selectedTopics = [];
  //exam 
  bool _isExamMode = false;

  // 2. Getters (to read the data safely)
  String? get subject => _subject;
  String? get grade => _grade;
  List<String> get selectedTopics => _selectedTopics;
  bool get isExamMode => _isExamMode;
  

  // 3. Setters (to update data and notify screens)
  void setSubject(String newSubject) {
    _subject = newSubject;
    notifyListeners(); 
  }

  void setGrade(String newGrade) {
    _grade = newGrade;
    notifyListeners();
  }
  void setExamMode(bool isExam) {
    _isExamMode = isExam;
       notifyListeners(); 
  }

  void toggleTopic(String topic) {
    if (_selectedTopics.contains(topic)) {
      _selectedTopics.remove(topic);
    } else {
      _selectedTopics.add(topic);
    }
    notifyListeners();
  }
  

  // Clear data (useful when starting over)
  void clearData() {
    _subject = null;
    _grade = null;
    _selectedTopics = [];
    notifyListeners();
  }
}