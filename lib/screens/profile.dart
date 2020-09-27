import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kegelapp/models/user.dart';
import 'package:kegelapp/providers/auth.dart';
import 'package:kegelapp/services/database.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> _genderList = ['Kadın', 'Erkek'];

  final formkey = GlobalKey<FormState>();

  String _selectedGender = 'Cinsiyet';
  int _age, _weight, _height;
  int _hydrationVal = 0;
  int _glass = 0;

  AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
  }

  void _submit() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();

      setState(() {
        _hydrationVal = (_weight * 30).toInt();
        _glass = (_hydrationVal / 200).floor();
      });

      db.saveProfile(authProvider.user.uid, this._age, this._selectedGender, this._height, this._hydrationVal, this._weight);

      Fluttertoast.showToast(
          msg: 'Profil kaydedildi.', toastLength: Toast.LENGTH_SHORT);
    }
  }

  DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

    authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          title: Text('Profil',
              style: TextStyle(fontSize: 22, color: Colors.black)),
        ),
        body: FutureBuilder(
          future: db.getProfile(authProvider.user.uid),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            print(snapshot);
            if (snapshot.hasError) {
              return Text('HATA OLUŞTU!\n' + snapshot.error.toString());
            } else {
              if (snapshot.hasData) {

                return SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      child: Form(
                        key: formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 10),
                            DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                items: _genderList.map((String item) {
                                  return DropdownMenuItem<String>(
                                    child: new Text(item),
                                    value: item,
                                  );
                                }).toList(),
                                hint: Text(snapshot.data.gender),
                                validator: (value) => value == null
                                    ? 'Lütfen cinsiyetinizi seçin'
                                    : null,
                                isExpanded: true,
                                onChanged: (String val) {
                                  print(val);
                                  setState(() {
                                    _selectedGender = val;
                                  });
                                },
                              ),
                            ),
                            TextFormField(
                              initialValue: snapshot.data.age.toString(),
                              keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                  hintText: '18 - 60',
                                  labelText: 'Yaş',
                                  suffix: Text('yıl')),
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              validator: (value) {
                                num numValue = num.tryParse(value.trim());
                                if (value.trim().isEmpty) {
                                  return 'Lütfen yaşınızı girin';
                                } else if (!(numValue >= 18 &&
                                    numValue <= 60)) {
                                  return 'Geçersiz değer 18 - 60';
                                }
                                return null;
                              },
                              onSaved: (value) => _age = num.tryParse(value),
                            ),
                            TextFormField(
                              initialValue: snapshot.data.weight.toString(),
                              keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                  hintText: '45 - 90',
                                  labelText: 'Kilo',
                                  suffix: Text('kg')),
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              validator: (value) {
                                num numValue = num.tryParse(value.trim());
                                if (value.trim().isEmpty) {
                                  return 'Lütfen kilonuzu girin';
                                } else if (!(numValue >= 45 &&
                                    numValue <= 90)) {
                                  return 'Geçersiz değer 45 - 90';
                                }
                                return null;
                              },
                              onSaved: (value) => _weight = num.tryParse(value),
                            ),
                            TextFormField(
                              initialValue: snapshot.data.height.toString(),
                              keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                  hintText: '140 - 200',
                                  labelText: 'Boy',
                                  suffix: Text('cm')),
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).unfocus(),
                              validator: (value) {
                                num numValue = num.tryParse(value.trim());
                                if (value.trim().isEmpty) {
                                  return 'Lütfen boyunuzu girin';
                                } else if (!(numValue >= 140 &&
                                    numValue <= 200)) {
                                  return 'Geçersiz değer 140 - 200';
                                }
                                return null;
                              },
                              onSaved: (value) => _height = num.tryParse(value),
                            ),
                            SizedBox(height: 25),
                            Center(
                              child: Text(
                                'Günlük sıvı ihtiyacınız ' +
                                    snapshot.data.hydrationGoal.toString() + ' ml',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              heightFactor: 1.75,
                              child: Hero(
                                tag: "hero",
                                child: ButtonTheme(
                                  minWidth: 225,
                                  height: 40,
                                  child: RaisedButton(
                                    onPressed: () {
                                      _submit();
                                    },
                                    color: Colors.pink,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Text(
                                      "Profili Kaydet",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
          },
        ));
  }
}
