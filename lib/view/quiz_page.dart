import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz/model/question.dart';
import 'package:quiz/model/question_parameter.dart';
import 'package:quiz/model/result.dart';
import 'package:quiz/service/question_service_provider.dart';
import 'package:quiz/view/score_page.dart';
//import 'package:quiz/widget/clock.dart';
import 'package:quiz/widget/question_widget.dart';

class QuizPage extends StatelessWidget {
  static const routeName = "/quizPage";

  Widget questionCounter(
      {@required int totalCount,
      @required int currentIndex,
      BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question ${currentIndex + 1}/$totalCount",
            style: TextStyle(
              //color: Colors.white,
              fontSize: 24,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: Row(
              children: List<Widget>.generate(
                totalCount,
                (index) {
                  Color color = index == currentIndex
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor;

                  return Expanded(
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 4,
                        color: color),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MaterialButton(
            color: Theme.of(context).accentColor,
            child: Row(
              children: [
                Icon(Icons.power_settings_new),
                SizedBox(width: 8),
                Text("Quit",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.button.color)),
              ],
            ),
            onPressed: () {
              Navigator.of(context)
                  .popUntil((route) => route.settings.name == '/');
            },
          ),
          /*
          Clock(
            onTimerEnd:
                Provider.of<QuestionServiceProvider>(context).nextQuestion,
          ),
          */
          MaterialButton(
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Text("Next",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.button.color)),
                SizedBox(width: 8),
                Icon(Icons.navigate_next),
              ],
            ),
            onPressed:
                Provider.of<QuestionServiceProvider>(context).nextQuestion,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final QuizParameter quizParameter =
        ModalRoute.of(context).settings.arguments as QuizParameter;

    return ChangeNotifierProvider<QuestionServiceProvider>(
      create: (_) => QuestionServiceProvider(),
      builder: (context, child) {
        QuestionServiceProvider questionService =
            Provider.of<QuestionServiceProvider>(context);
        int index = questionService.index;
        int count = questionService.count;
        bool loading = questionService.loading;
        bool completed = questionService.completed;

        if (completed) {
          questionService.refreshCompleted(false);
          WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback(
            (timeStamp) {
              Navigator.of(context).pushNamed(
                ScorePage.routeName,
                arguments: Result(
                  marksObtained: questionService.score,
                  totalMarks: questionService.count,
                ),
              );
            },
          );

          return Container();
        }

        if (loading) {
          questionService.fetchQuestion(quizParameter);

          return new Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: new EdgeInsets.all(32.0),
            child: new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(
                    "Welcome to",
                    style: Theme.of(context).textTheme.headline6,
                    maxLines: 2,
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: AutoSizeText(
                        "USABO/biology Quiz",
                        style: Theme.of(context).textTheme.headline5,
                        maxLines: 2,
                      )),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: AutoSizeText(
                        "questions reused with permission from CEE",
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 2,
                      )),
                  /*
                  Padding(
                    padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                    child: new Image.asset('assets/images/cee.png'),
                  )
                  */
                ],
              ),
            ),
          );
        } else if (Provider.of<QuestionServiceProvider>(context)
            .noQuestions()) {
          return new Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: new EdgeInsets.all(32.0),
            child: new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(
                    "No more questions",
                    style: Theme.of(context).textTheme.headline2,
                    maxLines: 2,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0)),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MaterialButton(
                        color: Theme.of(context).accentColor,
                        child: Row(
                          children: [
                            Icon(Icons.power_settings_new),
                            SizedBox(width: 2),
                            Text("Quit",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .button
                                        .color)),
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.settings.name == '/');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          Question question = questionService.question;
          QuestionWidget questionWidget = QuestionWidget(
            question: question,
            answer: questionService.answer,
          );

          return Scaffold(
            body: SafeArea(
              child: Material(
                color: Theme.of(context)
                    .scaffoldBackgroundColor, //Colors.deepPurple,
                child: Column(
                  children: [
                    questionCounter(
                        currentIndex: index,
                        totalCount: count,
                        context: context),
                    Expanded(
                      child: questionWidget,
                    ),
                    buttons(context),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
