import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kegelapp/models/week.dart';
import 'package:kegelapp/screens/exercise_list.dart';
import 'package:kegelapp/services/database.dart';
import 'package:page_transition/page_transition.dart';

class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage>
    with TickerProviderStateMixin {
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
            List<Week> weeks = snapshot.data.documents
                .map((e) => Week.fromJson(e.data))
                .toList();

            controller = new TabController(length: weeks.length, vsync: this);

            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RotatedBox(
                        quarterTurns: 3,
                        child: DefaultTabController(
                          length: weeks.length,
                          child: TabBar(
                            indicatorColor: Colors.pink,
                            labelColor: Colors.pink,
                            unselectedLabelColor: Colors.black38,
                            isScrollable: true,
                            labelStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            unselectedLabelStyle:
                                TextStyle(fontWeight: FontWeight.normal),
                            controller: controller,
                            tabs: [
                              for (var item in weeks) new Tab(text: item.name),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: MediaQuery.of(context).size.height - 200,
                          child: TabBarView(
                            controller: controller,
                            children: [
                              for (var week in weeks)
                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        week.description,
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.justify,
                                      ),
                                      SizedBox(height: 10),
                                      for (var day in week.days)
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: ExerciseList(
                                                      exercises: day.exercises),
                                                ),
                                              );

                                              debugPrint(day.name);
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 5,
                                                  height: 75,
                                                  color: Colors.pink,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          day.name,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Icon(Icons
                                                            .keyboard_arrow_right)
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ]);
        }
        return Container();
      },
    );
  }
}
