import 'package:meta/meta.dart';

class Option {
  String optionText;
  String optionImage;

  Option(String optionText, String optionImage) {
    this.optionText = optionText;
    this.optionImage = optionImage;
  }

  String toString() {
    return optionText + ":" + optionImage;
  }

  bool equals(Option o) {
    return this.optionText == o.optionText && this.optionImage == o.optionImage;
  }

  bool hasText() {
    return this.optionText != null && this.optionText != '';
  }

  bool hasImage() {
    return this.optionImage != null && this.optionImage != '';
  }
}

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
  final Option correctAnswer;
  final List<Option> incorrectAnswers;

  /// All the options
  List<Option> get options {
    List<Option> options = incorrectAnswers + [correctAnswer];
    options.shuffle();

    return options;
  }

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        category: json["category"],
        type: json["type"],
        difficulty: json["difficulty"],
        question: json["question"],
        questionImage: json["question_image"],
        correctAnswer:
            Option(json["correct_answer"], json["correct_answer_image"]),
        incorrectAnswers: (json["incorrect_answer_2"] != '' ||
                json["incorrect_answer_2_image"] != '')
            ? (json["incorrect_answer_3"] != '' ||
                    json["incorrect_answer_3_image"] != '')
                ? (json["incorrect_answer_4"] != '' ||
                        json["incorrect_answer_4_image"] != '')
                    ? [
                        Option(json["incorrect_answer_1"],
                            json["incorrect_answer_1_image"]),
                        Option(json["incorrect_answer_2"],
                            json["incorrect_answer_2_image"]),
                        Option(json["incorrect_answer_3"],
                            json["incorrect_answer_3_image"]),
                        Option(json["incorrect_answer_4"],
                            json["incorrect_answer_4_image"]),
                      ]
                    : [
                        Option(json["incorrect_answer_1"],
                            json["incorrect_answer_1_image"]),
                        Option(json["incorrect_answer_2"],
                            json["incorrect_answer_2_image"]),
                        Option(json["incorrect_answer_3"],
                            json["incorrect_answer_3_image"]),
                      ]
                : [
                    Option(json["incorrect_answer_1"],
                        json["incorrect_answer_1_image"]),
                    Option(json["incorrect_answer_2"],
                        json["incorrect_answer_2_image"]),
                  ]
            : [
                Option(json["incorrect_answer_1"],
                    json["incorrect_answer_1_image"]),
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
