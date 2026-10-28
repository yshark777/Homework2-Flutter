import 'package:flutter/material.dart'; // Imports Flutter's Material Design widgets
import '../models/question.dart'; // Imports the Question model from Homework 1.
import '../models/multiple_choice_question.dart'; // Imports the multiple-choice question model.
import '../models/fill_in_blank_question.dart'; // Imports the fill-in-the-blank question model.


/// Displays the student's quiz score after submission.
///
/// Allows students to review questions they answered incorrectly.
class ResultsScreen extends StatelessWidget { // Creates a screen that displays the quiz results
  
  final int score; // Stores the student's score
  final int totalQuestions; // Stores the total number of questions
  final List<Question> questions; // Stores all questions from the completed quiz
  final Map<int, int> selectedAnswers; // Stores the student's multi choice selections
  final Map<int, String> textAnswers; // Stores the student's fill in blank responses.

  
  const ResultsScreen({ // Defines the ResultsScreen constructor
    super.key, // Passes the widget key to the parent class
    required this.score, // Receives the student's score
    required this.totalQuestions, // Receives the total number of questions
    required this.questions, // Receives the quiz questions
    required this.selectedAnswers, // Receives the multiple-choice answers
    required this.textAnswers, // Receives the fill-in-the-blank answers
  }); // Ends the constructor

  /// Identifies questions the student answered incorrectly.
  ///
  /// Compares submitted answers against the correct answers for
  /// multiple-choice and fill-in-the-blank questions.
  List<int> getIncorrectQuestions() { // Creates a function that finds incorrect question
    final List<int> incorrect = []; // Creates an empty list of incorrect question indexes

    for (int i = 0; i < questions.length; i++) { // Loops through every question
      final question = questions[i]; // Gets the current question

      if (question is MultipleChoiceQuestion) { // Checks for a multi choice question
        final selected = selectedAnswers[i]; // Gets the student's selected option

        if (selected == null || selected + 1 != question.answer) { // Checks for an unanswered or incorrect selection
          incorrect.add(i); // Adds this question's index to the incorrect list
        } 
      } 
      
      else if (question is FillInBlankQuestion) { // Checks for a fill in blank question
        final studentAnswer = (textAnswers[i] ?? "").trim().toLowerCase(); 

        final isCorrect = question.answer.any( // Checks all accepted answers
          (answer) => answer.trim().toLowerCase() == studentAnswer, // Compares answers
        ); // End of any

        if (studentAnswer.isEmpty || !isCorrect) { // Checks for an empty or incorrect response
          incorrect.add(i); // Adds this question's index to the incorrect list
        }
      } 
    } // End of loop

    return incorrect; // Returns the indexes of all incorrect questions
  } // End of getIncorrectQuestions


  
  /// Builds the results screen with the score and answer review button.
  @override // Overrides the build method
  Widget build(BuildContext context) { // Builds the results screen
    return Scaffold( // Creates the basic screen structure
      appBar: AppBar( // Creates the top app bar
        title: const Text("Quiz Results"), // Displays the screen title
      ), // Ends AppBar
      body: Center( // Centers the results
        child: Column( // Arranges the results vertically
          mainAxisSize: MainAxisSize.min, // Uses only the space needed
          children: [ // Starts the widget list
            const Text( // Creates the heading
              "Quiz Complete!", 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Makes the heading larger and bold
            ), // End of Text
            const SizedBox(height: 20), // Adds vertical spacing
            Text( // Creates the score text
              "You scored $score out of $totalQuestions!", // Displays the student's score.
              style: const TextStyle(fontSize: 20), // Makes the score easy to read.
              ), // End of the score Text widget.

            const SizedBox(height: 20), // Adds space below the score

            ElevatedButton( // Creates the review button
              onPressed: () { // Runs when the student presses the button
                final incorrect = getIncorrectQuestions(); // Gets the indexes of incorrect questions
                showDialog<void>( // Opens a dialog displaying the incorrect questions
                  context: context, // Uses the current screens context
                  builder: (context) { // Builds the review dialog
                    return AlertDialog( // Creates the review dialog
                      title: const Text("Review Incorrect Answers"), // Displays the dialog title
                      content: SizedBox( // Gives the review list a limited height
                        width: double.maxFinite, // Allows the list to use available width
                        height: 300, // Sets the review area height
                        child: incorrect.isEmpty // Checks whether the student got everything correct
                            ? const Text("Great job! All answers are correct!") // Shows a message for a perfect score
                            : ListView.builder( // Creates a scrollable list of incorrect questions
                                itemCount: incorrect.length, // Sets the number of incorrect questions
                                itemBuilder: (context, index) { // Builds each incorrect question
                                  final questionIndex = incorrect[index]; // Gets the original question index
                                  final question = questions[questionIndex]; // Gets the question object

                                  String studentAnswer = "Not answered"; // Sets a default student answer
                                  String correctAnswer = ""; // Creates a variable for the correct answer

                                  if (question is MultipleChoiceQuestion) { // Checks for a multiple-choice question
                                    final selected = selectedAnswers[questionIndex]; // Gets the selected option
                                    if (selected != null) { // Checks whether an answer was selected
                                      studentAnswer = question.options[selected]; // Gets the selected option's text
                                    } 
                                    correctAnswer = question.options[question.answer - 1]; // Gets the correct option's text
                                  } 
                                  else if (question is FillInBlankQuestion) { // Checks for a fill-in-the-blank question
                                    final entered = textAnswers[questionIndex] ?? ""; // Gets the student's typed answer
                                    if (entered.trim().isNotEmpty) { // Checks whether the student entered text
                                      studentAnswer = entered; // Saves the student's answer for display
                                    } 
                                    correctAnswer = question.answer.join(", "); // Displays all accepted correct answers
                                  }

                                  return ListTile( // Displays the incorrect question and answers
                                    title: Text("Question ${questionIndex + 1}: ${question.stem}"), // Displays the question
                                    subtitle: Text( // Displays the student's answer and correct answer
                                      "Your answer: $studentAnswer\nCorrect answer: $correctAnswer", // Shows both answers
                                    ), // Ends subtitle
                                  ); // Ends ListTile
                                }, // Ends itemBuilder
                              ), // Ends ListView.builder
                      ), // Ends SizedBox
                      actions: [ // Starts the dialog's action buttons
                        TextButton( // Creates a Close button
                          onPressed: () => Navigator.pop(context), // Closes the dialog
                          child: const Text("Close"), // Displays the button label
                        ), // End of TextButton
                      ], // End of  actions
                    ); // End of  AlertDialog
                  }, // End of  dialog builder
                ); // End of  showDialog
              }, // End of  onPressed
              child: const Text("Review Incorrect Answers"), // Displays the button labe  
            ), // End of the Review Incorrect Answers button
          ], // End of the Column's children list
        ), // End of of Column
      ), // End of Center
    ); // End of Scaffold
  } // End of build
} // End of ResultsScreen
