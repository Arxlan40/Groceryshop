import 'package:flutter/material.dart';
import 'clipper.dart';
import 'gredients.dart';
import 'customIcon.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:groceryapp/ScreenPages/CartScreen.dart';

Widget _appbar(context) {
  return Align(
    heightFactor: 0.35,
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: new IconButton(
              icon: new Icon(
                Icons.keyboard_backspace,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              splashColor: Colors.black,
            )),
        new Expanded(
          child: new Container(),
        ),
        new Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: new IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black87,
            ),
            onPressed: () {
              return Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
          ),
        )
      ],
    ),
  );
}

Container content(picture, name) {
  return new Container(
    margin: new EdgeInsets.only(top: 30.0),
    child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Image.network(
            picture,
            width: 140,
            height: 140,
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Container(
                  width: 70.0,
                  height: 30.0,
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(30.0)),
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: new Offset(0.0, 10.0))
                      ]),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      new Text("4.8")
                    ],
                  ),
                ),
                new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text("$name",
                          style: new TextStyle(
                              fontSize: 20.0,
                              fontFamily: "OpenSans",
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal)),
                    ]),
                new Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: new BoxDecoration(
                      gradient: btnGradient,
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                            blurRadius: 10.0,
                            color: Colors.black12,
                            offset: new Offset(0.0, 10.0))
                      ]),
                  child: new IconButton(
                    icon: Icon(
                      Icons.share,
                      size: 25.0,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      print('www');
                      await FlutterShareMe()
                          .shareToWhatsApp(base64Image: picture, msg: name);
                    },
                  ),
                ),
              ],
            ),
          )
        ]),
  );
}

class MHeader extends StatelessWidget {
  final prod_detail_name;
  final prod_detail_pricture;

  MHeader({
    this.prod_detail_name,
    this.prod_detail_pricture,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 280.0,
      child: new Stack(
        children: <Widget>[
          new ClipPath(
            clipper: new ArcClipper(),
            child: new Container(
              height: double.infinity,
              decoration: new BoxDecoration(gradient: bgGradient),
            ),
          ),
          new Align(
            alignment: FractionalOffset.center,
            heightFactor: 3.5,
            child: content(prod_detail_pricture, prod_detail_name.toString()),
          ),
          _appbar(context),
        ],
      ),
    );
  }
}
