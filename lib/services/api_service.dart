import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  static final _apiKey = dotenv.env['DEEPSEEK_API_KEY'];
  static const String _apiUrl = "https://api.deepseek.com/chat/completions";
  static const Duration _timeout = Duration(seconds: 40);
  

  Future<Map<String, String>> generateExercise({
    required String subject,
    required String grade,
    required List<String> topics,
  }) async {
    final prompt =
        """
      Create a $subject exercise for $grade level students.
      The topics are: ${topics.join(', ')}.
      
      You must respond in strict JSON format with exactly two keys:
      1. "exercise": The question or problem statement.
      2. "correction": The step-by-step solution or final answer.
      
      Do not add markdown formatting (like ```json). Just the raw JSON.
    """;

    return _generateAndParse(prompt);
  }

  Future<Map<String, String>> generateExam({
    required String subject,
    required String grade,
    required List<String> topics,
  }) async {
    final prompt =
        """
      Create a comprehensive, formal $subject Exam for $grade students.
      The exam must cover these topics: ${topics.join(', ')}.
      
      Structure the exam professionally with:
      1. A Header (Subject, Grade, Duration: 60 mins, Total Marks: 20).
      2. Three Sections:
         - Section A: Multiple Choice Questions (MCQ).
         - Section B: Short Answer Questions.
         - Section C: Problem Solving / Essay.
      
      You must respond in strict JSON format with exactly two keys:
      1. "exercise": The full exam paper content (Question sheet).
      2. "correction": The marking scheme and answers (Teacher's key).
      
      Do not add markdown formatting. Just raw JSON.
    """;

    return _generateAndParse(prompt);
  }

  // Sends the prompt and parses the JSON response into a Map
  Future<Map<String, String>> _generateAndParse(String prompt) async {
    try {
      // 1. Send request
      final jsonString = await sendMessage(prompt);

      // 2. Clean up the response (DeepSeek sometimes adds Markdown blocks)
      final cleanJson = jsonString
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      // 3. Parse JSON
      final Map<String, dynamic> parsedData = jsonDecode(cleanJson);

      return {
        'exercise':
            parsedData['exercise']?.toString() ?? 'Error parsing exercise',
        'correction':
            parsedData['correction']?.toString() ?? 'Error parsing correction',
      };
    } catch (e) {
      debugPrint("Parsing Error: $e");
      // Fallback if AI fails to return valid JSON
      return {
        'exercise': "Could not generate content properly.",
        'correction': "Error details: $e\n\nRaw Response was maybe not JSON.",
      };
    }
  }

  Future<String> sendMessage(String userMessage) async {
    try {
      debugPrint('>>> Sending to DeepSeek...');

      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {
              "Authorization": "Bearer $_apiKey",
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "model": "deepseek-chat",
              "messages": [
                // System role helps define the AI's behavior
                {
                  "role": "system",
                  "content":
                      "You are a helpful AI Teacher assistant. You generate clear academic exercises and solutions.",
                },
                {"role": "user", "content": userMessage},
              ],
              "temperature": 0.7,
              "max_tokens": 1500,
              // "response_format": {"type": "json_object"}, // Enable if DeepSeek supports this flag specifically, otherwise prompt is enough
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(
          utf8.decode(response.bodyBytes),
        ); // utf8.decode ensures special characters (accents) work

        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'] ?? '';
        }
        throw ApiException('Invalid Response', 'No content in response');
      } else {
        throw ApiException('API Error ${response.statusCode}', response.body);
      }
    } on TimeoutException {
      throw ApiException('Timeout', 'The server took too long to respond.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network Error', e.toString());
    }
  }
}

class ApiException implements Exception {
  final String title;
  final String message;

  ApiException(this.title, this.message);

  @override
  String toString() => '$title: $message';
}
