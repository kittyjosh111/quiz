import 'dart:convert';

import 'package:http/http.dart' as http;

class QuestionYearExtension {
  final int _value;
  final String _title;

  const QuestionYearExtension(this._value, this._title);

  static const QuestionYearExtension ANY =
      const QuestionYearExtension(0, 'Any Year');

  String get title {
    return _title.substring(0, 1).toUpperCase() + _title.substring(1);
  }

  int get value => _value;
}

class QuestionYear {
  static final QuestionYear _singleton = QuestionYear._internal();

  factory QuestionYear() {
    return _singleton;
  }

  QuestionYear._internal();

  final http.Client _client = http.Client();
  final List<QuestionYearExtension> _years = [];
  bool _loaded = false;

  List<QuestionYearExtension> getYearsImmediate() {
    if (_loaded) {
      return _years;
    } else {
      return null;
    }
  }

  Future<List<QuestionYearExtension>> getYears() async {
    if (_loaded) {
      return _years;
    } else {
      // get question api url first
      final http.Response apiUrlResponse = await _client.get(Uri.parse(
          'https://raw.githubusercontent.com/kittyjosh111/biology_app_config/master/questions_api_url.json'));
      final String apiUrlBody = apiUrlResponse.body;
      final apiUrlJson = jsonDecode(apiUrlBody);
      final apiUrl = apiUrlJson['years_url'];

      // get url parameters
      //print("url=" + apiUrl);
      final http.Response response = await _client.get(Uri.parse(apiUrl));
      final String body = response.body;
      //print("body=" + body);
      final json = jsonDecode(body);
      if (json.length > 0) {
        for (int i = 0; i < json.length; ++i) {
          _years.add(QuestionYearExtension(
              int.parse(json[i]['value']), json[i]['title']));
        }
      }
      _years.insert(0, QuestionYearExtension.ANY);
      _loaded = true;
      return _years;
    }
  }
}
