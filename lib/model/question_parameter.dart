import 'package:meta/meta.dart';
import 'package:quiz/model/question_difficulty.dart';
import 'package:quiz/model/question_type.dart';
import 'package:quiz/model/quiz_category.dart';

class QuizParameter {
  final int _amount;
  final int _category;
  final String _difficulty;
  final String _type;

  const QuizParameter(
      {@required int amount, int category, String difficulty, String type})
      : this._amount = amount,
        this._category = category,
        this._difficulty = difficulty,
        this._type = type,
        assert(amount != null);

  factory QuizParameter.fromEnums({
    @required int amount,
    QuestionCategoryExtension category,
    QuestionDifficulty difficulty,
    QuestionType type,
  }) {
    return QuizParameter(
      amount: amount,
      category: category == null ? null : category.value,
      difficulty: difficulty == null ? null : difficulty.value,
      type: type == null ? null : type.value,
    );
  }

  String get type => _type;

  String get difficulty => _difficulty;

  int get category => _category;

  int get amount => _amount;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this._amount;
    data['category'] = this._category;
    data['difficulty'] = this._difficulty;
    data['type'] = this._type;
    return data;
  }

  @override
  String toString() {
    return "/search?" +
        "${_category == null ? "" : "&category_id=" + _category.toString()}" +
        "${_difficulty == null ? "" : "&difficulty=" + difficulty}" +
        "${_type == null ? "" : "&type=" + type}";
  }
}
