import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/service/quiz_customizer_cubit.dart';
import 'package:quiz/theme/ThemeItem.dart';
import 'package:quiz/view/customize_quiz_page.dart';
import 'package:quiz/view/home_page.dart';
import 'package:quiz/view/quiz_page.dart';
import 'package:quiz/view/score_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        themeCollection: themeCollection,
        defaultThemeId: AppThemes.LightPurpleAmber, // optional, default id is 0
        builder: (context, theme) {
          return BlocProvider.value(
            value: QuizCustomizerCubit(),
            child: MaterialApp(
                title: "Quiz",
                debugShowCheckedModeBanner: false,
                initialRoute: HomePage.routeName,
                routes: {
                  HomePage.routeName: (context) => HomePage(),
                  CustomizeQuizPage.routeName: (context) => CustomizeQuizPage(),
                  QuizPage.routeName: (context) => QuizPage(),
                  ScorePage.routeName: (context) => ScorePage(),
                },
                onGenerateRoute: (settings) {
                  String routeName = settings.name;

                  if (routeName == HomePage.routeName) {
                    return MaterialPageRoute(builder: (_) => HomePage());
                  } else if (routeName == CustomizeQuizPage.routeName) {
                    return PageRouteBuilder(
                        pageBuilder: (_, __, ___) => CustomizeQuizPage(),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration: Duration(milliseconds: 4000));
                  } else if (routeName == QuizPage.routeName) {
                    return MaterialPageRoute(builder: (_) => QuizPage());
                  } else if (routeName == QuizPage.routeName) {
                    return MaterialPageRoute(builder: (_) => ScorePage());
                  }

                  return null;
                },
                theme: theme),
          );
        });
  }
}
