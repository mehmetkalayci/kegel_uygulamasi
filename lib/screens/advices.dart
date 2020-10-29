import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class AdvicesPage extends StatefulWidget {
  @override
  _AdvicesPageState createState() => _AdvicesPageState();
}

class _AdvicesPageState extends State<AdvicesPage> {
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
        title: Text('Öneriler',
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
                  Text(
                      '''1.	Aşırı çay, kahve gibi kafeinli içecekler, asitli içecekler ile baharatlı yiyecek ve aşırı alkol tüketiminden kaçınılmalıdır.

2.	Günde 2 bardaktan fazla çay, kahve ve bitki çayları gibi kafeinli içecekler idrara çıkmanızı kolaylaştırdığı ve idrar kaçırmanızı tetikleyebileceği için tüketmemeniz önemlidir.

3.	Fiziksel aktivite artırılmalı dengeli ve düzenli beslenilmelidir.

4.	Sigara tüketiminden uzak durmanız önemlidir.

5.	Kronik kabızlık ve tuvalete çıkmak için ıkınma idrar kaçırmanızı arttırır bu nedenle kabızlığı engellemek için diyete lifli gıdalar eklemeniz önerilebilir.

6.	Kendi kilonuza uygun olarak sıvı tüketmelisiniz. Aşırı sıvı alımını azaltıp, yetersiz sıvı alımı artırılmalıdır

7.	Fazla kilo mesaneniz ve idrar tutmanızı sağlayan kaslar üzerinde baskı oluşturacağı ve idrar kaçırmanızı kolaylaştıracağı için ideal kilonuzda olmanız önemlidir.

8.	Öksürme, hapşırma, gülme ve ağırlık taşıma ya da ani olarak idrara sıkışma gibi sizde idrar kaçırma yaratan aktivitelerden önce pelvik taban kaslarınızı sıkıca kasmanız ve aktivite bitene kadar sıkılı tutmaya çalışmanız kaçırma periyodlarının azalmasına yardımcı olur.

9.	İdrar kaçırmayı engellemek için sürekli idrar kesenizi boş tutmaya çalışmak yani sürekli tuvalete gitmek idrar tutma kapasitenizi azaltır. Bu yüzden pelvik taban egzersizlerini yaparak işeme saatleri arasındaki zamanı dereceli olarak arttırmaya çalışmanız önemlidir.

10.	Fizyoterapistiniz tarafından size özel olarak hazırlanan egzersizlerinizi düzenli olarak yapmanız bu problemin tedavisinin başarılı olabilmesi için oldukça önemlidir.

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
