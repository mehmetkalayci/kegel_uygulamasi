import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:kegelapp/helpers/constants.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
        title: Text('Nasıl Kullanılır?',  style: TextStyle(fontSize: 22, color: Colors.black)),
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
                  Text('Program neyi hedeflemektedir?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(
                      'Pelvik taban egzersizleri sayesinde güçlendirdiğiniz pelvik taban kaslarınız, idrarınızı kontrol etmenize yardımcı olur; idrar kaçırma problemini ortadan kaldırır.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 17)),
                  Divider(),
                  Text('Pelvik taban kaslarını nasıl buluruz?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(
                      'İdrarınızın geldiği zaman tuvalete oturun. Hızlı bir şekilde idrarınızı bırakın ve geri çekin. İdrarınızı durduğunuz ve geri çektiğiniz sırada bir kasılma hissedeceksiniz. Kasılmanın meydana geldiği yer pelvik kasıdır. Bu hareketi pelvik kasınızı bulduğunuzu anladığınız ana kadar tekrarlayın.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 17)),
                  Divider(),
                  Text('Pelvik taban egzersizleri nasıl yapılmalıdır?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(
                      '''Pelvik taban egzersizlerine ilk olarak mesaneyi boşaltma işlemiyle başlamanız gerekir. İdrarınızı boşaltırken 10 a kadar sayın ve pelvik kaslarınızı kasın. Daha sonra pelvik kaslarını tamamen genişleterek 10 a kadar sayın. Bu egzersizleri idrarınızın geldiğinde günde 3 veya 4 defa tekrarlayabilirsiniz.
          
Pelvik kaslarını bulmakta çoğu kadın zorlanır. Bu nedenle yapılan egzersizler çoğu zaman bir işe yaramaz. Bazı kadınlar egzersiz sırasında pelvik kaslarını çalıştırmak yerine karın ve uyluk kaslarını çalıştırırlar. Bu yapıların ise pelvik kaslarını güçlendirecek hiçbir etkisi bulunmamaktadır. Dolayısıyla pelvik bilinmezse egzersizlerin hiçbir anlamı kalmaz.''',
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
