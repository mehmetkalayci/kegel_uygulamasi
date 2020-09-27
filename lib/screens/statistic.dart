import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:kegelapp/models/exercise_statistic.dart';
import 'package:kegelapp/models/water_statistic.dart';
import 'package:kegelapp/providers/auth.dart';
import 'package:provider/provider.dart';
import "package:collection/collection.dart";

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with TickerProviderStateMixin {
  List _selections = [
    "Son 7 gün",
    "Son 15 gün",
    "Son 30 gün",
    "Tüm Zamanlar",
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentSelection;
  TabController controller;

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = getDropDownMenuItems();
    _currentSelection = _dropDownMenuItems[0].value;
    controller = new TabController(length: 2, vsync: this);
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String item in _selections) {
      items.add(new DropdownMenuItem(value: item, child: new Text(item)));
    }
    return items;
  }

  void changedDropDownItem(String selectedItem) {
    setState(() {
      _currentSelection = selectedItem;

      switch (selectedItem) {
        case 'Son 7 gün':
          _daysAgo = 7;
          break;
        case 'Son 15 gün':
          _daysAgo = 15;
          break;
        case 'Son 30 gün':
          _daysAgo = 30;
          break;
        case 'Tüm Zamanlar':
          _daysAgo = 3650;
          break;
        default:
          break;
      }
    });

    getWaterData(authProvider.user.uid, daysAgo: _daysAgo);
    getExerciseData(authProvider.user.uid, daysAgo: _daysAgo);
  }

  Stream<List<WaterStatistic>> getWaterData(String uid, {int daysAgo = 7}) {
    DateTime _now = DateTime.now();
    DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);
    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    _start = _start.subtract(Duration(days: _daysAgo));

    var ref = Firestore.instance
        .collection('users')
        .document(uid)
        .collection('water')
        .where('date', isGreaterThanOrEqualTo: _start)
        .where('date', isLessThanOrEqualTo: _end)
        .orderBy('date')
        .snapshots();

    return ref.map((list) => list.documents
        .map((doc) => WaterStatistic.fromJson(doc.data))
        .toList());
  }

  Stream<List<ExerciseStatistic>> getExerciseData(String uid,
      {int daysAgo = 7}) {
    DateTime _now = DateTime.now();
    DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);
    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    _start = _start.subtract(Duration(days: _daysAgo));

    var ref = Firestore.instance
        .collection('users')
        .document(uid)
        .collection('exercise')
        .where('date', isGreaterThanOrEqualTo: _start)
        .where('date', isLessThanOrEqualTo: _end)
        .orderBy('date')
        .snapshots();

    return ref.map((list) => list.documents
        .map((doc) => ExerciseStatistic.fromJson(doc.data))
        .toList());
  }

  List<charts.Series<dynamic, String>> _getWaterStats(
      List<WaterStatistic> data) {
    return [
      new charts.Series<WaterStatistic, String>(
        id: 'water',
        domainFn: (WaterStatistic waterStat, _) => DateFormat.yMMMd().format(
            DateTime.fromMillisecondsSinceEpoch(
                waterStat.date.millisecondsSinceEpoch)),
        measureFn: (WaterStatistic waterStat, _) => waterStat.amount,
        displayName: 'Sıvı Tüketimi (ml)',
        seriesColor: charts.ColorUtil.fromDartColor(Colors.pink),
        data: data,
      ),
    ];
  }

  List<charts.Series<dynamic, String>> _getExerciseStats(
      List<ExerciseStatistic> data) {
    return [
      new charts.Series<ExerciseStatistic, String>(
        id: 'exercise',
        domainFn: (ExerciseStatistic waterStat, _) => DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(waterStat.date.millisecondsSinceEpoch)),
        measureFn: (ExerciseStatistic waterStat, _) => waterStat.totalDuration/60,
        displayName: 'Alıştırma (dk)',
        seriesColor: charts.ColorUtil.fromDartColor(Colors.pink),
        data: data,
      ),
    ];
  }

  int _daysAgo = 7;
  AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of(context);

    return Column(
      children: <Widget>[
        DefaultTabController(
          length: 2,
          child: TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black38,
            indicatorWeight: 2,
            controller: controller,
            tabs: [
              Tab(text: 'Alıştırma İstatistikleri'),
              Tab(text: 'Sıvı Tüketim İstatistikleri'),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height - 200,
          child: TabBarView(
            controller: controller,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            style:
                                TextStyle(fontSize: 18, color: Colors.black87),
                            isExpanded: true,
                            value: _currentSelection,
                            items: _dropDownMenuItems,
                            onChanged: changedDropDownItem,
                            icon: Icon(Icons.filter_list),
                          ),
                        ),
                        StreamBuilder(
                          stream: getExerciseData(authProvider.user.uid),
                          builder: (context,
                              AsyncSnapshot<List<ExerciseStatistic>> snapshot) {
                            if (snapshot.hasData) {
                              Map<String, List<ExerciseStatistic>> newMap =
                                  groupBy(
                                      snapshot.data,
                                      (ExerciseStatistic obj) =>
                                          obj.getOnlyDate());

                              List<ExerciseStatistic> actualList = [];

                              newMap.values.forEach((el) {
                                el.forEach((element) {
                                  int toplamSure = el.fold(
                                      0,
                                      (previousValue, element) =>
                                          previousValue +
                                          element.totalDuration);

                                  ExerciseStatistic temp = ExerciseStatistic(
                                    date: element.date,
                                    totalDuration: toplamSure,
                                  );

                                  actualList.add(temp);
                                });
                              });

                              return Container(
                                height: 400,
                                child: new charts.BarChart(
                                  _getExerciseStats(actualList),
                                  animate: true,
                                  domainAxis: charts.OrdinalAxisSpec(
                                    renderSpec: charts.SmallTickRendererSpec(
                                        labelRotation: 45),
                                    viewport:
                                        new charts.OrdinalViewport('AePS', 7),
                                  ),
                                  behaviors: [
                                    new charts.SeriesLegend(position: charts.BehaviorPosition.bottom),
                                    new charts.SlidingViewport(),
                                    new charts.PanAndZoomBehavior(),

                                  ],
                                ),
                              );
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),

              /* SAYFA 2 */

              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            style:
                                TextStyle(fontSize: 18, color: Colors.black87),
                            isExpanded: true,
                            value: _currentSelection,
                            items: _dropDownMenuItems,
                            onChanged: changedDropDownItem,
                            icon: Icon(Icons.filter_list),
                          ),
                        ),
                        StreamBuilder(
                          stream: getWaterData(authProvider.user.uid),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(
                                  'HATA OLUŞTU!\n' + snapshot.error.toString());
                            } else {
                              if (snapshot.hasData) {
                                Map<String, List<WaterStatistic>> newMap =
                                    groupBy(
                                        snapshot.data,
                                        (WaterStatistic obj) =>
                                            obj.getOnlyDate());

                                List<WaterStatistic> actualList = [];

                                newMap.values.forEach((el) {
                                  el.forEach((element) {
                                    int toplam = el.fold(
                                        0,
                                        (previousValue, element) =>
                                            previousValue + element.amount);

                                    WaterStatistic temp = WaterStatistic(
                                        date: element.date, amount: toplam);

                                    actualList.add(temp);
                                  });
                                });

                                return Container(
                                  height: 400,
                                  child: new charts.BarChart(
                                    _getWaterStats(actualList),
                                    animate: true,
                                    domainAxis: charts.OrdinalAxisSpec(
                                      renderSpec: charts.SmallTickRendererSpec(
                                          labelRotation: 45),
                                      viewport:
                                          new charts.OrdinalViewport('AePS', 7),
                                    ),
                                    behaviors: [
                                      new charts.SeriesLegend(
                                          position:
                                              charts.BehaviorPosition.bottom),
                                      new charts.SlidingViewport(),
                                      new charts.PanAndZoomBehavior(),
                                    ],
                                  ),
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}