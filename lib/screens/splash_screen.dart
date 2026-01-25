import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // Wait for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      // Use go_router to swap the screen to Home
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the theme data
    final theme = Theme.of(context);

    return Scaffold(
      // The background color is inherited from AppTheme (white)
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. The Logo Placeholder
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor.withAlpha(1), // Light blue circle
              ),
              child: Icon(
                Icons.smart_toy_rounded, // Robot icon
                size: 60,
                color: theme.primaryColor,
              ),
            ),
            
            const SizedBox(height: 24),

            // 2. The App Title
            Text(
              'AI Teacher Helper',
              style: theme.textTheme.headlineLarge, // Defined in your AppTheme
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // 3. Loading Text
            Text(
              'Loading...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Optional: A small spinner if you want it to look active
            SizedBox(
              width: 20, 
              height: 20, 
              child: CircularProgressIndicator(strokeWidth: 2, color: theme.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}