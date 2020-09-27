import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ExerciseItem extends Card {

  static Text showDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      "$twoDigitMinutes:$twoDigitSeconds",
      style: TextStyle(color: Colors.black87, fontSize: 18, height: 1.5),
    );
  }

  ExerciseItem({Key key, String title, int totalDuration, String image})
      : super(
          key: key,
          color: Colors.white,
          elevation: 0.5,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    height: 90,
                    width: 100,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            height: 1.8),
                      ),
                      showDuration(Duration(seconds: totalDuration)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
}
