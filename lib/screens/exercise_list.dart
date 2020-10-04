import 'package:flutter/material.dart';
import 'package:kegelapp/models/week.dart';
import 'package:kegelapp/screens/exercise_detail.dart';
import 'package:kegelapp/widgets/exercise_item.dart';
import 'package:page_transition/page_transition.dart';

class ExerciseList extends StatelessWidget {

  final List<Exercise> exercises;
  ExerciseList({Key key, @required this.exercises}): super(key: key);




  @override
  Widget build(BuildContext context) {

    this.exercises.forEach((element) {
      debugPrint(element.toString());
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text('Alıştırmalar',
            style: TextStyle(fontSize: 22, color: Colors.black)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[



                  for (var exercise in this.exercises)
                    GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: ExerciseDetailPage(exercise),
                        ),
                      );
                    },
                    child: ExerciseItem(
                        title: exercise.title,
                        image: exercise.coverImage,
                        totalDuration: exercise.totalDuration),
                  )


                ]),
          ),
        ),
      ),
    );
  }
}
