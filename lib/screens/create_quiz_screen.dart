import 'package:flutter/material.dart'; // Imports Flutter's Material Design widgets.
import 'dart:convert'; // Allows us to decode JSON responses from the server
import 'package:http/http.dart' as http; // Allows us to send HTTP requests
import '../models/question.dart'; // imports parent Question class
import '../models/multiple_choice_question.dart'; // Imports the multiple-choice question class
import '../models/fill_in_blank_question.dart'; // Imports the fill-in-the-blank question class
import 'quiz_screen.dart'; // imports the QuizScreen so we can navigate to it



class CreateQuizScreen extends StatefulWidget{ // Create a screen that does not manage changing state yet

  final String username; // stores the username from passed from the login screen
  final String pin; // stores the PIN passed from the Login Screen


  const CreateQuizScreen({ // constructor
    super.key,
    required this.username, 
    required this.pin,
  }); // end of constructor


  @override // Overrides the createState method.
  State<CreateQuizScreen> createState() { // Creates the screen's State object.
    return _CreateQuizScreenState(); // Returns the State object.
    
  } // Ends createState.


} // Ends CreateQuizScreen.


class _CreateQuizScreenState extends State<CreateQuizScreen> { // Stores the screen's state.
  
  final _numberController = TextEditingController(); // Stores the number entered by the student.
  
  @override // Overrides Flutter's cleanup method.
  void dispose() { // Runs when this State is permanently removed.
    _numberController.dispose(); // Cleans up the controller.
    super.dispose(); // Completes Flutter's cleanup.
  } // Ends dispose.


  Future<void> _fetchQuiz(int number) async{

    print("Student requested $number questions"); // prints the number recieved by the method
    final allQuestions = <dynamic>[]; // creates an empty list to collect questions from multiple quizzes
    int quizNumber = 1; // starts with Quiz 01

    try{
      while(allQuestions.length < number){ // repeats while we still need more questions
        final quizId = "quiz${quizNumber.toString().padLeft(2,"0")}"; // add 0 in front of int
        print("Requesting $quizId"); // Prints the current quiz ID for testing


        final url = Uri.https( //creates https URL
          "www.cs.utep.edu", 
          "/cheon/cs4381/homework/quiz/quiz.php",
          { // starts the query parameters
            "user": widget.username, // gets username passed to this screen
            "pin": widget.pin, // gets pin passed to this screen 
            "quiz": quizId, 
          }, // end of url query parameters
        ); // end of url

        final response = await http.get(url); // sends the request and waits for the response from server
        if(response.statusCode != 200){ // check for unsuccessful HTTP response
          throw Exception("Server conncetion ERROR :(");
        } // end of server connection check

        final data = jsonDecode(response.body); // converts the JSON response into Dart data

        if(data["response"] != true){ // checks if server has no more quizzes
            print("No more quizes left :(");
            break;
        }// end of quiz amount response check

        final quiz = data["quiz"]; // gets the quiz object from the response
        final questions = quiz["questions"]; // gets the list of questions inside the quiz

        if(questions.isEmpty){ // checks whether if this quiz contains any questions MIGHT NOT NEEED
            print("This quiz has no questions :O");
            break;
        } // end of empty list check


        allQuestions.addAll(questions); // Adds all questions to our comnined list
        print("Questions collected: ${allQuestions.length}"); // show the total amount of questions collected so far

        quizNumber++; // Moves to the next quiz number
      
      } // while loop end

      final selectedQuestions = allQuestions.take(number).toList(); // takes that many questions from the beginning of list
      print("Selected questions: ${selectedQuestions.length}"); // prints how many questions were selected

      final questionObjects = <Question>[]; // creates a empty list that will store our homework q question objects
      final figures = <String?>[]; // Stores the optional image filename for each question


      for(final item in selectedQuestions){ // Goes through each selected JSON question

          figures.add(item["figure"]?.toString()); // Saves the image filename, or null if there is no image

          if(item["type"] == 1){ // Checks if this item is a MultipleChoice Question
            final question = MultipleChoiceQuestion( // creates a MultipleChoice Question object
              item["stem"] as String, // gets the question text from JSON
              item["answer"] as int, // gets the correct answer nummber
              List<String>.from(item["options"]), // Converts the JSON options into a list of strings
            ); // end of constructor

            questionObjects.add(question); // Adds the new question object to our list
          } // end of Multi choice If

          else if(item["type"] == 2){ // checks whether the question is fill in blank
            final question = FillInBlankQuestion( // creates a in blank Question object
              item["stem"] as String, // Gets the question text from JSON
              List<String>.from(item["answer"]), // gets the list of accepted answers
            ); // end of constructor

            questionObjects.add(question); // Adds the new question object to our list
          } // end of FillBlankQuestion If
      } // end of for loop

      print("Question Objects created: ${questionObjects.length}"); // prints num of converted multi choice pregunta

      if (!mounted) return; // Stops if CreateQuizScreen is no longer active

      Navigator.push( // opens a new screen
        context, // Provides the location of the current widget in Flutter's widget tree
        MaterialPageRoute( // Creates a route to the next screen
          builder: (context) => QuizScreen( // Builds the QuizScreen
            questions: questionObjects, // Passes the converted Question objects to QuizScreen
            figures: figures, // Passes the matching image filenames
          ), // Ends QuizScreen
        ), // Ends MaterialPageRoute
      ); // Ends Navigator.push

    
    }catch (error) { //(try end) handles network or JSON errors. 
    print('Quiz request failed: $error :('); // prints the error message
    } // ends try/catch.
  } // Ends _fetchQuiz

  
  @override
  Widget build(BuildContext context){ // Builds the screens user interface

    return Scaffold( // Provides a basic screen structure
      
      appBar: AppBar( // located at top of screen
        title: const Text("Create Quiz"), // Displays Create Quiz at the top
      ), // end AppBar

      body: Center( // Centers the screens content
        child: Padding( // Adds space around the input fields
          padding: EdgeInsets.all(16.0), // Adds 16 pixels of padding
          child: Column( // for arranging input field and button vertically
            mainAxisSize: MainAxisSize.min, // keeps the column only as tall as its contents
            children: [ // starts list of widgets
              TextField(
                controller: _numberController, // connects the field to its controller
                keyboardType: TextInputType.number, // requests a numeric keyboard.
                decoration: const InputDecoration( // controls the input field's appearance.
                labelText: "# of Questions", // displays the label.
                border: OutlineInputBorder(), // adds a rectangular border.
                ),// end of text field
              ), // text field end
              const SizedBox(height: 16), //Adds space between the field and button
              ElevatedButton( // button for the create quiz button 
                onPressed: (){ // runs when user clicks button
                  final number = int.tryParse(_numberController.text.trim()); // convert the input into an integer   
                  if(number == null || number <=0){
                    ScaffoldMessenger.of(context).showSnackBar(// shows a message at the bottom of the screen
                      const SnackBar(
                        content: Text("INVALID :("),
                      ), // end of snackbar
                    ); // end of showSnackBar
                    return; // Stops the callback when input is invalid
                  } // end of if      
                  print("Valid # of preguntas: $number");
                  _fetchQuiz(number);        
                }, // end of call back
                  child: const Text("Create Quiz"), // Displays the button text
              ), // End of button
            ], // end list of widgets
          ), // end of column
        ), // end of padding
      ), // ends Center 

    ); // Scaffold end

 
 
 
  } // widget end

} //  class end