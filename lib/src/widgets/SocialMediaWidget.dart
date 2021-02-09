import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth.dart';
import '../utils/http_exception.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
FacebookLogin _facebookLogin = new FacebookLogin();

class SocialMediaWidget extends StatelessWidget {
  SocialMediaWidget({Key key}) : super(key: key);

  Future<void> _handleSignInWithGoogle(BuildContext context) async {
    try {
      await _googleSignIn.signIn();
      String email = _googleSignIn.currentUser.email;
      String image = _googleSignIn.currentUser.photoUrl;
      String displayName = _googleSignIn.currentUser.displayName;
      String googleId = _googleSignIn.currentUser.id;

      try {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await Provider.of<Auth>(context, listen: false)
            .loginWithGoogle(googleId, email, image, displayName);
        String token = sharedPreferences.getString('token');
        if (token != null) {
          await sharedPreferences.setString('image', image);
          await sharedPreferences.setString('name', displayName);
          Navigator.of(context).pushNamed('/Tabs', arguments: 2);
        }
      } on HttpException catch (e) {
        _showerrorDialog(context, e.toString());
      } catch (error) {
        var errorMessage = 'Plaese try again later';
        _showerrorDialog(context, errorMessage);
      }
    } catch (error) {}
  }

  Future<void> _handleSignOutGoogle() async {
    _googleSignIn.signOut();
  }

  Future<void> _handleSignInWithFacebook(BuildContext context) async {
    FacebookLoginResult result = await _facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        try {
          final FacebookAccessToken accessToken = result.accessToken;
          final token = accessToken.token;
          final graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${token}');
          final profile = json.decode(graphResponse.body);
          String email = profile['email'];
          String image = profile['picture']['data']['url'];
          String displayName = profile['name'];
          String facebookId = profile['id'];
          String firstName = profile['first_name'];
          String lastName = profile['first_name'];

          try {
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            await Provider.of<Auth>(context, listen: false).loginWithFacebook(
                facebookId, email, image, displayName, firstName, lastName);
            String token = sharedPreferences.getString('token');
            if (token != null) {
              await sharedPreferences.setString('image', image);
              await sharedPreferences.setString('name', displayName);

              Navigator.of(context).pushNamed('/Tabs', arguments: 2);
            }
          } on HttpException catch (e) {
            _showerrorDialog(context, e.toString());
          } catch (error) {
            var errorMessage = 'Plaese try again later';
            _showerrorDialog(context, errorMessage);
          }
        } catch (error) {}

        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 45,
          height: 45,
          child: InkWell(
            onTap: () => _handleSignInWithFacebook(context),
            child: Image.asset('img/facebook.png'),
          ),
        ),
        // SizedBox(width: 10),
        // SizedBox(
        //   width: 45,
        //   height: 45,
        //   child: InkWell(
        //     onTap: null,
        //     child: Image.asset('img/twitter.png'),
        //   ),
        // ),
        SizedBox(width: 30),
        SizedBox(
          width: 45,
          height: 45,
          child: InkWell(
            onTap: () => _handleSignInWithGoogle(context),
            child: Image.asset('img/google-plus.png'),
          ),
        ),
        // SizedBox(width: 10),
        // SizedBox(
        //   width: 45,
        //   height: 45,
        //   child: InkWell(
        //     onTap: null,
        //     child: Image.asset('img/linkedin.png'),
        //   ),
        // )
      ],
    );
  }
}

void _showerrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        'An Error Occurs',
        style: TextStyle(color: Colors.blue),
      ),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text('Okay'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    ),
  );
}
