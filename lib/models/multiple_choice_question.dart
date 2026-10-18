//NAME: YASHAR KEYVAN
import 'question.dart'; //using code from question.dart


// MULTIPLE CHOICE QUESTION 
//Inherits stem attribute
///Represantation of mutliple choice question in the quiz
class MultipleChoiceQuestion extends Question { 

  /// Num of the correct asnwer
  int answer; 

  ///string list of answer choices to question
  List<String> options; 

  /// Constructor of Question Obejct containing [stem], [answer], [options]
  MultipleChoiceQuestion( String stem, 
                          this.answer, 
                          this.options,
                        ) : super(stem); //using stem from parent/super class

}




