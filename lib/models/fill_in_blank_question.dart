//NAME: YASHAR KEYVAN
import 'question.dart'; //using code from question.dart

// Fill_in_blank_question
//Inherits stem attribute
///Represantation of Fill in blank question in the quiz
class FillInBlankQuestion extends Question{

  /// List the represents multiple correct answers that can be used
  List<String> answer;

  ///Constructor containing 
  FillInBlankQuestion(String stem,
                      this.answer
                     ) : super(stem); //using stem from parent/super class

}
