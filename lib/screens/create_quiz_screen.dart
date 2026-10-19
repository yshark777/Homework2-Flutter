import 'package:flutter/material.dart'; // Imports Flutter's Material Design widgets.

class CreateQuizScreen extends StatelessWidget{ // Create a screen that does not manage changing state yet

  const CreateQuizScreen({super.key}); // Defines the screens constructor

  @override
  Widget build(BuildContext context){ // Builds the screens user interface

    return Scaffold( // Provides a basic screen structure
      
      appBar: AppBar( // located at top of screen
        title: const Text("Create Quiz"), // Displays Create Quiz at the top
      ), // end AppBar

      body: const Center( // Centers the screens content
        child: Text("Create Quiz Screen") // Displays text to screen
      ), // ends Center 

    ); // Scaffold end

  } // widget end

} // build end