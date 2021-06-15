import 'package:flutter/material.dart';
import 'package:quiz/model/result.dart';
import 'package:quiz/view/home_page.dart';

class ScorePage extends StatefulWidget {
  static const routeName = "/scorePage";

  const ScorePage({Key key}) : super(key: key);

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _sizeAnimation;
  Animation<double> _marginAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));

    _sizeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0, 0.3, curve: Curves.easeOut),
      ),
    );

    _marginAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.7, curve: Curves.bounceOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.7, 1, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Result result = ModalRoute.of(context).settings.arguments as Result;
    double height = MediaQuery.of(context).size.height;

    return Material(
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Column(
                    children: [
                      ScaleTransition(
                        scale: _sizeAnimation,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: _marginAnimation.value * height * 0.25,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                          ),
                          height: 150,
                          width: 150,
                          child: FittedBox(
                            child: Text(
                                "${result.marksObtained} / ${result.totalMarks}",
                                style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .fontSize,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${result.comment}",
                          style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.headline4.fontSize -
                                    4,
                          ),
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 48.0),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(HomePage.routeName);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.8),
                                    Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.8),
                                  ],
                                ),
                              ),
                              child: Text(
                                "Play Again",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
