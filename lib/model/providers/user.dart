import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groceryapp/model/helpers/order.dart';
import 'package:groceryapp/model/models/order.dart';
import 'package:groceryapp/model/models/products.dart';
//import 'package:food_course/scr/helpers/order.dart';
import 'package:groceryapp/model/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:groceryapp/model/helpers/user.dart';
import 'file:///C:/Users/ABCDEF/AndroidStudioProjects/groceryapp/lib/src/Widget/pushnotification.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  Firestore _firestore = Firestore.instance;
  UserServices _userServicse = UserServices();
  OrderServices _orderServices = OrderServices();
  UserModel _userModel;

//  getter
  UserModel get userModel => _userModel;
  Status get status => _status;
  FirebaseUser get user => _user;

//   public variables
  List<OrderModel> orders = [];

  final formkey = GlobalKey<FormState>();
  TextEditingController emails = TextEditingController();
  TextEditingController passwords = TextEditingController();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController adress = TextEditingController();

  TextEditingController city = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController zipcode = TextEditingController();
  TextEditingController country = TextEditingController();

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }

  Future<bool> signIn(context) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      await PushNotificationService().initialise(context, userModel.id);

      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp(context) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(
              email: emails.text.trim(), password: passwords.text.trim())
          .then((result) {
        _firestore.collection('users').document(result.user.uid).setData({
          'name': name.text,
          'email': email.text,
          'uid': result.user.uid,
        });
      });
      await PushNotificationService().initialise(context, userModel.id);

      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController() {
    name.text = "";
    password.text = "";
    email.text = "";
  }

  Future<void> editprofile({String image}) async {
    await _firestore.collection('users').document(user.uid).updateData({
      "name": name.text,
      "profilePicture": image,
      "mobile": mobile.text,
      "address": adress.text,
      "zipcode": zipcode.text,
      "country": country.text,
      "city": city.text,
    });

    notifyListeners();
  }

  Future<void> reloadUserModel() async {
    _userModel = await _userServicse.getUserById(user.uid);
    notifyListeners();
  }

  Future<void> _onStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      _userModel = await _userServicse.getUserById(user.uid);
    }
    notifyListeners();
  }

  Future<bool> addToCard({ProductModel product, int quantity}) async {
    print("THE PRODUC IS: ${product.toString()}");
    print("THE qty IS: ${quantity.toString()}");

    try {
      var uuid = Uuid();
      String cartItemId = uuid.v4();
      List cart = _userModel.cart;
//      bool itemExists = false;
      Map cartItem = {
        // "id": cartItemId,
        "name": product.name,
        "image": product.image,
        "productId": product.id,
        "price": product.price,
        "quantity": quantity
      };

//      for(Map item in cart){
//        if(item["productId"] == cartItem["productId"]){
////          call increment quantity
//          itemExists = true;
//          break;
//        }
//      }

//      if(!itemExists){
      print("CART ITEMS ARE: ${cart.toString()}");
      _userServicse.addToCart(userId: _user.uid, cartItem: cartItem);
//      }

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  getOrders() async {
    orders = await _orderServices.getUserOrders(userId: _user.uid);
    notifyListeners();
  }

  Future<bool> removeFromCart({Map cartItem}) async {
    print("THE PRODUC IS: ${cartItem.toString()}");

    try {
      _userServicse.removeFromCart(userId: _user.uid, cartItem: cartItem);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  ///******************wishlist**************////////////

  Future<bool> addToCwishlist({ProductModel product}) async {
    print("THE PRODUC IS: ${product.toString()}");
    //print("THE qty IS: ${quantity.toString()}");

    try {
      List wish = _userModel.wish;
//      bool itemExists = false;
      Map wishitem = {
        // "id": cartItemId,
        "name": product.name,
        "image": product.image,
        "productId": product.id,
        "price": product.price,
        // "quantity": quantity
      };

      _userServicse.addTowishlist(userId: _user.uid, wisitem: wishitem);

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromwishlist({Map wishitem}) async {
    print("THE PRODUC IS: ${wishitem.toString()}");

    try {
      _userServicse.removeFromwishlist(userId: _user.uid, wisitem: wishitem);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }
}
