import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/scan_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/scan_card.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Document Scanner',
          style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textGrey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<ScanProvider>(
            builder: (context, scanProvider, child) {
              return IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: scanProvider.scanResults.isNotEmpty
                    ? () => _showClearAllDialog(context, scanProvider)
                    : null,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. The Results Area (Main Content)
          Column(
            children: [
              Expanded(child: _buildResultsList()),
              const SizedBox(height: 120), // Space for the bottom panel
            ],
          ),

          // 2. The Bottom Control Panel
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildModernControlPanel(context),
          ),
          
          // 3. Processing Overlay (Floating)
          _buildFloatingProcessingIndicator(),
        ],
      ),
    );
  }

  Widget _buildModernControlPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Consumer<ScanProvider>(
        builder: (context, scanProvider, child) {
          final isProcessing = scanProvider.isProcessing;
          return Expanded(
            flex: 2,
            child: _actionButton(
              label: "Take Photo",
              icon: Icons.camera_alt_rounded,
              color: AppColors.primaryBlue,
              isPrimary: true,
              onPressed: isProcessing ? null : () => _scanFromCamera(context, scanProvider),
            ),
          );
        },
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
    bool isPrimary = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? color : Colors.grey.shade100,
        foregroundColor: isPrimary ? Colors.white : color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return Consumer<ScanProvider>(
      builder: (context, scanProvider, child) {
        final results = scanProvider.scanResults;
        if (results.isEmpty && !scanProvider.isProcessing) {
          return _buildEmptyState();
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: results.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ScanResultCard(
                scanResult: results[index],
                onRetry: () => _retryProcessing(context, scanProvider, results[index]),
                onDelete: () => _deleteScanResult(context, scanProvider, results[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFloatingProcessingIndicator() {
    return Consumer<ScanProvider>(
      builder: (context, scanProvider, child) {
        if (!scanProvider.isProcessing) return const SizedBox.shrink();
        return Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text(
                  scanProvider.currentStep,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black.withAlpha(5)),
            ),
            child: const Icon(Icons.document_scanner_outlined, size: 64, color: AppColors.textDark),
          ),
          const SizedBox(height: 24),
          const Text(
            'Ready to Scan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          const Text(
            'Take a photo of your homework\nto get instant help.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textDark),
          ),
        ],
      ),
    );
  }

  // Logic Functions (Kept same as yours but cleaned up)
  Future<void> _scanFromCamera(BuildContext context, ScanProvider scanProvider) async {
    try { await scanProvider.scanFromCamera(); } catch (e) { _showError(context, e.toString()); }
  }


  Future<void> _retryProcessing(BuildContext context, ScanProvider scanProvider, result) async {
    try { await scanProvider.retryProcessing(result); } catch (e) { _showError(context, e.toString()); }
  }

  void _deleteScanResult(BuildContext context, ScanProvider scanProvider, result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Result'),
        content: const Text('Are you sure you want to delete this scan?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () { scanProvider.deleteScanResult(result); Navigator.pop(context); },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, ScanProvider scanProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All'),
        content: const Text('Delete everything?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () { scanProvider.clearAllResults(); Navigator.pop(context); },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }
}