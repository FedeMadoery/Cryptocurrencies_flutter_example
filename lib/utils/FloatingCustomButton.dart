import 'package:flutter/material.dart';

class FancyFab extends StatefulWidget {
   Function onPressedFirst;
   Function onPressedSecond;
   Function onPressedThird;
   String tooltipFirst;
   String tooltipSecond;
   String tooltipThird;
   IconData iconFirst;
   IconData iconSecond;
   IconData iconThird;

  FancyFab({
  this.onPressedFirst, this.onPressedSecond, this.onPressedThird,
  this.iconFirst, this.iconSecond, this.iconThird,
  this.tooltipFirst, this.tooltipSecond, this.tooltipThird
  });

  @override
  _FancyFabState createState() => new _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {

  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
        begin: Colors.blue,
        end: Colors.red,
        ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
            0.00,
            1.00,
            curve: Curves.linear,
            ),
        ));
    _translateButton = Tween<double>(
        begin: _fabHeight,
        end: -14.0,
        ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
            0.0,
            0.75,
            curve: _curve,
            ),
        ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget first() {
    return Container(
        child: FloatingActionButton(
            heroTag: 1,
            onPressed: widget.onPressedFirst,
            tooltip: widget.tooltipFirst,
            child: Icon(widget.iconFirst),
            ),
        );
  }

  Widget second() {
    return Container(
        child: FloatingActionButton(
            heroTag: 2,
            onPressed: widget.onPressedSecond,
            tooltip: widget.tooltipSecond,
            child: Icon(widget.iconSecond),
            ),
        );
  }

  Widget third() {
    return Container(
        child: FloatingActionButton(
            heroTag: 3,
            onPressed: widget.onPressedThird,
            tooltip: widget.tooltipThird,
            child: Icon(widget.iconThird),
            ),
        );
  }

  Widget toggle() {
    return Container(
        child: FloatingActionButton(
            heroTag: 0,
            backgroundColor: _buttonColor.value,
            onPressed: animate,
            tooltip: 'Toggle',
            child: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _animateIcon,
                ),
            ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Transform(
              transform: Matrix4.translationValues(
                  0.0,
                  _translateButton.value * 3.0,
                  0.0,
                  ),
              child: widget.iconThird != null ? third() : null,
              ),
          Transform(
              transform: Matrix4.translationValues(
                  0.0,
                  _translateButton.value * 2.0,
                  0.0,
                  ),
              child: widget.iconSecond != null ? second() : null,
              ),
          Transform(
              transform: Matrix4.translationValues(
                  0.0,
                  _translateButton.value,
                  0.0,
                  ),
              child: widget.iconFirst != null ? first() : null,
              ),
          toggle(),
        ],
        );
  }
}