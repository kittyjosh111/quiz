import 'package:flutter/material.dart';
import 'package:quiz/model/config.dart';

class FeelingLuckyButton extends StatefulWidget {
  final VoidCallback _floatingActionButtonOnPressed;
  final AnimationController _animationController;

  const FeelingLuckyButton(
      {@required VoidCallback onPressed,
      @required AnimationController animationController})
      : this._floatingActionButtonOnPressed = onPressed,
        this._animationController = animationController,
        assert(onPressed != null),
        assert(animationController != null);

  @override
  _FeelingLuckyButtonState createState() => _FeelingLuckyButtonState();
}

class _FeelingLuckyButtonState extends State<FeelingLuckyButton> {
  @override
  Widget build(BuildContext context) {
    final floatingActionButtonLabelText = Text(
      Config().luckyText,
      style: TextStyle(
        color: Theme.of(context).primaryColor, //blue,
      ),
    );

    return FadeTransition(
      opacity: widget._animationController,
      child: FloatingActionButton.extended(
        label: floatingActionButtonLabelText,
        onPressed: widget._floatingActionButtonOnPressed,
        backgroundColor: Colors.white.withOpacity(0.9),
      ),
    );
  }
}
