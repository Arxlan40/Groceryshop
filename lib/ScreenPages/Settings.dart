import 'package:flutter/material.dart';
import 'package:groceryapp/ScreenPages/Terms&condition.dart';
import 'package:groceryapp/model/providers/user.dart';
import 'package:provider/provider.dart';

import 'ProfileEdit.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff27BED1),
        title: Text(
          "Settings",
          style: TextStyle(fontFamily: "OpenSans"),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            leading: Text(
              "Notifications",
              style: TextStyle(fontSize: 18),
            ),
            trailing: Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                    print(isSwitched);
                  });
                }),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
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
                "Profile Settings",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: InkWell(
              onTap: () {
Navigator.push(context, MaterialPageRoute(builder: (context)=>Termscondition()));},
              child: Text(
                "Terms & Conditions",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Text(
              "version",
              style: TextStyle(fontSize: 18),
            ),
            trailing: Text(
              "1.0.0",
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: InkWell(
              onTap: () {
                print('object');
              },
              child: Text(
                "Logout",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: InkWell(
              onTap: () {
                print('object');
              },
              child: Text(
                "Rate Us",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
