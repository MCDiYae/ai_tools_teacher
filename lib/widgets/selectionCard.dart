import 'package:flutter/material.dart';
import '../utils/app_theme.dart'; 

class SelectionCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  final bool showCheckmark; 

  const SelectionCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.showCheckmark = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = isSelected 
        ? AppColors.lightBlue 
        : Colors.grey[100]; 
    
    final borderColor = isSelected 
        ? theme.primaryColor 
        : Colors.transparent;
        
    final textColor = isSelected 
        ? theme.primaryColor 
        : Colors.black87;

    return Card(
      elevation: 0,
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 6), // Spacing between cards
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: borderColor, 
          width: isSelected ? 2 : 0, // Thicker border when selected
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          // Fixed height feels better for lists, or use padding for dynamic height
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          width: double.infinity,
          child: showCheckmark 
            ? _buildWithCheckmark(textColor) 
            : _buildCentered(theme, textColor),
        ),
      ),
    );
  }

  Widget _buildCentered(ThemeData theme, Color textColor) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }

  Widget _buildWithCheckmark(Color textColor) {
    return Row(
      children: [
        // The Checkmark Icon
        Icon(
          isSelected ? Icons.check_circle : Icons.circle_outlined,
          color: isSelected ? AppColors.successGreen : Colors.grey,
          size: 24,
        ),
        const SizedBox(width: 16),
        // The Title
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}