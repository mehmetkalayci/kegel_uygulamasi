import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:kegelapp/models/day.dart';
import 'package:kegelapp/screens/exercise_timer.dart';
import 'package:page_transition/page_transition.dart';

class ExerciseDetailPage extends StatefulWidget {
  final Exercise _exercise;

  const ExerciseDetailPage(this._exercise, {Key key});

  @override
  _ExerciseDetailPageState createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    this.images = widget._exercise.images;
  }

  int imageIndex = 0;

  var images = [];

  void _nextImage() {
    setState(() {
      imageIndex = (imageIndex < images.length - 1) ? ++imageIndex : 0;
      print(imageIndex);
    });
  }

  void _prevImage() {
    setState(() {
      imageIndex = (imageIndex > 0) ? --imageIndex : images.length - 1;
      print(imageIndex);
    });
  }

  Widget _buildPageIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 12,
      width: isCurrentPage ? 16 : 12,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.white70 : Colors.white30,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Text showDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      "$twoDigitMinutes:$twoDigitSeconds",
      style:      TextStyle(fontSize: 20.0, height: 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        brightness: Brightness.light,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            foregroundDecoration: BoxDecoration(color: Colors.black26),
            height: 400,
            child: CachedNetworkImage(
              imageUrl: this.images[imageIndex],
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 315,
                  child: GestureDetector(
                      onHorizontalDragEnd: (DragEndDetails details) {
                    if (details.velocity.pixelsPerSecond.dx > 0) {
                      _nextImage();
                    } else if (details.velocity.pixelsPerSecond.dx < 0) {
                      _prevImage();
                    }
                  }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget._exercise.title,
                        style: TextStyle(
                            fontSize: 28,
                            height: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: List.generate(
                            this.images.length == 1 ? 0 : this.images.length,
                            (index) =>
                                _buildPageIndicator(index == imageIndex)),
                      )
                    ],
                  ),
                ),
                ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 15.0),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Süre'.toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22.0,
                                      height: 1.5),
                                ),
                                showDuration(Duration(seconds: widget._exercise.totalDuration)),
                                SizedBox(height: 15.0),
                                Text(
                                  'Açıklama'.toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22.0,
                                      height: 1.5),
                                ),
                                Text(widget._exercise.description,
                                    textAlign: TextAlign.justify,
                                    style:
                                        TextStyle(fontSize: 20.0, height: 1.5)),
                              ],
                            ),
                          ),
                          SizedBox(height: 25),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              child: RaisedButton(
                                color: Colors.lightGreen,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      " Antrenmana Başla",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: ExerciseTimerPage(
                                          this.widget._exercise),
                                    ),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(50.0)),
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
