import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/ui_icons.dart';
import '../widgets/SocialMediaWidget.dart';
import '../providers/auth.dart';
import '../utils/http_exception.dart';

class ForgotPasswordWidget extends StatefulWidget {
  static const String routeName = "/forgot_password";

  @override
  _ForgotPasswordWidgetState createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  Map<String, String> _authData = {'email': '', 'password': ''};

  Future _submit() async {
    try {
      // SharedPreferences sharedPreferences =
      //     await SharedPreferences.getInstance();
      await Provider.of<Auth>(context, listen: false)
          .forgotPassword(_authData['email']);
      // String token = sharedPreferences.getString('token');
      // if (token != null) {
      //   sharedPreferences.setString('name', _authData['email']);
      //   sharedPreferences.setString('email', _authData['email']);
      //   Navigator.of(context).pushNamed('/Tabs', arguments: 2);
      // }
    } on HttpException catch (e) {
      _showerrorDialog(e.toString());
    } catch (error) {
      var errorMessage = 'Plaese try again later';
      _showerrorDialog(errorMessage);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        body: new Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      margin:
                          EdgeInsets.symmetric(vertical: 65, horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).primaryColor,
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.2),
                                offset: Offset(0, 10),
                                blurRadius: 20)
                          ]),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 25),
                          Text('Forgot Password',
                              style: Theme.of(context).textTheme.display2),
                          SizedBox(height: 30),
                          TextField(
                            onChanged: (value) {
                              _authData['email'] = value;
                            },
                            style:
                                TextStyle(color: Theme.of(context).focusColor),
                            keyboardType: TextInputType.emailAddress,
                            decoration: new InputDecoration(
                              hintText: 'Email Address',
                              hintStyle:
                                  Theme.of(context).textTheme.body1.merge(
                                        TextStyle(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.6)),
                                      ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).focusColor)),
                              prefixIcon: Icon(
                                UiIcons.envelope,
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          FlatButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 70),
                            onPressed: () {
                              // 2 number refer the index of Home page
                              _submit();
                            },
                            child: Text(
                              'Next',
                              style: Theme.of(context).textTheme.title.merge(
                                    TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: StadiumBorder(),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/SignIn');
                  },
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.title.merge(
                            TextStyle(color: Theme.of(context).primaryColor),
                          ),
                      children: [
                        TextSpan(text: 'Already have an account ?'),
                        TextSpan(
                            text: ' Sign In',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _showerrorDialog(String message) {
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
}
