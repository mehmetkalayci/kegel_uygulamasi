import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:kegelapp/main.dart';
import 'package:kegelapp/providers/auth.dart';
import 'package:kegelapp/services/database.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<int> _showDailyAtTime(
      Time notificationTime, int notificationID) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      'description',
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        notificationID,
        'Pelvik Taban Egzersizleri',
        'Haydi, egzersiz zamanı!',
        notificationTime,
        platformChannelSpecifics);

    return notificationID;
  }

  Future<void> turnOffNotificationById(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      num id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  askToDelete(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("İptal"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );

    Widget continueButton = FlatButton(
      child: Text("Sil"),
      onPressed: () {
        Navigator.of(context).pop(true);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Upps!"),
      content: Text("Bildirim silinsin mi?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text('Ayarlar',
            style: TextStyle(fontSize: 22, color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_alert),
            onPressed: () async {
              TimeOfDay selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (BuildContext context, Widget child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child,
                    );
                  });

              if (selectedTime != null) {
                int id = int.parse(selectedTime.hour.toString() +
                    selectedTime.minute.toString());

                _db.addNotification(authProvider.user.uid, selectedTime.hour,
                    selectedTime.minute, id);
                _showDailyAtTime(
                    Time(selectedTime.hour, selectedTime.minute, 0), id);
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                    stream: _db.getNotifications(authProvider.user.uid),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return Divider(color: Colors.black45);
                          },
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    snapshot.data.documents[index].data['hour']
                                            .toString() +
                                        ':' +
                                        snapshot.data.documents[index]
                                            .data['minute']
                                            .toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Switch(
                                        value: snapshot.data.documents[index]
                                            .data['status'],
                                        onChanged: (value) {
                                          turnOffNotificationById(
                                              flutterLocalNotificationsPlugin,
                                              snapshot.data.documents[index]
                                                  .data['id']);
                                          _db.changeStatusOfNotification(
                                              authProvider.user.uid,
                                              snapshot.data.documents[index]
                                                  .documentID,
                                              value);
                                        },
                                        inactiveTrackColor: Colors.black12,
                                        inactiveThumbColor: Colors.grey,
                                        activeTrackColor: Colors.green[200],
                                        activeColor: Colors.green,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete_forever,
                                            color: Colors.red[400]),
                                        onPressed: () async {
                                          bool result =
                                              await askToDelete(this.context);
                                          if (result) {
                                            turnOffNotificationById(
                                                flutterLocalNotificationsPlugin,
                                                snapshot.data.documents[index]
                                                    .data['id']);
                                            _db.deleteNotification(
                                                authProvider.user.uid,
                                                snapshot.data.documents[index]
                                                    .documentID);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),


                ],
              )),
        ),
      ),
    );
  }
}
