import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kegelapp/providers/auth.dart';
import 'package:kegelapp/screens/profile.dart';
import 'package:kegelapp/services/database.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {

  Widget _pageIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.pinkAccent : Colors.black26,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _pageBody(String title, String content, String image) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Center(
            child: Image.asset(
              image,
              height: 200,
            ),
          ),
          SizedBox(height: 30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24,
                height: 1.5,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
          SizedBox(height: 10),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, height: 1.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  final int _numPages = 3;
  int _currentPage = 0;
  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

    AuthProvider authProvider = Provider.of(context);


    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 450,
              child: PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      this._currentPage = page;
                    });
                  },
                  children: <Widget>[
                    _pageBody(
                        "Pelvik Taban Egzersizleri \nUygulamasına Hoşgeldiniz!",
                        "Pelvik taban egzersizleri sayesinde güçlendirdiğiniz pelvik taban kaslarınız, idrarınızı kontrol etmenize yardımcı olur.",
                        "assets/images/3.png"),
                    _pageBody(
                        "Nasıl Çalışır?",
                        "Kasların yerini keşfettikten sonra, temel egzersiz olan kasılmaları uygulamaya başlayın. Alıştırmalara devam ettiğiniz sürece pelvik kası gücünüz artacaktır.",
                        "assets/images/2.png"),
                    _pageBody(
                        "Profil Oluşturun",
                        "Başlamadan önce günlük su ihtiyacını ve istatistiklerini takip etmek için profil oluşturmalısın.",
                        "assets/images/4.png"),
                  ]),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(this._numPages,
                      (index) => _pageIndicator(index == _currentPage)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              heightFactor: 1.75,
              child: ButtonTheme(
                minWidth: 250,
                height: 50,
                child: RaisedButton(
                    onPressed: () async {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );


                      if (_currentPage == _numPages - 1) {
                        try {

                          await authProvider.signInAnonymously().then((value) {
                            String uid = value.user.uid;

                            DatabaseService db = DatabaseService();
                            db.saveProfile(uid, 0, '-', 0, 0, 0);

                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: ProfilePage(),
                              ),
                            );

                          });
                        } catch (e) {
                          switch (e.code) {
                            case 'ERROR_NETWORK_REQUEST_FAILED':
                              Fluttertoast.showToast(
                                  msg: "İnternet bağlantınızı kontrol edin!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1);
                              break;
                            default:
                              Fluttertoast.showToast(
                                  msg: "Hata oluştu!\n" + e.toString(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1);
                              break;
                          }
                        }

                      }





                    },
                    color: Colors.pink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: _currentPage < _numPages - 1
                        ? Text("İleri",
                        style: TextStyle(fontSize: 15, color: Colors.white))
                        : Text("Haydi Başlayalım",
                        style:
                        TextStyle(fontSize: 15, color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
