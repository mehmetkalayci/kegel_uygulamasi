import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:kegelapp/helpers/constants.dart';
import 'package:kegelapp/main.dart';
import 'package:kegelapp/models/received_notification.dart';
import 'package:kegelapp/screens/about.dart';
import 'package:kegelapp/screens/exercise.dart';
import 'package:kegelapp/screens/profile.dart';
import 'package:kegelapp/screens/settings.dart';
import 'package:kegelapp/screens/statistic.dart';
import 'package:kegelapp/screens/water.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final MethodChannel platform =  MethodChannel('crossingthestreams.io/resourceResolver');

  @override
  void initState()  {
    super.initState();

    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // IOS
  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream.listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null ? Text(receivedNotification.title) : null,
          content: receivedNotification.body != null ? Text(receivedNotification.body) : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Tamam'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
        ),
      );
    });
  }

  // ANDROID
  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      return new AlertDialog(
        title: Text("PayLoad"),
        content: Text("Payload : $payload"),
      );
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }




  /*****************************************/

  int _currentIndex = 0;

  Widget _getPage() {
    switch (_currentIndex) {
      case 0:
//        return StatisticsPage();
        return ExercisePage();
      case 1:
        return StatisticsPage();
      case 2:
        return WaterPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(Constants.APP_TITLE,  style: TextStyle(fontSize: 22, color: Colors.black)),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (selectedValue) {
              switch (selectedValue) {
                case 1:
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: ProfilePage()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: SettingsPage()),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: AboutPage()),
                  );
                  break;
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Profil"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Ayarlar"),
              ),
              PopupMenuItem(
                value: 3,
                child: Text("Nasıl Kullanılır?"),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5),
                _getPage(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black54,
        selectedIconTheme: IconThemeData(size: 28, color: Colors.pink),
        unselectedIconTheme: IconThemeData(size: 24, color: Colors.black54),
        onTap: (index) {
          setState(() {
            this._currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/images/heart.png")),
            title: Text('Egzersiz'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/images/line-chart.png")),
            title: Text('İstatistik'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/images/water-glass.png")),
            title: Text('İçecek'),
          ),
        ],
      ),
    );
  }
}
