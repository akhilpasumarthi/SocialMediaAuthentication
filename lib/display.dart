import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class display extends StatefulWidget {
  display({this.value});
  final value;
  @override
  _displayState createState() => _displayState();
}

class _displayState extends State<display> {
  var _image;
  var name = '';
  var email = '';
  // TextEditingController name= TextEditingController();
  // TextEditingController email=TextEditingController();

  final GoogleSignIn googleSignIn = GoogleSignIn();

  final _auth = FirebaseAuth.instance;
  dynamic _userData;

  void initState() {
    super.initState();
    if (widget.value == 1) {
      _login();
    }
    if (widget.value == 2) {
      signInWithGoogle();
    }
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    auth.User user = _auth.currentUser;

    // Checking if email and name is null
    setState(() {
      name = user.displayName;
      email = user.email;
      _image = null;
    });

    name = user.displayName;

    email = user.email;

    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
  }

  _checkIfIsLogged() async {
    final accessToken = await FacebookAuth.instance.isLogged;
    if (accessToken != null) {
      FacebookAuth.instance.getUserData().then((userData) {
        setState(() => _userData = userData);
        _image = _userData['picture']['data']['url'];
        name = _userData['name'];
        email = _userData['email'];
        print(_image);
      });
    }
  }

  _login() async {
    final result = await FacebookAuth.instance.login();
    switch (result.status) {
      case FacebookAuthLoginResponse.ok:
        final userData = await FacebookAuth.instance.getUserData();
        final accessToken = result.accessToken.token;
        _checkIfIsLogged();

        // ignore: deprecated_member_use
        AuthCredential credential =
            FacebookAuthProvider.credential(accessToken);
        await FirebaseAuth.instance.signInWithCredential(credential);
        setState(() => _userData = userData);

        break;
      case FacebookAuthLoginResponse.cancelled:
        print("login cancelled");
        break;
      default:
        print("login failed");
        break;
    }
  }

  _logOut() async {
    await FacebookAuth.instance.logOut();
    setState(() => _userData = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
      builder: (context) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 130.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: Color(0xff476cfb),
                    radius: 105,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: (_image != null)
                          ? NetworkImage(_image)
                          : NetworkImage(
                              "https://img.pngio.com/computer-icons-user-clip-art-transparent-user-icon-png-1742152-user-logo-png-920_641.png"),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Name:  ",
                    style: TextStyle(
                        color: Color(0xff0B84ED),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700)),
                Text(name,
                    style: TextStyle(
                        color: Color(0xff0B84ED),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Email:  ",
                    style: TextStyle(
                        color: Color(0xff0B84ED),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700)),
                Text(email,
                    style: TextStyle(
                        color: Color(0xff0B84ED),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  name = null;
                  email = null;
                  _image = null;
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color(0xff0B84ED)),
                  child: Center(
                      child: Text('Signout',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w500))),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
