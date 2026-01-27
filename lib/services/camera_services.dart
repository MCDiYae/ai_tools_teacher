import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> captureFromCamera() async {
    try {
      // Check camera permission
      if (!await _checkAndRequestCameraPermission()) {
        throw CameraException('Camera permission denied');
      }

      debugPrint('>>> Capturing image from camera');
      
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image == null) {
        debugPrint('<<< Camera capture cancelled');
        return null;
      }

      final file = File(image.path);
      debugPrint('<<< Image captured: ${file.path}');
      return file;
    } catch (e) {
      debugPrint('Camera Error: $e');
      if (e is CameraException) rethrow;
      throw CameraException('Failed to capture image: ${e.toString()}');
    }
  }

  Future<File?> pickFromGallery() async {
    try {
      // Check gallery permission
      if (!await _checkAndRequestGalleryPermission()) {
        throw CameraException('Gallery permission denied');
      }

      debugPrint('>>> Picking image from gallery');
      
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) {
        debugPrint('<<< Gallery selection cancelled');
        return null;
      }

      final file = File(image.path);
      debugPrint('<<< Image selected: ${file.path}');
      return file;
    } catch (e) {
      debugPrint('Gallery Error: $e');
      if (e is CameraException) rethrow;
      throw CameraException('Failed to pick image: ${e.toString()}');
    }
  }

  Future<List<File?>> pickMultipleFromGallery() async {
    try {
      // Check gallery permission
      if (!await _checkAndRequestGalleryPermission()) {
        throw CameraException('Gallery permission denied');
      }

      debugPrint('>>> Picking multiple images from gallery');
      
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85,
        limit: 5, // Limit to 5 images
      );

      if (images.isEmpty) {
        debugPrint('<<< No images selected');
        return [];
      }

      final List<File?> files = images.map((xFile) => File(xFile.path)).toList();
      debugPrint('<<< ${files.length} images selected');
      return files;
    } catch (e) {
      debugPrint('Multiple Gallery Error: $e');
      if (e is CameraException) rethrow;
      throw CameraException('Failed to pick images: ${e.toString()}');
    }
  }

  Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  Future<bool> checkGalleryPermission() async {
    final status = await Permission.photos.status;
    return status.isGranted;
  }

  // Private helper methods for permission handling
  Future<bool> _checkAndRequestCameraPermission() async {
    // For Android only, skip iOS
    if (!Platform.isAndroid) return true;
    
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> _checkAndRequestGalleryPermission() async {
    // For Android only, skip iOS
    if (!Platform.isAndroid) return true;
    
    final status = await Permission.photos.request();
    return status.isGranted;
  }
}

class CameraException implements Exception {
  final String message;

  CameraException(this.message);

  @override
  String toString() => 'Camera Error: $message';
}