import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/foundation.dart';

class OcrService {
  final TextRecognizer _textRecognizer;

  OcrService() : _textRecognizer = TextRecognizer();

  Future<String> extractTextFromImage(File imageFile) async {
    try {
      debugPrint('>>> Starting OCR for: ${imageFile.path}');
      
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      final extractedText = recognizedText.text;
      debugPrint('<<< OCR completed. Text length: ${extractedText.length}');
      
      if (extractedText.isEmpty) {
        throw OcrException('No text found in the image');
      }
      
      return extractedText;
    } catch (e) {
      debugPrint('OCR Error: $e');
      if (e is OcrException) rethrow;
      throw OcrException('Failed to extract text: ${e.toString()}');
    }
  }

  Future<String> extractTextFromImageWithBlocks(File imageFile) async {
    try {
      debugPrint('>>> Starting detailed OCR for: ${imageFile.path}');
      
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      final StringBuffer buffer = StringBuffer();
      
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          buffer.writeln(line.text);
        }
        buffer.writeln(); // Add spacing between blocks
      }
      
      final extractedText = buffer.toString().trim();
      debugPrint('<<< Detailed OCR completed. Text length: ${extractedText.length}');
      
      if (extractedText.isEmpty) {
        throw OcrException('No text found in the image');
      }
      
      return extractedText;
    } catch (e) {
      debugPrint('Detailed OCR Error: $e');
      if (e is OcrException) rethrow;
      throw OcrException('Failed to extract text: ${e.toString()}');
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}

class OcrException implements Exception {
  final String message;

  OcrException(this.message);

  @override
  String toString() => 'OCR Error: $message';
}