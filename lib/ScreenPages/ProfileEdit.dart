import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:groceryapp/model/models/user.dart';
import 'package:groceryapp/model/providers/user.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/ScreenPages/loginPage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import 'package:uuid/uuid.dart';

class EditProfile extends StatefulWidget {
  final UserModel userModel;
  final String userid;
  EditProfile({this.userModel, this.userid});

  @override
  _EditProfileState createState() => _EditProfileState(userid: userid);
}

class _EditProfileState extends State<EditProfile> {
  final String userid;
  _EditProfileState({this.userid});
  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final StorageReference storageRef = FirebaseStorage.instance.ref();
  String postId = Uuid().v4();

  bool _displayNameValid = true;
  bool _bioValid = true;
  bool _adressValid = true;

  bool _cityValid = true;
  bool _zipcodeValid = true;
  bool _countryValid = true;

  bool _mobileValid = true;

  bool _usernameValid = true;
  File _file;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  _handleChooseFromGallery() async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this._file = file;
    });
  }

  final usersRef = Firestore.instance.collection('users');
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController adress = TextEditingController();

  TextEditingController city = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController zipcode = TextEditingController();
  TextEditingController country = TextEditingController();

  UserModel userModel;
  getUser() async {
    setState(() {
      _isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.document(userid).get();
    userModel = UserModel.fromSnapshot(doc);
    name.text = userModel.name;
    email.text = userModel.email;
    mobile.text = userModel.mobile;
    country.text = userModel.country;
    city.text = userModel.city;

    zipcode.text = userModel.zipcode;
    adress.text = userModel.address;
    print("${userModel.name};;;;;");

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child("post_$postId.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

//  getUser() async {
//    setState(() {
//      _isLoading = true;
//    });
//    DocumentSnapshot doc = await usersRef.document(widget.currentUserId).get();
//    user = User.fromDocument(doc);
//    displayNameController.text = user.displayName;
//    bioController.text = user.bio;
//    usernameController.text = user.username;
//    setState(() {
//      _isLoading = false;
//    });
//  }

  Column buildDisplayNameField(displayNameController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              " Display Name",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: new BorderSide(color: Colors.black),
            ),
            hintText: "Update Display Name",
            errorText: _displayNameValid ? null : "Display Name too short",
          ),
        )
      ],
    );
  }

  Column buildAddressield(AdressController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              " Delivery Address",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: AdressController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: new BorderSide(color: Colors.black),
            ),
            hintText: "Update Address",
            errorText: _usernameValid ? null : "User Address too long/Short",
          ),
        )
      ],
    );
  }

  Column buildCityield(AdressController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              " City",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: AdressController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: new BorderSide(color: Colors.black),
            ),
            hintText: "Update City Name",
            errorText: _adressValid ? null : "City Name too short/Long",
          ),
        )
      ],
    );
  }

  Column buildZipcodesield(zipController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              " City Zip Code",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: zipController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: new BorderSide(color: Colors.black),
            ),
            hintText: "Update Zip code",
            errorText: _zipcodeValid ? null : "ZipCode too long/Short",
          ),
        )
      ],
    );
  }

  Column buildcountrysield(countryController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              " Country",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: countryController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: new BorderSide(color: Colors.black),
            ),
            hintText: "Update Country Name",
            errorText: _countryValid ? null : "Country Name too long/short",
          ),
        )
      ],
    );
  }

  Column buildmobilesield(mobileController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              " Mobile Number",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: mobileController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: new BorderSide(color: Colors.black),
            ),
            hintText: "Update Mobile Number",
            errorText:
                _mobileValid ? null : "User Mobile Number too long/short",
          ),
        )
      ],
    );
  }

