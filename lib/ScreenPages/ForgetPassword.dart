import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/ScreenPages/home.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/ScreenPages/loginPage.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String _email;
  final _formkey = GlobalKey<FormState>();

  Future<void> sendPasswordResetEmail(String email) async {
    return firebaseAuth.sendPasswordResetEmail(email: email);
  }

  ///==========validate email function==========////
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  TextEditingController _emailtextcontroller = TextEditingController();

  Widget Emailfield() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            " Email",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _emailtextcontroller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10.0),
                borderSide: new BorderSide(color: Colors.black),
              ),
              // icon: Icon(Icons.email),
              hintText: "Email",
            ),
            validator: validateEmail,
            onSaved: (String val) {
              _email = val;
            },
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  Material sendbutton() {
    return Material(
      child: MaterialButton(
        color: Color(0xff4dd0e1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        onPressed: () async {
          if (_formkey.currentState.validate()) {
            sendPasswordResetEmail(_emailtextcontroller.text);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
        },
        child: Text(
          "Send",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Scaffold buildbody() {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Forget Your Password?",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Confirm Your Email We'll send the Instruction",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              Emailfield(),
              sendbutton(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildbody();
  }
}
