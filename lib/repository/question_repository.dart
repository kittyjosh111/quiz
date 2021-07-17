import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:quiz/model/question.dart';
import 'package:quiz/model/question_parameter.dart';

class QuestionRepository {
  final http.Client _client = http.Client();

  Future<List<Question>> getQuestions(QuizParameter quizParameter) async {
    // get question api url first
    final http.Response apiUrlResponse = await _client.get(Uri.parse(
        'https://raw.githubusercontent.com/kittyjosh111/biology_app_config/master/questions_api_url.json'));
    final String apiUrlBody = apiUrlResponse.body;
    final apiUrlJson = jsonDecode(apiUrlBody);
    final apiUrl = apiUrlJson['url'];

    List<Question> questions = [];
    // get url parameters
    final String url = apiUrl + quizParameter.toString();
    //print("url=" + url);
    final http.Response response = await _client.get(Uri.parse(url));
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

      questions.shuffle();
      questions =
          questions.take(min(quizParameter.amount, questions.length)).toList();
    }

    /*
    questions.shuffle();

    int amount = quizParameter.amount;
    final List<Question> randomized = [];

    if (amount > questions.length) {
      amount = questions.length;
    }

    for (int i = 0; i < amount; i++) {
      Question r = questions[i];
      randomized.add(r);
    }

    return randomized;
    */
    return questions;
  }
}
