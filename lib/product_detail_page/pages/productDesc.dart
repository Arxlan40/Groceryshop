import 'package:flutter/material.dart';

class ProductDesc extends StatelessWidget {
  final prod_detail_description;

  ProductDesc({
    this.prod_detail_description,
  });
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: ListView(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(14.0),
          child: new Text(
            prod_detail_description.toString(),
            style: new TextStyle(
                fontFamily: "OpenSans",
                color: Colors.black,
                fontSize: 13.0,
                fontWeight: FontWeight.w200),
          ),
        ),
      ],
    ));
  }
}
