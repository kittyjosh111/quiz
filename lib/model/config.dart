import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;

class Config {
  static final Config _singleton = Config._internal();

  factory Config() {
    return _singleton;
  }

  Config._internal();

  final http.Client _client = http.Client();
  bool _loaded = false;

  double categoryFontSize;
  Color categoryFontColor;
  double questionFontSize;
  double optionFontSize;
  String homeTitleText;
  String customizeTitleText;
  String luckyText;
  String homeParagraph1;
  double homeParagraph1FontSize;
  String homeParagraph2;
  double homeParagraph2FontSize;
  double minCount;
  double maxCount;

  Future<bool> loadConfig() async {
    if (_loaded) {
      return true;
    } else {
      // get question api url first
      final http.Response apiUrlResponse = await _client.get(Uri.parse(
          'https://raw.githubusercontent.com/kittyjosh111/biology_app_config/master/questions_api_url.json'));
      final String apiUrlBody = apiUrlResponse.body;
      final apiUrlJson = jsonDecode(apiUrlBody);
      final apiUrl = apiUrlJson['config_url'];

      // get url parameters
      //print("url=" + apiUrl);
      final http.Response response = await _client.get(Uri.parse(apiUrl));
      final String body = response.body;
      //print("body=" + body);
      final json = jsonDecode(body);
      if (json.length > 0) {
        categoryFontSize = double.parse(json[0]['categoryFontSize']);
        categoryFontColor =
            Color(int.parse(json[0]['categoryFontColor'], radix: 16));
        questionFontSize = double.parse(json[0]['questionFontSize']);
        optionFontSize = double.parse(json[0]['optionFontSize']);
        homeTitleText = json[0]['homeTitleText'];
        customizeTitleText = json[0]['customizeTitleText'];
        luckyText = json[0]['luckyText'];
        homeParagraph1 = json[0]['homeParagraph1'];
        homeParagraph1FontSize =
            double.parse(json[0]['homeParagraph1FontSize']);
        homeParagraph2 = json[0]['homeParagraph2'];
        homeParagraph2FontSize =
            double.parse(json[0]['homeParagraph2FontSize']);
        minCount = double.parse(json[0]['minCount']);
        maxCount = double.parse(json[0]['maxCount']);
      }
      assert(categoryFontSize != null &&
          categoryFontColor != null &&
          questionFontSize != null &&
          optionFontSize != null &&
          homeTitleText != null &&
          customizeTitleText != null &&
          luckyText != null &&
          homeParagraph1 != null &&
          homeParagraph1FontSize != null &&
          homeParagraph2 != null &&
          homeParagraph2FontSize != null &&
          minCount != null &&
          maxCount != null);
      _loaded = true;
      return true;
    }
  }
}
