import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:kegelapp/models/week.dart';
import 'package:kegelapp/screens/exercise_confirm.dart';
import 'package:kegelapp/widgets/progress_circle.dart';
import 'package:page_transition/page_transition.dart';
import 'package:screen/screen.dart';
import 'package:vibration/vibration.dart';

class ExerciseTimerPage extends StatefulWidget {
  final Exercise _exercise;

  const ExerciseTimerPage(this._exercise, {Key key}) : super(key: key);

  @override
  _ExerciseTimerState createState() => _ExerciseTimerState();
}

class _ExerciseTimerState extends State<ExerciseTimerPage>
    with TickerProviderStateMixin {

  AnimationController controller;

  Timer _timer;
  bool _timerStatus = false;

  int _indexOfSet = 0;

  int _totalRepetition;
  int _indexOfRepeat = 0;

  int _indexOfStep = 0;
  int _stepTimeRemaining = 0;

  @override
  void initState() {
    super.initState();

    _stepTimeRemaining = this.widget._exercise.sets[_indexOfSet].steps[_indexOfStep].stepDuration;
    // toplam tekrar
    _totalRepetition = this.widget._exercise.sets[_indexOfSet].repetition;

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _stepTimeRemaining),
    );


    Screen.keepOn(true);
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    setState(() {
      this._timerStatus = true;
    });
  }

  void stopTimer() {
    _timer.cancel();
    setState(() {
      this._timerStatus = false;
    });
  }

  void _getTime() {

    if (_timerStatus) {
      //controller.forward(from: controller.value == 1 ? 0 : controller.value);
      if (!mounted) return;
      setState(() {
        this._stepTimeRemaining--;
        if (this._stepTimeRemaining <= 0) {
          // bu adımın süresi bitti, sonraki adıma geç
          print('bu adımın süresi bitti, sonraki adıma geç -> ' + this.widget._exercise.sets[_indexOfSet].steps[this._indexOfStep].stepTitle + " " + this.widget._exercise.sets[_indexOfSet].steps[this._indexOfStep].stepDuration.toString() + "s");

          this._indexOfStep++;

          Vibration.vibrate(duration: 250);

          if (this._indexOfStep >= this.widget._exercise.sets[_indexOfSet].steps.length) {
            this._indexOfRepeat++;
            this._indexOfStep = 0;
            print('tüm adımlar tamamlandı, sonraki tekrara geç -> tekrar ' + this._indexOfRepeat.toString());
          }

          _stepTimeRemaining = this.widget._exercise.sets[_indexOfSet].steps[_indexOfStep].stepDuration;
        }


        if (this._indexOfRepeat >= this._totalRepetition) {


          this._indexOfSet++;
          if (this._indexOfSet < this.widget._exercise.sets.length) {
            print('sonraki set\'e geçiliyor');

            this._indexOfStep = 0;
            this._indexOfRepeat = 0;
            _stepTimeRemaining = this.widget._exercise.sets[_indexOfSet].steps[_indexOfStep].stepDuration;
            _totalRepetition = this.widget._exercise.sets[_indexOfSet].repetition;
            print('-------------------------------------------------');
          } else {
            // tüm tekrarlar tamamlandı, uygulamayı sonlandır.
            print('tüm tekrarlar tamamlandı, uygulamayı sonlandır.');
            Vibration.vibrate(duration: 250);
            _reset();
          }

        }


      });
    }
  }

  void _reset() {
    _timerStatus = false;
    _timer.cancel();
    _timer = null;

    _indexOfSet = 0;

    _indexOfRepeat = 0;
    _totalRepetition = this.widget._exercise.sets[_indexOfSet].repetition;

    _indexOfStep = 0;
    _stepTimeRemaining = this.widget._exercise.sets[_indexOfSet].steps[_indexOfStep].stepDuration;

    controller.stop();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _stepTimeRemaining),
    );

    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: ExerciseConfirmPage(this.widget._exercise),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer = null;
    Screen.keepOn(false);
  }



  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {


    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

    return Scaffold(
      backgroundColor: this._colorFromHex(this.widget._exercise.sets[_indexOfSet].steps[_indexOfStep].color),
      //extendBodyBehindAppBar: true,
      //appBar: AppBar(title: Text('Hareket 1'), centerTitle: true,),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 75, 20, 20),
        child: Stack(children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // title
                Text(this.widget._exercise.title, style: TextStyle(fontSize: 28, height: 1, fontWeight: FontWeight.w500)),

                SizedBox(height: 20),
                //Text(this.widget._exercise.definition, style: TextStyle(fontSize: 24, height: 1)),


                SizedBox(height: 20),
                Text(this.widget._exercise.sets[_indexOfSet].setTitle, style: TextStyle(fontSize: 28, height: 1, fontWeight: FontWeight.w500)),


                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                  ],
                ),

                Text("x" + this.widget._exercise.sets[_indexOfSet].repetition.toString(), style: TextStyle(fontSize: 24, height: 1)),
                SizedBox(height: 10),
                Text((this._indexOfRepeat + 1).toString() + '.tekrar', style: TextStyle(fontSize: 24, height: 1)),


                SizedBox(height: 30),
                // circle anim
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[

                    Container(
                      width: 150,
                      height: 150,
                      child: AnimatedBuilder(
                        animation: controller,
                        builder: (BuildContext context, Widget child) {
                          return CustomPaint(
                            painter: ProgressCircle(
                              animation: controller,
                              backgroundColor: Colors.grey[300],
                              color: Colors.pink,
                              strokeWidth: 8,
                            ),
                          );
                        },
                      ),
                    ),

                    Text(this._stepTimeRemaining.toString() + "s", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 45.0)),







                  ],
                ),

                SizedBox(height: 5),

                // description buraya gelsin
                Text(this.widget._exercise.sets[_indexOfSet].steps[this._indexOfStep].stepTitle, style: TextStyle(fontSize: 38, fontWeight: FontWeight.w500)),

                SizedBox(height: 20),

                // play pause button
                Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.amber,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: _timerStatus
                        ? Icon(Icons.pause)
                        : Icon(Icons.play_arrow),
                    color: Colors.white,
                    iconSize: 50,
                    onPressed: () {
                      if (_timerStatus) {
                        stopTimer();
                      } else {
                        startTimer();
                      }
                    },
                  ),
                ),

                //SizedBox(height: 20),
                //Text((this._indexOfRepeat + 1).toString() + '.tekrar', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w500, height: 1)),

              ],
            ),
          ),
        ]),
      ),
    );
  }
}