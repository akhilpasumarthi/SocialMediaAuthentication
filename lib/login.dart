import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:plasma_donour/display.dart';
class login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var value;
    return Scaffold(
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              width: double.infinity,
              decoration: BoxDecoration(
               gradient: LinearGradient(
                 begin: Alignment.topRight,
                 end: Alignment.bottomLeft,
                 colors:[
                   Colors.deepOrange,
                   Colors.amber
                 ]
               )
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children:<Widget> [
                  SizedBox(height:75.0,),
                  SizedBox(
                    height: 200.0,
                    child: Image.asset("images/logo_small.png")
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  SignInButton(
                    Buttons.FacebookNew,
                    text: "Sign Up with Facebook",
                    onPressed: () {
                      value=1;
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>display(value: value,)));
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SignInButton(
                    Buttons.Google,
                    text: "Sign up with Google",
                    onPressed: () {
                      value=2;
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>display(value: value,)));
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // SignInButton(
                  //   Buttons.Twitter,
                  //   text: "       Use Twitter",
                  //   onPressed: () {},
                  // ),
                ],


              ),


            )  );
}
}
