import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kegelapp/providers/auth.dart';
import 'package:kegelapp/screens/home.dart';
import 'package:kegelapp/screens/onboarding.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of(context);

    return FutureBuilder<FirebaseUser>(
      future: authProvider.getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return OnBoardingPage();
          }
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
