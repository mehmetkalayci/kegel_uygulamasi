
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kegelapp/models/day.dart';
import 'package:kegelapp/screens/exercise_detail.dart';
import 'package:kegelapp/services/database.dart';
import 'package:kegelapp/widgets/exercise_item.dart';
import 'package:page_transition/page_transition.dart';

class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> with TickerProviderStateMixin  {
  TabController controller;

  @override
  void initState() {
    super.initState();
  }

  DatabaseService db = DatabaseService();
  
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
        stream: db.getExercises(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:

              List<Day> days = snapshot.data.documents.map((e) => Day.fromJson(e.data)).toList();

              controller = new TabController(length: days.length, vsync: this);

              return Column(
                children: <Widget>[
                  DefaultTabController(
                    length: days.length,
                    child: TabBar(
                      indicatorColor: Colors.black,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black38,
                      indicatorWeight: 2,
                      isScrollable: true,
                      controller: controller,
                      tabs: [
                        for(var item in days) new Tab(text: item.name),
                      ],
                    ),
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height-200,
                    child: TabBarView(
                      controller: controller,
                      children: [
                        for(var item in days)
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  for(var exercise in item.exercises)
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
                                      child: ExerciseItem(title:exercise.title, totalDuration:exercise.totalDuration, image:exercise.coverImage),
                                    )
                                ],
                              ),
                            ),

                      ],
                    ),
                  )
                ],
              );


          }
        },
      );
  }
}