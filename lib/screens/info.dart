import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
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
        title: Text('Nasıl Kullanılır?',
            style: TextStyle(fontSize: 22, color: Colors.black)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Pelvik Taban nedir ve neden önemlidir?',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  Text(
                      '''Vajen girişindeki kaslarınızı güçlendirmeye yönelik 2 farklı egzersiz yapmanız gerekmektedir. Birinci egzersiz kaslarınızı hızlı kasmanıza yönelik olup; ikinci egzersiz ise kaslarınızı yavaş kasmanıza yöneliktir.
                      
Egzersizlerinizi dizler bükülü ve sırt destekli oturma pozisyonunda yapmalısınız.

Vajen girişi ve bağırsak çıkışı etrafındaki kaslara konsantre olun ama bu sırada karın ve bacak kaslarınızı kasmamaya dikkat edin. Bu egzersizi doğru yaptığınızı, pelvik taban kaslarınızı çalıştırdığınızı anlamak için sadece bir defaya mahsus idrarınızı yaparken idrarınızı tutun ya da başaramıyorsanız idrar akımınızı yavaşlatmaya çalışın ve sonra gevşetin idrarı yapmaya devam edin. Siz idrarınızı tutup bırakırken kasıp gevşettiğiniz kaslarınız pelvik taban kaslarınızdır. Yani idrarınızı tutarken pelvik taban kaslarınızı kasmakta, yaparken gevşetmektesiniz. Aynı şekilde bağırsaktan gaz çıkışını tutmanızı sağlayan kaslar pelvik taban kaslarıdır.

Kasların yerini keşfettikten sonra, temel egzersiz olan kasılmaları uygulamaya başlayın. Alıştırmalara devam ettiğiniz sürece pelvik taban kas kuvvetiniz artacaktır.
                      ''',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 17)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
