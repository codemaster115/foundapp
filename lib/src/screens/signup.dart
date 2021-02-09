import 'dart:async';

import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import '../../config/ui_icons.dart';
import '../widgets/SocialMediaWidget.dart';
import '../providers/auth.dart';
import '../utils/http_exception.dart';

class SignUpWidget extends StatefulWidget {
  static const String routeName = '/signup';

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  Map<String, String> _authData = {'email': '', 'password': ''};
  String confirmPassword = '';
  bool _showPassword = false;

  Future _submit() async {
    if (!EmailValidator.validate(_authData['email'])) {
      _showerrorDialog('Input correct email.');
      return;
    }

    if (_authData['password'] != confirmPassword) {
      _showerrorDialog('Passwords are not matched.');
      return;
    }

    try {
      if (await Provider.of<Auth>(context, listen: false)
          .signupWithMail(_authData['email'], _authData['password'])) {
        Navigator.of(context).pushNamed('/SignIn');
      }
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  margin: EdgeInsets.symmetric(vertical: 65, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                          offset: Offset(0, 10),
                          blurRadius: 20)
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 25),
                      Text('Sign Up',
                          style: Theme.of(context).textTheme.display2),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          _authData['email'] = value;
                        },
                        style: TextStyle(color: Theme.of(context).focusColor),
                        keyboardType: TextInputType.emailAddress,
                        decoration: new InputDecoration(
                          hintText: 'Email Address',
                          hintStyle: Theme.of(context).textTheme.body1.merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.4)),
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
                            color:
                                Theme.of(context).focusColor.withOpacity(0.4),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          _authData['password'] = value;
                        },
                        style: TextStyle(color: Theme.of(context).focusColor),
                        keyboardType: TextInputType.text,
                        obscureText: !_showPassword,
                        decoration: new InputDecoration(
                          hintText: 'Password',
                          hintStyle: Theme.of(context).textTheme.body1.merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.4)),
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
                            UiIcons.padlock_1,
                            color:
                                Theme.of(context).focusColor.withOpacity(0.4),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            color:
                                Theme.of(context).focusColor.withOpacity(0.4),
                            icon: Icon(_showPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          confirmPassword = value;
                        },
                        style: TextStyle(color: Theme.of(context).focusColor),
                        keyboardType: TextInputType.text,
                        obscureText: !_showPassword,
                        decoration: new InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: Theme.of(context).textTheme.body1.merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.4)),
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
                            UiIcons.padlock_1,
                            color:
                                Theme.of(context).focusColor.withOpacity(0.4),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            color:
                                Theme.of(context).focusColor.withOpacity(0.4),
                            icon: Icon(_showPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      FlatButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 70),
                        onPressed: () {
                          _submit();
                        },
                        child: Text(
                          'Sign Up',
                          style: Theme.of(context).textTheme.title.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                        ),
                        color: Theme.of(context).accentColor,
                        shape: StadiumBorder(),
                      ),
                      SizedBox(height: 50),
                      Text(
                        'Or using social media',
                        style: Theme.of(context).textTheme.body1,
                      ),
                      SizedBox(height: 20),
                      new SocialMediaWidget()
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
    );
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
