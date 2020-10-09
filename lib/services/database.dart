import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kegelapp/models/user.dart';
import 'package:kegelapp/models/week.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  void saveProfile(String uid, int age, String gender, int height, int hydration, int weight) async {
    await _db.collection('users').document(uid).setData({
      'age': age,
      'gender': gender,
      'height': height,
      'hydrationGoal': hydration,
      'weight': weight
    });
  }

  Future<User> getProfile(String uid) async {
    DocumentSnapshot profile =
        await _db.collection('users').document(uid).get();
    return User.fromJson(profile.data);
  }

  Stream<QuerySnapshot> getExercises() {
    return _db.collection('exercises').orderBy('name').snapshots();
  }

  void saveStatisticExercise(String uid, Exercise exercise) {
    var now = DateTime.now();

    _db.collection('users').document(uid).collection('exercise').add({
      'date': now,
      'title': exercise.statisticDetail,
      'totalDuration': exercise.totalDuration
    });
  }

  void saveStatisticWater(String uid, int amount, String beverage) {
    var now = DateTime.now();

    _db.collection('users').document(uid).collection('water').add({
      'date': now,
      'amount': amount,
      'beverage': beverage
    });
  }

  void deleteTodaysWaterStatistic(String uid, String docID) {
    _db.collection('users').document(uid).collection('water').document(docID).delete();
  }

  Stream<QuerySnapshot> getTodaysWaterStatistics(String uid){
    DateTime _now = DateTime.now();
    DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);
    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);

    return _db.collection('users')
        .document(uid)
        .collection('water')
        .where('date', isGreaterThanOrEqualTo: _start)
        .where('date', isLessThanOrEqualTo: _end)
        .orderBy('date', descending: true)
        .snapshots();
  }

  void addNotification(String uid, int hour, int minute, int id) {
    var now = DateTime.now();

    _db.collection('users').document(uid).collection('notifications').add({
      'date': now,
      'hour': hour,
      'minute' : minute,
      'status': true,
      'id': int.parse(hour.toString() + minute.toString())
    });
  }

  void changeStatusOfNotification(String uid, String docID, bool status) {
    _db.collection('users').document(uid).collection('notifications').document(docID).updateData({
      'status': status,
    });
  }

  void deleteNotification(String uid, String docID) {
    _db.collection('users').document(uid).collection('notifications').document(docID).delete();
  }

  Stream<QuerySnapshot> getNotifications(String uid){
    return _db.collection('users').document(uid).collection('notifications').snapshots();
  }

}
