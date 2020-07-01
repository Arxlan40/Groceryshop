import 'package:flutter/material.dart';
import 'package:groceryapp/model/providers/user.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/ScreenPages/ForgetPassword.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/ScreenPages/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import '../src/Widget/bezierContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final firestoreInstance = Firestore.instance;
  final _formkey = GlobalKey<FormState>();
  TextEditingController _emailtextcontroller = TextEditingController();
  TextEditingController _passwordtextcontroller = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final usersRef = Firestore.instance.collection('users');
  SharedPreferences preferences;
  bool loading = false;
  bool isLogedIn = false;

  String _pass;

  String _email;

  ///=======validate password function==========///
  String validatePassword(String value) {
    if (value.isEmpty) {
      return "The password cannot be empty";
    } else if (value.length < 6)
      return 'The password has to be atleast 6 charchter';
    else
      return null;
  }

//  Future<FirebaseUser> handlesignin() async {
//    preferences = await SharedPreferences.getInstance();
//    setState(() {
//      loading = true;
//    });
//    GoogleSignInAccount googleUser = await googleSignIn.signIn();
//    GoogleSignInAuthentication googleSignInAuthentication =
//        await googleUser.authentication;
//
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleSignInAuthentication.accessToken,
//      idToken: googleSignInAuthentication.idToken,
//    );
//    final FirebaseUser firebaseUser =
//        (await firebaseAuth.signInWithCredential(credential)).user;
//    if (firebaseUser != null) {
//      final QuerySnapshot result = await Firestore.instance
//          .collection("users")
//          .where("id", isEqualTo: firebaseUser.uid)
//          .getDocuments();
//      final List<DocumentSnapshot> documents = result.documents;
//      if (documents.length == 0) {
//        Firestore.instance
//            .collection("users")
//            .document(firebaseUser.uid)
//            .setData({
//          "uid": firebaseUser.uid,
//          "name": firebaseUser.displayName,
//          "profilePicture": firebaseUser.photoUrl,
//          "email": firebaseUser.email,
//        });
//        await preferences.setString("email", firebaseUser.email);
//        await preferences.setString("uid", firebaseUser.uid);
//
//        await preferences.setString("name", firebaseUser.displayName);
//        await preferences.setString("profilePicture", firebaseUser.photoUrl);
//      } else {
//        await preferences.setString("uid", documents[0]['email']);
//
//        await preferences.setString("uid", documents[0]['uid']);
//        await preferences.setString("name", documents[0]['name']);
//        await preferences.setString(
//            "profilePicture", documents[0]['profilePicture']);
//      }
//      Fluttertoast.showToast(msg: "Login was Successful");
//      setState(() {
//        loading = false;
//      });
//    } else {}
//  }

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

  Widget Emailfield(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
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

  Widget passwordField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _passwordtextcontroller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10.0),
                borderSide: new BorderSide(color: Colors.black),
              ),
              //icon: Icon(Icons.lock),
              hintText: "Password",
            ),
            obscureText: hidepass,
            keyboardType: TextInputType.visiblePassword,
            validator: validatePassword,
            onSaved: (String val) {
              _pass = val;
            },
          ),
        ],
      ),
    );
  }

  Future<void> logIn() async {
    setState(() {
      loading = true;
    });

    if (_formkey.currentState.validate()) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailtextcontroller.text,
              password: _passwordtextcontroller.text)
          .then((currentUser) => Firestore.instance
              .collection("users")
              .document(currentUser.user.uid)
              .get()
              .then(
                (result) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                ),
              )
              .catchError((err) => print(err)))
          .catchError((err) => print(err));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            ///===alert for the error===///
            return AlertDialog(
              title: Text("Error"),
              content: Text("Acoount Not found Or Wrong Passowrd"),
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
    Fluttertoast.showToast(msg: "Login was Successful");

    setState(() {
      loading = false;
    });
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () {
        logIn();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
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
                colors: [Color(0xff4dd0e1), Color(0xff00acc1)])),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

//  Material googleButton() {
//    return Material(
//      child: GestureDetector(
//        onTap: () {
//          handlesignin().whenComplete(
//            () => Navigator.pushReplacement(
//              context,
//              MaterialPageRoute(
//                builder: (context) => Home(),
//              ),
//            ),
//          );
//        },
//        child: Container(
//          height: 50,
//          margin: EdgeInsets.symmetric(vertical: 20),
//          decoration: BoxDecoration(
//            borderRadius: BorderRadius.all(Radius.circular(10)),
//          ),
//          child: Row(
//            children: <Widget>[
//              Expanded(
//                flex: 1,
//                child: Container(
//                  decoration: BoxDecoration(
//                    color: Color(0xFFF4B400),
//                    borderRadius: BorderRadius.only(
//                        bottomLeft: Radius.circular(5),
//                        topLeft: Radius.circular(5)),
//                  ),
//                  alignment: Alignment.center,
//                  child: Text('G',
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 25,
//                          fontWeight: FontWeight.w400)),
//                ),
//              ),
//              Expanded(
//                flex: 5,
//                child: Container(
//                  decoration: BoxDecoration(
//                    color: Color(0xFF4285F4),
//                    borderRadius: BorderRadius.only(
//                        bottomRight: Radius.circular(5),
//                        topRight: Radius.circular(5)),
//                  ),
//                  alignment: Alignment.center,
//                  child: Text('Log in with Google',
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 18,
//                          fontWeight: FontWeight.w400)),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpPage()));
            },
            child: Text(
              'Register',
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

//  Widget _emailPasswordWidget() {
//    return Column(
//      children: <Widget>[
//        Emailfield(" Email id"),
//        passwordField(" Password", isPassword: true),
//      ],
//    );
//  }

  Future<void> sendPasswordResetEmail(String email) async {
    return firebaseAuth.sendPasswordResetEmail(email: email);
  }

  void changeScreen(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

// request here
  void changeScreenReplacement(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
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
                            //   _emailPasswordWidget(),
                            Column(
                              children: <Widget>[
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
                                        controller: authProvider.email,
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
                                          _email = val;
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
                                        controller: authProvider.password,
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
                                          _pass = val;
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
                                  if (!await authProvider.signIn(context)) {
                                    _key.currentState.showSnackBar(SnackBar(
                                        content: Text("Login failed!")));
                                    return;
                                  }
                                  changeScreenReplacement(context, Home());
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
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgetPassword()));
                                },
                                child: Text('Forgot Password ?',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red)),
                              ),
                            ),
                            //googleButton(),
                            Expanded(
                              flex: 2,
                              child: SizedBox(),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _createAccountLabel(),
                      ),
                      //   Positioned(top: 40, left: 0, child: _backButton()),
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

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
