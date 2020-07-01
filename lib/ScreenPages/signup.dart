import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/model/providers/user.dart';
import 'package:groceryapp/src/Widget/bezierContainer.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/ScreenPages/loginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailtextcontroller = TextEditingController();
  TextEditingController _nameltextcontroller = TextEditingController();
  TextEditingController _passwordtextcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  ///=======validate password function==========///
  String validatePassword(String value) {
    if (value.isEmpty) {
      return "The password cannot be empty";
    } else if (value.length < 6)
      return 'The password has to be atleast 6 charchter';
    else
      return null;
  }

  ///==hide-password==//
  bool hidepass = true;

  ///=======Handle Google Sign In function=========///
  bool isAuth = false;
  final _key = GlobalKey<ScaffoldState>();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Future signup() async {
    setState(() {
      loading = true;
    });

    if (_formkey.currentState.validate()) {
      // print("");
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailtextcontroller.text,
              password: _passwordtextcontroller.text)
          .then((currentUser) {
        return Firestore.instance
            .collection("users")
            .document(currentUser.user.uid)
            .setData({
              "uid": currentUser.user.uid,
              "name": _nameltextcontroller.text,
              //"gender": gender,
              //"surname": lastNameInputController.text,
              "email": _emailtextcontroller.text,
            })
            .then((result) => {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      (_) => false),
                  _nameltextcontroller.clear(),
                  // lastNameInputController.clear(),
                  _emailtextcontroller.clear(),
                  _passwordtextcontroller.clear(),
                  // _passwordtextcontroller.clear()
                })
            .catchError((err) => print(err));
      }).catchError((err) => print(err));
    }

    ///===alert for the error===///
    else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("The passwords do not match"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
    setState(() {
      loading = false;
    });
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              'Login',
              style: TextStyle(
                  color: Color(0xff00acc1),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Groc',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xff00acc1),
          ),
          children: [
            TextSpan(
              text: 'ery',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'shop',
              style: TextStyle(color: Color(0xff00acc1), fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);

    return Scaffold(
        key: _key,
        body: authProvider.status == Status.Authenticating
            ? Loading()
            : SingleChildScrollView(
                child: Container(
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _formkey,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: SizedBox(),
                            ),
                            _title(),
                            SizedBox(
                              height: 50,
                            ),
                            //_emailPasswordWidget(),
                            Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Username",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: authProvider.name,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(10.0),
                                            borderSide: new BorderSide(
                                                color: Colors.black),
                                          ),
                                          //icon: Icon(Icons.lock),
                                          hintText: "Username",
                                        ),
                                        // obscureText: hidepass,
                                        // keyboardType: TextInputType.visiblePassword,
                                        //validator: validatePassword,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "The name field cannot be empty";
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.text,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Email Id",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: authProvider.emails,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(10.0),
                                            borderSide: new BorderSide(
                                                color: Colors.black),
                                          ),
                                          // icon: Icon(Icons.email),
                                          hintText: "Email",
                                        ),
                                        validator: validateEmail,
                                        onSaved: (String val) {
                                          //_email = val;
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Password",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: authProvider.passwords,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(10.0),
                                            borderSide: new BorderSide(
                                                color: Colors.black),
                                          ),
                                          //icon: Icon(Icons.lock),
                                          hintText: "Password",
                                        ),
                                        obscureText: hidepass,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        validator: validatePassword,
                                        onSaved: (String val) {
                                          // _pass = val;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (_formkey.currentState.validate()) {
                                  if (!await authProvider.signUp(context)) {
                                    _key.currentState.showSnackBar(SnackBar(
                                        content:
                                            Text("Resgistration failed!")));
                                    return;
                                  }

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()));
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          offset: Offset(2, 4),
                                          blurRadius: 5,
                                          spreadRadius: 2)
                                    ],
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xff4dd0e1),
                                          Color(0xff00acc1)
                                        ])),
                                child: Text(
                                  'Register Now',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: SizedBox(),
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _loginAccountLabel(),
                      ),
                      Positioned(top: 40, left: 0, child: _backButton()),
                      Positioned(
                          top: -MediaQuery.of(context).size.height * .15,
                          right: -MediaQuery.of(context).size.width * .4,
                          child: BezierContainer()),
                      Visibility(
                          visible: loading ?? true,
                          child: Container(
                            color: Colors.white.withOpacity(0.7),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              )));
  }
}
