import 'package:flutter/material.dart'; // Imports Flutter's Material Design widgets
import '../models/question.dart'; // Imports Homework 1 Question class
import '../models/multiple_choice_question.dart'; // imports Homework 1 multiple-choice question class
import '../models/fill_in_blank_question.dart'; // imports Homework 1 fill-in-the-blank question class



class QuizScreen extends StatefulWidget { // Creates a widget that can manage changing data
  final List<Question> questions; // Stores the questions received from CreateQuizScreen

  const QuizScreen({ // Defines the QuizScreen constructor
    super.key, // Passes the widget key to the parent class
    required this.questions, // Requires the list of questions
  }); // Ends the constructor

  @override // Overrides the createState method
  State<QuizScreen> createState() { // Creates the State object for QuizScreen
    return _QuizScreenState(); // Returns the State object
  } // Ends createState
} // Ends QuizScreen

class _QuizScreenState extends State<QuizScreen> { // Manages the quiz's changing data

  int currentQuestionIndex = 0; // Tracks which question the student is currently viewing
  final Map<int, int> selectedAnswers = {}; // stores the selected option for each question index
  final Map<int, String> textAnswers = {}; // stores each fill-in-the-blank answer by question index


  //function to calculate the students score
  int calculateScore(){

    int score = 0; // score starts at zero

    for(int i = 0; i < widget.questions.length; i++){ // loops through every question
      final question = widget.questions[i]; // gets the current question

      if(question is MultipleChoiceQuestion){
        final selected = selectedAnswers[i]; // gets the current question

        if(selected != null && selected + 1 == question.answer){ // compares the selected option with the correct answer
            score++; // adds 1 point for a correcct answer
        }

      }

    } // loop end 



    return score;

  }



  @override // Overrides the build method
  Widget build(BuildContext context) { // Builds the quiz user interface
    

    final question = widget.questions[currentQuestionIndex]; // Gets the question at the current index

    return Scaffold( // Provides the basic screen structure
      appBar: AppBar( // Creates the top app bar
        title: const Text("Quiz"), 
      ), // End of AppBar
      body: Center( // Centers the quiz content
        child: Column( // Arranges the question and choices vertically
          mainAxisSize: MainAxisSize.min, // Keeps the column only as tall as its contents
          children: [ // Starts the list of widgets
            Text(question.stem), // Displays the question text

            if (question is MultipleChoiceQuestion) // Checks if the question is multiple-choice
              ...question.options.asMap().entries.map((entry) { // Loops through choices and their indexes
                return RadioListTile<int>( // Creates a selectable radio button for an answer
                  title: Text(entry.value), // Displays the answer choice text
                  value: entry.key, // Uses the choice's index as its value
                  groupValue: selectedAnswers[currentQuestionIndex], // Identifies the currently selected answer
                  onChanged: (value) { // Runs when the student selects an option
                    setState(() { // Tells Flutter to rebuild the screen
                      if(value != null){ // checks that the option was selected
                        selectedAnswers[currentQuestionIndex] = value; // Saves the answer under this question index
                      } // end of null check
                    }); // End of setState
                  }, // End of onChanged
                ); // End of RadioListTile
              }), // End of the options loop

            if(question is FillInBlankQuestion) // checks if question is fill in blank
              Padding( // add space around text input
                padding: EdgeInsets.all(16.0), // adds 16 pixels of padding
                child: TextFormField( // Creates a text field that can restore saved text
                  key: ValueKey(currentQuestionIndex), // Gives each question's text field a unique identity
                  initialValue: textAnswers[currentQuestionIndex] ?? "", // Restores the previously entered answer
                  decoration: const InputDecoration( // Defines the text field's appearance
                    labelText: "Your Answer", // Displays the input label
                    border: OutlineInputBorder(), // Adds a rectangular border
                  ), // End of InputDecoration
                  onChanged: (value) { // Runs whenever user types
                    textAnswers[currentQuestionIndex] = value; // Saves the typed answer for this question
                  }, // End of onChanged
                ), // End of TextFormField
              ), // end of padding 

            const SizedBox(height: 20), // Adds space above the navigation buttons

            Row( // Places the navigation buttons side by side 
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Spaces the buttons evenly 
              children: [ // Starts the button list 
                ElevatedButton( // Creates the Previous button 
                  onPressed: currentQuestionIndex > 0 ? () { // Allows going back unless we're on the first question
                    setState(() { // Tells Flutter to rebuild the screen 
                      currentQuestionIndex--; // Moves to the previous question 
                  
                    }); // End of setState
                  } : null, // Disables Previous on the first question
                  child: const Text("Previous"), // Displays the button label
                ), // Ends Previous button

                ElevatedButton( // Creates the Next button
                  onPressed: currentQuestionIndex < widget.questions.length - 1 ? () { // Allows advancing unless we're on the last question
                    setState(() { // Tells Flutter to rebuild the screen
                      currentQuestionIndex++; // Moves to the next question
          
                    }); // Ends setState
                  } : null, // Disables Next on the last question
                  child: const Text("Next"), // Displays the button label
                ), // End of Next button
              ], // Ends of the button list
            ), // End of Row
          ], // End of the children list
        ), // End of Column
      ), // End of Center
    ); // End of Scaffold
  } // End of build
} // End of _QuizScreenState