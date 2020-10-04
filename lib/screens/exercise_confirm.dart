import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:kegelapp/models/week.dart';
import 'package:kegelapp/providers/auth.dart';
import 'package:kegelapp/screens/exercise.dart';
import 'package:kegelapp/services/database.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ExerciseConfirmPage extends StatelessWidget {
  final Exercise _exercise;

  const ExerciseConfirmPage(this._exercise, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 75),
            Image.asset(
              'assets/images/question.png',
              width: 125,
              height: 125,
            ),
            SizedBox(height: 40),
            Text(
              this._exercise.title,
              style: TextStyle(
                  fontSize: 32, height: 1, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 40),
            Text(
              'Alıştırmayı tamamladıysan lütfen onayla!',
              style: TextStyle(fontSize: 24, height: 1.5),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.red,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.clear),
                    color: Colors.white,
                    iconSize: 40,
                    onPressed: () {
                      Navigator.pop(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: ExercisePage(),
                        ),
                      );
                    },
                  ),
                ),
                Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.lightGreen,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.done),
                    color: Colors.white,
                    iconSize: 40,
                    onPressed: () {

                      DatabaseService _db = DatabaseService();
                      _db.saveStatisticExercise(authProvider.user.uid, this._exercise);


                      Navigator.pop(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: ExercisePage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}