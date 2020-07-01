import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/ScreenPages/ProfileEdit.dart';
import 'package:groceryapp/ScreenPages/ProfileScreen.dart';

import '../../model/helpers/screen_navigation.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final usersRef = Firestore.instance.collection('users');

  Future initialise(context, userID) async {
    if (Platform.isIOS) {
      // request permissions if we're on android
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.getToken().then((token) async {
      print("Firebase Messaging Token: $token\n");
      await usersRef
          .document(userID)
          .updateData({"androidNotificationToken": token});
    });
  }

  Future getmessages(context) {
    _fcm.configure(
      // Called when the app is in the foreground and we receive a push notification
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      // Called when the app has been closed comlpetely and it's opened
      // from the push notification.
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _serialiseAndNavigate(message, context);
      },
      // Called when the app is in the background and it's opened
      // from the push notification.
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        _serialiseAndNavigate(message, context);
      },
    );
  }

  void _serialiseAndNavigate(Map<String, dynamic> message, context) {
    var notificationData = message['data'];
    var view = notificationData['view'];

    if (view != null) {
      // Navigate to the create post view
      if (view == 'profile') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()));
      }
    }
  }
}
