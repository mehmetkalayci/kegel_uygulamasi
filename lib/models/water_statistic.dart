import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class WaterStatistic {
  int amount;
  Timestamp date;

  WaterStatistic({this.amount, this.date});

  getOnlyDate(){
    return new DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(this.date.millisecondsSinceEpoch));
  }

  WaterStatistic.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['date'] = this.date;
    return data;
  }
}
