import 'dart:io';

class ScanResult {
  final File? image;
  final String extractedText;
  final String aiResponse;
  final DateTime timestamp;
  final ScanResultStatus status;

  ScanResult({
    this.image,
    required this.extractedText,
    required this.aiResponse,
    required this.timestamp,
    required this.status,
  });

  ScanResult copyWith({
    File? image,
    String? extractedText,
    String? aiResponse,
    DateTime? timestamp,
    ScanResultStatus? status,
  }) {
    return ScanResult(
      image: image ?? this.image,
      extractedText: extractedText ?? this.extractedText,
      aiResponse: aiResponse ?? this.aiResponse,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'extractedText': extractedText,
      'aiResponse': aiResponse,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
    };
  }

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      extractedText: json['extractedText'] ?? '',
      aiResponse: json['aiResponse'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      status: ScanResultStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ScanResultStatus.completed,
      ),
    );
  }
}

enum ScanResultStatus {
  processing,
  completed,
  error,
}