
import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Using code from screens folder

// Starting point of the application
void main() {
  runApp(const MyApp()); // Starts flutter app
}

// Root widget of our application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return const MaterialApp( // Overall application setup
      home: LoginScreen(),
    );// Material App end
 
  }// Build end
 }// Widget end

