import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kegelapp/models/user.dart';
import 'package:kegelapp/models/water_statistic.dart';
import 'package:kegelapp/providers/auth.dart';
import 'package:kegelapp/services/database.dart';
import 'package:provider/provider.dart';

class WaterPage extends StatefulWidget {
  @override
  _WaterPageState createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  DatabaseService _db = DatabaseService();

  TextEditingController _textFieldController = TextEditingController();

  TextEditingController _textFieldDrinkController = TextEditingController();
  TextEditingController _textFieldDrinkAmountController =
      TextEditingController();

  _displayAmountDialog(BuildContext context, String uid, String title) async {
    Navigator.of(context).pop();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$title (ml)'),
            content: TextField(
              controller: _textFieldController,
              maxLength: 3,
              decoration:
                  InputDecoration(hintText: "Örnek: 250 ml", suffixText: ' ml'),
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('KAYDET'),
                onPressed: () {
                  _db.saveStatisticWater(
                      uid, int.parse(_textFieldController.text), title);

                  Fluttertoast.showToast(
                      msg: _textFieldController.text +
                          ' ml ${title.toLowerCase()} eklendi!',
                      toastLength: Toast.LENGTH_SHORT);

                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _displayDrinkDialog(BuildContext context, String uid) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            //title: Text('Diğer içecek (ml)'),
            content: Container(
              height: 150,
              child: Column(
                children: [
                  TextField(
                    controller: _textFieldDrinkController,
                    maxLength: 20,
                    decoration: InputDecoration(hintText: "İçecek adı"),
                    keyboardType: TextInputType.text,
                  ),
                  TextField(
                    controller: _textFieldDrinkAmountController,
                    maxLength: 3,
                    decoration: InputDecoration(
                        hintText: "Miktar 250 ml", suffixText: ' ml'),
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('KAYDET'),
                onPressed: () {
                  _db.saveStatisticWater(
                      uid,
                      int.parse(_textFieldDrinkAmountController.text),
                      _textFieldDrinkController.text);

                  Fluttertoast.showToast(
                      msg: _textFieldDrinkAmountController.text +
                          ' ml ${_textFieldDrinkController.text.toLowerCase()} eklendi!',
                      toastLength: Toast.LENGTH_SHORT);

                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return StreamBuilder(
      stream: _db.getTodaysWaterStatistics(authProvider.user.uid),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<WaterStatistic> water = snapshot.data.documents
              .map((e) => WaterStatistic.fromJson(e.data))
              .toList();

          int sum = water.fold(
              0, (previousValue, element) => element.amount + previousValue);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                  future: _db.getProfile(authProvider.user.uid),
                  builder:
                      (BuildContext context, AsyncSnapshot<User> snapshot) {
                    if (snapshot.hasError) {
                      return Text('HATA OLUŞTU!\n' + snapshot.error.toString());
                    } else {
                      if (snapshot.hasData) {
                        if (snapshot.data.hydrationGoal == 0) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 25),
                            child: (Text(
                              'Günlük seviyenizi görmek için profil bilgilerinizi güncelleyin!',
                              textAlign: TextAlign.center,
                            )),
                          );
                        } else {
                          return Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(10),
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.black26,
                                          strokeWidth: 7,
                                          value:
                                              sum / snapshot.data.hydrationGoal,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.blue),
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            (sum /
                                                        snapshot.data
                                                            .hydrationGoal *
                                                        100)
                                                    .floor()
                                                    .toString() +
                                                ' %',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22),
                                          ),
                                        ],
                                      )
                                    ]),
                              ),
                              SizedBox(height: 30),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'HEDEFLENEN',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'TÜKETİLEN',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      snapshot.data.hydrationGoal
                                              .toInt()
                                              .toString() +
                                          ' ml',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    sum.toString() + ' ml',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )),
                                ],
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              (sum > snapshot.data.hydrationGoal)
                                  ? Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'Bugünkü hedeflenen sıvı miktarını doldurdunuz sağlığınız için daha fazla sıvı tüketmeyin.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : Container(), //Text('Sağlığınız için hedeflenen miktar kadar sıvı tüketmeye özen gösterin.', textAlign: TextAlign.center,),
                            ],
                          );
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }
                  }),
              FutureBuilder(
                  future: _db.getTodaysTeaIntakes(authProvider.user.uid),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('HATA OLUŞTU!\n' + snapshot.error.toString());
                    } else {
                      if (snapshot.hasData) {
                        List<WaterStatistic> teaIntakesList = snapshot
                            .data.documents
                            .map((e) => WaterStatistic.fromJson(e.data))
                            .toList();

                        int teaAmount = teaIntakesList.fold(
                            0,
                            (previousValue, element) =>
                                element.amount + previousValue);

                        if (teaAmount >= 300)
                          return Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Günlük 300ml den fazla çay tüketmeyin!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                      } else {
                        return Container(); //return Center(child: CircularProgressIndicator());
                      }
                      return Container();
                    }
                  }),
              FutureBuilder(
                  future: _db.getTodaysCoffeeIntakes(authProvider.user.uid),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('HATA OLUŞTU!\n' + snapshot.error.toString());
                    } else {
                      if (snapshot.hasData) {
                        List<WaterStatistic> coffeeIntakesList = snapshot
                            .data.documents
                            .map((e) => WaterStatistic.fromJson(e.data))
                            .toList();

                        int coffeeAmount = coffeeIntakesList.fold(
                            0,
                            (previousValue, element) =>
                                element.amount + previousValue);

                        if (coffeeAmount >= 300)
                          return Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Günlük 300ml den fazla kahve tüketmeyin!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                      } else {
                        return Container(); //return Center(child: CircularProgressIndicator());
                      }
                      return Container();
                    }
                  }),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ButtonTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 80,
                      child: FlatButton.icon(
                        onPressed: () {
                          _drinkModalBottomSheet(
                              context, authProvider.user.uid, 'Su');
                        },
                        icon: ImageIcon(
                          AssetImage("assets/images/drink-water.png"),
                          size: 36,
                          color: Colors.white,
                        ),
                        label: Text(
                          'SU',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ButtonTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 80,
                      child: FlatButton.icon(
                        onPressed: () {
                          _drinkModalBottomSheet(
                              context, authProvider.user.uid, 'Çay');
                        },
                        icon: ImageIcon(
                          AssetImage("assets/images/tea-bag.png"),
                          size: 36,
                          color: Colors.white,
                        ),
                        label: Text(
                          'ÇAY',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.yellow[900],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ButtonTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 80,
                      child: FlatButton.icon(
                        onPressed: () {
                          _drinkModalBottomSheet(
                              context, authProvider.user.uid, 'Kahve');
                        },
                        icon: ImageIcon(
                          AssetImage("assets/images/coffee.png"),
                          size: 36,
                          color: Colors.white,
                        ),
                        label: Text(
                          'KAHVE',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.brown,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ButtonTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 80,
                      child: FlatButton.icon(
                        onPressed: () {
                          _drinkModalBottomSheet(
                              context, authProvider.user.uid, 'Meyve Suyu');
                        },
                        icon: ImageIcon(
                          AssetImage("assets/images/orange.png"),
                          size: 36,
                          color: Colors.white,
                        ),
                        label: Text(
                          'MEYVE SUYU',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ButtonTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 80,
                      child: FlatButton.icon(
                        onPressed: () {
                          _drinkModalBottomSheet(
                              context, authProvider.user.uid, 'Alkol');
                        },
                        icon: ImageIcon(
                          AssetImage("assets/images/alcohol.png"),
                          size: 36,
                          color: Colors.white,
                        ),
                        label: Text(
                          'ALKOL',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ButtonTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 80,
                      child: FlatButton.icon(
                        onPressed: () {
                          _drinkModalBottomSheet(context, authProvider.user.uid,
                              'Gazlı İçecekler');
                        },
                        icon: ImageIcon(
                          AssetImage("assets/images/soda-can.png"),
                          size: 36,
                          color: Colors.white,
                        ),
                        label: Flexible(
                          child: Text(
                            'GAZLI İÇECEKLER',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ButtonTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 80,
                      child: FlatButton.icon(
                        onPressed: () {
                          _displayDrinkDialog(context, authProvider.user.uid);
                        },
                        icon: ImageIcon(
                          AssetImage("assets/images/milkshake.png"),
                          size: 36,
                          color: Colors.white,
                        ),
                        label: Text(
                          'DİĞER İÇECEKLER',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'BUGÜN',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              StreamBuilder(
                stream: _db.getTodaysWaterStatistics(authProvider.user.uid),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.documents.length,
                      separatorBuilder: (context, index) {
                        return Divider(color: Colors.black45);
                      },
                      itemBuilder: (context, index) {
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.all(0),
                          leading: Icon(Icons.local_drink),
                          title: Text(snapshot
                                  .data.documents[index].data['amount']
                                  .toString() +
                              ' ml'),
                          subtitle: Text(snapshot
                              .data.documents[index].data['beverage']
                              .toString()),
                          trailing: IconButton(
                            onPressed: () {
                              _db.deleteTodaysWaterStatistic(
                                  authProvider.user.uid,
                                  snapshot.data.documents[index].documentID);
                            },
                            icon: Icon(Icons.delete_forever, color: Colors.red),
                          ),
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _saveDrinkStat(userId, amount, drink, glassType) {
    _db.saveStatisticWater(userId, amount, drink);

    Fluttertoast.showToast(
        msg: '1 ${glassType} ${drink.toLowerCase()} eklendi!',
        toastLength: Toast.LENGTH_SHORT);

    Navigator.of(context).pop();
  }

  void _drinkModalBottomSheet(context, userId, drink, {amount = 0}) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(10.0),
              topRight: const Radius.circular(10.0)),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext bc) {
          switch (drink) {
            case 'Su':
              return Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: ImageIcon(
                          AssetImage("assets/images/plastic-cup.png"),
                          size: 36,
                          color: Colors.black,
                        ),
                        title: new Text('Pet bardak'),
                        onTap: () {
                          _saveDrinkStat(userId, 180, drink, 'Pet bardak');
                        }),
                    new ListTile(
                        leading: ImageIcon(
                          AssetImage("assets/images/drink-water.png"),
                          size: 36,
                          color: Colors.black,
                        ),
                        title: new Text('Su bardağı'),
                        onTap: () {
                          _saveDrinkStat(userId, 200, drink, 'Su bardağı');
                        }),
                    new ListTile(
                        leading: ImageIcon(
                          AssetImage("assets/images/water.png"),
                          size: 36,
                          color: Colors.black,
                        ),
                        title: new Text('Pet şişe'),
                        onTap: () {
                          _saveDrinkStat(userId, 500, drink, 'Pet şişe');
                        }),
                    new ListTile(
                        leading: ImageIcon(
                          AssetImage("assets/images/drinks.png"),
                          size: 36,
                          color: Colors.black,
                        ),
                        title: new Text('Diğer'),
                        onTap: () {
                          _displayAmountDialog(context, userId, 'Su');
                        }),
                  ],
                ),
              );

            case 'Çay':
              return Container(
                child: new Wrap(children: <Widget>[
                  new ListTile(
                      leading: ImageIcon(
                        AssetImage("assets/images/tea-cup.png"),
                        size: 36,
                        color: Colors.black,
                      ),
                      title: new Text('Çay bardağı'),
                      onTap: () {
                        _saveDrinkStat(userId, 100, drink, 'Çay bardağı');
                      }),
                  new ListTile(
                      leading: ImageIcon(
                        AssetImage("assets/images/coffee-mug.png"),
                        size: 36,
                        color: Colors.black,
                      ),
                      title: new Text('Kupa'),
                      onTap: () {
                        _saveDrinkStat(userId, 300, drink, 'Kupa');
                      }),
                  ListTile(
                      leading: ImageIcon(
                        AssetImage("assets/images/plastic-cup.png"),
                        size: 36,
                        color: Colors.black,
                      ),
                      title: new Text('Pet bardak'),
                      onTap: () {
                        _saveDrinkStat(userId, 180, drink, 'Pet bardak');
                      }),
                  new ListTile(
                      leading: ImageIcon(
                        AssetImage("assets/images/drinks.png"),
                        size: 36,
                        color: Colors.black,
                      ),
                      title: new Text('Diğer'),
                      onTap: () {
                        _displayAmountDialog(context, userId, 'Çay');
                      }),
                ]),
              );

            case 'Kahve':
              return Container(
                child: new Wrap(children: <Widget>[
                  new ListTile(
                      leading: ImageIcon(
                        AssetImage("assets/images/coffee.png"),
                        size: 36,
                        color: Colors.black,
                      ),
                      title: new Text('Fincan 80ml'),
                      onTap: () {
                        _saveDrinkStat(userId, 80, drink, 'Fincan');
                      }),
                  new ListTile(
                      leading: ImageIcon(
                        AssetImage("assets/images/plastic-cup.png"),
                        size: 36,
                        color: Colors.black,
                      ),
                      title: new Text('Karton bardak'),
                      onTap: () {
                        _saveDrinkStat(userId, 180, drink, 'Karton bardak');
                      }),
                  ListTile(
                      leading: ImageIcon(
                        AssetImage("assets/images/coffee-mug.png"),
                        size: 36,
                        color: Colors.black,
                      ),
                      title: new Text('Kupa'),
                      onTap: () {
                        _saveDrinkStat(userId, 300, drink, 'Kupa');
                      }),
                  new ListTile(
                      leading: ImageIcon(
                        AssetImage("assets/images/drinks.png"),
                        size: 36,
                        color: Colors.black,
                      ),
                      title: new Text('Diğer'),
                      onTap: () {
                        _displayAmountDialog(context, userId, 'Kahve');
                      }),
                ]),
              );

            case 'Meyve Suyu':
              return Container(
                child: new Wrap(children: <Widget>[
                  new ListTile(
                      leading: ImageIcon(
                        AssetImage("assets/images/plastic-cup.png"),
                        size: 36,
                        color: Colors.black,
                      ),
                      title: new Text('Karton bardak'),
                      onTap: () {
                        _saveDrinkStat(userId, 180, drink, 'Karton bardak');
                      }),
                  new ListTile(
                      leading: ImageIcon(
                        AssetImage("assets/images/coffee-mug.png"),
                        size: 36,
                        color: Colors.black,
                      ),
                      title: new Text('Kupa'),
                      onTap: () {
                        _saveDrinkStat(userId, 300, drink, 'Kupa');
                      }),
                  new ListTile(
                      leading: ImageIcon(
                        AssetImage("assets/images/drinks.png"),
                        size: 36,
                        color: Colors.black,
                      ),
                      title: new Text('Diğer'),
                      onTap: () {
                        _displayAmountDialog(context, userId, 'Meyve Suyu');
                      }),
                ]),
              );

            case 'Alkol':
              return Container(
                child: new Wrap(children: <Widget>[
                  new ListTile(
                      leading: ImageIcon(
                        AssetImage("assets/images/drinks.png"),
                        size: 36,
                        color: Colors.black,
                      ),
                      title: new Text('Diğer'),
                      onTap: () {
                        _displayAmountDialog(context, userId, 'Alkol');
                      }),
                ]),
              );

            case 'Gazlı İçecekler':
              return Container(
                child: new Wrap(children: <Widget>[
                  new ListTile(
                      leading: ImageIcon(
                        AssetImage("assets/images/plastic-cup.png"),
                        size: 36,
                        color: Colors.black,
                      ),
                      title: new Text('Karton bardak'),
                      onTap: () {
                        _saveDrinkStat(userId, 180, drink, 'Karton bardak');
                      }),
                  new ListTile(
                      leading: ImageIcon(
                        AssetImage("assets/images/coffee-mug.png"),
                        size: 36,
                        color: Colors.black,
                      ),
                      title: new Text('Kupa'),
                      onTap: () {
                        _saveDrinkStat(userId, 300, drink, 'Kupa');
                      }),
                  new ListTile(
                      leading: ImageIcon(
                        AssetImage("assets/images/drinks.png"),
                        size: 36,
                        color: Colors.black,
                      ),
                      title: new Text('Diğer'),
                      onTap: () {
                        _displayAmountDialog(
                            context, userId, 'Gazlı İçecekler');
                      }),
                ]),
              );

            default:
              return Container();
          }
        });
  }
}
