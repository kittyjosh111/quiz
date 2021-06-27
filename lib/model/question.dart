import 'package:meta/meta.dart';

class Question {
  Question({
    @required this.category,
    @required this.type,
    @required this.difficulty,
    @required this.question,
    @required this.questionImage,
    @required this.correctAnswer,
    @required this.incorrectAnswers,
  });

  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String questionImage;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  /// All the options
  List<String> get options {
    List<String> options = incorrectAnswers + [correctAnswer];
    options.shuffle();

    return options;
  }

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        category: json["category"],
        type: json["type"],
        difficulty: json["difficulty"],
        question: json["question"],
        questionImage: json["question_image"],
        correctAnswer: json["correct_answer"],
        incorrectAnswers: json["incorrect_answer_2"] != ''
            ? json["incorrect_answer_3"] != ''
                ? [
                    json["incorrect_answer_1"],
                    json["incorrect_answer_2"],
                    json["incorrect_answer_3"],
                  ]
                : [
                    json["incorrect_answer_1"],
                    json["incorrect_answer_2"],
                  ]
            : [
                json["incorrect_answer_1"],
              ],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "type": type,
        "difficulty": difficulty,
        "question": question,
        "questionImage": questionImage,
        "correct_answer": correctAnswer,
        "incorrect_answers": List<dynamic>.from(incorrectAnswers.map((x) => x)),
      };
}
