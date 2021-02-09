import 'package:flutter/material.dart';
import '../screens/on_boarding.dart';
import '../screens/tabs.dart';
import '../screens/signin.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String token;
  int runApplicationTimes;

  _SplashState() {
    _init();
  }

  Future<void> _init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int runTimes = sharedPreferences.getInt('runApplicationTimes');
    if (runTimes == null) {
      runTimes = 1;
    } else {
      runTimes += 1;
    }
    sharedPreferences.setInt('runApplicationTimes', runTimes);
    setState(() {
      token = sharedPreferences.getString('token');
      runApplicationTimes = runTimes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 8,
      navigateAfterSeconds: token != null
          ? new TabsWidget(currentTab: 2)
          : runApplicationTimes != null
              ? new SignInWidget()
              : new OnBoardingWidget(),
      title: new Text(
        ' Business Listing \n Directory ',
        textAlign: TextAlign.center,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
          color: Colors.white,
        ),
      ),
      backgroundColor: Theme.of(context).accentColor.withOpacity(0.7),
      loaderColor: Colors.white,
    );
  }
}
