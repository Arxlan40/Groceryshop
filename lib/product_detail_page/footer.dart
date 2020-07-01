import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groceryapp/model/helpers/user.dart';
import 'gredients.dart';
import 'pages/specification.dart';
import 'pages/productDesc.dart';
import 'pages/userReviews.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groceryapp/ScreenPages/HomeScreen.dart';
import 'package:provider/provider.dart';

UserServices userServices = UserServices();

var divider = new Divider();

class Mfooter extends StatefulWidget {
  final prod_detail_description;

  Mfooter({
    this.prod_detail_description,
  });

  @override
  _MfooterState createState() => new _MfooterState();
}

@override
class _MfooterState extends State<Mfooter> with SingleTickerProviderStateMixin {
  List<Tab> _tabs;
  List<Widget> _pages;
  static TabController _controller;

  @override
  void initState() {
    super.initState();
    //Userdata().getgoogleuser();
    //print(user.email);
    _tabs = [
      new Tab(
        child: new Text(
          "Product Description",
          style: new TextStyle(color: Colors.black),
        ),
      ),
      new Tab(
        child: new Text(
          "specification",
          style: new TextStyle(color: Colors.black),
        ),
      ),
      new Tab(
        child: new Text(
          "user reviews",
          style: new TextStyle(color: Colors.black),
        ),
      ),
    ];
    _pages = [
      new ProductDesc(
        prod_detail_description: widget.prod_detail_description,
      ),
      new Specification(),
      new UserReview()
    ];
    _controller = new TabController(
      length: _tabs.length,
      vsync: this,
    );
    //getuser();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new TabBar(
          isScrollable: true,
          controller: _controller,
          tabs: _tabs,
          indicatorColor: Colors.white,
        ),
        new Divider(
          height: 1.0,
        ),
        new SizedBox.fromSize(
          size: const Size.fromHeight(220.0),
          child: new TabBarView(
            controller: _controller,
            children: _pages,
          ),
        ),
      ],
    );
  }
}