//  updateProfileData() async {
//    setState(() {
//      _isLoading = true;
//    });
//    setState(() {
//      displayNameController.text.trim().length < 3 ||
//              displayNameController.text.isEmpty
//          ? _displayNameValid = false
//          : _displayNameValid = true;
//
//      usernameController.text.trim().length < 3 ||
//              usernameController.text.isEmpty
//          ? _usernameValid = false
//          : _usernameValid = true;
//
//      bioController.text.trim().length > 100
//          ? _bioValid = false
//          : _bioValid = true;
//    });
//    String mediaUrl;
//    _file != null ? mediaUrl = await uploadImage(_file) : Text("");
//
//    if (_displayNameValid && _bioValid && _usernameValid && mediaUrl == null) {
//      await usersRef.document(widget.currentUserId).updateData({
//        "displayName": displayNameController.text,
//        "bio": bioController.text,
//        "username": usernameController.text,
//      });
//
//      SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
//      _scaffoldKey.currentState.showSnackBar(snackbar);
//    } else if (_displayNameValid && _bioValid && _usernameValid) {
//      await usersRef.document(widget.currentUserId).updateData({
//        "displayName": displayNameController.text,
//        "bio": bioController.text,
//        "username": usernameController.text,
//        "photoUrl": mediaUrl,
//      });
//      SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
//      _scaffoldKey.currentState.showSnackBar(snackbar);
//    }
//    setState(() {
//      _isLoading = false;
//    });
//  }

  Row buildimagefield() {
    return Row(children: <Widget>[
      RaisedButton(
        onPressed: _handleChooseFromGallery,
        child: Text("Upload Profile Pic"),
      ),
      SizedBox(
        width: 10,
      ),
      Expanded(
          child: _file == null
              ? Container(
                  color: Colors.grey,
                  child: Center(child: Text("Upload picture")),
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.8,
                  //decoration: BoxDecoration(image: DecorationImage(image: FileImage(file))),
                )
              : Container(
                  //color: Colors.red,
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: FileImage(_file))),
                )),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
//    user.name.text = user.userModel.name;
//    user.email.text = user.userModel.email;
//    user.mobile.text = user.userModel.mobile;
//    user.country.text = user.userModel.country;
//    user.city.text = user.userModel.city;
//
//    user.zipcode.text = user.userModel.zipcode;
//    user.adress.text = user.userModel.address;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff27BED1),
        title: Text(
          "Profile Settings",
          style: TextStyle(color: Colors.white, fontFamily: "OpenSans"),
        ),
      ),
      body: _isLoading
          ? Loading()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        child: CircleAvatar(
                            backgroundColor: Color(0xff27BED1),
                            radius: 50.0,
                            backgroundImage: user.userModel.image != null
                                ? NetworkImage(user.userModel.image)
                                : NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/groceryapp-8164c.appspot.com/o/post_f8d3d859-181f-4c83-a9bc-d8c712690344.jpg?alt=media&token=efd779b1-e3eb-4e2f-9278-410c1d6a9a93")),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            buildDisplayNameField(name),
                            buildAddressield(adress),
                            buildCityield(city),
                            buildZipcodesield(zipcode),
                            buildcountrysield(country),
                            buildmobilesield(mobile),
                            //buildBioField(),
                            SizedBox(
                              height: 10,
                            ),
                            buildimagefield(),
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;

                            name.text.trim().length > 15 ||
                                    name.text.trim().length < 8
                                ? _displayNameValid = false
                                : _displayNameValid = true;

                            adress.text.trim().length > 100 ||
                                    adress.text.trim().length < 15
                                ? _adressValid = false
                                : _adressValid = true;
                            city.text.trim().length > 10
                                ? _cityValid = false
                                : _cityValid = true;
                            zipcode.text.trim().length > 10 ||
                                    zipcode.text.trim().length < 3
                                ? _zipcodeValid = false
                                : _zipcodeValid = true;
                            country.text.trim().length > 15 ||
                                    country.text.trim().length < 4
                                ? _countryValid = false
                                : _countryValid = true;
                            mobile.text.trim().length > 15 ||
                                    mobile.text.trim().length < 8
                                ? _mobileValid = false
                                : _mobileValid = true;
                          });
                          String mediaUrl;
                          _file != null
                              ? mediaUrl = await uploadImage(_file)
                              : Text("");
                          if (_mobileValid == true &&
                              _countryValid == true &&
                              _zipcodeValid == true &&
                              _adressValid == true &&
                              _displayNameValid == true &&
                              _cityValid == true) {
                            await usersRef
                                .document(user.userModel.id)
                                .updateData({
                              "name": name.text,
                              "profilePicture": mediaUrl,
                              "mobile": mobile.text,
                              "address": adress.text,
                              "zipcode": zipcode.text,
                              "country": country.text,
                              "city": city.text,
                            });

                            //  user.editprofile(image: mediaUrl);
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text("Profile Edited")));
                          } else if (_mobileValid == true &&
                              _countryValid == true &&
                              _zipcodeValid == true &&
                              _adressValid == true &&
                              _displayNameValid == true &&
                              _cityValid == true &&
                              mediaUrl == null) {
                            await usersRef
                                .document(user.userModel.id)
                                .updateData({
                              "name": name.text,
                              "mobile": mobile.text,
                              "address": adress.text,
                              "zipcode": zipcode.text,
                              "country": country.text,
                              "city": city.text,
                            });

                            //  user.editprofile(image: mediaUrl);
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text("Profile Edited")));
                          } else {
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text("Profile Not Edited")));
                          }
                          await user.reloadUserModel();
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                            fontFamily: "OpenSans",
                            color: Color(0xff27BED1),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
