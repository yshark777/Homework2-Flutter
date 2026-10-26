import 'package:flutter/material.dart'; // Imports Flutter's Material Design widgets
import '../models/question.dart'; // Imports Homework 1 Question class
import '../models/multiple_choice_question.dart'; // imports Homework 1 multiple-choice question class


class QuizScreen extends StatelessWidget{ // creates a screen that will display the quiz information

  final List<Question> questions; // Stores the questions passed from CreateQuizScreen

  const QuizScreen({
    super.key,
    required this.questions// requires a list of questions when creating thisscreen
  }); // end of constructor


  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
          title: const Text("Quiz"),
        ), // end of AppBar

        body: Center(
            child: Column( // arranges the question and answers vertically
              mainAxisSize: MainAxisSize.min, // makes column as tall as contents
              children:[ // starts list of widgets
                Text(
                  questions[0].stem, // displays the text of 1st question
                ), // end of Text

                if(questions[0] is MultipleChoiceQuestion) // checks if 1st questions is Multi choice
                  ...((questions[0] as MultipleChoiceQuestion).options.map((option) { // Gets the options and creates a widget for each
                        return Text(option); // Displays one answer choice
                  }).toList()), // Converts the generated widgets into a list
              ], // end of list   
        ), // end of column
      ), //end of center
    ); // end of scaffold
  } // end of build
}// end of class