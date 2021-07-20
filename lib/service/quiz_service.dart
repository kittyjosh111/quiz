import 'package:meta/meta.dart';
import 'package:quiz/model/question_parameter.dart';
import 'package:quiz/model/quiz_category.dart';
import 'package:quiz/model/quiz_year.dart';

class QuizService {
  /// Returns a list of category names in title case
  List<String> get categories => QuestionCategory()
      .getCategoriesImmediate()
      .map((category) => category.title)
      .toList();

  QuizParameter getQuizParameter({
    @required int categoryIndex,
    @required int questionCount,
    @required int difficultyIndex,
    @required int questionTypeIndex,
    @required int questionYearIndex,
  }) {
    int category;
    String difficulty;
    String type;
    String year;

    if (categoryIndex != 0) {
      category = categoryIndex + 8;
    }

    switch (difficultyIndex) {
      case 1:
        {
          difficulty = "easy";
          break;
        }
      case 2:
        {
          difficulty = "medium";
          break;
        }
      case 3:
        {
          difficulty = "hard";
          break;
        }
    }

    switch (questionTypeIndex) {
      case 0:
        {
          type = "multiple";
          break;
        }
      case 1:
        {
          type = "boolean";
          break;
        }
    }

    if (questionYearIndex != 0) {
      final years = QuestionYear().getYearsImmediate();
      for (var i = 0; i < years.length; i++) {
        if (years[i].value == questionYearIndex) {
          year = years[i].title;
          break;
        }
      }
    }
    return QuizParameter(
      amount: questionCount,
      category: category,
      difficulty: difficulty,
      type: type,
      year: year,
    );
  }
}
