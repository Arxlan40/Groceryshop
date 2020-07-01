import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:groceryapp/ScreenPages/CartScreen.dart';
import 'package:groceryapp/ScreenPages/HomeScreen.dart';
import 'package:groceryapp/ScreenPages/MessagesScreen.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/src/Widget/pushnotification.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/ScreenPages/welcomePage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/model/providers/user.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'ProfileScreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    pageController = PageController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  Scaffold buildAuthScreen(userid) {
    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
        children: <Widget>[
          HomeScreen(),
          MessageScreen(
            currentUserId: userid,
          ),
          CartScreen(),
          ProfileScreen(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home)),
            BottomNavigationBarItem(icon: Icon(Icons.message)),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
              ),
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline)),
          ]),
    );
    // return RaisedButton(
    //   child: Text('Logout'),
    //   onPressed: logout,
    // );
  }

  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return buildAuthScreen(user.userModel.id);
  }
}
