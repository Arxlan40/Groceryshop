import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:groceryapp/model/providers/user.dart';
import 'package:provider/provider.dart';

import 'ProfileEdit.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
              right: 20,
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfile(
                              userid: user.userModel.id,
                            )));
              },
              child: Text(
                "Edit",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 20,
                    fontFamily: "OpenSans"),
              ),
            ),
          )
        ],
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          "Profile",
          style: TextStyle(fontFamily: "OpenSans"),
        ),
        backgroundColor: Color(0xff4dd0e1),
      ),
      //backgroundColor: Colors.blue,
      body: SafeArea(
          child: Center(
        child: ListView(
          children: <Widget>[
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                    radius: 40.0,
                    backgroundImage: user.userModel.image != null
                        ? NetworkImage(user.userModel.image)
                        : NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/groceryapp-8164c.appspot.com/o/post_f8d3d859-181f-4c83-a9bc-d8c712690344.jpg?alt=media&token=efd779b1-e3eb-4e2f-9278-410c1d6a9a93")),
                Text(
                  user.userModel.name,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 25.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                  width: 150.0,
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                    child: ListTile(
                      leading: Icon(
                        Icons.phone_android,
                        color: Colors.blueGrey,
                      ),
                      title: Text(
                        'Phone',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontFamily: 'Source Sans Pro',
                          fontSize: 15.0,
                        ),
                      ),
                      trailing: Text(
                        user.userModel.mobile != null
                            ? user.userModel.mobile
                            : "Give Mobile Number",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Source Sans Pro',
                          fontSize: 13.0,
                        ),
                      ),
                    )),
                Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                    child: ListTile(
                      leading: Icon(
                        Icons.email,
                        color: Colors.blueGrey,
                      ),
                      title: Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontFamily: 'Source Sans Pro',
                          fontSize: 15.0,
                        ),
                      ),
                      trailing: Text(
                        user.userModel.email,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Source Sans Pro',
                          fontSize: 13.0,
                        ),
                      ),
                    )),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    height: 100,
                    width: 800,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Text(
                                "Address:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              title: Text(
                                user.userModel.address != null
                                    ? user.userModel.address
                                    : "Give Address",
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                        //  Divider(),
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  color: Color(0xff4dd0e1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {},
                  child: Text("Logout"),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}
