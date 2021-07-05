import 'dart:convert';

import 'package:http/http.dart' as http;

/*enum QuestionCategory { ANIMALS, PLANTS, ANY }

extension QuestionCategoryExtension on QuestionCategory {
  String get title {
    String string = this.toString().toString().toLowerCase().split(".")[1];
    return string.substring(0, 1).toUpperCase() + string.substring(1);
  }

  int get value {
    switch (this) {
      case QuestionCategory.ANIMALS:
        return 9;
      case QuestionCategory.PLANTS:
        return 10;
      default:
        return 0;
    }
  }
}
*/
class QuestionCategoryExtension {
  final int _value;
  final String _title;
  final String _base64Image;

  const QuestionCategoryExtension(this._value, this._title, this._base64Image);

  static const QuestionCategoryExtension ANY =
      const QuestionCategoryExtension(0, 'any', null);

  String get title {
    return _title.substring(0, 1).toUpperCase() + _title.substring(1);
  }

  int get value => _value;

  String get base64Image => _base64Image;
}

class QuestionCategory {
  static final QuestionCategory _singleton = QuestionCategory._internal();

  factory QuestionCategory() {
    return _singleton;
  }

  QuestionCategory._internal();

  final http.Client _client = http.Client();
  final List<QuestionCategoryExtension> _categories = [];
  bool _loaded = false;

  List<QuestionCategoryExtension> getCategoriesImmediate() {
    if (_loaded) {
      return _categories;
    } else {
      return null;
    }
  }

  Future<List<QuestionCategoryExtension>> getCategories() async {
    if (_loaded) {
      return _categories;
    } else {
      // get question api url first
      final http.Response apiUrlResponse = await _client.get(Uri.parse(
          'https://raw.githubusercontent.com/kittyjosh111/biology_app_config/master/questions_api_url.json'));
      final String apiUrlBody = apiUrlResponse.body;
      final apiUrlJson = jsonDecode(apiUrlBody);
      final apiUrl = apiUrlJson['categories_url'];

      // get url parameters
      print("url=" + apiUrl);
      final http.Response response = await _client.get(Uri.parse(apiUrl));
      final String body = response.body;
      //print("body=" + body);
      final json = jsonDecode(body);
      if (json.length > 0) {
        for (int i = 0; i < json.length; ++i) {
          _categories.add(QuestionCategoryExtension(
              int.parse(json[i]['value']), json[i]['title'], json[i]['image']));
        }
      }
      _loaded = true;
      return _categories;
    }
  }
}
