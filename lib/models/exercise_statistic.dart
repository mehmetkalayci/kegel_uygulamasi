import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ExerciseStatistic {
  Timestamp date;
  String description;
  String title;
  int totalDuration;

  getOnlyDate(){
    return new DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(this.date.millisecondsSinceEpoch));
  }

  ExerciseStatistic(
      {this.date, this.description, this.title, this.totalDuration});

  ExerciseStatistic.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    description = json['description'];
    title = json['title'];
    totalDuration = json['totalDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['description'] = this.description;
    data['title'] = this.title;
    data['totalDuration'] = this.totalDuration;
    return data;
  }
}