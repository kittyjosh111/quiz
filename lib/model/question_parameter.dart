import 'package:meta/meta.dart';
import 'package:quiz/model/question_difficulty.dart';
import 'package:quiz/model/question_type.dart';
import 'package:quiz/model/quiz_category.dart';
import 'package:quiz/model/quiz_year.dart';

class QuizParameter {
  final int _amount;
  final int _category;
  final String _difficulty;
  final String _type;
  final String _year;

  const QuizParameter(
      {@required int amount,
      int category,
      String difficulty,
      String type,
      String year})
      : this._amount = amount,
        this._category = category,
        this._difficulty = difficulty,
        this._type = type,
        this._year = year,
        assert(amount != null);

  factory QuizParameter.fromEnums({
    @required int amount,
    QuestionCategoryExtension category,
    QuestionDifficulty difficulty,
    QuestionType type,
    QuestionYearExtension year,
  }) {
    return QuizParameter(
      amount: amount,
      category: category == null ? null : category.value,
      difficulty: difficulty == null ? null : difficulty.value,
      type: type == null ? null : type.value,
      year: year == null ? null : year.title,
    );
  }

  String get type => _type;

  String get difficulty => _difficulty;

  int get category => _category;

  int get amount => _amount;

  String get year => _year;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this._amount;
    data['category'] = this._category;
    data['difficulty'] = this._difficulty;
    data['type'] = this._type;
    data['year'] = this._year;
    return data;
  }

  @override
  String toString() {
    return "" +
        "${_category == null ? "" : "&category_id=" + _category.toString()}" +
        "${_difficulty == null ? "" : "&difficulty=" + _difficulty}" +
        "${_type == null ? "" : "&type=" + _type}" +
        "${_year == null ? "" : "&year=" + _year}";
  }
}
