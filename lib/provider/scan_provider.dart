import 'dart:io';
import 'package:flutter/material.dart';

import '../models/scan.dart';
import '../services/api_service.dart';
import '../services/camera_services.dart';
import '../services/ocr_services.dart';

class ScanProvider extends ChangeNotifier {
  final List<ScanResult> _scanResults = [];
  final CameraService _cameraService = CameraService();
  final OcrService _ocrService = OcrService();
  final ApiService _apiService = ApiService();

  bool _isProcessing = false;
  String _currentStep = '';
  File? _currentImage;

  List<ScanResult> get scanResults => List.unmodifiable(_scanResults);
  bool get isProcessing => _isProcessing;
  String get currentStep => _currentStep;
  File? get currentImage => _currentImage;

  Future<void> scanFromCamera() async {
    try {
      _setProcessing(true, 'Opening camera...');
      
      final imageFile = await _cameraService.captureFromCamera();
      if (imageFile == null) {
        _setProcessing(false, '');
        return; // User cancelled
      }

      await _processImage(imageFile);
    } catch (e) {
      _handleError(e.toString());
    }
  }

  Future<void> scanFromGallery() async {
    try {
      _setProcessing(true, 'Opening gallery...');
      
      final imageFile = await _cameraService.pickFromGallery();
      if (imageFile == null) {
        _setProcessing(false, '');
        return; // User cancelled
      }

      await _processImage(imageFile);
    } catch (e) {
      _handleError(e.toString());
    }
  }

  Future<void> scanMultipleFromGallery() async {
    try {
      _setProcessing(true, 'Opening gallery...');
      
      final imageFiles = await _cameraService.pickMultipleFromGallery();
      if (imageFiles.isEmpty) {
        _setProcessing(false, '');
        return; // User cancelled
      }

      for (int i = 0; i < imageFiles.length; i++) {
        final imageFile = imageFiles[i];
        if (imageFile != null) {
          _setProcessing(true, 'Processing image ${i + 1}/${imageFiles.length}...');
          await _processImage(imageFile);
        }
      }
    } catch (e) {
      _handleError(e.toString());
    }
  }

  Future<void> _processImage(File imageFile) async {
    try {
      _currentImage = imageFile;
      notifyListeners();

      // Step 1: Extract text using OCR
      _setProcessing(true, 'Extracting text from image...');
      final extractedText = await _ocrService.extractTextFromImage(imageFile);

      if (extractedText.trim().isEmpty) {
        throw Exception('No text found in the image');
      }

      // Step 2: Send to AI for processing
      _setProcessing(true, 'Processing with AI...');
      final aiResponse = await _apiService.sendMessage(
        'Please analyze and summarize this text extracted from an image:\n\n$extractedText'
      );

      // Step 3: Create and store result
      final scanResult = ScanResult(
        image: imageFile,
        extractedText: extractedText,
        aiResponse: aiResponse,
        timestamp: DateTime.now(),
        status: ScanResultStatus.completed,
      );

      _scanResults.insert(0, scanResult);
      _setProcessing(false, '');
      _currentImage = null;
      

    } catch (e) {
      // Store error result
      final errorResult = ScanResult(
        image: imageFile,
        extractedText: '',
        aiResponse: 'Error: ${e.toString()}',
        timestamp: DateTime.now(),
        status: ScanResultStatus.error,
      );

      _scanResults.insert(0, errorResult);
      _handleError(e.toString());
    }
  }

  Future<void> retryProcessing(ScanResult result) async {
    if (result.image == null) return;

    try {
      // Remove the error result
      _scanResults.remove(result);
      notifyListeners();

      // Retry processing
      await _processImage(result.image!);
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void clearAllResults() {
    _scanResults.clear();
    _currentImage = null;
    notifyListeners();
  }

  void deleteScanResult(ScanResult result) {
    _scanResults.remove(result);
    notifyListeners();
  }

  void _setProcessing(bool processing, String step) {
    _isProcessing = processing;
    _currentStep = step;
    notifyListeners();
  }

  void _handleError(String error) {
    _setProcessing(false, '');
    _currentImage = null;
    // Error will be handled by the UI layer
    throw Exception(error);
  }

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }
}