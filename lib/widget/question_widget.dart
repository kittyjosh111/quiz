import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quiz/model/question.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';

class QuestionWidget extends StatefulWidget {
  final Question _question;
  final ValueChanged<bool> _answer;

  const QuestionWidget(
      {@required Question question,
      @required ValueChanged<bool> answer,
      Key key})
      : this._question = question,
        this._answer = answer,
        assert(question != null),
        assert(answer != null),
        super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  List<Option> options;
  List<Widget> optionWidgets;
  List<Color> colors;
  List<Widget> resultIcons;
  final color = Colors.deepPurple;
  final correctColor = Colors.green;
  final wrongColor = Colors.red;
  Widget correctIcon;
  Widget wrongIcon;
  var correctAnswerIndex;
  var answered;

  @override
  void initState() {
    super.initState();

    options = widget._question.options;
    optionWidgets = [];
    colors = [];
    resultIcons = [];
    correctAnswerIndex = 0;
    answered = false;

    for (int i = 0; i < options.length; ++i) {
      colors.add(color);
      resultIcons.add(Container());

      if (options[i].equals(widget._question.correctAnswer)) {
        correctAnswerIndex = i;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    options = widget._question.options;
    optionWidgets = [];
    colors = [];
    resultIcons = [];
    correctAnswerIndex = 0;
    answered = false;

    for (int i = 0; i < options.length; ++i) {
      colors.add(Theme.of(context).primaryColor);
      resultIcons.add(Container());

      if (options[i] == widget._question.correctAnswer) {
        correctAnswerIndex = i;
      }
    }
  }

  @override
  void didUpdateWidget(QuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    options = widget._question.options;
    optionWidgets = [];
    colors = [];
    resultIcons = [];
    correctAnswerIndex = 0;
    answered = false;

    for (int i = 0; i < options.length; ++i) {
      colors.add(Theme.of(context).primaryColor);
      resultIcons.add(Container());

      if (options[i] == widget._question.correctAnswer) {
        correctAnswerIndex = i;
      }
    }
  }

  Widget questionContainer(String question, BuildContext context) => Container(
        child: Container(
          padding: const EdgeInsets.only(bottom: 24),
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              alignment: Alignment.center,
              child: Container(
                child: Text(
                  question,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .color, //color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget questionImageContainer(String base64Image) => Container(
        child: Container(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              padding: EdgeInsets.only(bottom: 16),
              alignment: Alignment.center,
              child: Container(
                child: PinchZoomImage(
                  image: Image.memory(Base64Decoder().convert(base64Image)),
                  zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                  hideStatusBarWhileZooming: true,
                  onZoomStart: () {
                    //print('Zoom started');
                  },
                  onZoomEnd: () {
                    //print('Zoom finished');
                  },
                ),
                //child: Image(
                //    image: Image.memory(Base64Decoder().convert(base64Image))
                //        .image),
              ),
            ),
          ),
        ),
      );

  Widget optionWidget(
          int index, Option option, bool isCorrect, BuildContext context) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: EdgeInsets.only(bottom: index == options.length - 1 ? 8 : 16),
        child: Material(
          elevation: 10,
          color: Theme.of(context).primaryColor,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: colors[index],
              width: 2,
            ),
          ),
          child: MaterialButton(
            onPressed: answered
                ? null
                : () {
                    setState(() {
                      colors[index] = wrongColor;
                      colors[correctAnswerIndex] = correctColor;
                      resultIcons[index] = Icon(
                        Icons.cancel_outlined,
                        color: wrongColor,
                      );
                      resultIcons[correctAnswerIndex] = Icon(
                        Icons.check_circle_outline_rounded,
                        color: correctColor,
                      );

                      answered = true;
                    });

                    widget._answer(answered && index == correctAnswerIndex);
                  },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              alignment: Alignment.centerLeft,
              child: Flex(
                direction: Axis.horizontal,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      flex: 10,
                      fit: FlexFit.loose,
                      child: Column(
                          children: (option.hasText() && option.hasImage())
                              ? [
                                  //fit: BoxFit.fitWidth,
                                  Text(
                                    option.optionText,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .button
                                          .color, //color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  PinchZoomImage(
                                    image: Image.memory(Base64Decoder()
                                        .convert(option.optionImage)),
                                    zoomedBackgroundColor:
                                        Color.fromRGBO(240, 240, 240, 1.0),
                                    hideStatusBarWhileZooming: true,
                                    onZoomStart: () {
                                      //print('Zoom started');
                                    },
                                    onZoomEnd: () {
                                      //print('Zoom finished');
                                    },
                                  ),
                                ]
                              : (option.hasText())
                                  ? [
                                      Text(
                                        option.optionText,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .button
                                              .color, //color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ]
                                  : [
                                      PinchZoomImage(
                                        image: Image.memory(Base64Decoder()
                                            .convert(option.optionImage)),
                                        zoomedBackgroundColor:
                                            Color.fromRGBO(240, 240, 240, 1.0),
                                        hideStatusBarWhileZooming: true,
                                        onZoomStart: () {
                                          //print('Zoom started');
                                        },
                                        onZoomEnd: () {
                                          //print('Zoom finished');
                                        },
                                      ),
                                    ])),
                  Flexible(
                    flex: 1,
                    child: resultIcons[index],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    optionWidgets = List.generate(options.length, (i) {
      //String option = HtmlUnescape().convert(options[i].optionText);
      return options[i].equals(widget._question.correctAnswer)
          ? optionWidget(i, options[i], true, context)
          : optionWidget(i, options[i], false, context);
    });

    return widget._question.questionImage != ''
        ? SingleChildScrollView(
            child: Container(
            child: Column(
              children: [
                    questionContainer(
                        HtmlUnescape().convert(widget._question.question),
                        context)
                  ] +
                  [questionImageContainer(widget._question.questionImage)] +
                  optionWidgets,
            ),
          ))
        : SingleChildScrollView(
            child: Container(
            child: Column(
              children: [
                    questionContainer(
                        HtmlUnescape().convert(widget._question.question),
                        context)
                  ] +
                  optionWidgets,
            ),
          ));
  }
}
