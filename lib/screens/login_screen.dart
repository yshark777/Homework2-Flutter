import 'package:flutter/material.dart';
import 'dart:convert'; // converts server JSON response into dart data
import 'package:http/http.dart' as http; // allows us to send HTTP requests to server
import 'create_quiz_screen.dart'; // Allows login_Screen to access/navigate to the Create Quiz Screen


/// Displays the login screen where students enter their username and PIN.
///
/// Authenticates students using the university's quiz web service.
// The login screen widget, used to store username, PIN and login status
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

/// Manages login input, authentication requests, and login feedback.
// Stores/manages the state of the login screen
class _LoginScreenState extends State<LoginScreen> {

  final _usernameController = TextEditingController(); // Stores and reads username input
  final _pinController = TextEditingController(); // Stores and reads PIN input
  
  // Mabye take out?
  @override
  void dispose(){ // Runs 
    _usernameController.dispose(); // Cleans up the Username controller
    _pinController.dispose(); // Cleans uup the PIN controller
    super.dispose(); // Completes Flutter cleanup 
  }


  /// Sends the students credentials to the server for authentication.
  ///
  /// Navigates to the quiz creation screen when authentication succeeds.
  // Async method for logging in with future return type
  Future<void> _login() async{ 

    final username = _usernameController.text.trim(); // Gets username and removes spaces
    final pin = _pinController.text.trim(); // Gets username and removes spaces

    final url = Uri.https( // Creates the URL
      "www.cs.utep.edu", 
      "/cheon/cs4381/homework/quiz/login.php",
      { // URL query parameters
        "user": username, 
        "pin": pin,
      },

    );// Url end

    try { // Handling possible errors

      final serverResponse = await http.get(url); // Sends get request and wait for response
      final data = jsonDecode(serverResponse.body); // Converts the JSON server response into data dart can use
      
      if(!mounted) return; // Stops if flutter has already removed this screen ???

      if(data["response"] == true){
        Navigator.pushReplacement( // Replace the login screen with another screen
          context, // Identifies the current screens location in flutter
          MaterialPageRoute( // Creates a route to the new screen
            builder: (context) =>  CreateQuizScreen(
              username: username, // pass username from login
              pin: pin, // pass pin from login
            ), // Builds the Create Quiz Screen
          ), // Ends MatieralPageRoute
        ); // End of Navigator.pushReplacement
      }  // End of if
      else{ // if server has rejected login
        ScaffoldMessenger.of(context).showSnackBar( // Displays a snackBar on the screen
          const SnackBar( // Snackbar widget
            content: Text("USERNAME OR PIN IS INVALID :(")
          ), // Ends the SnackBar
        ); // snackBar end
      } // End of else


    } // Try end
    catch(error){// If server response fails
        print("Login error!!!!: $error");

    } // Catch end
  } // End _login() method




  
  /// Builds the login interface with username and PIN input fields.
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(// Provides basic structure
      
      appBar: AppBar(// Dispays at the top
        title: const Text('Quiz Login'),
      ), // App bar end
      
      body: Center(// Displays on the middle
        child: Padding( // Adds space around form
          padding: EdgeInsets.all(16.0), // Adds 16 pixels of space around field
          child: Column( // Arrange input fields vertically
            mainAxisSize: MainAxisSize.min, // Controls column length
            children:[
              TextField( // Input field for Username
                controller: _usernameController, // Connects TextField to the username controller
                decoration: InputDecoration( // Controls how input field looks
                  labelText: 'Username', // Displays the word Username
                  border: OutlineInputBorder(), // Rectangle around Textfield
                ), // Decoration end
              ), // TextField end
              const SizedBox(height: 16), // Adds 16 pixels between the fields
              TextField( // PIN input TextField
                controller: _pinController, // Connects TextField to the username controller
                obscureText: true, // Hides PIN characters as user types
                decoration: InputDecoration(
                  labelText: "PIN", // Displays the word PIN
                  border: OutlineInputBorder(), // Rectangle border
                ), // Ends PIN decoration
              ), // Ends PIN TextField
              const SizedBox(height: 16), // Adds 16 pixels of space below the PIN field
              ElevatedButton( // Creates a button for log in
                onPressed: _login,  // Callback function that defines what happens when button is pressed
                child: const Text("Log In"), // Text on button
              ), // Button End 
            ], // Ends list of widgets
          ), // Column end        
        ), // Padding end        
      ), // Center end

      
    
    );// Scaffold end
  
  } // Build end 
} // Widget end