import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quiz/model/question.dart';
import 'package:quiz/model/question_parameter.dart';

class QuestionRepository {
  final http.Client _client = http.Client();

  Future<List<Question>> getQuestions(QuizParameter quizParameter) async {
    final List<Question> questions = [];
    print("url=" + quizParameter.toString());
    final http.Response response =
        await _client.get(Uri.parse(quizParameter.toString()));
    final String body = response.body;
    //print("body=" + body);
    final json = jsonDecode(body);

    if (json.length > 0) {
      final results = json;

      for (int i = 0; i < results.length; ++i) {
        Question q = Question.fromJson(results[i]);
        //if (q.questionImage != '')
        //  print("has image");
        //else
        //  print("no image");
        questions.add(q);
      }
    }
    questions.shuffle();

    int amount = quizParameter.amount;
    final List<Question> randomized = [];

    if (amount > questions.length) {
      amount = questions.length;
    }

    for (int i=0; i<amount; i++) {
      Question r = questions[i];
      randomized.add(r);
    }

    return randomized;
  }
 
}
