import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/scan.dart';

class ScanResultCard extends StatelessWidget {
  final ScanResult scanResult;
  final VoidCallback? onRetry;
  final VoidCallback? onDelete;

  const ScanResultCard({
    super.key,
    required this.scanResult,
    this.onRetry,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, theme),
          if (scanResult.image != null) _buildImageSection(),
          if (scanResult.extractedText.isNotEmpty) _buildTextSection(theme),
          _buildResponseSection(theme),
          _buildActionButtons(context, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(),
            color: _getStatusColor(),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              DateFormat('MMM dd, HH:mm').format(scanResult.timestamp),
              style: theme.textTheme.titleSmall?.copyWith(
                color: _getStatusColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
              iconSize: 20,
              tooltip: 'Delete',
            ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          scanResult.image!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade100,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, color: Colors.grey, size: 48),
                    SizedBox(height: 8),
                    Text('Image not available', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.text_fields, size: 16, color: theme.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Extracted Text',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColor,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () => _copyToClipboard(scanResult.extractedText),
                tooltip: 'Copy text',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            scanResult.extractedText,
            style: theme.textTheme.bodyMedium,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildResponseSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scanResult.status == ScanResultStatus.error 
          ? Colors.red.shade50 
          : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: scanResult.status == ScanResultStatus.error 
            ? Colors.red.shade300 
            : Colors.blue.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                scanResult.status == ScanResultStatus.error 
                  ? Icons.error_outline 
                  : Icons.auto_awesome,
                size: 16,
                color: scanResult.status == ScanResultStatus.error 
                  ? Colors.red 
                  : Colors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                scanResult.status == ScanResultStatus.error ? 'Error' : 'AI Response',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scanResult.status == ScanResultStatus.error 
                    ? Colors.red 
                    : Colors.blue,
                ),
              ),
              const Spacer(),
              if (scanResult.status != ScanResultStatus.error)
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () => _copyToClipboard(scanResult.aiResponse),
                  tooltip: 'Copy response',
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            scanResult.aiResponse,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scanResult.status == ScanResultStatus.error 
                ? Colors.red.shade700 
                : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    if (scanResult.status != ScanResultStatus.error || onRetry == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (scanResult.status) {
      case ScanResultStatus.processing:
        return Colors.orange;
      case ScanResultStatus.completed:
        return Colors.green;
      case ScanResultStatus.error:
        return Colors.red;
    }
  }

  IconData _getStatusIcon() {
    switch (scanResult.status) {
      case ScanResultStatus.processing:
        return Icons.hourglass_empty;
      case ScanResultStatus.completed:
        return Icons.check_circle_outline;
      case ScanResultStatus.error:
        return Icons.error_outline;
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}