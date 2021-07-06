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

  Brightness brightness;
  Color primaryColor;
  Color accentColor;
  Color backgroundColor;
  Color scaffoldBackgroundColor;
  Color textColor;
  Color quitButtonColor;
  Color nextButtonColor;
  double categoryFontSize;
  Color luckyTextColor;
  Color luckyBackgroundColor;
  Color optionColor;
  Color optionCorrectColor;
  Color optionWrongColor;
  double questionFontSize;
  double optionFontSize;

  Future<void> loadConfig() async {
    if (_loaded) {
      return;
    } else {
      // get question api url first
      final http.Response apiUrlResponse = await _client.get(Uri.parse(
          'https://raw.githubusercontent.com/kittyjosh111/biology_app_config/master/questions_api_url.json'));
      final String apiUrlBody = apiUrlResponse.body;
      final apiUrlJson = jsonDecode(apiUrlBody);
      final apiUrl = apiUrlJson['config_url'];

      // get url parameters
      print("url=" + apiUrl);
      final http.Response response = await _client.get(Uri.parse(apiUrl));
      final String body = response.body;
      //print("body=" + body);
      final json = jsonDecode(body);
      if (json.length > 0) {
        brightness = json[0]['brightness'] == 'dark'
            ? Brightness.dark
            : Brightness.light;
        primaryColor = Color(int.parse(json[0]['primaryColor'], radix: 16));
        accentColor = Color(int.parse(json[0]['accentColor'], radix: 16));

        backgroundColor =
            Color(int.parse(json[0]['backgroundColor'], radix: 16));
        scaffoldBackgroundColor =
            Color(int.parse(json[0]['scaffoldBackgroundColor'], radix: 16));
        textColor = Color(int.parse(json[0]['textColor'], radix: 16));
        quitButtonColor =
            Color(int.parse(json[0]['quitButtonColor'], radix: 16));
        nextButtonColor =
            Color(int.parse(json[0]['nextButtonColor'], radix: 16));
        categoryFontSize = double.parse(json[0]['categoryFontSize']);
        luckyTextColor = Color(int.parse(json[0]['luckyTextColor'], radix: 16));
        luckyBackgroundColor =
            Color(int.parse(json[0]['luckyBackgroundColor'], radix: 16));
        optionColor = Color(int.parse(json[0]['optionColor'], radix: 16));
        optionCorrectColor =
            Color(int.parse(json[0]['optionCorrectColor'], radix: 16));
        optionWrongColor =
            Color(int.parse(json[0]['optionWrongColor'], radix: 16));
        questionFontSize = double.parse(json[0]['questionFontSize']);
        optionFontSize = double.parse(json[0]['optionFontSize']);
      }
      assert(brightness != null &&
          primaryColor != null &&
          accentColor != null &&
          backgroundColor != null &&
          scaffoldBackgroundColor != null &&
          textColor != null &&
          quitButtonColor != null &&
          nextButtonColor != null &&
          categoryFontSize != null &&
          luckyTextColor != null &&
          luckyBackgroundColor != null &&
          optionColor != null &&
          optionCorrectColor != null &&
          optionWrongColor != null &&
          questionFontSize != null &&
          optionFontSize != null);
      _loaded = true;
      return;
    }
  }
}
