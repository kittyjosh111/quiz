import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz/model/question.dart';
import 'package:quiz/model/question_parameter.dart';
import 'package:quiz/model/result.dart';
import 'package:quiz/service/question_service_provider.dart';
import 'package:quiz/view/score_page.dart';
import 'package:quiz/widget/question_widget.dart';

class QuizPage extends StatelessWidget {
  static const routeName = "/quizPage";

  Widget questionCounter({
    @required int totalCount,
    @required int currentIndex,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question ${currentIndex + 1}/$totalCount",
            style: TextStyle(
              color: Colors.white,
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
                  Color color =
                      index == currentIndex ? Colors.amber : Colors.grey;

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
          return Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          Question question = questionService.question;
          QuestionWidget questionWidget = QuestionWidget(
            question: question,
            answer: questionService.answer,
          );

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: questionService.nextQuestion,
              child: Icon(Icons.navigate_next),
            ),
            body: SafeArea(
              child: Material(
                color: Colors.deepPurple,
                child: Column(
                  children: [
                    questionCounter(
                      currentIndex: index,
                      totalCount: count,
                    ),
                    Expanded(
                      child: questionWidget,
                    ),
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
